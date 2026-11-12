<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*, java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_nouser.jspf" %>
<tr valign="top">
    <td>
        <table>
            <tr>
                <td  align="center">
                    <c:set var="user_CF" value="1111111111111111" />
                    <sql:query var="notifiche">
                        SELECT n.ID_notifica, n.Data, t.Messaggio, n.ID_stato , t.Descrizione, s.Stato
                        FROM Notifiche n
                        INNER JOIN Tipi_Notifiche t ON n.ID_tipo = t.ID_tipo
                        INNER JOIN Stati s ON n.ID_stato = s.ID_stato
                        WHERE n.CF = ?
                        ORDER BY n.Data DESC
                        <sql:param value="${user_CF}" />
                    </sql:query>
                    <c:choose>
                        <c:when test="${notifiche.rowCount == 0}">
                            <p>Nessuna notifica presente.</p>
                        </c:when>
                        <c:otherwise>
                            <p>Hai <strong>${notifiche.rowCount}</strong> notifiche.</p>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Data</th>
                                        <th>Tipo</th>
                                        <th>Messaggio</th>
                                        <th>Stato</th>
                                        <th colspan="3">Azioni</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="n" items="${notifiche.rows}">
                                        <tr class="${n.ID_stato == '11' ? 'nNon_letta' : (n.ID_stato == '10' ? 'nLetta' : '')}">
                                            <td class="card">${n.Data}</td>
                                            <td class="card">${n.Descrizione}</td>
                                            <td class="card">${n.Messaggio}</td>

                                            <form  action="a_notifiche.jsp" method="post">
                                                <input type="hidden" name="id" value="${n.ID_notifica}" />
                                                <input type="hidden" name="risorsa" value="${n.Risorsa}" />



                                                <td>
                                                    <c:if test="${n.ID_stato == '11'}">
                                                        <button type="submit"  name="action" value="s_read" title="Segna come letto">
                                                            Segna come letto
                                                        </button>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <button type="submit"  name="action" value="delete" class="btn-icona" title="Elimina notifica">
                                                        <img src="delete.svg" alt="Elimina" width="32" height="32">
                                                    </button>
                                                </td>
                                                <td>
                                                    <button type="submit" name="action" value="GoTo" class="btn-icona" title="Vai alla risorsa">
                                                        <img src="GoTo.svg" alt="Vai" width="32" height="32">
                                                    </button>
                                                </td>

                                            </form>
                                        </tr>

                                    </c:forEach>

                                </tbody>
                            </table>

                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
    </td>
</tr>





<%@ include file="layout_bottom.jspf" %>
