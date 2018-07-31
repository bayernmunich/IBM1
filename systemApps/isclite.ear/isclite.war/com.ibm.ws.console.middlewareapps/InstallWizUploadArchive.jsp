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

<%-- <tiles:useAttribute name="titleKey" classname="java.lang.String"/>
<tiles:useAttribute name="descKey" classname="java.lang.String"/>
<tiles:useAttribute name="actionHandler" classname="java.lang.String"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String"/>
<tiles:useAttribute name="formType" classname="java.lang.String"/> --%>

<%-- <ibmcommon:setPluginInformation pluginIdentifier="com.ibm.ws.console.middlewareapps" pluginContextRoot=""/>
<ibmcommon:detectLocale/> --%>

<script language="JavaScript" src="/ibm/console/scripts/menu_functions.js"></script>

<script>
    function fileLocalFileValue(thisvalue) {
        thisvalue.form.fileName.value = thisvalue.form.localFilePath.value.toString();
        return true;
    }
</script>

<html:hidden property="fileName" value=""/>

<table border="0" cellpadding="3" cellspacing="0" width="100%" summary="List Table">
    <tr valign="top">
        <td class="table-text" nowrap>

            <%-- Need to Handle 'Previous'. --%>

            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_localFile" class="collectionLabel" title="<bean:message key="appinstall.upload.localpath"/>">
                            <%-- <html:radio property="uploadModeSelection" styleId="update_localFile" value="localFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')"/> --%>
                            <input type="radio" name="uploadModeSelection" value="localFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')" id="update_localFile" checked="checked">
                            <bean:message key="Upload.path.local"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="update_localFilePath" title="<bean:message key="appinstall.upload.localpath"/>">
                            <bean:message key="Upload.path.specify.fullpath"/><br>
                            <html:file property="localFilePath" styleId="update_localFilePath" size="30" styleClass="fileUpload" onchange="return fileLocalFileValue(this)" onblur="return fileLocalFileValue(this)"/>
                        </label>
                    </td>
                </tr>

                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_remoteFile" CLASS="collectionLabel" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <%-- <html:radio property="uploadModeSelection" styleId="update_remoteFile" value="remoteFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')" /> --%>
                            <input type="radio" name="uploadModeSelection" value="remoteFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')" id="update_remoteFile">
                            <bean:message key="Upload.path.remote"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="update_remoteFilePath" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <bean:message key="Upload.path.specify.fullpath"/><br>
                            <html:text property="remoteFilePath" styleId="update_remoteFilePath" size="60" styleClass="fileUpload"/>
                            <script>bidiComplexField("update_remoteFilePath", "FILEPATH");</script>
                        </label>
                        <label for="update_remoteFileBrowse">
                            <html:submit property="installAction" styleClass="buttons" styleId="update_remoteFileBrowse">
                                <bean:message key="appmanagement.button.browse"/>
                            </html:submit>
                        </label>
                    </td>
                </tr>

                <script>
                    enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse');
                </script>

            </table>

        </td>
    </tr>
</table>
