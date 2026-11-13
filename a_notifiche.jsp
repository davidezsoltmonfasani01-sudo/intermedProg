<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<c:choose>
  
    <c:when test="${param.action == 'GoTo' && not empty param.risorsa}">
        <c:redirect url="${param.risorsa}.jsp   " />
    </c:when>


    <c:otherwise>
        <jsp:forward page="notifiche.jsp" />
    </c:otherwise>
</c:choose>
