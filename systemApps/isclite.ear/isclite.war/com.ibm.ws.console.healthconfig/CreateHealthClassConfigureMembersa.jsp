<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.util.XDConstants,com.ibm.ws.console.healthconfig.util.Constants"%>
<%@ page import="com.ibm.ws.console.healthconfig.form.CreateHealthClassWizardForm"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="descImage" classname="java.lang.String" />
   <%
	MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
	%>
<%
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

   String fieldLevelHelpTopic = "CreateHealthClassWizardForm.detail.";
   String topicKey = fieldLevelHelpTopic;
%>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>

<SCRIPT>
var changing = false;
var selectedAvailableAP; // array of currently selected available nodes (for Applications)
var selectedCurrentAP; // array of currently selected member nodes (for Applications)
var availAP;
var currentAP;
var selectedAvailableCL; // array of currently selected available nodes (for Clusters)
var selectedCurrentCL; // array of currently selected member nodes (for Clusters)
var availCL;
var currentCL;
var selectedAvailableDC; // array of currently selected available nodes (for Dynamic Clusters)
var selectedCurrentDC; // array of currently selected member nodes (for Dynamic Clusters)
var availDC;
var currentDC;
var selectedAvailableGSC; // array of currently selected available nodes (for Generic Server Clusters)
var selectedCurrentGSC; // array of currently selected member nodes (for Generic Server Clusters)
var availODR;
var currentODR;
var selectedAvailableODR; // array of currently selected available nodes (for ODR)
var selectedCurrentODR; // array of currently selected member nodes (for ODR)
var availGSC;
var currentGSC;
var availField;
var outputField;
var inited = false;
var originalAvailFieldAP;
var originalOutputFieldAP;
var originalAvailFieldCL;
var originalOutputFieldCL;
var originalAvailFieldDC;
var originalOutputFieldDC;
var originalAvailFieldGSC;
var originalOutputFieldGSC;
var originalAvailFeldODR;
var originalOutputFieldODR;

//Testing from CustomPropsLayout
var selectedAvailableNodes; // array of currently selected available nodes
var selectedCurrentNodes; // array of currently selected member nodes
var availNodes;
var currentNodes;
var availField;
var outputField;
var originalAvailField;
var originalOutputField;
var descField;
var conditionField;
var modeField;
var cellLevelField;




/*
This function sets the global selectedAvailableAP, selectedAvailableCL or selectedAvailableDC array to correspond with the selected
objects in the box represented by "nodeList" (either currentAP or availAP)
*/
function setSelected(nodeList, selectObject){
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
			tempString += ",";			
		}
		tempString += nodeList[y].value;
		first = false;
	}	
      //alert("TempString: " + tempString);
	changing = false;
}


/*
Adds all objects in "optionsToMove" to "to", and removes all of those objects from "from"
optionsToMove: one of either selectedCurrentAP or selectedAvailableAP, selectedCurrentCL or selectedAvailableCL, or selectedCurrentDC or selectedAvailableDC
from:  An options array (from either availAP or currentAP, availCL or currentCL, or availDC or currentDC)
to:    An options array (from the other of either availAP or currentAP, availCL or currentCL, or availDC or currentDC)
*/
function moveOptions(optionsToMove, from, to){
        changing = true;
        for(var x = 0; x < from.length; x++){
                if (!from[x].selected)
                        continue;
                moveThis = from[x];
                remove(to, moveThis); //in case it's already in there
                to[to.length] = new Option(moveThis.value, moveThis.value, false, false);
                remove(from, moveThis);
                x--;//we removed the top of the list...gotta bump back this index.  we could start at the end of the list and work backwards, but then the items would be added in reverse order, which could look weird.
        }

        updateHiddenFields();
        empty(optionsToMove);
        changing = false;
}

/*
Removes all references to "removeThis" from "from"
from:  Array from which any references that are equal to "removeThis" will be removed
removeThis: object which will be removed from "from"
*/
function remove(from, removeThis){
	for (var x = 0; x < from.length; x++){
		if (from[x] == removeThis){
			from[x] = null; //since from is an options array, doing this removes the object
		}
	}
}

