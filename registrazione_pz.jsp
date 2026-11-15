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

<%@ include file="navbar_nouser.jspf"    %>
<tr>
            <td align="center" bgcolor="#f1f5f4">
                <br><br>
                <form action="a_registrazione_pz.jsp" method="post">
                    <table width="65%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                        <tr>
                            <td align="center" bgcolor="#dcebe7">
                                <table width="100%" border="0" cellpadding="16" cellspacing="0">
                                    <tr>
                                        <td align="center">
                                            <h2>Crea il tuo account</h2>
                                            <p>Inserisci le tue credenziali per registrarti</p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <table width="70%" border="0" cellpadding="12" cellspacing="0">
<%@ include file="registrazione.jspf" %>
<c:if test="${not empty errmsg}"><font color="red"><b>${errmsg}</b></font><br/></c:if>
<c:if test="${not empty param.page_msg}"><font color="red"><b>${param.page_msg}</b></font><br/></c:if>
<tr>
                            <td align="center" bgcolor="#f1f5f4">
                                <p>Hai gia' un account? <a href="login.jsp"><b>Accedi</b></a></p>
                                <p><a href="index.jsp">Torna alla Homepage</a></p>
                            </td>
                        </tr>
                    </table>
                </form>
                <br><br>
            </td>
        </tr>
<%@ include file="layout_bottom.jspf" %>
  