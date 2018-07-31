<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ page import="com.ibm.ws.console.healthconfig.form.CreateHealthClassWizardForm"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<bean:define id="name" name="<%=actionForm%>" property="name" type="java.lang.String" />
<bean:define id="description" name="<%=actionForm%>" property="description" type="java.lang.String" />
<bean:define id="reactionMode" name="<%=actionForm%>" property="reactionMode" type="java.lang.String" />
<bean:define id="type" name="<%=actionForm%>" property="type" type="java.lang.String" />
<bean:define id="age" name="<%=actionForm%>" property="age" type="java.lang.Integer" />
<bean:define id="ageUnits" name="<%=actionForm%>" property="ageUnits" type="java.lang.String" />
<bean:define id="requests" name="<%=actionForm%>" property="totalRequests" type="java.lang.Long" />
<bean:define id="responseTime" name="<%=actionForm%>" property="responseTime" type="java.lang.Integer" />
<bean:define id="timeUnits" name="<%=actionForm%>" property="responseTimeUnits" type="java.lang.String" />
<bean:define id="totalMemory" name="<%=actionForm%>" property="totalMemory" type="java.lang.Integer" />
<bean:define id="timeOverThreshold" name="<%=actionForm%>" property="timeOverThreshold" type="java.lang.Integer" />
<bean:define id="units" name="<%=actionForm%>" property="timeUnits" type="java.lang.String" />
<bean:define id="timeoutPercent" name="<%=actionForm%>" property="timeoutPercent" type="java.lang.Integer" />
<bean:define id="stormDrainConditionLevel" name="<%=actionForm%>" property="stormDrainConditionLevel" type="java.lang.String" />
<bean:define id="memoryLeakConditionLevel" name="<%=actionForm%>" property="memoryLeakConditionLevel" type="java.lang.String" />
<bean:define id="garbageCollectionPercent" name="<%=actionForm%>" property="garbageCollectionPercent" type="java.lang.Integer" />
<bean:define id="samplingPeriod" name="<%=actionForm%>" property="samplingPeriod" type="java.lang.Integer" />
<bean:define id="samplingUnits" name="<%=actionForm%>" property="samplingUnits" type="java.lang.String" />
<bean:define id="customExpression" name="<%=actionForm%>" property="customExpression" type="java.lang.String" />

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">

  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left">
          <bean:message key="healthclass.confirm.msg1"/>
          <bean:message key="healthclass.confirm.msg2"/>
	  </td>
  </tr>
