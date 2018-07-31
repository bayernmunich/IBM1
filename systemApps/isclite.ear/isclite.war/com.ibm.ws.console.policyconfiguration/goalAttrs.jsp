<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.ws.xd.operations.impl.*"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<%!
String getString(String key, org.apache.struts.util.MessageResources msgs, ServletRequest request){
	String str = msgs.getMessage(request.getLocale(), key);
	return str;
}
%>
<%
org.apache.struts.util.MessageResources resources = (org.apache.struts.util.MessageResources)application.getAttribute(org.apache.struts.action.Action.MESSAGES_KEY);
try {
	String initVars = "initVars(this);";
	String applyClick = initVars + " submitIt()";
%>

<tiles:useAttribute name="formBean" classname="java.lang.String"/>
<tiles:useAttribute name="readOnly" classname="java.lang.String"/>
<tiles:useAttribute name="property" classname="java.lang.String"/>
<tiles:useAttribute name="isRequired" classname="java.lang.String"/>

<script language="JavaScript">

// Array indices
var GOAL_TYPE_AVG_RESPONSE_TIME = 0;
var GOAL_TYPE_PCT_RESPONSE_TIME = 1;
var GOAL_TYPE_DISCRETIONARY = 2;
var GOAL_TYPE_QUEUETIME = 3;
var GOAL_TYPE_COMPLETIONTIME = 4;
var GOAL_TYPE_IMPORTANCE = 5;

// These double as array indices and field types.
var FIELD_VALUE = 0;
var FIELD_PERCENT = 1;
var FIELD_IMPORTANCE = 2;
var FIELD_UNITS = 3;
var FIELD_GOALDELTA = 4;
var FIELD_GOALDELTAUNIT = 5;
var FIELD_GOALDELTAPERCENT = 6;
var FIELD_TIMEPERIOD = 7;
var FIELD_TIMEPERIODUNIT = 8;
var FIELD_SPVBOX = 9;

var goalTypeMappings = {
	GOAL_TYPE_AVG_RESPONSE_TIME: GOAL_TYPE_AVG_RESPONSE_TIME, 
	GOAL_TYPE_PCT_RESPONSE_TIME: GOAL_TYPE_PCT_RESPONSE_TIME, 
	GOAL_TYPE_DISCRETIONARY: GOAL_TYPE_DISCRETIONARY, 
	GOAL_TYPE_QUEUETIME: GOAL_TYPE_QUEUETIME, 
	GOAL_TYPE_COMPLETIONTIME: GOAL_TYPE_COMPLETIONTIME
};

<%
String enableResponseTimeGoals = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
enableResponseTimeGoals = enableResponseTimeGoals.trim();
%>
var disableReponseTimeGoals = false;
if (<%=enableResponseTimeGoals.equalsIgnoreCase("true")%>) {
    disableResponseTimeGoals = true;
	goalTypeMappings.GOAL_TYPE_IMPORTANCE = GOAL_TYPE_IMPORTANCE;
}

// Arrays specifying whether Value, Percentile, and Importance are required/enabled or not.
var avgRespTimeSettings = [true, false, true, true, true, true, false, true, true, true];
var pctRespTimeSettings = [true, true, true, true, false, false, true, true, true, true];
var discretionarySettings = [false, false, false, false, false, false, false, false, false, false];
var importanceSettings = [false, false, false, false, false, false, false, true, true, true];

// D313929: Disable SPV Fields for Queue Time
// var queuetimeSettings = [true, false, true, false, true, true, false, true, true, true];
// D328422: Units should not be disabled for Queue Time
// var queuetimeSettings = [true, false, true, false, false, false, false, false, false, false];
var queuetimeSettings = [true, false, true, true, false, false, false, false, false, false];
var completiontimeSettings = [true, false, true, true, false, false, false, false, false, false];

var fieldSettings = [avgRespTimeSettings, pctRespTimeSettings, discretionarySettings, queuetimeSettings, completiontimeSettings, importanceSettings];

function changeType(selectBox) {
	var options = selectBox.options;
	if (!options || selectBox.selectedIndex < 0)
		return;
	var	form = selectBox.form;
	var goalType = options[selectBox.selectedIndex].value;
	var goalTypeInt = goalTypeMappings[goalType];
	for (var fieldType = 0; fieldType < 10; fieldType++) {
		if (fieldSettings[goalTypeInt][fieldType])
			enableField(getField(form, fieldType));
		else
			disableField(getField(form, fieldType));
	}

	var goalValueBox = document.getElementById("GoalValueTextBox");
	var goalPercentBox = document.getElementById("GoalPercentTextBox");
	var importanceBox = document.getElementById("ImportanceTextBox");

	var goalDeltaValueBox = document.getElementById("GoalDeltaValueTextBox");
	var goalDeltaPercentBox = document.getElementById("GoalDeltaPercentTextBox");

    // D313929: Disable SPV for Queue Time
    var spvCheckBox = document.getElementById("SPVCheckBox");
    var spvText = document.getElementById("SPVText");
    var timePeriodValueBox = document.getElementById("TimePeriodValueTextBox");

    goalValueBox.style.display = "block";
    goalPercentBox.style.display = "block";
    importanceBox.style.display = "block";

    spvCheckBox.style.display = "block";
    spvText.style.display = "block";
    goalDeltaValueBox.style.display = "block";
    goalDeltaPercentBox.style.display = "block";
    timePeriodValueBox.style.display = "block";

	if (goalType == "GOAL_TYPE_AVG_RESPONSE_TIME") {
               goalPercentBox.style.display = "none";

               form.timeInterval.options.length = 3;
               form.timeInterval.options[0] = new Option("<%=getString("UNITS_MILLISECONDS", resources, request)%>","UNITS_MILLISECONDS");
               form.timeInterval.options[1] = new Option("<%=getString("UNITS_SECONDS", resources, request)%>","UNITS_SECONDS");
               form.timeInterval.options[2] = new Option("<%=getString("UNITS_MINUTES", resources, request)%>","UNITS_MINUTES");
		       form.timeInterval.value = form.tempOrigTimeInterval.value;

		       goalDeltaPercentBox.style.display = "none";
	} else if (goalType == "GOAL_TYPE_PCT_RESPONSE_TIME") {
               form.timeInterval.options.length = 3;
               form.timeInterval.options[0] = new Option("<%=getString("UNITS_MILLISECONDS", resources, request)%>","UNITS_MILLISECONDS");
               form.timeInterval.options[1] = new Option("<%=getString("UNITS_SECONDS", resources, request)%>","UNITS_SECONDS");
               form.timeInterval.options[2] = new Option("<%=getString("UNITS_MINUTES", resources, request)%>","UNITS_MINUTES");
		       form.timeInterval.value = form.tempOrigTimeInterval.value;

		       goalDeltaValueBox.style.display = "none";
	} else if (goalType == "GOAL_TYPE_QUEUETIME") {
               goalPercentBox.style.display = "none";

               form.timeInterval.options.length = 1;
               form.timeInterval.options[0] = new Option("<%=getString("UNITS_MINUTES", resources, request)%>","UNITS_MINUTES");
		       form.timeInterval.value = "UNITS_MINUTES";

		// D313929: Disable SPV for Queue Time
		spvCheckBox.style.display = "none";
		spvText.style.display = "none";
		goalDeltaValueBox.style.display = "none";
		goalDeltaPercentBox.style.display = "none";
		timePeriodValueBox.style.display = "none";
	} else if(goalType == "GOAL_TYPE_COMPLETIONTIME") {
			   goalPercentBox.style.display = "none";

               form.timeInterval.options.length = 1;
               form.timeInterval.options[0] = new Option("<%=getString("UNITS_MINUTES", resources, request)%>","UNITS_MINUTES");
		form.timeInterval.value = "UNITS_MINUTES";

		// D313929: Disable SPV for Completion Time
		spvCheckBox.style.display = "none";
		spvText.style.display = "none";
		goalDeltaValueBox.style.display = "none";
		goalDeltaPercentBox.style.display = "none";
		timePeriodValueBox.style.display = "none";
			
	} else if (goalType == "GOAL_TYPE_IMPORTANCE") {
        goalValueBox.style.display = "none";
        goalPercentBox.style.display = "none";
        importanceBox.style.display = "block";
		
	} else if (goalType == "GOAL_TYPE_DISCRETIONARY") {
               goalValueBox.style.display = "none";
               goalPercentBox.style.display = "none";
               importanceBox.style.display = "none";

		spvCheckBox.style.display = "none";
		spvText.style.display = "none";
		goalDeltaValueBox.style.display = "none";
		goalDeltaPercentBox.style.display = "none";
		timePeriodValueBox.style.display = "none";
	}

	// checkViolation(form.ServicePolicyViolation);
	checkViolation(form.violationEnabled);
} //End changeType

// Grays out box (disables form field)
function disableField(field){
	field.disabled = true;
}

function enableField(field) {
	field.disabled = false;
}

function getField(form, fieldType) {
	var ret = null;
	switch(fieldType) {
		case FIELD_VALUE:
			ret = form.goalValue;
			break;
		case FIELD_PERCENT:
			ret = form.goalPercent;
			break;
		case FIELD_IMPORTANCE:
			ret = form.importance;		
			break;
		case FIELD_UNITS:
			ret = form.timeInterval;
			break;
		case FIELD_GOALDELTA:
			ret = form.goalDeltaValue;
			break;
		case FIELD_GOALDELTAUNIT:
			ret = form.goalDeltaValueUnits;
			break;
		case FIELD_GOALDELTAPERCENT:
			ret = form.goalDeltaPercent;
			break;
		case FIELD_TIMEPERIOD:
			ret = form.timePeriodValue;
			break;
		case FIELD_TIMEPERIODUNIT:
			ret = form.timePeriodValueUnits;
			break;
		case FIELD_SPVBOX:
			// ret = form.ServicePolicyViolation;
			ret = form.violationEnabled;
			break;
	}
	return ret;
} //getField

function checkViolation(spvBox) {
	if (spvBox.checked) {
		if (spvBox.disabled) {
			spvBox.form.goalDeltaValue.disabled = true;
			spvBox.form.goalDeltaValueUnits.disabled = true;
			spvBox.form.goalDeltaPercent.disabled = true;
			spvBox.form.timePeriodValue.disabled = true;
			spvBox.form.timePeriodValueUnits.disabled = true;
		} else {
			spvBox.form.goalDeltaValue.disabled = false;
			spvBox.form.goalDeltaValueUnits.disabled = false;
			spvBox.form.goalDeltaPercent.disabled = false;
			spvBox.form.timePeriodValue.disabled = false;
			spvBox.form.timePeriodValueUnits.disabled = false;
		}
	} else {
		spvBox.form.goalDeltaValue.disabled = true;
		spvBox.form.goalDeltaValueUnits.disabled = true;
		spvBox.form.goalDeltaPercent.disabled = true;
		spvBox.form.timePeriodValue.disabled = true;
		spvBox.form.timePeriodValueUnits.disabled = true;
	}
} //checkViolation

// ONLOAD doesn't appear to work properly under the Console Framework/Layout.
// Back/Forward Button won't have to SPV Fields shaded properly.
// window.onload = checkViolation(document.ServiceClassDetailForm.violationEnabled);

</script>

<%
ServiceClassDetailForm scform = (ServiceClassDetailForm)pageContext.findAttribute(formBean);
String goalType = scform.getGoalType();

// All enabled if PCT response time
boolean valEnabled = true, pctEnabled = true, impEnabled = true, unitsEnabled = true;

boolean spvGoalDeltaEnabled = true, spvGoalDeltaUnitEnabled = true;
boolean spvTimePeriodEnabled = true, spvTimePeriodUnitEnabled = true;
boolean spvGoalDeltaPercentEnabled = true;
boolean spvCheckBoxEnabled = true;

String spGoalValueDisplay = "display:block";
String spGoalPercentDisplay = "display:block";
String spImportanceDisplay = "display:block";

String spvGoalDeltaDisplay = "display:block";
String spvGoalDeltaPercentDisplay = "display:block";

// D313929: Disable SPV Fields for Queue Time
String spvCheckBoxDisplay = "display:block";
String spvTextDisplay = "display:block";
String spvTimePeriodDisplay = "display:block";

// This is used in the change goal type logic
String tempOrigTimeInterval = "UNITS_SECONDS"; // this is the default for AVG_RESPONSE_TIME and PCT_RESPONSE_TIME

String isDisablePropertyEnabled = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
isDisablePropertyEnabled = isDisablePropertyEnabled.trim();

if (isDisablePropertyEnabled.equalsIgnoreCase("true")) {
	valEnabled = false;
    pctEnabled = false;
    impEnabled = true;
    spGoalValueDisplay = "display:none";
    spGoalPercentDisplay = "display:none";
	spImportanceDisplay = "display:block";

	spvGoalDeltaEnabled = false;
	spvGoalDeltaUnitEnabled = false;
	spvTimePeriodEnabled = false;
	spvTimePeriodUnitEnabled = false;
	spvGoalDeltaPercentEnabled = false;
	spvCheckBoxEnabled = false;
	spvCheckBoxDisplay = "display:none";
	spvTextDisplay = "display:none";
	spvGoalDeltaDisplay = "display:none";
	spvGoalDeltaPercentDisplay = "display:none";
	spvTimePeriodDisplay = "display:none";

} else if (goalType.equals("GOAL_TYPE_AVG_RESPONSE_TIME")) {
	pctEnabled = false;
       spGoalPercentDisplay = "display:none";
	spvGoalDeltaPercentEnabled = false;
	spvGoalDeltaPercentDisplay = "display:none";
       tempOrigTimeInterval = scform.getTimeInterval();
} else if (goalType.equals("GOAL_TYPE_QUEUETIME")) {
	pctEnabled = false;
       spGoalPercentDisplay = "display:none";
       // D328422: Units should not be disabled for Queue Time
	// unitsEnabled = false;
	spvGoalDeltaPercentEnabled = false;
	spvGoalDeltaPercentDisplay = "display:none";

	// D313929: Disable SPV Fields for Queue Time
	spvCheckBoxDisplay = "display:none";
	spvTextDisplay = "display:none";
	spvGoalDeltaDisplay = "display:none";
	spvTimePeriodDisplay = "display:none";
} else if (goalType.equals("GOAL_TYPE_COMPLETIONTIME")){
	pctEnabled = false;
       spGoalPercentDisplay = "display:none";
       // D328422: Units should not be disabled for Queue Time
	// unitsEnabled = false;
	spvGoalDeltaPercentEnabled = false;
	spvGoalDeltaPercentDisplay = "display:none";

	// D313929: Disable SPV Fields for Queue Time
	spvCheckBoxDisplay = "display:none";
	spvTextDisplay = "display:none";
	spvGoalDeltaDisplay = "display:none";
	spvTimePeriodDisplay = "display:none";
} else if (goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME")) {
	spvGoalDeltaEnabled = false;
	spvGoalDeltaUnitEnabled = false;
	spvGoalDeltaDisplay = "display:none";
       tempOrigTimeInterval = scform.getTimeInterval();
} else if (!goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME")  && 
		   !goalType.equals("GOAL_TYPE_QUEUETIME")          && 
		   !goalType.equals("GOAL_TYPE_AVG_RESPONSE_TIME")  && 
		   !goalType.equals("GOAL_TYPE_COMPLETIONTIME")  ) {
		   
    // It's Discretionary, everything disabled
	valEnabled = false;
    pctEnabled = false;
    impEnabled = false;
    spGoalValueDisplay = "display:none";
    spGoalPercentDisplay = "display:none";
    spImportanceDisplay = "display:none";

	spvGoalDeltaEnabled = false;
	spvGoalDeltaUnitEnabled = false;
	spvTimePeriodEnabled = false;
	spvTimePeriodUnitEnabled = false;
	spvGoalDeltaPercentEnabled = false;
	spvCheckBoxEnabled = false;
	spvCheckBoxDisplay = "display:none";
	spvTextDisplay = "display:none";
	spvGoalDeltaDisplay = "display:none";
	spvGoalDeltaPercentDisplay = "display:none";
	spvTimePeriodDisplay = "display:none";
}

boolean isReadOnly = (readOnly != null && readOnly.equalsIgnoreCase("true"));
%>

<%
	boolean spvCheckBoxChecked = false;
	// if (!((scform.getGoalDeltaValue() == 0) && (scform.getGoalDeltaPercent() == 0))) {
	if (scform.isViolationEnabled()) {
		spvCheckBoxChecked = true;
	} else {
		spvGoalDeltaEnabled = false;
		spvGoalDeltaUnitEnabled = false;
		spvTimePeriodEnabled = false;
		spvTimePeriodUnitEnabled = false;
		spvGoalDeltaPercentEnabled = false;
	}
%>

    <table class="categorizedField" id="serviceClass.attributes" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
  			<tbody>
             <tr valign="top">
       			<td class="table-text" valign="top" width="25%">
					<label for="goalType" title="<bean:message key="serviceclass.detail.goaltype.description"/>">
		             	<bean:message key="serviceclass.detail.goaltype" />
        		    </label>
              		<br>     		
              		<% 
              		String value = scform.getName();
              		value = value.trim();
              		String isResponseTimePropertyEnabled = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
              		isResponseTimePropertyEnabled = isResponseTimePropertyEnabled.trim();
              		if ( value.equals("Default_SP")) {  %>
              			<html:select size="1" property="goalType" styleId="goalType" onchange="changeType(this)" disabled="true">
							<html:option value="GOAL_TYPE_DISCRETIONARY" key="GOAL_TYPE_DISCRETIONARY"/>																					
						</html:select>
              		<% } else { %>
              		<%	if (isResponseTimePropertyEnabled.equalsIgnoreCase("true")) { %> 
              		       <html:select size="1" property="goalType" styleId="goalType" onchange="changeType(this)" disabled="true">
							<html:option value="GOAL_TYPE_IMPORTANCE" key="GOAL_TYPE_IMPORTANCE"/>																					
						</html:select>
						<% } else { %>
        				<html:select size="1" property="goalType" styleId="goalType" onchange="changeType(this)" disabled="<%=isReadOnly%>">
						<% if (goalType.equals("GOAL_TYPE_AVG_RESPONSE_TIME") || goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME") || goalType.equals("GOAL_TYPE_DISCRETIONARY")){ %>
						<html:option value="GOAL_TYPE_AVG_RESPONSE_TIME" key="GOAL_TYPE_AVG_RESPONSE_TIME"/>
						<html:option value="GOAL_TYPE_PCT_RESPONSE_TIME" key="GOAL_TYPE_PCT_RESPONSE_TIME"/>
						<% } %>
						<html:option value="GOAL_TYPE_DISCRETIONARY" key="GOAL_TYPE_DISCRETIONARY"/>
						<% if (goalType.equals("GOAL_TYPE_QUEUETIME") || goalType.equals("GOAL_TYPE_COMPLETIONTIME") || goalType.equals("GOAL_TYPE_DISCRETIONARY")){ %>
							<% if (goalType.equals("GOAL_TYPE_QUEUETIME")){ %>																			
							<html:option value="GOAL_TYPE_QUEUETIME" key="GOAL_TYPE_QUEUETIME"/>
							<% } %>																			
							<% if (com.ibm.ws.xd.util.XD.isEnabledCG() || goalType.equals("GOAL_TYPE_COMPLETIONTIME")){ %>																			
							<html:option value="GOAL_TYPE_COMPLETIONTIME" key="GOAL_TYPE_COMPLETIONTIME"/>
							<% } %>																			
						<% } %>						
						</html:select>
					<% } %>
				<% } %>
				</td>
             </TR>
             <tr valign="top" id="GoalValueTextBox" style="<%= spGoalValueDisplay %>">
       			<td class="table-text" valign="top" width="25%">
					<label for="goalValue" title="<bean:message key="serviceclass.detail.goalvalue.description"/>">
		             	<bean:message key="serviceclass.detail.goalvalue" />
        		    </label>
              		<br>
					<html:text size="30" property="goalValue" styleId="goalValue" styleClass="textEntry" disabled="<%=isReadOnly || !valEnabled%>"/>
					<label class="hidden" for="timeInterval" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
		             	<bean:message key="serviceclass.detail.timeinterval" />
        		    </label>
					<html:select size="1" property="timeInterval" styleId="timeInterval" disabled="<%=isReadOnly || !valEnabled || !unitsEnabled%>">
                                               <% // D328422: Units should not be disabled for Queue Time
                                                  if (goalType.equals("GOAL_TYPE_QUEUETIME") || goalType.equals("GOAL_TYPE_COMPLETIONTIME" )) { %>
                                                     <html:option value="UNITS_MINUTES" key="UNITS_MINUTES"/>
                                               <% } else { %>
                                                     <html:option value="UNITS_MILLISECONDS" key="UNITS_MILLISECONDS"/>
                                                     <html:option value="UNITS_SECONDS" key="UNITS_SECONDS"/>
                                                     <html:option value="UNITS_MINUTES" key="UNITS_MINUTES"/>
                                               <% } %>
					</html:select>
				</td>
             </TR>
             <tr valign="top" id="GoalPercentTextBox" style="<%= spGoalPercentDisplay %>">
       			<td class="table-text" valign="top" width="25%">
					<label for="goalPercent" title="<bean:message key="serviceclass.detail.goalpercent.description"/>">
		             	<bean:message key="serviceclass.detail.goalpercent" />
        		    </label>
              		<br>
					<html:text size="30" property="goalPercent" styleId="goalPercent" styleClass="textEntry" disabled="<%=isReadOnly || !pctEnabled%>"/> %																												
				</td>
             </TR>
             <tr valign="top" id="ImportanceTextBox" style="<%= spImportanceDisplay %>">
       			<td class="table-text" valign="top" width="25%">
					<label for="importance" title="<bean:message key="serviceclass.detail.importance.description"/>">
		             	<bean:message key="serviceclass.detail.importance" />
        		    </label>
              		<br>
					<html:select size="1" property="importance" styleId="importance" disabled="<%=isReadOnly || !impEnabled%>">
						<html:option value="IMPORTANCE_HIGHEST" key="IMPORTANCE_HIGHEST"/>
						<html:option value="IMPORTANCE_HIGHER" key="IMPORTANCE_HIGHER"/>
						<html:option value="IMPORTANCE_HIGH" key="IMPORTANCE_HIGH"/>
						<html:option value="IMPORTANCE_MEDIUM" key="IMPORTANCE_MEDIUM"/>
						<html:option value="IMPORTANCE_LOW" key="IMPORTANCE_LOW"/>
						<html:option value="IMPORTANCE_LOWER" key="IMPORTANCE_LOWER"/>
						<html:option value="IMPORTANCE_LOWEST" key="IMPORTANCE_LOWEST"/>
					</html:select>
				</td>
             </TR>
             <TR valign="top" id="SPVCheckBox" style="<%= spvCheckBoxDisplay %>">
             	<TD class="table-text" valign="top">
                    <%--
					<% if (spvCheckBoxEnabled || !isReadOnly) {
						if (spvCheckBoxChecked) { %>
							<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)" CHECKED>
						<% } else { %>
							<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)">
						<% }
					} else {
						if (spvCheckBoxChecked) { %>
							<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)" CHECKED DISABLED>
						<% } else { %>
							<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)" DISABLED>
						<% }
					} %>
			        	<bean:message key="serviceclass.violation.title" />
					</INPUT>
					--%>

                    <html:checkbox property="violationEnabled" styleId="violationEnabled" styleClass="chkbox" onclick="checkViolation(this)" disabled="<%= isReadOnly || !spvCheckBoxEnabled %>" />
             		<LABEL for="violationEnabled" title="<bean:message key="serviceclass.violation" />">
             			<bean:message key="serviceclass.violation.title" />
             		</LABEL>

             	</TD>
             </TR>
             <tr valign="top" id="SPVText" style="<%= spvTextDisplay %>">
             	<td class="complex-property" valign="top">
             		<bean:message key="serviceclass.violation.description" />
             	</td>
             </tr>
             <tr valign="top" id="GoalDeltaValueTextBox" style="<%= spvGoalDeltaDisplay %>">
             	<td class="complex-property" valign="top">
             		<label for="goalDeltaValue" title="<bean:message key="serviceclass.violation.goaldeltavalue" />">
             			<bean:message key="serviceclass.violation.goaldeltavalue.description" />
             		</label>
             		<br />
             		<html:text size="30" property="goalDeltaValue" styleId="goalDeltaValue" styleClass="textEntry" disabled="<%= isReadOnly || !spvGoalDeltaEnabled %>" />
					<label class="hidden" for="goalDeltaValueUnits" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
		             	<bean:message key="serviceclass.detail.timeinterval" />
        		    </label>
					<html:select size="1" property="goalDeltaValueUnits" styleId="goalDeltaValueUnits" disabled="<%= isReadOnly || !spvGoalDeltaUnitEnabled %>" >
						<html:option value="UNITS_MILLISECONDS" key="UNITS_MILLISECONDS" />
						<html:option value="UNITS_SECONDS" key="UNITS_SECONDS" />
						<html:option value="UNITS_MINUTES" key="UNITS_MINUTES" />
					</html:select>
             	</td>
             </tr>
             <tr valign="top" id="GoalDeltaPercentTextBox" style="<%= spvGoalDeltaPercentDisplay %>">
             	<td class="complex-property" valign="top">
             		<label for="goalDeltaPercent" title="<bean:message key="serviceclass.violation.goaldeltapercent" />">
             			<bean:message key="serviceclass.violation.goaldeltapercent.description" />
             		</label>
             		<br />
             		<html:text size="30" property="goalDeltaPercent" styleId="goalDeltaPercent" styleClass="textEntry" disabled="<%= isReadOnly || !spvGoalDeltaPercentEnabled %>" />
             		%
             	</td>
             </tr>

             <tr valign="top" id="TimePeriodValueTextBox" style="<%= spvTimePeriodDisplay %>">
             	<td class="complex-property" valign="top">
             		<label for="timePeriodValue" title="<bean:message key="serviceclass.violation.timeperiodvalue" />">
             			<bean:message key="serviceclass.violation.timeperiodvalue.description" />
             		</label>
             		<br />
             		<html:text size="30" property="timePeriodValue" styleId="timePeriodValue" styleClass="textEntry" disabled="<%= isReadOnly || !spvTimePeriodEnabled %>" />
					<label class="hidden" for="timePeriodValueUnits" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
		             	<bean:message key="serviceclass.detail.timeinterval" />
        		    </label>
					<html:select size="1" property="timePeriodValueUnits" styleId="timePeriodValueUnits" disabled="<%= isReadOnly || !spvTimePeriodUnitEnabled %>" >
						<html:option value="UNITS_MILLISECONDS" key="UNITS_MILLISECONDS" />
						<html:option value="UNITS_SECONDS" key="UNITS_SECONDS" />
						<html:option value="UNITS_MINUTES" key="UNITS_MINUTES" />
					</html:select>
             	</td>
             </tr>
        </tbody>
    </table>
    <input type="hidden" name="tempOrigTimeInterval" value="<%=tempOrigTimeInterval%>">
<%
} catch (Exception e) {
	e.printStackTrace();
}
%>
