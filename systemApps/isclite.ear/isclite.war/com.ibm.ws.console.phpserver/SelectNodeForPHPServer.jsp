<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.appmanagement.*, com.ibm.ws.console.phpserver.*, com.ibm.ws.console.appmanagement.form.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<table border="0" cellpadding="3" cellspacing="1" width="100%">
  <tr valign="baseline" >
      <td class="wizard-step" id="current" headers="header1" width="99%" align="left"> 
          <bean:message key="phpserver.selectPHPServer.msg1"/>
      </td>
  </tr>
</table> 
	  
<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
  <tr valign="top"> 
          <td class="table-text" nowrap width="25%">
		      <label  for="selectedNode" TITLE="<bean:message key="phpserver.selectPHPServer.msg5"/>"><bean:message key="appserver.selectAppServer.msg3"/></label>
                <BR>
                <html:select property="selectedNode" size="1" styleId="selectedNode">
                   <logic:iterate id="node" name="<%=actionForm%>" property="nodePath">
<%
String value = (String) node;
value=value.trim();

if (!value.equals("")) {
%>
        <html:option value="<%=value%>"><%=value%></html:option>
<% } else { %>
        <html:option value="<%=value%>"><bean:message key="<none.text"/></html:option>
<%  } %>
			      </logic:iterate>
                </html:select>   
          </td>
     </tr>
     <tr valign="top"> 
          <td class="table-text" nowrap>
          
              <span class="requiredField">
                <label  for="serverName" title='<bean:message key="phpserver.selectPHPServer.msg6"/>'>
                <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                <bean:message key="appserver.selectAppServer.serverName"/>
                </label>
              </span>
                <BR>        
                <html:text property="serverName" styleClass="textEntryRequired" size="30" styleId="serverName"/>
		  </td>
     </tr>
</table>
