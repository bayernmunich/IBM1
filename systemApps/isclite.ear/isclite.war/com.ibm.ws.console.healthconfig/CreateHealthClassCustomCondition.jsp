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
<%@ page import="com.ibm.ws.console.healthconfig.form.HealthClassDetailForm"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>

<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="descImage" classname="java.lang.String" />

<script type="text/javascript" language="JavaScript">
   var initCurrentOnLoadDone = false;
</script>

<%// defect 126608

HealthClassDetailForm testForm = (HealthClassDetailForm)session.getAttribute("CreateHealthClassConditionPropertiesForm");

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
            <bean:message key="healthclass.customCondition.desc"/>
            <br>
            <br>
        </td>
     </tr>
     <tr>
       <td>
         <tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
	       <tiles:put name="actionForm" value="<%=actionForm%>" />
	       <tiles:put name="label" value="healthclass.customCondition.run.reaction.label" />
	       <tiles:put name="desc" value="healthclass.customCondition.desc" />
	       <tiles:put name="hideValidate" value="true" />
       	   <tiles:put name="hideRuleAction" value="true" />
       	   <tiles:put name="rule" value="customExpression" />
       	   <tiles:put name="rowindex" value="" />
       	   <tiles:put name="refId" value="" />
       	   <tiles:put name="ruleActionContext" value="service" />
       	   <tiles:put name="template" value="service" />
       	   <tiles:put name="actionItem0" value="notUsed" />
       	   <tiles:put name="actionListItem0" value="notUsed" />
       	   <tiles:put name="actionItem1" value="notUsed" />
       	   <tiles:put name="actionListItem1" value="notUsed" />
       	   <tiles:put name="quickHelpTopic" value="hc_condition_subex.html" />
       	   <tiles:put name="quickPluginId" value="com.ibm.ws.console.healthconfig" />
           <tiles:put name="customRuleBuilderLayout" value="/com.ibm.ws.console.xdcore/ruleBuilderLayoutForHealthPolicy.jsp" />
       	 </tiles:insert>
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
