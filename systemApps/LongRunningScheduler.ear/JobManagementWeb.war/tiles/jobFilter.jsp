<%@ page import="com.ibm.ws.security.core.SecurityContext,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="numOfColumns"   classname="java.lang.String"/>

<bean:define id="collectionForm"  name="<%=collectionName%>" type="com.ibm.ws.batch.jobmanagement.web.forms.JobCollectionForm"/>

<bean:define id="jobIdFilter"     name="<%=collectionName%>" property="jobIdFilter"     type="java.lang.String"/>
<bean:define id="submitterFilter" name="<%=collectionName%>" property="submitterFilter" type="java.lang.String"/>
<bean:define id="nodeFilter"      name="<%=collectionName%>" property="nodeFilter"      type="java.lang.String"/>
<bean:define id="appServerFilter" name="<%=collectionName%>" property="appServerFilter" type="java.lang.String"/>
<bean:define id="groupFilter"     name="<%=collectionName%>" property="groupFilter"     type="java.lang.String"/>
<bean:define id="sortBy"          name="<%=collectionName%>" property="sortBy"          type="java.lang.String"/>
<bean:define id="sortDirection"   name="<%=collectionName%>" property="sortDirection"   type="java.lang.String"/>

<%
  boolean isAdmin = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
     isAdmin = false;

  String username = "";
  if (SecurityContext.isSecurityEnabled())
     username = request.getRemoteUser();
	 
	boolean isGroupRoleSecurity = false;
	boolean isGroupSecurity = false;
		
	BatchSecurity.JOB_SECURITY_POLICY currentSecurityPolicy = BatchSecurity.getCurrentBatchSecurityPolicy();
		
	if(currentSecurityPolicy.equals(BatchSecurity.JOB_SECURITY_POLICY.GROUP))
		isGroupSecurity = true;
	else if(currentSecurityPolicy.equals(BatchSecurity.JOB_SECURITY_POLICY.GROUPROLE))
		isGroupRoleSecurity = true;
%>

    <!-- Filter Section -->
    <TR width="100%">
      <TD CLASS="column-filter-expanded" COLSPAN="<%=numOfColumns%>" ID="filterControls" STYLE="display:none">
        <BR>
          <bean:message key="filterInstruction"/>
        <p>
        <table BORDER="0" CELLPADDING="0" CELLSPACING="0" role="presentation">
          <tr>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="jobIdFilter" title="<bean:message key="jobId"/>"><b><bean:message key="jobId"/></b></label>
              <BR>
              <input type="text" id="jobIdFilter" name="jobIdFilter" class="noIndentTextEntry" size="20" value="<%=jobIdFilter%>" style="margin-left: 0.4em;"/>
              <br><img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              <label for="submitterFilter" title="<bean:message key="jobSubmitter"/>"><b><bean:message key="jobSubmitter"/></b></label>
              <BR>
<% if (isAdmin) { %>
              <input type="text" id="submitterFilter" name="submitterFilter" class="noIndentTextEntry" size="20" value="<%=submitterFilter%>" style="margin-left: 0.4em;"/>
<% } else { %>
              <input type="text" id="submitterFilter" name="submitterFilter" class="noIndentTextEntry" size="20" value="<%=username%>" style="margin-left: 0.4em;" disabled/>
<% } %>
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
			<BR>
			<label for="groupFilter" title="<bean:message key="jobGroup"/>"><b><bean:message key="jobGroup"/></b></label>
              <BR>
              <input type="text" id="groupFilter" name="groupFilter" class="noIndentTextEntry" size="20" value="<%=groupFilter%>" style="margin-left: 0.4em;"/>
