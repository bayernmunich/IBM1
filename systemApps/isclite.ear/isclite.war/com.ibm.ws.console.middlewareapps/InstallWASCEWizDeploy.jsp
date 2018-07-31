<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%-- This page is dealing with the Deploy Application to the Server/Cluster target--%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>


<table border="0" cellpadding="3" cellspacing="0" width="100%" role="presentation">
    <tr valign="top">
    	<td>
        	<span class="instruction-text"><bean:message key="middlewareapps.wizard.steps.options.deploy.description"/></span>
       	</td>
    </tr>
    <tr valign="top">
        <td class="table-text"nowrap>
            
            <tiles:insert page="/com.ibm.ws.console.middlewareapps/deploymentPropertiesWASCEAppLayout.jsp" flush="true">
                <tiles:put name="actionForm" value="<%=actionForm%>"/>
            </tiles:insert>

        </td>
    </tr>
</table>
