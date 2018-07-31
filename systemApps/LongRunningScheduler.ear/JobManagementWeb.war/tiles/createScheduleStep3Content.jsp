<%@ page import="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="scheduleName" name="NewScheduleForm" property="scheduleName" type="java.lang.String"/>
<bean:define id="startDate"    name="NewScheduleForm" property="startDate"    type="java.lang.String"/>
<bean:define id="startTime"    name="NewScheduleForm" property="startTime"    type="java.lang.String"/>
<bean:define id="interval"     name="NewScheduleForm" property="interval"     type="java.lang.String"/>
<bean:define id="xjclPath"     name="NewScheduleForm" property="xjclPath"     type="java.lang.String"/>
<bean:define id="jobName"      name="NewScheduleForm" property="jobName"      type="java.lang.String"/>
<bean:define id="submitBy"     name="NewScheduleForm" property="submitBy"     type="java.lang.String"/>
<bean:define id="props"        name="NewScheduleForm" property="props"        type="java.util.HashMap"/>

<bean:define id="newScheduleForm" name="NewScheduleForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm"/>

<%
    scheduleName = JMCUtils.convertToCharset(scheduleName, response.getCharacterEncoding());
    xjclPath     = JMCUtils.convertToCharset(xjclPath,     response.getCharacterEncoding());
    jobName      = JMCUtils.convertToCharset(jobName,      response.getCharacterEncoding());
%>

<form name="NewScheduleForm" method="post" action="/jmc/createSchedule.do?action=execute" id="NewScheduleForm" ENCTYPE="multipart/form-data">
  <tr>
    <td>
    <table width="100%" cellpadding="0" cellspacing="0" class="wizard-table" ID="outterMostTable" role="presentation">
      <tr>
        <TD WIDTH="20%" VALIGN="top">
        <TABLE width="150" height="100%" cellpadding="8" cellspacing="0" role="presentation">
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top" colspan="2">
              <bean:message key="createScheduleStep1"/>
            </TD>
          </TR>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top" colspan="2">
              <bean:message key="createScheduleStep2"/>
            </TD>
          </TR>
<% if (props.size() > 0) { %>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top">
              <bean:message key="createScheduleStep21"/>
            </TD>
          </TR>
<% } %>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/wwizard_step_current.gif" width="15" height="15" align="left" title="<bean:message key="currentStep"/>" alt="<bean:message key="currentStep"/>">
            </TD>
            <TD CLASS="wizard-tabs-on" VALIGN="top"colspan="2">
              <bean:message key="createScheduleStep3"/>
            </TD>
          </TR>
        </TABLE>
        </TD>
        <TD VALIGN="top" CLASS="not-highlighted">
        <DIV style="position:relative; margin-left:0px;margin-right:0px" id="thestep">
          <TABLE width="100%" height="100%" cellpadding="6" cellspacing="0" role="presentation">
            <TR>
              <TD CLASS="wizard-step-title"><bean:message key="createScheduleStep3Title"/></TD>
            </TR>
            <tr>
              <td>
              <p class="instruction-text">
              <bean:message key="createScheduleStep3Desc"/>
              </p>
              </td>
            </tr>
            <tr>
              <td class="wizard-step-expanded" valign="top">
              <fieldset id="summary" TITLE="Summary" style="margin-left: .75em;margin-right: .75em;margin-top: .5em;margin-bottom: .5em;">
              <LEGEND><bean:message key="summary"/></LEGEND>
              <table class="instruction-text" role="presentation">
                <tr>
                  <td>&nbsp;<font color="226699"><bean:message key="summaryScheduleName"/></font></td>
                  <td>&nbsp;<%= scheduleName %></td>
                </tr>
                <tr>
                  <td>&nbsp;<font color="226699"><bean:message key="summarySchedule"/></font></td>
                  <td>&nbsp;<%= startDate %>&nbsp;<%= startTime %>&nbsp;<%= interval %></td>
                </tr>
                <tr>
                  <td>&nbsp;<font color="226699"><bean:message key="summaryJobToSchedule"/></font></td>
                  <td>&nbsp;<%= submitBy.equals("local") ? xjclPath : jobName %></td>
                </tr>
              </table>
<% if (props.size() > 0) { %>
              <p class="instruction-text">
              &nbsp;<font color="226699"><bean:message key="summarySubstitutionProperties"/></font>
              </p>
              <div STYLE="overflow: auto; height: 200; margin-left: 1.5em;margin-right: 1em; ">
              <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" CLASS="framing-table">
                <TR>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="30%">
                  <bean:message key="propName"/>
                  </TH>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="50%">
                  <bean:message key="propValue"/>
                  </TH>
                </TR>
                <logic:iterate id="key" name="NewScheduleForm" property="propsKeys" type="java.lang.String">
<%
                String propValue = (String) props.get(key);
%>
                <TR CLASS="table-row">
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
<% if (newScheduleForm.isRequiredProp(key)) { %>
                  <img id="requiredImage-show-<%=key%>" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<% } else { %>
                  <img id="requiredImage-blank-<%=key%>" src="images/blank5.gif" width="8" height="8" align="absmiddle" alt="">
<% } %>
                  <%= key %>
                  </TD>
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
                    <%= propValue == null || propValue.length() < 1 ? "": propValue %>
                  </TD>
                </TR>
                </logic:iterate>
              </TABLE>
              </div>
              <br>
<% } else { %>
              </p>
<% } %>
              </fieldset>
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
            <input type="hidden" name="currentStep"               value="confirm">
            <input type="submit" name="button.specify.properties" value="<bean:message key="button.back"/>"       class="buttons" id="button.specify.properties">
            <input type="submit" name="button.next"               value="<bean:message key="button.next"/>"       class="buttons" id="button.next" disabled>
            <input type="submit" name="button.submit"             value="<bean:message key="button.finish"/>"     class="buttons" id="button.submit">
            <input type="submit" name="button.specify.schedule"   value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.specify.schedule">
            </td>
          </tr>
        </TABLE>
        </TD>
      </TR>
    </table>
    </td>
  </tr>
</form>
