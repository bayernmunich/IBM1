<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.*" %>
<%@ page import="com.ibm.wsspi.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.InstallMiddlewareAppForm" %>

<%@ page import="org.apache.struts.action.Action" %>
<%@ page import="org.apache.struts.util.MessageResources" %>

<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="titleKey" classname="java.lang.String"/>
<tiles:useAttribute name="descKey" classname="java.lang.String"/>
<tiles:useAttribute name="actionHandler" classname="java.lang.String"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String"/>
<tiles:useAttribute name="formType" classname="java.lang.String"/>
<tiles:useAttribute name="helpTopic" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="pluginId" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="contextType" classname="java.lang.String" id="contextType"/>

<% request.setAttribute("contextType", contextType); %>

<%
    // Console for IIR: Needed for Federation.
    Boolean iscFed = (Boolean) request.getSession().getAttribute(WSCDefines.WSC_ISC_LAUNCHED_TASK);
    if (iscFed == null) {
        iscFed = new Boolean(false);
    }

    Boolean isPortletFed = (Boolean) request.getSession().getAttribute(WSCDefines.PORTLET_COMPATIBLE);
    if (isPortletFed == null) {
        isPortletFed = new Boolean(false);
    }
%>

<ibmcommon:detectLocale/>

<%
    String fieldLevelHelpTopic = null;
    String DETAILFORM = "DetailForm";
    String COLLECTIONFORM = "CollectionForm";
    String APPINSTALLFORM = "AppInstallForm";
    String FORM = "Form";
    String objectType = "";
    String helpPluginId = "";

    if (helpTopic != null && helpTopic.length() > 0 && pluginId != null && pluginId.length() > 0) {
        fieldLevelHelpTopic = helpTopic;
        helpPluginId = pluginId; 
    } else {
        if (formType != null && formType.length() > 0) {
            int index = formType.lastIndexOf('.');
            if (index > 0) {
                String fType = formType.substring(index + 1);
                if (fType.endsWith(DETAILFORM)) {
                    objectType = fType.substring(0, fType.length() - DETAILFORM.length());
                    fieldLevelHelpTopic = objectType + ".detail";
                } else if (fType.endsWith(COLLECTIONFORM)) {
                    objectType = fType.substring(0, fType.length() - COLLECTIONFORM.length());
                    fieldLevelHelpTopic = objectType + ".collection";
                } else if (fType.equals(APPINSTALLFORM)) {
                    objectType = actionForm.substring(0, actionForm.length() - FORM.length());
                    fieldLevelHelpTopic = "appmanagement." + objectType;
                    request.setAttribute("fieldHelp", fieldLevelHelpTopic);
                    helpPluginId = "com.ibm.ws.console.appmanagement";
                } else if (fType.endsWith(FORM)) {
                    objectType = fType.substring(0, fType.length() - FORM.length());
                    fieldLevelHelpTopic = objectType;
                } else {
                    fieldLevelHelpTopic = fType;
                }
            } else {
                fieldLevelHelpTopic = formType;
            }
        } else {
            fieldLevelHelpTopic = "";
        }
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">

<HEAD>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<%@ include file="/secure/layouts/browser_detection.jsp" %>

<SCRIPT LANGUAGE="JavaScript" SRC="/ibm/console/scripts/menu_functions.js"></SCRIPT>
<title><bean:message key="<%=titleKey%>" /></title>
</HEAD>

<BODY CLASS="content" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" role="main">

<%
    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
    MessageResources messages = (MessageResources) servletContext.getAttribute(Action.MESSAGES_KEY);
    String pageTitle = messages.getMessage(request.getLocale(), titleKey);
    if (session.getAttribute("bcnames") != null) {
        String[] bcnamesT = (String[]) session.getAttribute("bcnames");
        pageTitle = bcnamesT[0];
        String[] bclinksT = (String[]) session.getAttribute("bclinks");
        int oldlen = 0;

        for (int counter1 = 0; counter1 < bclinksT.length; counter1++) {
            if (bclinksT[counter1].equals("")) {
                oldlen = counter1;
                break;
            }
        }

        String priorpage = request.getHeader("Referer");
        if (priorpage == null) {
            priorpage = "";
        }
        if (oldlen == 0) {
            oldlen = 1;
        }                           
        if (priorpage.indexOf("forwardName=") > 0) {
            if ((bclinksT[oldlen-1].indexOf("forwardName=") < 0) && (bclinksT[oldlen-1].indexOf("EditAction=true") < 0)) {
                bclinksT[oldlen-1] = priorpage;
                session.setAttribute("bclinks", bclinksT);
            }
        }
    }
%>

<html:form action="<%=actionHandler%>" name="<%=actionForm%>" type="<%=formType%>" enctype="multipart/form-data">

<%
    // WSC: Needed for Federation
    if (iscFed.booleanValue() == false && isPortletFed.booleanValue() == false) {
%>
    <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" CLASS="portalPage" role="banner">
        <TR>
            <TD CLASS="pageTitle">
                <%-- <%=pageTitle%> --%>
                <bean:message key="nav.middlewareapps.label"/>
            </TD>
            <TD CLASS="pageClose">
                <A HREF="<%=request.getContextPath()%>/navigation.do?wpageid=com.ibm.isclite.welcomeportlet.layoutElement.A&moduleRef=com.ibm.isclite.ISCAdminPortlet"><bean:message key="portal.close.page"/></A>
            </TD>
        </TR>
    </TABLE> 
<%
    }
%>

<TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" role="presentation">
    <TR>
    <TD VALIGN="top">

    <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="presentation">
        <TR>
            <td CLASS="wpsPortletTitle" WIDTH="100%"><b><bean:message key="<%=titleKey%>"/></b></td>

            <% if (!fieldLevelHelpTopic.equals("") && !helpPluginId.equals("")) { %>
            <td CLASS="wpsPortletTitleControls">
                <% request.setAttribute("fieldHelp", fieldLevelHelpTopic);  %>
                <ibmcommon:setPluginInformation pluginIdentifier="<%=helpPluginId%>" pluginContextRoot=""/>
                <ibmcommon:info image="help.additional.information.image" topic="<%=fieldLevelHelpTopic%>"/>
            </td>
            <% } %>

            <td CLASS="wpsPortletTitleControls">
                <A HREF="javascript:showHidePortlet('wasUniPortlet')">
                <IMG ID="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" ALT="<bean:message key="wsc.expand.collapse.alt"/>" BORDER="0" ALIGN="texttop"/>
                </A>    
            </td>
        </TR>

        <TBODY ID="wasUniPortlet">

        <TR>
        <TD CLASS="wpsPortletArea" COLSPAN="3">

        <A NAME="important"></A>
        <ibmcommon:errors/>

        <P CLASS="instruction-text">
            <bean:message key="<%=descKey%>"/>
        </P>


<%-- Actual Content --%>
<script>
    function fileLocalFileValue(thisvalue) {
        thisvalue.form.fileName.value = thisvalue.form.localFilePath.value.toString();
        return true;
    }

    function setRemoteFileType(filetype, typeValue) {
        filetype.form.remoteFileType.value = typeValue;
        window.location = encodeURI("/ibm/console/InstallWizUpload.do?installAction=Browse" + "&remoteFileType=" + typeValue
			 + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
    }
</script>

<%
    InstallMiddlewareAppForm theForm = (InstallMiddlewareAppForm) session.getAttribute(actionForm);
    boolean remoteUpload = false;
    String typeKey = null;
    typeKey = theForm.getTypeKey();
	session.setAttribute("typeKey", typeKey);
    if (theForm.getUploadModeSelection().equals("remoteFile")) {
        remoteUpload = true;
    }
	
%>

<html:hidden property="fileName" value=""/>
<html:hidden property="remoteFileType" value=""/>

<table border="0" cellpadding="3" cellspacing="0" width="100%" role="presentation">
    <tr valign="top">
        <td class="table-text" nowrap>

		<fieldset style="border:0px; padding:0pt; margin: 0pt;">
			<legend class="hidden"><bean:message key="middlewareapps.wizard.upload.mode.description"/></legend>

            <table width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
            
            	<%-- the local upload --%>
                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_localFile" class="collectionLabel" title="<bean:message key="appinstall.upload.localpath"/>">
                            <%-- <html:radio property="uploadModeSelection" styleId="update_localFile" value="localFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')"/> --%>
                            <% if (remoteUpload) { %>
                                <input type="radio" name="uploadModeSelection" value="localFile" onclick="enableDisable('update_localFile:update_localFilePath:update_exdeployPlan:local_setupScript:local_cleanUpScript,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse:update_remoteExdeployPlanPath:update_remoteExdeployFileBrowse:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_localFile">
                            <% } else { %>
                                <input type="radio" name="uploadModeSelection" value="localFile" onclick="enableDisable('update_localFile:update_localFilePath:update_exdeployPlan:local_setupScript:local_cleanUpScript,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse:update_remoteExdeployPlanPath:update_remoteExdeployFileBrowse:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_localFile" checked="checked">
                            <% } %>
                            <bean:message key="Upload.path.local"/>
                        </label>
                    </td>
                </tr>
                
                <%-- upload the local file --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="update_localFilePath" title="<bean:message key="appinstall.upload.localpath"/>">
                        	<% if(typeKey.equals("middlewareapps.type.wasce")) { %>
                            	<bean:message key="Upload.path.wasce.specify.fullpath"/>
                            <% } else { %>
                            	<bean:message key="Upload.path.specify.fullpath"/>
                            <% } %>
                        </label><br/>
                        <html:file property="localFilePath" styleId="update_localFilePath" size="30" styleClass="fileUpload" onchange="return fileLocalFileValue(this)" onblur="return fileLocalFileValue(this)"/>
                        
                    </td>
                </tr>
                
			<% if(typeKey.equals("middlewareapps.type.wasce")) { %>
                <%-- upload Extenral Deployment plan from local file system --%>
                <tr>
                	<td class="complex-property" nowrap>
                		<label for="update_exdeployPlan" title="<bean:message key="appinstall.upload.localpath"/>">
                            <bean:message key="Upload.path.wasce.exdeploy.fullpath"/>
                        </label><br/>
                        <html:file property="exdeployPlanFile" styleId="update_exdeployPlan" size="30" styleClass="fileUpload"/>
                        
                	</td>
                </tr>
                
			<% } else { %>
       			
       			<%-- upload the setup script file --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="local_setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/><br/>
                            <html:file property="setupScriptFile" styleId="local_setupScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>
                
                <%-- upload the clean up script file --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="local_cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/><br/>
                            <html:file property="cleanUpScriptFile" styleId="local_cleanUpScript" size="30" styleClass="fileUpload"/>
                        </label>
                    </td>
                </tr>
                
			<% } %>


				<%-- the remote update, need to copy the remote file to local, and tell the system where to find it --%>
                <tr valign="baseline">
                    <td class="table-text">
                        <label for="update_remoteFile" CLASS="collectionLabel" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <%-- <html:radio property="uploadModeSelection" styleId="update_remoteFile" value="remoteFile" onclick="enableDisable('update_localFile:update_localFilePath,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse')" /> --%>
                            <% if (remoteUpload) { %>
                                <input type="radio" name="uploadModeSelection" value="remoteFile" onclick="enableDisable('update_localFile:update_localFilePath:update_exdeployPlan:local_setupScript:local_cleanUpScript,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse:update_remoteExdeployPlanPath:update_remoteExdeployFileBrowse:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_remoteFile" checked="checked">
                            <% } else { %>
                                <input type="radio" name="uploadModeSelection" value="remoteFile" onclick="enableDisable('update_localFile:update_localFilePath:update_exdeployPlan:local_setupScript:local_cleanUpScript,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse:update_remoteExdeployPlanPath:update_remoteExdeployFileBrowse:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse')" id="update_remoteFile">
                            <% } %>
                            <bean:message key="Upload.path.remote"/>
                        </label>
                    </td>
                </tr>
                
                <%-- upload the remote file --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="update_remoteFilePath" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <% if(typeKey.equals("middlewareapps.type.wasce")) { %>
                            <bean:message key="Upload.path.wasce.specify.fullpath"/>
                            <% } else { %>
                            <bean:message key="Upload.path.specify.fullpath"/>
                            <% } %>
                        </label><br/>
                        <html:text property="remoteFilePath" styleId="update_remoteFilePath" size="60" styleClass="fileUpload"/>
                        <script>bidiComplexField("update_remoteFilePath", "FILEPATH");</script>
                        
                        <html:button property="installAction" styleClass="buttons special" styleId="update_remoteFileBrowse" onclick="setRemoteFileType(this,'remoteArchive')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:button>
                    </td>
                </tr>
                
			<% if(typeKey.equals("middlewareapps.type.wasce")) { %>
                
                <%-- upload remoste external deployment plan file --%>
                <tr>
                	<td class="complex-property" nowrap>
                        <label for="update_remoteExdeployPlanPath" title="<bean:message key="appinstall.upload.serverpath"/>">
                            <bean:message key="Upload.path.wasce.exdeploy.fullpath"/>
                        </label><br/>
                        <html:text property="remoteExdeployPlanPath" styleId="update_remoteExdeployPlanPath" size="60" styleClass="fileUpload"/>
                        <script>bidiComplexField("update_remoteExdeployPlanPath", "FILEPATH");</script>
                        
                        <html:button property="installAction" styleClass="buttons special" styleId="update_remoteExdeployFileBrowse" onclick="setRemoteFileType(this,'remoteExdeployPlan')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:button>
                    </td>
                </tr>
                
			<% } else { %>
                
                <%-- upload the remote setup script --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="remote_setupScript" title="<bean:message key="middlewareapps.scripts.setup"/>">
                            <bean:message key="middlewareapps.scripts.setup"/><br/>
                            <html:text property="remoteSetupScriptPath" styleId="remote_setupScript" size="60" styleClass="fileUpload"/>
                            <script>bidiComplexField("remote_setupScript", "FILEPATH");</script>
                        </label>
                        <html:button property="installAction" styleClass="buttons special" styleId="update_remoteSetupScriptBrowse" onclick="setRemoteFileType(this,'remoteSetupScript')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:button>
                    </td>
                </tr>
                
                <%-- upload the remote clean up script --%>
                <tr>
                    <td class="complex-property" nowrap>
                        <label for="remote_cleanUpScript" title="<bean:message key="middlewareapps.scripts.clean"/>">
                            <bean:message key="middlewareapps.scripts.clean"/><br/>
                            <html:text property="remoteCleanUpScriptPath" styleId="remote_cleanUpScript" size="60" styleClass="fileUpload"/>
                            <script>bidiComplexField("remote_cleanUpScript", "FILEPATH");</script>
                        </label>
                        <html:button property="installAction" styleClass="buttons special" styleId="update_remoteCleanUpScriptBrowse" onclick="setRemoteFileType(this,'remoteCleanUpScript')">
                            <bean:message key="appmanagement.button.browse"/>
                        </html:button>
                    </td>
                </tr>
			<% } %>
			
                <script>
                    enableDisable('update_localFile:update_localFilePath:update_exdeployPlan:local_setupScript:local_cleanUpScript,update_remoteFile:update_remoteFilePath:update_remoteFileBrowse:update_remoteExdeployPlanPath:update_remoteExdeployFileBrowse:remote_setupScript:update_remoteSetupScriptBrowse:remote_cleanUpScript:update_remoteCleanUpScriptBrowse');
                </script>
            </table>
		</fieldset>
        </td>
    </tr>

    <tr valign="top">
    <td>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr>
                <td class="button-section" colspan="2" align="center">
                
                <%-- the "next" button --%>
                <%-- <html:submit property="nextAction" styleId="nextAction" styleClass="buttons"> --%>
                <html:submit property="installAction" styleId="nextAction" styleClass="buttons special">
                    <bean:message key="appmanagement.button.next"/>
                </html:submit>
				
				<%-- the "cancel" button --%>
                <%-- <html:cancel property="cancelAction" styleId="cancelAction" styleClass="buttons"> --%>
                <html:cancel property="installAction" styleId="cancelAction" styleClass="buttons special">
                    <bean:message key="appmanagement.button.cancel"/>
                </html:cancel>
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
<%-- End Actual Content --%>

        </TD>
        </TR>

        </TBODY>    
    </TABLE>
    
    </TD>

    <%@ include file="/com.ibm.ws.console.middlewareapps/helpPortlet.jspf" %>
    </TR>
</TABLE>

</html:form>

</BODY>

</html:html>
