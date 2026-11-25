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

<c:choose>
    <%--CASO PAGINA APERTA DAL PAZIENTE PROPRIETARIO DELLA PAGINA--%>
    <c:when  test="${user.ruolo == 'PZ'}">
        <c:set var="PZ" value="${user}" />
        <%@ include file="navbar_pz.jspf" %>
         <%@ include file="pagina_diario_contenuto.jspf" %>
    </c:when>
    <c:otherwise>
        <jsp:forward page="v_pagina_diario.jsp"/>
    </c:otherwise>
</c:choose>


<%@ include file="layout_bottom.jspf" %>
