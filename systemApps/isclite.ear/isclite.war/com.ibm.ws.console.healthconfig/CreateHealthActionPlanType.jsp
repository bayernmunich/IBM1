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
<%@ page language="java" import="com.ibm.ws.sm.workspace.WorkSpace"%>
<%@ page language="java" import="com.ibm.ws.console.healthconfig.form.CreateHealthActionPlanWizardForm"%>
<%@ page language="java" import="com.ibm.ws.console.healthconfig.util.HealthUtils"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<%

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

WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
CreateHealthActionPlanWizardForm wizardForm = (CreateHealthActionPlanWizardForm)session.getAttribute("CreateHealthActionPlanTypeForm");
ArrayList list = new ArrayList(Arrays.asList(HealthUtils.listHealthCustomAction(wksp)));
wizardForm.setCustomActionList(list);
String newCustomActionName = (String)session.getAttribute("NEW_CUSTOM_HEALTH_POLICY_ACTION_NAME");
if (newCustomActionName != null) {
   wizardForm.setSelectedCustomAction(newCustomActionName);
}
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />


<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
   <tbody>
      <tr valign="top">
         <td class="table-text" nowrap valign="middle">	
            <fieldset id="actionType">
               <legend for ="actionType" title="<bean:message key="healthclass.actionPlan.wizard.steps.selectType"/>">
                  <bean:message key="healthclass.actionPlan.wizard.steps.selectType"/>
               </legend>
               <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                  <tbody>
                     <tr valign="top">
                        <td class="table-text" nowrap>
                           <label for="Predefined" title="<bean:message key="healthclass.actionPlan.predefinedAction.button"/>">
                              <html:radio property="actionType" styleId="Predefined" value="Predefined"
                                 onclick="enableDisable('Predefined:Predefined_0,Custom:Custom_0');"
                                 onkeypress="enableDisable('Predefined:Predefined_0,Custom:Custom_0');"
                              />
                             <bean:message key="healthclass.actionPlan.predefinedAction.button"/>
                           </label>
                        </td>
                     </tr>
                     <tr valign="top">
                        <td class="complex-property" nowrap>
                           <label for="Predefined_0" class="hidden" title='<bean:message key="healthclass.actionPlan.predefinedAction.button"/>'>
                           		<bean:message key="healthclass.actionPlan.predefinedAction.button"/>
                           </label>
                           <html:select property="selectedPredefinedAction" name="<%=actionForm%>" styleId="Predefined_0">
                              <html:option value="HEALTH_ACTION_RESTART">
                                 <bean:message key="HEALTH_ACTION_RESTART"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_THREADDUMP">
                                 <bean:message key="HEALTH_ACTION_THREADDUMP"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_HEAPDUMP">
                                 <bean:message key="HEALTH_ACTION_HEAPDUMP"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_SENDSNMPTRAP">
                                 <bean:message key="HEALTH_ACTION_SENDSNMPTRAP"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_MAINTMODE">
                                 <bean:message key="HEALTH_ACTION_MAINTMODE"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_MAINTBREAKMODE">
                                 <bean:message key="HEALTH_ACTION_MAINTBREAKMODE"/>
                              </html:option>
                              <html:option value="HEALTH_ACTION_NORMMODE">
                                 <bean:message key="HEALTH_ACTION_NORMMODE"/>
                              </html:option>
                           </html:select>
                           <br/> 		
                           <br/> 		
                        </td>
                     </tr>
                     <tr valign="top">
                        <td class="table-text" nowrap >
                           <label for="Custom" title="<bean:message key="healthclass.actionPlan.customAction.button"/>">
                              <html:radio property="actionType" styleId="Custom" value="Custom"
                                 onclick="enableDisable('Predefined:Predefined_0,Custom:Custom_0');"
                                 onkeypress="enableDisable('Predefined:Predefined_0,Custom:Custom_0');"
                              />
                             <bean:message key="healthclass.actionPlan.customAction.button"/>
                           </label>
                        </td>
                     </tr>
                     <tr valign="top">
                        <td class="complex-property" nowrap>
                           <label for="Custom_0" class="hidden" title="<bean:message key="healthclass.actionPlan.customAction.button"/>">
                           		<bean:message key="healthclass.actionPlan.customAction.button"/>
                           </label>
                           <html:select property="selectedCustomAction" name="<%=actionForm%>" styleId="Custom_0">
                              <html:option value="healthclass.customAction.selectAction.newcustomAction"><bean:message key="healthclass.customAction.selectAction.newcustomAction"/></html:option>
                              <logic:iterate id="dropDownItem" name="<%=actionForm%>" property="customActionList">
                                 <% String current = (String) dropDownItem;
                                    String value = current.toString();
                                    String displayText = value;
                                    if (!value.equals("")) {  %>
                                       <html:option value="<%=value%>"><%=displayText%></html:option>
                                    <% } else { %>
                                       <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
                                    <%  } %>
                              </logic:iterate>
                           </html:select>
                           <br/>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </fieldset>
         </td>
      </tr>		
   </tbody>
</table>

<script type="text/javascript" language="JavaScript">
    /**
     * Enable and disable the fields type when
     * the page is initially loaded.
     */
     enableDisable('Predefined:Predefined_0,Custom:Custom_0');
</script>

