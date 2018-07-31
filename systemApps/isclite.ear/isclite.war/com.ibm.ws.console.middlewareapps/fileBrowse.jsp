<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.websphere.management.fileservice.*,com.ibm.ws.console.core.form.*, com.ibm.ws.console.core.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action" %>

<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String"/>
<% request.setAttribute("contextType", contextType); %>

<tiles:useAttribute name="titleKey" classname="java.lang.String"/>
<tiles:useAttribute name="descKey" classname="java.lang.String"/>

<ibmcommon:detectLocale/>

<html:html locale="true">

<%
    String[] bcnamesT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };
    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
    MessageResources messages = (MessageResources) servletContext.getAttribute(Action.MESSAGES_KEY);
    String pageTitle = messages.getMessage(request.getLocale(), titleKey);
    if (session.getAttribute("bcnames") != null)  {
        bcnamesT = (String[]) session.getAttribute("bcnames");
        pageTitle = bcnamesT[0];
    }

    String encoding = response.getCharacterEncoding();
    if (encoding == null) {
        encoding = "UTF-8";
    }
    
    String typeKey = (String) session.getAttribute("typeKey");
%>



<HEAD>

<jsp:include page="/secure/layouts/browser_detection.jsp" flush="true"/>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

</HEAD>

<BODY>

    <TABLE WIDTH="97%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage">
    <TR>
        <TD CLASS="pageTitle"><%=pageTitle%></TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"><bean:message key="portal.close.page"/></A></TD>
    </TR>
    </TABLE>

    <TABLE WIDTH="97%" CELLPADDING="2" CELLSPACING="0" BORDER="0" CLASS="wasPortlet">
    <TR>
        <TH class="wpsPortletTitle" width="100%"><bean:message key="<%=titleKey%>"/></TH>
        <TH class="wpsPortletTitleControls">
            <A href="javascript:showHidePortlet('wasUniPortlet')">
            <img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="show/hide portlet" border="0" align="texttop"/>
            </A>
        </TH>
        <TH class="wpsPortletTitleControls">
            <A href="#" TARGET="HelpWindow">
            <img id="wasUniPortletHelp" SRC="<%=request.getContextPath()%>/images/title_help.gif" alt="View page help" border="0" align="texttop"/>
            </A>
        </TH>
    </TR>

    <TBODY ID="wasUniPortlet">
    <TR>
    <TD CLASS="wpsPortletArea" COLSPAN="3" >

    <a name="important"></a> 
    <ibmcommon:errors/>


<html:form action="extendedBrowseRemoteNodes.do" name="MiddlewareAppsRemoteBrowseForm" type="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsRemoteBrowseForm">

<p class="instruction-text"><bean:message key="<%=descKey%>"/></p>

<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" SUMMARY="List Table" CLASS="framing-table">
    <tr>
    <td class="column-head-name" colspan="2">
        <img src="images/onepix.gif" width="1" height="16">
        <bean:message key="browse.contents"/>&nbsp;<bean:write name="MiddlewareAppsRemoteBrowseForm" property="selectedItem"/>
    </td>
    </tr>

<bean:define id="thisForm" name="MiddlewareAppsRemoteBrowseForm" type="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsRemoteBrowseForm"/>
<bean:define id="parentList" name="MiddlewareAppsRemoteBrowseForm" property="parentDir" type="java.util.ArrayList"/>
<%
    String parentDir = (String) parentList.get(1); 
    String link = "extendedBrowseRemoteNodes.do?parentName=" + URLEncoder.encode(ConfigFileHelper.urlEncode(parentDir), encoding);
    if (parentDir.equals("cellContext")) {
        link = "extendedBrowseRemoteNodes.do?nodeName=";
    } else if (parentDir.equals("nodeContext")) {
        parentDir = thisForm.getNode();
        link = "extendedBrowseRemoteNodes.do?nodeName=" + URLEncoder.encode(ConfigFileHelper.urlEncode(parentDir), encoding);
    }
%>

    <tr class="table-row">
    <td class="collection-table-text">
        <DIV CLASS="indent1">
        <img src="images/parent_dir.gif" align="absmiddle" border="0">&nbsp;<a href="<%=link%>">parentDir</a>
        </DIV>
    </td>
    </tr>

