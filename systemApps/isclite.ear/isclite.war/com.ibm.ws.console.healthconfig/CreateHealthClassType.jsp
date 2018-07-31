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

<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="descImage" classname="java.lang.String" />

<%// defect 126608

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

<html:hidden property="action"/>
<table border="0" cellpadding="3" cellspacing="1" width="100%"	summary="property table">
  <tbody>
    <tr valign="top">
       <td class="table-text" nowrap>

          <FIELDSET id="type">
          	<legend class="hidden">
          		<bean:message key="healthclass.wizard.steps.properties" />
          	</legend>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
               <tbody>
                 <tr valign="top">
                   <td class="table-text" nowrap>
                      <span class="requiredField">
                      <br>
                         <label for="name" TITLE="<bean:message key="healthclass.wizard.name.description"/>">
                            <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                            <bean:message key="healthclass.name"/>
                         </label>
                      </span>
                      <br>
                      <html:text property="name"
                            name="<%=actionForm%>"
                            size="25"
                            styleId="name"
                            styleClass="textEntryRequired" />
                      <br>
                      <br>
                         <label for="description" TITLE="<bean:message key="healthclass.wizard.description.description"/>">
                            <bean:message key="healthclass.description"/>
                         </label>
                      </span>
                      <br>
                      <html:textarea property="description"
                            name="<%=actionForm%>"
                            rows="5"
                            cols="38"
                            styleId="description" />
                   </td>
                 </tr>
                 <tr valign="top">
                   <td class="table-text" nowrap>
                      <br/> 		
                      <FIELDSET id="healthcondition">
                        <legend for ="healthcondition" TITLE="<bean:message key="healthclass.healthcondition.description"/>">
                          <bean:message key="healthclass.type"/>
                        </legend>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                          <tbody>
                            <tr valign="top">
                              <td class="table-text" nowrap>
                                <label for="Predefined" title="<bean:message key="healthclass.customCondition.predefined.text"/>">
                                  <html:radio property="conditionType"
                                    styleId="Predefined"
                                    value="PREDEFINED"
                                    onclick="enableDisable('Predefined:Predefined_0,Custom');"
                                    onkeypress="enableDisable('Predefined:Predefined_0,Custom');"/>
                                  <bean:message key="healthclass.customCondition.predefined.text"/>&nbsp;&nbsp;
                                </label>
                              </td>
                            </tr>
                            <tr valign="top">
                               <td class="complex-property" nowrap>  
                                 <label for="Predefined_0" class="hidden" title="<bean:message key="healthclass.customCondition.predefined.text"/>">
                                 	<bean:message key="healthclass.customCondition.predefined.text"/>
                                 </label>
                                   <html:select property="type" name="<%=actionForm%>" styleId="Predefined_0">
                                     <html:option value="AGE">
                                       <bean:message key="AGE"/>
                                     </html:option>
                                     <html:option value="STUCKREQUEST">
                                       <bean:message key="STUCKREQUEST"/>
                                     </html:option>
                                     <html:option value="RESPONSE">
                                       <bean:message key="RESPONSE"/>
                                     </html:option>
                                     <html:option value="MEMORY">
                                       <bean:message key="MEMORY"/>
                                     </html:option>
                                     <html:option value="MEMORYLEAK">
                                       <bean:message key="MEMORYLEAK"/>
                                     </html:option>
                                     <html:option value="STORMDRAIN">
                                       <bean:message key="STORMDRAIN"/>
                                     </html:option>
                                     <html:option value="WORKLOAD">
                                       <bean:message key="WORKLOAD"/>
                                     </html:option>
                                     <html:option value="GCPERCENTAGE">
                                       <bean:message key="GCPERCENTAGE"/>
                                     </html:option>
                                   </html:select>        
                                 <br/> 		
                                 <br/>
                               </td>
                            </tr>
                            <tr valign="top">
                              <td class="table-text" nowrap>
                                <label for="Custom" title="<bean:message key="healthclass.customCondition.text"/>">
                                  <html:radio property="conditionType"
                                    styleId="Custom"
                                    value="CUSTOM"
                                    onclick="enableDisable('Predefined:Predefined_0,Custom');"
                                    onkeypress="enableDisable('Predefined:Predefined_0,Custom');"/>
                                  <bean:message key="healthclass.customCondition.text"/>&nbsp;&nbsp;
                                </label>
                              </td>
                            </tr>
                         </table>
                      </FIELDSET>
                     </td>
                 </tr>
             </table>
          </FIELDSET>
       </td>
    </tr>
  </tbody>
</table>

<script type="text/javascript" language="JavaScript">
    /**
     * Enable and disable the fields type when
     * the page is initially loaded.
     */
     enableDisable('Predefined:Predefined_0,Custom');
</script>
