<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>

<c:choose>

    <c:when test="${empty user || user.Ruolo != 'PZ'}">
        <jsp:forward page="login.jsp"/>
    </c:when>

    <c:otherwise>
        <c:if test="${empty param.pasto || empty param.id_pagina || empty param.id_alimento}">
            <jsp:forward page="pagina_diario.jsp"/>
        </c:if>

        <sql:query var="data_pagina">
            SELECT p.Data_pagina
            FROM Pagine_Diario p
            WHERE p.id_pagina = ?
            <sql:param value="${param.id_pagina}"/>
        </sql:query>
        <fmt:parseDate value="${data_pagina.rows[0].Data_pagina}" pattern="yyyy-MM-dd" var="page_date" />

        <sql:query var="alimento">
            SELECT *
            FROM Alimenti
            WHERE id = ?
            <sql:param value="${param.id_alimento}"/>
        </sql:query>
        <c:set var="alimento" value="${alimento.rows[0]}"/>


        <tr>
            <td align="center">

                <h1>Inserimento porzione </h1>
                <h6>${param.pasto} del ${page_date}</h6>

                <br>
                <h4>${alimento.alimento}</h4>
                <h5>Valori per 100 ${alimento.liquido ? 'ml' : 'g'}</h5>
                <table>
                    <tr>
                        <td colspan="4" width= "100%">
                            <div class="legenda-pb">
                                <div class="legenda-pb-item"><span class="dot bg-carb"></span> Carb.</div>
                                <div class="legenda-pb-item"><span class="dot bg-grassi"></span> Grassi</div>
                                <div class="legenda-pb-item"><span class="dot bg-proteine"></span> Proteine</div>
                            </div>
                            <c:set var="per_carb" value="${alimento.glucidi * 400/ alimento.energia}"/>
                            <c:set var="per_grassi" value="${alimento.lipidi * 900/ alimento.energia}"/>
                            <c:set var="per_proteine" value="${alimento.proteine * 400/ alimento.energia}"/>

                            <div class="progress-bar">
                                <div class="bg-carb" style="width: ${per_carb};"></div>
                                <div class="bg-grassi" style="width: ${per_grassi};"></div>
                                <div class="bg-proteine" style="width: ${per_proteine};"></div>
                            </div>
                            <div class="macro-percentuali">
                                <span>${per_carb}%</span>
                                <div class="macro-percentuali-destra">
                                    <span>${per_grassi}%</span>
                                    <span>${per_proteine}%</span>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-center">
                            ${alimento.enegia}
                        </td>
                        <td class="text-center">
                            ${alimento.proteine}
                        </td>
                        <td class="text-center">
                            ${alimento.lipidi}
                        </td>
                        <td class="text-center">
                            ${alimento.glucidi}
                        </td>
                    </tr>
                    <tr>
                        <td colspan=4>
                            <form action="compilazione_porzione.jsp" method="GET">
                                <input type="hidden" id="pasto" name="pasto" value="${param.pasto}">
                                <input type="hidden" id="id_pagina" name="id_pagina" value="${param.id_pagina}">
                                <input type="hidden" id="id_alimento" name="id_alimento" value="${param.id_alimento}">
                                <label>
                                    Quantita'(${alimento.liquido ? 'ml' : 'g'}):
                                    <input type="number" name="quantita" step="0.1" min="0" max="500000" placeholder="${param.quantita}" value="${param.quantita}" required onchange="this.form.submit()">
                                </label>
                                <input type="reset" class="submit-btn-small" value="Reset">
                            </form>
                        </td>
                    </tr>
                    <tr>
                        <td colspan=4><h5>Valori per ${param.quantita} ${alimento.liquido ? 'ml' : 'g'}</h5></td>
                    </tr>
                    <tr>
                        <td class="text-center">
                            ${alimento.enegia *param.quantita}
                        </td>
                        <td class="text-center">
                            ${alimento.proteine *param.quantita}
                        </td>
                        <td class="text-center">
                            ${alimento.lipidi*param.quantita}
                        </td>
                        <td class="text-center">
                            ${alimento.glucidi*param.quantita}
                        </td>
                    </tr>
                    <tr>
                        <td colspan=4>
                            <form action="a_pagina_diario.jsp" method="POST" style="display:inline-flex; align-items:center; gap:8px; flex-wrap:wrap;">
                                <input type="hidden" id="action" name="action" value="insert_porzione">
                                <input type="hidden" id="pasto" name="pasto" value="${param.pasto}">
                                <input type="hidden" id="id_pagina" name="id_pagina" value="${param.id_pagina}">
                                <input type="hidden" id="id_alimento" name="id_alimento" value="${param.id_alimento}">
                                <input type="hidden" id="quantita" name="quantita" value="${param.quantita}">
                                <input type="submit" class="submit-btn-small" value="conferma">
                            </form>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%@ include file="layout_bottom.jspf" %>
    </c:otherwise>
</c:choose>