<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

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
var selectedAvailableODR; // array of currently selected available nodes 
var selectedCurrentODR; // array of currently selected member nodes 
var availODR;
var currentODR;
var availField;
var outputField;
var inited = false;
var originalAvailField;
var originalOutputField;

function initVars(formElem){
	if (inited){
		return inited;
	}
	
	var theform = formElem.form;
	
	changing = false;
	selectedAvailableODR = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentODR = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	
	var firstindex = -1;
	//find the index of the first form element.
	for (var i = 0; i < theform.elements.length; i++){
		if (theform.elements[i].name == "notUsed"){//notUsed is the name of the first form element in the membership form
			firstindex = i;
			break;
		}			
	}
	
	availODR = theform.elements[firstindex]; //leave 0 in case firstMembershipFormElemIndex is a string
	currentODR = theform.elements[3 + firstindex];
	availField = theform.elements[4 + firstindex];
	outputField = theform.elements[5 + firstindex];
	
	originalAvailField = availField.value;
	originalOutputField = outputField.value;
	
	inited=true;
	return inited;
}

/*
This function sets the global selectedAvailableODR array to correspond with the selected 
objects in the box represented by "nodeList" (either currentODR or availODR)
*/
function setSelectedODR(nodeList, selectObject){
	changing = true;
	empty(nodeList);	
	if (selectObject.selectedIndex != -1){
		var index=0;
		var str;
		for (var x = 0; x < selectObject.options.length; x++) {
			if (selectObject.options[x].selected){				
				nodeList[index++] = selectObject.options[x]; //copy a reference to this field into our list of selected Options
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

	changing = false;
}

/*
Adds all objects in "optionsToMove" to "to", and removes all of those objects from "from"
optionsToMove: one of either selectedCurrentODR or selectedAvailableODR 
from:  An options array (from either availODR or currentODR)
to:    An options array (from the other of either availODR or currentODR)
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
	if (currentODR.options.length > 0){
		tempString += currentODR.options[0].value;
		for (var x = 1; x < currentODR.options.length; x++){
			tempString += "," + currentODR.options[x].value;
		}		
	}	
	outputField.value = tempString;	
	
	tempString = "";
	if (availODR.options.length > 0){
		tempString += availODR.options[0].value;
		for (var x = 1; x < availODR.options.length; x++){
			tempString += "," + availODR.options[x].value;
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
	setOptionsList(currentODR.options, originalOutputField);
	setOptionsList(availODR.options, originalAvailField);	
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

</SCRIPT>

<%try { %>


<%
        Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
        String numberOfColumns = "3";
        WASProduct productInfo = new WASProduct();
%>

  <table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%" summary="property table">
    <tbody>
        <tr>
  		<td class="table-text" nowrap valign="top" colspan="<%= numberOfColumns %>">
  			<label title='<bean:message key="healthclass.wizard.steps.odr"/>'>
        	<bean:message key="healthclass.detail.membershipdescription" />
        	</label>
		<br>
		<br>
		</td>
					 
<%
CreateHealthClassWizardForm testForm = (CreateHealthClassWizardForm)session.getAttribute("CreateHealthClassODRForm");
Collection availableODRBean = testForm.getAvailableODR();
Collection selectedODRBean = testForm.getSelectedODR();
String hcName = testForm.getName();
pageContext.setAttribute("availableODRBean", availableODRBean);
pageContext.setAttribute("selectedODRBean", selectedODRBean);

String availODRSelectChange = "initVars(this); setSelectedODR(selectedAvailableODR, availODR)";
String currODRSelectChange = "initVars(this);setSelectedODR(selectedCurrentODR, currentODR)";
String removeClicked = "initVars(this);moveOptions(selectedCurrentODR, currentODR.options, availODR.options)";
String addClicked = "initVars(this);moveOptions(selectedAvailableODR, availODR.options, currentODR.options)";
%>


		<tr valign="top"> 
			<td class="table-text"  scope="row" nowrap>               			  
				<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="table-text">
							<table>
								<tr>
		 							<td class="table-text"  align="center" valign="top" width="35%"><span> 
		                   				<bean:message key="healthclass.details.availableMembers" /> </span>
		             				</td>
		            			<td class="table-text" >&nbsp;</td>
		            			<td class="table-text"  align="center" valign="top" width="35%"><span> 
		                    		<bean:message key="healthclass.details.membersOf" arg0="<%=hcName%>" /> </span>
		            			</td>
								</tr>
								
								<tr>
									<td class="table-text">							
									  	<html:select property="notUsed" multiple="multiple" size="10" onchange="initVars(this); setSelectedODR(selectedAvailableODR, availODR)" style="width:200px;">
		                        			<html:options name="availableODRBean" />
		                				</html:select>
									</td>
		            				<td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">
			                			<html:button styleClass="buttons" property="notUsed" onclick="<%=addClicked%>" onkeypress="<%=addClicked%>" styleId="other" style="width:125px;">
			                        		<bean:message key="healthclass.button.add" /> 
			                			</html:button>
			                			<br>
			               				<br>
			                			<html:button styleClass="buttons" property="notUsed" onclick="<%=removeClicked%>" onkeypress="<%=removeClicked%>" styleId="other" style="width:125px;">
				                        	<bean:message key="healthclass.button.remove" />
				               	 		</html:button>
		              		 		</td>
		                			<td class="table-text"  align="center" valign="top" width="35%">
		 		                		<html:select property="notUsed" multiple="multiple" size="10" onchange="initVars(this, 2);setSelectedODR(selectedCurrentODR, currentODR)" style="width:200px;">
                        					<html:options name="selectedODRBean" />
                						</html:select>
		               		 		</td>
		       					</tr>
		 					</table>
		 				</td>
		   			</tr>
		        </table>
		   	</td>
		</tr>
		   
		<html:hidden property="availableODRString"/>
        <html:hidden property="selectedODRString"/>
         <tr class="table-text"><td colspan="<%= numberOfColumns %>"><br></td></tr>
	</tbody>
</table>

 <% }
catch (Exception e) {
  System.out.println("error is " + e.toString());
  e.printStackTrace();
  }
  %>
