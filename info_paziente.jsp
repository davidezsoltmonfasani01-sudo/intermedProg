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

<c:choose>
    <c:when test="${empty param.id_paziente}">
        <jsp:forward page="lista_associazioni.jsp"/>
    </c:when>

    <c:otherwise>

        
        <sql:query var="rset_ass">
            SELECT ID_kc, Data_inizio
            FROM Associazioni_KC_PZ 
            WHERE ID_pz = ? AND ID_stato = 2 AND Data_fine is null
            <sql:param value="${param.id_paziente}"/>
          <c:if test="${user.Ruolo == 'KC'}">
                AND ID_kc = ?
                <sql:param value="${user.ID}"/>
            </c:if>
        </sql:query>

        <sql:query var="rset_pz">
            SELECT ID, CF, Cognome, Nome, Data_Nascita
            FROM Utenti 
            WHERE ID = ?
            <sql:param value="${param.id_paziente}"/>
        </sql:query>
        
        <c:if test="${user.Ruolo == 'MN'}">
           <sql:query var="rset_kc">
            SELECT Cognome, Nome
            FROM Utenti 
            WHERE ID = ?
            <sql:param value="${rset_ass.rows[0].ID_kc}"/>
        </sql:query>
        </c:if>
        
        
        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <c:choose>

                    <c:when test="${rset_pz.rowCount == 1 && rset_ass.rowCount == 1}">
                        <c:set var="pz" value="${rset_pz.rows[0]}"/>
                        

                        <table width="650" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                            
                            
                            <tr bgcolor="#2e6f65">
                                <td align="center">
                                    <br>
                                    <span style="color: white;" ><h3>Informazioni sul Paziente</h3></span>
                                    <br><br>
                                </td>
                            </tr>

                            
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="15" cellspacing="0">
                                        <tr>
                                            <td>
                                                
                                                
                                                <fieldset>
                                                    <legend><b><span style="color:#2e6f65;">Scheda Anagrafica </span></b></legend>
                                                    <br>
                                                    <table width="100%" border="0" cellpadding="6" cellspacing="2">
                                                        <tr bgcolor="#f8faf9">
                                                            <td width="45%"><b>Codice Fiscale:</b></td>
                                                            <td><code>${pz.CF}</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Nome e Cognome:</b></td>
                                                            <td>${pz.Nome} ${pz.Cognome}</td>
                                                        </tr>
                                                        <tr bgcolor="#f8faf9">
                                                            <td><b>Data di Nascita:</b></td>
                                                            <td>${pz.Data_Nascita}
                                                            </td>
                                                        </tr>
                                                      	<tr>
                                                            <td><b>Data associazione:</b></td>
                                                            <td>${rset_ass.rows[0].Data_inizio} </td>
                                                        </tr>
                                                      <c:if test="${user.Ruolo == 'MN'}">  
                                                      <tr bgcolor="#f8faf9">
                                                            <td><b>Kitchen Coach Associato:</b></td>
                                                            <td>${rset_kc.rows[0].Nome} ${rset_kc.rows[0].Cognome} 
                                                            </td>
                                                      </tr> </c:if>
                                                    </table>
                                                </fieldset>

                                                <br>
                                              <div style="text-align: center; width: 100%; margin-top: 15px;">
    <a href="v_pagina_diario.jsp?id_paziente=${pz.ID}" 
       style="display: inline-block; background-color: #2e6f65; color: white; padding: 10px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; margin: 5px;">
        Diario Alimentare
    </a>

    <a href="v_lista_visite.jsp?id_paziente=${pz.ID}" 
       style="display: inline-block; background-color: #2e6f65; color: white; padding: 10px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; margin: 5px;">
        Visite con Referti
    </a>
											</div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr bgcolor="#e6efed">
                                <td align="center">
                                    <br>
                                    <a href="lista_pazienti.jsp">
                                        <b> Torna alla lista dei Pazienti</b>
                                    </a>
                                    <br><br>
                                </td>
                            </tr>

                        </table>

                    </c:when>

                    <c:otherwise>

                      <span style="color:#b03a2e;" ><b>Attenzione: Paziente non trovato.</b></span>                 
                      <br>
                      <a href="lista_associazioni.jsp">
                        <b> Torna alla lista delle Associazioni</b> </a>          
                    </c:otherwise>
                </c:choose>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>
