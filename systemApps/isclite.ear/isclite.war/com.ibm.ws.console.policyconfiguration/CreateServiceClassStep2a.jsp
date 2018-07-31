<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<SCRIPT type="text/javascript">

function myOnChange() {}

function checkViolation(spvBox) {
	if (spvBox.checked) {
		spvBox.form.goalDeltaValue.disabled = false;
		spvBox.form.goalDeltaValueUnits.disabled = false;
		spvBox.form.goalDeltaPercent.disabled = false;
		spvBox.form.timePeriodValue.disabled = false;
		spvBox.form.timePeriodValueUnits.disabled = false;
	} else {
		spvBox.form.goalDeltaValue.disabled = true;
		spvBox.form.goalDeltaValueUnits.disabled = true;
		spvBox.form.goalDeltaPercent.disabled = true;
		spvBox.form.timePeriodValue.disabled = true;
		spvBox.form.timePeriodValueUnits.disabled = true;
	}
}

</SCRIPT>

<%@ page language="java"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ page import="com.ibm.ws.xd.operations.impl.XDOperationsViewConfigHelper"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>


<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="descImage" classname="java.lang.String" />

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

<%
ServiceClassDetailForm testForm = (ServiceClassDetailForm)session.getAttribute("CreateServiceClassStep1Form");
String goalType = testForm.getGoalType();

%>
<html>
<body onload="checkViolation(document.CreateServiceClassStep2Form.violationEnabled)">
<!-- ONLOAD doesn't appear to work properly under the Console Framework/Layout. -->
<!-- Back/Forward Button won't have to SPV Fields shaded properly. -->

<html:hidden property="action"/>
	<table border="0" cellpadding="3" cellspacing="1" width="100%" 	role="presentation">

        <tbody>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
        <tr valign="top">    
 
                <% 
                String isRequired = item.getRequired(); 
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
                fieldLevelHelpTopic = topicKey + item.getAttribute();
                %>
 
                 <% if (strType.equalsIgnoreCase("Text")) {
                 
                 		if (item.getAttribute().equalsIgnoreCase("goalValue")) { 
		                    try {
		                        session.removeAttribute("valueVector");
		                        session.removeAttribute("descVector");
		                    }
		                    catch (Exception e) {
		                    }
			                Vector descVector = new Vector();
		                    Vector valueVector = new Vector();
		                    if(goalType.equals("GOAL_TYPE_QUEUETIME") || goalType.equals("GOAL_TYPE_COMPLETIONTIME" ) ){
		                    	descVector.add("UNITS_MINUTES");
		                    	valueVector.add("UNITS_MINUTES");
		                    }
		                    else{
		                    
			                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
			                    while(st1.hasMoreTokens()) 
			                    {
			                        String enumDesc = st1.nextToken();
			                        descVector.addElement(enumDesc);
			                    }
			                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
			                    while(st.hasMoreTokens()) 
			                    {
			                        String str = st.nextToken();
			                        valueVector.addElement(str);
			                    }
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
			                        <tiles:put name="bean" value="<%=actionForm%>" />
			                        <tiles:put name="valueVector" value="<%=valueVector%>" />
		                        	<tiles:put name="descVector" value="<%=descVector%>" />
			                    </tiles:insert>             		
		               	<% }
		               	
		               	else if (item.getAttribute().equalsIgnoreCase("goalPercent")) {
		               		if (goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME")) {
		               	 %>
		               	   <td class="table-text" valign="top">
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="3" />
		                        <tiles:put name="units" value="percent.sign"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=actionForm%>" />
		                        <tiles:put name="includeTD" value="false" />
		                    </tiles:insert>
		                    </td>
		                <% 
		                	} 
		                }
		                else  { %>
		                   <td class="table-text" valign="top">
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="30" />
		                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=actionForm%>" />
		                        <tiles:put name="includeTD" value="false" />
		                    </tiles:insert>
		                    </td>
		                <% 
		                }
		           } %>
		                
    
                <% if (strType.equalsIgnoreCase("TextArea")) { %>
                	<td class="table-text" valign="top">
                    <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="5" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="includeTD" value="false" />
                    </tiles:insert>
                    </td>
                <% } %>
        

        
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
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="onChange" value="myOnChange()" />
        		    </tiles:insert>
                <%
                } %>
 
        	</tr>

    	</logic:iterate>

<%
	String spvGoalDeltaDisplay = null;
	String spvGoalDeltaPercentDisplay = null;

	if (goalType.equals("GOAL_TYPE_PCT_RESPONSE_TIME")) {
		spvGoalDeltaDisplay = "display:none";
		spvGoalDeltaPercentDisplay = "display:block";
	} else {
		spvGoalDeltaDisplay = "display:block";
		spvGoalDeltaPercentDisplay = "display:none";
	}
