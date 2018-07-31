<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2004, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.xd.operations.impl.XDOperationsViewConfigHelper"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<% try{ %>

<tiles:useAttribute name="formBean" classname="java.lang.String"/>
<tiles:useAttribute name="readOnly" classname="java.lang.String"/>
<tiles:useAttribute name="property" classname="java.lang.String"/>
<tiles:useAttribute name="isRequired" classname="java.lang.String"/>

<script language="JavaScript">

function myOnChange() 
{
	var goalTypeValue = document.ServiceClassDetailForm.goalType.value;
	if (goalTypeValue == "GOAL_TYPE_DISCRETIONARY") {
		disableTextField(document.ServiceClassDetailForm.goalValue);
		disableTextField(document.ServiceClassDetailForm.goalPercent);
		document.ServiceClassDetailForm.timeInterval.disabled = true;
			document.ServiceClassDetailForm.importance.disabled = true;
<%
		String enableResponseTimeGoals = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
		enableResponseTimeGoals = enableResponseTimeGoals.trim();
		if (enableResponseTimeGoals.equalsIgnoreCase("true")) {
%>
			document.ServiceClassDetailForm.importance.disabled = false;
<%
		}
%>
	}
	if (goalTypeValue == "GOAL_TYPE_PCT_RESPONSE_TIME") {
		enableTextField(document.ServiceClassDetailForm.goalValue);
		enableTextField(document.ServiceClassDetailForm.goalPercent);
		document.ServiceClassDetailForm.importance.disabled = false;
		document.ServiceClassDetailForm.timeInterval.disabled = false;
	}
	if (goalTypeValue == "GOAL_TYPE_AVG_RESPONSE_TIME") {
		document.ServiceClassDetailForm.timeInterval.disabled = false;
		document.ServiceClassDetailForm.importance.disabled = false;
		enableTextField(document.ServiceClassDetailForm.goalValue);
		disableTextField(document.ServiceClassDetailForm.goalPercent);
		if (document.ServiceClassDetailForm.timeInterval.value == "UNITS_NONE")
			document.ServiceClassDetailForm.timeInterval.value = "UNITS_SECONDS";
	}
	if (goalTypeValue == "GOAL_TYPE_QUEUETIME") {
		document.ServiceClassDetailForm.timeInterval.disabled = false;
		document.ServiceClassDetailForm.importance.disabled = false;
		enableTextField(document.ServiceClassDetailForm.goalValue);
		disableTextField(document.ServiceClassDetailForm.goalPercent);
		document.ServiceClassDetailForm.timeInterval.value = "UNITS_MINUTES";
	}
	if (goalTypeValue == "GOAL_TYPE_COMPLETIONTIME") {
		document.ServiceClassDetailForm.timeInterval.disabled = false;
		document.ServiceClassDetailForm.importance.disabled = false;
		enableTextField(document.ServiceClassDetailForm.goalValue);
		disableTextField(document.ServiceClassDetailForm.goalPercent);
		document.ServiceClassDetailForm.timeInterval.value = "UNITS_MINUTES";
	}
}

function disableTextField(field) {
if (document.all || document.getElementById)
   field.disabled = true;
else {
	field.oldOnFocus = field.onfocus;
	field.onfocus=skip;
	}
}

function enableTextField(field) {
if (document.all || document.getElementById)
   field.disabled = false;
else {
	field.onfocus = field.oldOnFocus;
	}
}

var changing = false;
var selectedAvailableNodes; // array of currently selected available nodes 
var selectedCurrentNodes; // array of currently selected member nodes 
var availNodes;
var currentNodes;
var inited = false;
var descField;
var valueField;
var impField;
var timeField;
var typeField;
var percentField;

var spvGoalDeltaValue;
var spvGoalDeltaValueUnit;
var spvTimePeriodValue;
var spvTimePeriodValueUnit;
var spvGoalDeltaPercent;
var spvViolationEnabled;

