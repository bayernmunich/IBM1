<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>

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
%>

          	<td class="table-text" nowrap>
               <FIELDSET id="verticalStacking">
               <legend for ="verticalStacking" TITLE="<bean:message key="dynamiccluster.verticalStacking.description"/>">
                 <bean:message key="dynamiccluster.verticalStacking.instances"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                           <tbody>
                               <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="VERTICALSTACKING_INSTANCES_ALLOW">
                                           <html:checkbox property="selectedVerticalStackingInstances"
                                                       styleId="VERTICALSTACKING_INSTANCES_ALLOW"
                                                       value="true"
                                                       disabled="<%=val%>"
                                                       onclick="enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances')"
                                                       onkeypress="enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances')"/>
                                           <bean:message key="dynamiccluster.verticalStacking.allow"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap>
                                   <label for="selectedVerticalStackingNumberInstances">
                                       <bean:message key="dynamiccluster.number.instances"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedVerticalStackingNumberInstances"
                                              size="15"
                                              styleId="selectedVerticalStackingNumberInstances"
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
     * Enable and disable the fields associated with the vertical stacking instances type when
     * the page is initially loaded.
     */
     enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances');
</script>

