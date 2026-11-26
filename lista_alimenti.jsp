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
        <c:if test="${empty param.pasto || empty param.id_pagina}">
            <jsp:forward page="pagina_diario.jsp"/>
        </c:if>
        <c:choose>
            <c:when test="${param.ordina == 'energia' || param.ordina == 'proteine' || param.ordina == 'lipidi' || param.ordina == 'glucidi' || param.ordina == 'liquido' || param.ordina == 'alimento'}">
                <c:set var="colonnaOrdine" value="${param.ordina}" />
            </c:when>
            <c:otherwise>
                <c:set var="colonnaOrdine" value="alimento" />
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${param.sort == 'ASC'}">
                <c:set var="versoOrdine" value="ASC" />
            </c:when>
            <c:otherwise>
                <c:set var="versoOrdine" value="DESC" />
            </c:otherwise>
        </c:choose>


        <sql:query var="set_alimenti">
            SELECT *
            FROM Alimenti
            WHERE alimento LIKE ?
            <sql:param value="%${param.cerca}%"/>
            <c:if test="${param.onlyliquid == '1'}">
                AND liquido = 1
            </c:if>
            ORDER BY ${colonnaOrdine} ${versoOrdine}
        </sql:query>


        <tr>
            <td align="center">

                <h1>Lista Alimenti</h1>

                <br>

                <form action="lista_alimenti.jsp" method="get" style="display:inline-flex; align-items:center; gap:8px; flex-wrap:wrap;">
                    <input type="hidden" id="pasto" name="pasto" value="${param.pasto}">
                    <input type="hidden" id="id_pagina" name="id_pagina" value="${param.id_pagina}">

                    <input type="text"
                    name="cerca"
                    size="35"
                    placeholder="Cerca nome alimento"
                    value="${param.cerca}"
                    onchange="this.form.submit()">

                    <label>
                        <input type="checkbox" name="onlyliquid" value="1" ${param.onlyliquid == '1' ? 'checked' : ''} onchange="this.form.submit()">
                        Solo liquidi
                    </label>

                    <select name="ordina" onchange="this.form.submit()">
                        <option value="alimento" ${colonnaOrdine == 'alimento' ? 'selected' : ''}>--Alimento--</option>
                        <option value="energia" ${colonnaOrdine == 'energia' ? 'selected' : ''}>--Energia--</option>
                        <option value="proteine" ${colonnaOrdine == 'proteine' ? 'selected' : ''}>--Proteine--</option>
                        <option value="lipidi" ${colonnaOrdine == 'lipidi' ? 'selected' : ''}>--Grassi--</option>
                        <option value="glucidi" ${colonnaOrdine == 'glucidi' ? 'selected' : ''}>--Carboidrati--</option>
                        <option value="liquido" ${colonnaOrdine == 'liquido' ? 'selected' : ''}>--Liquido--</option>
                    </select>

                    <button type="submit" name="sort" value="${versoOrdine == 'ASC' ? 'DESC' : 'ASC'}" class="img-btn">
                        <img src="${versoOrdine == 'ASC' ? 'up.svg' : 'down.svg'}" alt="Ordina">
                    </button>

                    <a href="lista_alimenti.jsp?pasto=${param.pasto}&id_pagina=${param.id_pagina}" class="submit-btn-small">lista di default</a>
                </form>


                <br><br>
                <div class="big-scrollable-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Alimento</th>
                                <th>Energia</th>
                                <th>Proteine (g)</th>
                                <th>Grassi (g)</th>
                                <th>Carboidrati (g)</th>
                                <th>Liquido (SI/NO)</th>
                                <th>Inserisci</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="alimento" items="${set_alimenti.rows}">
                                <tr>
                                    <td>${alimento.alimento}</td>
                                    <td>${alimento.energia}</td>
                                    <td>${alimento.proteine}</td>
                                    <td>${alimento.lipidi}</td>
                                    <td>${alimento.glucidi}</td>
                                    <td class="text-center">${alimento.liquido ? 'SI' : 'NO'}</td>
                                    <td class="text-center">
                                        <a href="compilazione_porzione.jsp?pasto=${param.pasto}&id_pagina=${param.id_pagina}&id_alimento=${alimento.id}">
                                            <img src="GoTo.svg" alt="Vai" class="img-btn">
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        <%@ include file="layout_bottom.jspf" %>
    </c:otherwise>
</c:choose>