<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.security.core.SecurityContext"%>
<%@ page  errorPage="/error.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="com.ibm.ws.console.core.form.AbstractCollectionForm"%>
<%@ page import="com.ibm.ws.console.core.form.ContextScopeForm"%>
<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%
        int chkcounter = 0;
        try {
%>

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes" classname="java.lang.String"/>
<tiles:useAttribute name="useRefId" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="sortIconLocation" classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth" classname="java.lang.String"/>
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<tiles:useAttribute name="collectionList" classname="java.util.List" />
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List" />
<tiles:useAttribute name="parent" classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String" scope="request"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="htmlFilter" classname="java.lang.String"/>
<tiles:useAttribute name="treatAdminSecurityManagerRoleAsMonitor" classname="java.lang.String" ignore="true"/>

<bean:define id="collectionForm" name="<%=formName%>"/>
<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/>

<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%

int wasVersion = ConfigUtils.getWASVersionInts()[0];

if(treatAdminSecurityManagerRoleAsMonitor==null) {
      treatAdminSecurityManagerRoleAsMonitor="true"; 
} 

org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.action.Action.MESSAGES_KEY);
String contextType=(String)request.getAttribute("contextType");

AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();

java.util.Properties props= null;

String encoding = response.getCharacterEncoding();
if(encoding==null)	encoding = "UTF-8";


java.util.ArrayList collectionList_ext =  new java.util.ArrayList();
            for(int i=0;i<collectionList.size(); i++)
                collectionList_ext.add(collectionList.get(i));

java.util.ArrayList collectionPreferenceList_ext =  new java.util.ArrayList();
for(int i=0;i<collectionPreferenceList.size(); i++)
    collectionPreferenceList_ext.add(collectionPreferenceList.get(i));


IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.collectionItem";
    IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

    IExtension[] extensions = registry.getExtensions(extensionId, ic);

String extensionId_preferences = "com.ibm.websphere.wsc.preferences";
IConfigurationElementSelector ic_preferences = new ConfigurationElementSelector(contextType, extensionId_preferences);

IExtension[] extensions_preferences = registry.getExtensions(extensionId_preferences, ic);

    if((extensions!=null && extensions.length>0) || (extensions_preferences!=null && extensions_preferences.length>0)){
    if(contextId!=null && contextId!="nocontext"){
        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }
        props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);
    }

    if(extensions!=null && extensions.length>0){

    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props);
}

pageContext.setAttribute("collectionList_ext",collectionList_ext);

boolean isWASDynamicCluster = false;
com.ibm.ws.console.dynamiccluster.form.DynamicClusterDetailForm dcDetailForm = (com.ibm.ws.console.dynamiccluster.form.DynamicClusterDetailForm) session.getAttribute("DynamicClusterDetailForm");
if (dcDetailForm != null) {
  String serverType = dcDetailForm.getServerType();
  if (serverType != null && (serverType.equals(com.ibm.ws.xd.util.MiddlewareServerConstants.APPLICATION_SERVER) ||
							(serverType.equals(com.ibm.ws.xd.util.MiddlewareServerConstants.ONDEMAND_ROUTER)))) {
     isWASDynamicCluster = true;
  }
}

 %>



<%


if(extensions_preferences!=null && extensions_preferences.length>0){

collectionPreferenceList_ext = PreferenceSelector.getPreferences(extensions_preferences,collectionPreferenceList_ext,props);

}

%>

