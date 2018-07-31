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
<%@ page import="com.ibm.ws.*" %>
<%@ page import="com.ibm.wsspi.*" %>
<%@ page import="com.ibm.ws.console.healthconfig.*"%>
<%@ page import="com.ibm.ws.console.healthconfig.form.HealthClassDetailForm"%>
<%@ page import="com.ibm.ws.xd.config.healthconfig.HealthConfigConstants" %>

<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="org.apache.struts.util.MessageResources"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="callerType" classname="java.lang.String" />

<script language="JavaScript">

function getSelectedActionStepIDs(theElem)
{
   var length;
   var IDsExist = false;
   var selectedIds = "";
   var theForm = theElem.form;

   for (i=0; i < theForm.length; i++)
   {
      if (theForm[i].name == "checkBoxes")
      {
         IDsExist = true;
         break;
      }
   }

   if (IDsExist)
   {
      length = theForm.checkBoxes.length;
      if(length>=2)
      {
         for(i = 0; i < length; i++)
         {
         	if (theForm.checkBoxes[i].checked == true)
         	{
         		if (selectedIds == "")
         			selectedIds = theForm.checkBoxes[i].value;
         		else
         			selectedIds += "," + theForm.checkBoxes[i].value;
         	}
         }
      }
      else
      {
           	if (theForm.checkBoxes.checked == true)
           	{
        		//alert("Found 1:" + theForm.checkBoxes.value);
        		selectedIds = theForm.checkBoxes.value + ",";
        	}
      }
   }
   theForm.selectedIds.value = selectedIds;
}

function disableButtons(theElem)
{
   var rows=0;
   var theForm = theElem.form;

   var selectedIds = "";
   for (i=0; i < theForm.length; i++)
   {
      if (theForm[i].name == "checkBoxes")
      {
         rows++;
      }
   }

	//alert("Rows found: " + rows);
   if (rows < 2)
   {
   		theForm.moveUp.disabled=true;
   		theForm.moveDown.disabled=true;
   }
}

</script>

<%
HealthClassDetailForm testForm = null;
if (callerType.equals("detail"))
{
	testForm = (HealthClassDetailForm)session.getAttribute("HealthClassDetailForm");
}
else
{
	testForm = (HealthClassDetailForm)session.getAttribute("CreateHealthClassConditionPropertiesForm");
}

%>

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
  <tr>
      <td class="table-text">
     	  <fieldset id="actionPlan">
           	<legend for ="actionPlan" title="<bean:message key="healthclass.customCondition.action.label"/>">
  			  <bean:message key="healthclass.customCondition.action.label"/>
			</legend>
	      <table class="button-section" border="0" cellpadding="3" cellspacing="0" width="100%">
	        <tr>
	          <td valign="top" class="function-button-section">
	            <html:submit property="installAction" styleClass="buttons_other">
	              <bean:message key="healthclass.actionPlan.addAction.button"/>
	            </html:submit>
	            <html:submit property="installAction" onclick="javascript:getSelectedActionStepIDs(this);" onkeypress="javascript:getSelectedActionStepIDs(this);" styleClass="buttons_other">
	              <bean:message key="healthclass.actionPlan.deleteAction.button"/>
	            </html:submit>
	            <html:submit property="installAction" onclick="javascript:getSelectedActionStepIDs(this);" onkeypress="javascript:getSelectedActionStepIDs(this);" styleClass="buttons_other">
	              <bean:message key="healthclass.actionPlan.moveUp.button"/>
	            </html:submit>
	            <html:submit property="installAction" onclick="javascript:getSelectedActionStepIDs(this);" onkeypress="javascript:getSelectedActionStepIDs(this);" styleClass="buttons_other">
	              <bean:message key="healthclass.actionPlan.moveDown.button"/>
	            </html:submit>
	            <input type="hidden" name="selectedIds">
	          </td>
	        </tr>
	      </table>
	      <table class="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Generic funtions for the table, such as content filtering">
	        <tr valign="top">
	          <td class="function-button-section"  nowrap>
	            <a id="selectAllButton" HREF="javascript:iscSelectAll('<%=actionForm%>')" class="expand-task">
	              <img id="selectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_select_all.gif" ALT="<bean:message key="select.all.items"/>" BORDER="0" ALIGN="texttop">
	            </a>
            <a id="deselectAllButton" HREF="javascript:iscDeselectAll('<%=actionForm%>')" class="expand-task">
              <img id="deselectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_deselect_all.gif" ALT="<bean:message key="deselect.all.items"/>" BORDER="0" ALIGN="texttop">
            </a>
	          </td>
	        </tr>
	      </table>
	      <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
	        <tr>
	          <th class="column-head-name" scope="col" width="1%" >
	            <bean:message key="select.text"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="healthclass.actionPlan.step.label"/>
	          </th>
	
	          <th class="column-head-name" scope="col" >
	            <bean:message key="healthclass.actionPlan.action.label"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="healthclass.actionPlan.targetServer.label"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="healthclass.actionPlan.targetNode.label"/>
	          </th>
	        </tr>

