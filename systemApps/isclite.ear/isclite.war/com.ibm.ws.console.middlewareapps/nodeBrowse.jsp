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

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="framing-table">

        <table border="0" cellpadding="0" cellspacing="0" width="100%" summary="List Framing Table">
        <tbody>
        <tr>
            <td class="framing-table">

            <table cols=2 width="100%" cellpadding="3" cellspacing="1">
                <tr>
                    <td class="column-head-name" colspan="2">
                        <img src="images/onepix.gif" width="1" height="16">
                        <bean:message key="browse.contents"/>&nbsp;<bean:write name="MiddlewareAppsRemoteBrowseForm" property="selectedItem"/>
                    </td>
                </tr>

                <logic:iterate id="node" name="MiddlewareAppsRemoteBrowseForm" property="nodesList">
                <% String link = "extendedBrowseRemoteNodes.do?nodeName=" + URLEncoder.encode(ConfigFileHelper.urlEncode((String)node), encoding);%>
                <tr>
                    <td class="table-text">
                        <img src="images/closed_folder.gif" width="16" height="16" align="absmiddle" border="0">
                        &nbsp;
                        <a href="<%=link%>"><%=(String) node%></a>
                    </td>
                </tr>
                </logic:iterate>

		        <tr class="table-row">
                    <td class="file-button-section" colspan="2">
                        <html:submit property="okAction" styleId="functions" styleClass="buttons" disabled="true">
                            <bean:message key="button.ok"/>
                        </html:submit>
                        <html:cancel property="cancelAction" styleId="functions" styleClass="buttons">
                            <bean:message key="button.cancel"/>
                        </html:cancel>
                    </td>
                </tr>
            </table>

            </td>
        </tr>
        </tbody> 
        </table>

        </td>
    </tr>
</table>

</html:form>


    </TD>
    </TR>
    </TBODY>
    </TABLE>

</BODY>

</html:html>
