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
                <form action="#" method="post">
                    <table width="65%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                        <tr>
                            <td align="center" bgcolor="#dcebe7">
                                <table width="100%" border="0" cellpadding="16" cellspacing="0">
                                    <tr>
                                        <td align="center">
                                            <h2>Crea l'account del collaboratore</h2>
                                            <p>Inserisci le credenziali del collaboratore per registrarlo</p>
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
                                            <b>Ruolo</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <select id="ruolo" name="ruolo" required
                                                style="width: 67%; padding: 10px; border: 1px solid #b7ccc7; border-radius: 6px; background-color: white;">
                                                <option value="" selected disabled hidden>Seleziona un ruolo</option>
                                                <option value="KC">Kitchen Coach</option>
                                                <option value="MN">Medico Nutrizionista</option>
                                            </select>
                                        </td>
                                    </tr>
<%@ include file="registrazione.jspf" %>




<c:if test="${not empty errmsg}"><font color="red"><b>${errmsg}</b></font><br/></c:if>
<c:if test="${not empty param.page_msg}"><font color="red"><b>${param.page_msg}</b></font><br/></c:if>

<%@ include file="layout_bottom.jspf" %>
  