function addClicked(optionsToAdd) {
	var optionsToAddString = "";
	var newDesc = descField.value;
	var newValue = valueField.value;
	var newImp = impField.value;
	var newTime = timeField.value;
	var newType = typeField.value;
	var newPercent = percentField.value;

	var newGDValue = spvGoalDeltaValue.value;
	var newGDVUnit = spvGoalDeltaValueUnit.value;
	var newTPValue = spvTimePeriodValue.value;
	var newTPVUnit = spvTimePeriodValueUnit.value;
	var newGDPercent = spvGoalDeltaPercent.value;
	var newSPVBox = spvViolationEnabled.value;

	window.location = encodeURI("/ibm/console/ServiceClassDetail.do?AddClicked=true" + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp=" + newImp + "&time=" + newTime + "&pct=" + newPercent + "&type=" + newType + "&gdvalue=" + newGDValue + "&gdvunit=" + newGDVUnit + "&tpvalue=" + newTPValue + "&tpvunit=" + newTPVUnit + "&gdpercent=" + newGDPercent + "&spvbox=" + newSPVBox + "&uriStringToAdd=" + optionsToAddString
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++) {
			optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		optionsToRemoveString=optionsToRemoveString.substring(2); // take off the first 2 ";;"

		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;

		var newGDValue = spvGoalDeltaValue.value;
		var newGDVUnit = spvGoalDeltaValueUnit.value;
		var newTPValue = spvTimePeriodValue.value;
		var newTPVUnit = spvTimePeriodValueUnit.value;
		var newGDPercent = spvGoalDeltaPercent.value;
		var newSPVBox = spvViolationEnabled.value;

		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?RemoveClicked=true" + "&StringToRemove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp=" + newImp + "&time=" + newTime + "&pct=" + newPercent + "&type=" + newType + "&gdvalue=" + newGDValue + "&gdvunit=" + newGDVUnit + "&tpvalue=" + newTPValue + "&tpvunit=" + newTPVUnit + "&gdpercent=" + newGDPercent + "&spvbox=" + newSPVBox
          + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function moveClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++) {
			optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		optionsToRemoveString=optionsToRemoveString.substring(2); // take off the first 2 ";;"

		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;

		var newGDValue = spvGoalDeltaValue.value;
		var newGDVUnit = spvGoalDeltaValueUnit.value;
		var newTPValue = spvTimePeriodValue.value;
		var newTPVUnit = spvTimePeriodValueUnit.value;
		var newGDPercent = spvGoalDeltaPercent.value;
		var newSPVBox = spvViolationEnabled.value;

		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?MoveClicked=true" + "&StringToMove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp=" + newImp + "&time=" + newTime + "&pct=" + newPercent + "&type=" + newType + "&gdvalue=" + newGDValue + "&gdvunit=" + newGDVUnit + "&tpvalue=" + newTPValue + "&tpvunit=" + newTPVUnit + "&gdpercent=" + newGDPercent + "&spvbox=" + newSPVBox
         + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function modifyClicked(optionsToRemove) {
	if (optionsToRemove.length == 1) {
		var optionsToRemoveString = "";
		optionsToRemoveString=optionsToRemove[0].value; 
		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;

		var newGDValue = spvGoalDeltaValue.value;
		var newGDVUnit = spvGoalDeltaValueUnit.value;
		var newTPValue = spvTimePeriodValue.value;
		var newTPVUnit = spvTimePeriodValueUnit.value;
		var newGDPercent = spvGoalDeltaPercent.value;
		var newSPVBox = spvViolationEnabled.value;

		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?EditClicked=true" + "&StringToModify=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp=" + newImp + "&time=" + newTime + "&pct=" + newPercent + "&type=" + newType + "&gdvalue=" + newGDValue + "&gdvunit=" + newGDVUnit + "&tpvalue=" + newTPValue + "&tpvunit=" + newTPVUnit + "&gdpercent=" + newGDPercent + "&spvbox=" + newSPVBox
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	} else {
		// I need to figure out how to put up a message that they have to pick only one.
	}
}

function viewClicked(optionsToView) {
    var optionsToViewString = "";
    if (optionsToView.length == 1) {
        optionsToViewString = optionsToView[0].value;
    } else {
        // Either none selected or more than 1 selected. Display a message to select 1.
    }
    window.location = encodeURI("/ibm/console/ServiceClassDetail.do?ViewClicked=true" + "&StringToView=" + encodeURI(optionsToViewString)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function initROVars(formElem) {
	if (inited) {
		return inited;
	}

	var theform = formElem.form;
	changing = false;
	selectedCurrentNodes = new Array(); // associative array of currently selected member nodes (keyed on Node Name)
	currentNodes = theform.TCSelectBox; // theform.elements[7];
	inited = true;
	return inited;
}

function initVars(formElem, firstMembershipFormElemIndex) {
	if (inited) {
		return inited;
	}

	var theform = formElem.form;

	/*
	var otherWindow = window.open();
	var doc = otherWindow.document;
	for (var i = 0; i < theform.elements.length; i++) {
		var elem = theform.elements[i];
		doc.writeln("elements[" + i + "] type: " + elem.type + ", value: " + elem.value + ", name: " + elem.name + "<BR>");
	}
	*/
	
	changing = false;
	selectedAvailableNodes = new Array(); // associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); // associative array of currently selected member nodes (keyed on Node Name)
	
	descField = theform.description // theform.elements[1];
	typeField = theform.goalType; // theform.elements[3];
	valueField = theform.goalValue; // theform.elements[4];
	percentField = theform.goalPercent; // theform.elements[6];
	impField = theform.importance; // theform.elements[7];
	timeField = theform.timeInterval; // theform.elements[5];
	currentNodes = theform.TCSelectBox; // theform.elements[9];

	spvGoalDeltaValue = theform.goalDeltaValue;
	spvGoalDeltaValueUnit = theform.goalDeltaValueUnits;
	spvTimePeriodValue = theform.timePeriodValue;
	spvTimePeriodValueUnit = theform.timePeriodValueUnits;
	spvGoalDeltaPercent = theform.goalDeltaPercent;
	spvViolationEnabled = theform.violationEnabled;

	inited = true;
	return inited;
}

/*
This function sets the global selectedAvailableNodes array to correspond with the selected 
objects in the box represented by "nodeList" (either currentNodes or availNodes)
*/
function setSelectedNodes(nodeList, selectObject) {
	changing = true;
	empty(nodeList);
	var numSelected = 0;	
	var itemSelected;
	if (selectObject.selectedIndex != -1) {
		var index = 0;
		var str;
		for (var x = 0; x < selectObject.options.length; x++) {
			if (selectObject.options[x].selected) {
				nodeList[index++] = selectObject.options[x]; // copy a reference to this field into our list of selected Options
				itemSelected = selectObject.options[x].value;
				numSelected = numSelected + 1;
			}				
		}		
	}

	var tempString = "";
	first = true;
	for (var y = 0; y < nodeList.length; y++) {
		if (!first) {
			tempString += "!";			
		}
		tempString += nodeList[y].value;
		first = false;
	}	

	changing = false;
}

// this function removes all elements from the array "nodeList"
function empty(nodeList) {
	for (x=0; x < nodeList.length; x++) {
		nodeList.pop();
	}
}

function submitIt() {
	while (changing) {}
	changing=true;
	// document.forms[0].submit();
}

// this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm() {
	window.location = "/ibm/console/ServiceClassDetail.do?&ResetClicked=true" 
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

// optionsList: options array from a select object which will be emptied, and repopulated according to "stringValue"
// stringValue: "!" tokenized string of values which correspond to the nodes which will be placed in "optionsList"
function setOptionsList(optionsList, stringValue) {
	optionsList.length = 0;
	var tokens = stringValue.split("!");
	for (var a = 0; a < tokens.length; a++) {
		if (tokens[a].length > 0)
			optionsList[optionsList.length] = new Option(tokens[a], tokens[a], false, false);			
	}
}

</script>

<%
ServiceClassDetailForm testForm = (ServiceClassDetailForm)session.getAttribute(formBean);
Collection selectedNodesBean = testForm.getTCNames();
String scName = testForm.getRefId();
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
String currNodesSelectChange = "initVars(this);setSelectedNodes(selectedCurrentNodes, currentNodes)";
%>
	<table role="presentation">
		<tr>
			<td class="table-text" valign="top">
				<br>
				    <label title='<bean:message key="serviceclass.membership.description"/>'>
							<bean:message key="serviceclass.membership.description"/>
                    </label>
                    <br />
      				<div style="margin-top:1em;margin-left:1em">   
	      				<a href="/ibm/console/com.ibm.ws.console.guidedactivity.forwardCmd.do?forwardName=guidedactivity.configDeployApp.main&returning=true&fromStep=3">
			                <img src="/ibm/console/com.ibm.ws.console.guidedactivity/images/cheatsheet_view.gif" ALT='<bean:message key="serviceclass.membership.guidedactivity"/>' align="absmiddle" border="0"/>
			                <bean:message key="serviceclass.membership.link"/>
    		            </a>
               		</div>
				<br>
				<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="table-text">
							<table role="presentation">
								<tr>
				        			<td align="center" valign="top" width="35%">
										<span class="table-text"> 
						             		<label for="TCSelectBox">
						             			<bean:message key="serviceclass.details.membersOf" arg0="<%=scName%>"/> 
						             		</label>
										</span>
									</td>
								</tr>
								<tr>
									<td align="center" rowspan=2 valign="top" class="table-text">
											<html:select multiple="true" size="10" property="notUsed" 
														 onchange="<%=currNodesSelectChange%>"
														 style="width:200px;" styleId="TCSelectBox">
												<html:options name="selectedNodesBean" />
											</html:select>
									</td>
									<% if (readOnly.equalsIgnoreCase("true")){ 
										String viewButtonClicked = "initROVars(this);viewClicked(selectedCurrentNodes)";
									%>
									<td align="center" valign="middle" width="30%">	
										<br>
											<html:button styleClass="buttons_functions" property="notUsed"
														 onclick="<%=viewButtonClicked%>">
												 <bean:message key="serviceclass.button.view" />
											</html:button>
										<br>
									</td>									
									<%} else {
											String removeButtonClicked = "initVars(this);removeClicked(selectedCurrentNodes)";
											String addButtonClicked = "initVars(this);addClicked(selectedAvailableNodes)";
											String moveButtonClicked = "initVars(this);moveClicked(selectedCurrentNodes)";
											String modifyButtonClicked = "initVars(this);modifyClicked(selectedCurrentNodes)";
									%>
									<td align="center" valign="middle" width="30%">	
										<html:button styleClass="buttons_functions" property="notUsed"
													 onclick="<%=addButtonClicked%>">
											<bean:message key="serviceclass.button.add" /> 
										</html:button>
										<html:button styleClass="buttons_functions" property="notUsed"
													 onclick="<%=removeButtonClicked%>">
											 <bean:message key="serviceclass.button.remove" />
										</html:button>
										<html:button styleClass="buttons_functions" property="notUsed"
													 onclick="<%=modifyButtonClicked%>">
											 <bean:message key="serviceclass.button.modify" />
										</html:button>
										<html:button styleClass="buttons_functions" property="notUsed"
													 onclick="<%=moveButtonClicked%>">
											 <bean:message key="serviceclass.button.move" />
										</html:button>
									</td>
									<%}%>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

<% } catch (Exception e) { e.printStackTrace(); } %>
