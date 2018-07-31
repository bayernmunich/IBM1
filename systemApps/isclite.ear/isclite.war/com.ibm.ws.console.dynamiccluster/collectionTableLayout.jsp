<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page  errorPage="error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action" %>

<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer" %>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="com.ibm.ws.console.core.form.ContextScopeForm"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.json.JSUtil"%>
<%@ page import="com.ibm.ws.console.core.json.JSONObject"%>
<%@ page import="com.ibm.ws.console.core.json.JSONArray"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>
<%@ page import="com.ibm.ws.console.dynamiccluster.form.DynamicClusterCollectionForm" %>
<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>
<%@ page import="com.ibm.ws.console.dynamiccluster.servlet.OpModeServlet"%>


<ibmcommon:detectLocale/>
<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<%
int wasVersion = ConfigUtils.getWASVersionInts()[0];
MessageResources statusMessages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
String statusAlt = statusMessages.getMessage(request.getLocale(),"accessibility.needs");

String opmodeHeader = "null";
String opmodeManual = "null";
String opmodeSupervised = "null";
String opmodeAutomatic = "null";
String opmodeUnknown = "null";
String opmodeUnavailable = "null";
MessageResources opmodeMessages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
try { opmodeManual = opmodeMessages.getMessage(request.getLocale(),"OperationalMode.MANUAL"); } catch (Exception e) { }
try { opmodeSupervised = opmodeMessages.getMessage(request.getLocale(),"OperationalMode.SUPERVISED"); } catch (Exception e) { }
try { opmodeAutomatic = opmodeMessages.getMessage(request.getLocale(),"OperationalMode.AUTOMATIC"); } catch (Exception e) { }
try { opmodeUnavailable = opmodeMessages.getMessage(request.getLocale(),"OperationalMode.UNAVAILABLE"); } catch (Exception e) { }
try { opmodeUnknown = opmodeMessages.getMessage(request.getLocale(),"OperationalMode.UNKNOWN"); } catch (Exception e) { }
try { opmodeHeader = opmodeMessages.getMessage(request.getLocale(),"dynamiccluster.detail.opmode"); } catch (Exception e) { }
%>

<script>
top.opmodeCollection = "yes";
var opmodeManual = "<%=opmodeManual%>";
var opmodeSupervised = "<%=opmodeSupervised%>";
var opmodeAutomatic = "<%=opmodeAutomatic%>";
var opmodeUnavailable = "<%=opmodeUnavailable%>";
var opmodeUnknown = "<%=opmodeUnknown%>";
var opmodeHeader = "<%=opmodeHeader%>";

if (opmodeManual == "null") { opmodeManual = "Manual" }
if (opmodeSupervised == "null") { opmodeSupervised = "Supervised" }
if (opmodeAutomatic == "null") { opmodeAutomatic = "Automatic" }
if (opmodeUnavailable == "null") { opmodeUnavailable = "Unavailable" }
if (opmodeUnknown == "null") { opmodeUnknown = "Unknown" }
if (opmodeHeader == "null") { opmodeHeader= "Operational Mode" }
</script>	
	
<script type="text/javascript" language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.dynamiccluster/menu_functions.js"></script>


<%
int chkcounter = 0;
try {
%>

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes" classname="java.lang.String"/>
<tiles:useAttribute name="sortIconLocation" classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth" classname="java.lang.String"/>
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<tiles:useAttribute name="collectionList" classname="java.util.List" />
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List" />
<tiles:useAttribute name="parent" classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />


<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>


<!-- gets all the Collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
String contextType=(String)request.getAttribute("contextType");
Properties props= null;
ArrayList collectionList_ext =  new java.util.ArrayList();
for(int i=0;i<collectionList.size(); i++)
	collectionList_ext.add(collectionList.get(i));

ArrayList collectionPreferenceList_ext =  new java.util.ArrayList();
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
}

if(extensions!=null && extensions.length>0){
	collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props);
}
pageContext.setAttribute("collectionList_ext",collectionList_ext);

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
            contextId_detail = contextId_detail.replaceFirst("dynamicclusters", "clusters");
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
               contextId_detail = contextId_detail.replaceFirst("dynamicclusters", "clusters");
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


<% session.removeAttribute("preferences"); %>
<jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>

<% for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();) {
	preferences.add(i.next());
}
%>

<tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
    <tiles:put name="parent" value="<%=parent%>"/>
    <tiles:put name="preferences" beanName="preferences" beanScope="session" />
</tiles:insert>



