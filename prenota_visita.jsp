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



        <sql:query var="rset_mn">
            SELECT Utenti.ID, Nome, Cognome
            FROM Utenti, Schede_Professionali
            WHERE Utenti.ID = ID_utente
            AND Utenti.Ruolo = 'MN'
            AND Utenti.ID_stato = 2
            AND Utenti.ID = ?

            <sql:param value="${param.id_mn}"/>
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <c:choose>

                    <c:when test="${rset_mn.rowCount == 1}">

                        <h2>Prenota una visita</h2>

                        <p>
                            Stai prenotando una visita con il Dott.
                            ${rset_mn.rows[0].Nome}
                            ${rset_mn.rows[0].Cognome}
                        </p>

                        <br>
                        <c:if test="${not empty errmsg}">
    						<p style="color:red;">
        					${errmsg}
    						</p>
						</c:if>

                        <form action="a_prenota_visita.jsp" method="post">

                            <input type="hidden" name="id_mn"
                                   value="${rset_mn.rows[0].ID}">

                            <table border="0" cellpadding="10">

                                <tr>
                                    <td><b>Data e ora della visita:</b></td>
                                    <td>
                                        <input type="datetime-local"
                                               name="data_visita"
                                               required>
                                    </td>
                                </tr>

                            </table>

                            <br>

                            <input type="submit" value="Conferma prenotazione">

                        </form>

                    </c:when>

                    <c:otherwise>

                        <p>
                            <b>Medico Nutrizionista non trovato</b>
                        </p>

                        <a href="lista_schede_professionali_mn.jsp">
                            Torna alla lista dei medici
                        </a>

                    </c:otherwise>

                </c:choose>

                <br><br>

                <a href="lista_schede_professionali_mn.jsp">
                    Torna alla lista dei medici
                </a>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>