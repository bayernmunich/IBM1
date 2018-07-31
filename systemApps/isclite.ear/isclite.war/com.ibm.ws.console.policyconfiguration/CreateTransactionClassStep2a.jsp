<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.TransactionClassDetailForm,com.ibm.ws.console.policyconfiguration.util.*"%>
<%@ page import="java.beans.*"%>
<%@ page  errorPage="/error.jsp"%>
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


function appNameChange() {
	//When the app name changes we need to reset the WebModName lists
	var selectedApp = document.forms[0].selectedApp.value;
	window.location = encodeURI("/ibm/console/CreateTransactionClassStep2.do?appName=" + encodeURI(selectedApp) + "&AppChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}
	
function webModNameChange() {
	var selectedMod = document.forms[0].selectedMod.value;
	var selectedApp = document.forms[0].selectedApp.value;
	window.location = encodeURI("/ibm/console/CreateTransactionClassStep2.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&ModChanged=true"  
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function addClicked(optionsToAdd) {
	if (optionsToAdd.length > 0) {
		var selectedMod = document.forms[0].selectedMod.value;
		var selectedApp = document.forms[0].selectedApp.value;
		var contextRoot = document.forms[0].contextRoot.value;
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				optionsToAddString = optionsToAddString + ";;" + contextRoot + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/CreateTransactionClassStep2.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddClicked=true" + "&uriStringToAdd=" + encodeURI(optionsToAddString) 
              + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var selectedMod = document.forms[0].selectedMod.value;
		var selectedApp = document.forms[0].selectedApp.value;
		var contextRoot = document.forms[0].contextRoot.value;
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/CreateTransactionClassStep2.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&RemoveClicked=true" + "&uriStringToRemove=" + encodeURI(optionsToRemoveString)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function addFilterClicked() {
	var selectedMod = document.forms[0].selectedMod.value;
	var selectedApp = document.forms[0].selectedApp.value;
	var contextRoot = document.forms[0].contextRoot.value;
	var filterValueString = trimString(document.forms[0].filter.value);
	if (filterValueString.length > 0) {
		if (filterValueString.charAt(0) != "/")
			filterValueString = "/" + filterValueString;
		var newFilterValue = contextRoot + filterValueString;
		window.location = encodeURI("/ibm/console/CreateTransactionClassStep2.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + encodeURI(newFilterValue)
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
   fieldLevelHelpTopic = "CreateTransactionClassStep1Form.detail.";
   String topicKey = fieldLevelHelpTopic;
   fieldLevelHelpTopic = topicKey + "membership";
%>


<%
TransactionClassDetailForm testForm = (TransactionClassDetailForm)session.getAttribute("CreateTransactionClassStep2Form");

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
String refId = testForm.getRefId();

pageContext.setAttribute("availableNodesBean", uriNames);
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
pageContext.setAttribute("appNamesBean", appNames);
pageContext.setAttribute("webModNamesBean", webModNames);
pageContext.setAttribute("contextRoot", contextRoot);

try {
%>

	<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="table-text">
				<table>
						<tr>
							<td class="table-text" colspan=3>	
                                <label for="description" title='<bean:message key="transactionclass.detail.membershipinstruction"/>'>
								   <bean:message key="transactionclass.membership.description"/>
                                </label>
                                <br><br>
						</td>
						</tr>		
					<tr>
						<td class="table-text">
							&nbsp;<bean:message key="policy.App" /> 
							<br>
							<html:select size="1" value="<%=selectedApp%>" property="NotUsed" styleId="selectedApp"
										 onchange="initVars();appNameChange()">
								<html:options name="appNamesBean"/>
							</html:select>
							&nbsp;&nbsp; 
							<bean:message key="policy.Mod" /> &nbsp;&nbsp;
							<html:select size="1" value="<%=selectedMod%>" property="NotUsed" styleId="selectedMod"
										 onchange="initVars();webModNameChange()">
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
							<bean:message key="transactionclass.details.membersOf" arg0="<%=refId%>"/>
							</center></span> 
						</td>
					</tr>
					<tr>
						<td valign="top"  class="table-text" >
							<html:select multiple="true" size="8" property="notUsed" styleId="available"
										 onchange="initVars();setSelectedNodes(selectedAvailableNodes, availNodes)">
								<html:options name="availableNodesBean" />
							</html:select>
						</td>	

                        <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">	
							<html:button styleClass="buttons" property="notUsed" 
										 onclick="initVars();addClicked(selectedAvailableNodes)"
										 styleId="other">
								<bean:message key="transactionclass.button.add" /> 
							</html:button> 
						<br>
						<br>
							<html:button styleClass="buttons" property="notUsed" 
							             onclick="initVars();removeClicked(selectedCurrentNodes)"
										 styleId="other">
								<bean:message key="transactionclass.button.remove" />
							</html:button>
						</td>
						<td rowspan="2" valign="top"  class="table-text">
							<html:select multiple="true" size="12" property="notUsed" styleId="selected"
										 onchange="initVars();setSelectedNodes(selectedCurrentNodes, currentNodes)">
								<html:options name="selectedNodesBean" />
							</html:select>
						</td>
					</tr>
     				<tr>
	    				<td valign="bottom">
		    				<span class="table-text"><bean:message key="filterFieldLabel" /><br>
                			<html:text property="filterField" styleId="filter" style="width:200px" styleId="filter" disabled="false" /></span>
            	    	</td>
                        <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%"><br>
                			<html:button styleClass="buttons" property="notUsed" 
                			             onclick="initVars();addFilterClicked()" 
                                         styleId="other">
			     				<bean:message key="transactionclass.button.addFilter"  /> 
            	      		</html:button>   
 				    	</td>
			    	</tr>
    			</table>
	      		<br>
			    </td>
    		</tr>
		
	    	<html:hidden property="currentContextRoot" styleId="contextRoot" value="<%=contextRoot%>"/>
        
      </table>

 <% } 
 catch (Exception e) { System.out.println("Caught Exception" + e.toString()); e.printStackTrace();} %>