<%
    RemoteFile[] remoteFiles = thisForm.getRemoteFiles();
    for (int i = 0; i < remoteFiles.length; i++) {
        RemoteFile remoteFile = remoteFiles[i];
        // System.out.println(remoteFile.dump());

        String fileName = remoteFile.getName();
        String filePath = remoteFile.getPath();
        if (remoteFile.isRoot()) {
            fileName = remoteFile.getAbsolutePath();
        }

        if (remoteFile.isDirectory()) {
            link = "extendedBrowseRemoteNodes.do?remoteFileName=" + URLEncoder.encode(ConfigFileHelper.urlEncode(filePath), encoding);
%>

		    <tr class="table-row">
		    <td class="collection-table-text">
		        <DIV CLASS="indent2">
		        <img src="images/closed_folder.gif" align="absmiddle" border="0">&nbsp;<a href="<%=link%>"><%=(String) fileName%></a>
		        </DIV>
		    </td>
		    </tr>

<%
        } else {
            String foo = filePath + ":" + fileName;
            String fileType = remoteFile.getType();
%>                            
			
		    <%-- Types of Ext for the Type of Applications. --%>
		    <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="fileExt" value="middlewareApps">

			<%--=foo %>
			<%=fileType --%>
<%
	
            // Check for Valid Extension; Display only Supported Types
            //if (fileType.equals(RemoteFile.NORMAL_FILE)) {
            String thePath = remoteFile.getAbsolutePath().toLowerCase();
                
            if (typeKey.equals("middlewareapps.type.wasce")) {
                
            	if (thePath.endsWith(".car") || thePath.endsWith(".rar") || thePath.endsWith(".ear") || thePath.endsWith(".war") || thePath.endsWith(".jar"))
	            {
			%>
					<tr class="table-row">
					<td class="collection-table-text" width="1%">
					    <label class="collectionLabel">
					    <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="single">
					        <html:radio property="fileRadio" value="<%=(String) foo%>" />
					    </logic:equal>
					    <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="multi">
					        <html:checkbox property="checkBox" value="<%=(String) foo%>" />
					    </logic:equal>
					    <img src="images/file.gif" align="absmiddle" border="0">&nbsp;<%=(String) fileName%>
					    </label>
					</td>
					</tr>
		
			<%
	        	}
            } else {
            // Check for Valid Extension; Display only Supported Types
            
                if (thePath.endsWith(".zip") || thePath.endsWith(".tar") || thePath.endsWith(".tar.gz") || thePath.endsWith(".tgz") ||
                    thePath.endsWith(".jar"))
                {
		%>
		
				    <tr class="table-row">
				    <td class="collection-table-text" width="1%">
				        <label class="collectionLabel">
				        <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="single">
				            <html:radio property="fileRadio" value="<%=(String) foo%>" />
				        </logic:equal>
				        <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="multi">
				            <html:checkbox property="checkBox" value="<%=(String) foo%>" />
				        </logic:equal>
				        <img src="images/file.gif" align="absmiddle" border="0">&nbsp;<%=(String) fileName%>
				        </label>
				    </td>
				    </tr>
		
		<%
		        }
		    }
		
		%>

    		</logic:equal>
    		
		    <logic:notEqual name="MiddlewareAppsRemoteBrowseForm" property="fileExt" value="middlewareApps">
		
		    <tr class="table-row">
		    <td class="collection-table-text" width="1%">
		        <label class="collectionLabel">
		        <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="single">
		            <html:radio property="fileRadio" value="<%=(String) foo%>" />
		        </logic:equal>
		        <logic:equal name="MiddlewareAppsRemoteBrowseForm" property="select" value="multi">
		            <html:checkbox property="checkBox" value="<%=(String) foo%>" />
		        </logic:equal>
		        <img src="images/file.gif" align="absmiddle" border="0">&nbsp;<%=(String) fileName%>
		        </label>
		    </td>
		    </tr>
		
		    </logic:notEqual>

<%
        	}
        }	
%>

    <tr class="table-row">
    <td class="file-button-section" colspan="2">
        <html:submit property="okAction" styleId="functions" styleClass="buttons">
            <bean:message key="button.ok"/>
        </html:submit>
        <html:cancel property="cancelAction" styleId="functions" styleClass="buttons">
            <bean:message key="button.cancel"/>
        </html:cancel>
    </td>
    </tr>

</TABLE>

</html:form>


    </TD>
    </TR>
    </TBODY>
    </TABLE>

</BODY>

</html:html>