</table>
	
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
   <tr>
     <th class="column-head-name" scope="col"> <bean:message key="healthclass.summary.options"/></th>
     <th class="column-head-name" scope="col"><bean:message key="healthclass.summary.values"/></th>
   </tr>
   <%
	MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
	java.util.Locale locale = request.getLocale();
	String translatedReactionMode = messages.getMessage(locale,reactionMode);
	description = description.replaceAll("<","&#60;");
       description = description.replaceAll(">","&#62;");
	%>
   <tr CLASS="table-row">
       <td class="collection-table-text"><bean:message key="healthclass.name"/></td>
       <td class="collection-table-text"><%=name%></td>
   </tr>
   <tr CLASS="table-row">
       <td class="collection-table-text"><bean:message key="healthclass.description"/></td>
       <td class="collection-table-text"><%=description%></td>
   </tr>
   <%if (type.equalsIgnoreCase("AGE")) {
            String ageString = age.toString();
            String translatedUnits = messages.getMessage(locale,ageUnits); %>

            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="AGE"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.age"/></td>
                <td class="collection-table-text"><%=ageString%>&nbsp;<%=translatedUnits%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("WORKLOAD")) {
   	     String requestsString = requests.toString();               %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="WORKLOAD"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.requests"/></td>
                <td class="collection-table-text"><%=requestsString%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("RESPONSE")) {
            String timeString = responseTime.toString();
            String translatedUnits = messages.getMessage(locale,timeUnits); %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="RESPONSE"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.responsetime"/></td>
                <td class="collection-table-text"><%=timeString%>&nbsp;<%=translatedUnits%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("MEMORY")) {
            String translatedUnits = messages.getMessage(locale,units);
            String memoryString = totalMemory.toString();
            String timeString = timeOverThreshold.toString();  %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="MEMORY"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.memory"/></td>
                <td class="collection-table-text"><%=memoryString%><bean:message key="percent.sign"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.timeoverthreshold"/></td>
                <td class="collection-table-text"><%=timeString%>&nbsp;<%=translatedUnits%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("STUCKREQUEST")) {
            String timeoutPercentString = timeoutPercent.toString(); %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="STUCKREQUEST"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.timeoutpercent"/></td>
                <td class="collection-table-text"><%=timeoutPercentString%><bean:message key="percent.sign"/></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("STORMDRAIN")) {
            String translatedlevel = "";
            if (stormDrainConditionLevel.equals("CONDITION_LEVEL_NORMAL"))
               translatedlevel = messages.getMessage(locale,"healthclass.stormdrain.normallevel");
            else
               translatedlevel = messages.getMessage(locale,"healthclass.stormdrain.conservativelevel"); %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="STORMDRAIN"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.detectionlevel"/></td>
                <td class="collection-table-text"><%=translatedlevel%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("MEMORYLEAK")) {
            String translatedlevel = "";
            if (memoryLeakConditionLevel.equals("CONDITION_LEVEL_AGGRESSIVE"))
               translatedlevel = messages.getMessage(locale,"healthclass.memoryleak.aggressivelevel");
            else if (memoryLeakConditionLevel.equals("CONDITION_LEVEL_NORMAL"))
               translatedlevel = messages.getMessage(locale,"healthclass.memoryleak.normallevel");
            else
               translatedlevel = messages.getMessage(locale,"healthclass.memoryleak.conservativelevel"); %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="MEMORYLEAK"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.detectionlevel"/></td>
                <td class="collection-table-text"><%=translatedlevel%></td>
            </tr>
     <%
   }
   else if (type.equalsIgnoreCase("GCPERCENTAGE")) {
           String translatedSamplingPeriod = messages.getMessage(locale,samplingUnits);
           String gcPercentString = garbageCollectionPercent.toString();
           String samplingString = samplingPeriod.toString();  %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="GCPERCENTAGE"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.gcpercentage"/></td>
                <td class="collection-table-text"><%=gcPercentString%><bean:message key="percent.sign"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.samplingperiod"/></td>
                <td class="collection-table-text"><%=samplingString%>&nbsp;<%=translatedSamplingPeriod%></td>
            </tr>
    <%
   }
   else if (type.equalsIgnoreCase("CUSTOM")) { %>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.type"/></td>
                <td class="collection-table-text"><bean:message key="CUSTOM"/></td>
            </tr>
            <tr CLASS="table-row">
                <td class="collection-table-text"><bean:message key="healthclass.custom.expression"/></td>
                <td class="collection-table-text"><%=customExpression%></td>
            </tr>
     <%
   } %>
   <tr CLASS="table-row">
       <td class="collection-table-text"><bean:message key="healthclass.reactionMode"/></td>
       <td class="collection-table-text"><%=translatedReactionMode%></td>
   </tr>
   <tr CLASS="table-row">
       <td class="collection-table-text"><bean:message key="healthclass.actionPlan.actions.label"/></td>
       <%
       String actionsString = "";
       String actionName = null;
       CreateHealthClassWizardForm testForm = (CreateHealthClassWizardForm)session.getAttribute("ConfirmHealthClassCreateForm");
       ArrayList selectedActions = (ArrayList)testForm.getActionPlanNames();
       for (int i = 0; i < selectedActions.size(); i++) { // for List
          actionName = (String) selectedActions.get(i);
          if (actionName.equals("HEALTH_ACTION_RESTART"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_RESTART");
          else if (actionName.equals("HEALTH_ACTION_THREADDUMP"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_THREADDUMP");
          else if (actionName.equals("HEALTH_ACTION_HEAPDUMP"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_HEAPDUMP");
          else if (actionName.equals("HEALTH_ACTION_MAINTMODE"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_MAINTMODE");
          else if (actionName.equals("HEALTH_ACTION_MAINTBREAKMODE"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_MAINTBREAKMODE");
          else if (actionName.equals("HEALTH_ACTION_NORMMODE"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_NORMMODE");
          else if (actionName.equals("HEALTH_ACTION_CUSTOM"))
             actionName = messages.getMessage(locale,"HEALTH_ACTION_CUSTOM");
          else if (actionName.equals("HEALTH_ACTION_SENDSNMPTRAP"))
        	 actionName = messages.getMessage(locale,"HEALTH_ACTION_SENDSNMPTRAP");

          actionsString = actionsString + actionName + "<br />";
       }
       %>
       <td class="collection-table-text" nowrap><%=actionsString%></td>
   </tr>
   <tr CLASS="table-row">
       <td class="collection-table-text"><bean:message key="healthclass.details.members"/></td>
       <%
       String membersString = "";
       ArrayList selectedMembers = (ArrayList)testForm.getCurrentMembership(messages, locale);
       for (int i = 0; i < selectedMembers.size(); i++) { // for List
          membersString = membersString + (String) selectedMembers.get(i) + "<br />";
       }
       %>
       <td class="collection-table-text" nowrap><%=membersString%></td>
   </tr>

</table>
