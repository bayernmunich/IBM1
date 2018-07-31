<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.ibm.ws.console.workclass.form.WorkClassDetailForm,com.ibm.ws.console.workclass.util.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>
<%@ page import="com.ibm.ws.sm.workspace.WorkSpace"%>
<%@ page import="java.beans.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="descImage" classname="java.lang.String" />


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
	
function webModNameChange() {
	var selectedMod = document.forms[0].selectedMod.value;
	window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&ModChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function methodNameChange() {
	var selectedMethod = document.forms[0].selectedMethod.value;
	window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?method=" + encodeURI(selectedMethod) + "&MethodChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function jmsEJBNameChange() {
	var selectedJMSEJB = document.forms[0].selectedJMSEJB.value;
	window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?jmsEJB=" + encodeURI(selectedJMSEJB) + "&jmsEJBChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function enableFilterClicked() {
	var enableFilter = document.forms[0].enableFilter.checked;
	var selectedMethod = document.forms[0].selectedMethod.value;
	
	if (enableFilter) {
		window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?method=" + encodeURI(selectedMethod) + "&enableFilterChecked=true"
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	} else {
		window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?method=" + encodeURI(selectedMethod) + "&enableFilter=" + encodeURI(enableFilter)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}

}

function addClicked(optionsToAdd) {
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
			window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&AddClicked=true" + "&matchStringToAdd=" + encodeURI(optionsToAddString) 
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function removeClicked(optionsToRemove) {
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
			window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&RemoveClicked=true" + "&matchStringToRemove=" + encodeURI(optionsToRemoveString)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function addFilterClicked() {
	var selectedMod = document.forms[0].selectedMod.value;
	var contextRoot = document.forms[0].contextRoot.value;
	var filterValueString = trimString(document.forms[0].filter.value);
	if (filterValueString.length > 0) {
		if (filterValueString.charAt(0) != "/")
			filterValueString = "/" + filterValueString;
		//var newFilterValue = contextRoot + filterValueString;
		//window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(newFilterValue));
		window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(filterValueString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function addFilter2Clicked() {
	var selectedMod = document.forms[0].selectedMod.value;
	var contextRoot = document.forms[0].contextRoot.value;
	var filterValueString = trimString(document.forms[0].filter.value);
	var filter2ValueString = trimString(document.forms[0].filter2.value);	
	if (filterValueString.length > 0 && filter2ValueString.length > 0) {		
		//var newFilterValue = contextRoot + filterValueString;
		//window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(newFilterValue));
		window.location = encodeURI("/ibm/console/CreateWorkClassStep2.do?mod=" + encodeURI(selectedMod) + "&AddFilter2=true" + "&newFilterValue=" + encodeURI(filterValueString) + "&newFilter2Value=" + encodeURI(filter2ValueString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
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
   String fieldLevelHelpTopic = "";
   String fieldLevelHelpAttribute = "";
   fieldLevelHelpTopic = "CreateWorkClassStep1Form.detail.";
   String topicKey = fieldLevelHelpTopic;
   fieldLevelHelpTopic = topicKey + "membership";
%>

<%
WorkClassCollectionForm wccf = (WorkClassCollectionForm) session.getAttribute("WorkClassCollectionForm");
WorkClassDetailForm testForm = (WorkClassDetailForm)session.getAttribute("CreateWorkClassStep2Form");
WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
String wcType = (String)session.getAttribute("requestType");
boolean isEJBModule = ((Boolean)session.getAttribute("isEJBModule")).booleanValue();
int wcScope = wccf.getWCScope();
String edition = wccf.getEdition();

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
String removeButtonClicked = "initVars(this);removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVars(this);addClicked(selectedAvailableNodes)";
String addFilterButtonClicked = "initVars(this);addFilterClicked()";
String modDropDownChanged = "initVars(this);webModNameChange()";
String methodDropDownChanged = "initVars(this);methodNameChange()";
String jmsEJBDropDownChanged = "initVars(this);jmsEJBNameChange()";
String enableFilterClicked = "initVars(this);enableFilterClicked()";
boolean isMethodEnabled = testForm.getEnableFilter();

if (wcType.equals(WorkClassConstants.IIOP) || wcType.equals(WorkClassConstants.JMS))
	addFilterButtonClicked = "initVars(this);addFilter2Clicked()";

String message = "";
try {
%>

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
							<label for="selectedJMSEJB">
								<bean:message key="workclass.methodcall.iiop" />
							</label>
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
							<label for="selectedMethod">		
								<bean:message key="<%=message%>" />
							</label>
						</td>
						<td class="table-text">
							<html:select size="1" value="<%=selectedMethod%>" property="NotUsed" styleId="selectedMethod"
										 onchange="<%=methodDropDownChanged%>" disabled="<%=!isMethodEnabled%>">
								<html:options name="methodNamesBean" />
							</html:select>
<%							   if (wcType.equals(WorkClassConstants.IIOP) || wcType.equals(WorkClassConstants.JMS)) { %>
							<label for="enableFilter">
								<html:checkbox property="enableFilter" value="true" styleId="enableFilter" onchange="<%=enableFilterClicked%>"/>
								<% message = WorkClassConfigUtils.getLabel("workclass.enablefilter", wcType); %>
								<bean:message key="<%=message%>" />
							</label>
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
						<td valign="top"  class="table-text" >
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
						<td rowspan="2" valign="top"  class="table-text">
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
			</td>
    	</tr>
    	<html:hidden property="currentContextRoot" styleId="contextRoot" value="<%=contextRoot%>"/>        
      </table>
 <% } 
 catch (Exception e) { System.out.println("Caught Exception" + e.toString()); e.printStackTrace();} %>
