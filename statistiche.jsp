<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<!--Pagina dedicata alla Direzione Sanitaria (DS) per il monitoraggio dell'utilizzo della piattaforma,
                suddivisa tra dati globali e metriche per singolo utente: permette di visualizzare il numero totale di
                visite effettuate (e il parziale per ciascun Medico Nutrizionista), il totale delle pagine del Diario
                Alimentare compilate (con il dettaglio per singolo Paziente), il numero totale di annotazioni inserite
                (suddivise anche per singolo Kitchen Coach) e lo storico completo delle operazioni di sostituzione dei
                Kitchen Coach con le relative motivazioni addotte dai pazienti-->
<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_nouser.jspf" %>

<tr valign="top">
    <td align="center">
    
        <table>
                    <tr>
                    <td>
                    <table>
                    </table>
                    </td>
                    <form action="a_statisiche.jsp" method="get">
      
                        <td>
                            <p>Hai <strong>${notifiche.rowCount}</strong> notifiche.</p>
                        </td>
                        <td>
                           
                            
                               
                                
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
                                        <th>Data</th>
                                        <th>Tipo</th>
                                        <th>Messaggio</th>
                                        <th>Azioni</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="n" items="${notifiche.rows}">
                                        <tr class="${n.ID_stato == '11' ? 'nNon_letta' : (n.ID_stato == '10' ? 'nLetta' : '')}">
                                            <td>${n.Data}</td>
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
                </c:otherwise>
            </c:choose>
        </table>
    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>