<%-- Generate a map of roles--%>
<% 
Map contextToRolesMap = new HashMap(); 
if (wasVersion >= 7) {
%>
<logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">
	<bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
	<%String contextId_detail = null;%>
	<logic:notEmpty name="listcheckbox" property="contextId">
		<bean:define id="contextId_new" name="listcheckbox" property="contextId" type="java.lang.String" toScope="request"/>
		<%contextId_detail = contextId_new;%>
	 </logic:notEmpty>
	<%
		contextId_detail = ConfigFileHelper.encodeContextUri(contextId_detail);
		if(contextId_detail==null)
			contextId_detail=contextId;
      if (wasVersion >= 7)
		    contextToRolesMap.put(contextId_detail, ConfigFileHelper.getRoles(contextId_detail));
	%>
</logic:iterate>

<%-- We need to get ALL items in the collection so that we can display the correct values in the PreferenceFilter --%>
<%-- It would be nice if there was a more efficient way to do that without looking through every item. (417407) --%>
<logic:present name="<%=iterationName%>" property="contents">

  <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="contents">
       <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
       <%String contextId_detail = null;%>
       <logic:notEmpty name="listcheckbox" property="contextId">
              <bean:define id="contextId_new" name="listcheckbox" property="contextId" type="java.lang.String" toScope="request"/>
              <%contextId_detail = contextId_new;%>
        </logic:notEmpty>
       <%
              contextId_detail = ConfigFileHelper.encodeContextUri(contextId_detail);
              if(contextId_detail==null)
                     contextId_detail=contextId;
              contextToRolesMap.put(contextId_detail, ConfigFileHelper.getRoles(contextId_detail));
       %>

  </logic:iterate>

</logic:present>

<%
       //The goal is to populate contextToRolesMap with 
       // 1. The valid roles of all items in collection table
       // 2. The valid roles for current scope (if selected), or else for all possible scopes if "All Scopes" is selected
         if (contextId != null) {
           if (contextId.equals("none") || contextId.equals(Constants.ALLSCOPES)) {
               //try to get a list of scopes from a scope form
                ContextScopeForm scopeForm = (ContextScopeForm) session.getAttribute("contextScopeForm");
                List allScopes = scopeForm.getAllscopes();
                for (Iterator i = allScopes.iterator(); i.hasNext(); ) {
                    String scopeContextId = (String) i.next();
                    contextToRolesMap.put(scopeContextId, ConfigFileHelper.getRoles(ConfigFileHelper.decodeContextUri(scopeContextId)));
                } 
           } else if (contextId.equals("CONTEXT_NOT_SET")) {  //This happens when using AbstractController
                ContextScopeForm scopeForm = (ContextScopeForm) session.getAttribute("contextScopeForm");
                if (scopeForm.getCurrentScope().equals("All Scopes")) {
                List allScopes = scopeForm.getAllscopes();
                    for (Iterator i = allScopes.iterator(); i.hasNext(); ) {
                        String scopeContextId = (String) i.next();
                        contextToRolesMap.put(scopeContextId, ConfigFileHelper.getRoles(ConfigFileHelper.decodeContextUri(scopeContextId)));
                    } 
                } else {
                    contextToRolesMap.put(scopeForm.getCurrentScope(), ConfigFileHelper.getRoles(ConfigFileHelper.decodeContextUri(scopeForm.getCurrentScope())));
                }

           } else {
               //context is set to a single scope--use that
               contextToRolesMap.put(contextId, ConfigFileHelper.getRoles(ConfigFileHelper.decodeContextUri(contextId)));
           }
         }

}
%>

<%--
    NOTES:
            The sorting icons are specified in defaultIconList.  The icons are assumed to be located in the images folder.
            Checkboxes are NOT displayed for all objects whose refIds start with "builtin_"
