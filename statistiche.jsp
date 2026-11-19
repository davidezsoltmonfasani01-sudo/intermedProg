<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<sql:query var="n_visite_tot">
    SELECT count(*) AS totale
    FROM Visite v
    INNER JOIN Stati s ON v.ID_stato = s.ID_stato
    WHERE s.stato != 'cancellata'
</sql:query>
<c:set var="n_visite_tot" value="${n_visite_tot.rows[0].totale}" />

<sql:query var="n_pag_completate">
    SELECT count(*) AS totale
    FROM Pagine_Diario p
    INNER JOIN Stati s ON p.ID_stato = p.ID_stato
    WHERE s.stato = 'completata'
</sql:query>
<c:set var="n_pag_completate" value="${n_pag_completate.rows[0].totale}" />

<sql:query var="n_Annotazioni_kc">
    SELECT count(*) AS totale
    FROM Annotazioni_Diario a
    INNER JOIN Utenti u ON u.ID = a.ID_Scrittore
    WHERE u.Ruolo ='KC'
</sql:query>
<c:set var="n_Annotazioni_kc" value="${n_Annotazioni_kc.rows[0].totale}" />

<sql:query var="n_Annotazioni_pz">
    SELECT count(*) AS totale
    FROM Annotazioni_Diario a
    INNER JOIN Utenti u ON u.ID = a.ID_Scrittore
    WHERE u.Ruolo = 'PZ'
</sql:query>
<c:set var="n_Annotazioni_pz" value="${n_Annotazioni_pz.rows[0].totale}" />

<sql:query var="n_utenti">
    SELECT
    COUNT(*) AS totale
    FROM Utenti
</sql:query>
<c:set var="n_utenti" value="${n_utenti.rows[0].totale}" />
<sql:query var="n_utenti_attivati">
    SELECT
    COUNT(*) AS totale
    FROM Utenti
    WHERE ID_stato=2
</sql:query>
<c:set var="n_utenti_attivati" value="${n_utenti_attivati.rows[0].totale}" />
<sql:query var="n_utenti_attesa">
    SELECT
    COUNT(*) AS totale
    FROM Utenti
    WHERE Ruolo = 'PZ'
    AND ID_stato = 1
</sql:query>
<c:set var="n_utenti_attesa" value="${n_utenti_attesa.rows[0].totale}" />



<!--Pagina dedicata alla Direzione Sanitaria (DS) per il monitoraggio dell'utilizzo della piattaforma,
suddivisa tra dati globali e metriche per singolo utente: permette di visualizzare il numero totale di
visite effttuate (e il parziale per ciascun Medico Nutrizionista), il totale delle pagine del Diario
Alimentare compilate (con il dettaglio per singolo Paziente), il numero totale di annotazioni inserite
(suddivise anche per singolo Kitchen Coach) e lo storico completo delle operazioni di sostituzione dei
Kitchen Coach con le relative motivazioni addotte dai pazienti-->
<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_nouser.jspf" %>

<tr valign="top">
    <td align="center">

        <table>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td class="card">

                                <fieldset>
                                    <legend><b><span style="color:#2e6f65;">Utenti</span></b></legend>
                                    <p>totale: ${n_utenti}</p>
                                    <p>Attivati: ${n_utenti_attivati}</p>
                                    <p>In attesa: ${n_utenti_attesa}</p>
                                </fieldset>
                            </td>
                            <td class="card">
                                <h2>
                                    Totale Pagine diario completate
                                </h2>
                                <p>${n_pag_completate}</p>
                            </td>
                            <td class="card">
                                <h2>
                                    Totale Annotazioni Scritte dai KC
                                </h2>
                                <p>${n_Annotazioni_kc}</p>
                            </td>

                            <td class="card">
                                <h2>
                                    Totale Annotazioni Scritte dai Pazienti
                                </h2>
                                <p>${n_Annotazioni_pz}</p>
                            </td>
                        </tr>
                        <tr>
                            <td class="card">
                                <h2>
                                    Totale Visite
                                </h2>
                                <p>${n_visite_tot}</p>

                            </td>
                            <td class="card">
                                <h2>
                                    Totale Pagine diario completate
                                </h2>
                                <p>${n_pag_completate}</p>
                            </td>
                            <td class="card">
                                <h2>
                                    Totale Annotazioni Scritte dai KC
                                </h2>
                                <p>${n_Annotazioni_kc}</p>
                            </td>

                            <td class="card">
                                <h2>
                                    Totale Annotazioni Scritte dai Pazienti
                                </h2>
                                <p>${n_Annotazioni_pz}</p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>
