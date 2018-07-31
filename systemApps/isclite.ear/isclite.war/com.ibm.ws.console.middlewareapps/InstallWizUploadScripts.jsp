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

<table border="0" cellpadding="3" cellspacing="0" width="100%" summary="List Table">
    <tr valign="top" class="instruction-text">
        <bean:message key="middlewareapps.wizard.steps.upload.scripts.description"/>
    </tr>
    <tr><td>&nbsp;&nbsp;&nbsp;</td></tr>
    <tr valign="top">
        <td class="table-text" nowrap>

            <table width="100%" border="0" cellspacing="3" cellpadding="3">
                <tr valign="baseline">
                    <td class="complex-property" nowrap>
                        <label for="setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/>:<br/>
                            <html:file property="setupScriptFile" styleId="setupScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>
                <tr valign="baseline">
                    <td class="complex-property" nowrap>
                        <label for="cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/>:<br/>
                            <html:file property="cleanUpScriptFile" styleId="cleanUpScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>
            </table>

        </td>
    </tr>
</table>
