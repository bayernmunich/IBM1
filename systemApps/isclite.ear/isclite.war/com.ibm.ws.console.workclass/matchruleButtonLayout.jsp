<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2011 --%>
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

<script language="JavaScript">
function addMatchRuleClicked() {
	window.location = "/ibm/console/MatchRuleCollection.do?workclass.matchrule.button.add=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}
function deleteMatchRuleClicked() {
	window.location = "/ibm/console/MatchRuleCollection.do?workclass.matchrule.button.delete=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}
function upMatchRuleClicked() {
	window.location = "/ibm/console/MatchRuleCollection.do?workclass.matchrule.button.up=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}
function downMatchRuleClicked() {
	window.location = "/ibm/console/MatchRuleCollection.do?workclass.matchrule.button.down=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}
</script>
	<html:button styleClass="buttons_other" property="notUsed" onclick="addMatchRuleClicked()">
		<bean:message key="workclass.matchrule.button.add" /> 
	</html:button>
	<html:button styleClass="buttons_other" property="notUsed" onclick="deleteMatchRuleClicked()">
		<bean:message key="workclass.matchrule.button.delete" /> 
	</html:button>
	<html:button styleClass="buttons_other" property="notUsed" onclick="upMatchRuleClicked()">
		<bean:message key="workclass.matchrule.button.up" /> 
	</html:button>
	<html:button styleClass="buttons_other" property="notUsed" onclick="downMatchRuleClicked()">
		<bean:message key="workclass.matchrule.button.down" /> 
	</html:button>