--%>

        <%@ include file="filterSetup.jspf" %>


        <% session.removeAttribute("preferences"); %>
        <jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>

        <% for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();) {
            preferences.add(i.next());
           }%>

        <tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
            <tiles:put name="parent" value="<%=parent%>"/>
            <tiles:put name="preferences" beanName="preferences" beanScope="session" />
            <tiles:put name="collectionForm" value="<%=collectionForm %>"/>
            <% if (request.getAttribute("role.filtering.disabled") == null) { %>
            	<tiles:put name="rolemap" value="<%=contextToRolesMap%>" />
            <% } %>
        </tiles:insert>


 <html:form action="collectionButton.do" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">


        <tiles:insert definition="<%=buttons%>" flush="true">
        <% if (request.getAttribute("role.filtering.disabled") == null) { %>
            	<tiles:put name="rolemap" value="<%=contextToRolesMap%>" />
            <% } %>
        </tiles:insert>

				<%
				String hideCheckBoxes = (String) request.getAttribute("hide.check.boxes");
				if(hideCheckBoxes!= null && hideCheckBoxes.equals("true")){
					showCheckBoxes = "false";
				}
				%>

            <%@ include file="tableControlsLayout.jspf" %>

			<fieldset style="border:0px; padding:0pt; margin: 0pt;">
				<legend class="hidden"><bean:message key="dynamiccluster.membership.table.title"/></legend>
                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" SUMMARY="List table" CLASS="framing-table">

                    <TR>
                    <%
                        if (showCheckBoxes.equals ("true"))
                        {
                    %>
                        <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                            <bean:message key="select.text"/>
                        </TH>
                    <%
                        }
                    %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
                    <%
                        sortable = (String)cellItem.getIsSortable();
                        columnField = (String)cellItem.getColumnField();
                        String tmpName = cellItem.getTooltip();
                        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
                        String editable = cellItem.getEditable();

                       if (chkcounter == 0) {
                          if (searchFilter.equals("")) {
                             searchFilter = columnField;
                          }
                       }

                       String showItem = "yes";
                       if (SecurityContext.isSecurityEnabled()) {
                           String[] roles = cellItem.getRoles();
                           showItem = "no";
                           for (int idx = 0; idx < roles.length; idx++) {
                               if (contextId != null && contextId.indexOf(":clusters:") != -1) {
                                   // Cluster member panel.   Make sure that there is a proper role
                                   // to the cluster.
                                   String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);
                                   if (adminAuthorizer.checkAccess(contextUri,roles[idx])) {
								   } else if (request.isUserInRole(roles[idx])) {
                                       showItem = "yes";
                                       break;
                                   }
                               } else if (request.isUserInRole(roles[idx])) {
                                   showItem = "yes";
                                   break;
                               }
                           }
                       }

                           %>


                        <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
                    <%
                        if (sortIconLocation.equalsIgnoreCase ("right"))
                        {
                    %>
                            <%=columnName%>
                    <%
                        }
                        if (sortable.equals ("false"))
                        {
                    %>
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">
                    <%
                        }
                        if ((sortable.equals ("true")) && (!columnField.equals("status")))
                        {
                            if (columnField.equals (sortedColumn))
                            {
                                String nextOrder;
                                if (order.equalsIgnoreCase ("ASC"))
                                {
                                    nextOrder = "DSC";
                                }
                                else
                                {
                                    nextOrder = "ASC";
                                }
                    %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
                    <%
                                if (order.equalsIgnoreCase ("ASC"))
                                {
                    %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.ascending"/>">
                    <%
                                }
                                else if (order.equalsIgnoreCase ("DSC"))
                                {
                    %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.descending"/>">
                    <%
                                }
                    %>
                            </A>
                    <%
                            }
                            else
                            {
                    %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0"  align="texttop"  ALT="<bean:message key="not.sorted"/>"></A>
                    <%
                            }
                            if (sortIconLocation.equalsIgnoreCase ("left"))
                            {
                    %>
                            <bean:message key="<%=cellItem.getTooltip()%>"/>
                    <%
                            }
                            if (sortable.equals ("false"))
                            {
                    %>
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">
                    <%
                            }
                        }
                    %>
                    <% //add refresh.gif after status column to refresh page
	                    if (columnField.equals("status")) { 
	                    	String refreshLink = parent + (parent.indexOf('?') == -1 ? "?refresh=true" : "&refresh=true");
	                    	
                    %>
                    <A HREF="<%=refreshLink%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  ALT="<bean:message key="refresh.view"/>" align="texttop" border="0"/></A>    
                    <%
                        }

                        if (!filterDisplay.equals("none")) {
                           if (columnField.equals(searchFilter)) {
                    %>
                                <HR SIZE="1"><bean:message key="quick.search.label"/>: <bean:write name="<%=formName%>" property="searchPattern" scope="session"/>
                    <%
                           }
                        }

                        if(editable.equalsIgnoreCase("true") && showItem.equalsIgnoreCase("yes")){



                    %>

                     <Br>
                     <%String updateproperty= "update."+columnField; %>
                    <img src="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" border="0" width="9" height="13">
			    	<html:submit property="<%=updateproperty%>" styleClass="buttons_functions">
						<bean:message key="button.update"/>
					</html:submit>
                 <!--   <input type="submit" name=<%=columnField%> value="<bean:message key="button.update"/>" class="buttons" id="navigation"> -->

                    <% } %>

                        </TH>

                        <% chkcounter = chkcounter + 1; %>

                        </logic:iterate>
                    </TR>


            <%@ include file="filterControlsLayout.jspf" %>


            <% chkcounter = 0; %>
            <%
			String prevRole = null;
			boolean roleFilteringEnabled = true;
			if (wasVersion >= 7) {
			   if (request.getAttribute("role.filtering.disabled") != null)
				   roleFilteringEnabled = false;
			}
            %>


            <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">

            <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
            <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
            <%String contextId_detail = null;%>
            <logic:notEmpty name="listcheckbox" property="contextId">
              <bean:define id="contextId_new" name="listcheckbox" property="contextId" type="java.lang.String" toScope="request"/>
              <%contextId_detail = contextId_new;%>
            </logic:notEmpty>

                    <%
					   contextId_detail = ConfigFileHelper.encodeContextUri(contextId_detail);
					   if(contextId_detail==null)
						   contextId_detail=contextId;

                        String primaryRole = null;
                        if (wasVersion >= 7) {
                           primaryRole = ConfigFileHelper.getAssumedRole((Set)contextToRolesMap.get(contextId_detail));
                                          
                           //515386: Treat Admin security manager role as monitor
                           if(primaryRole.equals(AdminAuthorizer.ADMINSECURITY_ROLE) && treatAdminSecurityManagerRoleAsMonitor.equals("true")) {
                              primaryRole=AdminAuthorizer.MONITOR_ROLE;
                           }
                                          
                           if (roleFilteringEnabled) {
                              if (prevRole == null || !primaryRole.equals(prevRole)) {
                                 prevRole = primaryRole;
                                 String roleMessageKey = "resource.access." + primaryRole;
										%>
											<TR><TD class='table-role' valign='baseline' colspan='<%=collectionList_ext.size() + 1 %>'><bean:message key="<%=roleMessageKey%>"/></TD></TR>
                              <%
                              }
                           }
                        }
                    %>

                    <TR CLASS="table-row">
					<%
						if (showCheckBoxes.equals("true"))
						{
						   //Do not display checkbox if it is a builtin resource | do not display if user only has monitor access
						   if ((wasVersion >= 7) && (("monitor".equals(primaryRole)) || (ConfigFileHelper.isDeleteable(refId) == false))) {
							  //empty table cell where the check box normally would be
							    %>
                                <TD VALIGN="top"  WIDTH="1%" HEADERS="selectCell" class="collection-table-text">
							    &nbsp;
							    </TD>
						<% } else {

								String delId = (String)resourceUri + "#" + (String) refId ;
			            %>
				                <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
					   <%
								if ( !idColumn.equals("") ) {
                       %>
					                <bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
					                <LABEL class="collectionLabel" for="<%=selectId%>" TITLE='<bean:message key="select.text"/>: <%=selectId%>'>
					                <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectId%>"/>
				       <%
								 } else { 
                       %>
					                <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
					                <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=refId%>"/>
					   <%
								 }
                       %>
                                </LABEL>
						      </TD>
                    <%
                           }
                        }
                    %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
                    <%
                        columnField = (String)cellItem.getColumnField();
                        String columnRefId = columnField + "RefId";
                        String editable = cellItem.getEditable();

                        String showItem = "yes";
                        if (SecurityContext.isSecurityEnabled()) {
                           String contextUri_detail = ConfigFileHelper.decodeContextUri((String)contextId_detail); 
                           String[] roles = cellItem.getRoles();
                           showItem = "no";
                           for (int idx = 0; idx < roles.length; idx++) {
                               if (adminAuthorizer.checkAccess(contextUri_detail,roles[idx])) {
                                   
                                   if (contextId != null && contextId.indexOf(":clusters:") != -1) {
                                       // Cluster member panel.   Make sure that there is also a proper role
                                       // to the cluster.
                                       String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);
                                       for (int idx2 = 0; idx2 < roles.length; idx2++) {
                                           if (adminAuthorizer.checkAccess(contextUri,roles[idx2])) {
                                               showItem = "yes";
                                               break;
                                           }
                                       }
                                   } else {
                                       showItem = "yes";
                                       break;
                                   }
                                   
                               }
                           }
                       }
                    %>

                        <TD NOWRAP VALIGN="top"  class="collection-table-text" headers="<%=columnField%>">

                       <%
                        if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0)
                        {
                        %>
                            <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop"></IMG>&nbsp;
                        <%
                        }
                        if (cellItem.getLink().length() > 0)
                        {
                            String hRef = cellItem.getLink() + "&refId="+URLEncoder.encode(refId,encoding) + "&contextId=" + URLEncoder.encode(contextId,encoding) + "&resourceUri=" + URLEncoder.encode(resourceUri,encoding) + "&perspective=" + URLEncoder.encode(perspective,encoding);
                        %>
                            <A HREF="<%=hRef%>">
                        <% }
                        if (columnField.equalsIgnoreCase("status")) {

                            //hee 6.1??  String statusservlet = "/ibm/console/status";
                            String statusservlet = "/ibm/console/middlewareserverstatus";
                            if (isWASDynamicCluster)
                               statusservlet = "/ibm/console/status";

                            if(cellItem.getStatusServlet()!=null)
                                statusservlet = cellItem.getStatusServlet();

                            if ( statusType.equals("unknown") ) {%>
                            <bean:define id="status" name="listcheckbox" property="status"/>
                            <A target="statuswindow" href="<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>">
                            <IMG role="img" name="statusIcon" onfocus='getObjectStatus("<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>",this)' onmouseover='getObjectStatus("<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>",this)' border="0" SRC="<%=statusservlet%>?type=<%=statusType%>&status=<%=status%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                            <%
                            } else {
                            %>
                            <tiles:useAttribute name="statusCols" classname="java.util.List"/>
                            <%  String queryString = "";
                                Iterator cols = statusCols.iterator();
                                while (cols.hasNext()) {
                                String col = (String) cols.next();%>
                                <bean:define id="colvar" name="listcheckbox" property="<%=col%>"/>
                                <%
                                queryString += "&" + col + "=" + URLEncoder.encode((String)colvar , encoding);
                                }
                                String encodedStatusLink = statusservlet + "?text=true&type=" + statusType + queryString;
                                String imageSrcLink = statusservlet + "?type=" + statusType + queryString;
                                %>
                            <A target="statuswindow" href="<%=encodedStatusLink%>">
                            <IMG role="img" name="statusIcon" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' border="0" SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                           <% } %>


<%                       } else if(editable.equalsIgnoreCase("true") && showItem.equalsIgnoreCase("yes")){ %>
                            <%
                            String desc = cellItem.getTooltip();
                            String columnFieldId = columnField + "_" + chkcounter;
                            %>
                            <input type="hidden" name="<%=columnRefId%>" value="<%=refId%>"/>
                            <html:text property="<%=columnField%>" name="listcheckbox" size="10" styleClass="textEntry" styleId="<%=columnFieldId%>" title="<%=messages.getMessage(request.getLocale(),desc)%>"/>
                       <%
                        } else if (cellItem.getTranslate()) { 
                       %>
                            <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                            <bean:message key="<%=prop %>"/>
<%                       } else {
                          if (htmlFilter.equalsIgnoreCase("false")) {  %>
                            <bean:write filter="false" name="listcheckbox" property="<%=columnField%>"/>
                          <% } else {  %>
                               <bean:write name="listcheckbox" property="<%=columnField%>"/>
                     <%
							 }
                         } 


                         if (cellItem.getLink().length() > 0) { %>
                            </A>
                            <% }else{ %>
                               <% if (!columnField.equalsIgnoreCase("status")) { %>
                                 &nbsp;
                               <%  } %>
                         <%  } %>

                        </TD>

                        </logic:iterate>
                    </TR>
                    <% chkcounter = chkcounter + 1; %>
                    </logic:iterate>

                </TABLE>
			</fieldset>
            <input type="hidden" name="collectionFormAction" value="<%=formAction%>"/>

</html:form>


<% } catch (Exception e) {e.printStackTrace();
} %>

    <%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) {
           out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
           out.println("<tr class='table-row'><td>"+nonefound+"</td></tr></table>");
        }
    %>
