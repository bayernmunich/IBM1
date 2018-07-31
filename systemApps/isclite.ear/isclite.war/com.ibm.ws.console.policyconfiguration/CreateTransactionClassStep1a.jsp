<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ page language="java" import="com.ibm.ws.console.policyconfiguration.form.CreateServiceClassStep1Form"%>
<%@ page language="java" import="com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="descImage" classname="java.lang.String" />


<%  // defect 126608
  String image = ""; 
  String pluginId = "";
  String pluginRoot = "";

  if (descImage != "")
  {
     int index = descImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = descImage.substring (index + 9);
        if (index != 0)
           descImage = descImage.substring (0, index);
        else
           descImage = "";
     }
     else 
     {
        index = descImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = descImage.substring (index + 18);
           if (index != 0)
              descImage = descImage.substring (0, index);
           else
              descImage = "";
        }
     }
  }
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>

<%
	String fieldLevelHelpTopic = "";
	String fieldLevelHelpAttribute = "";
	String DETAILFORM = "DetailForm";
	String objectType = "";
	int index = formType.lastIndexOf ('.');
	if (index > 0)
	{
		String fType = formType.substring (index+1);
		if (fType.endsWith (DETAILFORM))
			objectType = fType.substring (0, fType.length()-DETAILFORM.length());
		else
			objectType = fType;
	}
	fieldLevelHelpTopic = objectType+".detail.";
	String topicKey = fieldLevelHelpTopic;   

	String nextStep = (String) session.getAttribute("nextAction");
	String attribute = "";
	String spName = "";
	if (nextStep.equals("success"))
		attribute = "ServiceClassDetailForm";
	else
		attribute = "CreateServiceClassStep3Form";

	ServiceClassDetailForm detailForm = (ServiceClassDetailForm) session.getAttribute(attribute);
	spName = detailForm.getName();
%>

<html>
<body>
<table border="0" cellpadding="3" cellspacing="1" width="100%" 	role="presentation">
	<tbody>
		<tr valign="top">
			<td class="table-text" nowrap width="20%">
				<bean:message key="transactionclass.sp.wizard.description" arg0="<%=spName%>"/>
				<br /><br />
    		 	<span class="requiredField">
	               <label for="name" title='<bean:message key="transactionclass.desc.name"/>'>
	                <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                    <bean:message key="transactionclass.label.name"/>
	               </label>
	     	    </span>
                <br>
                <html:text property="name" size="30" styleId="name" styleClass="textEntryRequired" />
            </td>
	<% 
		fieldLevelHelpTopic = topicKey + "name";
	 %>  
<!-- 
        <td class="table-text" valign="top" width="33%">
           <ibmcommon:info image="help.additional.information.image.align" topic="<%//=fieldLevelHelpTopic%>"/>
           <bean:message key="transactionclass.desc.name"/>
        </td>
-->

		</tr>
		<tr valign="top">
			<td class="table-text" nowrap width="20%">
                <label for="description" title='<bean:message key="transactionclass.detail.description.description"/>'>
                 <bean:message key="transactionclass.detail.descname"/>
                </label>
                <br>
                <html:textarea property="description" cols="38" rows="5" styleId="description" styleClass="textEntry" />
            </td>
			<% 
				fieldLevelHelpTopic = topicKey + "description";
			 %>  
<!-- 
		     <td class="table-text" valign="top" width="33%">
	           <ibmcommon:info image="help.additional.information.image.align" topic="<%//=fieldLevelHelpTopic%>"/>
	           <bean:message key="transactionclass.detail.description.description"/>
	        </td>
 -->
				
		</tr>


	</tbody>
</table>
</body>
</html>
