<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
 
<c:choose>
  <c:when test="${empty param.id_mn || empty param.data_visita}">
    <c:set var="errmsg" scope="request">
      Devi inserire tutti i dati richiesti
    </c:set>
    <jsp:forward page="prenota_visita.jsp">
      <jsp:param name="id_mn" value="${param.id_mn}"/>
    </jsp:forward>
  </c:when>
  
  <c:otherwise>
    <sql:query var="rset_mn">
      SELECT Utenti.ID
      FROM Utenti, Schede_Professionali
      WHERE Utenti.ID = ID_utente
      AND Utenti.ID = ?
	  AND Utenti.Ruolo = 'MN'
      AND Utenti.ID_stato = 2
      
      <sql:param value="${param.id_mn}"/>
    </sql:query>
    
    <sql:query var="rset_data">
      SELECT STR_TO_DATE(?, '%Y-%m-%dT%H:%i') AS data_visita
      
      <sql:param value="${param.data_visita}"/>
    </sql:query>
    
    <c:choose>
      <c:when test="${rset_mn.rowCount != 1}">
        <c:set var="errmsg" scope="request">
          Medico non trovato
        </c:set>
        <jsp:forward page="prenota_visita.jsp">
          <jsp:param name="id_mn" value="${param.id_mn}"/>
        </jsp:forward>
      </c:when>
      
      <c:when test="${empty rset_data.rows[0].data_visita}">
        <c:set var="errmsg" scope="request">
          La data inserita non e' valida
        </c:set>
        <jsp:forward page="prenota_visita.jsp">
          <jsp:param name="id_mn" value="${param.id_mn}"/>
        </jsp:forward>
      </c:when>
      
      <c:otherwise>
        <sql:query var="rset_intervallo">
          SELECT COUNT(*) AS troppo_presto
          FROM Prenotazioni
          WHERE ID_pz = ?
          AND ID_stato NOT IN (5, 6)
          AND Data_visita = (
          	SELECT MAX(Data_visita)
            FROM Prenotazioni
            WHERE ID_pz = ?
			AND ID_stato NOT IN (5, 6)
            AND CURDATE() >= Data_visita
			)
          AND 30 > DATEDIFF(STR_TO_DATE(?, '%Y-%m-%dT%H:%i'),
                        Data_visita)
         
          <sql:param value="${user.ID}"/>
          <sql:param value="${user.ID}"/>
          <sql:param value="${param.data_visita}"/>
       </sql:query>
        
       <c:choose>
         
         <c:when test="${rset_intervallo.rows[0].troppo_presto > 0}">
           <c:set var="errmsg" scope="request">
             Non sono ancora trascorsi 30 giorni dalla visita precedente
           </c:set>
           <jsp:forward page="prenota_visita.jsp">
             <jsp:param name="id_mn" value="${param.id_mn}"/>
           </jsp:forward>
         </c:when>
         
         <c:otherwise>
           <sql:update var="righe_inserite">
             INSERT INTO Prenotazioni
			 (ID_pz, ID_mn, Data_prenotazione, Data_visita, ID_stato)
             VALUES (?, ?, NOW(), STR_TO_DATE(?, '%Y-%m-%dT%H:%i'), 12)
             
             <sql:param value="${user.ID}"/>
             <sql:param value="${param.id_mn}"/>
             <sql:param value="${param.data_visita}"/>
           </sql:update>
                                    
           <c:choose>
             <c:when test="${righe_inserite == 1}">
               <c:set var="msg" scope="request">
                 Prenotazione effettuata correttamente
               </c:set>
             </c:when>
             
             <c:otherwise>
               <c:set var="errmsg" scope="request">
                 Errore durante l'inserimento della prenotazione.
               </c:set>
             </c:otherwise>

           </c:choose>
                    
           <jsp:forward page="lista_visite.jsp"/>
           </c:otherwise>

          </c:choose>

        </c:otherwise>

      </c:choose>

   </c:otherwise>

</c:choose>    
       
          
        
