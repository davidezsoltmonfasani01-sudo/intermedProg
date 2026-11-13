<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
  
<%@ include file="layout_top.jspf"    %>

    <tr>
      <td colspan="2" bgcolor="#124f49">
        <table width="100%" border="0" cellpadding="12" cellspacing="0">
          <tr align="center">
            <td> <a href="dispatch_home.jsp" style="color: white;">Accedi</a></td>
            <td> <a href="index.jsp" style="color: white;">Home</a></td>
            <td> <a href="logout.jsp" style="color: white;">Logout</a></td>
          </tr>
        </table>
      </td>
    </tr>
</thead>
  <tr valign="top">
      <td width="220" bgcolor="#dcebe7">
        <table width="100%" height="300" border="0" cellpadding="14" cellspacing="0">
          <tr>
            <td  align="center">
              <h1 id="inizio" align="center">Ciao ${user_nome}</h1>
              <p align="center">Account registrato con successo e in attesa di attivazione</p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  
 
<%@ include file="layout_bottom.jspf" %>
  