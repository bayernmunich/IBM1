<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>
<%
    String username  = request.getParameter("username");
    String logout    = SecurityContext.isSecurityEnabled() ? "ibm_security_logout?logoutExitPage=index.jsp" : "index.jsp";
    String lang      = response.getLocale().toString();
    String masterCSS = "Master.css";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
        masterCSS = lang + "/" + masterCSS;
%>

<html:html locale="true">
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/<%= masterCSS %>" rel="stylesheet" type="text/css">
<TITLE><bean:message key="jmc"/></TITLE>
</HEAD>

<BODY bgColor="#e8e8e8">
<div role="banner" id="jmc-banner">
<table bgcolor="#E8E8E8" border="0" cellspacing="0" cellpadding="0" width="100%"  class="wpsBannerEnclosure" role="presentation">
  <tr>
    <td align="left" nowrap width="20%" style="padding-left:10px;" class="wpsTitleText"><bean:message key="jmc"/></td>
    <td align="left" nowrap width="50%" style="padding-left:10px;" class="wpsWelcomeText"><bean:message key="welcomeUser" arg0="<%=username%>"/></td>

    <td class="wpsToolBarLink" nowrap style="text-align:center;">
      <a title= 'Help' href="/jmc/help/index.jsp?topic=/com.ibm.iehs/rgrid_jmc_main.html" target="_blank" style="text-decoration:none;">
         <bean:message key="help"/>
      </a>
    </td>
    <td align="center" style="width:10px;padding-left: 10px;padding-right: 10px;" width="33">
      <img style="vertical-align: middle;" alt="" src="images/toolbar_separator.gif">
    </td>
    <td class="wpsToolBarLink" nowrap style="text-align:center;">
      <a title= 'Logout' href="<%=logout%>" target="_top" style="text-decoration:none;">
         <bean:message key="logout"/>
      </a>
    </td>
    <td align="right" style="padding-left:10px;" ><img alt='IBM' title='IBM' src='images/iscbanner-mosaic.gif'/></td>
  </tr>
</table>
</div>
</BODY>
</html:html>
