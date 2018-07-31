<%@ page import="com.ibm.ws.security.core.SecurityContext,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" %>

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

    document.getElementById("statusFilter").selectedIndex  = 0;
    document.getElementById("sortBy").selectedIndex        = 0;
    document.getElementById("sortDirection").selectedIndex = 0;

    document.getElementById("requestIdFilter").value = "%";
	
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
	document.getElementById("groupFilter").value = "%";
<% } %>
    document.getElementById("submitterFilter").value = "%";
    document.getElementById("startTimeFilter").value = "%";
    document.getElementById("intervalFilter").value  = "%";
    document.getElementById("button.go").click();
}

function changeAction(selectObject) {
   targetObject = document.getElementById("button.execute");
   if (selectObject.options[selectObject.selectedIndex].value == "job.schedule.action.select") {
       targetObject.disabled = true;
   } else {
       targetObject.disabled = false;
   }
}
</script>
