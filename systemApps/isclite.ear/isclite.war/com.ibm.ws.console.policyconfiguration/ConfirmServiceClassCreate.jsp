<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="com.ibm.ws.xd.config.operationalpolicy.OperationalPolicyConstants"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<bean:define id="name" name="<%=actionForm%>" property="name" type="java.lang.String" />
<bean:define id="description" name="<%=actionForm%>" property="description" type="java.lang.String" />
<bean:define id="goalType" name="<%=actionForm%>"property="goalType" type="java.lang.String" />
<bean:define id="goalValueString" name="<%=actionForm%>" property="goalValueString" type="java.lang.String" />
<bean:define id="goalPercentString" name="<%=actionForm%>" property="goalPercentString" type="java.lang.String" />
<bean:define id="goalIntervalString" name="<%=actionForm%>" property="timeInterval" type="java.lang.String" /> 
<bean:define id="selectedTCsText" name="<%=actionForm%>" property="selectedTCsText" type="java.lang.String" />
<bean:define id="importance" name="<%=actionForm%>" property="importance" type="java.lang.String" />

<bean:define id="goalDeltaValue" name="<%= actionForm %>" property="goalDeltaValueString" type="java.lang.String" />
<bean:define id="goalDeltaValueUnit" name="<%= actionForm %>" property="goalDeltaValueUnits" type="java.lang.String" />
<bean:define id="goalDeltaPercent" name="<%= actionForm %>" property="goalDeltaPercentString" type="java.lang.String" />
<bean:define id="timePeriodValue" name="<%= actionForm %>" property="timePeriodValueString" type="java.lang.String" />
<bean:define id="timePeriodValueUnit" name="<%= actionForm %>" property="timePeriodValueUnits" type="java.lang.String" />

<bean:define id="violationEnabled" name="<%= actionForm %>" property="violationEnabled" type="java.lang.Boolean" />

<%
MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
java.util.Locale locale = request.getLocale();
description = description.replaceAll("<","&#60;");
description = description.replaceAll(">","&#62;");
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">

  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left"> 
          <bean:message key="serviceclass.confirm.msg1"/>
          <bean:message key="serviceclass.confirm.msg2"/>  
	  </td>
  </tr>
