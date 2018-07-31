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
<%@ page import="org.apache.struts.action.*"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page language="java" import="com.ibm.ws.console.distmanagement.wizard.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.form.CreateDynamicClusterForm"%>
<%@ page language="java" import="com.ibm.ws.console.middlewareserver.MiddlewareServerUtils"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<script language="JavaScript">
function dynamicClusterServerTypeChanged() {
  //When the server type is changed show/hide name.
  var selectedServerType = document.forms[0].dynamicClusterServerType.value;

  if ( (selectedServerType == "APPLICATION_SERVER") || (selectedServerType == "ONDEMAND_ROUTER") ) {
      document.getElementById("nameBlock").style.display = "none";
  } else {
      document.getElementById("nameBlock").style.display = "block";
  }
}
</script>

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
//TODO -- remove this and just get ifForeignServer from the FORM in both action classes and then display the correct
// style type
CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterManagementForm");
boolean isForeignServer = cdcf.isForeignServer();
MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
java.util.Locale locale = request.getLocale();
String serverTypeDisplayName = "";
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />


<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	<tbody>
		<tr valign="top">
		 <td class="table-text" nowrap valign="top">
		   <label for="dynamicClusterServerType" title='<bean:message key="dynamiccluster.wizard.steps.create.select.type.desc"/>'>
		     <bean:message key="dynamiccluster.wizard.steps.create.select.type"/>
		   </label>
		   <br />
		   <html:select property="dynamicClusterServerType" size="1" styleId="dynamicClusterServerType" onclick="dynamicClusterServerTypeChanged()" onkeypress="dynamicClusterServerTypeChanged()">
		     <logic:iterate id="dynamicClusterServerType" name="<%=actionForm%>" property="dynamicClusterServerTypes">
				<% 	String value = (String) dynamicClusterServerType;
				   	value=value.trim();
					if (!value.equals("")) {
                                          serverTypeDisplayName = MiddlewareServerUtils.mapFromServerType(value, locale, messages);
                                %>
					    <html:option value="<%=value%>"><%=serverTypeDisplayName%></html:option>
			  	 <% } else { %>
			  	        <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
			   	 <%  } %>
		     </logic:iterate>
		   </html:select>
		 </td>
		</tr>
		</tbody>
		   <%if (isForeignServer) { %>
   		   <tbody id="nameBlock" style="display:block">
   		   <%} else { %>
   		   <tbody id="nameBlock" style="display:none">
   		   <%}%>
   		    <tr>
   		     <td class="table-text" valign="top">
		     <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
               <tiles:put name="property" value="name" />
               <tiles:put name="isReadOnly" value="no" />
               <tiles:put name="isRequired" value="yes" />
               <tiles:put name="label" value="dynamiccluster.name.displayName" />
               <tiles:put name="desc" value="dynamiccluster.name.description" />
               <tiles:put name="size" value="30" />
               <tiles:put name="units" value=""/>
               <tiles:put name="bean" value="<%=actionForm%>" />
               <tiles:put name="includeTD" value="false" />
		     </tiles:insert>
		     </td>
		    </tr>
		   </tbody>
</table>
