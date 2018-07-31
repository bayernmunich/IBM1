<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.form.*,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.*,com.ibm.ws.console.core.mbean.*,javax.management.*,com.ibm.ws.console.distmanagement.topology.*,com.ibm.ws.console.core.form.*,com.ibm.websphere.models.config.topology.cluster.*,org.eclipse.emf.ecore.resource.*,com.ibm.ws.console.core.mbean.*"%>
<%@ page language="java" import="org.eclipse.emf.common.util.*"%>
<%@ page language="java" import="org.eclipse.emf.common.util.*"%>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page errorPage="/error.jsp" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<ibmcommon:detectLocale/>

<html:html locale="true">


<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">


<%
     String currFormName = (String) session.getAttribute(Constants.CURRENT_FORMTYPE);
    if (currFormName.equals("com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm") ) {
%>
       <TITLE><bean:message key="deletecluster.page.title"/></TITLE>
<%

     } else {
%>
       <TITLE><bean:message key="deleteserver.page.title"/></TITLE>
<%
     }
%>




<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>


<SCRIPT LANGUAGE="javascript" SRC="scripts/menu_functions.js"></script>
</head>

<body CLASS="content" >

<jsp:include page="/secure/layouts/content_accessibility.jsp" flush="true"/>


<%
        String[] bcnamesT = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" };
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String pageTitle = messages.getMessage(request.getLocale(),"button.delete");
        if (session.getAttribute("bcnames") != null)  {
                bcnamesT = (String[])session.getAttribute("bcnames");
                pageTitle = bcnamesT[0];
        }
%>


  <TABLE WIDTH="97%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage">
    <TR>
        <TD CLASS="pageTitle"><%=pageTitle%>
        </TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"><bean:message key="portal.close.page"/></A>
        </TD>
    </TR>
  </TABLE>



  <TABLE WIDTH="97%" CELLPADDING="2" CELLSPACING="0" BORDER="0" CLASS="wasPortlet">
  <TR>
    <TH class="wpsPortletTitle"><bean:message key="button.delete"/></TH>
    <TH class="wpsPortletTitleControls">
    <A href="javascript:showHidePortlet('wasUniPortlet')">
    <img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt"/>" border="0" align="texttop"/>
    </A>
    </TH>
  </TR>
  </TABLE>


  <TABLE WIDTH="97%" CELLPADDING="8" CELLSPACING="0" BORDER="0" CLASS="wasPortlet">
  <TR>
  <TD CLASS="wpsPortletArea" COLSPAN="2" ID="wasUniPortlet">


<%
	AbstractCollectionForm collectionForm = null;

    String currForm = (String) session.getAttribute(Constants.CURRENT_FORMTYPE);

	String actionString = null;
    String nameString = null;
    String typeString = null;

    if (currForm.equals("com.ibm.ws.console.dynamiccluster.form.DynamicClusterMemberCollectionForm") ) {
          // hee collectionForm = (DynamicClusterMemberCollectionForm) session.getAttribute("com.ibm.ws.console.dynamiccluster.form.DynamicClusterMemberCollectionForm");
          collectionForm = (DynamicClusterMemberCollectionForm) session.getAttribute("DynamicClusterMemberCollectionForm");
	   actionString = "com.ibm.ws.console.dynamiccluster.dynamicClusterMemberDeleteConf.do";
	   nameString = "com.ibm.ws.console.dynamiccluster.form.DynamicClusterMemberCollectionForm";
	   typeString = "com.ibm.ws.console.dynamiccluster.form.DynamicClusterMemberCollectionForm";

    } else if (currForm.equals("com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm") ) {
       collectionForm = (DynamicClusterCollectionForm) session.getAttribute("DynamicClusterCollectionForm");
	   actionString = "com.ibm.ws.console.dynamiccluster.dynamicClusterDeleteConf.do";
	   nameString = "com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm";
	   typeString = "com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm";
    }
%>

<html:form action="<%=actionString%>" name="<%=nameString%>" type="<%=typeString%>">

<p class="description-text">
<%
    if (nameString.equals("com.ibm.ws.console.distmanagement.ServerClusterCollectionForm") ) {
%>
       <bean:message key="deletecluster.page.msg1"/>
<%

     } else {
%>
       <bean:message key="deleteserver.page.msg1"/>
<%
     }
