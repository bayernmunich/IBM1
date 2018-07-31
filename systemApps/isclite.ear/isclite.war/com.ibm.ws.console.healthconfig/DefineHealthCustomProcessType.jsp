<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.appmanagement.*, com.ibm.ws.console.healthconfig.*, com.ibm.ws.console.healthconfig.form.*, com.ibm.ws.console.healthconfig.util.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="selectedHealthCustomActionType" name="<%=actionForm%>" property="selectedHealthCustomActionType" type="java.lang.String" />


<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
  <tr valign="top">
   <td class="table-text"  scope="row" valign="top">
    <% if (selectedHealthCustomActionType.equalsIgnoreCase(HealthUtils.JAVA_SERVER_OP)) {
    %>
          <tiles:insert definition="healthclass.customAction.wizard.JavaProcDef" flush="false">
          </tiles:insert>
    <% } else {
    %>
          <tiles:insert definition="healthclass.customAction.wizard.ProcDef" flush="false">
          </tiles:insert>
    <% }
    %>
   </td>
  </tr>
</table>
