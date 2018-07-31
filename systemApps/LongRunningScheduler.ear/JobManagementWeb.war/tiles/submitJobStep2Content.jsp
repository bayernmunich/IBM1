<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.jobmanagement.web.forms.NewJobForm" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="njForm"      name="NewJobForm" type="com.ibm.ws.batch.jobmanagement.web.forms.NewJobForm"/>
<bean:define id="submitBy"    name="NewJobForm" property="submitBy"    type="java.lang.String"/>
<bean:define id="xjclPath"    name="NewJobForm" property="xjclPath"    type="java.lang.String"/>
<bean:define id="jobName"     name="NewJobForm" property="jobName"     type="java.lang.String"/>
<bean:define id="props"       name="NewJobForm" property="props"  type="java.util.HashMap"/>

<form name="NewJobForm" method="post" action="/jmc/submitJob.do?action=execute" id="NewJobForm" ENCTYPE="multipart/form-data">
  <tr>
    <td>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="90%" role="presentation">
      <tr valign="top">
        <td>
          <p class="instruction-text">
<% 
   String job = submitBy.equals("local") ? xjclPath : jobName;
   if (props.size() > 0) { %>
          <bean:message key="CWLJM2340I" arg0="<%=job%>"/>
          </p>
          <br>
          <div STYLE="overflow: auto; height: 250; margin-left: 1.5em;margin-right: 1em;" >
          <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" CLASS="framing-table">
            <TR>
              <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="30%">
              <bean:message key="propName"/>
              </TH>
              <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="40%">
              <bean:message key="propValue"/>
              </TH>
            </TR>
            <logic:iterate id="key" name="NewJobForm" property="propsKeys" type="java.lang.String">
<%
              String propValue = (String) props.get(key);
              propValue = JMCUtils.convertToCharset(propValue, response.getCharacterEncoding());
%>
            <TR CLASS="table-row">
              <TD VALIGN="top"  class="collection-table-text" headers="property">
<% if (njForm.isRequiredProp(key)) { %>
                <img id="requiredImage-<%= key %>" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<% } else { %>
                <img id="requiredImage-<%= key %>" src="images/blank5.gif" width="8" height="8" align="absmiddle" alt="">
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
<% } else { %>
          <bean:message key="CWLJM2341I" arg0="<%=job%>"/>
          </p>
<% } %>
        </td>
      </tr>
      <tr>
        <td>
        <br>&nbsp;
        <input type="hidden" name="currentStep"         value="specify.properties">
        <input type="submit" name="button.submit"       value="<bean:message key="button.ok"/>"         class="buttons" id="button.submit" style="margin-left: 0.5em;">
        <input type="submit" name="button.specify.job"  value="<bean:message key="job.action.cancel"/>" class="buttons" id="button.specify.job">
        </td>
      </tr>
    </table>
    </td>
  </tr>
</form>
