<%@ page session="true" language="java" 
         contentType="text/html; charset=UTF-8" import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

    <c:choose>
  <c:when test="${not empty user.ID && user.Ruolo == 'MN'}">
    <c:if test="${user.ID_stato == 1}">
    <jsp:forward page="compilazione_scheda_professionale.jsp" />
  </c:if>
  <jsp:forward page="home_mn.jsp" />
  </c:when>
  <c:when test="${not empty user.ID && user.Ruolo == 'PZ'}">
    <c:if test="${user.ID_stato == 1}">
    <jsp:forward page="attesa_attivazione.jsp" />
  </c:if>
  <jsp:forward page="home_pz.jsp" />
  </c:when>
  <c:when test="${not empty user.ID && user.Ruolo == 'KC'}">
    <c:if test="${user.ID_stato == 1}">
    <jsp:forward page="compilazione_scheda_professionale.jsp" />
  </c:if>
  <jsp:forward page="home_kc.jsp" />
  </c:when>
  <c:when test="${not empty user.ID && user.Ruolo == 'DS'}">
    <jsp:forward page="home_ds.jsp" />
  </c:when>
  <c:otherwise>
    <jsp:forward page="login.jsp" />
  </c:otherwise>
</c:choose>