<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags" prefix="upload" %>

<%@ include file="layout_top.jspf" %>
    <c:choose>
        <c:when test="${user.Ruolo == 'MN' && user.ID_stato == 2}">
            <jsp:include page="navbar_mn.jspf" />
        </c:when>
        <c:when test="${user.Ruolo == 'KC' && user.ID_stato == 2}">
            <jsp:include page="navbar_kc.jspf" />
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

    <tr>
        <td align="center" bgcolor="#f1f5f4">
            <br><br>
            <form action="a_compilazione_scheda_professionale.jsp" method="post">
                <table width="65%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
                    <tr>
                        <td align="center" bgcolor="#dcebe7">
                            <table width="100%" border="0" cellpadding="16" cellspacing="0">
                                <tr>
                                    <td align="center">
                                        <h2>Scheda Professionale</h2>
                                        <p>Inserisci le tue informazioni professionali</p>
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
                                        <b>Data Conseguimento Certificazione</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="date" id="data_certificazione"
                                            name="data_certificazione" required>
                                    </td>
                                </tr>
                                <c:if test="${user.Ruolo == 'MN' }">
                              	<tr>
                                    <td>
                                        <b>Numero Albo</b>
                                    </td>
                                </tr>
                              
                                <tr>
                                    <td>
                                        <input type="text" id="numero_albo" name="numero_albo"
                                            size="30" required>
                                    </td>
                                </tr>
                                </c:if>
                                <tr>
                                    <td>
                                        <b>Messaggio Di Presentazione</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea id="messaggio_presentazione"
                                            name="messaggio_presentazione" rows="7" cols="60"
                                            required></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <input type="submit" value="Salva Scheda Professionale"
                                            style="background-color: #176b63; color: white; border: 0; border-radius: 6px; padding: 12px 32px; font-size: 16px; cursor: pointer;">


                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
            <br><br>
        </td>
    </tr>

<c:if test="${not empty errmsg}">
  <span style="color:red;"><b>${errmsg}</b></span><br/>
</c:if>
<%@ include file="layout_bottom.jspf" %>