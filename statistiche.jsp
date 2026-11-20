<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>


<%--QUERY GLOBALI FISSE--%>


<sql:query var="q_visite_tot">
    SELECT COUNT(*) AS totale
    FROM Visite v
    INNER JOIN Stati s ON v.ID_stato = s.ID_stato
    WHERE s.stato != 'cancellata'
</sql:query>
<c:set var="n_visite_tot" value="${q_visite_tot.rows[0].totale}" />

<sql:query var="q_pag_completate">
    SELECT COUNT(*) AS totale
    FROM Pagine_Diario p
    INNER JOIN Stati s ON p.ID_stato = s.ID_stato
    WHERE s.stato = 'completata'
</sql:query>
<c:set var="n_pag_completate" value="${q_pag_completate.rows[0].totale}" />

<sql:query var="q_ann_kc">
    SELECT COUNT(*) AS totale
    FROM Annotazioni_Diario a
    INNER JOIN Utenti u ON u.ID = a.ID_Scrittore
    WHERE u.Ruolo = 'KC'
</sql:query>
<c:set var="n_Annotazioni_kc" value="${q_ann_kc.rows[0].totale}" />

<sql:query var="q_ann_pz">
    SELECT COUNT(*) AS totale
    FROM Annotazioni_Diario a
    INNER JOIN Utenti u ON u.ID = a.ID_Scrittore
    WHERE u.Ruolo = 'PZ'
</sql:query>
<c:set var="n_Annotazioni_pz" value="${q_ann_pz.rows[0].totale}" />

<sql:query var="q_sostituzioni">
    SELECT COUNT(*) AS totale
    FROM Associazioni_KC_PZ a
    WHERE Data_fine IS NOT NULL
    AND ID_stato = 9
    AND Motivazione IS NOT NULL
</sql:query>
<c:set var="Sostituzioni_KC" value="${q_sostituzioni.rows[0].totale}" />

<sql:query var="q_utenti">
    SELECT COUNT(*) AS totale FROM Utenti
</sql:query>
<c:set var="n_utenti" value="${q_utenti.rows[0].totale}" />

<sql:query var="q_utenti_attivati">
    SELECT COUNT(*) AS totale FROM Utenti WHERE ID_stato = 2
</sql:query>
<c:set var="n_utenti_attivati" value="${q_utenti_attivati.rows[0].totale}" />

<sql:query var="q_utenti_attesa">
    SELECT COUNT(*) AS totale FROM Utenti WHERE Ruolo = 'PZ' AND ID_stato = 1
</sql:query>
<c:set var="n_utenti_attesa" value="${q_utenti_attesa.rows[0].totale}" />

<%-- Gestione parametro TAB (default: 'mn') --%>
<c:set var="tab" value="${empty param.tab ? 'mn' : param.tab}" />

<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_ds.jspf" %>

