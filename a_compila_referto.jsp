<%@ page session="true" language="java" 
contentType="text/html; charset=UTF-8" import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>

<c:choose>

    <c:when test="${empty user || user.Ruolo != 'MN'}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:when test="${empty param.id_prenotazione}">
        <jsp:forward page="lista_visite.jsp"/>
    </c:when>

    <c:otherwise>

        <sql:query var="rset_prenotazione">
            SELECT ID_prenotazione
            FROM Prenotazioni
            WHERE ID_prenotazione = ?
            AND ID_mn = ?
            AND ID_stato = 7

            <sql:param value="${param.id_prenotazione}"/>
            <sql:param value="${user.ID}"/>
        </sql:query>

        <sql:query var="rset_visita">
            SELECT ID_visita
            FROM Visite
            WHERE ID_prenotazione = ?

            <sql:param value="${param.id_prenotazione}"/>
        </sql:query>

        <c:choose>

            <c:when test="${rset_prenotazione.rowCount == 0}">
                <h3>Prenotazione non valida</h3>
                <a href="lista_visite.jsp">Torna alla lista visite</a>
            </c:when>

            <c:when test="${rset_visita.rowCount != 0}">
                <h3>Il referto per questa visita esiste gia'</h3>
                <a href="v_referto.jsp?id_prenotazione=${param.id_prenotazione}">
                    Visualizza referto
                </a>
            </c:when>

            <c:otherwise>

                <sql:update>

                    INSERT INTO Visite
                    (
                        ID_prenotazione,
                        ID_stato,
                        Altezza,
                        Peso,
                        Apporto_calorico,
                        Grassi,
                        note,
                        Circonferenza_vita,
                        Anamnesi_prossima,
                        Anamnesi_alimentare,
                        Valutazione_esami_recenti,
                        Diagnosi,
                        Obiettivi,
                        Metabolismo_basale,
                        Proteine,
                        Carboidrati,
                        Idratazione,
                        Schema_alimentare,
                        Percentuale_Colazione,
                        Percentuale_Pranzo,
                        Percentuale_Cena,
                        Fabbisogno_energetico,
                        Data_firma
                    )
                    VALUES
                    (
                        ?,
                        11,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        NULLIF(?, ''),
                        dateTime_oggi
                    )

                    <sql:param value="${param.id_prenotazione}"/>
                    <sql:param value="${param.altezza}"/>
                    <sql:param value="${param.peso}"/>
                    <sql:param value="${param.apporto_calorico}"/>
                    <sql:param value="${param.grassi}"/>
                    <sql:param value="${param.note}"/>
                    <sql:param value="${param.circonferenza_vita}"/>
                    <sql:param value="${param.anamnesi_prossima}"/>
                    <sql:param value="${param.anamnesi_alimentare}"/>
                    <sql:param value="${param.valutazione_esami_recenti}"/>
                    <sql:param value="${param.diagnosi}"/>
                    <sql:param value="${param.obiettivi}"/>
                    <sql:param value="${param.metabolismo_basale}"/>
                    <sql:param value="${param.proteine}"/>
                    <sql:param value="${param.carboidrati}"/>
                    <sql:param value="${param.idratazione}"/>
                    <sql:param value="${param.schema_alimentare}"/>
                    <sql:param value="${param.percentuale_colazione}"/>
                    <sql:param value="${param.percentuale_pranzo}"/>
                    <sql:param value="${param.percentuale_cena}"/>
                    <sql:param value="${param.fabbisogno_energetico}"/>

                </sql:update>

                <sql:update>
                    UPDATE Prenotazioni
                    SET ID_stato = 8
                    WHERE ID_prenotazione = ?
                    AND ID_mn = ?
                    AND ID_stato = 7

                    <sql:param value="${param.id_prenotazione}"/>
                    <sql:param value="${user.ID}"/>
                </sql:update>

                <jsp:forward page="dettaglio_prenotazione.jsp">
                    <jsp:param name="id_prenotazione" 
                               value="${param.id_prenotazione}"/>
                </jsp:forward>

            </c:otherwise>

        </c:choose>

    </c:otherwise>

</c:choose>
	