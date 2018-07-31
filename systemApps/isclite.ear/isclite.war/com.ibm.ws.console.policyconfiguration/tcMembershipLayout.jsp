<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.TransactionClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="formBean" classname="java.lang.String"/>
<tiles:useAttribute name="readOnly" classname="java.lang.String"/>
<tiles:useAttribute name="property" classname="java.lang.String"/>
<tiles:useAttribute name="isRequired" classname="java.lang.String"/>

<% try{
System.err.println("got into tcMembershipLayout.jsp");
%>

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
var contextRootField;
var descField;

//removes leading and trailing whitespace from a string
function trimString(string){
    var s = string.replace(/^\s+/g, ""); //remove leading whitespace
    return s.replace(/\s+$/g, ""); //remove leading whitespace;
}
//this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm(){
	window.location = "/ibm/console/TransactionClassDetail.do?&ResetClicked=true" 
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function initVars(formElem, firstMembershipFormElemIndex){
	if (inited){
		return inited;
	}
	
	var theform = formElem.form;
	
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	
	availNodes = theform.availNodes;
	currentNodes = theform.currentNodes;
	filterField = theform.filterField;
	appField = theform.app;
	modField = theform.mod;
	contextRootField = theform.currentContext;
	descField = theform.elements[0];	
	inited=true;
	return inited;
}


function appNameChange() {
	//When the app name changes we need to reset the WebModName lists
	var selectedApp = appField.value;
	var newDesc = descField.value;
	window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&AppChanged=true" + "&desc=" + encodeURI(newDesc)
      + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}
	
function webModNameChange() {
	var selectedMod = modField.value;
	var selectedApp = appField.value;
	var newDesc = descField.value;
	window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&ModChanged=true" + "&desc=" + encodeURI(newDesc)   
      + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function addClicked(optionsToAdd) {
	if (optionsToAdd.length > 0) {
		var selectedMod = modField.value;
		var selectedApp = appField.value;
		var contextRoot = contextRootField.value;
		var newDesc = descField.value;
		
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				optionsToAddString = optionsToAddString + ";;" + contextRoot + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddClicked=true" + "&uriStringToAdd=" + encodeURI(optionsToAddString) + "&desc=" + encodeURI(newDesc)  
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var selectedMod = modField.value;
		var selectedApp = appField.value;
		var contextRoot = contextRootField.value;
		var optionsToRemoveString = "";
		var newDesc = descField.value;
		
		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&RemoveClicked=true" + "&uriStringToRemove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function addFilterClicked() {
	var selectedMod = modField.value;
	var selectedApp = appField.value;
	var contextRoot = contextRootField.value;
	var filterValueString = trimString(filterField.value);
	var newDesc = descField.value;
	
	
	if (filterValueString.length > 0) {
		if (filterValueString.charAt(0) != "/")
			filterValueString = "/" + filterValueString;
		var newFilterValue = contextRoot + filterValueString;
		window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + newFilterValue + "&desc=" + encodeURI(newDesc)  
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


function submitIt(){
	while (changing){}
	changing=true;
	//document.forms[0].submit();
}


</script>


<%
TransactionClassDetailForm testForm = (TransactionClassDetailForm)session.getAttribute("TransactionClassDetailForm");

ArrayList selectedNodesBean = (ArrayList)testForm.getSelectedURIs();
Collection appNames = testForm.getAppNamesToShow();
Collection webModNames = testForm.getWebModNamesToShow();
ArrayList uriNames = (ArrayList) testForm.getUrisToShow();

//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
if (!selectedNodesBean.contains("-------------------------------------------"))
	selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");
if (!uriNames.contains("-------------------------------------------"))
	uriNames.add(uriNames.size(),"-------------------------------------------");

String selectedApp = testForm.getSelectedApp();
String selectedMod = testForm.getSelectedMod();
String contextRoot = testForm.getContextRoot();
String tcName = testForm.getRefId();

pageContext.setAttribute("availableNodesBean", uriNames);
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
pageContext.setAttribute("appNamesBean", appNames);
pageContext.setAttribute("webModNamesBean", webModNames);
pageContext.setAttribute("contextRoot", contextRoot);


String availNodesSelectChange = "initVars(this); setSelectedNodes(selectedAvailableNodes, availNodes)";
String currNodesSelectChange = "initVars(this);setSelectedNodes(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVars(this);removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVars(this);addClicked(selectedAvailableNodes)";
String addFilterButtonClicked = "initVars(this);addFilterClicked()";
String appDropDownChanged = "initVars(this);appNameChange()";
String modDropDownChanged = "initVars(this);webModNameChange()";


%>
	<table>
        <tr>        
	        <td class="table-text" nowrap valign="top" >
				<br>
			        <bean:message key="transactionclass.membership.description"/>
				<br>                                 
		
				<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">				
								
					<tr>
						<td class="table-text">
							<table>
								<tr>
									<td class="table-text">
										<bean:message key="policy.App" /> 
										&nbsp;&nbsp;
										<html:select size="1" value="<%=selectedApp%>" property="notUsed" styleId="app"
													 onchange="<%=appDropDownChanged%>">
											<html:options name="appNamesBean"/>
										</html:select>
										&nbsp;&nbsp; 
										<bean:message key="policy.Mod" /> &nbsp;&nbsp;
										<html:select size="1" value="<%=selectedMod%>" property="notUsed" styleId="mod"
													 onchange="<%=modDropDownChanged%>">
											<html:options name="webModNamesBean" />
										</html:select>
									</td>
								</tr>
							</table>
							<br>
							<table>
								<tr>
										<td valign="top"><span class="table-text"><center>
											<bean:message key="transactionclass.details.availableURIs" arg0="<%=selectedApp%>" arg1="<%=selectedMod%>" /> 
											</center></span>
										</td>
										<td>&nbsp;</td>
										<td valign="top"> <span class="table-text"><center>
											<bean:message key="transactionclass.details.membersOf" arg0="<%=tcName%>" />
											</center></span> 
										</td>
									</tr>
									<tr>
										<td valign="top"  class="table-text" >
											<html:select multiple="true" size="8" property="notUsed" styleId="availNodes"
														 onchange="<%=availNodesSelectChange%>">
												<html:options name="availableNodesBean" />
											</html:select>
										</td>	
										<td align="center" valign="middle"  width="160px">	
											<html:button styleClass="buttons" property="notUsed" styleId="addButton"
														 onclick="<%=addButtonClicked%>">
												<bean:message key="transactionclass.button.add" /> 
											</html:button> 
										<br>
										<br>
											<html:button styleClass="buttons" property="notUsed" styleId="removeButton"
														 onclick="<%=removeButtonClicked%>">
												 <bean:message key="transactionclass.button.remove" />
											</html:button>
										</td>
										<td rowspan="2" valign="top"  class="table-text">
											<html:select multiple="true" size="12" property="notUsed" styleId="currentNodes"
														 onchange="<%=currNodesSelectChange%>">
												<html:options name="selectedNodesBean" />
											</html:select>
										</td>
									</td>
								</tr>
				
								<tr>
									<td valign="bottom">
										<span class="table-text"><bean:message key="filterFieldLabel" /><br>
				            			<html:text property="filterField" style="width:200px" styleId="filterField" styleId="filterField" disabled="false" /></span>
				            		</td>
				            		<td align="center" valign="bottom"><br>
				            			<html:button styleClass="buttons" property="notUsed" styleId="addFilterButton"
													 onclick="<%=addFilterButtonClicked%>">
											<bean:message key="transactionclass.button.addFilter"  />
				            			</html:button>   
				 					</td>
								</tr>
							</table>
						</td>
		        	</tr>
        
     		        <html:hidden property="currentContextRoot" 	value="<%=contextRoot%>" styleId="currentContext"/>		          
			        
			    </table>
			</td>
        </tr>
    </table>
    
    <%} catch (Exception e){e.printStackTrace();} %>
