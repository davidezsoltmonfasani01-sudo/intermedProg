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
        <c:if test="${page_date > dateTime_oggi}">
            <c:set var="page_date" value="${dateTime_oggi}" />
        </c:if>

    </c:when>
    <c:otherwise>

        <c:set var="page_date" value="${dateTime_oggi}" />
    </c:otherwise>
</c:choose>
<c:if test="${empty param.id_paziente}">
    <jsp:forward page="dispatch_home.jsp"/>
</c:if>
<sql:query var="paziente">
    SELECT U.ID, U.CF, U.Nome, U.Cognome, U.Data_nascita, U.Username, U.Ruolo, U.ID_stato, S.Stato
    FROM Utenti U
    INNER JOIN Stati S ON U.ID_stato = S.ID_stato
    WHERE UPPER(U.ID) = ?
    <sql:param value="${param.id_paziente}"/>
</sql:query>
<c:set var="PZ" value="${paziente.rows[0]}" />
<c:choose>

    <c:when  test="${user.ruolo == 'PZ'}">
        <jsp:forward page="pagina_diario.jsp"/>
    </c:when>
    <c:when  test="${user.ruolo == 'MN'}">
        <%-- da aggiungere altri controlli per determinare se il medico può visualizzare le info del paziente --%>

        <%@ include file="navbar_mn.jspf" %>
        <%@ include file="pagina_diario_contenuto.jspf" %>
    </c:when>
    <c:when  test="${user.ruolo == 'MN'}">
        <%-- da aggiungere altri controlli per determinare se il kc può visualizzare le info del paziente --%>
        <%@ include file="navbar_kc.jspf" %>
        <%@ include file="pagina_diario_contenuto.jspf" %>
    </c:when>
    <c:otherwise>
        <jsp:forward page="dispatch_home.jsp"/>
    </c:otherwise>
</c:choose>



<%@ include file="layout_bottom.jspf" %>
