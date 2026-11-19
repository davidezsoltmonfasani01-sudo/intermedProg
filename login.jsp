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

<c:choose><c:when test="${empty user_userid}">
  <%@ include file="navbar_nouser.jspf"    %>
</c:when><c:otherwise>
  <%@ include file="navbar_user.jspf"    %>
</c:otherwise></c:choose>
  
    <tr>
        <td align="center" bgcolor="#f1f5f4">
          <br><br>
          <form action = "a_login.jsp" method = "post">
            <table width="65%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
              <tr>
                <td align="center" bgcolor="#dcebe7">
                  <table width="100%" border="0" cellpadding="16" cellspacing="0">
                                    <tr>
                                        <td align="center">
                                            
                                            <h2>Inserisci le tue credenziali</h2>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
              <tr>
                <td align="center">
                  <table width="70%" border="0" cellpadding="12" cellspacing="0">
                    <tr>
                      <td>
                        <b>Username</b>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input type="text" id="form_usernam" name="form_username" size="30"
                               maxlength="16"  required>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Password</b>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <input type="password" id="form_password" name="form_password" size="30"
                               required>
                      </td>
                    </tr>
                <td align="center">
                  <input type="submit" value="Invia"
 style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px;cursor: pointer;">
                </td>
               </table>
              </tr>
              <tr>
                <td align="center"  bgcolor="#f1f5f4">
                  <p>Non hai un account? <a href="registrazione_pz.jsp">Registrati</a></p>
                </td>
              </tr>
            </table>
          </form>
        </td>
    </tr>
<c:if test="${not empty errmsg}">
  <span style="color:red;"><b>${errmsg}</b></span><br/>
</c:if>


<%@ include file="layout_bottom.jspf" %>