%>
</p>


        <table id="serverTable" border="0" cellpadding="2" cellspacing="0" valign="top" width="90%" summary="Framing Table" >
                        <tr>
                    <td class="complex-property" valign="bottom" align="left" width="100%" nowrap>
                            <table border="0" cellpadding="2" cellspacing="1" width="100%" summary="List table" class="framing-table">
                                <tr>
                                    <th class="column-head-name" scope="col" nowrap>
                                        <bean:message key="ManagedObject.name.displayName"/>
                                    </th>
                                    <th class="column-head-name" scope="col" nowrap>
                                        <bean:message key="ServerCluster.status.displayName"/>
                                    </th>
                                </tr>

<%
  	WorkSpace workSpace = (WorkSpace)session.getAttribute(Constants.WORKSPACE_KEY);
	String selectedObjectIds[]= collectionForm.getSelectedObjectIds();
    String qualifiedServerName = null;
    String contextStr = null;
	RepositoryContext serverContext = null;
	String serverName = null;
    String nodeName = null;
    ServerMBeanHelper helper = null;
    ObjectName nodeAgentMbean = null;
    boolean nodeAgentFound = false;

    if (nameString.equals("com.ibm.ws.console.dynamiccluster.form.DynamicClusterMemberCollectionForm")) {
		String resUri = null;
		ClusterMember clusterMember = null;
		ResourceSet resourceSet=null;
		RepositoryContext cellContext = (RepositoryContext) session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
		String cellName = cellContext.getName();
		resourceSet = cellContext.getResourceSet();
               boolean clusterMemberStopped = false;	
	
               DistributedMBeanHelper _helper = DistributedMBeanHelper.getDistributedMBeanHelper();
		RepositoryContext context = null;

		DynamicClusterDetailForm dcDetailForm = (DynamicClusterDetailForm) session.getAttribute("DynamicClusterDetailForm");
		String dcName = dcDetailForm.getName();
               String contextId = "cells:" + cellName + ":clusters:" + dcName;
		// String contextId = collectionForm.getContextId();
		String  contextUri = ConfigFileHelper.decodeContextUri(contextId);
		if (contextUri != null) {
			try {
				context = workSpace.findContext(contextUri);
			}
			catch (WorkSpaceException we) {
				context = null;
			}
		}

		resourceSet = context.getResourceSet();
		
		for (int i = 0; ((selectedObjectIds != null) && (i < selectedObjectIds.length)); i++) {
			 resUri = collectionForm.getResourceUri() + "#" + selectedObjectIds[i];
			 clusterMember = (ClusterMember) resourceSet.getEObject(URI.createURI(resUri),true);

			 if ( _helper.isServerMbeanRegistered(clusterMember.getNodeName(), clusterMember.getMemberName()) ) {
		
                 clusterMemberStopped = false;
				 // Keep member from being removed from the list
				 selectedObjectIds[i]="";
			 } else {
                 clusterMemberStopped = true;
             }

             qualifiedServerName = clusterMember.getNodeName() + "/" + clusterMember.getMemberName();

%>

            <tr CLASS="table-row">
              <td CLASS="collection-table-text">
                <%=qualifiedServerName%>
              </td>
              <td CLASS="collection-table-text">
<%
            if (clusterMemberStopped == false) {
%>
              <img src="<%=request.getContextPath()%>/images/Warning.gif" align="absmiddle" ALT="<bean:message key="error.msg.warning"/>"/>
              <bean:message key="NodeAgent.not.found"/>
<%
            } else {
%>
              <img src="<%=request.getContextPath()%>/images/Information.gif" align="absmiddle" ALT="<bean:message key="error.msg.information"/>"/>
              <bean:message key="button.ok"/>
<%
            }
%>
              </td>
            </TR>
<%
		}

    }


// 170149.1
    if (nameString.equals("com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm")) {

	   for (int i = 0; ((selectedObjectIds != null) && (i < selectedObjectIds.length)); i++) {
           contextStr =  selectedObjectIds[i];
           contextStr = ConfigFileHelper.decodeContextUri(contextStr);

           qualifiedServerName = contextStr ;
%>
           <tr CLASS="table-row">
              <td CLASS="collection-table-text">
                 <%=qualifiedServerName%>
              </td>
              <td CLASS="collection-table-text">
                    <img src="<%=request.getContextPath()%>/images/Information.gif" align="absmiddle" ALT="<bean:message key="error.msg.information"/>"/>
                    <bean:message key="button.ok"/>
              </td>
           </TR>
<%
       } // for

    }
%>

        </table>
        </td>
        </tr>


  </TABLE>

    <p class="description-text">
          <input type="submit" name="deleteServer" value="<bean:message key="button.ok"/>" class="buttons" id="other">
          <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons" id="other">
</p>
	
 <BR>

 </TD>
 </TR>
 </TABLE>
</html:form>
</BODY>
</html:html>
