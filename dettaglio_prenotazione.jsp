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

    <c:when test="${empty user || (user.Ruolo != 'PZ' && user.Ruolo != 'MN')}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:when test="${empty param.id_prenotazione}">
        <jsp:forward page="lista_visite.jsp"/>
    </c:when>

    <c:otherwise>



        <sql:query var="rset_prenotazione">
            SELECT
                Prenotazioni.ID_prenotazione,
                Prenotazioni.Data_prenotazione,
                Prenotazioni.Data_visita,
                Prenotazioni.ID_stato,
          		Prenotazioni.ID_pz,
                Stati.Stato,

                (SELECT Nome FROM Utenti
                 WHERE ID = Prenotazioni.ID_pz) AS nome_paziente,

                (SELECT Cognome FROM Utenti
                 WHERE ID = Prenotazioni.ID_pz) AS cognome_paziente,

                (SELECT Nome FROM Utenti
                 WHERE ID = Prenotazioni.ID_mn) AS nome_medico,

                (SELECT Cognome FROM Utenti
                 WHERE ID = Prenotazioni.ID_mn) AS cognome_medico

            FROM Prenotazioni, Stati

            WHERE Prenotazioni.ID_stato = Stati.ID_stato
            AND Prenotazioni.ID_prenotazione = ?
            AND (
                ( ? = 'PZ' AND Prenotazioni.ID_pz = ? )
                OR
                ( ? = 'MN' AND Prenotazioni.ID_mn = ? )
            )

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.Ruolo}"/>
            <sql:param value="${user.ID}"/>
            <sql:param value="${user.Ruolo}"/>
            <sql:param value="${user.ID}"/>

        </sql:query>


        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>
                <h2>Dettaglio prenotazione</h2>
                <br>

                <c:choose>

                    <c:when test="${rset_prenotazione.rowCount == 1}">

                        <p>
                            <b>Paziente:</b>
                            ${rset_prenotazione.rows[0].nome_paziente}
                            ${rset_prenotazione.rows[0].cognome_paziente}
                        </p>

                        <p>
                            <b>Medico:</b>
                            ${rset_prenotazione.rows[0].nome_medico}
                            ${rset_prenotazione.rows[0].cognome_medico}
                        </p>

                        <p>
                            <b>Data prenotazione:</b>
                            ${rset_prenotazione.rows[0].Data_prenotazione}
                        </p>

                        <p>
                            <b>Data visita:</b>
                            ${rset_prenotazione.rows[0].Data_visita}
                        </p>

                        <p>
                            <b>Stato:</b>
                            ${rset_prenotazione.rows[0].Stato}
                        </p>

                        <br>

                        <table border="0">
                            <tr>
                                <c:if test="${user.Ruolo == 'MN'}">
                                    <c:choose>
                                        <c:when test="${rset_prenotazione.rows[0].ID_stato == 12}">
                                            <td>
                                                <form action="a_m_stato_prenotazione.jsp" method="post">
                                                    <input type="hidden" name="id_prenotazione"
                                                           value="${param.id_prenotazione}">
                                                    <input type="hidden" name="azione" value="accetta">
                                                    <input type="submit" value="Accetta prenotazione" class="submit-btn">
                                                </form>
                                            </td>
                                            <td>
                                                <form action="a_m_stato_prenotazione.jsp" method="post">
                                                    <input type="hidden" name="id_prenotazione"
                                                           value="${param.id_prenotazione}">
                                                    <input type="hidden" name="azione" value="rifiuta">
                                                    <input type="submit" value="Rifiuta prenotazione" class="submit-btn">
                                                </form>
                                            </td>
                                        </c:when>

                                        <c:when test="${rset_prenotazione.rows[0].ID_stato == 4}">
                                            <td>
                                                <form action="a_m_stato_prenotazione.jsp" method="post">
                                                    <input type="hidden" name="id_prenotazione"
                                                           value="${param.id_prenotazione}">
                                                    <input type="hidden" name="azione" value="effettuata">
                                                    <input type="submit" value="Segna visita come effettuata" class="submit-btn">
                                                </form>
                                            </td>
                                        </c:when>

                                        <c:when test="${rset_prenotazione.rows[0].ID_stato == 7}">
                                            <td>
                                                <form action="compila_referto.jsp" method="get">
                                                    <input type="hidden" name="id_prenotazione"
                                                           value="${param.id_prenotazione}">
                                                    <input type="submit" value="Compila referto" class="submit-btn">
                                                </form>
                                            </td>
                                        </c:when>
                                    </c:choose>
                                </c:if>

                                <c:if test="${(rset_prenotazione.rows[0].ID_stato == 4 || rset_prenotazione.rows[0].ID_stato == 12)}">
                                    <td>
                                        <form action="a_m_stato_prenotazione.jsp" method="post">
                                            <input type="hidden" name="id_prenotazione"
                                                   value="${param.id_prenotazione}">
                                            <input type="hidden" name="azione" value="annulla">
                                            <input type="submit" value="Annulla prenotazione" class="submit-btn">
                                        </form>
                                    </td>
                                </c:if>

                                <c:if test="${rset_prenotazione.rows[0].ID_stato == 8}">
                                    <td>
                                        <form action="v_referto.jsp" method="get">
                                            <input type="hidden" name="id_prenotazione"
                                                   value="${param.id_prenotazione}">
                                            <input type="submit" value="Visualizza referto" class="submit-btn">
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </table>
						
                      	<c:if test="${(user.Ruolo == 'MN' && rset_prenotazione.rows[0].ID_stato == 4)}">
                         <br>
                          <a href="info_paziente.jsp?id_paziente=${rset_prenotazione.rows[0].ID_pz}" 
       style="display: inline-block; background-color: #2e6f65; color: white; padding: 10px 18px; text-decoration: none; border-radius: 4px; font-weight: bold; margin: 5px;">
        Maggiori Informazioni sul Paziente
                          </a> </c:if>

                    </c:when>


                    <c:otherwise>

                        <p><b>Prenotazione non trovata</b></p>

                    </c:otherwise>

                </c:choose>

                <br>

                <a href="lista_visite.jsp">Torna all'elenco</a>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>
