<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.CreateServiceClassStep1Form"%>
<%@ page import="com.ibm.ws.xd.config.operationalpolicy.OperationalPolicyConstants"%>
<%@ page import="java.beans.*"%>
<%@ page  errorPage="/error.jsp"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="descImage" classname="java.lang.String" />

<script language="JavaScript">
var changing = false;
var selectedCurrentNodes; // array of currently selected member nodes 
var currentNodes;
var outputField;
var inited = false;
var originalOutputField;
var originalNodes;  //this is an array of all the nodes originally in either box


function addClicked(optionsToAdd) {
	window.location = "/ibm/console/CreateServiceClassStep3.do?&AddClicked=true"  
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++){
			optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
		window.location = encodeURI("/ibm/console/CreateServiceClassStep3.do?&RemoveClicked=true" + "&StringToRemove=" + encodeURI(optionsToRemoveString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function modifyClicked(optionsToModify) {
	if (optionsToModify.length == 1) {
		var optionsToModifyString = optionsToModify[0].value;
		window.location = encodeURI("/ibm/console/CreateServiceClassStep3.do?&ModifyClicked=true" + "&StringToModify=" + encodeURI(optionsToModifyString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function initVars(){
	if (inited){
		return;
	}
	
	changing = false;
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	originalNodes = new Array();							
	currentNodes = document.forms[0].elements[2];
	
	inited=true;
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


//optionsList: options array from a select object which will be emptied, and repopulated according to "stringValue"
//stringValue: "!" tokenized string of values which correspond to the nodes which will be placed in "optionsList"
function setOptionsList(optionsList, stringValue){
	optionsList.length = 0;
	var tokens = stringValue.split("!");
	for (var a = 0; a < tokens.length; a++){
		if (tokens[a].length > 0)
			optionsList[optionsList.length] = new Option(tokens[a], tokens[a], false, false);			
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
   fieldLevelHelpTopic = "CreateServiceClassStep1Form.detail.";
   String topicKey = fieldLevelHelpTopic;
   fieldLevelHelpTopic = fieldLevelHelpTopic + "membership";
%>


<%
CreateServiceClassStep1Form testForm = (CreateServiceClassStep1Form)session.getAttribute("CreateServiceClassStep3Form");
Collection selectedNodesBean = testForm.getTCNames();
selectedNodesBean.add(OperationalPolicyConstants.DEFAULT_TC_NAME+testForm.getName());
String refId = testForm.getRefId();
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
try {
%>



	<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%" role="presentation">
		<tr>
    		<td class="table-text" valign="top">
    			<label title='<bean:message key="serviceclass.wizard.membershipinstruction"/>'>
            	<bean:message key="serviceclass.detail.membershipdescription" />
            	</label>
    		<br>
	    	<br>
    		</td>
        </tr>
        <tr>
			<td class="table-text">
			<table role="presentation">
				<tr>
					<td align="center" valign="top" colspan=1>
						<span class="table-text"> 
							<label for='transactionClassMembers' title='<bean:message key="serviceclass.details.membersOf.title"/>'>
								<bean:message	key="serviceclass.details.membersOf" arg0="<%=refId%>"/> 
							</label>
						</span>
					</td>
					
				</tr>
				<tr>
					<td align="center" rowspan=2 valign="top" class="table-text" width="35%">
						<html:select multiple="true" size="10" property="notUsed" 
									 onchange="initVars();setSelectedNodes(selectedCurrentNodes, currentNodes)"
									 style="width:200px;"
									 styleId="transactionClassMembers">
							<html:options name="selectedNodesBean" />
						</html:select>
					</td>
                    <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">
						<html:button styleClass="buttons_other" property="notUsed" 
						             onclick="initVars();addClicked(selectedCurrentNodes)">
							<bean:message key="serviceclass.button.add" /> 
						</html:button>
						<br>
						<br>
						<html:button styleClass="buttons_other" property="notUsed" 
									 onclick="initVars();removeClicked(selectedCurrentNodes)">
							 <bean:message key="serviceclass.button.remove" />
						</html:button>
						<br>
						<br>
						<!--<html:button styleClass="buttons" property="notUsed"
									 onclick="initVars();modifyClicked(selectedCurrentNodes)">
							 <bean:message key="serviceclass.button.modify" />
						</html:button>-->
						
					</td>		
				</tr>
			</table>
		</tr>

        
	</table>

 <% } 
 catch (Exception e) { System.out.println("Caught Exception"); e.printStackTrace();} %>
