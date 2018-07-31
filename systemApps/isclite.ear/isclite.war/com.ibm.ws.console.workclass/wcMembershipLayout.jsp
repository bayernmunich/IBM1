<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.ibm.ws.console.workclass.form.WorkClassDetailForm,com.ibm.ws.console.workclass.util.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>
<%@ page import="com.ibm.ws.console.core.item.*" %>
<%@ page import="com.ibm.ws.sm.workspace.WorkSpace"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>

<%@ page import="java.beans.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String" />
<% request.setAttribute("contextType",contextType);%>

<tiles:useAttribute name="titleKey" classname="java.lang.String" />
<tiles:useAttribute name="descKey" classname="java.lang.String" />
<tiles:useAttribute name="actionHandler" classname="java.lang.String" />
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="descImage" classname="java.lang.String" />
<tiles:useAttribute name="helpTopic" classname="java.lang.String"  ignore="true"/>

<ibmcommon:detectLocale/>
<ibmcommon:setPluginInformation pluginIdentifier="com.ibm.ws.console.workclass" pluginContextRoot=""/>

<script language="JavaScript">
var changing = false;
var selectedAvailableNodes; // array of currently selected available nodes 
var selectedCurrentNodes; // array of currently selected member nodes 
var availNodes;
var currentNodes;
var availField;
var outputField;
var inited = false;
var originalAvailField;
var originalOutputField;
var filterValue;
var originalNodes;  //this is an array of all the nodes originally in either box

//removes leading and trailing whitespace from a string
function trimString(string){
                var s = string.replace(/^\s+/g, ""); //remove leading whitespace
                return s.replace(/\s+$/g, ""); //remove leading whitespace;
}

function initVars(){
	if (inited){
		return;
	}
	
	/*
	var otherWindow = window.open();
	var doc = otherWindow.document;
	
	for (var i = 0; i < document.forms[0].elements.length; i++){
		var elem = document.forms[0].elements[i];
		doc.writeln("elements[" + i + "] type: " + elem.type + ",  name: " + elem.name + "<BR>");
	}
	*/
	
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	originalNodes = new Array();							
	availNodes = document.forms[0].available;
	currentNodes = document.forms[0].selected;
	filterValue = document.forms[0].filter;

	inited=true;
}
	
