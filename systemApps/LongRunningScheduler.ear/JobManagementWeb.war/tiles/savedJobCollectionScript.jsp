<%@ page import="com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" %>

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

<script>
function clearFilter(theForm) {
    document.getElementById("sortDirection").selectedIndex = 0;
    document.getElementById("jobNameFilter").value = "%";
	
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
	document.getElementById("jobGroupFilter").value = "%";
<% } %>

    document.getElementById("button.go").click();
}
</script>
