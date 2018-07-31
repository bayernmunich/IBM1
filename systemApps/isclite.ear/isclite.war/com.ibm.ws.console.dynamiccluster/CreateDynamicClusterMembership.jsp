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
String membershipType = cdcf.getMembershipType();
String manualType = cdcf.getManualType();
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />


<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
		 <% if (membershipType.equals(DynamicClusterConstants.OPMODE_AUTOMATIC)) {%>
		         <tiles:insert page="/com.ibm.ws.console.dynamiccluster/DynamicClusterMembershipPropAttrs.jsp" flush="false">
                   <tiles:put name="label" value="dynamiccluster.membershipPolicy.define" />
                   <tiles:put name="desc" value="dynamiccluster.membershipPolicy.description"/>
                   <tiles:put name="bean" value="<%=actionForm%>" />
                   <tiles:put name="readOnly" value="false" />
                   <tiles:put name="jspPage" value="/com.ibm.ws.console.dynamiccluster/DynamicClusterMembershipPropAttrs.jsp"/>
                   <tiles:put name="units" value=""/>
                   <tiles:put name="property" value="membershipPolicy" />
                   <tiles:put name="isRequired" value="no" />
                   <tiles:put name="size" value="30" />
                </tiles:insert>		
		 <% } else { %>
         <%     if ((isWASServer) || (isODRServer)) {%>
                		 <label for="staticClusterName" title='<bean:message key="dynamiccluster.wizard.steps.membership.cluster.desc"/>'>
                    	   <bean:message key="dynamiccluster.wizard.steps.membership.cluster"/>
                    	 </label>
                         <br />

                       	 <html:select property="staticClusterName" size="1" styleId="staticClusterName" >
                    	   <logic:iterate id="staticClusterName" name="<%=actionForm%>" property="staticClusterNames">
                   		   <% String value = (String) staticClusterName;
				              value=value.trim();
                			  if (!value.equals("")) {  %>
            	    			  <html:option value="<%=value%>"><%=value%></html:option>
			               <% } else { %>
                			      <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
                		   <%  } %>
                    	   </logic:iterate>
                    	 </html:select>
         <%	   } else {%>
                	   	 <tiles:insert page="/com.ibm.ws.console.dynamiccluster/DynamicClusterManualMembershipPropAttrs.jsp" flush="false">
                	       <tiles:put name="actionForm" value="<%=actionForm%>" />
                    	 </tiles:insert>
         <%    }
            }
         %>
         </td>
	  </tr>		
	</tbody>
</table>
