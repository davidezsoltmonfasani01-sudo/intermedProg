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
        
        <sql:query var="Controllo_kc">
            SELECT ID_kc, data_inizio
            FROM Associazioni_KC_PZ
            WHERE ID_pz = ?
            AND data_fine IS NULL
            AND ID_stato = 2
            <sql:param value="${user.ID}"/>
        </sql:query>

        <c:choose>
            
            <c:when test="${Controllo_kc.rowCount > 0}">
                <c:set var="errmsg" value="Hai gia' un Kitchen Coach associato. Per associarne un altro, devi prima disassociare quello attuale." scope="request"/>
                <jsp:forward page="kc_associato.jsp"/>
            </c:when>

            <c:otherwise>
                <sql:update var="associazione">
                    INSERT INTO Associazioni_KC_PZ (ID_pz, ID_kc, data_inizio, data_fine, ID_stato, motivazione)
                    VALUES (?, ?, CURDATE(), NULL, 2, NULL)
                    <sql:param value="${user.ID}"/>
                    <sql:param value="${param.id_kc}"/>
                </sql:update>
              <sql:update var="righe_modificate">
                    UPDATE Utenti
                    SET ID_stato = 2
                    WHERE ID = ?
                    <sql:param value="${User.ID}"/>
                </sql:update>
				
         
                <jsp:forward page="kc_associato.jsp"/>
            </c:otherwise>
        </c:choose>

    </c:when>
    <c:otherwise>
        <jsp:forward page="lista_schede_professionali_kc.jsp"/>
    </c:otherwise>
</c:choose>

