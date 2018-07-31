<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
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

<% try { System.err.println("in ServiceClassCustomPropsLayout.jsp");%>

<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="formFocus" classname="java.lang.String" />
<bean:define id="pctDisabled" property="pctDisabled" name="<%=formName%>"/> 


<script language="JavaScript">

function myOnChange() 
{
	var goalTypeValue = document.ServiceClassDetailForm.goalType.value;
	if (goalTypeValue == "GOAL_TYPE_DISCRETIONARY") {
		disableTextField(document.ServiceClassDetailForm.goalValue);
		disableTextField(document.ServiceClassDetailForm.goalPercent);
		document.ServiceClassDetailForm.timeInterval.disabled = true;
		//document.ServiceClassDetailForm.importance.disabled = true;
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

function addClicked(optionsToAdd) {
		var optionsToAddString = "";
		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?AddClicked=true" + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp=" + newImp + "&time=" + newTime + "&pct=" + newPercent + "&type=" + newType + "&uriStringToAdd=" + optionsToAddString
            + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++){
			optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;
		
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?RemoveClicked=true" + "&StringToRemove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp="+ newImp + "&time=" + newTime + "&pct=" + newPercent + "&type="+newType
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function moveClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var optionsToRemoveString = "";
		for(var x = 0; x < optionsToRemove.length; x++){
			optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
		var newDesc = descField.value;
		var newValue = valueField.value;
		var newImp = impField.value;
		var newTime = timeField.value;
		var newType = typeField.value;
		var newPercent = percentField.value;
		
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?MoveClicked=true" + "&StringToMove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp="+ newImp + "&time=" + newTime + "&pct=" + newPercent + "&type="+newType
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
		
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?EditClicked=true" + "&StringToModify=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc) + "&val=" + newValue + "&imp="+ newImp + "&time=" + newTime + "&pct=" + newPercent + "&type="+newType
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	else {
	//I need to figure out how to put up a message that they have to pick only one.
	}
}

function viewClicked(optionsToView) {
	if (optionsToView.length == 1) {
		var optionsToViewString = optionsToView[0].value;
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?ViewClicked=true" + "&StringToView=" + encodeURI(optionsToViewString)
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	else {
	//I need to figure out how to put up a message that they have to pick only one.
	}
}

function initROVars(formElem) {
	if (inited){
		return inited;
	}
		var theform = formElem.form;
		changing = false;
		selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
		currentNodes = theform.elements[0];
		inited=true;
		return inited;
}

function initVars(formElem, firstMembershipFormElemIndex){
	if (inited){
		return inited;
	}
	
	var theform = formElem.form;
	
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	
	currentNodes = theform.elements[0 + firstMembershipFormElemIndex];
	descField = theform.elements[1];
	valueField = theform.elements[3];
	impField = theform.elements[6];
	percentField = theform.elements[5]
	timeField = theform.elements[4];
	typeField = theform.elements[2];
		
	inited=true;
	return inited;
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

//this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm(){
	window.location = "/ibm/console/ServiceClassDetail.do?&ResetClicked=true" 
      + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
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

<%  String renderReadOnlyView = "no";
if( (readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes")) ) {
  renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
    renderReadOnlyView = "yes";
    if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
    }
    else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
    }
}

ServiceClassDetailForm testForm = (ServiceClassDetailForm)session.getAttribute("ServiceClassDetailForm");

Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
String numberOfColumns = "3";
if (descriptionsOn.booleanValue() == false)
	numberOfColumns = "2";	
	
WASDirectory directory = new WASDirectory();
%>

<%
   String fieldLevelHelpTopic = "";
   String fieldLevelHelpAttribute = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formType.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formType.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
   }
   fieldLevelHelpTopic = objectType+".detail.";
   String topicKey = fieldLevelHelpTopic;
%>

<a name="general"></a>

<% if (renderReadOnlyView.equalsIgnoreCase("yes")) { 
		String goalType = testForm.getGoalType();
		int fields = 1; 
%>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
      
      <table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="Properties Table" >
        
        <tbody>
        <tr valign="top">
          <th colspan="<%= numberOfColumns %>" class="column-head" scope="rowgroup">
            <a name="general"></a><bean:message key="config.general.properties"/></th>
        </tr>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
  
<%      
		boolean displayField = true;
		fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
        //this code gets productId from icon attribute of PropertyItem 
        //and checks if product is installed 
        // If product  is installed , then make row visible
        String productId = item.getIcon();
        boolean productEnabled = true;
        if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
            productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }

        if (productEnabled) { 
			if (item.getType().equalsIgnoreCase("Select")) { 
				if ((item.getAttribute().equalsIgnoreCase("importance")) && (goalType.equals("GOAL_TYPE_DISCRETIONARY"))) {
					displayField = false;
				}
				else {
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
                    Vector descVector = new Vector();
                    while(st1.hasMoreTokens()) 
                    {
                        String enumDesc = st1.nextToken();
                        descVector.addElement(enumDesc);
                    }
                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
                    Vector valueVector = new Vector();
                    while(st.hasMoreTokens()) 
                    {
                        String str = st.nextToken();
                        valueVector.addElement(str);
                    }
                    session.setAttribute("descVector", descVector);
                    session.setAttribute("valueVector", valueVector);
                    %>
                    <tr valign="top">                   
                     <tiles:insert page="/com.ibm.ws.console.policyconfiguration/submitLayoutWithOnChange.jsp"  flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="valueVector" value="<%=valueVector%>" />
                        <tiles:put name="descVector" value="<%=descVector%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="onChange" value="myOnChange()" />
                    </tiles:insert>               
                	<% 
	               	 } 
	            }
                else if (item.getType().equalsIgnoreCase("Password")) { %>
 			       <tr valign="top">           
			          <td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
			          <td class="table-text" valign="top">******</td> 
                <% 
                } 
				else { 
			          if (item.getAttribute().equalsIgnoreCase("goalValue")) { 
			          	if (!goalType.equals("GOAL_TYPE_DISCRETIONARY") ) { 
			          		String key = testForm.getTimeInterval(); %>			          
 					       <tr valign="top">           
			          		<td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
			          		<td class="table-text" valign="top"><bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/>  
			        		<bean:message key="<%=key%>"/></td>  <%
			          	}
			          	else {
			     	     	displayField = false;
			          	}
			          }
			          else if (item.getAttribute().equalsIgnoreCase("goalPercent")) {
			          	if (goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME")) { %>
 					       <tr valign="top">           
			          		<td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
			          		<td class="table-text" valign="top"><bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/>  
							<bean:message key="percent.sign"/></td>  <%
				        }
				        else {
			     	     	displayField = false;
			          	}				        
			          }
			          else {
			          %>
		 			       <tr valign="top">           
					          <td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
					          <td class="table-text" valign="top"><bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/> </td>         
    		    <% }
    		    } %>
          
		  <% if ((descriptionsOn.booleanValue() == true) && (displayField)) { %>  
                  <td class="table-text" valign="top">
	                  <ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
	                  <bean:message key="<%= item.getDescription() %>"/>
                  </td>
          <% }
          	if (displayField) {
          		fields++; %>
				</tr>		
			<% } %>        
        
        <% }%>  
        
        </logic:iterate>
        
        <%


Collection selectedNodesBean = testForm.getTCNames();
String scName = testForm.getRefId();

pageContext.setAttribute("selectedNodesBean", selectedNodesBean);

String currNodesSelectChange = "initROVars(this);setSelectedNodes(selectedCurrentNodes, currentNodes)";
String viewButtonClicked = "initROVars(this);viewClicked(selectedCurrentNodes)";

%>


          <!-- INSERT THE MEMBERSHIP ROW HERE -->
		<% int numMembershipColumns = Integer.parseInt(numberOfColumns); 
           if (numMembershipColumns > 0) 
           		numMembershipColumns--; 
	    	fieldLevelHelpTopic = topicKey + "membership"; 		
		%>      

        <tr>        
        <td class="table-text"  scope="row" valign="top" nowrap>
            <label for="membership"> <bean:message key="serviceclass.membership" /></label>                                
        </td>

		<td class="table-text" nowrap valign="top" colspan="<%= numMembershipColumns %>">
		<% if (descriptionsOn.booleanValue() == true) { %>  
          	<ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
           	<bean:message key="serviceclass.membershipdescription"/>
			<br>
		<% } %>  
		<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">

		
		<tr>
			<td class="table-text">
			<table>
				<tr>
        		
				<td align="center" valign="top" width="35%">
						<span class="table-text"> <bean:message	key="serviceclass.details.membersOf" arg0="<%=scName%>"/> 
						</span>
					</td>
				</tr>
				<tr>
					
					
				<td align="center" rowspan=2 valign="top" class="table-text">
						<html:select multiple="true" size="10" property="notUsed" 
									 onchange="<%=currNodesSelectChange%>"
									 style="width:200px;">
							<html:options name="selectedNodesBean" />
						</html:select>
				</td>
				<td align="center" valign="middle" width="30%">	
					<br>
						<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=viewButtonClicked%>"
									 style="width:125px;">
							 <bean:message key="serviceclass.button.view" />
						</html:button>
					<br>
					</td>
	
									
								</tr>
							</table>
						</tr>
					</table>
	</td>
        </tr>
        
        
        
        
        <tr>
          <th class="button-section" colspan="<%= numberOfColumns %>">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons" id="navigation">
          </th>
        </tr>
        
        </tbody>
        
      </table>

</html:form>

<% } %>

<% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>
<%int fields = 1; %>
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" >
<html:hidden property="action"/>
    <table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="Properties Table" >
        <tbody>
        <tr valign="top">
            <th colspan="<%= numberOfColumns %>" class="column-head" scope="rowgroup">
            <bean:message key="config.general.properties"/></th>
        </tr>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
             
<%  
        fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;

        //this code gets productId from icon attribute of PropertyItem 
        //and checks if product is installed 
        // If product  is installed , then make row visible
        String productId = item.getIcon();
        boolean productEnabled = true;
        if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
            productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }

        if (productEnabled) {
%>

        <tr valign="top">    
 
                <% 
                String isRequired = item.getRequired(); 
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
                %>
 
                 <% if (strType.equalsIgnoreCase("Text")) {
                 
                 		if (item.getAttribute().equalsIgnoreCase("goalValue")) { 
		                    try {
		                        session.removeAttribute("valueVector");
		                        session.removeAttribute("descVector");
		                    }
		                    catch (Exception e) {
		                    }
		                    
		                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
		                    Vector descVector = new Vector();
		                    while(st1.hasMoreTokens()) 
		                    {
		                        String enumDesc = st1.nextToken();
		                        descVector.addElement(enumDesc);
		                    }
		                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
		                    Vector valueVector = new Vector();
		                    while(st.hasMoreTokens()) 
		                    {
		                        String str = st.nextToken();
		                        valueVector.addElement(str);
		                    }
		                    session.setAttribute("descVector", descVector);
		                    session.setAttribute("valueVector", valueVector);
		                    
		                  %>
			                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/goalValueTextFieldLayout.jsp" flush="false">
			                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
			                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
			                        <tiles:put name="isRequired" value="<%=isRequired%>" />
			                        <tiles:put name="label" value="<%=item.getLabel()%>" />
			                        <tiles:put name="size" value="15" />
			                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
			                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
			                        <tiles:put name="bean" value="<%=formName%>" />
			                        <tiles:put name="valueVector" value="<%=valueVector%>" />
		                        	<tiles:put name="descVector" value="<%=descVector%>" />
			                    </tiles:insert>             		
		               	<% 
       	                fields++; 
       	                } 
		               	
		               	else if (item.getAttribute().equalsIgnoreCase("goalPercent")) { %>
						   <tiles:insert page="/com.ibm.ws.console.policyconfiguration/disableableTextFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="3" />
		                        <tiles:put name="units" value="percent.sign"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=formName%>" />
		                        <tiles:put name="disabled" value="<%=pctDisabled%>"/>
		                    </tiles:insert>
		                <% 
		                fields++; 
		                } 
		                else  { %>
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="30" />
		                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=formName%>" />
		                    </tiles:insert>
		                <% 
		                fields++;
		                }
		           } %>
		                
    
                <% if (strType.equalsIgnoreCase("TextArea")) { %>
                    <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="5" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <%  fields++; } %>
        
                <% if (strType.equalsIgnoreCase("checkbox")) { %>
                    <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <%  fields++; } %>
        
                <% if (strType.equalsIgnoreCase("Select")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
                    Vector descVector = new Vector();
                    while(st1.hasMoreTokens()) 
                    {
                        String enumDesc = st1.nextToken();
                        descVector.addElement(enumDesc);
                    }
                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
                    Vector valueVector = new Vector();
                    while(st.hasMoreTokens()) 
                    {
                        String str = st.nextToken();
                        valueVector.addElement(str);
                    }
        
                    session.setAttribute("descVector", descVector);
                    session.setAttribute("valueVector", valueVector);
                    %>
                    
                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/submitLayoutWithOnChange.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="onChange" value="myOnChange()" />
        		    </tiles:insert>
                <% 
                 fields++; } %>
                           
		<% if (descriptionsOn.booleanValue() == true) { %>  
		        <td class="table-text" valign="top" width="33%">
		           <ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
		           <bean:message key="<%=item.getDescription()%>"/>
		        </td>
		<% }  //end descriptions on  %>  
		</tr>
<% } //end product enabled %>    

   </logic:iterate>

<%


Collection selectedNodesBean = testForm.getTCNames();
String scName = testForm.getRefId();

pageContext.setAttribute("selectedNodesBean", selectedNodesBean);


String currNodesSelectChange = "initVars(this, " + fields + ");setSelectedNodes(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVars(this, " + fields + ");removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVars(this, " + fields + ");addClicked(selectedAvailableNodes)";
String moveButtonClicked = "initVars(this, " + fields + ");moveClicked(selectedCurrentNodes)";
String modifyButtonClicked = "initVars(this, " + fields + ");modifyClicked(selectedCurrentNodes)";

%>


          <!-- INSERT THE MEMBERSHIP ROW HERE -->
		<% int numMembershipColumns = Integer.parseInt(numberOfColumns); 
           if (numMembershipColumns > 0) 
           		numMembershipColumns--; 
	    	fieldLevelHelpTopic = topicKey + "membership"; 		
		%>      

        <tr>        
        <td class="table-text"  scope="row" valign="top" nowrap>
            <label for="membership"> <bean:message key="serviceclass.membership" /></label>                                
        </td>

		<td class="table-text" nowrap valign="top" colspan="<%= numMembershipColumns %>">
		<% if (descriptionsOn.booleanValue() == true) { %>  
          	<ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
           	<bean:message key="serviceclass.membershipdescription"/>
			<br>
		<% } %>  
		<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">

		
		<tr>
			<td class="table-text">
			<table>
				<tr>
        		
				<td align="center" valign="top" width="35%">
						<span class="table-text"> <bean:message	key="serviceclass.details.membersOf" arg0="<%=scName%>"/> 
						</span>
					</td>
				</tr>
				<tr>
					
					
				<td align="center" rowspan=2 valign="top" class="table-text">
						<html:select multiple="true" size="10" property="notUsed" 
									 onchange="<%=currNodesSelectChange%>"
									 style="width:200px;">
							<html:options name="selectedNodesBean" />
						</html:select>
				</td>
				<td align="center" valign="middle" width="30%">	
						<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=addButtonClicked%>"
									 style="width:125px;">
							<bean:message key="serviceclass.button.add" /> 
						</html:button>
					<br>
						<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=removeButtonClicked%>"
									 style="width:125px;">
							 <bean:message key="serviceclass.button.remove" />
						</html:button>
					<br>
						<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=modifyButtonClicked%>"
									 style="width:125px;">
							 <bean:message key="serviceclass.button.modify" />
						</html:button>
					<br>
						<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=moveButtonClicked%>"
									 style="width:125px;">
							 <bean:message key="serviceclass.button.move" />
						</html:button>
						
					</td>
	
									
								</tr>
							</table>
						</tr>
					</table>
	</td>
        </tr>
        
        <% String initVars = "initVars(this, " + fields + ");";
           String applyClick = initVars + " submitIt()";
           String resetClick = initVars + " resetForm()";
        %>          
                        
        <tr>
              <td class="button-section" colspan="<%= numberOfColumns %>">
                <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons" id="navigation" onclick="<%=applyClick%>">
                <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons" id="navigation" onclick="<%=applyClick%>">
                <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons" id="navigation" onclick="<%=resetClick%>">
                <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons" id="navigation">
              </td>
        </tr>
                
        </tbody>
    </table>

</html:form>

<%}


} //try
catch (Exception e) { 
	e.printStackTrace();
}%>
