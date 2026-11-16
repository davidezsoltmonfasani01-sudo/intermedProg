
<%@ page session="true" language="java"
         contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>

<c:choose>
    <c:when test="${empty user_userid || user_role != 'DS'}">
        <jsp:forward page="login.jsp"/>
    </c:when>
    <c:otherwise>

        <%@ include file="navbar_user.jspf" %>

        <sql:query var="rset_richieste">
            SELECT CF, Cognome, Nome, Data_Nascita, Username
            FROM Utenti
            WHERE Ruolo = 'PZ'
              AND ID_stato = 1
            ORDER BY Cognome, Nome
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">
                <br><br>

                <h2>Richieste di attivazione pazienti</h2>

                <c:if test="${not empty errmsg}">
                    <font color="red"><b>${errmsg}</b></font>
                    <br>
                </c:if>

                <c:if test="${not empty msg}">
                    <font color="green"><b>${msg}</b></font>
                    <br>
                </c:if>

                <c:choose>
                    <c:when test="${rset_richieste.rowCount == 0}">
                        <p>Non ci sono richieste di attivazione in attesa.</p>
                    </c:when>

                    <c:otherwise>
                        <table border="1" cellpadding="8" cellspacing="0">
                            <tr bgcolor="#dce8e5">
                                <th>Codice fiscale</th>
                                <th>Cognome</th>
                                <th>Nome</th>
                                <th>Data di nascita</th>
                                <th>Username</th>
                                <th>Gestione</th>
                            </tr>

                            <c:forEach items="${rset_richieste.rows}" var="pz">
                                <tr>
                                    <td>${pz.CF}</td>
                                    <td>${pz.Cognome}</td>
                                    <td>${pz.Nome}</td>
                                    <td>
                                        <fmt:formatDate value="${pz.Data_Nascita}"
                                                        pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>${pz.Username}</td>
                                    <td align="center">

                                        <form action="a_gestione_richieste.jsp"
                                              method="post"
                                              style="display:inline;">
                                            <input type="hidden"
                                                   name="username"
                                                   value="${pz.Username}">
                                            <input type="hidden"
                                                   name="azione"
                                                   value="accetta">
                                            <input type="submit"
                                                   value="Accetta">
                                        </form>

                                        <form action="a_gestione_richieste.jsp"
                                              method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Vuoi eliminare definitivamente questo paziente?');">
                                            <input type="hidden"
                                                   name="username"
                                                   value="${pz.Username}">
                                            <input type="hidden"
                                                   name="azione"
                                                   value="rifiuta">
                                            <input type="submit"
                                                   value="Rifiuta">
                                        </form>

                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </c:otherwise>
                </c:choose>

                <br><br>
            </td>
        </tr>

    </c:otherwise>
</c:choose>

<%@ include file="layout_bottom.jspf" %>
