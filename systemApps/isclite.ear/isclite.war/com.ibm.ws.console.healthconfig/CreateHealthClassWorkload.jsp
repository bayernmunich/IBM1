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
<table border="0" cellpadding="3" cellspacing="1" width="100%"	role="presentation">
  <tbody>
    <tr valign="top">
       <td class="table-text">
           <bean:message key="healthclass.workload.healthcondition.description"/>
           <br>
           <br>
       </td>
    </tr>
    <tr valign="top">
       <td class="table-text" nowrap>
          <FIELDSET id="workload">
             <legend for ="workload" TITLE="<bean:message key="healthclass.workload.healthcondition.description"/>">
                <bean:message key="healthclass.conditionproperties"/>
             </legend>
             <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tbody>
                 <tr valign="top">
                   <td class="complex-property" nowrap>
                      <span class="requiredField">
                      <br>
                         <label for="totalRequests" TITLE="<bean:message key="healthclass.wizard.requests.description"/>">
                            <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                            <bean:message key="healthclass.requests"/>
                         </label>
                      </span>
                      <br>
                      <html:text property="totalRequests"
                            name="<%=actionForm%>"
                            size="25"
                            styleId="totalRequests"
                            styleClass="textEntryRequired" />
                      <br>
                   </td>
                 </tr>
             </table>
          </FIELDSET>
       </td>
    </tr>
    <tr valign="top">
       <td class="table-text" nowrap>
          <FIELDSET id="monitorReaction">
             <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                <bean:message key="healthclass.monitorreaction"/>
             </legend>
             <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
               <tbody>
                 <tr valign="top">
                   <td class="complex-property" nowrap>
                      <br>
                      <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                          <bean:message key="healthclass.reactionMode" />
                      </label>
                      <br>
                      <html:select property="reactionMode" name="<%=actionForm%>" styleId="reactionMode">
                         <html:option value="REACTION_MODE_SUPERVISED">
                           <bean:message key="REACTION_MODE_SUPERVISED"/>
                         </html:option>
                         <html:option value="REACTION_MODE_AUTOMATIC">
                           <bean:message key="REACTION_MODE_AUTOMATIC"/>
                         </html:option>
                      </html:select>
                      <br>
                   </td>
                 </tr>
                 <tr valign="top">
        			 <td class="table-text"nowrap>
		            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualLayout.jsp" flush="true">
	    	        	<tiles:put name="actionForm" value="<%=actionForm%>" />
            	   		<tiles:put name="callerType" value="wizard"/>
            		</tiles:insert>
      			</td>
                 </tr>
             </table>
          </FIELDSET>
       </td>
    </tr>
  </tbody>
<br>
