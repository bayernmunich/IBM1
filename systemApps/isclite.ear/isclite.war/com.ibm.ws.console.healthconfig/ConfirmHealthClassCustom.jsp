<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.healthconfig.*, com.ibm.ws.console.healthconfig.form.*,  com.ibm.ws.console.healthconfig.util.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="selectedHealthCustomActionType" name="<%=actionForm%>" property="selectedHealthCustomActionType" type="java.lang.String" />
<bean:define id="name" name="<%=actionForm%>" property="name" type="java.lang.String" />
<bean:define id="executableName" name="<%=actionForm%>" property="executableName" type="java.lang.String" />
	
<%  
String confirmMessage = "healthclass.customAction.wizard.confirm.msg3";
if (request.getAttribute("confirmMessage")!=null) {
    confirmMessage = (String) request.getAttribute("confirmMessage");
}
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left">
          <bean:message key="healthclass.customAction.wizard.confirm.msg1"/>
          <bean:message key="healthclass.customAction.wizard.confirm.msg2"/>
	  </td>
  </tr>
</table>

<br>

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
    <tr valign="top">
        <td class="table-text"  nowrap valign="top" scope="row">
            <label title='<bean:message key="wizard.summary.label.alt"/>'>
                <bean:message key="wizard.summary.label"/>:
            </label>
            <br>
            <p class="textEntryReadOnlyLong" name="summary" style="min-height:5em">
                <bean:message key="<%=confirmMessage%>" arg0="<%=name%>" arg1="<%=executableName%>"/>
            </p>
        </td>
    </tr>
</table>
