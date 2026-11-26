<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>
<%@ include file="layout_top.jspf" %>



<c:if test="${empty user}">
    <jsp:forward page="login.jsp"/>
</c:if>
<c:if test="${empty param.id_pagina}">
    <jsp:forward page="pagina_diario.jsp"/>
</c:if>
<sql:query var ="d_page_info">
    SELECT pg.Data_pagina, pg.ID_pz, u.nome, u.cognome
    FROM Pagine_Diario pg
    INNER JOIN Utenti u ON u.ID = pg.ID_pz
    WHERE pg.ID_pagina=?
    <sql:param value="${param.id_pagina}"/>
</sql:query>
<c:if test="${d_page_info.rowCount == 0}"> <%-- magari meglio da un altra parte --%>
    <jsp:forward page="pagina_diario.jsp"/>
</c:if>
<c:set var="d_page_info" value="${d_page_info.rows[0]}"/>
<%-- Definisco chi è il mettende e il destinatario in base al ruolo e faccio le query di conseguenza --%>
<tr valign="top">
    <td align="center">
        <table>
            <tr>
                <td class="back">
                    <a href="${user.ruolo == 'PZ' ? 'pagina_diario.jsp' : 'v_pagina_diario.jsp'}?id_pagina=${param.id_pagina}">
                        <img class="img-btn" src="back.svg" title="indetro" alt="indietro">
                    </a>
                </td>
                <td>
                    <h1>
                        Annotazioni del Diario Alimentare di ${d_page_info.nome} ${d_page_info.cognome} del:
                        <fmt:formatDate value="${d_page_info.Data_pagina}" pattern="dd MMMM yyyy"/>
                    </h1>
                </td>

            </tr>
        </table>
        <c:choose>
            <c:when test="${user.ruolo =='KC'}">
                <%-- controllo se è il KC ASSOCIATO --%>
                <sql:query var="associazione_KC_PZ">
                    SELECT a.*
                    FROM Associazioni_KC_PZ a
                    WHERE ID_kc = ?
                    AND ID_pz =?
                    AND data_fine is null
                    AND ID_stato = 2
                    <sql:param value="${user.ID}"/>
                    <sql:param value="${d_page_info.ID_pz}"/>
                </sql:query>
                <c:if test="${associazione_KC_PZ.rowCount == 0}">
                    <jsp:forward page="dispatch.jsp"/>
                    <%-- da aggiungere msg d'errore mangari --%>
                </c:if>
                <c:set var="mittente" value="KC"/>
                <c:set var="destinatario" value="${d_page_info.ID_pz}"/>
                <%@ include file="annotazioni_chat.jspf" %>
                <%@ include file="annotazioni_new.jspf" %>
            </c:when>
            <c:otherwise>
                <c:set var="mittente" value="PZ"/>
                <c:choose>
                    <c:when test="${user.ruolo == 'PZ'}">
                        <sql:query var="destinatario">
                            SELECT a.ID_kc
                            FROM Associazioni_KC_PZ a
                            WHERE ID_pz = ?
                            AND data_fine is null
                            AND ID_stato = 2
                            <sql:param value="${user.ID}"/>
                        </sql:query>
                        <c:set var="destinatario" value="${destinatario.rows[0].ID_kc}"/>
                        <%@ include file="annotazioni_chat.jspf" %>
                        <%@ include file="annotazioni_new.jspf" %>
                    </c:when>
                    <c:otherwise>
                        <%-- da inserire controlli se il medico può vedere le cose o meno --%>
                        <%@ include file="annotazioni_chat.jspf" %>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>

    </td>
</tr >



<%@ include file="layout_bottom.jspf" %>
