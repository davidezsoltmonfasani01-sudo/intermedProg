<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>

<c:choose>

    <c:when test="${empty user || (user.Ruolo != 'MN' && user.Ruolo != 'PZ')}">
        <jsp:forward page="login.jsp" />
    </c:when>

    <c:otherwise>

        <sql:query var="rset_referto">

            SELECT V.*, P.Data_visita, P.ID_pz, P.ID_mn, -V.Fabbisogno_energetico +
            V.Apporto_calorico AS Bilancio_energetico, 
            ROUND(V.Peso / POWER(NULLIF(V.Altezza, 0) / 100, 2), 1) AS BMI

            FROM Visite V, Prenotazioni P

            WHERE V.ID_prenotazione = P.ID_prenotazione
            AND P.ID_prenotazione = ?
            AND P.ID_stato = 8
            AND ((? = 'PZ' AND P.ID_pz = ?)
            OR (? = 'MN' AND P.ID_mn = ?))

            <sql:param value="${param.id_prenotazione}" />
            <sql:param value="${user.Ruolo}" />
            <sql:param value="${user.ID}" />
            <sql:param value="${user.Ruolo}" />
            <sql:param value="${user.ID}" />

        </sql:query>
        <c:set var="dati_ref" value="${rset_referto.rows[0]}" />



        <c:choose>

            <c:when test="${rset_referto.rowCount == 0}">

                <h2>Referto non disponibile</h2>

                <p>Il referto non esiste oppure non hai i permessi per visualizzarlo.</p>

            </c:when>

            <c:otherwise>

                <sql:query var="rset_pz">
                    SELECT Nome, Cognome, CF, Data_Nascita
                    FROM Utenti
                    WHERE ID = ?

                    <sql:param value="${rset_referto.rows[0].ID_pz}" />
                </sql:query>
                <c:set var="dati_pz" value="${rset_pz.rows[0]}" />
                <sql:query var="rset_mn">
                    SELECT Nome, Cognome
                    FROM Utenti
                    WHERE ID = ?

                    <sql:param value="${rset_referto.rows[0].ID_mn}" />
                </sql:query>
                <c:set var="dati_mn" value="${rset_mn.rows[0]}" />
                <tr>
                    <td colspan="2" bgcolor="#f1f5f4"
                        style="padding-top: 25px; padding-bottom: 25px; ">
                        <table width="780" align="center" border="0" cellpadding="6"
                            cellspacing="0" bgcolor="#ffffff">

                            
                            <!-- INTESTAZIONE -->
                            <tr>
                                <td align="center">
                                    <span style="font-size: 25px; color: #1f2d3d;">
                                        <b>Referto dietologico di
                                            ${dati_pz.Nome} ${dati_pz.Cognome}

                                        </b>
                                    </span>
                                    <hr color="#2c3e50" size="2">
                                </td>
                            </tr>

                            <!-- DATI DEL PAZIENTE -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;DATI DEL PAZIENTE</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="0" cellpadding="3"
                                        cellspacing="0">
                                        <tr>
                                            <td width="50%">
                                                <b>Nome e Cognome:</b>
                                                ${dati_pz.Nome} ${dati_pz.Cognome}
                                            </td>
                                            <td width="50%">
                                                <b>Data di nascita:</b>
                                                <fmt:formatDate
                                                    value="${dati_pz.Data_Nascita}"
                                                    pattern="dd/MM/yy" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>Codice Fiscale:</b>
                                                ${dati_pz.CF}
                                            </td>
                                            <td>
                                                <b>Data della visita:</b>
                                                <fmt:formatDate
                                                    value="${dati_ref.Data_visita}"
                                                    pattern="dd/MM/yy" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                            <!-- PARAMETRI ANTROPOMETRICI E COMPOSIZIONE CORPOREA -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;PARAMETRI ANTROPOMETRICI E
                                                        COMPOSIZIONE CORPOREA</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="0" cellpadding="3"
                                        cellspacing="0">
                                        <tr>
                                            <td width="50%">
                                              <b>Altezza:</b> ${dati_ref.Altezza} cm
                                            </td>
                                            <td width="50%">
                                              <b>Peso Attuale:</b> ${dati_ref.Peso} kg
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                              <b>BMI (indice di massa corporea):</b> ${dati_ref.BMI} kg/m<sup>2</sup>
                                                <c:if test="${dati_ref.BMI < 18.5}">(Sottopeso)</c:if>
                                                <c:if test="${dati_ref.BMI >= 18.5 && dati_ref.BMI < 25}">(Peso Normale)</c:if>
                                                <c:if test="${dati_ref.BMI >= 25 && dati_ref.BMI < 30}">(Sovrappeso)</c:if>
                                                <c:if test="${dati_ref.BMI >= 30}">(Obesita')</c:if>

                                            </td> 
                                            <td>
                                              <b>Circonferenza Vita:</b> ${dati_ref.Circonferenza_Vita} cm
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                            <!-- ANAMNESI CLINICA E ALIMENTARE -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;ANAMNESI CLINICA E
                                                        ALIMENTARE</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <b>Anamnesi Prossima:</b><br>
                                        ${dati_ref.Anamnesi_Prossima}<br><br>
                                        <b>Anamnesi Alimentare:</b><br>
                                        ${dati_ref.Anamnesi_Alimentare}
                                    </div>
                                </td>
                            </tr>

                            <!-- VALUTAZIONE ESAMI RECENTI -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;VALUTAZIONE DEGLI ESAMI RECENTI
                                                    </b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        ${dati_ref.Valutazione_Esami_Recenti}
                                    </div>
                                </td>
                            </tr>

                            <!-- DIAGNOSI NUTRIZIONALE E OBIETTIVI TERAPEUTICI -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;DIAGNOSI NUTRIZIONALE E
                                                        OBIETTIVI TERAPEUTICI</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>

                                    <b>Diagnosi:</b><br>
                                    ${dati_ref.Diagnosi}<br><br>
                                    <b>Obiettivi:</b><br>
                                    ${dati_ref.Obiettivi}

                                </td>
                            </tr>

                            <!-- VALUTAZIONE DEL FABBISOGNO GIORNALIERO ED ENERGETICO -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;VALUTAZIONE DEL FABBISOGNO
                                                        ENERGETICO GIORNALIERO</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="0" cellpadding="3"
                                        cellspacing="0">
                                        <tr>
                                            <td width="50%">
                                                <b>Fabbisogno Energetico Totale (TDEE):</b>
                                                ${dati_ref.Fabbisogno_energetico}
                                                kcal/giorno
                                            </td>
                                            <td width="50%">
                                                <b>Metabolismo Basale stimato (MB):</b>
                                                ${dati_ref.Metabolismo_basale}
                                                kcal/giorno
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <b>Apporto Calorico Prescritto:</b>
                                                ${dati_ref.Apporto_calorico}
                                                kcal/giorno
                                               <c:if test="${dati_ref.Bilancio_energetico < 0}">  (Deficit calorico mirato: ${dati_ref.Bilancio_energetico} kcal)</c:if>
                                              <c:if test="${dati_ref.Bilancio_energetico >= 0}">  (Surplus calorico mirato: ${dati_ref.Bilancio_energetico} kcal)</c:if>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <b>Ripartizione dei Macronutrienti Prescritta:</b>
                                        <ul>
                                            <li>
                                                <b>Carboidrati:</b> ${dati_ref.Carboidrati} g / giorno
                                            </li>
                                            <li>
                                                <b>Proteine:</b> ${dati_ref.Proteine} g / giorno
                                            </li>
                                            <li>
                                                <b>Grassi:</b> ${dati_ref.Grassi} g / giorno
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>

                            <!-- PRESCRIZIONE DIETETICA E INDICAZIONI -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;PRESCRIZIONE DIETETICA E
                                                        INDICAZIONI</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <b>Schema Alimentare:</b> ${dati_ref.Schema_Alimentare}<br><br>
                                        <b>Colazione:</b> ${dati_ref.Percentuale_Colazione} % -
                                        <b>Pranzo:</b> ${dati_ref.Percentuale_Pranzo} % -
                                        <b>Cena:</b> ${dati_ref.Percentuale_Cena} % -
                                        <b>Apporto idrico:</b> ${dati_ref.Idratazione} ml/giorno
                                        <br><br>

                                    </div>
                                </td>
                            </tr>

                            <!-- CONTROLLO -->
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="2"
                                        cellspacing="0">
                                        <tr>
                                            <td width="4" bgcolor="#176b63"></td>
                                            <td bgcolor="#ecf2ef">
                                                <span
                                                    style="font-size: 17px; color: #2c3e50;">
                                                    <b>&nbsp;COMMENTI FINALI</b>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <b>Note:</b><br>
                                        ${dati_ref.Note}<br><br>
                                    </div>
                                </td>
                            </tr>
                            <!-- FIRMA -->
                            <tr>
                                <td style="padding-top: 20px;">
                                    <hr color="#2c3e50" size="1">

                                    <p>
                                        <b>Firmato Digitalmente il
                                            <fmt:formatDate value="${dati_ref.Data_Firma}"
                                                            pattern="dd MMM yyyy"
                                                            timeZone="Europe/Rome"/>
                                        </b>
                                    </p>

                                    <p>
                                        <b>Centro Dietologico l'Ultima Cena</b><br>
                                        Dott. ${dati_mn.Nome} ${dati_mn.Cognome}
                                    </p>
                                </td>
                            </tr>
                        </table>
                        
                    </td>


                </tr>

            </c:otherwise>

        </c:choose>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>