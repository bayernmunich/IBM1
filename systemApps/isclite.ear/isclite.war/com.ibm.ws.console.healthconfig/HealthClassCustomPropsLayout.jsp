<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.util.XDConstants,com.ibm.ws.console.healthconfig.util.Constants,com.ibm.ws.console.healthconfig.form.HealthClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="formFocus" classname="java.lang.String" />

<script type="text/javascript" language="JavaScript">
   var initCurrentOnLoadDone = false;
</script>

<%
String contextId = (String)request.getAttribute("contextId");
AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);
String healthCondition = "";
HealthClassDetailForm testForm = (HealthClassDetailForm)session.getAttribute("HealthClassDetailForm");

String renderReadOnlyView = "no";
if( (readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes")) ) {
  renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
	renderReadOnlyView = "yes";
    if (adminAuthorizer.checkAccess(contextUri, "administrator")) {
        renderReadOnlyView = "no";
    }
    else if (adminAuthorizer.checkAccess(contextUri, "configurator")) {
        renderReadOnlyView = "no";
    }
}

//Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
String numberOfColumns = "3";
//if (descriptionsOn.booleanValue() == false)
//	numberOfColumns = "2";	
String fieldLevelHelpTopic = "HealthClass.detail.";
String topicKey = fieldLevelHelpTopic;
int fields = 0;
String healthConditionType = testForm.getType();

%>

<script language="JavaScript">
var changing = false;
var selectedAvailableNodes; // array of currently selected available nodes
var selectedCurrentNodes; // array of currently selected member nodes
var availNodes;
var currentNodes;
var inited = false;

//this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm(){
	var urlString = "/ibm/console/HealthClassDetail.do?&ResetClicked=true&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
	window.location = urlString;
}

function initVariables(){

	if (inited){
		return inited;
	}
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
       availNodes = document.getElementById('availableNodes');
       currentNodes = document.getElementById('currentNodes');
	inited=true;
	return inited;
}

function myOnChange() {}

function finishMethod(healthConditionType, urlString, newDesc) {

	//determine the condition fields
	if (healthConditionType == "AGE") {  // age condition
	        var newage = document.getElementById('age').value;
	        var newageUnits = document.getElementById('ageUnits').value;
		urlString = urlString + "&age=" + newage + "&ageUnits=" + newageUnits;
	}
	else if (healthConditionType == "WORKLOAD") {  // workload condition
	        var newtotalRequests = document.getElementById('totalRequests').value;
		urlString = urlString + "&totalRequests=" + newtotalRequests;
	}
	else if (healthConditionType == "MEMORY") {  // memory condition
	        var newtotalMemory = document.getElementById('totalMemory').value;
	        var newtimeOverThreshold = document.getElementById('timeOverThreshold').value;
	        var newtimeUnits = document.getElementById('timeUnits').value;
		urlString = urlString + "&totalMemory=" + newtotalMemory + "&timeOverThreshold=" + newtimeOverThreshold + "&timeUnits=" + newtimeUnits;
	}
	else if (healthConditionType == "RESPONSE") {  // response condition
	        var newresponseTime = document.getElementById('responseTime').value;
	        var newresponseTimeUnits = document.getElementById('responseTimeUnits').value;
		urlString = urlString + "&responseTime=" + newresponseTime + "&responseTimeUnits=" + newresponseTimeUnits;
	}
	else if (healthConditionType == "STUCKREQUEST") {  // stuck request condition
	        var newtimeoutPercent = document.getElementById('timeoutPercent').value;

		urlString = urlString + "&timeoutPercent=" + newtimeoutPercent;
	}
	else if (healthConditionType == "STORMDRAIN") {  // storm drain condition
               var newstormDrainConditionLevel;
               if (document.getElementById('stormDrainConditionNormalLevel').checked)
                  newstormDrainConditionLevel = document.getElementById('stormDrainConditionNormalLevel').value;
               else
                  newstormDrainConditionLevel = document.getElementById('stormDrainConditionConservativeLevel').value;

		urlString = urlString + "&stormDrainConditionLevel=" + newstormDrainConditionLevel;
	}
	else if (healthConditionType == "MEMORYLEAK") {  // memory leak condition
               var newmemoryLeakConditionLevel;
               if (document.getElementById('memoryLeakConditionAggressiveLevel').checked)
                  newmemoryLeakConditionLevel = document.getElementById('memoryLeakConditionAggressiveLevel').value;
               else if (document.getElementById('memoryLeakConditionNormalLevel').checked)
                  newmemoryLeakConditionLevel = document.getElementById('memoryLeakConditionNormalLevel').value;
               else
                  newmemoryLeakConditionLevel = document.getElementById('memoryLeakConditionConservativeLevel').value;

		urlString = urlString + "&memoryLeakConditionLevel=" + newmemoryLeakConditionLevel;
	}
	else if (healthConditionType == "GCPERCENTAGE") { //garbage collection percentage condition
        var newgarbageCollectionPercent = document.getElementById('garbageCollectionPercent').value;
        var newsamplingPeriod = document.getElementById('samplingPeriod').value;
        var newsamplingUnits = document.getElementById('samplingUnits').value;
	    urlString = urlString + "&garbageCollectionPercent=" + newgarbageCollectionPercent + "&samplingPeriod=" + newsamplingPeriod + "&samplingUnits=" + newsamplingUnits;
	}
	else if (healthConditionType == "CUSTOM") {  // custom condition
               var newcustomExpression = document.getElementById('customExpression').value;
               //Need to filter out carriage returns.
               newcustomExpression = newcustomExpression.replace(/\r|\n|\r\n/g, "");

		urlString = urlString + "&customExpression=" + newcustomExpression
	      + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
	}
	//add the description at the end
	urlString = urlString + "&description=" + newDesc + "&csrfid=" 
       + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
    window.location = urlString;
	
	return;
	
}