%>

<%
	// D313929: Disable SPV for Queue Time
	if (  !goalType.equals("GOAL_TYPE_QUEUETIME") && 
		  !goalType.equals("GOAL_TYPE_COMPLETIONTIME")  ) {
%>
             <TR valign="top" id="SPVCheckBox">
             	<TD class="table-text" valign="top">
<%--
					<% if (isReadOnly) { %>
						<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)" DISABLED>
					<% } else { %>
						<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)">
					<% } %>
					<INPUT name="ServicePolicyViolation" type="checkbox" value="ON" ID="ServicePolicyViolation" class="chkbox" onclick="checkViolation(this)">
			        	<bean:message key="serviceclass.violation.title" />
					</INPUT>
--%>

					<%	boolean importanceOnlyEnabled = false;
						String isDisablePropertyEnabled = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
						isDisablePropertyEnabled = isDisablePropertyEnabled.trim(); 
					    if (isDisablePropertyEnabled.equalsIgnoreCase("true")) {
							importanceOnlyEnabled = true;
						}
						%>
					<html:checkbox property="violationEnabled" styleId="violationEnabled" styleClass="chkbox" onclick="checkViolation(this)" disabled="<%=importanceOnlyEnabled%>" />
					<LABEL for="violationEnabled" title="<bean:message key="serviceclass.violation.description" />">
             			<bean:message key="serviceclass.violation.title" />
             		</LABEL>
             	</TD>
             </TR>
             <TR valign="top" id="SPVText">
             	<TD class="complex-property" valign="top">
             		<bean:message key="serviceclass.violation.description" />
             	</TD>
             </TR>
             <TR valign="top" id="GoalDeltaValueTextBox" style="<%= spvGoalDeltaDisplay %>">
             	<TD class="complex-property" valign="top">
             		<LABEL for="goalDeltaValue" title="<bean:message key="serviceclass.violation.goaldeltavalue.description" />">
             			<bean:message key="serviceclass.violation.goaldeltavalue" />
             		</LABEL>
             		<BR>
             		<html:text size="30" property="goalDeltaValue" styleId="goalDeltaValue" styleClass="textEntry" disabled="<%= !testForm.isViolationEnabled() %>" />
					<label class="hidden" for="goalDeltaValueUnits" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
		             	<bean:message key="serviceclass.detail.timeinterval" />
        		    </label>
					<html:select size="1" property="goalDeltaValueUnits" styleId="goalDeltaValueUnits" disabled="<%= !testForm.isViolationEnabled() %>">
						<html:option value="UNITS_MILLISECONDS" key="UNITS_MILLISECONDS" />
						<html:option value="UNITS_SECONDS" key="UNITS_SECONDS" />
						<html:option value="UNITS_MINUTES" key="UNITS_MINUTES" />
					</html:select>
             	</TD>
             </TR>
             <TR valign="top" id="GoalDeltaPercentTextBox" style="<%= spvGoalDeltaPercentDisplay %>">
             	<TD class="complex-property" valign="top">
             		<LABEL for="goalDeltaPercent" title="<bean:message key="serviceclass.violation.goaldeltapercent.description" />">
             			<bean:message key="serviceclass.violation.goaldeltapercent" />
             		</LABEL>
             		<BR>
             		<html:text size="30" property="goalDeltaPercent" styleId="goalDeltaPercent" styleClass="textEntry" disabled="<%= !testForm.isViolationEnabled() %>" />
             		%
             	</TD>
             </TR>
             <TR valign="top" id="TimePeriodValueTextBox" style="display:block">
             	<TD class="complex-property" valign="top">
             		<LABEL for="timePeriodValue" title="<bean:message key="serviceclass.violation.timeperiodvalue.description" />">
             			<bean:message key="serviceclass.violation.timeperiodvalue" />
             		</LABEL>
             		<BR>
             		<html:text size="30" property="timePeriodValue" styleId="timePeriodValue" styleClass="textEntry" disabled="<%= !testForm.isViolationEnabled() %>" />
					<label class="hidden" for="timePeriodValueUnits" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
		             	<bean:message key="serviceclass.detail.timeinterval" />
        		    </label>
					<html:select size="1" property="timePeriodValueUnits" styleId="timePeriodValueUnits" disabled="<%= !testForm.isViolationEnabled() %>">
						<html:option value="UNITS_MILLISECONDS" key="UNITS_MILLISECONDS" />
						<html:option value="UNITS_SECONDS" key="UNITS_SECONDS" />
						<html:option value="UNITS_MINUTES" key="UNITS_MINUTES" />
					</html:select>
             	</TD>
             </TR>
<%
	}
%>

	</tbody>
</table> 

<br>

</body>
</html>