<%@ page session="true"
language="java"
contentType="text/html; charset=UTF-8"
import="java.sql.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>
<c:choose>
        <c:when test="${ user.ID_stato == 2}">
            <jsp:include page="navbar_pz.jspf" />
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" bgcolor="#124f49">
                    <table width="100%" border="0" cellpadding="12" cellspacing="0">
                        <tr align="center">
                            <td><a href="index.jsp"
                                    style="color: white;"><b>Home</b></a></td>
                            <td><a href="logout.jsp"
                                    style="color: white;"><b>Logout</b></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
           </thead>
        </c:otherwise>
    </c:choose>



    <sql:query var="rset_kc">
      SELECT Utenti.ID, CF, Cognome, Nome, Data_Nascita
      FROM Utenti, Schede_Professionali
      WHERE Ruolo='KC'
      AND Utenti.ID = ID_utente
      AND ID_stato= 2
      AND (Cognome LIKE ?
      OR Nome LIKE ?)
      ORDER BY Cognome, Nome

      <sql:param value="%${param.cerca}%"/>
      <sql:param value="%${param.cerca}%"/>
    </sql:query>

    <tr>
      <td align="center" bgcolor="#f1f5f4">

        <br><br>

        <h2>Lista Kitchen Coach Disponibili</h2>

        <p>Visualizza e cerca i Kitchen Coach registrati</p>

        <c:if test="${user.ID_stato == 3}">
          <b>Seleziona un Kitchen Coach per sbloccare le altre funzionalita'</b>
        </c:if>
        <br><br>

        <form action="lista_schede_professionali_kc.jsp" method="get">

          <input type="text"
                 name="cerca"
                 size="35"
                 placeholder="Cerca per cognome o nome"
                 value="${param.cerca}">

          <input type="submit" value="Cerca" style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 3px 16px; font-size: 13px; line-height: 1; cursor: pointer;">

          <a href="lista_schede_professionali_kc.jsp">Mostra tutti</a>

        </form>

        <br><br>

        <table border="1" align="center" cellpadding="8">

          <tr bgcolor="#dce8e5">
            <th>Cognome</th>
            <th>Nome</th>
            <th>Data di nascita</th>
            <th>Dettagli</th>
          </tr>

          <c:forEach items="${rset_kc.rows}" var="kc">

            <tr>

              <td>${kc.Cognome}</td>

              <td>${kc.Nome}</td>

              <td>${kc.Data_Nascita}</td>          

              <td>
                <a href="v_scheda_professionale_kc.jsp?ID_kc=${kc.ID}">
                  Visualizza
                </a>
              </td>
            </tr>

          </c:forEach>

          <c:if test="${rset_kc.rowCount == 0}">
            <tr>
              <td colspan="4" align="center">
                Nessun Kitchen Coach trovato
              </td>
            </tr>
          </c:if>

        </table>

        <br><br>

      </td>
    </tr>

<%@ include file="layout_bottom.jspf" %>

