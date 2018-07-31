<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006,2013 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.appdeployment.*,com.ibm.ws.console.appmanagement.*,com.ibm.websphere.models.config.appdeployment.*,com.ibm.ws.console.core.*,com.ibm.ws.console.core.form.*,com.ibm.ws.console.core.mbean.*,javax.management.*,org.apache.struts.util.MessageResources,org.apache.struts.action.Action,org.eclipse.emf.common.util.*,org.eclipse.emf.ecore.resource.ResourceSet,com.ibm.ws.console.middlewareapps.*,com.ibm.ws.console.middlewareapps.form.*,java.util.*" %>
<%@ page errorPage="/error.jsp" %>

<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<ibmcommon:detectLocale/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">

<%
    String pageTitle;
    String titlePage;
    String msg1;

    String[] bcnamesT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };         
    ServletContext servletContext = (ServletContext)pageContext.getServletContext();
    MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);

    // String whichForm = (String) session.getAttribute(com.ibm.ws.console.appmanagement.Constants.APPMANAGEMENT_LAST_PAGE);
    // if (whichForm.equals("applicationDeploymentCollection")) {
        titlePage = "appmgmt.uninstallapp.title";
        pageTitle = messages.getMessage(request.getLocale(), "button.uninstall");
        msg1 = "appmgmt.uninstallapp.page.msg1";
	// } else {
    //    titlePage="appmgmt.removemodule.title";
    //    pageTitle = messages.getMessage(request.getLocale(),"appmanagement.button.remove");
    //     msg1 = "appmgmt.removemodule.page.msg1";
	// }

    // AbstractCollectionForm collectionForm = (AbstractCollectionForm) session.getAttribute("com.ibm.ws.console.appmanagement.removeCollection");
    AbstractCollectionForm collectionForm = (AbstractCollectionForm) session.getAttribute("com.ibm.ws.console.middlewareapps.removeCollection");

    /*
    if (session.getAttribute("bcnames") != null)  {
        bcnamesT = (String[])session.getAttribute("bcnames");
        pageTitle = bcnamesT[0];
    }
    */
%>

<HEAD>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<TITLE><bean:message key="<%=titlePage%>"/></TITLE>

<jsp:include page="/secure/layouts/browser_detection.jsp" flush="true"/>

<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>

</HEAD>
                                  
<jsp:include page="/secure/layouts/content_accessibility.jsp" flush="true"/>

<body CLASS="content">

  <TABLE WIDTH="97%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage" role="banner">
    <TR>
        <TD CLASS="pageTitle"><%=pageTitle%>
        </TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"> <bean:message key="portal.close.page"/></A>
        </TD>        
    </TR>
  </TABLE>
  
  <TABLE WIDTH="97%" CELLPADDING="2" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="main">
  <TR>
    <td class="wpsPortletTitle"><b><bean:message key="<%=titlePage%>"/></b></td>
    <td class="wpsPortletTitleControls">
    <A href="javascript:showHidePortlet('wasUniPortlet')">
    <img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt"/>" border="0" align="texttop"/>
    </A>
    </td>
  </TR>

  <TR> 
  <TD CLASS="wpsPortletArea" COLSPAN="2" ID="wasUniPortlet">
 
    <a name="important"></a>
    <ibmcommon:errors/> 

<html:form action="middlewareappsRemoveSplat.do" name="MiddlewareAppsRemoveSplatForm" type="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsRemoveSplatForm">
<p class="description-text">
<bean:message key="<%=msg1%>"/>  
<p/>

        <table id="serverTable" border="0" cellpadding="2" cellspacing="0" valign="top" width="50%" role="presentation" > 
                <tr> 
                   <td valign="bottom" align="left" width="100%" nowrap>                             
                            <table border="0" cellpadding="2" cellspacing="1" width="100%" summary="List table" class="framing-table">
                                <tr> 
                                    <th class="column-head-name" scope="col" nowrap>
                                        <bean:message key="middlewareapps.displayName"/>
                                    </th>
                                </tr>
<% 
        // if (whichForm.equals("applicationDeploymentCollection")) {
            MiddlewareAppsDetailForm selectedDetailForm = null;
            String selectedObjectIds[] = collectionForm.getSelectedObjectIds();

            List contents = collectionForm.getContents();
            for (int i = 0;  ((collectionForm.getSelectedObjectIds() != null) && (i < collectionForm.getSelectedObjectIds().length)); i++) {
                Iterator iter = contents.iterator();
                while (iter.hasNext()) {
                    selectedDetailForm = (MiddlewareAppsDetailForm) iter.next();
                    if (selectedDetailForm.getUniqueId().equals(selectedObjectIds[i])) {

                // String module = collectionForm.getSelectedObjectIds()[i].substring(collectionForm.getSelectedObjectIds()[i].lastIndexOf("/") + 1);
%>
                                    <tr CLASS="table-row"> 
                                        <td CLASS="collection-table-text">
                                        <%=selectedDetailForm.getName()%>&nbsp;<%=selectedDetailForm.getEditionAlias()%>
                                        <%-- =module --%>
                                        </td>
                                    </tr>
<%
                    }
                }
            }
        // }
%>
                                
                            </table>
                    </td>
            </tr>
    <TR><TD>
            <TABLE width="100%" cellpadding="6" cellspacing="0" role="presentation">
              <tr>
                <td class="wizard-button-section" COLSPAN="2" ALIGN="center">
                    <input type="submit" name="appmanagement.button.confirm.ok" value="<bean:message key="button.ok"/>" class="buttons_navigation">
                    <input type="submit" name="appmanagement.button.confirm.cancel" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
                </td>
              </tr>
            </TABLE>            
        </TD>
 </TR>
 </TABLE>

</html:form>

</BODY>

</html:html>
