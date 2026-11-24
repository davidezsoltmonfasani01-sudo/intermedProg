<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>
<c:if test="${empty user}">
    <jsp:forward page="login.jsp"/>
</c:if>





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

<c:set var="tab" value="${empty param.tab ? 'mn' : param.tab}" />

<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_ds.jspf" %>




<tr valign="top">
    <td align="center">
        <h1>Cruscotto Statistiche - Direzione Sanitaria</h1>
        <table cellspacing="10">
            <tr>
                <td class="card card-compact">
                    <h3>Utenti Totali</h3>
                    <p><strong>${n_utenti}</strong></p>
                    <small>Attivi: ${n_utenti_attivati} | In attesa: ${n_utenti_attesa}</small>
                </td>
                <td class="card card-compact">
                    <h3>Visite Effettuate</h3>
                    <p><strong>${n_visite_tot}</strong></p>
                </td>
                <td class="card card-compact">
                    <h3>Pagine Diario</h3>
                    <p><strong>${n_pag_completate}</strong></p>
                </td>
                <td class="card card-compact">
                    <h3>Annotazioni</h3>
                    <p><strong>${n_Annotazioni_kc + n_Annotazioni_pz}</strong></p>
                    <small>KC: ${n_Annotazioni_kc} | PZ: ${n_Annotazioni_pz}</small>
                </td>
                <td class="card card-compact">
                    <h3>Sostituzioni KC</h3>
                    <p><strong>${Sostituzioni_KC}</strong></p>
                </td>
            </tr>
        </table>
        <br>
        <div>
            <a href="?tab=mn"
            class="tab-btn ${tab == 'mn' ? 'attiva' : ''}">Medici
            Nutrizionisti (MN)</a>
            <a href="?tab=kc"
            class="tab-btn ${tab == 'kc' ? 'attiva' : ''}">Kitchen Coach
            (KC)</a>
            <a href="?tab=pz"
            class="tab-btn ${tab == 'pz' ? 'attiva' : ''}">Pazienti (PZ)</a>

        </div>
        <br>

        <%--CONTENUTO DINAMICO PER RUOLO E DETTAGLIO UTENTE--%>

        <c:choose>
            <%-- TAB 1: MEDICI NUTRIZIONISTI --%>
            <c:when test="${tab == 'mn'}">
                <sql:query var="q_riepilogo_mn">
                    SELECT COUNT(DISTINCT u.ID) AS tot_mn,
                    COUNT(DISTINCT CASE WHEN u.ID_stato = 2 THEN u.ID END) AS attivi_mn,
                    COUNT(DISTINCT pr.ID_prenotazione) AS tot_pren,
                    COUNT(DISTINCT CASE WHEN pr.ID_stato = 4 THEN pr.ID_prenotazione END) AS pren_attive,
                    COUNT(DISTINCT v.ID_visita ) AS tot_visite,
                    COUNT(DISTINCT CASE WHEN v.ID_stato = 8 THEN v.ID_visita END) AS visite_ref
                    FROM Utenti u
                    LEFT JOIN Prenotazioni pr ON u.ID = pr.ID_mn
                    LEFT JOIN Visite v ON pr.ID_prenotazione =
                    v.ID_prenotazione
                    WHERE u.Ruolo = 'MN'
                </sql:query>
                <c:set var="q_riepilogo_mn"
                value="${q_riepilogo_mn.rows[0]}" />
                <sql:query var="q_dettaglio_mn">
                    SELECT u.ID, u.Nome, u.Cognome, s.stato,
                    COUNT(DISTINCT pr.ID_prenotazione) AS  tot_pren,
                    COUNT(DISTINCT CASE WHEN pr.ID_stato = 4 THEN
                    pr.ID_prenotazione END) AS pren_attive,
                    COUNT(DISTINCT v.ID_visita) AS tot_visite,
                    COUNT(DISTINCT CASE WHEN v.ID_stato = 8 THEN
                    v.ID_visita END) AS visite_ref
                    FROM Utenti u
                    INNER JOIN Stati s ON u.ID_stato = s.ID_stato
                    LEFT JOIN Prenotazioni pr ON u.ID = pr.ID_mn
                    LEFT JOIN Visite v ON pr.ID_prenotazione =v.ID_prenotazione
                    WHERE u.Ruolo = 'MN'
                    GROUP BY u.ID, u.Nome, u.Cognome, s.stato
                    ORDER BY tot_visite DESC
                </sql:query>
                <h2>Statistiche Medici Nutrizionisti </h2>
                <b>MN Registrati:</b><small> Totali: ${q_riepilogo_mn.tot_mn} / Attivi: ${q_riepilogo_mn.attivi_mn}</small>
                <b>Prenotazioni</b> <small>Totali: ${q_riepilogo_mn.tot_pren} / Attive: ${q_riepilogo_mn.pren_attive}</small>
                &nbsp;|&nbsp;
                <b>Visite </b> <small>Totali: ${q_riepilogo_mn.tot_visite} / Refertate: ${q_riepilogo_mn.visite_ref}</small>
                <br>

                <h3>Dettaglio per Singolo Medico Nutrizionista</h3>
                <div class="scrollable-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Medico Nutrizionista</th>
                                <th>Stato Account</th>
                                <th class="text-center">Prenotazioni</th>
                                <th class="text-center">Visite</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mn" items="${q_dettaglio_mn.rows}">
                                <tr>
                                    <td><b>${mn.cognome} ${mn.nome}</b></td>
                                    <td>${mn.stato}</td>
                                    <td class="text-center">
                                        <small>Totali: ${mn.tot_pren} / Attive: ${mn.pren_attive}</small>
                                    </td>
                                    <td class="text-center">
                                        <small>Totali: ${mn.tot_visite} / Refertate: ${mn.visite_ref}</small>
                                    </td>
                                    <td class="text-center">
                                        <a href="info_utente.jsp?id_utente=${mn.ID}">
                                            <img src="GoTo.svg" alt="Vai" class="img-btn">
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </c:when>
            <%-- TAB 2: KITCHEN COACH --%>
            <c:when test="${tab == 'kc'}">
                <sql:query var="q_riepilogo_kc">
                    SELECT
                    COUNT(DISTINCT u.ID) AS tot_kc,
                    COUNT(DISTINCT CASE WHEN u.ID_stato = 2 THEN u.ID END) AS attivi_kc,
                    COUNT(DISTINCT a.ID_annotazione) AS num_annotazioni,
                    COUNT(DISTINCT assoc.ID_PZ) AS Pz_seguiti,
                    COUNT(DISTINCT CASE WHEN assoc.ID_stato = 2 THEN assoc.ID_PZ END) AS assoc_attive
                    FROM Utenti u
                    LEFT JOIN Associazioni_KC_PZ assoc ON u.ID = assoc.ID_KC
                    LEFT JOIN Annotazioni_Diario a ON u.ID = a.ID_Scrittore
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
                <c:set var="q_riepilogo_kc"
                value="${q_riepilogo_kc.rows[0]}" />
                <h2>Statistiche Kitchen Coach</h2>
                <b>KC Registrati:</b><small> Totali: ${q_riepilogo_kc.tot_kc} / Attivi: ${q_riepilogo_kc.attivi_kc}</small>
                &nbsp;|&nbsp;
                <b>Pazienti seguiti:</b> <small>Totali: ${q_riepilogo_kc.Pz_seguiti} / Attive: ${q_riepilogo_kc.assoc_attive}</small>
                &nbsp;|&nbsp;
                <b>Annotazioni inserite: </b> <small>${q_riepilogo_kc.num_annotazioni}</small>
                <br>
                <h3>Dettaglio per
                    Singolo Kitchen Coach</h3>
                    <div class="scrollable-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Kitchen Coach</th>
                                    <th>Stato Account</th>
                                    <th class="text-center">Associazioni con Pazienti</th>
                                    <th class="text-center">Annotazioni Inserite</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="kc" items="${q_dettaglio_kc.rows}">
                                    <tr>
                                        <td><b>${kc.Cognome} ${kc.Nome}</b></td>
                                        <td>${kc.stato}</td>
                                        <td class="text-center">
                                            <small>Totali: ${kc.Pz_seguiti} | Attive: ${kc.assoc_attive}</small>
                                        </td>
                                        <td class="text-center">
                                            ${kc.num_annotazioni}
                                        </td>
                                        <td class="text-center">
                                            <a href="info_utente.jsp?id_utente=${kc.ID}">
                                                <img src="GoTo.svg" alt="Vai" class="img-btn">
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <%--TAB 3: PAZIENTI--%>
                <c:when test="${tab == 'pz'}">
                    <sql:query var="q_riepilogo_pz">
                        SELECT
                        COUNT(DISTINCT u.ID) AS tot_pz,
                        COUNT(DISTINCT CASE WHEN u.ID_stato = 2 THEN u.ID END) AS attivi_pz,
                        COUNT(DISTINCT CASE WHEN u.ID_stato = 1 THEN u.ID END) AS attesa_pz,
                        COUNT(DISTINCT a.ID_annotazione) AS num_annotazioni,
                        COUNT(DISTINCT pr.ID_prenotazione) AS tot_pren,
                        COUNT(DISTINCT CASE WHEN pr.ID_stato = 4 THEN pr.ID_prenotazione END) AS pren_attive,
                        COUNT(DISTINCT v.ID_visita ) AS tot_visite,
                        COUNT(DISTINCT p.ID_pagina) AS pagine_compilate
                        FROM Utenti u
                        LEFT JOIN Associazioni_KC_PZ assoc ON u.ID = assoc.ID_PZ
                        LEFT JOIN Annotazioni_Diario a ON u.ID = a.ID_Scrittore
                        LEFT JOIN Prenotazioni pr ON u.ID = pr.ID_pz
                        LEFT JOIN Visite v ON pr.ID_prenotazione =  v.ID_prenotazione
                        LEFT JOIN Pagine_Diario p ON u.ID = p.ID_PZ AND p.ID_stato = (SELECT ID_stato FROM Stati WHERE stato = 'completata')
                        WHERE u.Ruolo = 'PZ'
                    </sql:query>
                    <c:set var="q_riepilogo_pz"
                    value="${q_riepilogo_pz.rows[0]}" />
                    <sql:query var="q_dettaglio_pz">
                        SELECT u.ID, u.Nome, u.Cognome, s.stato,
                        COUNT(DISTINCT p.ID_pagina) AS pagine_compilate,
                        COUNT(DISTINCT a.ID_annotazione) AS annotazioni_scritte,
                        COUNT(DISTINCT pr.ID_prenotazione) AS tot_pren,
                        COUNT(DISTINCT CASE WHEN pr.ID_stato = 4 THEN pr.ID_prenotazione END) AS pren_attive,
                        COUNT(DISTINCT v.ID_visita) AS tot_visite
                        FROM Utenti u
                        INNER JOIN Stati s ON u.ID_stato = s.ID_stato
                        LEFT JOIN Pagine_Diario p ON u.ID = p.ID_PZ
                        AND p.ID_stato = (SELECT ID_stato FROM Stati WHERE stato = 'completata' LIMIT 1)
                        LEFT JOIN Annotazioni_Diario a ON u.ID = a.ID_Scrittore
                        LEFT JOIN Prenotazioni pr ON u.ID = pr.ID_pz
                        LEFT JOIN Visite v ON pr.ID_prenotazione =  v.ID_prenotazione
                        WHERE u.Ruolo = 'PZ'
                        GROUP BY u.ID, u.Nome, u.Cognome, s.stato
                        ORDER BY pagine_compilate DESC
                    </sql:query>
                    <h2>Statistiche Pazienti </h2>
                    <b>PZ Registrati</b> <small>Totali: ${q_riepilogo_pz.tot_pz} / Attivi: ${q_riepilogo_pz.attivi_pz} / In Attesa: ${q_riepilogo_pz.attesa_pz}</small> &nbsp;|&nbsp;
                    <b>Annotazioni inserite: </b><small>${q_riepilogo_pz.num_annotazioni}</small>&nbsp;|&nbsp;
                    <b>Pagine Completate: </b> <small>${q_riepilogo_pz.pagine_compilate}</small>&nbsp;|&nbsp;
                    <b>Prenotazioni</b> <small>Totali: ${q_riepilogo_pz.tot_pren} / Attive: ${q_riepilogo_pz.pren_attive}</small>
                    &nbsp;|&nbsp;
                    <b>Visite </b> <small>Totali: ${q_riepilogo_pz.tot_visite}</small>
                    <br>
                    <h3>Dettaglio per Singolo Paziente</h3>
                    <div class="scrollable-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Paziente</th>
                                    <th>Stato Account</th>
                                    <th class="text-center">Pagine Diario Compilate</th>
                                    <th class="text-center">Annotazioni inserite</th>
                                    <th class="text-center">Prenotazioni</th>
                                    <th class="text-center">Visite</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pz" items="${q_dettaglio_pz.rows}">
                                    <tr>
                                        <td><b>${pz.Cognome} ${pz.Nome}</b></td>
                                        <td>${pz.stato}</td>
                                        <td class="text-center">${pz.pagine_compilate}</td>
                                        <td class="text-center">${pz.annotazioni_scritte}</td>
                                        <td class="text-center">
                                            <small>Totali: ${pz.tot_pren} | Attive: ${pz.pren_attive}</small>
                                        </td>
                                        <td class="text-center">${pz.tot_visite}</td>
                                        <td class="text-center">
                                            <a href="info_utente.jsp?id_utente=${pz.ID}">
                                                <img src="GoTo.svg" alt="Vai" class="img-btn">
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </c:when>
            </c:choose>
            <br>
        </td>
    </tr>
    <%@ include file="layout_bottom.jspf" %>
