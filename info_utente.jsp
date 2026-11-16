```jsp
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

    <c:when test="${empty user || user.Ruolo != 'DS'}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:when test="${empty param.id_utente}">
        <jsp:forward page="lista_utenti.jsp"/>
    </c:when>

    <c:otherwise>

        <%@ include file="navbar_user.jspf" %>

        <sql:query var="rset_utente">
            SELECT U.ID, U.CF, U.Cognome, U.Nome, U.Data_Nascita,
                   U.Username, U.Ruolo, U.ID_stato, S.Stato
            FROM Utenti U, Stati S
            WHERE U.ID_stato = S.ID_status
              AND U.ID = ?

            <sql:param value="${param.id_utente}"/>
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <h2>Informazioni utente</h2>

                <br>

                <c:choose>

                    <c:when test="${rset_utente.rowCount == 1}">

                        <table border="1" align="center" cellpadding="8">

                            <tr>
                                <th>Codice fiscale</th>
                                <td>${rset_utente.rows[0].CF}</td>
                            </tr>

                            <tr>
                                <th>Cognome</th>
                                <td>${rset_utente.rows[0].Cognome}</td>
                            </tr>

                            <tr>
                                <th>Nome</th>
                                <td>${rset_utente.rows[0].Nome}</td>
                            </tr>

                            <tr>
                                <th>Data di nascita</th>
                                <td> ${rset_utente.rows[0].Data_Nascita}</td>
                            </tr>

                            <tr>
                                <th>Username</th>
                                <td>${rset_utente.rows[0].Username}</td>
                            </tr>

                            <tr>
                                <th>Ruolo</th>
                                <td>${rset_utente.rows[0].Ruolo}</td>
                            </tr>

                            <tr>
                                <th>Stato account</th>
                                <td>${rset_utente.rows[0].Stato}</td>
                            </tr>

                        </table>

                        <br><br>

                        <a href="lista_utenti.jsp">
                            Torna alla lista utenti
                        </a>

                    </c:when>

                    <c:otherwise>

                        <p>Utente non trovato.</p>

                        <a href="lista_utenti.jsp">
                            Torna alla lista utenti
                        </a>

                    </c:otherwise>

                </c:choose>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>