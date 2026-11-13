<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*, java.util.*" %>

<%@ taglib uri="http://sun.com" prefix="c" %>
<%@ taglib uri="http://sun.com" prefix="sql" %>

<%-- Recupero i parametri inviati dai form di notifiche.jsp --%>
<c:set var="action" value="${param.action}" />
<c:set var="all_action" value="${param.all_action}" />
<c:set var="id_notifica" value="${param.id}" />
<c:set var="risorsa" value="${param.risorsa}" />
<c:set var="user_username" value="${param.user_username}" />

<%-- Gestione delle azioni singole e globali --%>
<c:choose>
    

    <c:when test="${action == 'GoTo'}">
       
        <sql:update>
            UPDATE Notifiche SET ID_stato = '10' WHERE ID_notifica = ?
            <sql:param value="${id_notifica}" />
        </sql:update>
        
       
        <c:choose>
            <c:when test="${not empty risorsa}">
                <c:redirect url="${risorsa}.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:forward page="notifiche.jsp" />
            </c:otherwise>
        </c:choose>
    </c:when>


    <c:when test="${action == 's_read'}">
        <sql:update>
            UPDATE Notifiche SET ID_stato = '10' WHERE ID_notifica = ?
            <sql:param value="${id_notifica}" />
        </sql:update>
        <jsp:forward page="notifiche.jsp" />
    </c:when>

  
    <c:when test="${action == 'delete'}">
        <sql:update>
            DELETE FROM Notifiche WHERE ID_notifica = ?
            <sql:param value="${id_notifica}" />
        </sql:update>
        <jsp:forward page="notifiche.jsp" />
    </c:when>

    
    <c:when test="${all_action == 'all_delete'}">
        <sql:update>
            DELETE FROM Notifiche 
            WHERE CF = (SELECT CF FROM Utenti WHERE Username = ?)
            <sql:param value="${user_username}" />
        </sql:update>
        <jsp:forward page="notifiche.jsp" />
    </c:when>

    <%-- 5. SEGNA TUTTE COME LETTE --%>
    <c:when test="${all_action == 'all_s_as_view'}">
        <sql:update>
            UPDATE Notifiche SET ID_stato = '10' 
            WHERE CF = (SELECT CF FROM Utenti WHERE Username = ?) AND ID_stato = '11'
            <sql:param value="${user_username}" />
        </sql:update>
        <jsp:forward page="notifiche.jsp" />
    </c:when>

    <%-- 6. DEFAULT / CAMBIO FILTRO (Visualizza tutte / solo non lette) --%>
    <c:otherwise>
        <jsp:forward page="notifiche.jsp" />
    </c:otherwise>

</c:choose>
