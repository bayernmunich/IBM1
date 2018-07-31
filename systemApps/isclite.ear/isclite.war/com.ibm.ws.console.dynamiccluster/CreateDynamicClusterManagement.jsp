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
<%@ page language="java" import="com.ibm.ws.console.distmanagement.wizard.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.form.CreateDynamicClusterForm"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.utils.DynamicClusterConstants"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<%// defect 126608

String descImage = "pluginId=com.ibm.ws.console.dynamiccluster";
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

CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterManagementForm");
boolean isWASServer = cdcf.isWASServer();
boolean isODRServer = cdcf.isODRServer();
boolean isRepresentable = cdcf.isRepresentable();
String membershipType = cdcf.getMembershipType();
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />


<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
	    <td class="table-text" nowrap valign="middle">	
		  <fieldset id="membershipType">
           	<legend for ="membershipType" title="<bean:message key="dynamiccluster.wizard.steps.management.define.desc"/>">
  			  <bean:message key="dynamiccluster.wizard.steps.management.define"/>
			</legend>
		 		
            <label for="Automatic" title="<bean:message key="dynamiccluster.wizard.steps.management.automatic.desc"/>">
 		      <html:radio property="membershipType" styleId="Automatic" value="Automatic"
 		                  onclick="enableDisable('Automatic:automaticType_0,Automatic:automaticType_1,Automatic:automaticType_2');" onkeypress="enableDisable('Automatic:automaticType_0,Automatic:automaticType_1,Automatic:automaticType_2');" />
              <bean:message key="dynamiccluster.wizard.steps.management.automatic"/>&nbsp;&nbsp;
 		    </label>
 		
 		    <% if ((isWASServer) || (isODRServer)) {%>
   		    <div id="name">
              <br />
              &nbsp;&nbsp;
              <label for="automaticType_0" title="<bean:message key="dynamiccluster.name.description"/>">
                <!-- <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">  -->
                <bean:message key="dynamiccluster.name.displayName" />
              </label>
              <br />

              &nbsp;&nbsp;
              <html:text property="name" name="<%=actionForm%>" size="30" styleClass="textEntry" styleId="automaticType_0" />
  		      <br />

		      &nbsp;&nbsp;
			  <label for="automaticType_1" title="<bean:message key="dynamiccluster.preferLocal.description"/>">
				<html:checkbox property="preferLocal" value="true" styleId="automaticType_1" />
				<bean:message key="prefer.local" />&nbsp;&nbsp;
			  </label>
			  <br />

 		      <% if (!(isODRServer)) {%>
			  &nbsp;&nbsp;
			  <label for="automaticType_2" title='<bean:message key="create.replication.domain.description"/>'>
				<html:checkbox property="createDomain" value="true" styleId="automaticType_2" />
			    <bean:message key="create.replication.domain" />&nbsp;&nbsp;
			  </label>
			  <br />
 		      <%} %>
		    </div>
 		    <%} %>

 		    <% if ((isWASServer) || (isRepresentable) || (isODRServer)) {%>
 		    <br />
 		    <label for="Manual" title="<bean:message key="dynamiccluster.wizard.steps.management.manual.desc"/>">
 		      <html:radio property="membershipType" styleId="Manual" value="Manual"
 		                  onclick="enableDisable('Automatic:automaticType_0,Automatic:automaticType_1,Automatic:automaticType_2')" onkeypress="enableDisable('Automatic:automaticType_0,Automatic:automaticType_1,Automatic:automaticType_2')" />
              <bean:message key="dynamiccluster.wizard.steps.management.manual"/>&nbsp;&nbsp;
 		    </label>
 		    <%} %>
 		  </fieldset>
        </td>
	  </tr>		
	</tbody>
</table>