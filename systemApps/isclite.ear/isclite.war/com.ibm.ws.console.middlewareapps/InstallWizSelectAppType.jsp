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

<%-- <bean:define id="appTypeList" name="<%=actionForm%>" property="appTypeList" type="java.util.ArrayList"/> --%>

<%--
<%
    String descImage = "pluginId=com.ibm.ws.console.middlewareapps";
    String image = "";
    String pluginId = "";
    String pluginRoot = "";

    if (descImage != "") {
        int index = descImage.indexOf("pluginId=");
        if (index >= 0) {
            pluginId = descImage.substring(index + 9);
            if (index != 0) {
                descImage = descImage.substring(0, index);
            } else {
                descImage = "";
            }
        } else {
            index = descImage.indexOf("pluginContextRoot=");
            if (index >= 0) {
                pluginRoot = descImage.substring(index + 18);
                if (index != 0) {
                    descImage = descImage.substring(0, index);
                } else {
                    descImage = "";
                }
            }
        }
    }
%>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>
--%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List Table">
    <tbody>
        <tr valign="top">
            <td class="table-text" scope="row">
                <span class="requiredField">
                    <label for="selectedAppType" title="<bean:message key="middlewareapps.apptype.description"/>">
                        <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>"/>
                        <bean:message key="middlewareapps.apptype.displayName"/>
                    </label>
                </span>
                <br/>

                <html:select property="selectedAppType" styleId="applicationType">
                <logic:iterate id="appType" name="<%=actionForm%>" property="appTypeList" type="java.lang.String">
                <%-- <logic:iterate id="appType" name="appTypeList" type="java.lang.String"> --%>
                    <html:option value="<%=appType%>">
                        <bean:message key="<%=appType%>"/>
                    </html:option>
                </logic:iterate>
                </html:select>
            </td>
        </tr>
    </tbody>
</table>
