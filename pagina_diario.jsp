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

                        <table class="header-table">
                            <tr>
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
                                        <input type="submit" value="aggiungi peso"  class="submit-btn- small">
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
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">

                        <table class="legend-header-table">
                            <thead>
                                <th>
                                    <h2>Alimento</h2>
                                </th>
                                <th>
                                    <h2>Quantita'</h2>
                                    <p>(g)</p>
                                </th>
                                <th>
                                    <h2>Energia</h2>
                                    <p>(kcal)</p>
                                </th>
                                <th>
                                    <h2>Proteine</h2>
                                    <p>(g)</p>
                                </th>
                                <th>
                                    <h2>Grassi</h2>
                                    <p>(g)</p>
                                </th>
                                <th>
                                    <h2>Carboidrati</h2>
                                    <p>(g)</p>
                                </th>
                                <th>
                                    <h2>Acqua/Liquidi</h2>
                                    <p>(ml)</p>
                                </th>
                            </thead>
                        </table>
                        <c:set var="totale_Quantita" value="0" />
                        <c:set var="totale_Energia" value="0" />
                        <c:set var="totale_Proteine" value="0" />
                        <c:set var="totale_Grassi" value="0" />
                        <c:set var="totale_Carboidrati" value="0" />
                        <c:set var="totale_Liquidi" value="0" />
                        <c:forTokens items="Colazione,Pranzo,Cena,Fuori pasto" delims="," var="pasto">
                            <c:set var="pasto_simbolo" value="${fn:substring(pasto, 0, 2)}"/>
                            <table class="header-table">
                                <thead>
                                    <th>
                                        <a href="lista_alimenti.jsp?pasto=${pasto}">
                                            <img class="img-btn" src="add.svg" title="Aggiungi Porzione" alt="Aggiungi Porzione">
                                        </a>
                                    </th>
                                    <th>
                                        <h2>${pasto}</h2>
                                    </th>
                                </thead>
                            </table>
                            <sql:query var="composizione_pasto">
                                SELECT por.Quantita, al.*
                                FROM Porzioni por
                                INNER JOIN Alimenti al on al.id = por.ID_alimento
                                WHERE por.ID_Pagina = ? AND por.Tipo_pasto = ?
                                <sql:param value="${d_info.ID_pagina}"/>
                                <sql:param value="${pasto_simbolo}"/>
                            </sql:query>

                            <c:set var="totale_Quantita_p" value="0" />
                            <c:set var="totale_Energia_p" value="0" />
                            <c:set var="totale_Proteine_p" value="0" />
                            <c:set var="totale_Grassi_p" value="0" />
                            <c:set var="totale_Carboidrati_p" value="0" />
                            <c:set var="totale_Liquidi_p" value="0" />

                            <div class="scrollable-table">
                                <table>

                                    <c:forEach var="porzione" items="${composizione_pasto.rows}">
                                        <tr>
                                            <td>
                                                ${porzione.Alimento}
                                            </td>
                                            <td class="text-center">
                                                <c:set var="Quantita_p" value="${porzione.Quantita}"/>
                                                <c:set var="totale_Quantita_p" value="${totale_Quantita_p + Quantita_p}"/>
                                                ${Quantita_p}
                                            </td>
                                            <td class="text-center">
                                                <c:set var="Energia_p" value="${porzione.Energia * porzione.quantita}"/>
                                                <c:set var="totale_Energia_p" value="${totale_Energia_p + Energia_p}"/>
                                                ${Energia_p}
                                            </td>
                                            <td class="text-center">
                                                <c:set var="Proteine_p" value="${porzione.Proteine * porzione.quantita}"/>
                                                <c:set var="totale_Proteine_p" value="${totale_Proteine_p + Proteine_p}"/>
                                                ${Proteine_p}
                                            </td>
                                            <td class="text-center">
                                                <c:set var="Grassi_p" value="${porzione.lipidi * porzione.quantita}"/>
                                                <c:set var="totale_Grassi_p" value="${totale_Grassi_p + Grassi_p}"/>
                                                ${Grassi_p}
                                            </td>
                                            <td class="text-center">
                                                <c:set var="Carboidrati_p" value="${porzione.glucidi * porzione.quantita}"/>
                                                <c:set var="totale_Carboidrati_p" value="${totale_Carboidrati_p + Carboidrati_p}"/>
                                                ${Carboidrati_p}
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${porzione.Liquido == true}">
                                                        <c:set var="Liquidi_p" value="${porzione.quantita}"/>
                                                        <c:set var="totale_Liquidi_p" value="${totale_Liquidi_p + Liquidi_p}"/>
                                                        ${Liquidi_p}
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </div>
                            <table class="footer-table">
                                <tr class="totale_d">
                                    <td><strong>${pasto} Totale</strong></td>
                                    <td class="text-center"><strong>${totale_Quantita_p}</strong></td>
                                    <td class="text-center"><strong>${totale_Energia_p}</strong></td>
                                    <td class="text-center"><strong>${totale_Proteine_p}</strong></td>
                                    <td class="text-center"><strong>${totale_Grassi_p}</strong></td>
                                    <td class="text-center"><strong>${totale_Carboidrati_p}</strong></td>
                                    <td class="text-center"><strong>${totale_Liquidi_p}</strong></td>
                                </tr>
                                <c:if test="${pasto_simbolo != 'Fu'}">
                                    <c:set var="percentuale" value="percentuale_${pasto}" />
                                    <tr class="consigliato_d">
                                        <td>${pasto} consigliato</td>
                                        <td class="text-center">-</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${d_visita.apporto_calorico * d_visita[percentuale] / 100}" maxFractionDigits="0" groupingUsed="false" />
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${d_visita.Proteine * d_visita[percentuale] / 100}" maxFractionDigits="0" groupingUsed="false" />
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${d_visita.Grassi * d_visita[percentuale] / 100}" maxFractionDigits="0" groupingUsed="false" />
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${d_visita.Carboidrati * d_visita[percentuale] / 100}" maxFractionDigits="0" groupingUsed="false" />
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${d_visita.Idratazione * d_visita[percentuale] / 100}" maxFractionDigits="0" groupingUsed="false" />
                                        </td>
                                    </tr>
                                </c:if>
                            </table>
                            <c:set var="totale_Quantita" value="${totale_Quantita + totale_Quantita_p}" />
                            <c:set var="totale_Energia" value="${totale_Energia + totale_Energia_p}" />
                            <c:set var="totale_Proteine" value="${totale_Proteine + totale_Proteine_p}" />
                            <c:set var="totale_Grassi" value="${totale_Grassi + totale_Grassi_p}" />
                            <c:set var="totale_Carboidrati" value="${totale_Carboidrati + totale_Carboidrati_p}" />
                            <c:set var="totale_Liquidi" value="${totale_Liquidi + totale_Liquidi_p}" />
                        </c:forTokens>
                        <table class="header-table">
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <h2>Totale</h2>
                                </td>
                            </tr>
                        </table>
                        <table class="footer-table">
                            <tr class="totale_d">
                                <td>
                                    Totale Giornaliero
                                </td>
                                <td>
                                    ${totale_Quantita}
                                </td>
                                <td>
                                    ${totale_Energia}
                                </td>
                                <td>
                                    ${totale_Proteine}
                                </td>
                                <td>
                                    ${totale_Grassi}
                                </td>
                                <td>
                                    ${totale_Carboidrati}
                                </td>
                                <td>
                                    ${totale_Liquidi}
                                </td>
                            </tr>
                            <tr class="consigliato_d">
                                <td>Totale giornaliero consigliato</td>
                                <td class="text-center">-</td>
                                <td class="text-center">
                                    ${d_visita.apporto_calorico }
                                </td>
                                <td class="text-center">
                                    ${d_visita.Proteine}
                                </td>
                                <td class="text-center">
                                    ${d_visita.Grassi}
                                </td>
                                <td class="text-center">
                                    ${d_visita.Carboidrati}
                                </td>
                                <td class="text-center">
                                    ${d_visita.Idratazione}
                                </td>
                            </tr>

                        </table>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:when>
    <c:otherwise>
        <jsp:forward page="v_pagina_diario.jsp"/>
    </c:otherwise>
</c:choose>


<%@ include file="layout_bottom.jspf" %>
