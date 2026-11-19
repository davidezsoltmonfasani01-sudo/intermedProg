<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_pz.jspf" %>
  
<sql:query var="Controllo_kc">
    SELECT ID_kc, data_inizio
    FROM Associazioni_KC_PZ
    WHERE ID_pz = ?
    AND data_fine is null
    AND ID_stato = 2
    <sql:param value="${user.ID}"/>
  </sql:query>


  
  <sql:query var="rset_kc">
    SELECT Utenti.ID, CF, Cognome, Nome, Data_Nascita, Presentazione, data_certificazione
    FROM Utenti , Schede_Professionali
    WHERE Utenti.ID = ID_utente
    AND Utenti.Ruolo = 'KC'
    AND ID_stato = 2
    AND Utenti.ID = ?
    <sql:param value="${Controllo_kc.rows[0].ID_kc}"/>
  </sql:query>

  <tr>
    <td align="center" bgcolor="#f1f5f4">

      <br><br>

      <c:choose>

        <c:when test="${rset_kc.rowCount == 1}">
          <c:set var="kc" value="${rset_kc.rows[0]}"/>

		  
          <table width="650" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">


            <tr bgcolor="#2e6f65">
              <td align="center">
                <br>
                <span style="color: white;" ><h3>${kc.Nome} ${kc.Cognome}</h3></span>
                <span style="color:#d1e5e1;"><i>Kitchen Coach Certificato</i></span>
                <br><br>
              </td>
            </tr>


            <tr>
              <td>
                <table width="100%" border="0" cellpadding="15" cellspacing="0">
                  <tr>
                    <td>


                      <fieldset>
                        <legend><b><span style="color:#2e6f65;">Dati Professionali e Anagrafici</span></b></legend>
                        <br>
                        <table width="100%" border="0" cellpadding="6" cellspacing="2">
                          <tr bgcolor="#f8faf9">
                            <td width="45%"><b>Codice Fiscale:</b></td>
                            <td><code>${kc.CF}</code></td>
                          </tr>
                          <tr>
                            <td><b>Data di Nascita:</b></td>
                            <td>
                              <fmt:formatDate value="${kc.Data_Nascita}" pattern="dd/MM/yyyy"/>
                            </td>
                          </tr>
                          <tr bgcolor="#f8faf9">
                            <td><b>Conseguimento Certificazione:</b></td>
                            <td>
                              <fmt:formatDate value="${kc.data_certificazione}" pattern="dd/MM/yyyy"/>
                            </td>
                          </tr>
                          <tr>
                            <td><b>Data Associazione:</b></td>
                            <td>
                              <fmt:formatDate value="${Controllo_kc.rows[0].data_inizio}" pattern="dd/MM/yyyy"/>
                            </td>
                          </tr>
                        </table>
                      </fieldset>

                      <br>


                      <fieldset>
                        <legend><b><span style="color:#2e6f65;">Presentazione e Approccio</span></b></legend>
                        <table width="100%" border="0" cellpadding="10" cellspacing="0">
                          <tr>
                            <td align="center">
                              <c:choose>
                                <c:when test="${not empty kc.Presentazione}">
                                  ${kc.Presentazione}
                                </c:when>
                                <c:otherwise>
                                  <i>Nessuna presentazione inserita dal professionista.</i>
                                </c:otherwise>
                              </c:choose>
                            </td>
                          </tr>
                        </table>
                      </fieldset>
                      <br>
                      <form action="#" method="post">
                      <fieldset>
                        <legend><b><span style="color:#8B0000;">Motivazione Sostituzione Kitchen Coach</span></b></legend>
                        <table width="100%" border="0" cellpadding="10" cellspacing="0">
                          <tr>
                            <td align="center">
                              <textarea id="messaggio_motivazione"
                                        name="messaggio_motivazione" rows="7" cols="60"
                                        required></textarea>
                            </td>
                          </tr>
                        </table>
                      </fieldset>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td align="center">
                  <input type="hidden" name="id_kc" value="${kc.ID}">
                  <input type="submit" value="Rimuovi Associazione" style="background-color: #8B0000; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px; cursor: pointer;">
                </form>
                <br>
              </td>
            </tr>
          </table>

        </c:when>

        <c:otherwise>

          <span style="color:#b03a2e;" ><b>Attenzione: Kitchen Coach non trovato.</b></span>                 
          <br>
          <a href="lista_schede_professionali_kc.jsp">
            <b> Torna alla lista dei Kitchen Coach</b> </a>          
        </c:otherwise>
      </c:choose>

      <br><br>

    </td>
  </tr>

    

<%@ include file="layout_bottom.jspf" %>
