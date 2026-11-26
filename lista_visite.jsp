<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
  
<%@ include file="layout_top.jspf" %>
  
<c:choose>
 <c:when test="${empty user || (user.Ruolo != 'PZ' && user.Ruolo != 'MN')}">
   <jsp:forward page="login.jsp"/>
  </c:when>
  
  <c:otherwise>
    


<sql:query var="rset_visite">
    SELECT
        Prenotazioni.ID_prenotazione,
        Prenotazioni.Data_prenotazione,
        Prenotazioni.Data_visita,
        Stati.Stato,

        (SELECT Nome
         FROM Utenti
         WHERE ID = Prenotazioni.ID_pz) AS nome_paziente,

        (SELECT Cognome
         FROM Utenti
         WHERE ID = Prenotazioni.ID_pz) AS cognome_paziente,

        (SELECT Nome
         FROM Utenti
         WHERE ID = Prenotazioni.ID_mn) AS nome_medico,

        (SELECT Cognome
         FROM Utenti
         WHERE ID = Prenotazioni.ID_mn) AS cognome_medico

    FROM Prenotazioni, Stati

    WHERE Prenotazioni.ID_stato = Stati.ID_stato
    AND (
        ( ? = 'PZ' AND Prenotazioni.ID_pz = ? )
        OR
        ( ? = 'MN' AND Prenotazioni.ID_mn = ? )
    )

    ORDER BY Prenotazioni.Data_visita DESC

    <sql:param value="${user.Ruolo}"/>
    <sql:param value="${user.ID}"/>
    <sql:param value="${user.Ruolo}"/>
    <sql:param value="${user.ID}"/>
</sql:query>
        <tr>
          <td align="center" bgcolor="#f1f5f4">
            
            <br><br>
            <h2>Le mie visite</h2>
            <br>
            
            <c:choose>
              <c:when test="${rset_visite.rowCount > 0}">
                
                <table border="1" cellpadding="10">
                  <tr>
                    <th>Data Prenotazione</th>
                    <th>Data Visita</th>
                    <th>Paziente</th>
                    <th>Medico</th>
                    <th>Stato</th>
                    <th>Dettagli</th>
                  </tr>
                  
                  <c:forEach var="visita" items="${rset_visite.rows}">
                    
                    <tr>
                      <td>${visita.Data_prenotazione}</td>
                      <td>${visita.Data_visita}</td>
                      <td>${visita.nome_paziente}
                          ${visita.cognome_paziente}
                      </td>
                      <td>${visita.nome_medico}
                          ${visita.cognome_medico}
                      </td>
                      <td>${visita.Stato}</td>
                      <td>
                        <a href="dettaglio_prenotazione.jsp?id_prenotazione=${visita.ID_prenotazione}">
                            Visualizza
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </table>
              </c:when>
              
              <c:otherwise>
                <p>Non sono presenti prenotazioni</p>
              </c:otherwise>
            </c:choose>
          <br><br>
       </td>
     </tr>

   </c:otherwise>
</c:choose>

<%@ include file="layout_bottom.jspf" %>
                   
      
      
        

        