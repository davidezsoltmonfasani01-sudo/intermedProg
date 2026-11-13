<%@ page session="true" language="java" 
         contentType="text/html; charset=UTF-8" import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<c:remove var="user_userid" scope="session"/>
<c:remove var="user_role"   scope="session"/>

<sql:query var="rset_controllo">
SELECT ID, CF, Nome, Cognome, Data_nascita, Username, Password, Ruolo, ID_stato
  FROM Utenti
 WHERE Username = ?
 <sql:param value="${param.form_username}"/>
 and Password = ?
 <sql:param value="${param.form_password}"/>
</sql:query> 
<c:if test="${rset_controllo.rowCount == 1}">
  <c:set var="user_userid" value="${rset_controllo.rows[0].ID}" scope="session"/>
  <c:set var="user_role" value="${rset_controllo.rows[0].Ruolo}" scope="session"/>
  <c:set var="user_status" value="${rset_controllo.rows[0].ID_stato}" scope="session"/>
  <c:set var="user_nome"   value="${rset_controllo.rows[0].Nome}"  scope="session"/>
  <c:set var="user_cognome"   value="${rset_controllo.rows[0].Cognome}"  scope="session"/>
  <c:set var="user_CF"   value="${rset_controllo.rows[0].CF}"  scope="session"/>
  <c:set var="user_data"   value="${rset_controllo.rows[0].data_nascita}"  scope="session"/>
  <jsp:forward page="dispatch_home.jsp"/>
</c:if>

  

<c:set var="errmsg" scope="request">Credenziali errate: riprovare</c:set>
<jsp:forward page="login.jsp"/>