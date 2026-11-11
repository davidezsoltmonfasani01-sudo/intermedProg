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
<%@ include file="navbar_nouser.jspf" %>
    <tr valign="top">
      <td width="220" bgcolor="#dcebe7">
        <table width="100%" height="300" border="0" cellpadding="14" cellspacing="0">
          <tr>
            <td  align="center">
              <h1 id="inizio" align="center">Benvenuto!</h1>
              <p align="center">Autenticati per accedere ai tuoi servizi</p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
<%@ include file="layout_bottom.jspf" %>