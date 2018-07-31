<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.*" %>


<tiles:useAttribute name="actionForm" classname="java.lang.String"/>
<tiles:useAttribute name="actionHandler" classname="java.lang.String"/>
<%
	MiddlewareAppsDetailForm theForm = (MiddlewareAppsDetailForm) session.getAttribute(actionForm);
	String typeKey = theForm.getTypeKey();
%>

	<!-- Deploy! -->
	<a name="deploy"></a>
	<% if(!theForm.getTypeKey().equals("middlewareapps.type.wasce")) { %>
	<H2><bean:message key="middlewareapps.detail.deploy.name"/></H2>
	<% } %>
		
	<tiles:insert page="/com.ibm.ws.console.middlewareapps/commonDeploymentPropertiesLayout.jsp" flush="true">
		<tiles:put name="actionForm" value="<%=actionForm%>"/>
	    <tiles:put name="actionHandler" value="<%=actionHandler%>"/>
	</tiles:insert> 
<%
if(theForm.getTypeKey().equals("middlewareapps.type.wasce") && theForm.getAvailableModuleNames().size()==0){
	;
}else{
 %>  	          
	<tiles:insert page="/com.ibm.ws.console.middlewareapps/deploymentModulesCollectionLayout.jsp" flush="true">
	    <tiles:put name="actionForm" value="<%=actionForm%>"/>
	    <tiles:put name="actionHandler" value="<%=actionHandler%>"/>
	</tiles:insert>
            
<% } %>
