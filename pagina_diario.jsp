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

<c:choose>
    <c:when test="${not empty param.page_date}">
        <fmt:parseDate value="${param.page_date}" pattern="yyyy-MM-dd" var="page_date" />
    </c:when>
    <c:otherwise>

        <c:set var="page_date" value="${dateTime_oggi}" />
    </c:otherwise>
</c:choose>

<c:choose>
    <%--CASO PAGINA APERTA DAL PAZIENTE PROPRIETARIO DELLA PAGINA--%>
    <c:when  test="${user.ruolo == 'PZ'}">
        <c:set var="PZ" value="${user}" />
        <%@ include file="navbar_pz.jspf" %>
        <tr valign="top">
            <td align="center">
                <h1>
                    Diario Alimentare di ${PZ.nome} ${PZ.cognome} del:
                    <fmt:formatDate value="${page_date}" pattern="dd MMMM yyyy"/>
                </h1>
                <form action="pagina_diario.jsp" method="GET">
                    <input type="date" id="page_date" name="page_date" required>
                    <input type="submit" value="Vai alla data"
                    class="submit-btn">
                </form>
                <%--RICERCO I VALORI DELLA PAGINA SE ESISTE--%>
                <sql:query var="d_info">
                    SELECT *
                    FROM Pagine_Diario pd
                    WHERE ID_pz = ?
                    <sql:param value="${PZ.id}" />
                </sql:query>
                <sql:query var="d_visita">
                    SELECT v.*, pr.Data_visita
                    FROM Visite v
                    INNER JOIN Prenotazioni pr ON pr.ID_prenotazione = v.ID_prenotazione
                    WHERE pr.ID_pz = ?
                    AND pr.Data_visita <= ?
                    AND v.id_stato= 8
                    ORDER BY pr.Data_visita DESC
                    LIMIT 1
                    <sql:param value="${PZ.id}" />
                    <sql:dateParam value="${page_date}" type="date" />
                </sql:query>
                <%--questa cosa mi sa molto da azione da fare in una pagina di action sinceramente--%>
                <%--SE NON ESISTE --%>
                <c:choose>

                    <c:when test="${d_info.rowCount == 0}">
                        <%--RICERCO SE L'UTENTE HA EFFETTUATO VISITE, E SE SI PRENDO I DATI DELLA VISITA CORRISPETTIVA ALLA DATA SCELTA, ALTRIMENTI STAMPO UN MESSAGGIO--%>


                        <c:choose>
                            <c:when test="${d_visita.rowCount == 0}">
                                <h3>
                                    La data selezionata non ha una visita associata con referto completato, se non hai ancora fatto visite
                                    prenotane una
                                </h3>
                                <a href="lista_schede_professionali_mn.jsp">Prenota</a>
                            </c:when>
                            <c:otherwise>

                                <%--Reinderizzo alla action per creare la pagina ma il metodo post lo so fare --%>
                                <sql:update>
                                    INSERT INTO Pagine_Diario (ID_pz, ID_visita, Data_pagina, ID_stato) VALUES
                                    (?,?,?, 14);
                                    <sql:param value="${PZ.id}" />
                                    <sql:param value="${d_visita.rows[0].ID_visita}" />
                                    <sql:dateParam value="${page_date}" type="date" />
                                </sql:update>
                                <jsp:forward page="pagina_diario.jsp">

                                    <jsp:param name="page_date" value="${page_date}"/>
                                </jsp:forward>

                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    <c:otherwise>
                        <c:set var="d_visita" value="${d_visita.rows[0]}"/>
                        <c:set var="d_info" value="${d_info.rows[0]}"/>
                        <%--stampo il contenuto della pagina --%>
                        <table>
                            <thead>
                                <th>
                                    <a href="v_referto.jsp">
                                        <img  class="img-btn"
                                        src="referto.png"
                                        title="Referto"
                                        alt="Referto">
                                    </a>
                                </th>
                                <th>
                                    <h3>Peso: <small>${d_info.Peso_giornaliero}</small></h3>
                                </th>
                                <th>
                                    <form method="POST" action="a_pagina_diario.jsp">
                                        <input type="hidden" name="id_page" value="${d_info.id_pagina}">
                                        <input type="number" name="peso" step="0.1" min="0" max="500" placeholder="${d_visita.peso}" required>
                                        <input type="submit" value="aggiungi peso"  class="submit-btn-small">
                                    </form>
                                </th>
                                <th>
                                    <h3>BMI :
                                        <c:if test="${not empty d_info.Peso_giornaliero}">
                                            <small>${d_info.Peso_giornaliero/(d_visita.altezza *d_visita.altezza)}</small>
                                        </c:if>
                                    </h3>
                                </th>
                                <th>
                                    <a href="annotazioni.jsp?id_pagina=${d_info.ID_pagina}">
                                        <table>
                                            <tr>
                                                <sql:query var="n_annotazioni">
                                                    SELECT count(a.ID_annotazione) as n_annotazioni
                                                    FROM Annotazioni_Diario a
                                                    WHERE a.ID_pagina = ?
                                                    <sql:param value="${d_info.ID_pagina}"/>
                                                </sql:query>
                                                <td>
                                                    ${n_annotazioni.rows[0].n_annotazioni}
                                                </td>
                                                <td>
                                                    <img  class="img-btn"
                                                    src="annotazioni.svg"
                                                    title="Annotazioni"
                                                    alt="Referto">
                                                </td>
                                            </tr>
                                        </table>
                                    </a>
                                </th>
                            </thead>
                        </table>
                    </c:otherwise>

                </c:choose>







            </c:when>
            <c:otherwise>
                <jsp:forward page="v_pagina_diario.jsp"/>
            </c:otherwise>



        </c:choose>










    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>
