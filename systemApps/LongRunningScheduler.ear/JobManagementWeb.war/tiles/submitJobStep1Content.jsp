<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page language="java" import="com.ibm.ws.batch.jobmanagement.web.forms.NewJobForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils"%>
<%@ taglib uri="/WEB-INF/struts-html.tld"  prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld"  prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<%@ include file="/tiles/tileFieldDefs.jsp" %>

<bean:define id="xjclPath"    name="NewJobForm" property="xjclPath"    type="java.lang.String"/>
<bean:define id="jobName"     name="NewJobForm" property="jobName"     type="java.lang.String"/>
<bean:define id="submitBy"    name="NewJobForm" property="submitBy"    type="java.lang.String"/>
<bean:define id="updateProps" name="NewJobForm" property="updateProps" type="java.lang.String"/>
<bean:define id="delaySubmit" name="NewJobForm" property="delaySubmit" type="java.lang.String"/>
<bean:define id="startDate"   name="NewJobForm" property="startDate"   type="java.lang.String"/>
<bean:define id="startTime"   name="NewJobForm" property="startTime"   type="java.lang.String"/>

<bean:define id="newJobForm"  name="NewJobForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewJobForm"/>

<%
    String disabled = delaySubmit.equals("true") ? "" : "disabled";
    if (newJobForm.isPropertyNeedConvertToCharset("jobName"))
        jobName = JMCUtils.convertToCharset(jobName, response.getCharacterEncoding());
    String lang           = response.getLocale().toString();
    String buttonFontSize = "85%";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW"))
        buttonFontSize = "80%";
%>

<form name="NewJobForm" method="post" action="/jmc/submitJob.do?action=execute" id="NewJobForm" ENCTYPE="multipart/form-data">
  <tr>
    <td>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="90%" role="presentation">
      <tr valign="top">
        <td class="table-text" nowrap>
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
              <input type="submit" name="redirect.browse" value="<bean:message key="button.browse"/>" class="buttons" id="redirect.browse" style="font-size:<%= buttonFontSize %>;">
            </td>
          </tr>
		  
          <tr valign="top">
            <td  class="table-text">
            <label for="updateProps" title=" <bean:message key="updateProps"/>">
              <input type="checkbox" name="updateProps" value="on" id="updateProps" <%=updateProps.equals("true") ? "checked" : "" %>>
              <bean:message key="updateProps"/>
            </label>
            </td>
          </tr>
          <tr valign="top">
            <td  class="table-text">
            <label for="delaySubmit" title="<bean:message key="delaySubmit"/>">
              <input type="checkbox" name="delaySubmit" value="on" id="delaySubmit" onclick="enableDisableDateTime()" <%=delaySubmit.equals("true") ? "checked" : "" %>>
              <bean:message key="delaySubmit"/>
            </label>
            </td>
          </tr>
          <tr>
            <td class="complex-property" nowrap>
            <tiles:insert beanName="date.field">
              <tiles:put name="startDate"  value="<%=startDate%>" />
              <tiles:put name="disabled"   value="<%=disabled%>" />
              <tiles:put name="required"   value="true" />
              <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
            </tiles:insert>
            </td>
          </tr>
          <tr>
            <td class="complex-property" nowrap>
            <tiles:insert beanName="time.field">
              <tiles:put name="startTime"  value="<%=startTime%>" />
              <tiles:put name="disabled"   value="<%=disabled%>" />
              <tiles:put name="required"   value="true" />
              <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
            </tiles:insert>
            </td>
          </tr>
          <tr>
            <td>
            <br>&nbsp;
            <input type="hidden" name="currentStep"   value="specify.job">
            <input type="submit" name="button.submit" value="<bean:message key="button.submit"/>"     class="buttons" id="button.submit" style="margin-left: -0.6em;">
            <input type="reset"  name="button.reset"  value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.reset">
            </td>
          </tr>
        </table>
		</fieldset>
        </td>
      </tr>
    </TABLE>
    </td>
  </tr>
</form>
<script>
enableDisable("<%= submitBy.equals("local") ? "xjclFile" : "" %>");
</script>