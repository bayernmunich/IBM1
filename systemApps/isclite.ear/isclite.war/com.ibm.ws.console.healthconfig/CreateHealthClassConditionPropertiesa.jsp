<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.ws.console.healthconfig.form.CreateHealthClassWizardForm,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="descImage" classname="java.lang.String" />
<%
CreateHealthClassWizardForm testForm = (CreateHealthClassWizardForm)session.getAttribute("CreateHealthClassConditionPropertiesForm");
String predefinedType = testForm.getType();
String conditionType = testForm.getConditionType();
%>

<%  // defect 126608
  String image = "";
  String pluginId = "";
  String pluginRoot = "";

  if (descImage != "")  {
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

<%  String renderReadOnlyView = "no";
if( (readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes")) ) {
  renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
    renderReadOnlyView = "yes";
    if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
    }
    else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
    }
}

   String numberOfColumns = "3";
   WASProduct productInfo = new WASProduct();
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

%>
<%

if (conditionType.equals("CUSTOM"))
  {
    String[] customHealthPolicyActions = testForm.getCustomHealthPolicyHealthAction();

    testForm.setupActionPlan(customHealthPolicyActions);
    %>
    <tiles:insert definition="healthclass.wizard.steps.customcondition.attributes" flush="false">
    </tiles:insert>
<%}
else
  {
	if (predefinedType.equals("WORKLOAD")) {
	String[] workloadActions = testForm.getWorkloadHealthAction();
	
	testForm.setupActionPlan(workloadActions);
	%>
    	<tiles:insert definition="healthclass.wizard.steps.workloadcondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else if (predefinedType.equals("MEMORY")) {
	String[] memoryActions = testForm.getMemoryHealthAction();
	
	testForm.setupActionPlan(memoryActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.memorycondition.attributes" flush="false">
    	</tiles:insert>
	<%}
	else if (predefinedType.equals("RESPONSE")) {
	String[] responseActions = testForm.getResponseHealthAction();
	
	testForm.setupActionPlan(responseActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.responsecondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else if (predefinedType.equals("STUCKREQUEST")) {
	String[] stuckRequestActions = testForm.getStuckRequestHealthAction();
	
	testForm.setupActionPlan(stuckRequestActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.stuckrequestcondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else if (predefinedType.equals("STORMDRAIN")) {
	String[] stormDrainActions = testForm.getStormDrainHealthAction();
	
	testForm.setupActionPlan(stormDrainActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.stormdraincondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else if (predefinedType.equals("MEMORYLEAK")) {
	String[] memoryLeakActions = testForm.getMemoryLeakHealthAction();
	
	testForm.setupActionPlan(memoryLeakActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.memoryleakcondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else if (predefinedType.equals("GCPERCENTAGE")) {
	String[] garbageCollectActions = testForm.getGCPercentageHealthAction();
	
	testForm.setupActionPlan(garbageCollectActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.gcpercentagecondition.attributes" flush="false">
	    </tiles:insert>
	<%}
	else { //default to age, although it should NEVER happen
	String[] ageActions = testForm.getAgeHealthAction();
	
	testForm.setupActionPlan(ageActions);
	%>
	    <tiles:insert definition="healthclass.wizard.steps.agecondition.attributes" flush="false">
    	</tiles:insert>
	<%}
  }

//default to age, although it should NEVER happen

%>
</tbody>
</table>