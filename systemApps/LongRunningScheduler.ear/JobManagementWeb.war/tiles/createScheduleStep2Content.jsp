<%@ page import="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<bean:define id="xjclPath" name="NewScheduleForm" property="xjclPath" type="java.lang.String"/>
<bean:define id="jobName"  name="NewScheduleForm" property="jobName"  type="java.lang.String"/>
<bean:define id="submitBy" name="NewScheduleForm" property="submitBy" type="java.lang.String"/>
<!-- Debug Information
xjclPath: <%=xjclPath%>
jobName: <%=jobName%>
submitBy: <%=submitBy%>
 -->

<bean:define id="newScheduleForm" name="NewScheduleForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewScheduleForm"/>

<%
    boolean isAdmin = true;
    if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
       isAdmin = false;

    jobName = JMCUtils.convertToCharset(jobName, response.getCharacterEncoding());
%>

<BODY>


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
            <TD CLASS="wizard-tabs-off" VALIGN="top">
              <bean:message key="createScheduleStep1"/>
            </TD>
          </TR>
          <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
            <img src="images/wwizard_step_current.gif" width="15" height="15" align="left" title="<bean:message key="currentStep"/>" alt="<bean:message key="currentStep"/>">
            </TD>
            <TD CLASS="wizard-tabs-on" VALIGN="top">
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
              <TD CLASS="wizard-step-title"><bean:message key="createScheduleStep2Title"/></TD>
            </TR>
            <tr>
              <td>
              <p class="instruction-text">
              <bean:message key="createScheduleStep2Desc"/>
              </p>
              </td>
            </tr>
            <tr>
              <td class="table-text" valign="top">
			  <fieldset style="border: 0px; margin: 0px; padding: 0px">
			  <legend class="hidden"><bean:message key="job.definition"/></legend>
              <table width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
                <tr valign="baseline">
                  <td class="table-text">
                  <label CLASS="collectionLabel" for="submitByLFS" title="<bean:message key="localFileSystem"/>">
                    <input type="radio" name="submitBy" value="local" <%=submitBy.equals("local") ? "checked" : "" %> onclick="enableDisable('xjclFile')" id="submitByLFS">
                    <bean:message key="localFileSystem"/>
                  </label>
                  </td>
                </tr>
                <tr>
                  <td class="complex-property" nowrap>
                  <img id="requiredImage-path" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
                  <label style="margin-left: 0.0em;" for="xjclFile" title="<bean:message key="specifyPath"/>"><bean:message key="specifyPath"/></label><br>
                  <input type="file"   name="xjclFile" size="50" value="<%=submitBy.equals("local") ? xjclPath : "" %>" class="fileUpload" id="xjclFile" style="margin-left: 0.6em;">
                  </td>
                </tr>
                <tr valign="baseline">
                  <td class="table-text">
                  <label CLASS="collectionLabel" for="submitByJR" title="<bean:message key="jobRepository"/>">
                    <input type="radio" name="submitBy" value="job.repository" <%=submitBy.equals("local") ? "" : "checked" %> onclick="enableDisable('submitJobName')" id="submitByJR">
                    <bean:message key="jobRepository"/>
                  </label>
                  </td>
                </tr>
                <tr>
                  <td class="complex-property" nowrap>
                  <img id="requiredImage-jobname" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
                  <label for="submitJobName" style="margin-left: 0.0em;" title="<bean:message key="specifyJobName"/>"><bean:message key="specifyJobName"/></label><br>
                  <input type="text"   name="submitJobName" size="25" value="<%=submitBy.equals("local") ? "" : jobName%>" class="noIndentTextEntry" style="margin-left: 0.6em;" id="submitJobName">
                  <input type="submit" name="redirect.browse" value="<bean:message key="button.browse"/>" class="buttons" id="redirect.browse" style="font-size:85.0%;"/>
                  <br>&nbsp;
                  </td>
                </tr>
              </table>
			  </fieldset>
              </td>
            </tr>
          </TABLE>
        </DIV>
        </TD>
      </TR>
      <TR>
        <TD COLSPAN="3">
        <TABLE width="100%" cellpadding="6" cellspacing="0" role="presentation">
          <tr>
            <td class="wizard-button-section"  ALIGN="center">
            <input type="hidden" name="currentStep"               value="specify.job">
            <input type="submit" name="button.specify.schedule"   value="<bean:message key="button.back"/>"       class="buttons" id="button.specify.schedule">
            <input type="submit" name="button.specify.properties" value="<bean:message key="button.next"/>"       class="buttons" id="button.specify.properties">
            <input type="submit" name="button.submit"             value="<bean:message key="button.finish"/>"     class="buttons" id="button.submit" disabled>
            <input type="submit" name="button.cancel"             value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.cancel">
            </td>
          </tr>
        </TABLE>
        </TD>
      </TR>
    </table>
    </td>
  </tr>
</form>

<script>
enableDisable(<%=submitBy.equals("local") ? "'xjclFile'" : "''" %>);
</script>
