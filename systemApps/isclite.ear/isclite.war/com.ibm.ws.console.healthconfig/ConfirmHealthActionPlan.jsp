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
<%@ page language="java" import="com.ibm.ws.console.healthconfig.form.CreateHealthActionPlanWizardForm"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<%
String confirmMsg = (String) session.getAttribute("confMsg");

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
%>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
    <tr valign="top">
        <td class="table-text" valign="top" scope="row">
            <label title='<bean:message key="wizard.summary.label.alt"/>'>
                <bean:message key="wizard.summary.label"/>:
            </label>
            <br>
            <p class="textEntryReadOnlyLong" name="summary" style="min-height:5em">
                <%=confirmMsg%>
            </p>
        </td>
    </tr>
</table>
