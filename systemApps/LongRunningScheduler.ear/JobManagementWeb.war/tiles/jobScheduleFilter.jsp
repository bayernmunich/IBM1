<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>


<%
  boolean isGroupRoleSecurity = false;
  boolean isGroupSecurity = false;
  
  BatchSecurity.JOB_SECURITY_POLICY currentSecurityPolicy = BatchSecurity.getCurrentBatchSecurityPolicy();
  
  if(currentSecurityPolicy.equals(BatchSecurity.JOB_SECURITY_POLICY.GROUP))
	isGroupSecurity = true;
  else if(currentSecurityPolicy.equals(BatchSecurity.JOB_SECURITY_POLICY.GROUPROLE))
	isGroupRoleSecurity = true;
%>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="numOfColumns"   classname="java.lang.String"/>

<bean:define id="collectionForm"  name="<%=collectionName%>" type="com.ibm.ws.batch.jobmanagement.web.forms.JobScheduleCollectionForm"/>

<bean:define id="requestIdFilter" name="<%=collectionName%>" property="requestIdFilter" type="java.lang.String"/>
<bean:define id="submitterFilter" name="<%=collectionName%>" property="submitterFilter" type="java.lang.String"/>
<bean:define id="startTimeFilter" name="<%=collectionName%>" property="startTimeFilter" type="java.lang.String"/>
<bean:define id="groupFilter"     name="<%=collectionName%>" property="groupFilter"     type="java.lang.String"/>
<bean:define id="sortBy"          name="<%=collectionName%>" property="sortBy"          type="java.lang.String"/>
<bean:define id="sortDirection"   name="<%=collectionName%>" property="sortDirection"   type="java.lang.String"/>
<%
    requestIdFilter = JMCUtils.convertToCharset(requestIdFilter, response.getCharacterEncoding());
%>
    <!-- Filter Section -->
    <TR width="100%">
      <TD CLASS="column-filter-expanded" COLSPAN="<%=numOfColumns%>" ID="filterControls" STYLE="display:none">
        <BR>
          <bean:message key="jobScheduleFilterInstruction"/>
        <p>
        <table BORDER="0" CELLPADDING="0" CELLSPACING="0" role="presentation">
          <tr>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="requestIdFilter" title="<bean:message key="jobScheduleRequestId"/>"><b><bean:message key="jobScheduleRequestId"/></b></label>
              <BR>
              &nbsp;<input type="text" id="requestIdFilter" name="requestIdFilter" class="noIndentTextEntry" size="20" value="<%=requestIdFilter%>"/>
              <br><img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              <label for="submitterFilter" title="<bean:message key="jobScheduleSubmitter"/>"><b><bean:message key="jobScheduleSubmitter"/></b></label>
              <BR>
              &nbsp;<input type="text" id="submitterFilter" name="submitterFilter" class="noIndentTextEntry" size="20" value="<%=submitterFilter%>"/>
              <br><img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              <label for="startTimeFilter" title="<bean:message key="jobScheduleStartDateTime"/>"><b><bean:message key="jobScheduleStartDateTime"/></b></label>
              <BR>
              &nbsp;<input type="text" id="startTimeFilter" name="startTimeFilter" class="noIndentTextEntry" size="20" value="<%=startTimeFilter%>"/>
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
			  <BR>
			  <label for="groupFilter" title="<bean:message key="group"/>"><b><bean:message key="group"/></b></label>
			  <BR>
              &nbsp;<input type="text" id="groupFilter" name="groupFilter" class="noIndentTextEntry" size="20" value="<%=groupFilter%>"/>
<% } %>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="statusFilter" title="<bean:message key="jobScheduleStatus"/>"><b><bean:message key="jobScheduleStatus"/></b></label>
              <BR>&nbsp;
              <SELECT MULTIPLE SIZE="5" NAME="statusFilter" id="statusFilter">
                <OPTION VALUE="all"                            <%=collectionForm.statusFilterContains("all") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.schedule.all"/></OPTION>
                <OPTION VALUE="job.schedule.status.active"    <%=collectionForm.statusFilterContains("job.schedule.status.active") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.schedule.status.active"/></OPTION>
                <OPTION VALUE="job.schedule.status.suspended" <%=collectionForm.statusFilterContains("job.schedule.status.suspended") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.schedule.status.suspended"/></OPTION>
              </SELECT>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="intervalFilter" title="<bean:message key="jobScheduleInterval"/>"><b><bean:message key="jobScheduleInterval"/></b></label>
              <BR>&nbsp;
              <SELECT MULTIPLE SIZE="5" NAME="intervalFilter" id="intervalFilter">
                <OPTION VALUE="all"              <%=collectionForm.intervalFilterContains("all") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.schedule.all"/></OPTION>
                <OPTION VALUE="daily"   <%=collectionForm.intervalFilterContains("daily") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="daily"/></OPTION>
                <OPTION VALUE="weekly"  <%=collectionForm.intervalFilterContains("weekly") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="weekly"/></OPTION>
                <OPTION VALUE="monthly" <%=collectionForm.intervalFilterContains("monthly") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="monthly"/></OPTION>
              </SELECT>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="sortBy" title="<bean:message key="sortBy"/>"><b><bean:message key="sortBy"/></b></label>
              <br>&nbsp;
              <select id="sortBy" name="sortBy" class="textEntry">
                <option value="REQUESTID" <%= sortBy.equals("REQUESTID") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobScheduleRequestId"/></option>
                <option value="SUBMITTER" <%= sortBy.equals("SUBMITTER") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobScheduleSubmitter"/></option>
                <option value="STATUS" <%= sortBy.equals("STATUS") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobScheduleStatus"/></option>
                <option value="STARTTIME" <%= sortBy.equals("STARTTIME") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobScheduleStartDateTime"/></option>
                <option value="INTERVAL" <%= sortBy.equals("INTERVAL") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobScheduleInterval"/></option>
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
				<option value="USERGRP" <%= sortBy.equals("USERGRP") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="group"/></option>
<% } %>
              </select><br>
              <img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              
              <select title="<bean:message key="sortDirection"/>" id="sortDirection" name="sortDirection" class="textEntry" style="margin-left: 0.1em;">
                <option value="ASC"  <%= sortDirection.equals("DESC") ? "" : "SELECTED=\"SELECTED\""%>>
                  <bean:message key="ascending"/></option>
                <option value="DESC" <%= sortDirection.equals("DESC") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="descending"/></option>
              </select>
            </td>
          </tr>
          <tr>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <br>
              <INPUT TYPE="submit" NAME="searchAction" VALUE="<bean:message key="button.go"/>" CLASS="filter-buttons" ID="button.go" style="margin-left: 0.5em;">
            </td>
          </tr>
        </table>
        <p>
      </TD> 
    </TR>
    <!-- End of Filter Section -->
