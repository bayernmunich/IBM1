<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action" %>
<%@ page errorPage="error.jsp" %>
<%@ page import="com.ibm.ws.*" %>
<%@ page import="com.ibm.wsspi.*" %>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="com.ibm.ws.console.core.form.ContextScopeForm"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem" %>
<%@ page import="com.ibm.ws.console.core.selector.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>
<%@ page import="com.ibm.ws.security.core.SecurityContext" %>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor" %>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsDetailForm" %>
<%@ page import="com.ibm.ws.xd.middlewareapp.status.OverallAppStatus" %>
<%@ page import="com.ibm.ws.console.middlewareapps.servlet.MiddlewareAppsDeploymentStatusServlet" %>
<%@page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld"  prefix="bean"  %>
<%@ taglib uri="/WEB-INF/struts-html.tld"  prefix="html"  %>
<%@ taglib uri="/WEB-INF/tiles.tld"        prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%
int chkcounter = 0;
try {
%>

<tiles:useAttribute name="iterationName"            classname="java.lang.String"/>
<tiles:useAttribute name="iterationProperty"        classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes"           classname="java.lang.String"/>
<tiles:useAttribute name="sortIconLocation"         classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth"              classname="java.lang.String"/>
<tiles:useAttribute name="buttons"                  classname="java.lang.String"/>
<tiles:useAttribute name="collectionList"           classname="java.util.List"/>
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List"/>
<tiles:useAttribute name="parent"                   classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String"/>
<tiles:useAttribute name="formName"   classname="java.lang.String"/>
<tiles:useAttribute name="formType"   classname="java.lang.String"/>
<tiles:useAttribute name="idColumn"   classname="java.lang.String"/>
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="htmlFilter" classname="java.lang.String"/>

<tiles:useAttribute name="treatAdminSecurityManagerRoleAsMonitor" classname="java.lang.String" ignore="true"/>

<bean:define id="order"        name="<%=iterationName%>" property="order"       type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId"    name="<%=iterationName%>" property="contextId"   type="java.lang.String" toScope="request"/>
<bean:define id="perspective"  name="<%=iterationName%>" property="perspective" type="java.lang.String"/>


<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<!-- collectionTableLayout.jsp -->
<%--
MiddlewareAppsDetailForm adf = new MiddlewareAppsDetailForm();
adf.setDeploymentStatusMsg("");

request.setAttribute("theForm", adf);
--%>
<%

//  BEGIN Javascript Translated Text Variables
String pleaseWait = "null";

String statusDeploymentErr = "null";
String statusPartialDeploymentErr = "null";
String statusUnknownDeployment = "null";
String statusPartialDeployed = "null";
			
MessageResources statusMessages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
try { pleaseWait = statusMessages.getMessage(request.getLocale(),"trace.tree.pleaseWaitLabel"); } catch (Exception e) { } 

try { statusDeploymentErr = statusMessages.getMessage(request.getLocale(), "middlewareapps.deployment.overall.error"); } catch (Exception e) { }
try { statusPartialDeploymentErr = statusMessages.getMessage(request.getLocale(), "middlewareapps.deployment.overall.partialerror"); } catch (Exception e) { }
try { statusUnknownDeployment = statusMessages.getMessage(request.getLocale(), "middlewareapps.deployment.unknowndeployment"); } catch (Exception e) { } 
try { statusPartialDeployed = statusMessages.getMessage(request.getLocale(), "middlewareapps.deployment.overall.partiallydeployed"); } catch (Exception e) { }

%>

<script LANGUAGE="JavaScript">
var pleaseWait = "<%=pleaseWait%>";

var statusDeploymentErr = "<%=statusDeploymentErr%>";
var statusPartialDeploymentErr = "<%=statusPartialDeploymentErr%>";
var statusUnknownDeployment = "<%=statusUnknownDeployment%>";
var statusPartialDeployed = "<%=statusPartialDeployed%>";

if (statusDeploymentErr == "null") { statusDeploymentErr = "Deployment error" }
if (statusPartialDeploymentErr == "null") { statusPartialDeploymentErr = "Partial deployment error" }
if (statusUnknownDeployment == "null") { statusUnknownDeployment =  "Unknown deployment" }
if (statusPartialDeployed == "null") { statusPartialDeployed = "Partially deployed" }

deployStatusArray = new Array(statusDeploymentErr,statusPartialDeploymentErr,statusUnknownDeployment,statusPartialDeployed);
var statusIconDeploymentErr = '/ibm/console/com.ibm.ws.console.middlewareapps/images/Error3.gif';        
var statusIconPartialDeploymentErr = '/ibm/console/com.ibm.ws.console.middlewareapps/images/Error3.gif';
var statusIconUnknownDeployment = '/ibm/console/com.ibm.ws.console.middlewareapps/images/unknown.gif';
var statusIconPartialDeployed = '/ibm/console/com.ibm.ws.console.middlewareapps/images/Warning3.gif';
       
deployStatusIconArray = new Array(statusIconDeploymentErr,statusIconPartialDeploymentErr,statusIconUnknownDeployment,statusIconPartialDeployed);

</script>


<script type="text/javascript" language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.middlewareapps/collectiontable.js"></script>

<%
int wasVersion = ConfigUtils.getWASVersionInts()[0];

if(treatAdminSecurityManagerRoleAsMonitor==null) {
      treatAdminSecurityManagerRoleAsMonitor="true"; 
} 

AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri(contextId);

String contextType = (String) request.getAttribute("contextType");
Properties props   = null;

ArrayList collectionList_ext = new ArrayList();
for (int i = 0; i < collectionList.size(); i++) {
    collectionList_ext.add(collectionList.get(i));
}

ArrayList collectionPreferenceList_ext =  new ArrayList();
for (int i = 0; i < collectionPreferenceList.size(); i++) {
    collectionPreferenceList_ext.add(collectionPreferenceList.get(i));
}

IPluginRegistry registry         = IPluginRegistryFactory.getPluginRegistry();
String extensionId               = "com.ibm.websphere.wsc.collectionItem";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

IExtension[] extensions          = registry.getExtensions(extensionId, ic);
String extensionId_preferences   = "com.ibm.websphere.wsc.preferences";

IConfigurationElementSelector ic_preferences = new ConfigurationElementSelector(contextType, extensionId_preferences);
IExtension[] extensions_preferences          = registry.getExtensions(extensionId_preferences, ic);

if ((extensions != null && extensions.length > 0) || (extensions_preferences != null && extensions_preferences.length > 0)) {
    if(contextId != null && contextId != "nocontext") {
        props = ConfigFileHelper.getNodeMetadataProperties((String) contextId);
    }
    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);
}

