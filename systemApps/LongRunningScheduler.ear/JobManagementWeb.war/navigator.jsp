<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<% 
    String lang = response.getLocale().toString();
    String masterCSS = "Master.css";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
        masterCSS = lang + "/" + masterCSS;
%>
<html:html locale="true">
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<title><bean:message key="jmc"/></title>
<LINK href="theme/<%= masterCSS %>" rel="stylesheet"
	type="text/css">
</HEAD>

<%
  boolean isAdmin = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
     isAdmin = false;
%>

<%
  boolean isSubmitter = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lrsubmitter"))
     isSubmitter = false;
%>
<SCRIPT>

var isNav4   = false;
var isIE     = false;
var isDom    = false;
var foropera = window.navigator.userAgent.toLowerCase();
var itsopera = foropera.indexOf("opera",0) + 1;
var itsgecko = foropera.indexOf("gecko",0) + 1;
var itsmozillacompat = foropera.indexOf("mozilla",0) + 1;
var itsmsie  = foropera.indexOf("msie",0) + 1;

if (itsopera > 0) {
    isNav4 = true
}
if (itsmozillacompat > 0){
    if (itsgecko > 0) {
        isIE= true
        isDom = true
        document.all = document.getElementsByTagName("*");
    } else if (itsmsie > 0) {
        isIE = true
    } else {
        if (parseInt(navigator.appVersion) < 5) {
            isNav4 = true
        } else {
            isIE = true
        }
    }
}

// Added because Mozilla wants to use the TBODY and table-row-group to show/hide table rows
if (isDom) {
    showIt = "table-row-group";
} else {
    showIt = "block";
}

function showHideNavigation(item) {
    taskSet = document.getElementById("child_"+item);
    taskImg = document.getElementById("img_"+item);
    if (taskSet.style.display == "none") {
        taskSet.style.display = showIt;
        taskImg.src = "images/arrow_expanded.gif";
        taskImg.title = "<bean:message key="collapse"/>";
        taskImg.alt = "<bean:message key="collapse"/>";
    } else {
        taskSet.style.display = "none";
        taskImg.src = "images/arrow_collapsed.gif";
        taskImg.title = "<bean:message key="expand"/>";
        taskImg.alt = "<bean:message key="expand"/>";
    }
}

</SCRIPT>

<body class="navtree" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div role="navigation">
<UL CLASS="nav-child">
    <LI CLASS="navigation-bullet">
      <a href="/jmc/welcome.jsp" target="detail" style="text-decoration:none" title="<bean:message key="homePage"/>"><bean:message key="welcome"/></a>
    </LI>
</UL>

<tiles:insert component="tiles/sectionNav.jsp" beanScope="session">
	<tiles:put name="navid" value="jobmanagement"/>
    <tiles:putList name="subCmdList">
        <tiles:add value="viewJobs;viewJobs.do"/>
<% if (isAdmin || isSubmitter) { %>        
        <tiles:add value="submitJob;submitJob.do?type=submit"/>
<% } %>        
    </tiles:putList>
</tiles:insert>

<tiles:insert component="tiles/sectionNav.jsp" beanScope="session">
	<tiles:put name="navid" value="jobrepository"/>
    <tiles:putList name="subCmdList">
        <tiles:add value="viewSavedJobs;viewSavedJobs.do"/>
<% if (isAdmin) { %>
        <tiles:add value="saveJob;saveJob.do"/>
<% } %>
    </tiles:putList>
</tiles:insert>

<% if (isAdmin) { %>
<tiles:insert component="tiles/sectionNav.jsp" beanScope="session">
	<tiles:put name="navid" value="jobschedules"/>
    <tiles:putList name="subCmdList">
        <tiles:add value="viewJobSchedules;viewJobSchedules.do"/>
        <tiles:add value="createSchedule;createSchedule.do"/>
    </tiles:putList>
</tiles:insert>
<% } %>

<script>
    showHideNavigation("jobmanagement");
    showHideNavigation("jobrepository");
<% if (isAdmin) { %>
    showHideNavigation("jobschedules");
<% } %>
</script>
</div>
</BODY>
</html:html>
