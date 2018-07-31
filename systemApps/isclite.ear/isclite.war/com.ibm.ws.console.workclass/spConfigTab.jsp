<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2012 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.ApplicationUtil"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.OSGiApplicationUtil"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassXDUtil"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="formAction" classname="java.lang.String"/>
<tiles:useAttribute name="formName" classname="java.lang.String"/>
<tiles:useAttribute name="formType" classname="java.lang.String"/>
<tiles:useAttribute name="attributeList" classname="java.util.List"/>

<%
Double dblValue = (Double)session.getAttribute("multiplier");
double multiplier = dblValue.doubleValue();
%>
 
<style type="text/css">
	a.tree { 
	    color: #000000; 
	    text-decoration: none; 
	}
	
	.workclassRow {
		font-size: <%=(65*multiplier)%>%;
		font-family: Verdana,Helvetica, sans-serif;
		background-color: #f7f7f7; 	
		border: 0;
		margin-left: 2em;
	 }
</style>


<script language="JavaScript">

function showHideSection(sectionId) {
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
            state = "display:block";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.workclass/images/minus_sign.gif";
            }
        } else {
            document.getElementById(sectionId).style.display = "none";           
            state = "display:none";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.workclass/images/plus_sign.gif";
            }
        }
        
		uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_"+sectionId+"&variableValue="+state;
		setState = doXmlHttpRequest(uriState);
		setState = setState.substring(0,setState.indexOf("+endTransmission"));        
    }
}

function popUpLimitedWindow(winUrl) {
    var features = "height=500,width=600,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
    var parentWin = window.name;
    var newWin = open(winUrl, 'SupportingEvidence', features, parentWin);
}

</script>
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">

<%
WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
WorkClassCollectionForm wccf = (WorkClassCollectionForm)request.getSession().getAttribute("WorkClassCollectionForm");

int wcscope = -1;
int wcview = -1;
// Retrieve the Scope and View for this collection.   This determines the layout of this page.
wcview = wccf.getWCView();  // View is either Service or Routing Policy
wcscope = wccf.getWCScope();  // Scope is either App, ODR

boolean isAppDeployedOnZOS = false;
if (wcscope == WorkClassConstants.WCSCOPE_CU) {
	isAppDeployedOnZOS = OSGiApplicationUtil.isAppDeployedOnZOS(wccf.getApplicationName(), null, wksp);
} else if (wcscope != WorkClassConstants.WCSCOPE_MWA && wccf.getApplicationName() != null) {
	isAppDeployedOnZOS = ApplicationUtil.isAppDeployedOnZOS(wccf.getApplicationName(), null, wksp);
}


String labelext = "";
String expandID = "";
if (wccf != null) {	
	if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
		expandID = wccf.getNodeName()+"_"+wccf.getODRName();
	} else {
		if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
			expandID = WorkClassXDUtil.normalizeAppName(wccf.getApplicationName());
		} else {
			expandID = wccf.getApplicationName();
		}
	}
	expandID = expandID+"_"+wcview;
	
	if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
		if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
			labelext = ".odr.routing";
		} else {
			labelext = ".odr.service";
		}
	} else {
		if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
			labelext = ".routing";
		} else {
			labelext = "";
		}
	}
}

//System.out.println("labelext = " +labelext);    // Debug - Remove
//System.out.println("wcview = " +wcview);    // Debug - Remove
//System.out.println("wcscope = " +wcscope);    // Debug - Remove
String fieldsetMessage = "workclass" + labelext + ".config.description";
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">

	<% 
	   if (wcview == WorkClassConstants.WCVIEW_SERVICE && wcscope == WorkClassConstants.WCSCOPE_APP) { 
		    String href = "/ibm/console/com.ibm.ws.console.policyconfiguration.forwardCmd.do?forwardName=serviceclasstopology.content.main"
		    	    + "&csrfid=" + session.getAttribute("com.ibm.ws.console.CSRFToken");
	%>
	<tr>
		<td class="table-text" nowrap>
            <a href="#" onclick="popUpLimitedWindow('<%=href%>')">
                <img id="allSPsImg" SRC="<%=request.getContextPath()%>/com.ibm.ws.console.workclass/images/popup_icon.gif" alt="Open in new window" border="0" align="texttop">
   	            <bean:message key="workclass.service.config.topologyLink" />
   	        </a>
		</td>
	</tr>
	<% } %>
<!--   
		<tr>
			<td class="table-text" scope="row" nowrap>
                  <a href="#"><img id="specificSPsImg" SRC="<%=request.getContextPath()%>/images/popup_icon.gif" alt="" border="0" align="texttop"/>
                  View the service policies that are mapped to this application</A>
			</td>
		</tr>
-->			
    <tr>
        <td class="table-text" nowrap>
            <% String labelkey = "workclass" +labelext +".config.description"; %>
			<bean:message key="<%=labelkey%>" />
		</td>
	</tr>
	<tr>
        <td class="navigation-button-section" nowrap>
            <tiles:insert definition="workclass.content.main.buttons" flush="false">
			<% if (wcview == WorkClassConstants.WCVIEW_ROUTING) { 
			    labelext = ".routing";
			} else {
			    labelext = "";
			} %>
			<tiles:put name="labelext" value="<%=labelext%>" />
    		</tiles:insert>
		</td>
	</tr>
</table>

<br/>
<fieldset style="border:0px; padding:0pt; margin: 0pt;">
    <legend class="hidden"><bean:message key="<%=fieldsetMessage %>"/></legend>
    <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">

		<% 
			String wcType = item.getAttribute(); //protocol
			if (WorkClassConfigUtils.isProtocolSectionVisable(wcType, wcscope, wcview, isAppDeployedOnZOS)) {
		%>

		<tr>
			<td class="table-text" nowrap>
				<%					
					String expandGraphic = "/ibm/console/com.ibm.ws.console.workclass/images/plus_sign.gif";
					String expandState = (String)session.getAttribute("com_ibm_ws_"+expandID+wcType);
					if (expandState == null)
						expandState = "display:none";
					else if (expandState.equals("display:block"))
						expandGraphic = "/ibm/console/com.ibm.ws.console.workclass/images/minus_sign.gif";
				%>
				<a href="javascript:showHideSection('<%=expandID%><%=wcType%>')" class="tree">
			        <img id="<%=expandID%><%=wcType%>Img" border="0" align="middle" src="<%=expandGraphic%>" />
				    <bean:message key="workclass.requests.type1" arg0="<%=wcType%>" />
				</a>
		
				<div id="<%=expandID%><%=wcType%>" style="<%=expandState%>">
				   	<tiles:insert definition="workclass.content.main.requests" flush="false">
			    		<tiles:put name="requestType" value="<%=wcType%>" />
	    			</tiles:insert>
				</div>
			</td>
		</tr>
               
        <% } %> 
        </logic:iterate>
	</table>
</fieldset>
</html:form>
