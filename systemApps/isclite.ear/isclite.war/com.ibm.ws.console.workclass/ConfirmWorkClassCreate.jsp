<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<bean:define id="name" name="<%=actionForm%>" property="name" type="java.lang.String" />
<bean:define id="modMatchesText" name="<%=actionForm%>" property="modMatchesText" type="java.lang.String" />

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">

  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left"> 
          <bean:message key="workclass.confirm.msg1"/>
          <bean:message key="workclass.confirm.msg2"/>  
	  </td>
  </tr>
</table>
	  
<table border="0" cellpadding="3" cellspacing="1" width="100%" class="framing-table">
   <tr> 
      <th class="column-head-name" scope="col">
          <bean:message key="workclass.confirm.msg3"/>
	  </th>
   </tr>
   <tr> 
      <td class="table-text"  valign="top">
      <% if ((modMatchesText.length() == 0)) { %>
	        <bean:message key="workclass.confirm.msg.min" arg0="<%=name%>" />
	  <% }
         else { %>
	        <bean:message key="workclass.confirm.msg.members" arg0="<%=name%>" arg1="<%=modMatchesText%>"/>
	  <% } %>
	  </td>
   </tr>
   
</table>
