<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004,2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.error.*,com.ibm.ws.console.core.bean.*"%>
<%@ page import="com.ibm.ws.console.core.utils.StatusUtils" %>
<%@ page import="com.ibm.ws.console.core.breadcrumbs.Breadcrumb" %>
<%@ page import="com.ibm.ws.console.core.breadcrumbs.impl.BreadcrumbImpl" %>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>
<%@ page import="com.ibm.ws.console.core.item.PropertyItem" %>
<%@ page import="com.ibm.ws.console.core.utils.ConsoleUtils" %>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>
<ibmcommon:detectLocale/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">

<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<style type="text/css">
  @import "<%=request.getContextPath()%>/dojo/dijit/themes/tundra/tundra.css";
</style>

<style>
.fixUp { padding: 0.75em; }
</style>

<tiles:useAttribute name="tabList" classname="java.util.List" />
<tiles:useAttribute name="defaultSelectedTab" classname="java.lang.String" />

<title><bean:message key="xdruntime.operations" /></title>

<%
// Get the request locale so the appropriate dojo bundle is loaded.
// This would be needed when the IE language is different from the 
// language preferred for WVE. A  PMR had a Chinese/English scenario.
String thelocale = "";
if (request.getHeader("ACCEPT-LANGUAGE")==null) {
        thelocale = "en";
} else {
        thelocale = request.getHeader("ACCEPT-LANGUAGE").toLowerCase();
}

String[] theirlangs = thelocale.split(",");
String browserLocale = theirlangs[0];
        
int weight = browserLocale.indexOf(";q=");
if (weight > -1) {
   browserLocale = browserLocale.substring(0,weight).trim();
}

%>

<script language="JavaScript" src="/ibm/console/scripts/menu_functions.js"></script>
<script type="text/javascript">
	var dojoConfig = { isDebug: true, parseOnLoad: true, locale: "<%=browserLocale%>" };
</script>
<jsp:include page ="/secure/layouts/browser_detection.jsp" flush="true"/>

<jsp:include page = "/com.ibm.ws.console.xdcore/styles/customDojoStyles.jsp" flush="true"/>
</head>
<body>

<div class="customWASDojoTabLayout" role="main">
<div class="fixUp">

<ibmcommon:detectLocale />
<ibmcommon:getBreadcrumbs name="bc"/>

<script type="text/javascript">
dojo.require("dijit.layout.TabContainer");
dojo.require("dojox.layout.ContentPane");
</script>

<script type="text/javascript" language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/svgchart.js"></script>

<%
//Bug 9676: set attribute indicating tab/breadcrumb reset is ocurring
session.setAttribute("xd_bc_reset", "xdops");

MessageResources msgs = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);
//Bug 9833: The WAS base defaultBreadcrumbHandler looks for the attribute forwardName and the string .do before registering a the request.
//	Because of this we need to manually set the breadcrumb for a dojo tab switch.
String defaultTileDefinition = null;
String defaultTabNLSLabel = null;
//Bug 9143: Need to build attribute map of Tabs defind in the console defs.
//System.out.println("xdOperationsTabs.jsp:defaultSelectedTab: "+defaultSelectedTab);
HashMap mainTabAttributesMap = new HashMap();
for (Iterator i = tabList.iterator(); i.hasNext();) {
	PropertyItem propertyItem = (PropertyItem)i.next();
	String label = propertyItem.getLabel();
	mainTabAttributesMap.put(label, propertyItem.getAttribute());
	mainTabAttributesMap.put(label+"contextType", propertyItem.getType());
	
	//Bud 9833: getting correct tile definition to forward to.
	String tileDefinition = propertyItem.getRequired();
	//System.out.println("xdOperationsTabs.jsp:defaultSelectedTab: "+defaultSelectedTab);
	//System.out.println("xdOperationsTabs.jsp:label: "+label);
	//System.out.println("xdOperationsTabs.jsp:tileDefinition: "+tileDefinition);
	if (defaultSelectedTab.equals(label)) {
		defaultTileDefinition = tileDefinition;
		defaultTabNLSLabel = msgs.getMessage(request.getLocale(), label);
	}
	
	//System.out.println("xdOperationsTabs.jsp:defaultTileDefinition: "+defaultTileDefinition);
}

