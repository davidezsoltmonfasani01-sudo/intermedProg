<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<c:if test="${empty param.codice_fiscale ||
              empty param.nome           ||
              empty param.cognome        ||
              empty param.data_nascita   ||
              empty param.password       ||
              empty param.username}">
  <c:set var="errmsg" scope="request">Tutti i campi sono obbligatori</c:set>
  <jsp:forward page="registrazione_pz.jsp"/>
</c:if>

<c:if test="${fn:length(param.codice_fiscale) != 16}">
  <c:set var="errmsg" scope="request">Il Codice Fiscale deve essere esattamente di 16 caratteri</c:set>
  <jsp:forward page="registrazione_pz.jsp"/>
</c:if>


  

 
<sql:query var="rset_controllo_U">
SELECT Username
  FROM Utenti
 WHERE UPPER(Username) = ?
 <sql:param value="${fn:toUpperCase(param.username)}"/>
</sql:query>


  
<c:if test="${rset_controllo_U.rowCount > 0}">
  <c:set var="errmsg" scope="request">Questo Username risulta gia' registrato</c:set>
  <jsp:forward page="registrazione_pz.jsp"/>
</c:if>
 


<sql:update var="righe_inserite">
INSERT INTO Utenti (CF, Cognome, Nome, Data_Nascita, Password, ID_stato, Ruolo, Username)
VALUES (?, ?, ?, ?, ?, 1, 'PZ', ?)
  <sql:param value="${fn:toUpperCase(param.codice_fiscale)}"/>
  <sql:param value="${param.cognome}"/>
  <sql:param value="${param.nome}"/>
  <sql:param value="${param.data_nascita}"/>
  <sql:param value="${param.password}"/>
  <sql:param value="${param.username}"/>
</sql:update>

<sql:query var="rset_controllo">
SELECT ID, CF, Cognome, Nome, Data_Nascita, ID_stato, Ruolo, Username
  FROM Utenti
 WHERE Username = ?
 <sql:param value="${param.username}"/>
</sql:query>
 
<c:set var="user" value="${rset_controllo.rows[0]}" scope="session"/>
<c:set var="user_userid" value="${user.ID}" scope="session"/>
<c:set var="user_role"   value="PZ"  scope="session"/>
<c:set var="user_status"   value='1'  scope="session"/>


<jsp:forward page="dispatch_home.jsp"/>  