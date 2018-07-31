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
<%@ page language="java" import="com.ibm.ws.console.core.utils.VersionHelper"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="nodes" name="<%=actionForm%>" property="nodePath"/>
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
boolean isForeignServer = cdcf.isForeignServer();
String membershipType = cdcf.getMembershipType();
String manualType = cdcf.getManualType();

// Get the cell name
String cellName = ((RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY)).getName();

// Get localized (none) message to place in the pulldowns
ServletContext servletContext = (ServletContext) pageContext.getServletContext();
MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);

// Get node version helper
VersionHelper versionHelper = new VersionHelper(cellName, messages, request.getLocale());

%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">

               <label for="selectedNodeFirst" TITLE="<bean:message key="new.cluster.member.node.description"/>"><bean:message key="appserver.selectAppServer.msg3"/></label>
               <BR>
               <html:select property="selectedNodeFirst" styleId="selectedNodeFirst" size="1" onclick="setTemplateDropDownLists(this.form);" onkeypress="setTemplateDropDownLists(this.form);">
                 <logic:iterate id="node" name="<%=actionForm%>" property="nodePath">
                   <%
                      String nodeNm = (String)node;
                      String display = nodeNm + versionHelper.getDropdownNodeVersion(nodeNm);
                   %>
                   <html:option value="<%=nodeNm%>" >
                     <%=display%>
                   </html:option>
                 </logic:iterate>
               </html:select>
         </td>
	  </tr>		
	</tbody>
</table>