function memberTypeChange() {
	//When the app name changes we need to reset the WebModName lists
	var selectedType = document.getElementById('memberTypeField').value;
	var selectedCondition = "<%=healthConditionType%>";
	var newDesc = document.getElementById('description').value;
	var newMode = document.getElementById('reactionMode').value;
	var urlString = "/ibm/console/HealthClassDetail.do?selectedType="+ selectedType + "&memberTypeChanged=true" + "&type=" + selectedCondition + "&reactionMode=" + newMode;
	finishMethod("<%=healthConditionType%>",urlString,newDesc);
}
	
function addClicked(optionsToAdd) {
	if (optionsToAdd.length > 0) {
               if ((optionsToAdd.length == 1) && (optionsToAdd[0].value == "-------------------------------------------"))
                  return;
	        var selectedType = document.getElementById('memberTypeField').value;
	        var selectedCondition = "<%=healthConditionType%>";
	        var newDesc = document.getElementById('description').value;
	        var newMode = document.getElementById('reactionMode').value;
		//alert ("Add clicked");
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				optionsToAddString = optionsToAddString + ";;" + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			var urlString = "/ibm/console/HealthClassDetail.do?selectedType=" + selectedType + "&AddClicked=true" + "&stringToAdd=" + encodeURI(encodeURI(optionsToAddString)) + "&type=" + selectedCondition + "&reactionMode=" + newMode;	
		}
	finishMethod("<%=healthConditionType%>",urlString,newDesc);
	}
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
               if ((optionsToRemove.length == 1) && (optionsToRemove[0].value == "-------------------------------------------"))
                  return;
		var optionsToRemoveString = "";
	        var selectedType = document.getElementById('memberTypeField').value;
	        var selectedCondition = "<%=healthConditionType%>";
	        var newDesc = document.getElementById('description').value;
	        var newMode = document.getElementById('reactionMode').value;
		//alert("remove clicked");
		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			var urlString = "/ibm/console/HealthClassDetail.do?selectedType=" + selectedType + "&RemoveClicked=true" + "&stringToRemove=" + encodeURI(encodeURI(optionsToRemoveString)) + "&type=" + selectedCondition + "&reactionMode=" + newMode;	
		}
	finishMethod("<%=healthConditionType%>",urlString,newDesc);
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


function empty(nodeList){
	for (x=0; x<nodeList.length; x++){
		nodeList.pop();
	}
}

function submitIt(){
	while (changing){}
	changing=true;
}
</script>


<a name="general"></a>

<% if (renderReadOnlyView.equalsIgnoreCase("yes")) { %>
	<tiles:insert page="/com.ibm.ws.console.healthconfig/HealthClassCustomPropsLayoutReadOnly.jsp"  flush="false">
		<tiles:put name="attributeList" value="<%=attributeList%>"/>
		<tiles:put name="formAction" value="<%=formAction%>" />
		<tiles:put name="formName" value="<%=formName%>" />
		<tiles:put name="formType" value="<%=formType%>" />
		<tiles:put name="formFocus" value="<%=formFocus%>" />
		<tiles:put name="numberOfColumns" value="<%=numberOfColumns%>"/>
		<tiles:put name="topicKey" value="<%=topicKey%>" />
		<tiles:put name="testForm" value="<%=testForm%>" />
		<tiles:put name="fieldLevelHelpTopic" value="<%=fieldLevelHelpTopic%>" />
	</tiles:insert>
<% } %>

<% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>

<h2><bean:message key="config.general.properties"/></h2>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" >
<html:hidden property="action"/>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
        <tbody>
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">

<%
        String fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute; %>

       	 	<tr valign="top">
<%
                String isRequired = item.getRequired();
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
%>

                 <% if (strType.equalsIgnoreCase("Text")) { %>
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
                <%  fields++; } %>

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

                   <% if (item.getAttribute().equalsIgnoreCase("type")) { %>
                    <tiles:insert page="/com.ibm.ws.console.healthconfig/submitLayoutWithOnChange.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="onChange" value=""  />
        		    </tiles:insert>
   					<%} else { %>
                    <tiles:insert page="/com.ibm.ws.console.healthconfig/submitLayoutWithOnChange.jsp" flush="false">
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
                <% }
                  fields++; } %>


        </tr>
        </logic:iterate>

        <tr valign="top">
           <td class="table-text" valign="top" nowrap>
              <label TITLE="<bean:message key="healthclass.healthcondition.description"/>">
                <bean:message key="healthclass.type"/>
              </label>
              <br>
              <P CLASS="readOnlyElement">
	              <bean:message key="<%=testForm.getType()%>"/>
	              &nbsp;
              </P>
           </td>
        </tr>
        <html:hidden property="type" styleId="type" name="<%=formName%>"/>
