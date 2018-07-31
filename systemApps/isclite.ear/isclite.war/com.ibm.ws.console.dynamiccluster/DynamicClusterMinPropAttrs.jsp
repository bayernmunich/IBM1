<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page import="com.ibm.ws.console.dynamiccluster.form.DynamicClusterDetailForm"%>
<%@ page import="com.ibm.ws.xd.util.MiddlewareServerConstants"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute  name="property" classname="java.lang.String"/>
<tiles:useAttribute  name="bean" classname="java.lang.String"/>

<tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<%
    String contextId = (String)request.getAttribute("contextId");
    AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
    String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

    String showNoneText = "none.text";
    boolean isODRServer = false;
    DynamicClusterDetailForm dynamicClusterDetailForm = (DynamicClusterDetailForm)session.getAttribute("DynamicClusterDetailForm");
    if (dynamicClusterDetailForm != null) {
       if (dynamicClusterDetailForm.getServerType().equals(MiddlewareServerConstants.ONDEMAND_ROUTER)) {
    	   isODRServer = true;
       }
    }
    
    boolean val = false;
    if (readOnly != null && readOnly.equals("true"))
        val = true;
    else if (SecurityContext.isSecurityEnabled()) { 		
        contextUri = contextUri.replaceFirst("dynamicclusters", "clusters");
        if ((adminAuthorizer.checkAccess(contextUri, "administrator")) || (adminAuthorizer.checkAccess(contextUri, "configurator"))) {
            val = false;
        }
        else {
            val = true;
        }
    }
    boolean disableMinInst = val;
    if (isODRServer) {
    	disableMinInst = true;
    }
%>

          	<td class="table-text" nowrap>
               <FIELDSET id="minimumInstances">
               <legend for ="minimumInstances" TITLE="<bean:message key="dynamiccluster.minimumInstances.description"/>">
                 <bean:message key="dynamiccluster.minimum.instances"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                           <tbody>
                                <tr valign="top">
                                   <td class="table-text">
                                       <label for="MINIMUM_INSTANCES_ZERO">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_ZERO"
                                                       value="MINIMUM_INSTANCES_ZERO"
                                                       disabled="<%=disableMinInst%>"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                       </label>
                                   </td>
                                   <td class="table-text">
                                           <bean:message key="dynamiccluster.minimum.instances.zero"/>&nbsp;&nbsp;
			            			</td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap colspan="2">
                                   <label for="selectedServerInactivityTime">
                                       <bean:message key="dynamiccluster.minimum.instances.waittime"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedServerInactivityTime"
                                              size="15"
                                              styleId="selectedServerInactivityTime"
                                              disabled="<%=val%>"
                                              styleClass="textEntry" /> <bean:message key="dynamiccluster.minimum.instances.minutes"/>&nbsp;&nbsp;
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="table-text" nowrap colspan="2">
                                       <label for="MINIMUM_INSTANCES_ONE">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_ONE"
                                                       value="MINIMUM_INSTANCES_ONE"
                                                       disabled="<%=val%>"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                           <bean:message key="dynamiccluster.minimum.instances.one"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="table-text" nowrap colspan="2">
                                       <label for="MINIMUM_INSTANCES_MULTIPLE">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_MULTIPLE"
                                                       value="MINIMUM_INSTANCES_MULTIPLE"
                                                       disabled="<%=val%>"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                           <bean:message key="dynamiccluster.minimum.instances.multiple"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap colspan="2">
                                   <label for="selectedMinimumNumberInstances">
                                       <bean:message key="dynamiccluster.number.instances"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedMinimumNumberInstances"
                                              size="15"
                                              styleId="selectedMinimumNumberInstances"
                                              disabled="<%=val%>"
                                              styleClass="textEntry" />
                                   </td>
                               </tr>
			</table>
		</FIELDSET>
          </td>
     </tr>


<script type="text/javascript" language="JavaScript">
    /**
     * Enable and disable the fields associated with the minimum instances type when
     * the page is initially loaded.
     */
     enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances');
</script>