//this function removes all elements from the array "nodeList"
function empty(nodeList){
	for (x=0; x<nodeList.length; x++){
		nodeList.pop();
	}
}

//removes the object in cell "index" in "theArray" and shrinks "theArray" by one.
function deleteCellFromArray(index, theArray){
	if ( (index < 0) || (index >= theArray.length))
		return;

	for (var x = index; x < (theArray.length - 1); x++){
		theArray[x] = theArray[x+1];
	}
	theArray.pop(); // remove last element 		
}


function updateHiddenFields(){	
	var tempString = "";
	if (currentNodes.options.length > 0){
		tempString += currentNodes.options[0].value;
		for (var x = 1; x < currentNodes.options.length; x++){
			tempString += "," + currentNodes.options[x].value;
		}		
	}	
	outputField.value = tempString;	
	
	tempString = "";
	if (availNodes.options.length > 0){
		tempString += availNodes.options[0].value;
		for (var x = 1; x < availNodes.options.length; x++){
			tempString += "," + availAP.options[x].value;
		}		
	}
	availField.value = tempString;
}

function submitIt(){
	initVars();
	while (changing){}
	changing=true;
	updateHiddenFields();
	document.forms[0].submit();
}

//this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm(){
	initVars(); //just in case it hasn't been called yet
	setOptionsList(currentAP.options, originalOutputFieldAP);
	setOptionsList(availAP.options, originalAvailFieldAP);	
	setOptionsList(currentCL.options, originalOutputFieldCL);
	setOptionsList(availCL.options, originalAvailFieldCL);	
	setOptionsList(currentDC.options, originalOutputFieldDC);
	setOptionsList(availDC.options, originalAvailFieldDC);	
	setOptionsList(currentGSC.options, originalOutputFieldGSC);
	setOptionsList(availGSC.options, originalAvailFieldGSC);	
	setOptionsList(availODR.options, originalAvailFieldODR);
	setOptionsList(currentODR.options, originalOutputFieldODR);
}

//optionsList: options array from a select object which will be emptied, and repopulated according to "stringValue"
//stringValue: "," tokenized string of values which correspond to the nodes which will be placed in "optionsList"
function setOptionsList(optionsList, stringValue){
	optionsList.length = 0;
	var tokens = stringValue.split(",");
	for (var a = 0; a < tokens.length; a++){
		if (tokens[a].length > 0)
			optionsList[optionsList.length] = new Option(tokens[a], tokens[a], false, false);			
	}
}




//Testing from CustomPropsLayout
function initVars(formElem, firstMembershipFormElemIndex){

	if (inited){
		return inited;
	}
	
	var theform = formElem.form;
      //for (var i =0; i<theform.elements.length; i++) {
      //   alert('Element ' + i + ': ' + theform.elements[i] + 'Value: ' + theform.elements[i].value);
      //}	
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	availNodes = document.getElementById('availNodeField'); //leave 0 in case firstMembershipFormElemIndex is a string
	currentNodes = document.getElementById('currNodeField');
	memberTypeField = document.getElementById('memberTypeField');
	cellLevelField = theform.elements[2];
	conditionField = theform.elements[4];
	modeField = theform.elements[0];
	descField = theform.elements[1];

	inited=true;
	return inited;
}

function myOnChange() {}


function finishMethod(urlString, newDesc) {
	//add the description at the end
	urlString = urlString + "&desc=" + encodeURI(newDesc);
    urlString = urlString + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
	window.location = encodeURI(urlString);
}

function memberTypeChange() {
	//When the app name changes we need to reset the WebModName lists
	var selectedType = memberTypeField.value;
	var selectedCondition = conditionField.value;
	var newDesc = descField.value;
	var newMode = modeField.value;
	var checked = "false";
	if (cellLevelField.checked) checked="true";
	var urlString = "/ibm/console/CreateHealthClassConfigureMembers.do?memberType="+ selectedType + "&memberTypeChanged=true";
	finishMethod(urlString,newDesc);
}
	
