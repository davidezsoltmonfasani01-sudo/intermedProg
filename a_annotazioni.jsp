<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>
<fmt:requestEncoding value="UTF-8" />

<c:choose>

    <c:when test="${param.azione == 'nuova'}">
        <c:if test="${not empty param.nuovo_testo}">
            <sql:update>
                INSERT INTO Annotazioni_Diario (ID_pagina, ID_Scrittore, Testo, Data_Creazione)
                VALUES (?, ?, ?, ?)
                <sql:param value="${param.id_pagina}" />
                <sql:param value="${param.id_scrittore}" />
                <sql:param value="${param.nuovo_testo}" />
                <sql:param value="${dateTime_oggi}" />
            </sql:update>
            <sql:update>
                INSERT INTO Notifiche ( ID_risorsa, ID_tipo, ID_stato, Data_Ora, ID_utente)
                VALUES (?, 4, 11, ?,?)
                <sql:param value="${param.id_pagina}" />
                <sql:param value="${dateTime_oggi}" />
                <sql:param value="${param.destinatario}" />
            </sql:update>
        </c:if>
    </c:when>


    <c:when test="${param.azione == 'salva'}">
        <c:if test="${not empty param.nuovo_testo}">
            <sql:update>
                UPDATE Annotazioni_Diario
                SET Testo = ?, Data_ultima_modifica = ?
                WHERE ID_annotazione = ?
                <sql:param value="${param.nuovo_testo}" />
                <sql:param value="${param.id_annotazione}" />
                <sql:param value="${dateTime_oggi}" />
            </sql:update>
            <sql:update>
                INSERT INTO Notifiche ( ID_risorsa, ID_tipo, ID_stato, Data_Ora, ID_utente)
                VALUES (?, 5, 11, ?,?)
                <sql:param value="${param.id_pagina}" />
                <sql:param value="${dateTime_oggi}" />
                <sql:param value="${param.destinatario}" />
            </sql:update>
        </c:if>
    </c:when>
</c:choose>


<c:redirect url="annotazioni.jsp">
    <c:param name="id_pagina" value="${param.id_pagina}" />
</c:redirect>
