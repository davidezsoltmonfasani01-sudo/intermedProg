<%@ page session="true" language="java"
         contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<c:choose>

    <c:when test="${empty user.ID || user.Ruolo != 'DS'}">
        <jsp:forward page="login.jsp"/>
    </c:when>


    <c:when test="${empty param.id_utente ||
                    (param.azione != 'accetta' &&
                     param.azione != 'rifiuta')}">

        <c:set var="errmsg" scope="request">
            Richiesta non valida.
        </c:set>
        <jsp:forward page="lista_richieste_pz.jsp"/>

    </c:when>

    <c:otherwise>


        <sql:query var="rset_controllo">
            SELECT ID
            FROM Utenti
            WHERE ID = ?
              AND Ruolo = 'PZ'
              AND ID_stato = 1
            <sql:param value="${param.id_utente}"/>
        </sql:query>

        <c:choose>


            <c:when test="${rset_controllo.rowCount != 1}">
                <c:set var="errmsg" scope="request">
                      Paziente non trovato o gia' gestito.
                </c:set>
                <jsp:forward page="lista_richieste_pz.jsp"/>
            </c:when>


            <c:when test="${param.azione == 'accetta'}">

                <sql:update var="righe_modificate">
                    UPDATE Utenti
                    SET ID_stato = 2
                    WHERE ID = ?
                      AND Ruolo = 'PZ'
                      AND ID_stato = 1
                    <sql:param value="${param.id_utente}"/>
                </sql:update>

                <c:choose>
                    <c:when test="${righe_modificate == 1}">
                        <c:set var="msg" scope="request">
                            Account del paziente attivato correttamente.
                        </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="errmsg" scope="request">
                            Non e' stato possibile attivare l'account.
                        </c:set>
                    </c:otherwise>
                </c:choose>

                <jsp:forward page="lista_richieste_pz.jsp"/>

            </c:when>


            <c:when test="${param.azione == 'rifiuta'}">

                <sql:update var="righe_eliminate">
                    DELETE FROM Utenti
                    WHERE ID = ?
                      AND Ruolo = 'PZ'
                      AND ID_stato = 1
                    <sql:param value="${param.id_utente}"/>
                </sql:update>

                <c:choose>
                    <c:when test="${righe_eliminate == 1}">
                        <c:set var="msg" scope="request">
                            Richiesta rifiutata. Il paziente e' stato eliminato definitivamente.
                        </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="errmsg" scope="request">
                            Non e' stato possibile eliminare il paziente.
                        </c:set>
                    </c:otherwise>
                </c:choose>

                <jsp:forward page="lista_richieste_pz.jsp"/>

            </c:when>

        </c:choose>

    </c:otherwise>

</c:choose>
