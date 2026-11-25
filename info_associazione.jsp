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
    <c:when test="${empty param.id_associazione}">
        <jsp:forward page="lista_associazioni.jsp"/>
    </c:when>

    <c:otherwise>

        <%@ include file="navbar_ds.jspf" %>

        <sql:query var="rset_pz_associazione">
            SELECT Utenti.ID, CF, Cognome, Nome, data_inizio, data_fine, motivazione, Stati.Stato
            FROM Utenti , Stati, Associazioni_KC_PZ
            WHERE Utenti.ID = ID_pz and Associazioni_KC_PZ.ID_stato = Stati.ID_stato
            AND ID_associazione = ?
            <sql:param value="${param.id_associazione}"/>
        </sql:query>
        <sql:query var="rset_kc">
            SELECT Utenti.ID, CF, Cognome, Nome
            FROM Utenti , Associazioni_KC_PZ
            WHERE Utenti.ID = ID_kc 
            AND ID_associazione = ?
            <sql:param value="${param.id_associazione}"/>
        </sql:query>
        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <c:choose>

                    <c:when test="${rset_pz_associazione.rowCount == 1 && rset_kc.rowCount == 1}">
                        <c:set var="pz_ass" value="${rset_pz_associazione.rows[0]}"/>
                        <c:set var="kc" value="${rset_kc.rows[0]}"/>

                        <table width="650" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                            
                            
                            <tr bgcolor="#2e6f65">
                                <td align="center">
                                    <br>
                                    <span style="color: white;" ><h3>Informazioni sull'Associazione</h3></span>
                                    <br><br>
                                </td>
                            </tr>

                            
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="15" cellspacing="0">
                                        <tr>
                                            <td>
                                                
                                                
                                                <fieldset>
                                                    <legend><b><span style="color:#2e6f65;">Dettagli Paziente</span></b></legend>
                                                    <br>
                                                    <table width="100%" border="0" cellpadding="6" cellspacing="2">
                                                        <tr bgcolor="#f8faf9">
                                                            <td width="45%"><b>Codice Fiscale:</b></td>
                                                            <td><code>${pz_ass.CF}</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Nome e Cognome:</b></td>
                                                            <td>${pz_ass.Nome} ${pz_ass.Cognome}</td>
                                                        </tr>
                                                        <tr bgcolor="#f8faf9">
                                                            <td><b>Maggiori Informazioni:</b></td>
                                                            <td>
                                                                <a href="info_utente.jsp?id_utente=${pz_ass.ID}">
                                                                    <img src="GoTo.svg" alt="Vai" height="40" width="50">
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>

                                                <br>
                                                <fieldset>
                                                    <legend><b><span style="color:#2e6f65;">Dettagli Kitchen Coach</span></b></legend>
                                                    <br>
                                                    <table width="100%" border="0" cellpadding="6" cellspacing="2">
                                                        <tr bgcolor="#f8faf9">
                                                            <td width="45%"><b>Codice Fiscale:</b></td>
                                                            <td><code>${kc.CF}</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Nome e Cognome:</b></td>
                                                            <td>${kc.Nome} ${kc.Cognome}</td>
                                                        </tr>
                                                        <tr bgcolor="#f8faf9">
                                                            <td><b>Maggiori Informazioni:</b></td>
                                                            <td>
                                                                <a href="info_utente.jsp?id_utente=${kc.ID}">
                                                                    <img src="GoTo.svg" alt="Vai" height="40" width="50">
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>

                                                <br>
                                                

                                               
                                                <fieldset>
                                                    <legend><b><span style="color:#2e6f65;">Informazioni Associazione</span></b></legend>
                                                    <table width="100%" border="0" cellpadding="6" cellspacing="0">
                                                        <tr bgcolor="#f8faf9">
                                                            <td width="45%"><b>Data associazione:</b></td>
                                                            <td>${pz_ass.data_inizio}</td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Data Fine:</b></td>
                                                            <td>${pz_ass.data_fine}</td>
                                                        </tr>
                                                        <tr bgcolor="#f8faf9">
                                                            <td><b>Stato associazione:</b></td>
                                                            <td> ${pz_ass.Stato}
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <c:if test="${not empty pz_ass.motivazione}">
                                                    <table width="100%" border="0" cellpadding="10" cellspacing="0" bgcolor="#e6f0ee">
                                                        <tr>
                                                            <td align="left">
                                                                <b><span style="color:#2e6f65;">Motivazione</span></b>
                                                                <br><br>
                                                                ${pz_ass.motivazione}
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    </c:if>

                                                </fieldset>

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr bgcolor="#e6efed">
                                <td align="center">
                                    <br>
                                    <a href="lista_associazioni.jsp">
                                        <b> Torna alla lista delle Associazioni</b>
                                    </a>
                                    <br><br>
                                </td>
                            </tr>

                        </table>

                    </c:when>

                    <c:otherwise>

                      <span style="color:#b03a2e;" ><b>Attenzione: Associazione non trovata.</b></span>                 
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
