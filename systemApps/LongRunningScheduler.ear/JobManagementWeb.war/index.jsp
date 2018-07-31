<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<% 
    try {
        if (SecurityContext.isSecurityEnabled())
            ((HttpServletResponse)pageContext.getResponse()).sendRedirect(request.getContextPath() + "/console.jsp");
    } catch (Exception e) {}

    String lang = response.getLocale().toString();
    String masterCSS = "Master.css";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
        masterCSS = lang + "/" + masterCSS;
%>
<html:html locale="true">
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/<%= masterCSS %>" rel="stylesheet"
	type="text/css">
<TITLE><bean:message key="jmc"/></TITLE>
</HEAD>

<div role="banner">
<BODY onLoad="document.logonForm.username.focus()" style="direction:ltr" bgColor="#e8e8e8">
<table border="0" cellspacing="0" cellpadding="0" width="100%"  class="wpsBannerEnclosure" role="presentation">
  <tbody>
  <tr>
    <td height="35"align="left" bgcolor="#F5F5F5" style="padding-left:10px;" class="wpsTitleText"><bean:message key="jmc"/></td>
    <td height="35"align="right" bgcolor="#F5F5F5" ><img alt='IBM' title='IBM' src='images/iscbanner-mosaic.gif'/></td>
  </tr>
  </tbody>
</table>
</div>

<div role="main">
<table bgcolor="#E8E8E8" height="100%" width="100%" border=0 cellspacing=0 cellpadding=5 role="presentation">
<tr><td width="100%" align="left" valign="top">
<form name="logonForm" method="post" action="/jmc/console.jsp">
<table border="0" cellpadding="5" cellspacing="0" bgColor="#e8e8e8" role="presentation">
  <tr> 
          <td align="left" class="wpsLoginHeadText" nowrap><bean:message key="indexWelcome"/><BR></td>
        </tr>
        <tr>
          <td align="left" valign=top width="33%" class="wpsLoginText" nowrap >
		  <label for="username"><bean:message key="userId"/></label>
                  </td>
                  </tr>
                  <tr>
                  <td align="left">
				  <input TYPE="text" class="noIndentTextEntry" name="username" id="username"/> 
        </td>
              </tr>
        <tr>
           <td align="left" valign=top class="wpsLoginText" nowrap ><input type="submit" name="action" value="<bean:message key="logIn"/>" class="buttons"></td>
        </tr>
        <tr>
          <td align="left" CLASS="wpsLoginText"><br><bean:message key="logInNote"/></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</div>

</td>
    <td VALIGN="top"><img alt='IBM' title='IBM' src='images/bgrid.gif'/></td>
</tr></table>
</BODY>
</html:html>
