<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="numOfColumns"   classname="java.lang.String"/>

<bean:define id="collectionForm"  name="<%=collectionName%>" type="com.ibm.ws.batch.jobmanagement.web.forms.SavedJobCollectionForm"/>

<bean:define id="jobNameFilter" name="<%=collectionName%>" property="jobNameFilter" type="java.lang.String"/>
<bean:define id="jobGroupFilter"   name="<%=collectionName%>" property="jobGroupFilter"   type="java.lang.String"/>
<bean:define id="sortBy"        name="<%=collectionName%>" property="sortBy"        type="java.lang.String"/>
<bean:define id="sortDirection" name="<%=collectionName%>" property="sortDirection" type="java.lang.String"/>
<%
  jobNameFilter = JMCUtils.convertToCharset(jobNameFilter, response.getCharacterEncoding());
	 
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
          <bean:message key="savedJobFilterInstruction"/>
        <p>
        <table BORDER="0" CELLPADDING="0" CELLSPACING="0" role="presentation">
          <tr>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="jobNameFilter" title="<bean:message key="jobName"/>"><b><bean:message key="jobName"/></b></label>
              <BR>
              <input type="text" id="jobNameFilter" name="jobNameFilter" class="noIndentTextEntry" size="20" value="<%=jobNameFilter%>" style="margin-left: 0.4em;"/>
            </td>
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
			<td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="jobGroupFilter" title="<bean:message key="jobGroup"/>"><b><bean:message key="jobGroup"/></b></label>
              <BR>
              <input type="text" id="jobGroupFilter" name="jobGroupFilter" class="noIndentTextEntry" size="20" value="<%=jobGroupFilter%>" style="margin-left: 0.4em;"/>
            </td>
<% } %>
            <td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
              <label for="sortDirection" title="<bean:message key="sortDirection"/>"><b><bean:message key="sortDirection"/></b></label>
              <br>
              <select id="sortDirection" name="sortDirection" class="textEntry" style="margin-left: 0.4em;">
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