function addClicked(optionsToAdd) {
	if (optionsToAdd.length > 0) {
               if ((optionsToAdd.length == 1) && (optionsToAdd[0].value == "-------------------------------------------"))
                  return;
		var selectedType = memberTypeField.value;
		var selectedCondition = conditionField.value;
		var newDesc = descField.value;
		var newMode = modeField.value;
		var checked = "false";
		if (cellLevelField.checked) checked="true";
		
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				optionsToAddString = optionsToAddString + ";;" + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			var urlString = "/ibm/console/CreateHealthClassConfigureMembers.do?memberType=" + selectedType + "&AddClicked=true" + "&stringToAdd=" + encodeURI(optionsToAddString);
			//alert("urlString = " + urlString);	
		}
		finishMethod(urlString,newDesc);
	}
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
               if ((optionsToRemove.length == 1) && (optionsToRemove[0].value == "-------------------------------------------"))
                  return;
		var optionsToRemoveString = "";
		var selectedCondition = conditionField.value;
		var selectedType = memberTypeField.value;
		var newDesc = descField.value;
		var newMode = modeField.value;
		var checked = "false";
		if (cellLevelField.checked) checked="true";

		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			var urlString = "/ibm/console/CreateHealthClassConfigureMembers.do?memberType=" + selectedType + "&RemoveClicked=true" + "&stringToRemove=" + encodeURI(optionsToRemoveString);	
		}
	finishMethod(urlString,newDesc);
	}
}

</SCRIPT>


<%try { %>


<%
        Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
        String numberOfColumns = "3";
        WASProduct productInfo = new WASProduct();
%>




<%
CreateHealthClassWizardForm testForm = (CreateHealthClassWizardForm)session.getAttribute("CreateHealthClassConfigureMembersForm");
int fields = 5;
//MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
java.util.Locale locale = request.getLocale();
ArrayList availableMembers = (ArrayList)testForm.getAvailableNames();
ArrayList selectedNodesBean = (ArrayList)testForm.getCurrentMembership(messages, locale);
//Do the dropdown with the member types
Collection memberTypes = new ArrayList();
memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.none"),String.valueOf(Constants.MEMBER_TYPE_NONE)));
if (testForm.getType().equalsIgnoreCase("STORMDRAIN")) {
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.dynamiccluster"),String.valueOf(XDConstants.DYNAMICCLUSTER_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.cell"),String.valueOf(XDConstants.CELL_MEMBER)));
//
// defect 305139
// commented out GSC support for now, will add this back in XD 7.0
// and also GSCs would have applied to more policy types other than RESPONSE
//
// } else if (testForm.getType().equalsIgnoreCase("RESPONSE")) {
//    memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.appserver"),String.valueOf(XDConstants.APPSERVER_MEMBER)));
//    memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.cluster"),String.valueOf(XDConstants.CLUSTER_MEMBER)));
//    memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.dynamiccluster"),String.valueOf(XDConstants.DYNAMICCLUSTER_MEMBER)));
//    memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.cell"),String.valueOf(XDConstants.CELL_MEMBER)));
//    memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.genericservercluster"),String.valueOf(XDConstants.GENERICSERVERCLUSTER_MEMBER)));
} else {
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.appserver"),String.valueOf(XDConstants.APPSERVER_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.cluster"),String.valueOf(XDConstants.CLUSTER_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.dynamiccluster"),String.valueOf(XDConstants.DYNAMICCLUSTER_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.odr"),String.valueOf(XDConstants.ODR_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.cell"),String.valueOf(XDConstants.CELL_MEMBER)));
}

//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
if (!selectedNodesBean.contains("-------------------------------------------"))
	selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");
if (!availableMembers.contains("-------------------------------------------"))
	availableMembers.add(availableMembers.size(),"-------------------------------------------");

