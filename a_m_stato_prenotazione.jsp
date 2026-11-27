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

    <c:when test="${empty user}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:when test="${empty param.id_prenotazione}">
        <jsp:forward page="lista_visite.jsp"/>
    </c:when>

    <c:when test="${user.Ruolo == 'MN' && param.azione == 'accetta'}">

        <sql:update>
            UPDATE Prenotazioni
            SET ID_stato = 4
            WHERE ID_prenotazione = ?
            AND ID_mn = ?
            AND ID_stato = 12

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:update>

        <jsp:forward page="dettaglio_prenotazione.jsp">
            <jsp:param name="id_prenotazione" value="${param.id_prenotazione}"/>
        </jsp:forward>

    </c:when>

    <c:when test="${user.Ruolo == 'MN' && param.azione == 'rifiuta'}">

        <sql:update>
            UPDATE Prenotazioni
            SET ID_stato = 6
            WHERE ID_prenotazione = ?
            AND ID_mn = ?
            AND ID_stato = 12

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:update>

        <jsp:forward page="dettaglio_prenotazione.jsp">
            <jsp:param name="id_prenotazione" value="${param.id_prenotazione}"/>
        </jsp:forward>

    </c:when>


    <c:when test="${user.Ruolo == 'MN' && param.azione == 'effettuata'}">

        <sql:update>
            UPDATE Prenotazioni
            SET ID_stato = 7
            WHERE ID_prenotazione = ?
            AND ID_mn = ?
            AND ID_stato = 4

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:update>

        <jsp:forward page="dettaglio_prenotazione.jsp">
            <jsp:param name="id_prenotazione" value="${param.id_prenotazione}"/>
        </jsp:forward>

    </c:when>


    <c:when test="${param.azione == 'annulla'}">

        <sql:update>
            UPDATE Prenotazioni
            SET ID_stato = 5
            WHERE ID_prenotazione = ?
            AND ID_pz = ?
            AND ID_stato IN (4, 12)

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:update>

        <jsp:forward page="dettaglio_prenotazione.jsp">
            <jsp:param name="id_prenotazione" value="${param.id_prenotazione}"/>
        </jsp:forward>

    </c:when>


    <c:otherwise>
        <jsp:forward page="lista_visite.jsp"/>
    </c:otherwise>

</c:choose>