%>

<script>
var bidiLoaded = true;
var xdOperationsTabsHandles = [];

this.reloadChart = function (refId) {
    //console.debug('xdOperationsTabs.reloadChart:  refId'+ refId);
	if (dijit.byId(refId) && dijit.byId(refId).scriptScope.reload)
		dijit.byId(refId).scriptScope.reload();
}

this.disconnectTabs = function () {
	var reportingTab = dojo.byId("nav.reporting");
	//console.debug('xdOperationsTabs.disconnectTabs:  reportingTab'+ disconnectTabs);
	if (reportingTab) {
		if (reportingTab.scriptScope)
			reportingTab.scriptScope.disconnect();
	}
}

//Bug 9143: begin added functions to switch tabs manually
function getAttrIndex(jsLabel) {
  //console.debug('xdOperationsTabs.getAttrIndex:  jsLabel '+ jsLabel);
  var attr = "";
  <% 
  	 String masterKey = "";
  	 for (Iterator i = mainTabAttributesMap.keySet().iterator(); i.hasNext();) {
	   String key = (String)i.next();
	   %> if (jsLabel == "<%=key%>") {
	         attr = "<%=(String)mainTabAttributesMap.get(key)%>";
	      }
     <%}
  %>

  return attr;
}

function setMainTabContent () {
	//console.debug('[xdOperationsTabs.jsp].setMainTabContent: Entry');
	disconnectTabs();
	<%
		for (Iterator i = tabList.iterator(); i.hasNext();) {
			PropertyItem propertyItem = (PropertyItem)i.next();
			String label = propertyItem.getLabel();
	%>		var prevTab = dijit.byId("<%=label%>");
			//Double table entry issue
			if (prevTab && "<%=label%>" != "nav.xd.summmary") { 
				prevTab.set("content", "<p></p>"); 
			} 
	<%	} %>

	var mainTabContainer = dijit.byId("mainTabContainer");
	if (mainTabContainer) {
   		//console.debug("[xdOperationsTabs.jsp].setMainTabContent:selectedTab: "+mainTabContainer.selectedChildWidget.id);
   		if (mainTabContainer.selectedChildWidget.id != "nav.xd.summmary") {
			var refId = mainTabContainer.selectedChildWidget.id;
			//console.debug('[xdOperationsTabs.jsp].setMainTabContent:found selected tab refId: ['+refId+']');
			var attr = getAttrIndex(refId);
			var contextType = getAttrIndex(refId+"contextType");
			
			//console.debug('[xdOperationsTabs.jsp].setMainTabContent:attr: ['+attr+']');
			//console.debug('[xdOperationsTabs.jsp].setMainTabContent:contextType: ['+contextType+']');
			if (contextType != "") {
				var url = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/insertTileLayout.jsp?attr=" + attr + "&contextType=" + contextType + "&scopeChanged=true";
				//console.debug('[xdOperationsTabs.jsp].setMainTabContent:url: ['+url+']');
				try {
					if (refId != "nav.xd.summmary") {
						bidiLoaded = false;
						//console.debug('[xdOperationsTabs.jsp].setMainTabContent:setting up new tab:['+refId+']');
						mainTabContainer.selectedChildWidget.set("href", url);
					} //else {
					    //console.debug('[xdOperationsTabs.jsp].setMainTabContent:skip reloading of tab:['+refId+']');
					//}
				} catch (e) { 
					//console.debug('[xdOperationsTabs.jsp].setMainTabContent:e:['+e+']'); 
				}
			}
   		}
   		
   		<%
			//Bug 9676: resetting breadcrumb each time new tab is visited	   		
			String link = request.getContextPath()+"/com.ibm.ws.console.xdoperations.forwardCmd.do?forwardName="+defaultTileDefinition+"&WSC=true";
	   		Breadcrumb crumb = new BreadcrumbImpl(defaultTabNLSLabel, link, defaultTabNLSLabel+link, defaultTabNLSLabel+link);
	   		//System.out.println("xdOperationsTabs.jsp:title: "+defaultTabNLSLabel);
	   		//System.out.println("xdOperationsTabs.jsp:link: "+link);
	   		java.util.List l = new java.util.ArrayList();
	   		l.add(crumb);		   			
			com.ibm.ws.console.core.breadcrumbs.BreadcrumbHelper.setBreadcrumbTrail(request, l);
   		%>
   		//console.debug("[xdOperationsTabs.jsp].setMainTabContent:exit");
		//dojo.disconnect(mainTabContainer, "selectChild", "setMainTabContent");
	}
}


