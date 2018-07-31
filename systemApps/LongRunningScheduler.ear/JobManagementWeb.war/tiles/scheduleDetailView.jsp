<%@ page import="com.ibm.ws.batch.jobmanagement.web.forms.JobScheduleDetailForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils" errorPage="/errors/error.jsp" %>
<%@ page language="java" import="java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ include file="/tiles/tileFieldDefs.jsp" %>

<bean:define id="jsdForm"     name="JobScheduleDetailForm" type="com.ibm.ws.batch.jobmanagement.web.forms.JobScheduleDetailForm"/>
<bean:define id="requestId"   name="JobScheduleDetailForm" property="jobScheduleRequestId" type="java.lang.String"/>
<bean:define id="submitter"   name="JobScheduleDetailForm" property="jobScheduleSubmitter" type="java.lang.String"/>
<bean:define id="startDate"   name="JobScheduleDetailForm" property="startDate"            type="java.lang.String"/>
<bean:define id="startTime"   name="JobScheduleDetailForm" property="startTime"            type="java.lang.String"/>
<bean:define id="interval"    name="JobScheduleDetailForm" property="interval"             type="java.lang.String"/>
<bean:define id="updateJob"   name="JobScheduleDetailForm" property="updateJob"            type="java.lang.String"/>
<bean:define id="submitBy"    name="JobScheduleDetailForm" property="submitBy"             type="java.lang.String"/>
<bean:define id="jobName"     name="JobScheduleDetailForm" property="jobName"              type="java.lang.String"/>
<bean:define id="props"       name="JobScheduleDetailForm" property="props"                type="java.util.HashMap"/>

<%
    String ridLink = JMCUtils.urlEncode(requestId);
    requestId = JMCUtils.convertToCharset(requestId, response.getCharacterEncoding());
    jobName   = JMCUtils.convertToCharset(jobName, response.getCharacterEncoding());
%>

  <tr>
    <td>
    <form name="JobScheduleDetailForm" method="post" action="/jmc/viewJobSchedules.do" ENCTYPE="multipart/form-data">
    <table border="0" cellspacing="0" width=100% role="presentation">
      <tr>
        <td width=50% valign="top"  >
        <table border="0" cellpadding="5" cellspacing="0" class="framing-table" role="presentation">
          <tbody>
            <tr  valign="top" >
              <td class="table-text" valign="top" colspan=2 width=10% >
              <h2><bean:message key="jobScheduleDetailViewTitle"/></h2>
              </td>
            </tr>
            <tr  valign="top">
              <td class="table-text" valign="top">
              <label><bean:message key="jobScheduleRequestId"/>:</label>
              </td>
              <td class="table-text"><%=requestId%></td>
            </tr>
            <tr  valign="top">
              <td class="table-text"  valign="top">
              <label><bean:message key="jobScheduleSubmitter"/>:</label>
              </td>
              <td class="table-text"><%=submitter == null || submitter.length() < 1 ? "&nbsp;" : submitter%></td>
            </tr>
            <tr valign="top">
              <td class="table-text"  valign="top" colspan=2>
              <tiles:insert beanName="date.field">
                <tiles:put name="startDate"  value="<%=startDate%>" />
                <tiles:put name="disabled"   value="" />
                <tiles:put name="required"   value="true" />
                <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
              </tiles:insert>
              </td>
            </tr>
            <tr valign="top">
              <td class="table-text"  valign="top" colspan=2>
              <tiles:insert beanName="time.field">
                <tiles:put name="startTime"  value="<%=startTime%>" />
                <tiles:put name="disabled"   value="" />
                <tiles:put name="required"   value="true" />
                <tiles:put name="labelStyle" value="style=\"margin-left: 0.0em;\"" />
              </tiles:insert>
              </td>
            </tr>
            <tr>
              <td class="table-text" valign="top" colspan=2>
              <img id="requiredImage-interval" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
              <label style="margin-left: 0.0em;" for="interval" title="<bean:message key="interval"/>"><bean:message key="interval"/>:</label><br>
              <select id="interval" name="interval" class="textEntry" style="margin-left: 0.6em;" >
                <option value="daily"   <%= interval.equals("daily")   ? "selected=\"selected\"" : "" %>><bean:message key="daily"/></option>
                <option value="weekly"  <%= interval.equals("weekly")  ? "selected=\"selected\"" : "" %>><bean:message key="weekly"/></option>
                <option value="monthly" <%= interval.equals("monthly") ? "selected=\"selected\"" : "" %>><bean:message key="monthly"/></option>
              </select>
              </td>
            </tr>
	      </tbody>
        </table>
        </td>
        <td>
        <table border="0" cellpadding="5" cellspacing="0" class="framing-table" role="presentation">
          <tbody>
            <tr valign="top">
              <td class="table-text" valign="top" colspan=2>
              <h2><bean:message key="scheduleJob"/></h2>
              </td>
            </tr>
            <tr  valign="top">
              <td class="table-text" valign="top" width=35%>
              <label><bean:message key="jobToRun"/>:</label>
              </td>
              <td class="table-text"><a href="/jmc/viewJobSchedules.do?forward.viewJob=viewJob&refId=<%=ridLink%>"><%=requestId%></a></td>
            </tr>
