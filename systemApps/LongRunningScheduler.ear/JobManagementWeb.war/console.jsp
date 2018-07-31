<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>
<%
  String framesize = "30";
  String navFrameSize = "25%";
  String navSource = request.getContextPath() + "/navigator.jsp";
  String contentSource = request.getContextPath() + "/welcome.jsp";
  String username = "";
  if (SecurityContext.isSecurityEnabled())
     username = request.getRemoteUser();
  else {
     username = request.getParameter("username");
     request.getSession().setAttribute("jmc_userid", username);
  }
  String bannerSource = request.getContextPath() + "/banner.jsp?username=" + username;
  String lang         = response.getLocale().toString();
  String masterCSS    = "Master.css";
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

<frameset rows="<%= framesize %>,*" FRAMEBORDER="1" BORDER="1" resize="yes" name="JMCMain">

  <frame name="header" title='<bean:message key="header.frame" />' scrolling="NO" noresize src="<%=bannerSource%>" marginwidth="0" marginheight="0" >
 
  <frameset cols="<%=navFrameSize%>,*" resize="yes" >
	  <FRAME title='<bean:message key="task.nav.frame" />' src="<%=navSource%>" name="navigation_tree" resize="yes" marginwidth="0" marginheight="0">
	  <FRAME title='<bean:message key="work.area.frame" />' src="<%=contentSource%>"  name="detail"  marginwidth="0" marginheight="0" resize="yes">
  </frameset>

</frameset>
<NOFRAMES>
	You must use a browser that supports frames for the WebSphere Application Server Job Management Console.
</NOFRAMES>
</html:html>