<%
//The last thing was the health condition, so here we wil put in the Health Condition attributes
		if (testForm.getType().equalsIgnoreCase("AGE")) { %>
                 <tr valign="top">
                    <td class="table-text" >
                        <bean:message key="healthclass.age.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="age.healthcondition">
                          <legend for ="age.healthcondition" TITLE="<bean:message key="healthclass.age.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="age" TITLE="<bean:message key="healthclass.wizard.age.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.age"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="age"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="age"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="ageUnits"><bean:message key="healthclass.wizard.age.units"/></label>
                         	       <html:select property="ageUnits" name="<%=formName%>" styleId="ageUnits">
                                        <html:option value="UNITS_DAYS"><bean:message key="UNITS_DAYS"/></html:option>
                                        <html:option value="UNITS_HOURS"><bean:message key="UNITS_HOURS"/></html:option>
                         	       </html:select>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							       <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                             </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>

<%
		
		} else if (testForm.getType().equalsIgnoreCase("WORKLOAD")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.workload.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="workload.healthcondition">
                          <legend for ="workload.healthcondition" TITLE="<bean:message key="healthclass.workload.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="totalRequests" TITLE="<bean:message key="healthclass.wizard.requests.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.requests"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="totalRequests"                                  		
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="totalRequests"
                                         styleClass="textEntryRequired" />
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>

<%
		
		} else if (testForm.getType().equalsIgnoreCase("MEMORY")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.memory.healthcondition.description"/>
                        <br><br>
                        <img src="<%=request.getContextPath()%>/images/Information.gif" border="0" alt="<bean:message key="error.msg.information"/>"/>
                        <bean:message key="healthclass.memory.memoryleak.recommended.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="memory.healthcondition">
                          <legend for ="memory.healthcondition" TITLE="<bean:message key="healthclass.memory.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="totalMemory" TITLE="<bean:message key="healthclass.wizard.memory.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.memory"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="totalMemory"                                  		
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="totalMemory"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="timeOverThreshold" TITLE="<bean:message key="healthclass.wizard.timeoverthreshold.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.timeoverthreshold"/>
                                   <br>
                                   <html:text property="timeOverThreshold"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="timeOverThreshold"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="timeUnits"><bean:message key="healthclass.wizard.time.units"/></label>
                                   <html:select property="timeUnits" name="<%=formName%>" styleId="timeUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_SECONDS"><bean:message key="UNITS_SECONDS"/></html:option>
                         	       </html:select>
                                   <br>

                                     </label>
                                   </span>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
			
		} else if (testForm.getType().equalsIgnoreCase("RESPONSE")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.response.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="response.healthcondition">
                          <legend for ="response.healthcondition" TITLE="<bean:message key="healthclass.response.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="responseTime" TITLE="<bean:message key="healthclass.wizard.responsetime.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.responsetime"/>
									  </label>
                                   <br>
                                   <html:text property="responseTime"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="responseTime"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="responseTimeUnits">Response Time Units</label>
                                   <html:select property="responseTimeUnits" name="<%=formName%>" styleId="responseTimeUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_SECONDS"><bean:message key="UNITS_SECONDS"/></html:option>
                                        <html:option value="UNITS_MILLISECONDS"><bean:message key="UNITS_MILLISECONDS"/></html:option>
                         	       </html:select>
                                   <br>
                                   </span>

                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  scope="row" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("STUCKREQUEST")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.stuckrequest.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="stuckRequest.healthcondition">
                          <legend for ="stuckRequest.healthcondition" TITLE="<bean:message key="healthclass.stuckrequest.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="timeoutPercent" TITLE="<bean:message key="healthclass.wizard.timeoutpercent.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.timeoutpercent"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="timeoutPercent"
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="timeoutPercent"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
							  <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("STORMDRAIN")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.stormdrain.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="stormDrain.healthcondition">
                          <legend for ="stormDrain.healthcondition" TITLE="<bean:message key="healthclass.stormdrain.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                      <label TITLE="<bean:message key="healthclass.stormdrain.detection.description"/>">
                                         <bean:message key="healthclass.detectionlevel"/>
                                      </label>
                                   <br>
                                   <html:radio property="stormDrainConditionLevel"
                                               name="<%=formName%>"
                                               styleId="stormDrainConditionNormalLevel"
                                               value="CONDITION_LEVEL_NORMAL"/>
                                   <label for="stormDrainConditionNormalLevel">
                                      <bean:message key="healthclass.stormdrain.normallevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="stormDrainConditionLevel"
                                               name="<%=formName%>"
                                               styleId="stormDrainConditionConservativeLevel"
                                               value="CONDITION_LEVEL_CONSERVATIVE"/>
                                   <label for="stormDrainConditionConservativeLevel">
                                      <bean:message key="healthclass.stormdrain.conservativelevel"/>
                                   </label>
                                   <br>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("MEMORYLEAK")) {%>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.memoryleak.healthcondition.description"/>
                        <br><br>
                        <img src="<%=request.getContextPath()%>/images/Information.gif" border="0" alt="<bean:message key="error.msg.information"/>"/>
                        <bean:message key="healthclass.memory.memoryleak.recommended.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="memoryLeak.healthcondition">
                          <legend for ="memoryLeak.healthcondition" TITLE="<bean:message key="healthclass.memoryleak.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                      <label TITLE="<bean:message key="healthclass.memoryleak.detection.description"/>">
                                         <bean:message key="healthclass.detectionlevel"/>
                                      </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionAggressiveLevel"
                                               value="CONDITION_LEVEL_AGGRESSIVE"/>
                                   <label for="memoryLeakConditionAggressiveLevel">
                                      <bean:message key="healthclass.memoryleak.aggressivelevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionNormalLevel"
                                               value="CONDITION_LEVEL_NORMAL"/>
                                   <label for="memoryLeakConditionNormalLevel">
                                      <bean:message key="healthclass.memoryleak.normallevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionConservativeLevel"
                                               value="CONDITION_LEVEL_CONSERVATIVE"/>
                                   <label for="memoryLeakConditionConservativeLevel">
                                      <bean:message key="healthclass.memoryleak.conservativelevel"/>
                                   </label>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							       <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
		
		} else if (testForm.getType().equalsIgnoreCase("GCPERCENTAGE")) {%>
                 <tr valign="top">
                    <td class="instruction-text">
                        <bean:message key="healthclass.gcpercentage.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="gcpercentage.healthcondition">
                          <legend for ="gcpercentage.healthcondition" TITLE="<bean:message key="healthclass.gcpercentage.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="garbageCollectionPercent" TITLE="<bean:message key="healthclass.wizard.gcpercentage.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.gcpercentage"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="garbageCollectionPercent"                                  		
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="garbageCollectionPercent"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                   <label for="samplingPeriod" TITLE="<bean:message key="healthclass.wizard.samplingperiod.description"/>">
                                      <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                      <bean:message key="healthclass.samplingperiod"/>
                                   </label>
                                   <br>
                                   <html:text property="samplingPeriod"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="samplingPeriod"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="samplingUnits"><bean:message key="healthclass.wizard.sampling.units"/></label>
                                   <html:select property="samplingUnits" name="<%=formName%>" styleId="samplingUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_HOURS"><bean:message key="UNITS_HOURS"/></html:option>
                         	       </html:select>
                                   <br>
                                   </span>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text" nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
		
		} else if (testForm.getType().equalsIgnoreCase("CUSTOM")) { %>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.customCondition.desc"/>
                    </td>
                 </tr>
                <tr>
                  <td>
                    <tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
           	       <tiles:put name="actionForm" value="<%=formName%>" />
           	       <tiles:put name="label" value="healthclass.customCondition.run.reaction.label" />
           	       <tiles:put name="desc" value="healthclass.customCondition.desc" />
           	       <tiles:put name="hideValidate" value="true" />
                  	   <tiles:put name="hideRuleAction" value="true" />
                  	   <tiles:put name="rule" value="customExpression" />
                  	   <tiles:put name="rowindex" value="" />
                  	   <tiles:put name="refId" value="" />
                  	   <tiles:put name="ruleActionContext" value="service" />
                  	   <tiles:put name="template" value="service" />
                  	   <tiles:put name="actionItem0" value="notUsed" />
                  	   <tiles:put name="actionListItem0" value="notUsed" />
                  	   <tiles:put name="actionItem1" value="notUsed" />
                  	   <tiles:put name="actionListItem1" value="notUsed" />
               	   <tiles:put name="quickHelpTopic" value="hc_condition_subex.html" />
               	   <tiles:put name="quickPluginId" value="com.ibm.ws.console.healthconfig" />
                  	   <tiles:put name="customRuleBuilderLayout" value="/com.ibm.ws.console.xdcore/ruleBuilderLayoutForHealthPolicy.jsp" />
                  	 </tiles:insert>
                  </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text" nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>

<%

	}

MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
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
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.odr"),String.valueOf(XDConstants.ODR_MEMBER)));
   memberTypes.add(new org.apache.struts.util.LabelValueBean(messages.getMessage(locale,"member.type.dynamiccluster"),String.valueOf(XDConstants.DYNAMICCLUSTER_MEMBER)));
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

String availNodesSelectChange = "initVariables(); setSelectedNodes(selectedAvailableNodes, availNodes)";
String currNodesSelectChange = "initVariables();setSelectedNodes(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVariables();removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVariables();addClicked(selectedAvailableNodes)";
String memberTypeChanged = "initVariables();memberTypeChange()";
%>


<!-- INSERT THE MEMBERSHIP ROW HERE -->
<%
int numMembershipColumns = Integer.parseInt(numberOfColumns);
if (numMembershipColumns > 0)
	numMembershipColumns--;
	fieldLevelHelpTopic = topicKey + "membership"; 		
%>
<br>
    <tr>
        <td class="table-text" valign="top" nowrap>
        	<FIELDSET id="membership">
               	<legend for ="membership" TITLE="<bean:message key="healthclass.detail.membershipdescription"/>">
                 	<bean:message key="healthclass.details.membership"/>
               	</legend>

			<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">									
				<tr>
					<td class="table-text">
						<table role="presentation">
							<tr>
								<td class="table-text">
									<bean:message key="healthclass.member.filter.by" /> 							
									&nbsp;&nbsp;
									<%String memberTypeTitle = messages.getMessage(locale,"member.type"); %>
									<html:select title="<%=memberTypeTitle%>" size="1" value="<%=selectedTypeString%>" property="notUsed" styleId="memberTypeField" onchange="<%=memberTypeChanged%>">
                                         <html:options collection="appNamesBean" property="value" labelProperty="label" />
									</html:select>
								</td>
							</tr>
						</table>
						<br>
						<table role="presentation">
							<tr>
								<td valign="top"><span class="table-text"><center>
									<bean:message key="healthclass.details.availableMembers" />
									</center></span>
								</td>
								<td>&nbsp;</td>
								<td valign="top"> <span class="table-text"><center>
									<bean:message key="healthclass.details.membersOf" arg0="<%=hcName%>" />
									</center></span>
								</td>
							</tr>
							<tr>
								<td valign="top" class="table-text" width="35%">
									<%String availableTitle = messages.getMessage(locale,"healthclass.details.availableMembers"); %>
									<html:select title="<%=availableTitle%>" multiple="true" size="7" property="notUsed" styleId="availableNodes"
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
									<%String selectedMemberTitle = messages.getMessage(locale,"healthclass.details.members"); %>
									<html:select multiple="true" title="<%=selectedMemberTitle%>" size="7" property="notUsed" styleId="currentNodes"
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

    <% String initVars = "initVariables();";
       String applyClick = initVars + " submitIt()";
       String resetClick = initVars + " resetForm()";
    %>

   	<tr>
      	<td class="button-section" colspan="<%=numberOfColumns %>">
        	<input type="submit" name="apply" title="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation" onclick="<%=applyClick%>" >
        	<input type="submit" name="save"  title="save"  value="<bean:message key="button.ok"/>" class="buttons_navigation"     onclick="<%=applyClick%>" >
        	<input type="reset" name="reset"  title="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation"  onClick="<%=resetClick%>" >
        	<input type="submit" name="org.apache.struts.taglib.html.CANCEL" title="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
      	</td>
  	</tr>
	</tbody>
</table>

</html:form>

<%}
%>
