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
            <%@ include file="navbar_pz.jspf" %>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" bgcolor="#124f49" style="padding: 0;">
                    <nav class="menu-contenitore" aria-label="Navigazione principale">
                        <div class="menu-links">
                            <div class="menu-scrollabile">
                                <a href="index.jsp">Home</a>
                                <a href="lista_schede_professionali_mn.jsp">Elenco Medici Nutrizionisti</a>
                                <a href="lista_schede_professionali_kc.jsp">Elenco Kitchen Coach</a>
                            </div>
                            <div>
                                <a href="logout.jsp"><img  style="width: 45px; height: 45px;"
                                src="LogOut.svg"
                                title="logout"
                                alt="logout"></a>
                            </div>
                        </div>
                    </nav>
                </td>
            </tr>
            </thead>
        </c:otherwise>
    </c:choose>

    <sql:query var="rset_mn">
      SELECT ID, CF, Cognome, Nome, Data_Nascita
      FROM Utenti, Schede_Professionali
      WHERE Utenti.ID = ID_utente
      AND Ruolo='MN'
      AND ID_stato = 2
      AND (Cognome LIKE ?
      OR Nome LIKE ?)
      ORDER BY Cognome, Nome

      <sql:param value="%${param.cerca}%"/>
      <sql:param value="%${param.cerca}%"/>
    </sql:query>

    <tr>
      <td align="center" bgcolor="#f1f5f4">

        <br><br>

        <h2>Lista Medici Nutrizionisti Disponibili</h2>

        <p>Visualizza e cerca i Medici Nutrizionisti registrati</p>

        <br>

        <form action="lista_schede_professionali_mn.jsp" method="get">

          <input type="text"
                 name="cerca"
                 size="35"
                 placeholder="Cerca per cognome o nome"
                 value="${param.cerca}">

          <input type="submit" value="Cerca" style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 3px 16px; font-size: 13px; line-height: 1; cursor: pointer;">

          <a href="lista_schede_professionali_mn.jsp">Mostra tutti</a>

        </form>

        <br><br>

        <table border="1" align="center" cellpadding="8">

          <tr bgcolor="#dce8e5">
            <th>Cognome</th>
            <th>Nome</th>
            <th>Data di nascita</th>
            <th>Dettagli</th>
          </tr>

          <c:forEach items="${rset_mn.rows}" var="mn">

            <tr>

              <td>${mn.Cognome}</td>

              <td>${mn.Nome}</td>

              <td>${mn.Data_Nascita}</td>          

              <td>
                <a href="v_scheda_professionale_mn.jsp?id_mn=${mn.ID}">
                  Visualizza
                </a>
              </td>
            </tr>

          </c:forEach>

          <c:if test="${rset_mn.rowCount == 0}">
            <tr>
              <td colspan="4" align="center">
                Nessun Medico Nutrizionista trovato
              </td>
            </tr>
          </c:if>

        </table>

        <br><br>

      </td>
    </tr>

<%@ include file="layout_bottom.jspf" %>

