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

    <c:otherwise>

        <%@ include file="navbar_user.jspf" %>

        <sql:query var="rset_utenti">
            SELECT ID, CF, Cognome, Nome, Data_Nascita,
                   Username, Ruolo, ID_stato
            FROM Utenti
            WHERE CF LIKE ?
               OR Cognome LIKE ?
               OR Nome LIKE ?
               OR Username LIKE ?
            ORDER BY Cognome, Nome

            <sql:param value="%${param.cerca}%"/>
            <sql:param value="%${param.cerca}%"/>
            <sql:param value="%${param.cerca}%"/>
            <sql:param value="%${param.cerca}%"/>
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <h2>Gestione utenti</h2>

                <p>Visualizza e cerca gli utenti registrati</p>

                <br>

                <form action="lista_utenti.jsp" method="get">

                    <input type="text"
                           name="cerca"
                           size="35"
                           placeholder="Cerca per CF, nome, cognome o username"
                           value="${param.cerca}">

                    <input type="submit" value="Cerca">

                    <a href="lista_utenti.jsp">Mostra tutti</a>

                </form>

                <br><br>

                <table border="1" align="center" cellpadding="8">

                    <tr bgcolor="#dce8e5">
                        <th>CF</th>
                        <th>Cognome</th>
                        <th>Nome</th>
                        <th>Data di nascita</th>
                        <th>Username</th>
                        <th>Ruolo</th>
                        <th>Stato</th>
                        <th>Dettagli</th>
                    </tr>

                    <c:forEach items="${rset_utenti.rows}" var="utente">

                        <tr>
                            <td>${utente.CF}</td>

                            <td>${utente.Cognome}</td>

                            <td>${utente.Nome}</td>

                            <td>${utente.Data_Nascita}</td>          

                            <td>${utente.Username}</td>

                            <td>${utente.Ruolo}</td>

                            <td>${utente.ID_stato}</td>

                            <td>
                                <a href="info_utente.jsp?id_utente=${utente.ID}">
                                    Visualizza
                                </a>
                            </td>
                        </tr>

                    </c:forEach>

                    <c:if test="${rset_utenti.rowCount == 0}">
                        <tr>
                            <td colspan="8">
                                Nessun utente trovato
                            </td>
                        </tr>
                    </c:if>

                </table>

                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>

