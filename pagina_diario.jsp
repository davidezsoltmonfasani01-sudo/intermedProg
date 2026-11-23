<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<c:if test="${empty user}">
    <jsp:forward page="login.jsp"/>

    <%--Al momento faccio che la può vedere solo il paziente (non ci sono tutti i contolli kc se è associato etc)--%>
    <c:if test="${user.ruolo != 'PZ'}">
        <jsp:forward page="a_dispact_home.jsp"/>
        <c:if>
        </c:if>

        <c:set var=PZ value="user">

            <%@ include file="layout_top.jspf" %>
            <%@ include file="navbar_nouser.jspf" %>

            <tr valign="top">
                <td align="center">
                    <h1>Diario Alimetare di ${PZ.nome} ${PZ.Cognome} del: <fmt:formatDate var="page_date"
                        value="${page_date}"
                        pattern="dd MMMM yyyy"/></h1>
                        <form action="pagina_diario.jsp" metod="GET">
                          <input type="date" id="data_nascita" name="data_nascita"
                                                 required>
                                                 <input type="submit" value="Crea Account"
                                                style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px; cursor: pointer;">
                        </form>
                        <table>
                            <tr>
                                <td>
                                    <p>Hai <strong>${notifiche.rowCount}</strong> notifiche.</p>
                                </td>
                                <td>

                                    <form action="a_notifiche.jsp" method="post">
                                        <input type="hidden" name="user_ID" value="${user.ID}" />

                                        <button class="card" type="submit" title="Elimina tutte le notifiche" value="all_delete" name="all_action">
                                            Elimina tutte
                                        </button>

                                        <c:if test="${not_viewed_n.rows[0].not_viewed_count > 0}">
                                            <button class="card" type="submit" title="Segna tutte come lette" value="all_s_as_view" name="all_action">
                                                Segna tutte come lette
                                            </button>

                                            <c:choose>
                                                <c:when test="${not empty vAll && vAll == 'false'}">
                                                    <button class="card" type="submit" name="vAll" value="true" title="Visualizza tutte le notifiche">
                                                        Visualizza tutte
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="card" type="submit" name="vAll" value="false" title="Visualizza solo non lette">
                                                        Visualizza solo non lette
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </form>
                                </td>
                            </tr>

                            <tr>
                                <td align="center" colspan="2">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Data e ora</th>
                                                <th>Tipo</th>
                                                <th>Messaggio</th>
                                                <th>Azioni</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="n" items="${notifiche.rows}">
                                                <tr class="${n.ID_stato == '11' ? 'nNon_letta' : (n.ID_stato == '10' ? 'nLetta' : '')}">
                                                    <td>${n.Data_ora}</td>
                                                    <td>${n.Descrizione}</td>
                                                    <td>${n.Messaggio}</td>
                                                    <td>

                                                        <form action="a_notifiche.jsp" method="post" style="display:flex; gap:8px;">
                                                            <input type="hidden" name="id" value="${n.ID_notifica}" />
                                                            <input type="hidden" name="risorsa" value="${n.Risorsa}" />
                                                            <input type="hidden" name="vAll" value="${vAll}" />

                                                            <button class="card" type="submit" name="action" value="s_read" title="Segna come letto"
                                                            style="${n.ID_stato != '11' ? 'visibility: hidden;' : ''}"
                                                            ${n.ID_stato != '11' ? 'disabled' : ''}>
                                                            Segna come letto
                                                        </button>



                                                        <button class="card btn-icona" type="submit" name="action" value="delete" title="Elimina notifica">
                                                            <img src="delete.svg" alt="Elimina" width="32" height="32">
                                                        </button>

                                                        <button class="card btn-icona" type="submit" name="action" value="GoTo" title="Vai alla risorsa">
                                                            <img src="GoTo.svg" alt="Vai" width="32" height="32">
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <%@ include file="layout_bottom.jspf" %>
