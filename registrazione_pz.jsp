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
  