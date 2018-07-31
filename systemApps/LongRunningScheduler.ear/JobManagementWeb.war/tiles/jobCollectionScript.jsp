<%@ page import="com.ibm.ws.security.core.SecurityContext,com.ibm.ws.batch.security.BatchSecurity,com.ibm.websphere.wim.SchemaConstants" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%
  boolean isAdmin = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
     isAdmin = false;
	 
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

//    document.getElementById("typeFilter").selectedIndex    = 0;
    document.getElementById("stateFilter").selectedIndex   = 0;
    document.getElementById("sortBy").selectedIndex        = 0;
    document.getElementById("sortDirection").selectedIndex = 0;

<% if (isAdmin) { %>
    document.getElementById("submitterFilter").value = "%";
<% } %>
    document.getElementById("jobIdFilter").value     = "%";
    document.getElementById("nodeFilter").value      = "%";
    document.getElementById("appServerFilter").value = "%";
<% if (isGroupSecurity || isGroupRoleSecurity) { %>
	document.getElementById("groupFilter").value = "%";
<% } %>
	
    document.getElementById("button.go").click();
}

function showHideSuspendedTime() {
    targetObject = document.getElementById("suspendTimeSection");
    if (targetObject.style.display == "none") {
        targetObject.style.display = showIt;
    } else {
        targetObject.style.display = "none";
    }
}

function changeAction(selectObject) {
   targetObject = document.getElementById("suspendTimeSection");
   if (selectObject.options[selectObject.selectedIndex].value == "job.action.suspend") {
       targetObject.style.display = showIt;
   } else {
       targetObject.style.display = "none";
   }
   targetObject = document.getElementById("button.execute");
   if (selectObject.options[selectObject.selectedIndex].value == "job.action.select") {
       targetObject.disabled = true;
   } else {
       targetObject.disabled = false;
   }
}
</script>