<html:form action="<%=formAction%>" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">
	<tiles:insert definition="<%=buttons%>" flush="true">
        <% if (request.getAttribute("role.filtering.disabled") == null) { %>
            <tiles:put name="rolemap" value="<%=contextToRolesMap%>" />
        <% } %>
    </tiles:insert>

 	<%@ include file="/secure/layouts/tableControlsLayout.jspf" %>

	<fieldset style="border:0px; padding:0pt; margin: 0pt;">
		<legend class="hidden"><bean:message key="desc.showDynamicCluster.title"/></legend>
	<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" SUMMARY="List table" CLASS="framing-table">
		<TR>
        <% if (showCheckBoxes.equals ("true")) { %>
			<TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                <bean:message key="select.text"/>
            </TH>
        <% } %>

        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
			<%
			sortable = (String)cellItem.getIsSortable();
			columnField = (String)cellItem.getColumnField();
	        String tmpName = cellItem.getTooltip();
	        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
	        	
	       	if (chkcounter == 0) {
			   if (searchFilter.equals("")) {
				  searchFilter = columnField;
			   }
			}
	    	%>
			<TH VALIGN="MIDDLE" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>">
				<% if (sortIconLocation.equalsIgnoreCase ("right")) { %>
					<bean:message key="<%=cellItem.getTooltip()%>"/>
				<% }
				
				if (sortable.equals ("false")) { %>
					<IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" BORDER="0" WIDTH="9" HEIGHT="13">
				<% }
				
                if ((sortable.equals ("true")) && (!columnField.equals("status"))) {
					if (columnField.equals (sortedColumn)) {
						String nextOrder;
						if (order.equalsIgnoreCase ("ASC")) {
							nextOrder = "DSC";
						} else {
							nextOrder = "ASC";
						}
				%>
                                               <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
                               <%              if (order.equalsIgnoreCase ("ASC")) { %>
                                                  <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" align="texttop" BORDER="0"  ALT="<bean:message key="sorted.ascending"/>"></A>
                               <%              } else if (order.equalsIgnoreCase ("DSC")) { %>
                                                  <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" align="texttop" BORDER="0"  ALT="<bean:message key="sorted.descending"/>"></A>
                               <%              }
                                       } else { %>
                                               <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" align="texttop" BORDER="0"  ALT="<bean:message key="not.sorted"/>"></A>
                               <%      }
                                       if (sortIconLocation.equalsIgnoreCase ("left")) { %>
                                          <bean:message key="<%=cellItem.getTooltip()%>"/>
                               <%      }
                                       if (sortable.equals ("false")) { %>
                                          <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">
                               <%
                                       }
                               }
				%>
				
            <% //add refresh.gif after status column to refresh page
            	if (columnField.equals("status")) { %>
                  <A HREF="<%=parent%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  align="texttop" ALT="<bean:message key="refresh.view"/>" align="texttop" border="0"/></A>
            <%  } %>

            <%//add refresh.gif after op mode column to refresh page
				if (columnField.equals("opMode")) {%>
                            <A HREF="<%=parent%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif" ALT="<bean:message key="refresh.view"/>" align="texttop" border="0" /></A>
			<%}%>

            <% if (!filterDisplay.equals("none")) {
                	if (columnField.equals(searchFilter)) { %>
                   		<HR SIZE="1"><bean:message key="quick.search.label"/>: <bean:write name="<%=formName%>" property="searchPattern" scope="session"/>
            <%		}
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
			Object scriptVars = null;
         boolean roleFilteringEnabled = true;
         if (wasVersion >= 7) {
			   scriptVars = new JSONObject();
			   if (request.getAttribute("role.filtering.disabled") != null)
				   roleFilteringEnabled = false;
         }
            %>

    <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">
    	<bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
    	<bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
   		<bean:define id="contextId" name="listcheckbox" property="contextId" type="java.lang.String"/>
		
                    <%
                        String primaryRole = null;
                        if (wasVersion >= 7) {
                           String contextId_detail = contextId.replaceFirst("dynamicclusters", "clusters");
                           primaryRole = ConfigFileHelper.getAssumedRole((Set)contextToRolesMap.get(contextId_detail));
                                          
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

		<TR class="table-row">
		<%
		if (showCheckBoxes.equals("true")) {
            if (!((wasVersion >= 7) && ("monitor".equals(primaryRole))) &&
         	   ( ConfigFileHelper.isDeleteable(refId) == true)) {
            	String delId = (String)resourceUri + "#" + (String) refId ;
            	String selectedObjectIds = "selectedObjectIds" + chkcounter;
		%>
				<TD VALIGN="top"  WIDTH="1%" HEADERS="header1">
				<% if ( !idColumn.equals("") ) { %>
                	<bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
                    <LABEL class="collectionLabel" for="<%=selectedObjectIds%>" TITLE="<bean:message key="select.text"/> <%=selectId%>">
                    	<html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectedObjectIds%>"/>	
				<%} else { %>
                    <LABEL class="collectionLabel" for="<%=selectedObjectIds%>" TITLE="<bean:message key="select.text"/> <%=refId%>">
                    	<html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectedObjectIds%>"/>
				<%}%>					
                    </LABEL>
                </TD>
		<% 	} else { %>

        	<TD VALIGN="top"  WIDTH="1%" HEADERS="header1"> &nbsp;</TD>
		<%  }
       	}
        %>
			<logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
				<%
					columnField = (String)cellItem.getColumnField();
				%>
				<TD NOWRAP VALIGN="top"  HEADERS="header2">
				<%
					if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0) {
				%>    		
						<IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="BASELINE"></IMG>&nbsp;
				<% 	}	
					
					if (cellItem.getLink().length() > 0) {
						String hRef = cellItem.getLink() + "&refId="+refId + "&contextId=" + contextId + "&resourceUri=" + URLEncoder.encode(resourceUri) + "&perspective=" + URLEncoder.encode(perspective);
				%>
                                               <A HREF="<%=hRef%>">
			    <%  }
			    	
			    	if (columnField.equalsIgnoreCase("status")) {
                                  String statusservlet = "/ibm/console/status";
                                  if(cellItem.getStatusServlet()!=null)
                                     statusservlet = cellItem.getStatusServlet();
                               %>
						<bean:define id="name" name="listcheckbox" property="name" />
							<%if (iterationName.equals("DynamicClusterCollectionForm")) {
                                                          String encodedStatusLink = statusservlet + "?text=true&type=cluster&name=" + URLEncoder.encode((String)name, "UTF-8");
                                                          String imageSrcLink = statusservlet + "?type=cluster&name=" + URLEncoder.encode((String)name, "UTF-8");
                                                       %>
                                                          <A target="statuswindow" href="<%=encodedStatusLink%>">
                                                          <IMG name="statusIcon" border="0" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' SRC="<%=imageSrcLink%>" TITLE="<%=statusAlt%>" ALT="<%=statusAlt%>">
							<%} else { %>
								<bean:define id="node" name="listcheckbox" property="node" />
                                                       <%
                                                          String encodedStatusLink = statusservlet + "?text=true&type=ClusterMember&memberName=" + URLEncoder.encode((String)name, "UTF-8") + "&node=" + node;
                                                          String imageSrcLink = statusservlet + "?type=ClusterMember&memberName=" + URLEncoder.encode((String)name, "UTF-8") + "&node=" + node;
                                                       %>
                                                          <A target="statuswindow" href="<%=encodedStatusLink%>">
                                                          <IMG name="statusIcon" border="0" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' SRC="<%=imageSrcLink%>" TITLE="<%=statusAlt%>" ALT="<%=statusAlt%>">
							<%}%>
						
				<%  } else if (columnField.equalsIgnoreCase("opMode")) {%>
							<bean:define id="dc" name="listcheckbox" property="name" />
							<bean:define id="ng" name="listcheckbox" property="serverType" />
							<% String opModeMsgKey = OpModeServlet.getOperationalModeStatic(request.getSession(), (String)dc); %>
							<IMG align="texttop" name="opmodeIcon" border="0" SRC="/ibm/console/opmode?ng=<%=ng%>&dc=<%=dc%>" onmouseover="showOpModeLegend(event)" onmouseout="hideOpModeLegend(event)"> 
                            <bean:message key="<%=opModeMsgKey%>"/>
						
				<% 	} else if (cellItem.getTranslate()) { %>
                    	<bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                   		<bean:message key="<%=prop %>"/>
				<%	} else { %>
                             <bean:write name="listcheckbox" property="<%=columnField%>"/>&nbsp;
				<%	}	%>
					
							
				<%  if (cellItem.getLink().length() > 0) { %>
						</A>
				<%	}  %>
				</TD>
			</logic:iterate>
		</TR>

    	<% chkcounter = chkcounter + 1; %>
                    <%
                        if (wasVersion >= 7) {
                           JSUtil.getScriptingContext(request).storeObject("collectionFilter", (JSONObject)scriptVars);
						
      						   //These are used for dynamically adding tooltips to disabled buttons
                           JSONObject roleNLS = new JSONObject();
                           roleNLS.put("administrator", statusMessages.getMessage(request.getLocale(), "role.administrator"));
                           roleNLS.put("operator", statusMessages.getMessage(request.getLocale(), "role.operator"));
                           roleNLS.put("configurator", statusMessages.getMessage(request.getLocale(), "role.configurator"));
                           roleNLS.put("monitor", statusMessages.getMessage(request.getLocale(), "role.monitor"));
                           roleNLS.put("deployer", statusMessages.getMessage(request.getLocale(), "role.deployer"));
                           roleNLS.put("button.disabled.desc", statusMessages.getMessage(request.getLocale(), "button.disabled.desc"));
                           JSUtil.getScriptingContext(request).storeObject("roleNLS", roleNLS);
                        }
					%>

	</logic:iterate>
	</TABLE>
	</fieldset>
</html:form>
<% } catch (Exception e) {e.printStackTrace();
} %>


    <%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) {
        out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'><tr class='table-row'><td>"+nonefound+"</td></tr></table>");
        }
    %>

