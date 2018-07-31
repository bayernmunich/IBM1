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
<%@ page import="com.ibm.ws.console.middlewareapps.util.MiddlewareAppsUtil"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>
<bean:define id="edition" name="<%=actionForm%>" property="edition" type="java.lang.String"/>
<%
	String defaultEditionAlias = MiddlewareAppsUtil.DEFAULT_EDITION_NAME;

%>
<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
    <tr>
        <td class="table-text">
            <span class="requiredField">
                <label for="name" title='<bean:message key="middlewareapps.detail.name.description"/>'>
                    <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                    <bean:message key="middlewareapps.detail.name"/>
                </label>
            </span>
            <br/>
            <html:text property="name" size="25" styleClass="textEntryRequired" styleId="name"/>
        </td>
    </tr>

    <tr>
        <td class="table-text">
            <span class="requiredField">
                <label for="edition" title='<bean:message key="middlewareapps.detail.edition.description"/>'>
                    <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                    <bean:message key="middlewareapps.detail.edition"/>
                </label>
            </span>
            <br/>

            <% if(edition.equals("")){ %>
				<%-- Should use MiddlewareAppUtils.DEFAULT_EDITION_NAME. --%>
            	<html:text property="edition" size="25" styleClass="textEntryRequired" styleId="edition" value="<%=defaultEditionAlias%>"/>
            <% }else{ %>
				<html:text property="edition" size="25" styleClass="textEntryRequired" styleId="edition"/>            	            
            <% } %>
        </td>
    </tr>

    <tr>
        <td class="table-text">
            <label for="editionDesc" title='<bean:message key="middlewareapps.detail.editionDesc.description"/>'>
                <bean:message key="middlewareapps.detail.editionDesc"/>
            </label>
            <br/>
            <html:text property="editionDesc" size="25" styleClass="textEntry" styleId="editionDesc"/>
        </td>
    </tr>
</table>