if (extensions != null && extensions.length > 0) {
    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions, collectionList_ext, props);
}

pageContext.setAttribute("collectionList_ext", collectionList_ext);

if (extensions_preferences != null && extensions_preferences.length > 0) {
    collectionPreferenceList_ext = PreferenceSelector.getPreferences(extensions_preferences, collectionPreferenceList_ext, props);
}
%>

<%-- Generate a map of roles--%>
<% Map contextToRolesMap = new HashMap(); 
boolean showButtons = true;
if (wasVersion >= 7) {
   showButtons = false;
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
              Set roles = ConfigFileHelper.getRoles(contextId_detail);
			  // Show buttons if user can perform the button actions on any of the apps. 
              if ((roles.contains(AdminAuthorizer.ADMIN_ROLE)) || 
				  (roles.contains(AdminAuthorizer.CONFIG_ROLE)) || 
				  (roles.contains(AdminAuthorizer.OPERATOR_ROLE)) || 
				  (roles.contains(AdminAuthorizer.DEPLOYER_ROLE))) {
                 showButtons = true;
			  }
              contextToRolesMap.put(contextId_detail, roles);
       %>
</logic:iterate>
<%-- Extra missing context/roles logic imported from webui.mws layout JSP (RTC163482) --%>
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

<%@ include file="/secure/layouts/filterSetup.jspf" %>

<%-- Preferences at the top --%>
<% session.removeAttribute("preferences"); %>
<jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>

<%
for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();) {
    preferences.add(i.next());
}
%>

<tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
    <tiles:put name="parent" value="<%=parent%>"/>
    <tiles:put name="preferences" beanName="preferences" beanScope="session" />
</tiles:insert>

<html:form action="<%=formAction%>" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">