function buildUpEvents() {
	//console.debug('[xdOperationsTabs.jsp].buildUpEvents: Entry');
	var mainTabContainer = dijit.byId("mainTabContainer");
	if (mainTabContainer) {
		//console.debug('[xdOperationsTabs.jsp].buildUpEvents:connection to mainTabConainter');
		//load first tab when XD tab is selected
		xdOperationsTabsHandles.push(dojo.connect(mainTabContainer, "selectChild", "setMainTabContent"));
		//console.debug('[xdOperationsTabs.jsp].buildUpEvents:connection to mainTabConainter done');
	} else {
	    //console.debug('[xdOperationsTabs.jsp].buildUpEvents:already connected to mainTabContainer');
		setMainTabContent();
		//console.debug('[xdOperationsTabs.jsp].buildUpEvents:already connected to mainTabContainer done');
	}
}

function tearDownEvents() {
	//console.debug('[xdOperationsTabs.jsp].tearDownEvents entry');
	disconnectTabs();
	var tabContainer = dijit.byId("mainTabContainer");
	if (tabContainer) {
		dojo.forEach(xdOperationsTabsHandles, dojo.disconnect);
	}
	//console.debug('[xdOperationsTabs.jsp].tearDownEvents exit');
}

dojo.ready(buildUpEvents);
dojo.addOnUnload(tearDownEvents);
//Bug 9143: end added functions to switch tabs manually
</script>

<%!
  private boolean isDmgr = StatusUtils.isND();
%>

<%
String contextId = (String)request.getAttribute("contextId");
if (contextId == null) {
    contextId = "nocontext";
}
AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

try {

String pleaseWait = msgs.getMessage(request.getLocale(), "trace.tree.pleaseWaitLabel");
pleaseWait.replaceAll("'", "\\\\'");
%>

<%
	WorkSpace workSpace = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
    UserPreferenceBean userBean = (UserPreferenceBean)session.getAttribute(com.ibm.ws.console.core.Constants.USER_PREFS);

	if (workSpace != null) {
		if (workSpace.getModifiedList().size() > 0) {
            String uri = (String)request.getAttribute("javax.servlet.forward.request_uri");
			if (uri.indexOf("syncworkspace.do") == -1 && uri.indexOf("logoff.do") == -1) {
		        java.util.Locale locale = (java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
	    	    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
                    boolean noOverwrite = (request.getSession().getAttribute (com.ibm.ws.console.core.Constants.NO_OVERWRITE_KEY) != null);
				if((!com.ibm.ws.security.core.SecurityContext.isSecurityEnabled() || 
					(adminAuthorizer.checkAccess(contextUri, "administrator") || adminAuthorizer.checkAccess (contextUri, "adminsecuritymanager") || 
					 adminAuthorizer.checkAccess(contextUri, "configurator"))) && !noOverwrite){
					IBMErrorMessage errorMessage1 = IBMErrorMessages.createWarningMessage(locale, messages, "warning.config.changes.made", null);
	                //LIDB3795-28 Added direct "Save" link and "Preferences" link under messages
	                IBMErrorMessage errorMessage2 = null;
	                if(userBean.getProperty("System/workspace", "syncWithNodes", "false").equalsIgnoreCase("true"))
	                   errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.disabled", null);
	                else
	                    errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.enabled", null);
					IBMErrorMessage errorMessage3 = null;
					if(ConsoleUtils.requiresServerRestart(workSpace.getModifiedList())){
						errorMessage3 = IBMErrorMessages.createWarningMessage(locale, messages, "info.restart.server", null);
					}
		        	Object obj = request.getAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY);
		        	if (obj == null || !(obj instanceof IBMErrorMessage[])) {
						obj = new IBMErrorMessage[0];
					}
		        	IBMErrorMessage[] errorArray = (IBMErrorMessage[])obj;
	        		List newErrorArray = new Vector();
		       		newErrorArray.add(errorMessage1);
                                if (this.isDmgr) {
          	        		newErrorArray.add(errorMessage2);
                                }
					if(errorMessage3!=null){
	                	newErrorArray.add(errorMessage3);
					}
					newErrorArray.addAll(Arrays.asList(errorArray));
			        request.setAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY, (IBMErrorMessage[]) newErrorArray.toArray(new IBMErrorMessage[newErrorArray.size()]));
				}
		    }
		}
	}
