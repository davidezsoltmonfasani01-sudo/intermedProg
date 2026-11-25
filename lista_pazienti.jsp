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

    <c:when test="${empty user || user.Ruolo != 'KC'}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:otherwise>

        <%@ include file="navbar_kc.jspf" %>

        <sql:query var="rset_pazienti">
            SELECT Utenti.ID, CF, Cognome, Nome, Stati.Stato
            FROM Utenti, Associazioni_KC_PZ, Stati
            WHERE ID_kc = ? and Stati.ID_stato = Associazioni_KC_PZ.ID_stato
               AND Utenti.ID = Associazioni_KC_PZ.ID_pz
               AND
               (CF LIKE ?
               OR Cognome LIKE ?
               OR Nome LIKE ?)
            ORDER BY Cognome, Nome

            <sql:param value="${user.ID}"/>
            <sql:param value="%${param.cerca}%"/>
            <sql:param value="%${param.cerca}%"/>
            <sql:param value="%${param.cerca}%"/>
        </sql:query>

        <tr>
            <td align="center" bgcolor="#f1f5f4">

                <br><br>

                <h2>Pazienti Associati</h2>

                <p>Visualizza e cerca i Pazienti</p>

                <br>

                <form action="lista_pazienti.jsp" method="get">

                    <input type="text"
                           name="cerca"
                           size="35"
                           placeholder="Cerca per CF, nome o cognome"
                           value="${param.cerca}">

                    <input type="submit" value="Cerca" style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 3px 16px; font-size: 13px; line-height: 1; cursor: pointer;">

                    <a href="lista_pazienti.jsp">Mostra tutti</a>

                </form>

                <br><br>
				<div class="scrollable-table">
                <table border="1" align="center" cellpadding="8">

                    <tr bgcolor="#dce8e5">
                        <th>CF</th>
                        <th>Cognome</th>
                        <th>Nome</th>
                        <th>Stato Associazione</th>
                        <th>Dettagli</th>
                    </tr>

                    <c:forEach items="${rset_pazienti.rows}" var="paziente">

                        <tr>
                            <td>${paziente.CF}</td>

                            <td>${paziente.Cognome}</td>

                            <td>${paziente.Nome}</td>

                            <td>${paziente.Stato}</td>

                            <td>
                                <a href="info_paziente.jsp?id_paziente=${paziente.ID}">
                                    <img src="GoTo.svg" alt="Vai" height="40" width="50">
                                </a>
                            </td>
                        </tr>

                    </c:forEach>

                    <c:if test="${rset_pazienti.rowCount == 0}">
                        <tr>
                            <td colspan="8">
                                Nessun paziente trovato
                            </td>
                        </tr>
                    </c:if>

                </table>
              </div>
                <br><br>

            </td>
        </tr>

    </c:otherwise>

</c:choose>

<%@ include file="layout_bottom.jspf" %>