<tr valign="top">
    <td align="center">

        <h1>Cruscotto Statistiche - Direzione Sanitaria</h1>


        <table>
            <tr>
                <td class="card">
                    <h3>Utenti Totali</h3>
                    <p><strong>${n_utenti}</strong></p>
                    <small>Attivi: ${n_utenti_attivati} | In attesa: ${n_utenti_attesa}</small>
                </td>
                <td class="card">
                    <h3>Visite Effettuate</h3>
                    <p><strong>${n_visite_tot}</strong></p>
                </td>
                <td class="card">
                    <h3>Pagine Diario</h3>
                    <p><strong>${n_pag_completate}</strong></p>
                </td>
                <td class="card">
                    <h3>Annotazioni</h3>
                    <p><strong>${n_Annotazioni_kc + n_Annotazioni_pz}</strong></p>
                    <small>KC: ${n_Annotazioni_kc} | PZ: ${n_Annotazioni_pz}</small>
                </td>
                <td class="card">
                    <h3>Sostituzioni KC</h3>
                    <p><strong>${Sostituzioni_KC}</strong></p>
                </td>
            </tr>
        </table>

        <hr />


        <div class="tabs-nav">
            <a href="?tab=mn"><strong>[ Medici Nutrizionisti (MN) ]</strong></a> |
            <a href="?tab=kc"><strong>[ Kitchen Coach (KC) ]</strong></a> |
            <a href="?tab=pz"><strong>[ Pazienti (PZ) ]</strong></a> |
            <a href="?tab=storico"><strong>[ Storico Sostituzioni KC ]</strong></a>
        </div>

        <br />


        <%--CONTENUTO DINAMICO PER RUOLO E DETTAGLIO UTENTE--%>

        <c:choose>

            <%-- TAB 1: MEDICI NUTRIZIONISTI --%>
            <c:when test="${tab == 'mn'}">
                <sql:query var="tot_mn">
                    SELECT
                    COUNT(*) AS tot_mn,
                    SUM(CASE WHEN ID_stato = 2 THEN 1 ELSE 0 END) AS attivi_mn
                    FROM Utenti WHERE Ruolo = 'MN'
                </sql:query>
                <c:set var="tot_mn" value="${tot_mn.rows[0].tot_mn}"/>

                <sql:query var="attivi_mn">
                    SELECT COUNT(*) AS attivi_mn
                    FROM Utenti
                    WHERE Ruolo = 'MN'
                    and  ID_stato = 2
                </sql:query>

                <c:set var="attivi_mn" value="${attivi_mn.rows[0].attivi_mn}"/>


                <sql:query var="q_dettaglio_mn">
                    SELECT u.ID ,
                    u.Nome ,
                    u.Cognome ,
                    s.stato,

                    COUNT(DISTINCT pr.ID_prenotazione) AS tot_prenotazioni,
                    COUNT(DISTINCT CASE WHEN pr.ID_stato = 4 THEN pr.ID_prenotazione END) AS prenotazioni_attive,

                    COUNT(DISTINCT v.ID_visita) AS tot_visite,
                    COUNT(DISTINCT CASE WHEN v.ID_stato = 8 THEN v.ID_visita END) AS visite_refertate

                    FROM Utenti u
                    INNER JOIN Stati s ON u.ID_stato = s.ID_stato
                    LEFT JOIN Prenotazioni pr ON u.ID = pr.ID_mn
                    LEFT JOIN Visite v ON pr.ID_prenotazione = v.ID_prenotazione
                    WHERE u.Ruolo = 'MN'
                    GROUP BY u.ID, u.Nome, u.Cognome, s.stato
                    ORDER BY tot_visite DESC
                </sql:query>



                <h2>Statistiche Medici Nutrizionisti (MN)</h2>
                <p>
                    Totale MN registrati: <strong>${tot_mn}</strong> |
                    Attivi: <strong>${attivi_mn}</strong> |
                    Visite totali erogate: <strong>${n_visite_tot}</strong>
                </p>
                <table border="1" cellpadding="6" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Medico Nutrizionista</th>
                            <th>Stato Account</th>
                            <th>Prenotazioni</th>
                            <th>Visite Effettuate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="mn" items="${q_dettaglio_mn.rows}">
                            <tr>
                                <td>${mn.cognome} ${mn.nome}</td>
                                <td>${mn.stato}</td>
                                <td align="center">
                                    <small>Totali: ${mn.tot_prenotazioni} | Attive: ${mn.prenotazioni_attive}</small>
                                </td>
                                <td align="center">
                                    <small>Totali: ${mn.tot_visite} | Refertate: ${mn.visite_refertate}</small>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

            </c:when>

            <%-- TAB 2: KITCHEN COACH  --%>
            <c:when test="${tab == 'kc'}">
                <sql:query var="q_riepilogo_kc">
                    SELECT
                    COUNT(DISTINCT u.ID) AS tot_kc,
                    COUNT(DISTINCT CASE WHEN u.ID_stato = 2 THEN u.ID END) AS attivi_kc,
                    COUNT(DISTINCT assoc.ID_PZ) AS Pz_seguiti,
                    COUNT(DISTINCT CASE WHEN assoc.ID_stato = 2 THEN assoc.ID_PZ END) AS assoc_attive
                    FROM Utenti u
                    LEFT JOIN Associazioni_KC_PZ assoc ON u.ID = assoc.ID_KC
                    WHERE u.Ruolo = 'KC'

                </sql:query>

                <sql:query var="q_dettaglio_kc">
                    SELECT u.ID, u.Nome, u.Cognome, s.stato,
                    COUNT(DISTINCT a.ID_annotazione) AS num_annotazioni,
                    COUNT(DISTINCT assoc.ID_PZ) AS Pz_seguiti,
                    COUNT(DISTINCT CASE WHEN assoc.ID_stato = 2 THEN assoc.ID_PZ END ) AS assoc_attive
                    FROM Utenti u
                    INNER JOIN Stati s ON u.ID_stato = s.ID_stato
                    LEFT JOIN Annotazioni_Diario a ON u.ID = a.ID_Scrittore
                    LEFT JOIN Associazioni_KC_PZ assoc ON u.ID = assoc.ID_KC
                    WHERE u.Ruolo = 'KC'
                    GROUP BY u.ID, u.Nome, u.Cognome, s.stato
                    ORDER BY num_annotazioni DESC
                </sql:query>
                <c:set var="q_riepilogo_kc" value="${q_riepilogo_kc.rows[0]}"/>
                <h2>Statistiche Kitchen Coach (KC)</h2>
                <p>
                    Totale KC registrati: <strong>${q_riepilogo_kc.tot_kc}</strong> |
                    Attivi: <strong>${q_riepilogo_kc.attivi_kc}</strong> |
                    Pazienti seguiti: <small>Totali: ${q_riepilogo_kc.Pz_seguiti} | Attive: ${q_riepilogo_kc.assoc_attive}</small>|
                    Annotazioni totali inserite dai KC: <strong>${q_riepilogo_kc.num_annotazioni}</strong>
                </p>

                <table border="1" cellpadding="6" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Kitchen Coach</th>
                            <th>Stato Account</th>
                            <th>Associazioni con Pazienti </th>
                            <th>Annotazioni Inserite</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="kc" items="${q_dettaglio_kc.rows}">
                            <tr>
                                <td>${kc.Cognome} ${kc.Nome}</td>
                                <td>${kc.stato}</td>
                                <td align="center">
                                    <small>Totali: ${kc.Pz_seguiti} | Attive: ${kc.assoc_attive}</small>
                                </td>
                                <td align="center"><strong>${kc.num_annotazioni}</strong></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>

            <%-- ================= TAB 3: PAZIENTI ================= --%>
            <c:when test="${tab == 'pz'}">
                <sql:query var="q_riepilogo_pz">
                    SELECT
                    COUNT(*) AS tot_pz,
                    SUM(CASE WHEN ID_stato = 2 THEN 1 ELSE 0 END) AS attivi_pz,
                    SUM(CASE WHEN ID_stato = 1 THEN 1 ELSE 0 END) AS attesa_pz
                    FROM Utenti WHERE Ruolo = 'PZ'
                </sql:query>

                <sql:query var="q_dettaglio_pz">
                    SELECT u.ID, u.Nome, u.Cognome, s.stato AS stato_utente,
                    COUNT(DISTINCT p.ID_pagina) AS pagine_compilate,
                    COUNT(DISTINCT a.ID_annotazione) AS annotazioni_scritte
                    FROM Utenti u
                    INNER JOIN Stati s ON u.ID_stato = s.ID_stato
                    LEFT JOIN Pagine_Diario p ON u.ID = p.ID_PZ
                    AND p.ID_stato = (SELECT ID_stato FROM Stati WHERE stato = 'completata')
                    LEFT JOIN Annotazioni_Diario a ON u.ID = a.ID_Scrittore
                    WHERE u.Ruolo = 'PZ'
                    GROUP BY u.ID, u.Nome, u.Cognome, s.stato
                    ORDER BY pagine_compilate DESC
                </sql:query>

                <h2>Statistiche Pazienti (PZ)</h2>
                <p>
                    Totale PZ: <strong>${q_riepilogo_pz.rows[0].tot_pz}</strong> |
                    Attivi: <strong>${q_riepilogo_pz.rows[0].attivi_pz}</strong> |
                    In attesa: <strong>${q_riepilogo_pz.rows[0].attesa_pz}</strong> |
                    Pagine Diario totali: <strong>${n_pag_completate}</strong>
                </p>

                <table border="1" cellpadding="6" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Paziente</th>
                            <th>Stato Account</th>
                            <th>Pagine Diario Compilate</th>
                            <th>Annotazioni Inviate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="pz" items="${q_dettaglio_pz.rows}">
                            <tr>
                                <td>${pz.Cognome} ${pz.Nome}</td>
                                <td>${pz.stato_utente}</td>
                                <td align="center"><strong>${pz.pagine_compilate}</strong></td>
                                <td align="center">${pz.annotazioni_scritte}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>

            <%-- ================= TAB 4: STORICO SOSTITUZIONI KC ================= --%>
            <c:when test="${tab == 'storico'}">
                <sql:query var="q_storico_kc">
                    SELECT pz.Nome AS pz_nome, pz.Cognome AS pz_cognome,
                    kc.Nome AS kc_nome, kc.Cognome AS kc_cognome,
                    assoc.Data_inizio, assoc.Data_fine, assoc.Motivazione
                    FROM Associazioni_KC_PZ assoc
                    INNER JOIN Utenti pz ON assoc.ID_PZ = pz.ID
                    INNER JOIN Utenti kc ON assoc.ID_KC = kc.ID
                    WHERE assoc.Data_fine IS NOT NULL
                    AND assoc.ID_stato = 9
                    AND assoc.Motivazione IS NOT NULL
                    ORDER BY assoc.Data_fine DESC
                </sql:query>

                <h2>Storico Sostituzioni Kitchen Coach</h2>
                <p>Totale operazioni di cambio KC registrate: <strong>${Sostituzioni_KC}</strong></p>

                <table border="1" cellpadding="6" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Paziente</th>
                            <th>KC Sostituito</th>
                            <th>Data Inizio</th>
                            <th>Data Sostituzione</th>
                            <th>Motivazione addotta dal Paziente</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${q_storico_kc.rows}">
                            <tr>
                                <td>${row.pz_cognome} ${row.pz_nome}</td>
                                <td>${row.kc_cognome} ${row.kc_nome}</td>
                                <td>${row.Data_inizio}</td>
                                <td>${row.Data_fine}</td>
                                <td><em>"${row.Motivazione}"</em></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>

        </c:choose>

    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>
