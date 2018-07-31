<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>

<bean:define id="appName" name="<%=actionForm%>" property="name" type="java.lang.String"/>
<bean:define id="appType" name="<%=actionForm%>" property="type" type="java.lang.String"/>
<bean:define id="edition" name="<%=actionForm%>" property="edition" type="java.lang.String"/>
<bean:define id="editionDesc" name="<%=actionForm%>" property="editionDesc" type="java.lang.String"/>
<bean:define id="setupScript" name="<%=actionForm%>" property="setupScript" type="java.lang.String"/>
<bean:define id="cleanUpScript" name="<%=actionForm%>" property="cleanUpScript" type="java.lang.String"/>
<bean:define id="moduleName" name="<%=actionForm%>" property="moduleName" type="java.lang.String"/>
<bean:define id="contextRoot" name="<%=actionForm%>" property="contextRoot" type="java.lang.String"/>
<bean:define id="virtualHost" name="<%=actionForm%>" property="virtualHost" type="java.lang.String"/>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List Table">
    <tr valign="baseline">
        <td class="wizard-step-text" width="100%" align="left">
            <bean:message key="middlewareapps.confirm.description"/>
        </td>
    </tr>
</table>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List Table" class="framing-table">
    <tr>
        <th class="column-head-name" scope="col">
            <bean:message key="middlewareapps.confirm.summary"/>
        </th>
    </tr>
    <tr>
        <td class="table-text" valign="top">
            <bean:message key="middlewareapps.detail.name"/>=<%=appName%>
            <br/>
            <bean:message key="middlewareapps.detail.type"/>=<%=appType%>
            <br/>
            <bean:message key="middlewareapps.detail.edition"/>=<%=edition%>
            <br/>
            <bean:message key="middlewareapps.detail.editionDesc"/>=<%=editionDesc%>
            <br/>
            <bean:message key="middlewareapps.scripts.setup"/>=<%=setupScript%>
            <br/>
            <bean:message key="middlewareapps.scripts.clean"/>=<%=cleanUpScript%>
            <br/>
            <bean:message key="middlewareapps.deploy.moduleName"/>=<%=moduleName%>
            <br/>
            <bean:message key="middlewareapps.deploy.contextRoot"/>=<%=contextRoot%>
            <br/>
            <bean:message key="middlewareapps.deploy.virtualHost"/>=<%=virtualHost%>
            <br/>
            <bean:message key="middlewareapps.deploy.deploymentTargets"/>=
            <logic:iterate id="deploymentTarget" name="<%=actionForm%>" property="deploymentTargets">
                <%=(String) deploymentTarget%>;
            </logic:iterate>
        </td>
    </tr>
</table>