<% } %>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="stateFilter" title="<bean:message key="jobCurrentState"/>"><b><bean:message key="jobCurrentState"/></b></label>
              <BR>
              <SELECT MULTIPLE SIZE="5" NAME="stateFilter" id="stateFilter" style="margin-left: 0.4em;">
                <OPTION VALUE="all"                       <%=collectionForm.stateFilterContains("all") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.all"/></OPTION>
                <OPTION VALUE="job.state.submitted"       <%=collectionForm.stateFilterContains("job.state.submitted") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.submitted"/></OPTION>
                <OPTION VALUE="job.state.cancelpending"   <%=collectionForm.stateFilterContains("job.state.cancelpending") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.cancelpending"/></OPTION>
                <OPTION VALUE="job.state.suspendpending"  <%=collectionForm.stateFilterContains("job.state.suspendpending") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.suspendpending"/></OPTION>
                <OPTION VALUE="job.state.resumepending"   <%=collectionForm.stateFilterContains("job.state.resumepending") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.resumepending"/></OPTION>
                <OPTION VALUE="job.state.executing"       <%=collectionForm.stateFilterContains("job.state.executing") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.executing"/></OPTION>
                <OPTION VALUE="job.state.suspended"       <%=collectionForm.stateFilterContains("job.state.suspended") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.suspended"/></OPTION>
                <OPTION VALUE="job.state.cancelled"       <%=collectionForm.stateFilterContains("job.state.cancelled") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.cancelled"/></OPTION>
                <OPTION VALUE="job.state.ended"           <%=collectionForm.stateFilterContains("job.state.ended") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.ended"/></OPTION>
                <OPTION VALUE="job.state.restartable"     <%=collectionForm.stateFilterContains("job.state.restartable") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.restartable"/></OPTION>
                <OPTION VALUE="job.state.executionfailed" <%=collectionForm.stateFilterContains("job.state.executionfailed") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.executionfailed"/></OPTION>
                <OPTION VALUE="job.state.pendingsubmit"   <%=collectionForm.stateFilterContains("job.state.pendingsubmit") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.pendingsubmit"/></OPTION>
                <OPTION VALUE="job.state.stoppending"   <%=collectionForm.stateFilterContains("jjob.state.stoppending") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="job.state.stoppending"/></OPTION>
              </SELECT>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="nodeFilter" title="<bean:message key="jobNode"/>"><b><bean:message key="jobNode"/></b></label>
              <BR>
              <input type="text" id="nodeFilter" name="nodeFilter" class="noIndentTextEntry" size="20" value="<%=nodeFilter%>" style="margin-left: 0.4em;"/>
              <br><img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              <label for="appServerFilter" title="<bean:message key="jobAppServer"/>"><b><bean:message key="jobAppServer"/></b></label>
              <BR>
              <input type="text" id="appServerFilter" name="appServerFilter" class="noIndentTextEntry" size="20" value="<%=appServerFilter%>" style="margin-left: 0.4em;"/>
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
            </td>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="sortBy" title="<bean:message key="sortBy"/>"><b><bean:message key="sortBy"/></b></label>
              <br>
              <select id="sortBy" name="sortBy" class="textEntry" style="margin-left: 0.4em;">
                <option value="JOBID" <%= sortBy.equals("JOBID") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobId"/></option>
                <option value="STATUS" <%= sortBy.equals("STATUS") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobCurrentState"/></option>
                <option value="SUBMITTER" <%= sortBy.equals("SUBMITTER") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobSubmitter"/></option>
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
				<option value="USERGRP" <%= sortBy.equals("USERGRP") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobGroup"/></option>
<% } %>
                <option value="LASTUPDATE" <%= sortBy.equals("LASTUPDATE") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobLastUpdate"/></option>
                <option value="NODE" <%= sortBy.equals("NODE") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobNode"/></option>
                <option value="APPSERVER" <%= sortBy.equals("APPSERVER") ? "SELECTED=\"SELECTED\"" : ""%>>
                  <bean:message key="jobAppServer"/></option>
              </select><br>
              <img alt='IBM' title='IBM' src='images/blank5.gif'/><br>
              <select id="sortDirection" title="<bean:message key="sortDirection"/>" name="sortDirection" class="textEntry">
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
              <INPUT TYPE="submit" NAME="searchAction" VALUE="<bean:message key="button.go"/>" CLASS="filter-buttons" ID="button.go" style="margin-left: 0.4em;">
            </td>
          </tr>
        </table>
        <p>
      </TD> 
    </TR>
    <!-- End of Filter Section -->
