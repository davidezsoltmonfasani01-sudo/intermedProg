<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>
<%@ include file="layout_top.jspf" %>
<c:if test="${empty user}">
    <jsp:forward page="login.jsp"/>
</c:if>

<c:choose>
    <c:when test="${not empty param.page_date}">

        <fmt:parseDate value="${param.page_date}" pattern="yyyy-MM-dd" var="page_date" />
    </c:when>
    <c:otherwise>

        <c:set var="page_date" value="${dateTime_oggi}" />
    </c:otherwise>
</c:choose>
<tr valign="top">
    <td align="center">
        <h1>
            Diario Alimentare di ${PZ.nome} ${PZ.cognome} del:
            <fmt:formatDate value="${page_date}" pattern="dd MMMM yyyy"/>
        </h1>
        <form action="pagina_diario.jsp" method="GET">
            <input type="date" id="page_date" name="page_date" required>
            <input type="submit" value="Vai alla data"
            style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px; cursor: pointer;">
        </form>
<c:choose>
    <%--CASO PAGINA APERTA DAL PAZIENTE PROPRIETARIO DELLA PAGINA--%>
    <c:when  test="${user.ruolo == 'PZ'}">
        <c:set var="PZ" value="${user}" />
        <%@ include file="navbar_pz.jspf" %>
        <%--RICERCO I VALORI DELLA PAGINA SE ESISTE--%>
        <sql:query var="d_info">
            SELECT *
            FROM Pagine_Diario pd
            WHERE ID_pz = ?
            <sql:param value="${PZ.id}" />
        </sql:query>

        <%--questa cosa mi sa molto da azione da fare in una pagina di action sinceramente--%>
        <%--SE NON ESISTE --%>
        <c:if test="${d_info.rowCount == 0}">
            <%--RICERCO SE L'UTENTE HA EFFETTUATO VISITE, E SE SI PRENDO I DATI DELLA VISITA CORRISPETTIVA ALLA DATA SCELTA, ALTRIMENTI STAMPO UN MESSAGGIO--%>
            <sql:query var="d_visita">
                SELECT v.*, pr.Data_visita
                FROM Visite v
                INNER JOIN Prenotazioni pr ON pr.ID_prenotazione = v.ID_prenotazione
                WHERE pr.ID_pz = ?
                AND pr.Data_visita <= ?
                ORDER BY pr.Data_visita DESC
                LIMIT 1
                <sql:param value="${PZ.id}" />
                <sql:dateParam value="${page_date}" type="date" />
            </sql:query>

            <c:choose>
                <c:when test="${d_visita.rowCount == 0}">
                    Nessuna visita trovata (${d_visita.rowCount})
                </c:when>
                <c:otherwise>
                        <%@ include file="pagina_diario_contenuto.jspf" %>
                    Visita trovata! (${d_visita.rowCount})
                </c:otherwise>
            </c:choose>

        </c:if>







    </c:when>
    <c:otherwise>
        <jsp:forward page="a_dispatch_home.jsp"/>
    </c:otherwise>
</c:choose>










    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>
