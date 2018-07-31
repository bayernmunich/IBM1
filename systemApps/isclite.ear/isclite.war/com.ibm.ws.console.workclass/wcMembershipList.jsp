<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.console.workclass.form.WorkClassDetailForm,com.ibm.ws.console.workclass.form.WorkClassCollectionForm,com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>
<%@ page import="com.ibm.ws.sm.workspace.WorkSpace"%>
<%@ page import="com.ibm.ws.xd.config.workclass.exceptions.WorkClassNotFoundException"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="formAction" classname="java.lang.String"/>
<tiles:useAttribute name="formName" classname="java.lang.String"/>
<tiles:useAttribute name="formType" classname="java.lang.String"/>

<ibmcommon:detectLocale/>

<script language="JavaScript">

function EditPatternsClicked(wcType, formName) {
	//parent.location="/ibm/console/WorkClassDetail.do?&EditPatternsClicked=true" + "&wcType=" + encodeURI(wcType) + "&wcName=" + encodeURI(formName);
	parent.location=encodeURI("/ibm/console/WorkClassDetail.do?&EditPatternsClicked=true" + "&wcType=" + encodeURI(wcType) + "&wcName=" + encodeURI(formName)
      + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
//	window.location="/ibm/console/WorkClassDetail.do?&EditPatternsClicked=true" + "&wcType=" + encodeURI(wcType) + "&wcName=" + encodeURI(formName);
}

</script>
<%
    WorkClassCollectionForm collectionForm = (WorkClassCollectionForm)session.getAttribute("WorkClassCollectionForm");

	String wcName = (String)request.getAttribute("wcName");
	String requestType = (String)request.getAttribute("requestType");

    WorkClassDetailForm detailForm = null;	
	try {
		detailForm = WorkClassConfigUtils.getWorkClassDetailForm(wcName, collectionForm);
		//WorkClassDetailForm detailForm = (WorkClassDetailForm)session.getAttribute(wcName+"WorkClassDetailForm");
    } catch (WorkClassNotFoundException e) {
    }

	boolean isDisabled = false;
    if ((detailForm.getName().indexOf("Default_") != -1) ||
        (!request.isUserInRole("administrator") && !request.isUserInRole("configurator") && !request.isUserInRole("deployer"))) {
		isDisabled = true;
	}
	
	if(! SecurityContext.isSecurityEnabled() ) {
		// System.out.println("security not enabled");
		isDisabled = false;
	}
	
	if(detailForm.getName().indexOf("Default_") != -1){
		isDisabled = true;
	}

	WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
	ArrayList matchNames = detailForm.getModMatches();	
	matchNames = (ArrayList)WorkClassConfigUtils.formatMatchesForDisplay(matchNames, collectionForm.getApplicationName(), collectionForm.getEdition(), wksp, detailForm.getType(), collectionForm.getWCScope());
			
	matchNames.add("-------------------------------------------");

	pageContext.setAttribute("matchNamesBean", matchNames);

	String editPatternsClicked = "EditPatternsClicked('" + requestType + "', '" + detailForm.getName() + "')";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<HEAD>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/collectionform.js"></script>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<title><bean:message key="workclass.membership.label" arg0="<%=requestType%>"/></title>

</HEAD>

<BODY CLASS="content"  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="table-row" role="main">

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
	<table border="0" role="presentation">
		<tr class="table-row">
			<td valign="top" nowrap>
			<!--<td valign="top" class="table-text" scope="row" nowrap>-->
				<label class="hidden" for="available">
					<bean:message key="workclass.membership.label" arg0="<%=requestType%>"/>
				</label>
				<html:select multiple="true" size="8" property="notUsed" styleId="available"
							 onchange="" disabled="<%=isDisabled%>">
					<html:options name="matchNamesBean" />
				</html:select>
			</td>
			<td valign="top" nowrap>
			<!--<td valign="top" class="table-text" scope="row" nowrap>-->
<%				
			if (!SecurityContext.isSecurityEnabled() ||
				(request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) {
%>
			    	<html:button styleClass="buttons_other" property="notUsed" onclick="<%=editPatternsClicked%>"
    	            		disabled="<%=isDisabled%>">
	    	        	<bean:message key="workclass.button.editpatterns" arg0="<%=requestType%>" />
    				</html:button>
<%				}%>
    		</td>	
		</tr>
	</table>			
</html:form>

<SCRIPT>

function getISize(name) {
    parent.adjustISize(window.name);
}

window.onload=getISize;
</SCRIPT>


</body>
</html:html>