<%
    if (wasVersion == 6) {
	   if (SecurityContext.isSecurityEnabled() && !(adminAuthorizer.checkAccess(contextUri, "administrator") || 
													adminAuthorizer.checkAccess(contextUri, "configurator") || 
													adminAuthorizer.checkAccess(contextUri, "deployer"))) {

		   showButtons = false;
	   }
	}
    if (showButtons) {
%>
    <tiles:insert definition="<%=buttons%>" flush="true">
            <tiles:put name="rolemap" value="<%=contextToRolesMap%>" />
    </tiles:insert>
<%
    }
%>

    <%@ include file="/secure/layouts/tableControlsLayout.jspf" %>
	
	<fieldset style="border:0px; padding:0pt; margin: 0pt;">
		<legend class="hidden"><bean:message key="allapps.displayName"/></legend>
    <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" SUMMARY="List table" CLASS="framing-table">

        <TR>
            <%
                if (showCheckBoxes.equals("true")) {
            %>
                    <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                        <bean:message key="select.text"/>
                    </TH>
            <%
                }
            %>

            <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
                <%
                    sortable          = (String) cellItem.getIsSortable();
                    columnField       = (String) cellItem.getColumnField();
                    String tmpName    = cellItem.getTooltip();
                    String columnName = translatedText.getMessage(request.getLocale(), tmpName);

                    if (chkcounter == 0) {
                        if (searchFilter.equals("")) {
                            searchFilter = columnField;
                        }
                    }
                %>

                <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
                <%
                    if (sortIconLocation.equalsIgnoreCase("right")) {
                %>
                        <%=columnName%>
                <%
                    }

                    if (sortable.equals("false")) {
                %>
                        <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">
                <%
                    }

                    // if ((sortable.equals("true")) && (!columnField.equals("status"))) {
                    if (sortable.equals("true")) {
                        if (columnField.equals(sortedColumn)) {
                            String nextOrder;
                            if (order.equalsIgnoreCase("ASC")) {
                                nextOrder = "DSC";
                            } else {
                                nextOrder = "ASC";
                            }
                %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
                <%
                            if (order.equalsIgnoreCase("ASC")) {
                %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.ascending"/>">
                <%
                            } else if (order.equalsIgnoreCase("DSC")) {
                %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.descending"/>">
                <%
                            }
                %>
                            </A>
                <%
                        } else {
                %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0"  align="texttop"  ALT="<bean:message key="not.sorted"/>"></A>
                <%
                        }

                        if (sortIconLocation.equalsIgnoreCase("left")) {
                %>
                            <bean:message key="<%=cellItem.getTooltip()%>"/>
                <%
                        }

                        if (sortable.equals ("false")) {
                %>
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">
                <%
                        }
                    }
                %>
                <%  // add refresh.gif after status column to refresh page
                    if (columnField.equals("status")) { 
                %>
                        <A HREF="<%=parent%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  ALT="<bean:message key="refresh.view"/>" align="texttop" border="0"/></A>
                <%
                    }
                        
                    // add refresh.gif after state column to refresh page
                    if (columnField.equals("currentState")) {
                %> 
                        <A HREF="<%=parent%>"> 
                            <IMG SRC="<%=request.getContextPath()%>/images/refresh.gif" ALT="<bean:message key="refresh.view"/>" align="texttop" border="0" /></A> 
                <%
                    }

                    if (!filterDisplay.equals("none")) {
                        if (columnField.equals(searchFilter)) {
               %>
                            <HR SIZE="1"><bean:message key="quick.search.label"/>: <bean:write name="<%=formName%>" property="searchPattern" scope="session"/>
               <%
                        }
                    }
               %>
               </TH>

               <% chkcounter = chkcounter + 1; %>

            </logic:iterate>
        </TR>

        <%@ include file="/secure/layouts/filterControlsLayout.jspf" %> 

        <% chkcounter = 0; %>
             
            <%
		String prevRole = null;
             %> 

        <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">
            <bean:define id="resourceUri" name="listcheckbox" property="resourceUri"  type="java.lang.String"/>
            <bean:define id="refId"       name="listcheckbox" property="refId"        type="java.lang.String"/>
            <bean:define id="uniqueId"    name="listcheckbox" property="uniqueId"     type="java.lang.String"/>
            <bean:define id="name"        name="listcheckbox" property="name"         type="java.lang.String"/>
            <bean:define id="edition" 		name="listcheckbox" property="edition" 	  type="java.lang.String"/>
            <bean:define id="editionAlias" name="listcheckbox" property="editionAlias" type="java.lang.String"/>
            <bean:define id="editionState" name="listcheckbox" property="editionState" type="java.lang.String"/>
            <bean:define id="type"        name="listcheckbox" property="type"         type="java.lang.String"/>
            <bean:define id="typeKey"     name="listcheckbox" property="typeKey"      type="java.lang.String"/>
            <bean:define id="status"      name="listcheckbox" property="status"       type="java.lang.String"/>
            <bean:define id="contextId"   name="listcheckbox" property="contextId"    type="java.lang.String"/>
            <bean:define id="deploymentStatusMsg"	name="listcheckbox"	property="deploymentStatusMsg"	type="java.lang.String"/>
            <%
		   String primaryRole = null;
		   if (wasVersion >= 7) {
			  primaryRole = ConfigFileHelper.getAssumedRole((Set)contextToRolesMap.get(contextId));

			  //515386: Treat Admin security manager role as monitor
			  if(primaryRole.equals(AdminAuthorizer.ADMINSECURITY_ROLE) && treatAdminSecurityManagerRoleAsMonitor.equals("true")) {
				 primaryRole=AdminAuthorizer.MONITOR_ROLE;
			  }

			  if (prevRole == null || !primaryRole.equals(prevRole)) {
				 prevRole = primaryRole;
				 String roleMessageKey = "resource.access." + primaryRole;

					  %>
					  <TR><TD class='table-role' valign='baseline' colspan='<%=collectionList_ext.size() + 1 %>'><bean:message key="<%=roleMessageKey%>"/></TD></TR>
					  <%
				 }
		   }
             %>

            <TR CLASS="table-row">
            
            <%
            	session.setAttribute("typeKey", typeKey);
            	
                if (showCheckBoxes.equals("true")) {
				   if ((wasVersion >= 7) && ("monitor".equals(primaryRole))) {
						//empty table cell where the check box normally would be
						%>
                        <TD VALIGN="top"  WIDTH="1%" HEADERS="selectCell" class="collection-table-text">
						&nbsp;
						</TD>
						<%

					} else {
					   if (ConfigFileHelper.isDeleteable(refId) == true) {
						   String delId = (String) resourceUri + "#" + (String) refId ;
			   %>
						   <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
			   <%
						   if (!idColumn.equals("")) {
			   %>
							   <bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
							   <LABEL class="collectionLabel" for="<%=selectId%>" TITLE='<bean:message key="select.text"/> <%=name%> <%=editionAlias%>'>
								   <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectId%>"/>
			   <%
						   } else {
			   %>
							   <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/> <%=name%> <%=editionAlias%>'>
								   <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=refId%>"/>
			   <%
						   }
			   %>
							   </LABEL>
						   </TD>
			   <%
					   } else {
			   %>
						   <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
							   &nbsp;
						   </TD>
			   <%
					   }
					}
				} else {
			%>
					<%-- zoght 4361 21, display empty cell if monitor role --%>
					<TD VALIGN="top"  WIDTH="1%" class="collection-table-text"> &nbsp;</TD>
			<%
				 }
            %>

                <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
                <%
                    columnField = (String) cellItem.getColumnField();
                %>

                    <TD VALIGN="top" class="collection-table-text" headers="<%=columnField%>" id="<%=refId + "_" + columnField%>">

                <%
                    if (cellItem.getIcon() != null && cellItem.getIcon().length() > 0) {
                %>
                        <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop"></IMG>&nbsp;
                <%
                    }

                    if (cellItem.getLink().length() > 0) {
                        if (columnField.equalsIgnoreCase("name")) {
                            String hRef = cellItem.getLink()
                                            + "&refId="
                                            + refId
                                            + "&contextId="
                                            + URLEncoder.encode(contextId)
                                            + "&resourceUri="
                                            + URLEncoder.encode(resourceUri)
                                            + "&perspective="
                                            + URLEncoder.encode(perspective); 
                %> 
                            <A HREF="<%=hRef%>">
                <%
                        } // end if
                    } // end if link

                    if (columnField.equalsIgnoreCase("status")) {
                        if (statusType.equals("unknown")) {

                            String statusServlet = "/ibm/console/AppManagementStatus";
                            String middlewareappsStatusServlet = "/ibm/console/MiddlewareAppsStatus";
                            String middlewareappsDeploymentStatusServlet = "/ibm/console/MiddlewareAppsDeploymentStatus";
                %>

                            <%-- <bean:define id="name" name="listcheckbox" property="name"/>
                            <bean:define id="node" name="listcheckbox" property="node"/> --%>

			                <% if (typeKey.equals("middlewareapps.type.j2ee")) {
			                        String mangledName = name + "-edition" + editionAlias;
			                        if (edition.equals("")) {
			                        	mangledName = name;
			                        }
			                %>
			
				                    <A target="statuswindow" href="<%=statusServlet%>?text=true&name=<%=mangledName%>">
				                    <IMG role="img" name="statusIcon<%=refId%>" onfocus='getObjectStatus("<%=statusServlet%>?text=true&name=<%=mangledName%>",this)' onmouseover='getObjectStatus("<%=statusServlet%>?text=true&name=<%=mangledName%>",this)' border="0" SRC="<%=statusServlet%>?name=<%=mangledName%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
				                    </A>
			
			                <% } else {
			                       String encoding = response.getCharacterEncoding();
			                       String encodedStatusLink = middlewareappsStatusServlet + "?text=true&name=" + URLEncoder.encode((String) name, encoding) + "&edition=" + URLEncoder.encode((String) editionAlias, encoding) + "&typeKey=" + URLEncoder.encode((String) typeKey, encoding);
			                       String imageSrcLink = middlewareappsStatusServlet + "?name=" + URLEncoder.encode((String) name, encoding) + "&edition=" + URLEncoder.encode((String) editionAlias, encoding) + "&typeKey=" + URLEncoder.encode((String) typeKey, encoding);
			                       
			                %>

									<IMG role="img" name="statusIcon<%=refId%>" border="0" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
								
								<%  if (typeKey.equals("middlewareapps.type.wasce")) { 
										String encodedDeploymentStatusLink = middlewareappsDeploymentStatusServlet + "?text=true&name=" + URLEncoder.encode((String) name, encoding) + "&edition=" + URLEncoder.encode((String) editionAlias, encoding) + "&typeKey=" + URLEncoder.encode((String) typeKey, encoding);
				                       	String deploymentStatusImageSrcLink = middlewareappsDeploymentStatusServlet + "?name=" + URLEncoder.encode((String) name, encoding) + "&edition=" + URLEncoder.encode((String) editionAlias, encoding) + "&typeKey=" + URLEncoder.encode((String) typeKey, encoding);
													                        
				                       	request.setAttribute("name", name);
										request.setAttribute("edition",editionAlias);
				                		
										OverallAppStatus overallAppStatus = new OverallAppStatus(request);
										String deploystatus = overallAppStatus.deploymentStatus();
																												
										if(deploystatus.equals("ExecutionState.SUCCESS") || deploystatus.equals("")){
											;	
										} else {
											String statusImgLink = "/ibm/console/com.ibm.ws.console.middlewareapps" + MiddlewareAppsDeploymentStatusServlet.getForwardName(deploystatus);
											String statusText = MiddlewareAppsDeploymentStatusServlet.getStatusTextKey(deploystatus);

											MessageResources messages = (MessageResources) getServletContext().getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
											statusText = messages.getMessage(request.getLocale(), statusText);
								%>
																												
											<%-- <IMG name="deploymentStatusIcon<%=refId%>" border="0" onfocus='getMiddlewareAppStatus("<%=encodedDeploymentStatusLink%>",this,"<%=refId%>")' onmouseover='getMiddlewareAppStatus("<%=encodedDeploymentStatusLink%>",this,"<%=refId%>")' SRC="<%=deploymentStatusImageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>"> --%>
											<IMG role="img" name="deploymentStatusIcon<%=refId%>" border="0" onfocus='getMiddlewareAppStatus("<%=encodedDeploymentStatusLink%>",this,"<%=refId%>")' onmouseover='getMiddlewareAppStatus("<%=encodedDeploymentStatusLink%>",this,"<%=refId%>")' SRC="<%=statusImgLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
											<A id="deploymentStatusText<%=refId%>" class="collection-table-text" style="color: #000000"><%=statusText%></A>

								<%	
										}
									}
								%>	

			                <% } %>

                            <%-- <bean:define id="status" name="listcheckbox" property="status"/> --%>
                            <%--
                            <A target="statuswindow" href="/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>">
                                <IMG name="statusIcon" onfocus='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' onmouseover='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' border="0" SRC="/ibm/console/status?type=<%=statusType%>&status=<%=status%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                            --%>

                <%
                            } else {
                %>
                               <tiles:useAttribute name="statusCols" classname="java.util.List"/>
                <%              String queryString = "";
                                Iterator cols = statusCols.iterator();
                                while (cols.hasNext()) {
                                    String col = (String) cols.next();
                %>
                                    <bean:define id="colvar" name="listcheckbox" property="<%=col%>"/>
                <%
                                    queryString += "&" + col + "=" + URLEncoder.encode((String) colvar , "UTF-8");
                                }
                                String encodedStatusLink = "/ibm/console/status?text=true&type=" + statusType + queryString;
                                String imageSrcLink = "/ibm/console/status?type=" + statusType + queryString;
                %>
                            <A target="statuswindow" href="<%=encodedStatusLink%>">
                                <IMG role="img" name="statusIcon" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' border="0" SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                <%
						   }
                    } else if (columnField.equalsIgnoreCase("action")) {
					   if ((wasVersion < 7) || ((showCheckBoxes.equals("true")) && (!("monitor".equals(primaryRole))))) {
                %>
                        <bean:define id="actionList" name="listcheckbox" property="actionList" type="java.util.List"/>
                        <label title="<bean:message key="middlewareapps.app.action.description"/>">
                        	<div class="hidden">
                        		<bean:message key="middlewareapps.app.action.description" />
                        	</div>
                <%
                        if (actionList.size() != 0 && !editionState.equalsIgnoreCase("INACTIVE")) {
                            Iterator i_actionList = actionList.iterator();
                %>
                            
                            <select title="<bean:message key="middlewareapps.app.action.description"/>" name="action_<%=uniqueId%>" onchange="setCheckBox('<%=uniqueId%>', this)">
                <%
                            while (i_actionList.hasNext()) {
                                String curraction = (String) i_actionList.next();
                                String key = curraction;
                                if (key != null && key.length() > 0) {
                %>
                                    <option value="<%=curraction%>">
                                        <bean:message key="<%=key%>"/>
                                    </option>
                <%
                                }
                            } // end while
                        } else {
                %>
                            <select name="action_<%=uniqueId%>" title="<bean:message key="middlewareapps.app.no.action.description"/>" DISABLED>
                <%
                        }
                %>
                            </select>
                            </label>
                <%
					   }
                    } else if (columnField.equalsIgnoreCase("type")) {
                %>
                        <%-- <bean:message key="<%=type%>"/> --%>
                        <%=type%>
                <%
                    } else if (columnField.equalsIgnoreCase("editionState")) {
                %>
                        <%=editionState%>
                <%
                    } else if (cellItem.getTranslate()) {
                %>
                        <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                        <bean:message key="<%=prop%>"/>
                <%
                    } else {
                        if (htmlFilter.equalsIgnoreCase("false")) {
                %>
                            <bean:write filter="false" name="listcheckbox" property="<%=columnField%>"/>
                <%
                        } else {
                %>
                            <bean:write name="listcheckbox" property="<%=columnField%>"/>
                <%      }
                    }

                    if (cellItem.getLink().length() > 0) {
                %>
                        </A>
                <%
                    } else {
                        if (!columnField.equalsIgnoreCase("status")) {
                %>
                            &nbsp;
                <%
                        }
                    }
                %>

                    </TD>

                </logic:iterate>
            </TR>

            <% chkcounter = chkcounter + 1; %>
        </logic:iterate>

    </TABLE>
	</fieldset>
</html:form>

<%
} catch (Exception e) {
    e.printStackTrace();
}

ServletContext   servletContext = (ServletContext) pageContext.getServletContext();
MessageResources messages       = (MessageResources) servletContext.getAttribute(Action.MESSAGES_KEY);
String           nonefound      = messages.getMessage(request.getLocale(), "Persistence.none");

if (chkcounter == 0) {
    out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
    out.println("<tr class='table-row'><td>" + nonefound + "</td></tr></table>");
}
%>
