<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="labelext" classname="java.lang.String"/>

<%
	if (!SecurityContext.isSecurityEnabled() || 
			(request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) {
%>
   <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation">
   <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons_navigation">
   <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation">
   <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
<%
	}
%>