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
    <c:when test="${param.action == 'set_weight'}">

    </c:when>
    <c:when test="${param.action == 'insert_porzione' && not empty param.pasto && not empty param.id_pagina && not empty param.id_alimento  && not empty param.quantita }">
        <c:set var="pasto_simbolo" value="${fn:substring(param.pasto, 0, 2)}"/>
        <c:if test="${pasto_simbolo == 'Co' || pasto_simbolo == 'Pr'||pasto_simbolo == 'Ce'|| pasto_simbolo == 'Fu'}">
            <sql:update>
                INSERT INTO Porzioni (ID_alimento, Tipo_pasto, Quantita, ID_Pagina) VALUES
                (?,?,?,?)
                <sql:param value="${param.id_alimento}"/>
                <sql:param value="${pasto_simbolo}"/>
                <sql:param value="${param.quantita}"/>
                <sql:param value="${param.id_pagina}"/>
            </sql:update>
        </c:if>
        <sql:query var="page_date">
            SELECT p.Data_pagina
            FROM Pagine_Diario p
            WHERE  p.id_pagina = ?
            <sql:param value="${param.id_pagina}"/>
        </sql:query>
        <jsp:forward page="pagina_diario.jsp" >
            <jsp:param name="page_date" value="${page_date.rows[0].Data_pagina}" />
        </jsp:forward>
    </c:when>
    <c:otherwise>
        <jsp:forward page="pagina_diario.jsp?seiscemo=True"/>
            
    </c:otherwise>
</c:choose>
