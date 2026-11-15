<%@ page session="true" language="java" 
         contentType="text/html; charset=UTF-8" import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<c:if test="${empty param.data_certificazione ||
              empty param.numero_albo ||
              empty param.messaggio_presentazione}">
  <c:set var="errmsg" scope="request">Tutti i campi sono obbligatori</c:set>
  <jsp:forward page="compilazione_scheda_professionale.jsp"/>
</c:if>


<sql:query var="rset_controllo_scheda_professionale">
SELECT ID_utente
  FROM Schede_Professionali
 WHERE ID_utente = ?
 <sql:param value="${user.ID}"/>
</sql:query>


<c:if test="${rset_controllo_scheda_professionale.rowCount == 0}">
<sql:update var="riga_scheda_professionale">
INSERT INTO Schede_Professionali (ID_utente, Presentazione, data_certificazione, numero_albo)
VALUES (?, ?, ?, ?)
  <sql:param value="${user.ID}"/>
  <sql:param value="${param.messaggio_presentazione}"/>
  <sql:param value="${param.data_certificazione}"/>
  <sql:param value="${param.numero_albo}"/>
</sql:update>

<sql:update var="riga_scheda_professionale">
UPDATE Utenti
SET ID_Stato = 2
WHERE ID = ?
  <sql:param value="${user.ID}"/>
</sql:update>
<jsp:forward page="dispatch_home.jsp"/>
<c:set target="${user}" property="ID_stato" value="2"/>
<c:set target="${user}" property="Stato" value="Attivo"/>
</c:if>

<sql:update var="riga_scheda_professionale">
UPDATE Schede_Professionali
SET Presentazione = ?, data_certificazione = ?, numero_albo = ?
WHERE ID_utente = ?
  <sql:param value="${param.messaggio_presentazione}"/>
  <sql:param value="${param.data_certificazione}"/>
  <sql:param value="${param.numero_albo}"/>
  <sql:param value="${user.ID}"/>
</sql:update>


<jsp:forward page="dispatch_home.jsp"/>