String hcName = testForm.getRefId();
String selectedTypeString = testForm.getSelectedType(); //this is already translated

pageContext.setAttribute("availableNodesBean", availableMembers);
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
pageContext.setAttribute("appNamesBean", memberTypes);

String availNodesSelectChange = "initVars(this, " + fields + ");setSelected(selectedAvailableNodes, availNodes)";
String currNodesSelectChange = "initVars(this, " + fields + ");setSelected(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVars(this, " + fields + ");removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVars(this, " + fields + ");addClicked(selectedAvailableNodes)";
String memberTypeChanged = "initVars(this, " + fields + ");memberTypeChange()";
%>

  <table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%" role="presentation">
    <tbody>
    <tr>
      <td class="instruction-text" >
         <br><bean:message key="healthclass.detail.members.description"/>
      </td>
    </tr>
    <tr>
  		<td class="table-text" nowrap valign="top" colspan="<%= numberOfColumns %>">
		<br>
		<br>

<!-- INSERT THE MEMBERSHIP ROW HERE -->
<%
int numMembershipColumns = Integer.parseInt(numberOfColumns);
if (numMembershipColumns > 0)
	numMembershipColumns--;
	fieldLevelHelpTopic = topicKey + "membership"; 		
%>

        	<FIELDSET id="selectTemplate">
               	<legend for ="membership" TITLE="<bean:message key="healthclass.detail.membershipdescription"/>">
                 	<bean:message key="healthclass.details.membership"/>
               	</legend>

			<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">									
				<tr>
					<td class="table-text">
						<table>
							<tr>
								<td class="table-text">
									<label for="memberTypeField">
										<bean:message key="healthclass.member.filter.by" /> 							
										&nbsp;&nbsp;
									</label>									
										<html:select title="Member type" size="1" title="<%=selectedTypeString%>" value="<%=selectedTypeString%>" styleId="memberTypeField" property="notUsed" onchange="<%=memberTypeChanged%>">
	                                    	<html:options collection="appNamesBean" property="value" labelProperty="label" />
										</html:select>
								</td>
							</tr>
						</table>
						<br>
						<table role="presentation">
							<tr>
								<td valign="top">
									<span class="table-text">
										<label for="availNodeField">
											<center>
												<bean:message key="healthclass.details.availableMembers"   />
											</center>
										</label>
									</span>
								</td>
								<td>&nbsp;</td>
								<td valign="top">
									<span class="table-text">
										<label for="currNodeField">
											<center>
												<bean:message key="healthclass.details.membersOf" arg0="<%=hcName%>" />
											</center>
										</label>
									</span>
								</td>
							</tr>
							<tr>
								<td valign="top" class="table-text" width="35%">
									<html:select multiple="true" size="7" property="notUsed" styleId="availNodeField"
												 onchange="<%=availNodesSelectChange%>">
										<html:options name="availableNodesBean" />
									</html:select>
								</td>	
                                <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">
									<html:button styleClass="buttons_other" property="notUsed"
												 onclick="<%=addButtonClicked%>"
												 onkeypress="<%=addButtonClicked%>">
										<bean:message key="healthclass.button.add" />
									</html:button>
								<br>
								<br>
									<html:button styleClass="buttons_other" property="notUsed"
												 onclick="<%=removeButtonClicked%>"
												 onkeypress="<%=removeButtonClicked%>">
										 <bean:message key="healthclass.button.remove" />
									</html:button>
								</td>
								<td rowspan="2" valign="top" class="table-text" width="35%">
									<html:select multiple="true" size="7" property="notUsed" styleId="currNodeField"
												 onchange="<%=currNodesSelectChange%>">
										<html:options name="selectedNodesBean" />
									</html:select>
								</td>	
							</tr>
						</table>
					</td>
    			</tr>
    		</table>
    	</FIELDSET>
    	</td>
    	
    </tr>
	</tbody>
</table>



 <% }
catch (Exception e) {
  System.out.println("error is " + e.toString());
  e.printStackTrace();
  }
  %>
