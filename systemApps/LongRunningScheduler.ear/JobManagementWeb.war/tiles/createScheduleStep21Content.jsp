<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="nsForm" name="NewScheduleForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm"/>
<bean:define id="props"  name="NewScheduleForm" property="props"  type="java.util.HashMap"/>

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
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/wwizard_step_current.gif" width="15" height="15" align="left" title="<bean:message key="currentStep"/>" alt="<bean:message key="currentStep"/>">
            </TD>
            <TD CLASS="wizard-tabs-on" VALIGN="top">
              <bean:message key="createScheduleStep21"/>
            </TD>
          </TR>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="images/blank5.gif" width="15" height="15" align="left" alt="">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top" colspan="2">
              <bean:message key="createScheduleStep3"/>
            </TD>
          </TR>
        </TABLE>
        </TD>
        <TD VALIGN="top" CLASS="not-highlighted">
        <DIV style="position:relative; margin-left:0px;margin-right:0px" id="thestep">
          <TABLE width="100%" height="100%" cellpadding="6" cellspacing="0" role="presentation">
            <TR>
              <TD CLASS="wizard-step-title"><bean:message key="createScheduleStep21Title"/></TD>
            </TR>
            <tr>
              <td>
              <p class="instruction-text">
              <bean:message key="createScheduleStep21Desc"/>
              </p>
              </td>
            </tr>
            <tr>
              <td class="wizard-step-expanded" valign="top">
              <div STYLE="overflow: auto; height: 250; margin-left: 1.0em;margin-right: 1em; ">
              <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" CLASS="framing-table">
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
                propValue = JMCUtils.convertToCharset(propValue, response.getCharacterEncoding());
%>
                <TR CLASS="table-row">
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
<% if (nsForm.isRequiredProp(key)) { %>
                    <img id="requiredImage-show-<%= key %>" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<% } else { %>
                <img id="requiredImage-blank-<%= key %>" src="images/blank5.gif" width="8" height="8" align="absmiddle" alt="">
<% } %>
                    <%= key %>
                  </TD>
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
                    
                    <input type="text" title="<%= key %>" name="property.<%= key %>" size="50" value="<%= propValue == null || propValue.length() < 1 ? "": propValue %>" class="noIndentTextEntry" style="margin-left: 0.1em;" id="property.<%= key %>">
                    
                  </TD>
                </TR>
                </logic:iterate>
              </TABLE>
              </div>
              <br>
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
            <input type="hidden" name="currentStep"        value="specify.properties">
            <input type="submit" name="button.specify.job" value="<bean:message key="button.back"/>"       class="buttons" id="button.specify.job">
            <input type="submit" name="button.confirm"     value="<bean:message key="button.next"/>"       class="buttons" id="button.confirm">
            <input type="submit" name="button.submit"      value="<bean:message key="button.finish"/>"     class="buttons" id="button.submit" disabled>
            <input type="submit" name="button.cancel"      value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.cancel">
            </td>
          </tr>
        </TABLE>
        </TD>
      </TR>
    </table>
    </td>
  </tr>
</form>
