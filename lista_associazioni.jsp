<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>
<%@ include file="navbar_ds.jspf" %>

<sql:query var="associazioni">
    SELECT Associazioni_KC_PZ.ID_associazione, ID_pz, ID_kc, Stati.Stato
    FROM Associazioni_KC_PZ, Stati
    WHERE Associazioni_KC_PZ.ID_stato = Stati.ID_stato
    and (ID_pz like ? or ID_kc like ?)
    ORDER BY Associazioni_KC_PZ.ID_associazione

    <sql:param value="%${param.cerca}%" />
    <sql:param value="%${param.cerca}%" />
</sql:query>

<tr>
    <td align="center" bgcolor="#f1f5f4">

        <br><br>

        <h2>Lista associazioni Paziente - Kitchen Coach</h2>

        <p>Visualizza e cerca tutte le associazioni, attive e concluse</p>
        <br><br>

        <form action="lista_associazioni.jsp" method="get">

            <input type="text" name="cerca" size="35"
                placeholder="Cerca per id di PZ o KC" value="${param.cerca}">

            <input type="submit" value="Cerca"
                style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 3px 16px; font-size: 13px; line-height: 1; cursor: pointer;">

            <a href="lista_associazioni.jsp">Mostra tutti</a>

        </form>

        <br><br>

        <table border="1" align="center" cellpadding="8">

            <tr bgcolor="#dce8e5">
                <th>Paziente</th>
                <th>Kitchen Coach</th>
                <th>Stato</th>
                <th>Dettagli</th>
            </tr>

            <c:forEach items="${associazioni.rows}" var="associazione">
                <sql:query var="Paziente">
                    SELECT CF
                    FROM Associazioni_KC_PZ, Utenti
                    WHERE Associazioni_KC_PZ.ID_pz = Utenti.ID
                    AND Utenti.ID = ?
                    <sql:param value="${associazione.ID_pz}" />
                </sql:query>
                <sql:query var="KitchenCoach">
                    SELECT CF
                    FROM Associazioni_KC_PZ, Utenti
                    WHERE Associazioni_KC_PZ.ID_kc = Utenti.ID
                    AND Utenti.ID = ?
                    <sql:param value="${associazione.ID_kc}" />
                </sql:query>



                <tr>

                    <td>${Paziente.rows[0].CF} </td>

                    <td>${KitchenCoach.rows[0].CF} </td>

                    <td> ${associazione.Stato}</td>

                    <td>
                        <a href="info_associazione.jsp?id_associazione=${associazione.ID_associazione}">
                        <img src="GoTo.svg" alt="Vai" height="40" width="50">  
                        </a>
                    </td>

                </tr>

            </c:forEach>

            <c:if test="${associazioni.rowCount == 0}">
                <tr>
                    <td colspan="4" align="center">
                        Nessuna associazione trovata
                    </td>
                </tr>
            </c:if>

        </table>

        <br><br>

    </td>
</tr>

<%@ include file="layout_bottom.jspf" %>