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

%>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
           <label for="defaultServer">
             <bean:message key="default.appserver.choose.template" />&nbsp;&nbsp;
           </label>
           <br />

			<html:select property="defaultServer" styleId="defaultServer" size="1">
			  <logic:iterate id="defaultServer" name="<%=actionForm%>" property="defaultServerPath">
			  <%String serverStr = (String) defaultServer;
				int index = serverStr.indexOf("/");
				String serverName = serverStr.substring(index + 1);
				// defaultXD is deprecated
				if ((!serverName.equalsIgnoreCase("defaultXD"))  &&
					(!serverName.equalsIgnoreCase("defaultXDZOS"))) {
					
				%>
				<html:option value="<%=(String) defaultServer%>">
				<%=(String) serverName%>
				</html:option>
				<%
				}
				   %>
			  </logic:iterate>
			</html:select>

         </td>
	  </tr>		
	</tbody>
</table>
