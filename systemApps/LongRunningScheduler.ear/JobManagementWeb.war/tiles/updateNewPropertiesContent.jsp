<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils" errorPage="/errors/error.jsp" %>
<%@ page language="java" import="java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="jsdForm"   name="JobScheduleDetailForm" type="com.ibm.ws.batch.jobmanagement.web.forms.JobScheduleDetailForm"/>
<bean:define id="requestId" name="JobScheduleDetailForm" property="jobScheduleRequestId" type="java.lang.String"/>
<bean:define id="submitBy"  name="JobScheduleDetailForm" property="submitBy"             type="java.lang.String"/>
<bean:define id="xjclPath"  name="JobScheduleDetailForm" property="xjclPath"             type="java.lang.String"/>
<bean:define id="jobName"   name="JobScheduleDetailForm" property="jobName"              type="java.lang.String"/>
<bean:define id="props"     name="JobScheduleDetailForm" property="props"                type="java.util.HashMap"/>

<% 
   String job = submitBy.equals("local") ? xjclPath : jobName;
%>

  <tr>
    <td>
    <p class="instruction-text">
    <bean:message key="CWLJM2342I" arg0="<%=job%>"/>
    </p>
    <form name="JobScheduleDetailForm" method="post" action="/jmc/viewJobSchedules.do" ENCTYPE="multipart/form-data">
    <table border="0" cellpadding="5" cellspacing="0" width="90%" class="framing-table" role="presentation">
      <tbody>
<% if (props.size() > 1) { %>
        <tr>
          <td class="table-text" valign="top">
            <P style="margin-top:0em; margin-left: 0.5em; margin-right: 0.5em;">
              <div STYLE="overflow: auto; height: 250; margin-left: 1.5em;margin-right: 1em;" >
              <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" CLASS="framing-table" id="subProps">
                <TR>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="30%">
                  <bean:message key="propName"/>
                  </TH>
                  <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="40%">
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
                    <img id="requiredImage-show-<%= key %>" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="informationRequired"/>" title="<bean:message key="informationRequired"/>">
<% } else { %>
                    <img id="requiredImage-blank-<%= key %>" src="images/blank5.gif" width="8" height="8" align="absmiddle" alt="">
<% } %>
                    <%= key %>
                  </TD>
	              <TD VALIGN="top"  class="collection-table-text" headers="property">
                    <input type="text" title="property.<%= key %>" name="property.<%= key %>" size="50" value="<%= propValue == null || propValue.length() < 1 ? "": propValue %>" class="noIndentTextEntry" style="margin-left: 0.1em;" id="property.<%= key %>">
                  </TD>
                </TR>
                </logic:iterate>
              </TABLE>
              </div>
            </P>
          </td>
        </tr>
<% } %>
        <tr>
          <td class="navigation-button-section" VALIGN="top">
            &nbsp;<br>
            <input type="hidden" name="refId" value="<%=requestId%>" id="refId">
            <input type="submit" name="button.update.properties" value="<bean:message key="button.ok"/>" class="buttons" id="button.update.properties" style="margin-left: -0.5em;">
            <input type="submit" name="button.cancel" value="<bean:message key="job.schedule.action.cancel"/>" class="buttons" id="button.cancel">
          </td>
        </tr>
	    </tbody>
    </table>
    </form>

    </td>
  </tr>

<!--  script>
enableDisable(<%= submitBy.equals("local") ? "'xjclFile'" : "'specifyJobName'" %>);
enableDisableSelectJob();
</script -->