<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="java.util.Calendar,com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<%@ include file="/tiles/tileFieldDefs.jsp" %>

<bean:define id="startDate"    name="NewScheduleForm" property="startDate"    type="java.lang.String"/>
<bean:define id="startTime"    name="NewScheduleForm" property="startTime"    type="java.lang.String"/>
<bean:define id="interval"     name="NewScheduleForm" property="interval"     type="java.lang.String"/>
<bean:define id="scheduleName" name="NewScheduleForm" property="scheduleName" type="java.lang.String"/>

<bean:define id="newScheduleForm" name="NewScheduleForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm"/>

<%
    scheduleName = JMCUtils.convertToCharset(scheduleName, response.getCharacterEncoding());
%>
<form name="NewScheduleForm" method="post" action="/jmc/createSchedule.do?action=execute" id="NewScheduleForm" <%=JMCUtils.encType()%>>
  <tr>
    <td>
    <table width="100%" cellpadding="0" cellspacing="0" class="wizard-table" ID="outterMostTable" role="presentation">
      <tr>
        <TD WIDTH="20%" VALIGN="top">
        <TABLE width="150" height="100%" cellpadding="8" cellspacing="0" role="presentation">
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/wwizard_step_current.gif" width="15" height="15" align="left" title="<bean:message key="currentStep"/>" alt="<bean:message key="currentStep"/>">
            </TD>
            <TD CLASS="wizard-tabs-on" VALIGN="top">
              <bean:message key="createScheduleStep1"/>
            </TD>
          </TR>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top">
              <bean:message key="createScheduleStep2"/>
            </TD>
          </TR>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top">
              <bean:message key="createScheduleStep3"/>
            </TD>
          </TR>
        </TABLE>
        </TD>
        <TD VALIGN="top" CLASS="not-highlighted">
        <DIV style="position:relative; margin-left:0px;margin-right:0px" id="thestep">
          <TABLE width="100%" height="100%" cellpadding="6" cellspacing="0" role="presentation">
            <TR>
              <TD CLASS="wizard-step-title"><bean:message key="createScheduleStep1Title"/></TD>
            </TR>
            <tr>
              <td>
              <p class="instruction-text">
              <bean:message key="createScheduleStep1Desc"/>
              </p>
              </td>
            </tr>
            <tr>
              <td class="complex-property" style="padding-left: 1.75em;" nowrap>
              <img id="requiredImage-schedulename" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
              <label for="scheduleName" style="margin-left: 0.0em;" title="<bean:message key="scheduleName"/>"><bean:message key="scheduleName"/>:</label><br>
              <input type="text" name="scheduleName" size="30" value="<%=scheduleName%>" class="noIndentTextEntry" style="margin-left: 0.6em;" id="scheduleName">
              </td>
            </tr>
            <tr>
              <td class="complex-property" style="padding-left: 1.75em;" nowrap>
              <tiles:insert beanName="date.field">
                <tiles:put name="startDate"  value="<%=startDate%>" />
                <tiles:put name="disabled"   value="" />
                <tiles:put name="required"   value="true" />
                <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
              </tiles:insert>
              </td>
            </tr>
            <tr>
              <td class="complex-property" style="padding-left: 1.75em;" nowrap>
              <tiles:insert beanName="time.field">
                <tiles:put name="startTime" value="<%=startTime%>" />
                <tiles:put name="disabled"  value="" />
                <tiles:put name="required"  value="true" />
                <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
              </tiles:insert>
              </td>
            </tr>
            <tr>
              <td class="complex-property" style="padding-left: 1.75em;" nowrap>
              <img id="requiredImage-interval" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
              <label for="interval" style="margin-left: 0.0em;" title="<bean:message key="interval"/>"><bean:message key="interval"/>:</label><br>
              <select id="interval" name="interval" class="textEntry" style="margin-left: 0.6em;" >
                <option value="daily"   <%= interval.equals("daily")   ? "selected=\"selected\"" : "" %>><bean:message key="daily"/></option>
                <option value="weekly"  <%= interval.equals("weekly")  ? "selected=\"selected\"" : "" %>><bean:message key="weekly"/></option>
                <option value="monthly" <%= interval.equals("monthly") ? "selected=\"selected\"" : "" %>><bean:message key="monthly"/></option>
              </select>
              <br>&nbsp;
              </td>
            </tr>
          </TABLE>
        </DIV>
        </TD>
      </TR>
      <TR>
        <TD COLSPAN="3">
        <TABLE width="100%" cellpadding="6" cellspacing="0">
          <tr>
            <td class="wizard-button-section"  ALIGN="center">
            <input type="hidden" name="currentStep"             value="specify.schedule">
            <input type="submit" name="button.specify.schedule" value="<bean:message key="button.back"/>"       class="buttons" id="button.specify.schedule" disabled>
            <input type="submit" name="button.specify.job"      value="<bean:message key="button.next"/>"       class="buttons" id="button.specify.job">
            <input type="submit" name="button.submit"           value="<bean:message key="button.finish"/>"     class="buttons" id="button.submit" disabled>
            <input type="reset"  name="button.reset"            value="<bean:message key="job.schedule.action.cancel"/>" class="buttons" id="button.reset">
            </td>
          </tr>
        </TABLE>
        </TD>
      </TR>
    </table>
    </td>
  </tr>
</form>
