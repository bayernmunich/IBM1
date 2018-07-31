<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.console.workclass.form.WorkClassDetailForm,com.ibm.ws.console.workclass.form.WorkClassCollectionForm,com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>
<%@ page import="com.ibm.ws.xd.config.workclass.exceptions.WorkClassNotFoundException"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
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
var inited = false;
var availTCs;

function initVars(formElem, firstMembershipFormElemIndex){
	if (inited){ return inited; }
	
	var theform = formElem.form;		
	availTCs = theform.tcList;

	inited=true;
	return inited;
}

function tcNameChange(formName, requestType) {
	//When the transaction class changes we need to save it in the form
	var selectedTC = availTCs.value;
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?tcName=" + encodeURI(selectedTC) + "&wcName=" + encodeURI(formName) + "&requestType=" + encodeURI(requestType) + "&tcChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

</script>
<%
    WorkClassCollectionForm collectionForm = (WorkClassCollectionForm)session.getAttribute("WorkClassCollectionForm");

	 int wcscope = -1;
	 int wcview = -1;
	 String labelext = "";
	 if (collectionForm != null) {
	 	// Retrieve the Scope and View for this collection.   This determines the layout of this page.
		wcview = collectionForm.getWCView();  // View is either Service or Routing Policy
		wcscope = collectionForm.getWCScope();  // Scope is either App, LRA, ODR
		if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
			labelext = ".routing";
		} else {
			labelext = "";
		}
	}
//System.out.println("labelext = " +labelext);  // Debug - Remove
//System.out.println("wcview = " +wcview);    // Debug - Remove
//System.out.println("wcscope = " +wcscope);    // Debug - Remove

	String wcName = (String)request.getAttribute("wcName");
	String requestType = (String)request.getAttribute("requestType");

    WorkClassDetailForm detailForm = null;	
	try {
		detailForm = WorkClassConfigUtils.getWorkClassDetailForm(wcName, collectionForm);
		//WorkClassDetailForm detailForm = (WorkClassDetailForm)session.getAttribute(wcName+"WorkClassDetailForm");
    } catch (WorkClassNotFoundException e) {
    }

	WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
	ArrayList tcNames = detailForm.getTCs(wksp, wcscope);
	String selectedTC = detailForm.getSelectedTC();
	pageContext.setAttribute("tcBean", tcNames);

	String tcDropDownChanged = "initVars(this);tcNameChange('" + wcName + "', '" + requestType + "')";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<HEAD>
<title><bean:message key="workclass.default.action.title"/></title>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/collectionform.js"></script>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>


<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

</HEAD>

<BODY CLASS="content"  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" class="table-row" role="main">

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
	<table role="presentation">	
		<tr class="table-row">
			<td valign="top">
					
			<label for="tcList" >
				<bean:message key="workclass.default.action.label.label"/>
		    </label>
		    <br/>
            <% if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
                   // Put the routing selection lists here.
               } else {
                   boolean isDisabled = false;
              	   if (SecurityContext.isSecurityEnabled()) {
              	   		isDisabled = (!request.isUserInRole("administrator") && !request.isUserInRole("configurator") && !request.isUserInRole("deployer"));
              	   }
			%>
                <html:select size="1" value="<%=selectedTC%>" property="notUsed" styleId="tcList"
                             onchange="<%=tcDropDownChanged%>" disabled="<%=isDisabled%>">
					<html:options name="tcBean"/>
				</html:select>	
			<%
				}
			%>
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
