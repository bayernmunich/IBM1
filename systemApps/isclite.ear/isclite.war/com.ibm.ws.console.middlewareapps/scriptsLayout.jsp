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

<tiles:useAttribute name="actionHandler" classname="java.lang.String"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String"/>
<tiles:useAttribute name="formType" classname="java.lang.String"/>
<tiles:useAttribute name="showButtons" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showOkButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showApplyButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showCancelButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showResetButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="helpTopic" classname="java.lang.String"/>
<tiles:useAttribute name="pluginId" classname="java.lang.String"/>

<% request.setAttribute("fieldHelp", helpTopic); %>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot=""/>
<ibmcommon:info image="help.additional.information.image" topic="<%=helpTopic%>"/>

<script>
    function setRemoteFileType(typeValue) {
        typeValue.form.remoteFileType.value = typeValue;
    }
</script>

<html:form action="<%=actionHandler%>" name="<%=actionForm%>" type="<%=formType%>" enctype="multipart/form-data">

<html:hidden property="remoteFileType" value=""/>

<table border="0" cellpadding="3" cellspacing="0" width="100%" role="presentation">
    <tr valign="top">
        <td class="table-text" nowrap>

            <table width="100%" border="0" cellspacing="3" cellpadding="3" role="presentation">
                <tr valign="baseline">
                    <bean:message key="middlewareapps.detail.scripts.current"/><br/>
                </tr>
                <tr valign="baseline">
                    <td class="complex-property" nowrap>
                        <label for="setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/>:<br/>
                            <html:text property="setupScript" styleId="setupScript" readonly="true" styleClass="fileUpload"/>
                            <script>bidiComplexField("setupScript", "FILEPATH");</script>
                        </label>
                    </td>
                </tr>
                <tr valign="baseline">
                    <td class="complex-property" nowrap>
                        <label for="cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/>:<br/>
                            <html:text property="cleanUpScript" styleId="cleanUpScript" readonly="true" styleClass="fileUpload"/>
                            <script>bidiComplexField("cleanUpScript", "FILEPATH");</script>
                        </label>
                    </td>
                </tr>
            </table>

        </td>
    </tr>

    <tr valign="top">
        <td class="table-text" nowrap>

		<fieldset style="border:0px; padding:0pt; margin: 0pt;">
			<legend class="hidden"><bean:message key="middlewareapps.detail.scripts.file.system"/></legend>
            <table width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
                <tr valign="baseline">
                    <bean:message key="middlewareapps.detail.scripts.new"/><br/>
                </tr>
                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_localFile" class="collectionLabel" title="<bean:message key="appinstall.upload.localpath"/>">
                            <input type="radio" name="uploadModeSelection" value="localFile" onclick="enableDisable('update_localFile:local_setupScript:local_cleanUpScript,update_remoteFile:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_localFile" checked="checked">
                            <bean:message key="Upload.path.local"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="local_setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/><br/>
                            <html:file property="setupScriptFile" styleId="local_setupScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="local_cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/><br/>
                            <html:file property="cleanUpScriptFile" styleId="local_cleanUpScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>

                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_remoteFile" CLASS="collectionLabel" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <input type="radio" name="uploadModeSelection" value="remoteFile" onclick="enableDisable('update_localFile:local_setupScript:local_cleanUpScript,update_remoteFile:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_remoteFile">
                            <bean:message key="Upload.path.remote"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="remote_setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/><br/>
                            <html:text property="remoteSetupScriptPath" styleId="remote_setupScript" size="60" styleClass="fileUpload"/>
                        </label>
                        <html:submit property="installAction" styleClass="buttons special" styleId="update_remoteSetupScriptBrowse" onclick="setRemoteFileType('remoteSetupScript')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:submit>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="remote_cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/><br/>
                            <html:text property="remoteCleanUpScriptPath" styleId="remote_cleanUpScript" size="60" styleClass="fileUpload"/>
                        </label>
                        <html:submit property="installAction" styleClass="buttons special" styleId="update_remoteCleanUpScriptBrowse" onclick="setRemoteFileType('remoteCleanUpScript')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:submit>
                    </td>
                </tr>

                <script>
                    enableDisable('update_localFile:local_setupScript:local_cleanUpScript,update_remoteFile:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse');
                </script>
            </table>
		</fieldset>
        </td>
    </tr>

<%
    if (showButtons!=null && showButtons.equalsIgnoreCase("yes")) {
%>
    <tr>
        <td class="navigation-button-section" nowrap VALIGN="top">

            <% if (showApplyButton != null && showApplyButton.equals("yes")) { %>
            <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation">
            <% } %>

            <% if (showOkButton != null && showOkButton.equals("yes")) { %>
            <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons_navigation">
            <% } %>

            <% if (showResetButton != null && showResetButton.equals("yes")) { %>
            <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation">
            <% } %>

            <% if (showCancelButton != null && showCancelButton.equals("yes")) { %>
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
            <% } %>

        </td>
    </tr>
<%
    }
%>
</table>

</html:form>
