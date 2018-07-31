<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.xd.config.healthconfig.HealthConfigConstants" %>
<%@ page language="java" import="com.ibm.ws.console.healthconfig.form.CreateHealthActionPlanWizardForm"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<script language="JavaScript">
function updateServerNames() {
		var installAction = "update";
		var updatedNode = null;
				
		updatedNode = document.forms[0].selectedTargetNode.value;
		//window.location = encodeURI("/ibm/console/CreateHealthActionPlanTarget.do?installAction=" +installAction );
		window.location = encodeURI("/ibm/console/CreateHealthActionPlanTarget.do?installAction=" +installAction +"&updatednode=" + updatedNode
         + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");

	}
</script>


<%
CreateHealthActionPlanWizardForm wizardForm = (CreateHealthActionPlanWizardForm)session.getAttribute("CreateHealthActionPlanTargetForm");
String selectedTargetNode = wizardForm.getSelectedTargetNode();

String descImage = "pluginId=com.ibm.ws.console.healthconfig";
String image = "";
String pluginId = "";
String pluginRoot = "";

if (descImage != "") {
	int index = descImage.indexOf("pluginId=");
	if (index >= 0) {
		pluginId = descImage.substring(index + 9);
		if (index != 0)
			descImage = descImage.substring(0, index);
		else
			descImage = "";
	} else {
		index = descImage.indexOf("pluginContextRoot=");
		if (index >= 0) {
			pluginRoot = descImage.substring(index + 18);
			if (index != 0)
				descImage = descImage.substring(0, index);
			else
				descImage = "";
		}
	}
}

//CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterManagementForm");
//boolean isForeignServer = cdcf.isForeignServer();
//String membershipType = cdcf.getMembershipType();

//request.setParameter("installAction","update");
String updateServers = "updateServerNames()";
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />


<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	  <tr valign="top">
	    <td class="table-text" nowrap valign="middle">	
            <label for="targetNode" title="<bean:message key="healthclass.actionPlan.targetNode.label"/>">
             <bean:message key="healthclass.actionPlan.targetNode.label"/>
             </label>
        </td>
       </tr>
       <tr valign="top">
 	    <td class="table-text" nowrap valign="middle">	
       		<html:select property="selectedTargetNode" name="<%=actionForm%>" styleId="targetNode" onchange="<%=updateServers%>" >
 		         <logic:iterate id="dropDownItem" name="<%=actionForm%>" property="targetNodeList">
                  <% String current = (String) dropDownItem;
                     String value = current.toString();
                     String displayText = value;
                     if (value.equals("")) {  %>
                     	<html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
            	  <% } else if (value.equalsIgnoreCase(HealthConfigConstants.NODE_HOSTING_SICK_SERVER)) { %>
            	  		<html:option value="<%=value %>"><bean:message key="healthclass.node.hosting.sick.server"/></html:option>
			      <% } else { %>
                  	    <html:option value="<%=value%>"><%=displayText%></html:option>
                  <%  } %>
                  </logic:iterate>
            </html:select>
	     </td>
	    </tr>
	    <tr valign="top" >
	      <td class="table-text" nowrap valign="middle">
 		    <label for="targetServer" title="<bean:message key="healthclass.actionPlan.targetServer.label"/>">
            <bean:message key="healthclass.actionPlan.targetServer.label"/>
   		    </label>
          </td>
        </tr>       
        <tr valign="top" >
          <td class="table-text" nowrap valign="middle">
        	<html:select property="selectedTargetServer" name="<%=actionForm%>" styleId="targetServer">
        		 <% if (!selectedTargetNode.equalsIgnoreCase(HealthConfigConstants.NODE_HOSTING_SICK_SERVER)) { %>
 		         	<html:option value=""><bean:message key="healthclass.actionPlan.wizard.steps.notspecified"/></html:option>
 		         <% } %>
 		         <logic:iterate id="dropDownItem" name="<%=actionForm%>" property="targetServerList">
                  <% String current = (String) dropDownItem;
                     String value = current.toString();
                     String displayText = value;
                     if (!value.equals("")) {  %>
            	     <% if (value.equals(HealthConfigConstants.SICK_SERVER)) { %>
              			<html:option value="<%=value%>"><bean:message key="healthclass.sick.server"/></html:option> 
              		 <% } else if (value.equals(HealthConfigConstants.NODE_AGENT_OF_SICK_SERVER)) { %>
              		 	<html:option value="<%=value%>"><bean:message key="healthclass.sick.server.nodeagent"/></html:option> 
              		 <% } else { %>
                     	<html:option value="<%=value%>"><%=displayText%></html:option>
                     <% } %>
			      <% } else { %>
                  	    <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
                  <%  } %>
                  </logic:iterate>
    	    </html:select>
    	  </td>
	     </tr>	
</table>
