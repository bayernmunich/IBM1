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
<title><bean:message key="<%=titleKey%>"/></title>
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

<html:form action="<%=actionHandler%>" name="<%=actionForm%>" type="<%=formType%>">

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
<table border="0" cellpadding="3" cellspacing="0" width="100%" role="presentation">
    <tbody>
        <tr valign="top">
            <td class="table-text">
                <span class="requiredField">
                    <label for="selectedAppType" title="<bean:message key="middlewareapps.apptype.description"/>">
                        <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>"/>
                        <bean:message key="middlewareapps.apptype.displayName"/>
                    </label>
                </span>
                <br/>

                <html:select property="selectedAppType" styleId="selectedAppType">
                <logic:iterate id="appType" name="<%=actionForm%>" property="appTypeList" type="java.lang.String">
                    <html:option value="<%=appType%>">
                        <bean:message key="<%=appType%>"/>
                    </html:option>
                </logic:iterate>
                </html:select>
            </td>
        </tr>
    </tbody>

    <tr valign="top">
    <td>
        <table width="100%" cellpadding="3" cellspacing="0">
            <tr>
                <td class="button-section" colspan="2" align="center">
                <%-- <html:submit property="nextAction" styleId="nextAction" styleClass="buttons"> --%>
                <html:submit property="installAction" styleId="nextAction" styleClass="buttons special">
                    <bean:message key="appmanagement.button.next"/>
                </html:submit>

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
