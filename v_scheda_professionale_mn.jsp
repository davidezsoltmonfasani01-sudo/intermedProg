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
    <c:when test="${empty param.id_mn}">
        <jsp:forward page="lista_schede_professionali_mn.jsp"/>
    </c:when>

    <c:otherwise>

        <c:choose>
        <c:when test="${ user.ID_stato == 2}">
            <%@ include file="navbar_pz.jspf" %>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" bgcolor="#124f49" style="padding: 0;">
                    <nav class="menu-contenitore" aria-label="Navigazione principale">
                        <div class="menu-links">
                            <div class="menu-scrollabile">
                                <a href="index.jsp">Home</a>
                                <a href="lista_schede_professionali_mn.jsp">Elenco Medici Nutrizionisti</a>
                                <a href="lista_schede_professionali_kc.jsp">Elenco Kitchen Coach</a>
                            </div>
                            <div>
                                <a href="logout.jsp"><img  style="width: 45px; height: 45px;"
                                src="LogOut.svg"
                                title="logout"
                                alt="logout"></a>
                            </div>
                        </div>
                    </nav>
                </td>
            </tr>
            </thead>
        </c:otherwise>
    </c:choose>
        

        <sql:query var="rset_mn">
            SELECT Utenti.ID, CF, Cognome, Nome, Data_Nascita, Presentazione, data_certificazione, numero_albo
            FROM Utenti , Schede_Professionali
            WHERE Utenti.ID = ID_utente
            AND Utenti.Ruolo = 'MN'
          	AND ID_stato = 2
            AND Utenti.ID = ?
            <sql:param value="${param.id_mn}"/>
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <c:choose>

                    <c:when test="${rset_mn.rowCount == 1}">
                        <c:set var="mn" value="${rset_mn.rows[0]}"/>

                        
                        <table width="650" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                            
                            
                            <tr bgcolor="#2e6f65">
                                <td align="center">
                                    <br>
                                    <span style="color: white;" ><h3>${mn.Nome} ${mn.Cognome}</h3></span>
                                    <span style="color:#d1e5e1;"><i>Medico Nutrizionista </i></span>
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
                                                    <table width="100%" border="0" cellpadding="8" cellspacing="2">
                                                        <tr bgcolor="#f8faf9">
                                                            <td width="45%"><b>Codice Fiscale:</b></td>
                                                            <td><code>${mn.CF}</code></td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Data di Nascita:</b></td>
                                                            <td>
                                                                <fmt:formatDate value="${mn.Data_Nascita}" pattern="dd/MM/yyyy"/>
                                                            </td>
                                                        </tr>
                                                        <tr bgcolor="#f8faf9">
                                                            <td><b>Conseguimento Certificazione:</b></td>
                                                            <td>
                                                                <fmt:formatDate value="${mn.data_certificazione}" pattern="dd/MM/yyyy"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Numero Albo:</b></td>
                                                            <td>${mn.numero_albo}</td>
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
                                                                    <c:when test="${not empty mn.Presentazione}">
                                                                        ${mn.Presentazione}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i>Nessuna presentazione inserita dal medico.</i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
							<c:if test="${ user.ID_stato == 2}">
                            <tr>
                            <td align="center">
                              <form action="#" method="post">
                                <input type="hidden" name="id_mn" value="${mn.ID}">
                                <input type="submit" value="Prenota Visita" style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px; cursor: pointer;">
                              </form>
                              <br>
                            </td>
                          </tr>
                            </c:if>
                            <tr bgcolor="#e6efed">
                                <td align="center">
                                    <br>
                                    <a href="lista_schede_professionali_mn.jsp">
                                        <b> Torna alla lista dei Medici Nutrizionisti</b>
                                    </a>
                                    <br><br>
                                </td>
                            </tr>

                        </table>

                    </c:when>

                    <c:otherwise>

                      <span style="color:#b03a2e;" ><b>Attenzione: Medico Nutrizionista non trovato.</b></span>                 
                      <br>
                      <a href="lista_schede_professionali_mn.jsp">
                        <b> Torna alla lista dei Medici Nutrizionisti</b> </a>          
                    </c:otherwise>
                </c:choose>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>