<% if (props.size() > 1) { %>
            <tr>
              <td class="table-text" valign="top" colspan=2>
              <label><bean:message key="jobScheduleNameValuePairs"/>:</label><br>
              <div STYLE="overflow: auto; height: 150; margin-left: 1.0em;margin-right: 1em; ">
              <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" CLASS="framing-table" WIDTH="95%" id="subProps">
                <TR>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="30%">
                  <bean:message key="propName"/>
                  </TH>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="50%">
                  <bean:message key="propValue"/>
                  </TH>
                </TR>
                <logic:iterate id="key" name="JobScheduleDetailForm" property="propsKeys" type="java.lang.String">
<%
                String propValue = (String) props.get(key);
                propValue = JMCUtils.convertToCharset(propValue, response.getCharacterEncoding());
%>
                <TR CLASS="table-row">
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
<% if (jsdForm.isRequiredProp(key)) { %>
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
              </td>
            </tr>
<% } %>
            <tr>
              <td class="table-text"  valign="top" colspan=2>
              <br>
              <label for="updateJob" title="<bean:message key="updateJob"/>">
              <input type="checkbox" name="updateJob" value="on" id="updateJob" <%=updateJob.equals("true") ? "checked" : "" %> style="margin-left: -0.2em;" onclick="javascript:enableDisableSelectJob();">
              <bean:message key="updateJob"/>
              </label><br><br>
			    <fieldset style="border: 0px; margin: 0px; padding: 0px">
					<legend class="hidden"><bean:message key="job.definition"/></legend>
              <table id="selectJob" width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
                <tr valign="baseline">
                  <td class="table-text">
                  <label CLASS="collectionLabel" for="submitByLFS" title="<bean:message key="localFileSystem"/>">
                  <input type="radio" name="submitBy" value="local" <%=submitBy.equals("local") ? "checked" : "" %> onclick="enableDisable('xjclFile')" id="submitByLFS" style="margin-left: 0.6em;">
                  <bean:message key="localFileSystem"/>
                  </label>
                  </td>
                </tr>
                <tr>
                  <td class="complex-property" nowrap>
                  <img id="requiredImage-path" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>" style="margin-left: 0.6em;">
                  <label style="margin-left: 0.0em;" for="xjclFile" title="<bean:message key="specifyPath"/>"><bean:message key="specifyPath"/></label><br>
                  <input type="file"   name="xjclFile" size="50" value="" class="fileUpload" id="xjclFile" style="margin-left: 0.6em;">
                  </td>
                </tr>
                <tr valign="baseline">
                  <td class="table-text">
                  <label CLASS="collectionLabel" for="submitByJR" title="<bean:message key="jobRepository"/>">
                  <input type="radio" name="submitBy" value="job.repository" <%=submitBy.equals("local") ? "" : "checked" %> onclick="enableDisable('specifyJobName')" id="submitByJR" style="margin-left: 0.6em;">
                  <bean:message key="jobRepository"/>
                  </label>
                  </td>
                </tr>
                <tr>
                  <td class="complex-property" nowrap>
                  <img id="requiredImage-name" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>" style="margin-left: 0.6em;">
                  <bean:message key="specifyJobName"/><br>
                  <input type="text"   title="<bean:message key="specifyJobName"/>" name="jobName" size="25" value="<%=submitBy.equals("local") ? "" : jobName%>" class="noIndentTextEntry" style="margin-left: 0.6em;" id="jobName">
                  <input type="submit" name="button.browse" value="<bean:message key="button.browse"/>" class="buttons" id="button.browse" style="font-size:85.0%;"/>
                  </td>
                </tr>
              </table>
			  </fieldset>
              </td>
            </tr>
	      </tbody>
        </table>
        </td>
      </tr>
      <tr>
        <td class="navigation-button-section" VALIGN="top" colspan=2>
        &nbsp;<br>
        <input type="hidden" name="refId" value="<%=requestId%>" id="refId">
        <input type="submit" name="button.apply"  value="<bean:message key="button.apply"/>" class="buttons" id="button.apply" style="margin-left: -0.5em;">
        <input type="submit" name="button.update" value="<bean:message key="button.ok"/>" class="buttons" id="button.update">
        <input type="reset"  name="button.reset"  value="<bean:message key="button.reset"/>" class="buttons" id="button.reset">
        <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="job.schedule.action.cancel"/>" class="buttons" id="button.back">
        </td>
      </tr>
    </table>
    </form>

    </td>
  </tr>

<script>
enableDisable(<%= submitBy.equals("local") ? "'xjclFile'" : "'specifyJobName'" %>);
enableDisableSelectJob();
</script>