</table>
	  
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
   <tr> 
      <th class="column-head-name" scope="col">
          <bean:message key="serviceclass.confirm.msg3"/>
	  </th>
   </tr>
   <tr> 
      <td class="table-text"  valign="top">

      <%
        if (selectedTCsText.length() == 0) {
            selectedTCsText = OperationalPolicyConstants.DEFAULT_TC_NAME+name;
        } else {
            selectedTCsText = OperationalPolicyConstants.DEFAULT_TC_NAME+name+":"+selectedTCsText;
        }
        
      	if (goalType.equalsIgnoreCase("GOAL_TYPE_DISCRETIONARY")) { 
      		if ((description.length() == 0) && (selectedTCsText.length() == 0)) {%>
        		<bean:message key="serviceclass.confirm.disc.min" arg0="<%=name%>" />
      		<%}
       		else if ((description.length() == 0) && (selectedTCsText.length() > 0)) {%>
        		<bean:message key="serviceclass.confirm.disc.nodesc" arg0="<%=name%>" arg1="<%=selectedTCsText%>"/>
      		<%}
       		else if ((description.length() > 0) && (selectedTCsText.length() == 0)) {%>
        		<bean:message key="serviceclass.confirm.disc.nomembers" arg0="<%=name%>" arg1="<%=description%>" />
      		<%}
       		else {%>
        		<bean:message key="serviceclass.confirm.disc" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=selectedTCsText%>"/>
      		<%}
      	}
		else if (goalType.equalsIgnoreCase("GOAL_TYPE_AVG_RESPONSE_TIME")) {
			String transImportance = messages.getMessage(locale,importance);
			String transTime = messages.getMessage(locale,goalIntervalString);   
			if (description.length() == 0) { %>
			    <bean:message key="serviceclass.confirm.avg.nodesc" arg0="<%=name%>" arg1="<%=goalValueString%>" arg2="<%=transTime%>"  arg3="<%=transImportance%>"  />
			<%}
			else { %>
			    <bean:message key="serviceclass.confirm.avg" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=goalValueString%>" arg3="<%=transTime%>"  arg4="<%=transImportance%>"  />
			<%}
		    if (selectedTCsText.length() > 0) { %>
			    <bean:message key="serviceclass.confirm.avga" arg0="<%=selectedTCsText%>" />
			<% }
				// if (Integer.parseInt(goalDeltaValue) > 0) {
				if (violationEnabled.booleanValue()) {
					String gdvUnitString = messages.getMessage(locale, goalDeltaValueUnit);
					String tpvUnitString = messages.getMessage(locale, timePeriodValueUnit);
			%>
					<bean:message key="serviceclass.violation.confirmation" arg0="<%= goalDeltaValue %>" arg1="<%= gdvUnitString %>" arg2="<%= timePeriodValue %>" arg3="<%= tpvUnitString %>" />
			<% } %>
		<% }
		else if (goalType.equalsIgnoreCase("GOAL_TYPE_QUEUETIME")) {
			String transImportance = messages.getMessage(locale,importance);
			String transTime = messages.getMessage(locale,goalIntervalString);   
			if (description.length() == 0) { %>
			    <bean:message key="serviceclass.confirm.queue.nodesc" arg0="<%=name%>" arg1="<%=goalValueString%>" arg2="<%=transTime%>"  arg3="<%=transImportance%>"  />
			<%}
			else { %>
		    	<bean:message key="serviceclass.confirm.queue" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=goalValueString%>" arg3="<%=transTime%>"  arg4="<%=transImportance%>"  />
			<%}
		    if (selectedTCsText.length() > 0) { %>
			    <bean:message key="serviceclass.confirm.avga" arg0="<%=selectedTCsText%>" />
			<% }
				// if (Integer.parseInt(goalDeltaValue) > 0) {
				if (violationEnabled.booleanValue()) {
					String gdvUnitString = messages.getMessage(locale, goalDeltaValueUnit);
					String tpvUnitString = messages.getMessage(locale, timePeriodValueUnit);
			%>
					<bean:message key="serviceclass.violation.confirmation" arg0="<%= goalDeltaValue %>" arg1="<%= gdvUnitString %>" arg2="<%= timePeriodValue %>" arg3="<%= tpvUnitString %>" />
			<% } %>
		<% }
		else if (goalType.equalsIgnoreCase("GOAL_TYPE_COMPLETIONTIME")) {
			String transImportance = messages.getMessage(locale,importance);
			String transTime = messages.getMessage(locale,goalIntervalString);   
			if (description.length() == 0) { %>
			    <bean:message key="serviceclass.confirm.completiontime.nodesc" arg0="<%=name%>" arg1="<%=goalValueString%>" arg2="<%=transTime%>"  arg3="<%=transImportance%>"  />
			<%}
			else { %>
		    	<bean:message key="serviceclass.confirm.completiontime" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=goalValueString%>" arg3="<%=transTime%>"  arg4="<%=transImportance%>"  />
			<%}
		    if (selectedTCsText.length() > 0) { %>
			    <bean:message key="serviceclass.confirm.avga" arg0="<%=selectedTCsText%>" />
			<% }
				// if (Integer.parseInt(goalDeltaValue) > 0) {
				if (violationEnabled.booleanValue()) {
					String gdvUnitString = messages.getMessage(locale, goalDeltaValueUnit);
					String tpvUnitString = messages.getMessage(locale, timePeriodValueUnit);
			%>
					<bean:message key="serviceclass.violation.confirmation" arg0="<%= goalDeltaValue %>" arg1="<%= gdvUnitString %>" arg2="<%= timePeriodValue %>" arg3="<%= tpvUnitString %>" />
			<% } %>
		<% }
		else if (goalType.equalsIgnoreCase("GOAL_TYPE_PCT_RESPONSE_TIME")) {		
			String transImportance = messages.getMessage(locale,importance);
			String transTime = messages.getMessage(locale,goalIntervalString);
			if ((description.length() == 0) && (selectedTCsText.length() == 0)) { %>
			    <bean:message key="serviceclass.confirm.pct.min" arg0="<%=name%>" />
			<%}
			else if ((description.length() > 0) && (selectedTCsText.length() == 0)) { %>
			    <bean:message key="serviceclass.confirm.pct.desc" arg0="<%=name%>" arg1="<%=description%>"  />
			<%}
			else if ((description.length() == 0) && (selectedTCsText.length() > 0)) { %>
			    <bean:message key="serviceclass.confirm.pct.members" arg0="<%=name%>" arg1="<%=selectedTCsText%>"  />
			<%}
			else { %>
			    <bean:message key="serviceclass.confirm.pct" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=selectedTCsText%>" />
			<%}%>
		    <bean:message key="serviceclass.confirm.pcta" arg0="<%=goalPercentString%>" arg1="<%=goalValueString%>" arg2="<%=transTime%>"  arg3="<%=transImportance%>" />
		    <% // if (Integer.parseInt(goalDeltaPercent) > 0) {
				if (violationEnabled.booleanValue()) {
		    		String tpvUnitString = messages.getMessage(locale, timePeriodValueUnit);
		    %>
				<bean:message key="serviceclass.violation.percentile.confirmation" arg0="<%= goalDeltaPercent %>" arg1="<%= timePeriodValue %>" arg2="<%= tpvUnitString %>" />
		    <% } %>
		<%}%>
	  </td>
   </tr>
   
</table>
