<%@ page import="com.ibm.ws.batch.security.BatchSecurity" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<bean:define id="xjclPath" name="NewJobForm" property="xjclPath" type="java.lang.String"/>
<bean:define id="jobName"  name="NewJobForm" property="jobName"  type="java.lang.String"/>

<bean:define id="auditString" name="NewJobForm" property="auditString"  type="java.lang.String"/>

<%
  boolean isAuditStringRequired = false;
  if(BatchSecurity.getAuditStringValidator() != null)
	isAuditStringRequired = true;
%>

<form name="NewJobForm" method="post" action="/jmc/saveJob.do?action=execute" id="NewJobForm" ENCTYPE="multipart/form-data">
  <tr>
    <td>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="90%">
      <tr valign="top">
        <td class="table-text" nowrap>
        <table width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
          <tr>
            <td class="complex-property" nowrap>
            <img id="requiredImage-jobname" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
            <label for="saveJobName" title="<bean:message key="job.name"/>" style="margin-left: 0.0em;"><bean:message key="job.name"/>:</LABEL><br>
            <input type="text" name="saveJobName" size="25" value=""  class="noIndentTextEntry" id="saveJobName" style="margin-left: 0.6em;">
            </td>
          </tr>
          <tr>
            <td class="complex-property" nowrap>
            <img id="requiredImage-xjclpath" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
            <label for="xjclFile" title="<bean:message key="xjclPath"/>" style="margin-left: 0.0em;"><bean:message key="xjclPath"/>:</label><br>
            <input type="file" name="xjclFile" size="50" value="<%=xjclPath%>" class="fileUpload" id="xjclFile" style="margin-left: 0.6em;">
            </td>
          </tr>
		  		  <tr>
            <td class="complex-property" nowrap>
<%
		if(isAuditStringRequired)
		{
%>
            <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<%
		}
%>
            <label for="auditString" title="<bean:message key="audit.string"/>" style="margin-left: 0.0em;"><bean:message key="audit.string"/>:</label><br>
            <input type="text" name="auditString" size="50" value="" class="noIndentTextEntry" id="auditString" style="margin-left: 0.6em;">
            </td>
          </tr>
          <tr valign="top">
            <td  class="table-text">
            </td>
          </tr>
          <tr>
            <td  class="table-text">
            <label for="replaceJob" title="<bean:message key="replaceJob"/>">
              <input type="checkbox" name="replaceJob" value="false" style="margin-left: 1.5em;" id="replaceJob">
              <bean:message key="replaceJob"/>
            </label>
            </td>
          </tr>
          <tr>
            <td class="navigation-button-section" VALIGN="top">
            <br>&nbsp;
            <input type="submit" name="button.save"  value="<bean:message key="button.save"/>"  class="buttons" id="button.save" style="margin-left: 0.5em;">
            <input type="reset"  name="button.reset" value="<bean:message key="button.reset"/>" class="buttons" id="button.reset">
            </td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</form>
