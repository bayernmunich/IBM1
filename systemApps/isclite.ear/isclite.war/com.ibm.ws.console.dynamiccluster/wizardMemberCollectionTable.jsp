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
<%@ page language="java" import="com.ibm.ws.console.distmanagement.DistHelper"%>
<%@ page language="java" import="com.ibm.ws.console.distmanagement.topology.ClusterMemberCollectionForm"%>
<%@ page language="java" import="com.ibm.ws.console.distmanagement.topology.ClusterMemberDetailForm"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="nodes" name="<%=actionForm%>" property="nodePath"/>

<%
    // Get the cell name
    String cellName = ((RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY)).getName();

    // Get node version helper
    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
    MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
    String noneText = messages.getMessage(request.getLocale(),"none.text");
    VersionHelper versionHelper = new VersionHelper(cellName, messages, request.getLocale());

    // Determine which wizard is running (cluster wizard or cluster member wizard)
    String wizardType = (String)session.getAttribute("com.ibm.ws.console.distmanagement.wizard.type");

    // Determine if the Edit button was previously pressed
    //boolean previousActionWasEditAction = (EditRowNumber.intValue() != -1)? true : false;

    // Determine if there is at least one ZOS node in the list of nodes
    boolean nodeListContainsZOSNode = DistHelper.containsZosNode((ArrayList)nodes, cellName);
%>



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
// Get the cluster member collection form (if it exists)
ClusterMemberCollectionForm clusterMemberCollectionForm = cdcf.getClusterMemberCollectionForm();
boolean isForeignServer = cdcf.isForeignServer();
String membershipType = cdcf.getMembershipType();
String manualType = cdcf.getManualType();
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
  <tr>
    <td valign="top" class="wizard-step-text" colspan="2">
      <html:submit styleClass="buttons_other" property="installAction">
        <bean:message key="button.add.member"/>
      </html:submit>
    </td>
  </tr>
  <tr>
    <td>
     <fieldset style="border:0px; padding:0pt; margin: 0pt;">
	  <legend class="hidden"><bean:message key="dynamiccluster.membership.table.title"/></legend>
      <table class="button-section" border="0" cellpadding="3" cellspacing="0" width="100%" summary="List table">
        <tr>
          <th valign="top" class="function-button-section">
            <html:submit property="installAction" styleClass="buttons_other">
              <bean:message key="button.new"/>
            </html:submit>
            <html:submit property="installAction" styleClass="buttons_other">
              <bean:message key="button.remove"/>
            </html:submit>
          </th>
        </tr>
      </table>
      <table class="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Generic funtions for the table, such as content filtering">
        <tr valign="top">
          <td class="function-button-section"  nowrap>
            <a id="selectAllButton" HREF="javascript:iscSelectAll('<%=actionForm%>','clusterMember')" CLASS="expand-task">
              <img id="selectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_select_all.gif" ALT="<bean:message key="select.all.items"/>" BORDER="0" ALIGN="texttop">
            </a>
            <a id="deselectAllButton" HREF="javascript:iscDeselectAll('<%=actionForm%>','clusterMember')" CLASS="expand-task">
              <img id="deselectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_deselect_all.gif" ALT="<bean:message key="deselect.all.items"/>" BORDER="0" ALIGN="texttop">
            </a>
          </td>
        </tr>
      </table>
      <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
        <tr>
          <th class="column-head-name" scope="col" width="1%">
            <bean:message key="select.text"/>
          </th>
          <th class="column-head-name" scope="col" >
            <bean:message key="ClusterMember.memberName.displayName"/>
          </th>

          <th class="column-head-name" scope="col" >
            <bean:message key="new.cluster.nodes"/>
          </th>
          <th class="column-head-name" scope="col" >
            <bean:message key="node.version.displayName"/>
          </th>
        </tr>

<%
      com.ibm.ws.sm.workspace.WorkSpace workspace = (com.ibm.ws.sm.workspace.WorkSpace)request.getSession().getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
      // Place the additional cluster members in the table
      ArrayList column0 = cdcf.getColumn0();
      ArrayList column1 = cdcf.getColumn1();

      for (int i=0; i < column0.size(); i++) {
    	  String checkboxId="clusterMember_" + i;
%>
        <tr class="table-row">
          <td CLASS="collection-table-text" width="1%">
             <label class="collectionLabel" for="<%=checkboxId%>" title="<bean:message key="select.text"/> <%=column0.get(i)%>">
                <html:checkbox property="checkBoxes" styleId="<%=checkboxId%>" value="<%=Integer.toString(i)%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)"/>
             </label>
          </td>
          <td NOWRAP CLASS="collection-table-text"><%=column0.get(i)%> </td>
          <td NOWRAP CLASS="collection-table-text"><%=column1.get(i)%></td>
<%
            String expandedVersion = "";
            try {
                expandedVersion = versionHelper.getCollectionNodeVersion((String)column1.get(i));
                byte[] utf8Bytes = expandedVersion.getBytes("UTF8");
                String utfVersion = new String(utf8Bytes, "UTF8");
                //check to see if this is an XD only node
                if (!utfVersion.startsWith("ND ") && !utfVersion.startsWith("Base "))
                {
                   expandedVersion = com.ibm.ws.console.middlewareserver.MiddlewareServerUtils.getXDANodeVersion((String)column1.get(i), workspace);
                }
            } catch (Exception e) {
                expandedVersion = "";
                e.printStackTrace();
            }

%>
          <td NOWRAP CLASS="collection-table-text"><%=expandedVersion%></td>
        </tr>
<%    } %>
<%
     // Place the existing cluster members in the table.  The existing members are added to the table
     // without a checkbox so that the user cannot edit or delete them.
     if (wizardType != null && wizardType.equals("ClusterMemberWizard") && clusterMemberCollectionForm != null && (clusterMemberCollectionForm.getContents().size() > 0)) {
         // In ClusterMember wizard and there are existing cluster members

         // Walk through each existing member and determine the member name, node and weight
         Iterator clusterMemberIterator = clusterMemberCollectionForm.getContents().iterator();

         while (clusterMemberIterator.hasNext()) {
             ClusterMemberDetailForm clusterMemberDetailForm = (ClusterMemberDetailForm) clusterMemberIterator.next();
             // Add existing member to the member table
%>
        <tr class="table-row">
          <td CLASS="collection-table-text" width="1%">
            <label class="collectionLabel"/>
          </td>
          <td CLASS="collection-table-text"><%=clusterMemberDetailForm.getMemberName()%> </td>
          <td CLASS="collection-table-text"><%=clusterMemberDetailForm.getNode()%></td>
          <td CLASS="collection-table-text"><%=versionHelper.getCollectionNodeVersion((String)clusterMemberDetailForm.getNode())%></td>
        </tr>
<%
         } // end while have existing members
     }

     if (column0.size() == 0) {
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        //out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
        out.println("<tr class='table-row'><td colspan='4'>"+nonefound+"</td></tr>");
     }
%>
      </table>
      </fieldset>
    </td>
  </tr>
</table>