%>
<ibmcommon:errors/>

<tiles:insert name="operations.chart.status.messages" flush="true"/>

<div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width: 100%;" doLayout="false" selectedChild="<%=defaultSelectedTab%>" lang="<%=request.getLocale().toString().replace('_', '-')%>" dir="ltr" role="region" aria-label="Runtime Operations">
	<% int count=0; %>
	<% for (Iterator i = tabList.iterator(); i.hasNext();) {
			//System.out.println("xdOperationsTabs::count: " + count);
			PropertyItem propertyItem = (PropertyItem)i.next();
			String label = propertyItem.getLabel();
			String attribute = propertyItem.getAttribute(); 
			//Bug 9143: add defaultSelectTab check to only get contextType from the selected nav item.
			if (defaultSelectedTab.equals(label) && !propertyItem.getType().equals("")) {
				//System.out.println("xdOperationsTabs:: type=" + propertyItem.getType());
				request.setAttribute("contextType", propertyItem.getType());
			}
			//System.out.println("xdOperationsTabs:: property=" + label + " attr=" + attribute);
			count++;
	%>

		<% if (defaultSelectedTab.equals(label)) { %>
			<div id="<%=label%>" style="display: none; overflow: auto;" widgetId="<%=label%>" dojoType="dojox.layout.ContentPane" 
				 title="<bean:message key="<%=label%>"/>" scriptSeparation="false" executeScripts="true" refreshOnShow="false" 
				 loadingMessage="<%=pleaseWait%>" adjustPaths="false" cacheContent="false" selected="true" role="region" aria-label="<bean:message key="<%=label%>"/>">
			    <% //Bug 9143: add defaultSelectTab check to only load selected nav item.
			       if ((defaultSelectedTab.equals(label) || label.equals("nav.xd.summmary"))
			    		   && !attribute.equals(" ") && !attribute.equals("")) {
			    	//if (attribute.equals("xdoperations.chart.main")) 
			    		//request.setAttribute("contextType","XDOperations");
			    %>
					<tiles:insert name="<%=attribute%>" flush="true" />
				<% } %>
			</div>
		<% } else { %>
			<div id="<%=label%>" style="display: none; overflow: auto;" widgetId="<%=label%>" dojoType="dojox.layout.ContentPane" 
				 title="<bean:message key="<%=label%>"/>" scriptSeparation="false" executeScripts="true" refreshOnShow="false" 
				 loadingMessage="<%=pleaseWait%>" adjustPaths="false" cacheContent="false" role="region" aria-label="<bean:message key="<%=label%>"/>">
			    <% //Bug 9143: add defaultSelectTab check to only load selected nav item.
			       if ((defaultSelectedTab.equals(label) || label.equals("nav.xd.summmary"))
			    		   && !attribute.equals(" ") && !attribute.equals("")) {
			    	//if (attribute.equals("xdoperations.chart.main")) 
			    		//request.setAttribute("contextType","XDOperations");
			    %>
					<tiles:insert name="<%=attribute%>" flush="true" />
				<% } %>
			</div>
		<% } %>
   <% } %>
			
</div>
<% } catch (Exception e) {e.printStackTrace();} %>
<% //Bug 9676: remove attribute indicating tab/breadcrumb reset is ocurring
   session.removeAttribute("xd_bc_reset");
%>

</div> <!--the fixUp div -->
</div>
</body>
</html:html>