<%
 	//System.out.println("Trying to get the form data for the action plan");


ArrayList column0 = testForm.getActionPlanSteps();
 	//System.out.println("Trying to get the form data for the action plan A");
ArrayList column1 = testForm.getActionPlanNames();
 	//System.out.println("Trying to get the form data for the action plan B");
ArrayList column2 = testForm.getActionPlanTargetServers();
 	//System.out.println("Trying to get the form data for the action plan C");
ArrayList column3 = testForm.getActionPlanTargetNodes();
String actionName = null;

for (int i=0; i < column0.size(); i++) {
	String moduleMemberId = "moduleMember" + i;
%>

<tr class="table-row">
   <td class="collection-table-text" width="1%">
      <label class="collectionLabel" for="<%=moduleMemberId %>" title='<bean:message key="select.text"/> <bean:message key="healthclass.actionPlan.step.label"/> <%=column0.get(i)%>'>
         <html:checkbox property="checkBoxes" value="<%=Integer.toString(i)%>" styleId="<%=moduleMemberId %>" onclick="checkChecks(this);disableButtons(this);" onkeypress="checkChecks(this)"/>
      </label>
   </td>
   <td class="collection-table-text"><%=column0.get(i)%></td>
   <%
   actionName = (String) column1.get(i);
   if (actionName.equals("HEALTH_ACTION_RESTART"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_RESTART"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_THREADDUMP"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_THREADDUMP"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_HEAPDUMP"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_HEAPDUMP"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_MAINTMODE"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_MAINTMODE"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_MAINTBREAKMODE"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_MAINTBREAKMODE"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_NORMMODE"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_NORMMODE"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_CUSTOM"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_CUSTOM"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else if (actionName.equals("HEALTH_ACTION_SENDSNMPTRAP"))
   { %>
        <td class="collection-table-text"><bean:message key="HEALTH_ACTION_SENDSNMPTRAP"/></td>
	<td class="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
<% }
   else
   { 
   String serverStr = (String)column2.get(i);
   %>
        <td class="collection-table-text"><%=actionName%></td>
        <% if (serverStr.equalsIgnoreCase(HealthConfigConstants.SICK_SERVER)) { %>
			<td CLASS="collection-table-text"><bean:message key="healthclass.sick.server"/></td>
		<% } else if (serverStr.equalsIgnoreCase(HealthConfigConstants.NODE_AGENT_OF_SICK_SERVER)) { %>
			<td CLASS="collection-table-text"><bean:message key="healthclass.sick.server.nodeagent"/></td>
		<% } else { %>
			<td CLASS="collection-table-text"><%=serverStr%></td>
		<% } %>
<% }



   String nodeVal = (String)column3.get(i);
   if (nodeVal == null || nodeVal.equals(""))
   { %>
   <td class="collection-table-text"><bean:message key="healthclass.node.hosting.sick.server"/></td>
 <%} else { %>
   <td class="collection-table-text"><%=column3.get(i)%></td>
   <%}%>

</tr>

<%
}
// Column size is null	
ServletContext servletContext = (ServletContext) pageContext.getServletContext();
MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
if (column0.size() == 0) {
  String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
  //out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
  out.println("<tr class='table-row'><td colspan='5'>"+nonefound+"</td></tr>");
}

%>




      </table>
      </fieldset>
    </td>
  </tr>
</table>
