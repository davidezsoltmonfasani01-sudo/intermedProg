<%@ page session="true" language="java" 
         contentType="text/html; charset=UTF-8" import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<c:remove var="user" scope="session"/>

<sql:query var="rset_controllo">
SELECT ID, CF, Nome, Cognome, Data_nascita, Username, Ruolo, ID_stato, Stato
  FROM Utenti U, Stati S
 WHERE 
 U.ID_stato = S.ID_stato
 AND Username = ?
 <sql:param value="${param.form_username}"/>
 AND Password = ?
 <sql:param value="${param.form_password}"/>
</sql:query> 
<c:if test="${rset_controllo.rowCount == 1}">
  <c:set var="user" value="${rset_controllo.rows[0]}" scope="session"/>
  <jsp:forward page="dispatch_home.jsp"/>
</c:if>

  

<c:set var="errmsg" scope="request">Credenziali errate: riprovare</c:set>
<jsp:forward page="login.jsp"/>