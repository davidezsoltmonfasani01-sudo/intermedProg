<%@ page session="true" language="java" 
contentType="text/html; charset=UTF-8" import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>

<c:choose>

    <c:when test="${empty user || user.Ruolo != 'MN'}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:when test="${empty param.id_prenotazione}">
        <jsp:forward page="lista_visite.jsp"/>
    </c:when>

    <c:otherwise>

        <sql:query var="rset_prenotazione">
            SELECT ID_prenotazione, Data_visita, Nome, Cognome, CF, Data_Nascita
            FROM Prenotazioni, Utenti
            WHERE Utenti.ID=ID_pz
            AND ID_prenotazione = ?
            AND ID_mn = ?
            AND Prenotazioni.ID_stato = 7

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:query>
		<c:set var="dati_pren" value="${rset_prenotazione.rows[0]}"/>
        <sql:query var="rset_visita">
            SELECT ID_visita
            FROM Visite
            WHERE ID_prenotazione = ?

            <sql:param value="${param.id_prenotazione}"/>
        </sql:query>

        
         <c:choose>
            <c:when test="${rset_prenotazione.rowCount == 0}">
                
          <tbody>
            <tr>
                <td colspan="2" style="padding: 20px;">
                    <h3>Il referto esiste gia</h3>
                    <a href="v_referto.jsp?id_prenotazione=${param.id_prenotazione}">
                        Visualizza referto
                    </a>
                </td>
            </tr>
        </tbody>
            </c:when>

            <c:when test="${rset_visita.rowCount != 0}">
          <tbody>
            <tr>
                <td colspan="2" style="padding: 20px;"> 
              <h3>Il referto esiste gia</h3>

                <a href="v_referto.jsp?id_prenotazione=${param.id_prenotazione}">
                    Visualizza referto
                </a>
              </td>
            </tr>
        </tbody>
            </c:when>

            <c:otherwise>
          <tr>
            <td colspan="2" bgcolor="#f1f5f4" style="padding-top: 25px; padding-bottom: 25px; ">
   <form action="a_compila_referto.jsp" method="post">
  <table width="780" align="center" border="0" cellpadding="6" cellspacing="0" bgcolor="#ffffff">
    
    <input type="hidden" name="id_prenotazione" value="${param.id_prenotazione}">
    <!-- INTESTAZIONE -->
    <tr>
      <td align="center">
        <span style="font-size: 25px; color: #1f2d3d;">
          <b>Referto dietologico di
            ${dati_pren.Nome} ${dati_pren.Cognome}
            
          </b>
        </span>
        <hr color="#2c3e50" size="2">
      </td>
    </tr>

    <!-- DATI DEL PAZIENTE -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;DATI DEL PAZIENTE</b>
              </span>
            </td>
          </tr>
        </table>
        <table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr>
            <td width="50%">
              <b>Nome e Cognome:</b>
              ${dati_pren.Nome} ${dati_pren.Cognome}
            </td>
            <td width="50%">
              <b>Data di nascita:</b>
              <fmt:formatDate value="${dati_pren.Data_Nascita}" pattern="dd/MM/yy" />
            </td>
          </tr>
          <tr>
            <td>
              <b>Codice Fiscale:</b>
              ${dati_pren.CF}
            </td>
            <td>
              <b>Data della visita:</b>
              <fmt:formatDate value="${dati_pren.Data_visita}" pattern="dd/MM/yy" />
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <!-- PARAMETRI ANTROPOMETRICI E COMPOSIZIONE CORPOREA -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;PARAMETRI ANTROPOMETRICI E COMPOSIZIONE CORPOREA</b>
              </span>
            </td>
          </tr>
        </table>
        <table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr>
            <td width="50%">
              <b>Altezza:</b>
              <input type="text" name="altezza" required size="5">
              <b>cm</b>
            </td>
            <td width="50%">
              <b>Peso Attuale:</b>
              <input type="text" name="peso" required size="5">
              <b>kg</b>
            </td>
          </tr>
          <tr>
            <td>
              <span><b>Circonferenza Vita:</b></span>
              <input type="text" name="circonferenza_vita" required size="5">
              <span>cm</span>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <!-- ANAMNESI CLINICA E ALIMENTARE -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;ANAMNESI CLINICA E ALIMENTARE</b>
              </span>
            </td>
          </tr>
        </table>
        <div>
          <b>Anamnesi Prossima:</b><br>
          <textarea name="anamnesi_prossima" rows="3" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"></textarea><br><br>
          <b>Anamnesi Alimentare:</b><br>
          <textarea name="anamnesi_alimentare" rows="3" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"></textarea>
        </div>
      </td>
    </tr>

    <!-- VALUTAZIONE ESAMI RECENTI -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;VALUTAZIONE DEGLI ESAMI RECENTI </b>
              </span>
            </td>
          </tr>
        </table>
        <div>
          <textarea name="valutazione_esami_recenti" rows="2" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"></textarea>
        </div>
      </td>
    </tr>

    <!-- DIAGNOSI NUTRIZIONALE E OBIETTIVI TERAPEUTICI -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;DIAGNOSI NUTRIZIONALE E OBIETTIVI TERAPEUTICI</b>
              </span>
            </td>
          </tr>
        </table>
        
          <b>Diagnosi:</b><br>
          <textarea name="diagnosi" rows="2" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; "></textarea><br><br>
          <b>Obiettivi:</b><br>
          <textarea name="obiettivi" rows="2" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; "></textarea>
    
      </td>
    </tr>

    <!-- VALUTAZIONE DEL FABBISOGNO GIORNALIERO ED ENERGETICO -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;VALUTAZIONE DEL FABBISOGNO ENERGETICO GIORNALIERO</b>
              </span>
            </td>
          </tr>
        </table>
        <table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr>
            <td width="50%">
              <b>Fabbisogno Energetico Totale (TDEE):</b>
              <input type="text" name="fabbisogno_energetico" size="5">
              kcal/giorno
            </td>
            <td width="50%">
              <b>Metabolismo Basale stimato (MB):</b>
              <input type="text" name="metabolismo_basale" size="5">
              kcal/giorno
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <b>Apporto Calorico Prescritto:</b>
              <input type="text" name="apporto_calorico" size="5">
              <b>kcal/giorno</b>
            </td>
          </tr>
        </table>
        <div>
          <b>Ripartizione dei Macronutrienti Prescritta:</b>
          <ul>
            <li>
              <b>Carboidrati:</b> <input name="carboidrati"type="text" size="4"> <b>g / giorno</b> 
            <li>
              <b>Proteine:</b> <input name="proteine" type="text" size="4"> <b>g / giorno</b>  
            </li>
            <li>
              <b>Grassi:</b> <input name="grassi" type="text" size="4"> <b>g / giorno</b> 
            </li>
          </ul>
        </div>
      </td>
    </tr>

    <!-- PRESCRIZIONE DIETETICA E INDICAZIONI -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;PRESCRIZIONE DIETETICA E INDICAZIONI</b>
              </span>
            </td>
          </tr>
        </table>
        <div>
          <b>Schema Alimentare:</b> <textarea name="schema_alimentare" rows="1" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; "></textarea><br><br>
          <b>Colazione:</b> <input name="percentuale_colazione" type="text" size="3"> % -
          <b>Pranzo:</b> <input name="percentuale_pranzo" type="text" size="3"> % -
          <b>Cena:</b> <input name="percentuale_cena" type="text" size="3"> % -
          <b>Apporto idrico:</b> <input name="idratazione" type="text" size="5"> ml/giorno<br><br>
          
        </div>
      </td>
    </tr>

    <!-- CONTROLLO -->
    <tr>
      <td>
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td width="4" bgcolor="#176b63"></td>
            <td bgcolor="#ecf2ef">
              <span style="font-size: 17px; color: #2c3e50;">
                <b>&nbsp;COMMENTI FINALI</b>
              </span>
            </td>
          </tr>
        </table>
        <div>
           <b>Note:</b><br>
          <textarea name="note" rows="2" cols="92" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; "></textarea><br><br>
        </div>
      </td>
    </tr>

            </table>
            <div style="text-align: center; padding: 12px; color:#ffffff; ">
                <input type="submit" value="Salva Referto"
                    style="background-color: #176b63; color: white; border: 0; border-radius: 4px; padding: 10px 24px; font-size: 15px; cursor: pointer;">
            </div>
            </form>
        </td>
        

        </tr>
            </c:otherwise>

        </c:choose>

    </c:otherwise>

</c:choose>
<%@ include file="layout_bottom.jspf" %>
