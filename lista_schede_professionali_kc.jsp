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


  <%@ include file="navbar_pz.jspf" %>

    <sql:query var="rset_utenti">
      SELECT ID, CF, Cognome, Nome, Data_Nascita
      FROM Utenti
      WHERE Ruolo='KC'
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

        <br>

        <form action="lista_schede_professionali_kc.jsp" method="get">

          <input type="text"
                 name="cerca"
                 size="35"
                 placeholder="Cerca per CF, nome, cognome o username"
                 value="${param.cerca}">

          <input type="submit" value="Cerca" style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 3px 16px; font-size: 13px; line-height: 1; cursor: pointer;">

          <a href="lista_utenti.jsp">Mostra tutti</a>

        </form>

        <br><br>

        <table border="1" align="center" cellpadding="8">

          <tr bgcolor="#dce8e5">
            <th>Cognome</th>
            <th>Nome</th>
            <th>Data di nascita</th>
            <th>Dettagli</th>
          </tr>

          <c:forEach items="${rset_utenti.rows}" var="utente">

            <tr>

              <td>${utente.Cognome}</td>

              <td>${utente.Nome}</td>

              <td>${utente.Data_Nascita}</td>          

              <td>
                <a href="v_scheda_professionale_kc.jsp?id_utente=${utente.ID}">
                  Visualizza
                </a>
              </td>
            </tr>

          </c:forEach>

          <c:if test="${rset_utenti.rowCount == 0}">
            <tr>
              <td colspan="8">
                Nessun Kitchen Coach trovato
              </td>
            </tr>
          </c:if>

        </table>

        <br><br>

      </td>
    </tr>

<%@ include file="layout_bottom.jspf" %>

