<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<tiles:useAttribute name="portletTitle" classname="java.lang.String" />
<tiles:useAttribute name="parentLink" classname="java.lang.String" />
<tiles:useAttribute name="parentTitle" classname="java.lang.String" />
<tiles:useAttribute name="contentList" classname="java.util.List" />

<% 
	String dname = (String)session.getAttribute("DisplayName");
	if ((dname == null) || (dname.trim().equals(""))){
		dname = "<bean:message key=\""+portletTitle+"\"/>";
	}
	session.removeAttribute("DisplayName");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">

<head>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<!--WSC Console: needed for Federation-->
<%@ page import="com.ibm.ws.console.core.WSCDefines" %>

<jsp:include page = "/com.ibm.ws.console.xdoperations/browser_detection.jsp" flush="true"/>

<style type="text/css">
	.hidden {
		display:none;
	}
</style>

<script language="JavaScript" src="/ibm/console/scripts/menu_functions.js"></script>
<title><bean:message key="<%=portletTitle%>"/></title>
</head>

<body>
<%
//WSC Console: needed for Federation
Boolean federated = (Boolean)request.getSession().getAttribute(WSCDefines.WSC_ISC_LAUNCHED_TASK);
if ( federated == null) {
    federated = new Boolean(false);
}
Boolean isPortletCompatible = (Boolean)request.getSession().getAttribute(WSCDefines.PORTLET_COMPATIBLE);
if(isPortletCompatible == null){
    isPortletCompatible = new Boolean(false);
}
%>

<% //WSC Console: needed for Federation
if ( federated.booleanValue() == false && isPortletCompatible.booleanValue()==false) { %>
  <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage" role="banner">
      <TR>
          <TD CLASS="pageTitle"><bean:message key="<%=portletTitle%>"/>
          </TD>
          <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/navigation.do?wpageid=com.ibm.isclite.welcomeportlet.layoutElement.A&moduleRef=com.ibm.isclite.ISCAdminPortlet"><bean:message key="portal.close.page"/></A>
          </TD>
      </TR>
  </TABLE>
<%}%>

  <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" role="main">
  	<TR>
  		<TD valign="top">
  
  			<TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="presentation">
			<% //WSC Console: needed for Federation %>
  				<TR>
      				<td class="wpsPortletTitle" width="100%"><b><bean:message key="<%=portletTitle%>"/></b></td>
  				</TR>
  				<TBODY ID="wasUniPortlet">
    				<TR>   
  					<TD CLASS="wpsPortletArea" COLSPAN="3" >
    
        				<a name="important"></a> 
						<% if (!parentLink.trim().equals("")) {%>
							<h1 id="title-bread-crumb"><a href='<%=request.getContextPath()%>/<%=parentLink%>'><bean:message key="<%=parentTitle%>"/></a> > <%=dname%></h1>
							<br>
						<%}%>


						<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" SUMMARY="List layout table">
							<TBODY>
							<TR>
								<TD CLASS="layout-manager" id="notabs">

								    <tiles:insert page="/secure/layouts/vboxLayout.jsp" flush="true">
							    	    <tiles:put name="list" beanName="contentList" beanScope="page"/>
								    </tiles:insert>
		                        </TD>
        			        </TR>
					        </TBODY>
						</TABLE>
  					</TD>
 					</TR>
  				</TBODY>
 			</TABLE>
 		</TD>
	</TR>
  </TABLE>
  </body>
</html:html>