function webModNameEditMembershipChange(wcName) {
	var selectedMod = document.forms[0].selectedMod.value;
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&ModEditMembershipChanged=true"+ "&wcName=" + encodeURI(wcName)   
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function methodNameEditMembershipChange(wcName) {
	var selectedMethod = document.forms[0].selectedMethod.value;
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?method=" + encodeURI(selectedMethod) + "&MethodEditMembershipChanged=true"+ "&wcName=" + encodeURI(wcName)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function jmsEJBNameEditMembershipChange(wcName) {
	var selectedJMSEJB = document.forms[0].selectedJMSEJB.value;
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?jmsEJB=" + encodeURI(selectedJMSEJB) + "&jmsEJBEditMembershipChanged=true"+ "&wcName=" + encodeURI(wcName)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function enableFilterClicked(wcName) {
	var enableFilter = document.forms[0].enableFilter.checked;
	var selectedMethod = document.forms[0].selectedMethod.value;
	
	if (enableFilter) {
		window.location = encodeURI("/ibm/console/WorkClassDetail.do?method=" + encodeURI(selectedMethod) + "&enableFilterChecked=true" + "&wcName=" + encodeURI(wcName)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	} else {
		window.location = encodeURI("/ibm/console/WorkClassDetail.do?method=" + encodeURI(selectedMethod) + "&enableFilter=" + encodeURI(enableFilter) + "&wcName=" + encodeURI(wcName)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}

}

function addEditMembershipClicked(optionsToAdd, wcName) {
	if (optionsToAdd.length > 0) {
		var selectedMod = document.forms[0].selectedMod.value;
		//var contextRoot = document.forms[0].contextRoot.value;
		var contextRoot = selectedMod;
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				//Expression - /<contextRoot>/match
				optionsToAddString = optionsToAddString + ";;" + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&AddEditMembershipClicked=true" + "&matchStringToAdd=" + encodeURI(optionsToAddString)+ "&wcName=" + encodeURI(wcName)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function removeEditMembershipClicked(optionsToRemove, wcName) {
	if (optionsToRemove.length > 0) {
		var selectedMod = document.forms[0].selectedMod.value;
		//var contextRoot = document.forms[0].contextRoot.value;
		var contextRoot = selectedMod;
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&RemoveEditMembershipClicked=true" + "&matchStringToRemove=" + encodeURI(optionsToRemoveString)+ "&wcName=" + encodeURI(wcName)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function addFilterEditMembershipClicked(wcName) {
	var selectedMod = document.forms[0].selectedMod.value;
	var contextRoot = document.forms[0].contextRoot.value;
	var filterValueString = trimString(document.forms[0].filter.value);
	if (filterValueString.length > 0) {
		if (filterValueString.charAt(0) != "/")
			filterValueString = "/" + filterValueString;
		//var newFilterValue = contextRoot + filterValueString;
		//window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(newFilterValue));
		window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&AddFilterEditMembership=true" + "&newFilterValue=" + encodeURI(filterValueString)+ "&wcName=" + encodeURI(wcName)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function addFilter2EditMembershipClicked(wcName) {
	var selectedMod = document.forms[0].selectedMod.value;
	var contextRoot = document.forms[0].contextRoot.value;
	var filterValueString = trimString(document.forms[0].filter.value);
	var filter2ValueString = trimString(document.forms[0].filter2.value);	
	if (filterValueString.length > 0 && filter2ValueString.length > 0) {
		//var newFilterValue = contextRoot + filterValueString;
		//window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(newFilterValue));
		window.location = encodeURI("/ibm/console/WorkClassDetail.do?mod=" + encodeURI(selectedMod) + "&AddFilter2EditMembership=true" + "&newFilterValue=" + encodeURI(filterValueString) + "&wcName=" + encodeURI(wcName) + "&newFilter2Value=" + encodeURI(filter2ValueString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}


function okEditMembershipClicked(wcName) {
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?&okEditMembershipClicked=true"+ "&wcName=" + encodeURI(wcName)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function cancelEditMembershipClicked(wcName) {
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?&cancelEditMembershipClicked=true"+ "&wcName=" + encodeURI(wcName)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

/*
This function sets the global selectedAvailableNodes array to correspond with the selected 
objects in the box represented by "nodeList" (either currentNodes or availNodes)
*/
function setSelectedNodes(nodeList, selectObject){
	changing = true;
	empty(nodeList);
	var numSelected = 0;	
	var itemSelected;
	if (selectObject.selectedIndex != -1){
		var index=0;
		var str;
		for (var x = 0; x < selectObject.options.length; x++) {
			if (selectObject.options[x].selected){				
				nodeList[index++] = selectObject.options[x]; //copy a reference to this field into our list of selected Options
				itemSelected = selectObject.options[x].value;
				numSelected = numSelected + 1;
			}				
		}		
	}	
	var tempString="";
	first = true;
	for (var y = 0; y < nodeList.length; y++){
		if (!first){
			tempString += "!";			
		}
		tempString += nodeList[y].value;
		first = false;
	}	

	changing = false;
}


//this function removes all elements from the array "nodeList"
function empty(nodeList){
	for (x=0; x<nodeList.length; x++){
		nodeList.pop();
	}
}


</script>

<%  // defect 126608
  String image = ""; 
  String pluginId = "";
  String pluginRoot = "";

  if (descImage != "")
  {
     int index = descImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = descImage.substring (index + 9);
        if (index != 0)
           descImage = descImage.substring (0, index);
        else
           descImage = "";
     }
     else 
     {
        index = descImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = descImage.substring (index + 18);
           if (index != 0)
              descImage = descImage.substring (0, index);
           else
              descImage = "";
        }
     }
  }
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>

<%
   String fieldLevelHelpTopic = null;
   String DETAILFORM = "DetailForm";
   String COLLECTIONFORM = "CollectionForm";
   String FORM = "Form";
   String objectType = "";
   String helpPluginId = "";

   String fieldLevelHelpAttribute = "";
   fieldLevelHelpTopic = "CreateWorkClassStep1Form.detail.";
   String topicKey = fieldLevelHelpTopic;
   fieldLevelHelpTopic = topicKey + "membership";

   if (helpTopic !=null && helpTopic.length()>0 && pluginId !=null && pluginId.length()>0)
   {
	   fieldLevelHelpTopic = helpTopic;
	   helpPluginId = pluginId; 
   }
   else {
   if (formType != null && formType.length() > 0) {
		int index = formType.lastIndexOf ('.');
		if (index > 0) {
			String fType = formType.substring (index+1); 
			if (fType.endsWith (DETAILFORM)) {
				objectType = fType.substring (0, fType.length()-DETAILFORM.length());
				fieldLevelHelpTopic = objectType + ".detail";
			} else if (fType.endsWith (COLLECTIONFORM)) {
				objectType = fType.substring (0, fType.length()-COLLECTIONFORM.length());
				fieldLevelHelpTopic = objectType + ".collection";
			} else if (fType.endsWith (FORM)) {
           		objectType = fType.substring (0, fType.length() - FORM.length()); 
           	 	fieldLevelHelpTopic = objectType; 
         	} else {
				fieldLevelHelpTopic = fType;
			}
		} else {
        	fieldLevelHelpTopic = formType;
      	}
   	} else 
        fieldLevelHelpTopic = "";
   	}
%>

<%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String pageTitle = messages.getMessage(request.getLocale(),titleKey);
        if (session.getAttribute("bcnames") != null)  {           
                String[] bcnamesT = (String[])session.getAttribute("bcnames");
                pageTitle = bcnamesT[0];
                String[] bclinksT = (String[])session.getAttribute("bclinks");
				int oldlen = 0;
				for (int counter1=0; counter1<bclinksT.length; counter1++) {
                  if (bclinksT[counter1].equals("")) {
                          oldlen = counter1;
                          break;
                  }
				}
                String priorpage = request.getHeader("Referer");
                if (oldlen == 0) { 
					 oldlen = 1;
				}

				if (priorpage.indexOf("forwardName=") > 0) {
				   if ((bclinksT[oldlen].indexOf("forwardName=") < 0) &&
					   (bclinksT[oldlen].indexOf("EditAction=true") < 0)) {
                        bclinksT[oldlen] = priorpage;
						 session.setAttribute("bclinks", bclinksT);
				   }
                }

        }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<HEAD>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/collectionform.js"></script>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<title><%=pageTitle%></title>

</HEAD>

<BODY CLASS="content"  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" role="main">

<%
  // .do of the action handler in definition was omitted for easier comparison.
  // Appending the .do now.
  String actionPath = actionHandler + ".do";
%>


<html:form action="<%=actionPath%>" name="<%=formAction%>" type="<%=formType%>">
  
<TABLE WIDTH="97%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage" role="banner">
	<TR>
    	<TD CLASS="pageTitle"><%=pageTitle%>
        </TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"><bean:message key="portal.close.page"/></A>
        </TD>        
    </TR>
</TABLE>

<%
WorkClassCollectionForm wccf = (WorkClassCollectionForm)session.getAttribute("WorkClassCollectionForm");
WorkSpace wksp = (WorkSpace) session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
String wcName = (String)request.getAttribute("wcName");
WorkClassDetailForm testForm = WorkClassConfigUtils.getWorkClassDetailForm(wcName, wccf);
String wcType = (String)session.getAttribute("requestType");
boolean isEJBModule = ((Boolean)session.getAttribute("isEJBModule")).booleanValue();

//String wcName = testForm.getName();
ArrayList selectedNodesBean = (ArrayList)testForm.getModMatches();
selectedNodesBean = (ArrayList)WorkClassConfigUtils.formatMatchesForDisplay(selectedNodesBean, wccf.getApplicationName(), wccf.getEdition(), wksp, testForm.getType(), wccf.getWCScope());
Collection appNames = testForm.getAppNamesToShow();
Collection modNames = testForm.getModNamesToShow();
Collection methodNames = testForm.getMethodNamesToShow();
Collection jmsEJBNames = testForm.getJMSEJBNamesToShow();
ArrayList matchesNames = (ArrayList)testForm.getMatchesToShow();

//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
if (!selectedNodesBean.contains("-------------------------------------------"))
	selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");
if (!matchesNames.contains("-------------------------------------------"))
	matchesNames.add(matchesNames.size(),"-------------------------------------------");

String selectedApp = testForm.getSelectedApp();
String selectedMod = testForm.getSelectedMod();
String selectedMethod = testForm.getSelectedMethod();
String selectedJMSEJB = testForm.getSelectedJMSEJB();
String contextRoot = testForm.getContextRoot();
String refId = testForm.getName();

pageContext.setAttribute("availableNodesBean", matchesNames);
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
pageContext.setAttribute("appNamesBean", appNames);
pageContext.setAttribute("modNamesBean", modNames);
pageContext.setAttribute("methodNamesBean", methodNames);
pageContext.setAttribute("jmsEJBNamesBean", jmsEJBNames);
pageContext.setAttribute("contextRoot", contextRoot);


String availNodesSelectChange = "initVars(this); setSelectedNodes(selectedAvailableNodes, availNodes)";
String currNodesSelectChange = "initVars(this);setSelectedNodes(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVars(this);removeEditMembershipClicked(selectedCurrentNodes, '" + wcName + "')";
String addButtonClicked = "initVars(this);addEditMembershipClicked(selectedAvailableNodes, '" + wcName + "')";
String addFilterButtonClicked = "initVars(this);addFilterEditMembershipClicked('" + wcName + "')";
String modDropDownChanged = "initVars(this);webModNameEditMembershipChange('" + wcName + "')";
String methodDropDownChanged = "initVars(this);methodNameEditMembershipChange('" + wcName + "')";
String okButtonClicked = "initVars(this);okEditMembershipClicked('" + wcName + "')";
String cancelButtonClicked = "initVars(this);cancelEditMembershipClicked('" + wcName + "')";
String jmsEJBDropDownChanged = "initVars(this);jmsEJBNameEditMembershipChange('" + wcName + "')";
String enableFilterClicked = "initVars(this);enableFilterClicked('" + wcName + "')";
boolean isMethodEnabled = testForm.getEnableFilter();

if (wcType.equals(WorkClassConstants.IIOP) || wcType.equals(WorkClassConstants.JMS))
	addFilterButtonClicked = "initVars(this);addFilter2EditMembershipClicked('" + wcName + "')";

String message = "";
try {
%>

<TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" role="presentation">
  <TR>
	<TD valign="top">
	  <TABLE WIDTH="97%" CELLPADDING="2" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="presentation">
		  <TR>
		    <td class="wpsPortletTitle"><b><bean:message key="<%=titleKey%>" arg0="<%=wcName%>" /></b></td>
		    <td class="wpsPortletTitleControls">
				<% if (!fieldLevelHelpTopic.equals("") && !helpPluginId.equals("")) {%>
					<ibmcommon:setPluginInformation pluginIdentifier="<%=helpPluginId%>" pluginContextRoot=""/>
					<ibmcommon:info image="help.additional.information.image" topic="<%=fieldLevelHelpTopic%>"/>
				<%}%>	
			    <A href="javascript:showHidePortlet('wasUniPortlet')">
				    <img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt"/>" border="0" align="texttop"/>
		    	</A>    
			</td>
		  </TR>
  
		  <TBODY ID="wasUniPortlet">
		  <TR>   
			  <TD CLASS="wpsPortletArea" COLSPAN="2" >
 			    <a name="important"></a> 
			    <ibmcommon:errors/>
  
				<%-- Iterate over names.
				  We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
				 --%>

<!-- Begin Content-->
	<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="table-text">
				<table role="presentation">
					<tr>
						<td class="table-text" colspan=3>
						    <% if (wcType.equals(WorkClassConstants.SOAP)) {%>
	                        	<label title='<bean:message key="workclass.detail.membershipinstruction.soap" arg0="<%=wcType%>" />'>
	                        <%} else { %>
                        	    <label title='<bean:message key="workclass.detail.membershipinstruction" arg0="<%=wcType%>" />'>
                        	<%} %>
								<bean:message key="workclass.membership.description" arg0="<%=wcType%>" arg1="<%=selectedApp%>" />
                            </label>
                            <br><br>
						</td>
					</tr>		
					<tr>
						<td class="table-text">
							<label for="selectedMod">
								<bean:message key="policy.Mod" />
							</label>
						</td>
						<td class="table-text">
							<html:select size="1" value="<%=selectedMod%>" property="NotUsed" styleId="selectedMod"
										 onchange="<%=modDropDownChanged%>">
								<html:options name="modNamesBean" />
							</html:select>
						</td>
					</tr>
					
					<% if (isEJBModule && wcType.equals(WorkClassConstants.JMS)) { %>
					<tr>
						<td class="table-text">
							<bean:message key="workclass.methodcall.iiop" />
						</td>
						<td class="table-text">
							<html:select size="1" value="<%=selectedJMSEJB%>" property="NotUsed" styleId="selectedJMSEJB"
										 onchange="<%=jmsEJBDropDownChanged%>">
								<html:options name="jmsEJBNamesBean" />
							</html:select>
						</td>
					</tr>
					<% } %>					
					
						<% if (!wcType.equals(WorkClassConstants.HTTP)) { %>
							<% message = WorkClassConfigUtils.getLabel("workclass.methodcall", wcType); %>
					<tr>							
						<td class="table-text">						
							<bean:message key="<%=message%>" />
						</td>
						<td class="table-text">
							<html:select size="1" value="<%=selectedMethod%>" property="NotUsed" styleId="selectedMethod"
										 onchange="<%=methodDropDownChanged%>" disabled="<%=!isMethodEnabled%>">
								<html:options name="methodNamesBean" />
							</html:select>
<%							   if (wcType.equals(WorkClassConstants.IIOP) || wcType.equals(WorkClassConstants.JMS)) { %>
<%									if (isMethodEnabled) { %>
										<input type=checkbox name="enableFilter" id="enableFilter" onchange="<%=enableFilterClicked%>" checked />
<%									} else {%>
										<input type=checkbox name="enableFilter" id="enableFilter" onchange="<%=enableFilterClicked%>" />
<%									}%>
							<% message = WorkClassConfigUtils.getLabel("workclass.enablefilter", wcType); %>
							<bean:message key="<%=message%>" />
<%							   }%>
						</td>							
					</tr>							
						<% } %>
				</table>				
				<br>
				<table role="presentation">
					<tr>
						<td valign="top" class="table-text">
							<center>
								<% message = WorkClassConfigUtils.getLabel("workclass.details.availableMatches", wcType); %>
								<label for="available">
									<bean:message key="<%=message%>" />
								</label>
							</center>
						</td>
						<td>&nbsp;</td>
						<td valign="top" class="table-text"> 
							<center>
								<label for="selected">
									<bean:message key="workclass.details.membersOf" arg0="<%=refId%>"/>
								</label>
							</center> 
						</td>
					</tr>
					<tr>
						<td valign="top" class="table-text" >
							<html:select multiple="true" size="8" property="notUsed" styleId="available"
										 onchange="<%=availNodesSelectChange%>">
								<html:options name="availableNodesBean" />
							</html:select>
						</td>	
                        <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">	
							<html:button styleClass="buttons_other" property="notUsed" onclick="<%=addButtonClicked%>">
								<bean:message key="workclass.button.add" /> 
							</html:button> 
						<br>
						<br>
							<html:button styleClass="buttons_other" property="notUsed" onclick="<%=removeButtonClicked%>">
								<bean:message key="workclass.button.remove" />
							</html:button>
						</td>
						<td rowspan="2" valign="top" class="table-text">
							<html:select multiple="true" size="8" property="notUsed" styleId="selected"
										 onchange="<%=currNodesSelectChange%>">
								<html:options name="selectedNodesBean" />
							</html:select>
						</td>
					</tr>
				</table>									
				<table role="presentation">
<%				if (!wcType.equals(WorkClassConstants.SOAP)) {
					message = WorkClassConfigUtils.getLabel("customPatternLabel", wcType); %>
     				<tr>
						<td>
							<table width="15%">     				
								<tr>
				    				<td valign="bottom" class="table-text" nowrap>
				    					<label for="filter">
		    								<bean:message key="<%=message%>" />
		    							</label>
		    							<br>
				                		<html:text property="filterField" styleId="filter" style="width:125px" styleId="filter" disabled="false" />
            	    				</td>
<%					if (wcType.equals(WorkClassConstants.IIOP) || wcType.equals(WorkClassConstants.JMS)) {
						message = WorkClassConfigUtils.getLabel("customPatternLabel2", wcType); %>					
									<td class="table-text"><br />:</td>
	    							<td valign="bottom" class="table-text" nowrap>
		    							<label for="filter2">
				    						<bean:message key="<%=message%>" />
				    					</label>
				    					<br>
	    		            			<html:text property="filterField2" styleId="filter2" style="width:125px" styleId="filter2" disabled="false" />
			            	    	</td>
<%					}%>
								</tr>
							</table>
						</td>
                        <td class="table-text" align="center" valign="middle" cellpadding="10" width="25%"><br>
                			<html:button styleClass="buttons_other" property="notUsed" onclick="<%=addFilterButtonClicked%>">
			     				<bean:message key="workclass.button.addFilter"  />
            	      		</html:button>
 				    	</td>
			    	</tr>
<%				}%>
    			</table>				
				<br />
	            <table width="100%" cellpadding="6" cellspacing="0">
    	          <tr>
		        	<td class="wizard-button-section"  ALIGN="center">
 				    	<html:button styleClass="buttons_navigation" property="notUsed" onclick="<%=okButtonClicked%>">
   		 					<bean:message key="button.ok"  /> 
		            	</html:button>   
		            	&nbsp;
 				    	<html:button styleClass="buttons_navigation" property="notUsed" onclick="<%=cancelButtonClicked%>">
   		 					<bean:message key="button.cancel"  /> 
		            	</html:button>   		            	
        		    </td>
        		    
				  </tr>
				</table>
			</td>
    	</tr>

    	<html:hidden property="currentContextRoot" styleId="contextRoot" value="<%=contextRoot%>"/>        
      </table>


			</TD>
		</TR>
	</TBODY>     
	</TABLE>
   </TD>
   <%@ include file="/com.ibm.ws.console.workclass/helpPortlet.jspf" %>
  </TR>

 <% } 
 catch (Exception e) { System.out.println("Caught Exception" + e.toString()); e.printStackTrace();} %>
</table>
<!--  end content -->




</html:form>
</body>
</html:html>
