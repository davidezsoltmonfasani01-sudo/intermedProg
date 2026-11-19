<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>



<c:choose>
    <c:when test="${not empty param.id_kc and not empty user.ID}">
     <c:if test="${empty param.messaggio_motivazione}">
                <c:set var="errmsg" value="Inserisci un messaggio di motivazione per dissociare il kitchen coach." scope="request"/>
                <jsp:forward page="kc_associato.jsp"/>
            </c:if>   
                <sql:update var="termina_associazione">
                    UPDATE Associazioni_KC_PZ 
                    SET data_fine = CURDATE(),
                    motivazione = ?, ID_stato = 9
                    where ID_pz = ? AND ID_kc = ? AND data_fine is null
                    <sql:param value="${param.messaggio_motivazione}"/>
                    <sql:param value="${user.ID}"/>
                    <sql:param value="${param.id_kc}"/>
                </sql:update>
              <sql:update var="righe_modificate">
                    UPDATE Utenti
                    SET ID_stato = 3
                    WHERE ID = ?
                    <sql:param value="${user.ID}"/>
                </sql:update>
				
         
                <jsp:forward page="lista_schede_professionali_kc.jsp"/>
            

    </c:when>
    <c:otherwise>
        <jsp:forward page="dispatch_home.jsp"/>
    </c:otherwise>
</c:choose>

