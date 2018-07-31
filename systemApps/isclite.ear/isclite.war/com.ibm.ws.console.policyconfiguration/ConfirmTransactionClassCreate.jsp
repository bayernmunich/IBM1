<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ page language="java" import="com.ibm.ws.console.policyconfiguration.form.CreateServiceClassStep1Form"%>
<%@ page language="java" import="com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<bean:define id="name" name="<%=actionForm%>" property="name" type="java.lang.String" />
<bean:define id="description" name="<%=actionForm%>" property="description" type="java.lang.String" />
<bean:define id="selectedURIsText" name="<%=actionForm%>" property="selectedURIsText" type="java.lang.String" />

<%
	String nextStep = (String) session.getAttribute("nextAction");
	String attribute = "";
	String spName = "";
	if (nextStep.equals("success"))
		attribute = "ServiceClassDetailForm";
	else
		attribute = "CreateServiceClassStep3Form";

	ServiceClassDetailForm detailForm = (ServiceClassDetailForm) session.getAttribute(attribute);
	spName = detailForm.getName();
%>
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">

  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left"> 
          <bean:message key="transactionclass.confirm.msg1"  arg0="<%=spName%>"/>
          <bean:message key="transactionclass.confirm.msg2"/>  
	  </td>
  </tr>
</table>
	  
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
   <tr> 
      <th class="column-head-name" scope="col">
          <bean:message key="transactionclass.confirm.msg3"/>
	  </th>
   </tr>
   <tr> 
      <td class="table-text"  valign="top">
      <% if ((description.length()== 0) && (selectedURIsText.length() == 0)) { %>
	        <bean:message key="transactionclass.confirm.msg.min" arg0="<%=name%>" />
	  <% }
         else if ((description.length()== 0) && (selectedURIsText.length() > 0)) { %>
	        <bean:message key="transactionclass.confirm.msg.members" arg0="<%=name%>" arg1="<%=selectedURIsText%>"/>
	  <% }
         else if ((description.length()> 0) && (selectedURIsText.length() == 0)) { %>
	        <bean:message key="transactionclass.confirm.msg.desc" arg0="<%=name%>" arg1="<%=description%>"/>
	  <% }
	     else {%>
	        <bean:message key="transactionclass.confirm.msg4" arg0="<%=name%>" arg1="<%=description%>" arg2="<%=selectedURIsText%>"/>
	  <% } %>
	  </td>
   </tr>
   
</table>
