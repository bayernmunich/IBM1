<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*"%>

<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="summary" name="<%=actionForm%>" property="summary" type="java.util.ArrayList"/>

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
  <tr>
      <td class="table-text"  nowrap valign="top" scope="row">
          <LABEL TITLE="<bean:message key="wizard.summary.label.alt"/>">
          	<bean:message key="wizard.summary.label"/><bean:message key="dynamiccluster.showmestepslayout.token"/>
          </LABEL>
      </td>
  </tr>
</table>

<table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
  <tr>
    <th class="column-head-name" scope="col"> <bean:message key="appinstall.summary.options"/></th>
    <th class="column-head-name" scope="col"><bean:message key="appinstall.summary.values"/></th>
  </tr>

<%
  String key="";
  String value="";

  Iterator i = summary.iterator();
  while (i.hasNext()) {
    key = (String) i.next();
    if (i.hasNext()) {
      value = (String) i.next();
    }

    if (key == "" && value == "") {
        // Place a dummy entry in the table to separate the cluster members
%>
        <tr></tr>
<%
    } else {
        // Add the entry to the table
%>
        <tr CLASS="table-row">
            <td class="collection-table-text"><%= key%> </td>
            <td class="collection-table-text"><%= value%> </td>
        </tr>
<%
    }
%>
<%
  }
%>
</table>
