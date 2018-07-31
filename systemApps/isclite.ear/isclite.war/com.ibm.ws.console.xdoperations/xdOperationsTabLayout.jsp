<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004,2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources"%>
<%@ page language="java" import="org.apache.struts.action.Action"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.console.core.item.PropertyItem" %>
<%@ page import="com.ibm.ws.console.xdoperations.util.Constants" %>
<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute id="list" name="list" classname="java.util.List" />
<tiles:useAttribute name="defaultSelectedTab" classname="java.lang.String" />
<tiles:useAttribute name="tabContainerName" classname="java.lang.String" />
<tiles:useAttribute name="hideDojoScripts" ignore="true" classname="java.lang.String" />
<tiles:useAttribute name="contextType" ignore="true" classname="java.lang.String"/>

<style type="text/css">
  @import "<%=request.getContextPath()%>/dojo/dijit/themes/tundra/tundra.css";
</style>
<jsp:include page = "/com.ibm.ws.console.xdcore/styles/customDojoStyles.jsp" flush="true"/>

<script type="text/javascript" language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.taskmanagement/collectiontable.js"></script>

<script type="text/javascript">
<!-- unsetting global event handlers that get set in menu_fuction.js  -->
document.onclick = "";
document.onmouseover = "";
document.onmouseout = "";
document.onmouseup = "";
window.onload = "";
window.onscroll="";
window.onresize = "";
</script>

<%
try {

MessageResources msgs = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);
String pleaseWait = msgs.getMessage(request.getLocale(), "trace.tree.pleaseWaitLabel");
pleaseWait.replaceAll("'", "\\\\'");

//System.out.println("xdOperationsTabLayout:: contextType=" + contextType);
request.setAttribute("contextType", contextType);
String scopeChanged = (String) request.getAttribute("scopeChanged");

	String customDefaultSelectedTab = (String)request.getSession().getAttribute(Constants.DEFAULTTAB_REQUEST_KEY);
	if (customDefaultSelectedTab != null) {
		for (Iterator i = list.iterator(); i.hasNext();) {
			PropertyItem propertyItem = (PropertyItem)i.next();
			if (propertyItem.getLabel().equals(customDefaultSelectedTab)) {
				defaultSelectedTab = customDefaultSelectedTab;
			}
		}
		request.getSession().removeAttribute(Constants.DEFAULTTAB_REQUEST_KEY);
	}

int selectedIndex = 0;
%>

<ibmcommon:detectLocale />

<script type="text/javascript">
	dojo.require("dijit.layout.TabContainer");
	dojo.require("dijit.layout.ContentPane");
</script>

<script type="text/javascript">
//Bug 9143: need to change variable name b/c it is being used in other layouts.
var tileDefinition = new Object();
<%
int count = 0;
for (Iterator i = list.iterator(); i.hasNext();) {
	PropertyItem propertyItem = (PropertyItem)i.next();
	String label = propertyItem.getLabel();
	String attribute = propertyItem.getAttribute(); 
	if (label.equals(defaultSelectedTab))
		selectedIndex = count;
%>
	//console.debug("[xdOperationsTabLayout.jsp].main:attribute: <%=attribute%>");
    tileDefinition['<%=count++%>'] = '<%=attribute%>';   
<%}%>

var jsIndex = <%=selectedIndex%>;
var xdOperationsTabLayoutHandles = [];

function switchTab () {
    //console.debug('[xdOperationsTabLayout.jsp].switchTab: Start');
	var tabContainer = dijit.byId("<%=tabContainerName%>TabContainer");
	var prevTab = dijit.byId("tab" + jsIndex);
	if (prevTab) {
		//console.debug('[xdOperationsTabLayout.jsp].switchTab:found previous tab: ' + prevTab);
		prevTab.set('content', "<p></p>");
	}		
	var selectedTab = tabContainer.selectedChildWidget;
	var refId = selectedTab.id;
	var index = refId.substring(3);
	jsIndex = index;
	var attr = tileDefinition[index];
	//console.debug('[xdOperationsTabLayout.jsp].switchTab: attr = '+attr);
	var url = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/insertTileLayout.jsp?attr=" + attr + "&contextType=<%=contextType%>&scopeChanged=<%=scopeChanged%>";
	//console.debug('[xdOperationsTabLayout.jsp].switchTab:url = '+url);
	selectedTab.set("onDownloadEnd", function() {
    	if (typeof bidiOnLoad == "function")
		    bidiOnLoad();
		if (typeof ariaOnLoadTop == "function")
		    ariaOnLoadTop();
	});
	selectedTab.set('href', url);
}

function setTabContent () {
	//console.debug("[xdOperationsTabLayout.jsp].setTabContent: Start");

	//load stability icon
	var icon = dojo.byId("stabilityIcon");
	if (icon) {
		//console.debug('[xdOperationsTabLayout.jsp].setTabContent:found icon');
		icon.src = "opsstability";
	}
	var tabContainer = dijit.byId("<%=tabContainerName%>TabContainer");
	//console.debug("[xdOperationsTabLayout.jsp].setTabContent:tabContainer:"+tabContainer);
	if (tabContainer) {
		//console.debug('[xdOperationsTabLayout.jsp].setTabContent:found tab container:'+tabContainer.id);
		var selectedTab = tabContainer.selectedChildWidget;
		//console.debug("[xdOperationsTabLayout.jsp].setTabContent:selectedTab:"+selectedTab);
		if (selectedTab) {
			
			var refId = selectedTab.id;
			var index = refId.substring(3);
			var attr = tileDefinition[index];

			var url = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/insertTileLayout.jsp?attr=" + attr + "&contextType=<%=contextType%>";
			//console.debug('[xdOperationsTabLayout.jsp].setTabContent:url: '+url);
			try {
				selectedTab.set("onDownloadEnd", function() {
					if (typeof bidiOnLoad == "function")
					   bidiOnLoad();
			        if (typeof ariaOnLoadTop == "function")
			            ariaOnLoadTop();
			    });
				selectedTab.set('href', url);
			} catch (e) { 
                console.debug("Exception in setTabContent:"+e); 
            }
		}
	}
	//console.debug("[xdOperationsTabLayout.jsp].setTabContent: Exit");
}

function disconnectEvents() {
	//console.debug("[[xdOperationsTabLayout.jsp].disconnectEvents:Entry");
	var tabContainer = dijit.byId("<%=tabContainerName%>TabContainer");
	//console.debug("[[xdOperationsTabLayout.jsp].disconnectEvents:tabContainer: "+tabContainer);
	if (tabContainer) {
		dojo.forEach(xdOperationsTabLayoutHandles, dojo.disconnect);
	}
	//console.debug("[[xdOperationsTabLayout.jsp].disconnectEvents:Exit");
}

dojo.ready(function() {
    //console.debug("[xdOperationsTabLayout.jsp].ready:Entry");
  <% if (!contextType.equals("XDOperations")) { %>
    var tc = new dijit.layout.TabContainer({
        id:"<%=tabContainerName%>TabContainer",
        selectedChild:"tab<%=selectedIndex%>",
        style: "height: 100%;"
    }, "tabPane");

    <% int idx = 0; %>
    <% for (Iterator i = list.iterator(); i.hasNext();) {
        PropertyItem propertyItem = (PropertyItem)i.next();
        String label = propertyItem.getLabel();
    %>
        var cp = new dijit.layout.ContentPane({
            id:"tab<%=idx%>",
            title:"<%=msgs.getMessage(request.getLocale(), label)%>",
            loadingMessage:"<%=pleaseWait%>", 
            preload:"false", 
            refreshOnShow:"false", 
            extractContent:"false", 
            selected:"true"
        });
        <% if (idx == selectedIndex) { %>
            cp.selected = "true";
        <% } %>
        tc.addChild(cp);
        <%idx++;%>
    <% } %>

    tc.startup();
    tc.resize();
  <% } %>

	var tabContainer = dijit.byId("<%=tabContainerName%>TabContainer");
	if (tabContainer) {
		setTabContent();
		xdOperationsTabLayoutHandles.push(dojo.connect(tabContainer, "selectChild", "switchTab"));
	}
	//console.debug("[xdOperationsTabLayout.jsp].ready:Exit");
});

dojo.addOnUnload(disconnectEvents);

</script>

<br>
<% if (contextType.equals("XDOperations")) { %>
<div class="customWASDojoTabLayout">
<div id="<%=tabContainerName%>TabContainer" dojoType="dijit.layout.TabContainer" style="width: 100%;" doLayout="false" 
     selectedChild="tab<%=selectedIndex%>" lang="<%=request.getLocale().toString().replace('_', '-')%>" dir="ltr" 
     role="region" aria-label="Operations">
	<%
	int index = 0;
	for (Iterator i = list.iterator(); i.hasNext();) {
		PropertyItem propertyItem = (PropertyItem)i.next();
		String label = propertyItem.getLabel();
		String attribute = propertyItem.getAttribute(); %>
		
		<% if (label.equals(defaultSelectedTab)) { %>
		<div id="tab<%=index%>" style="display: none; overflow: auto;" widgetId="tab<%=index%>" 
		     dojoType="dijit.layout.ContentPane" title="<bean:message key="<%=label%>"/>" 
		     scriptSeparation="false" parseContent="false" cacheContent="false" adjustPaths="false" 
		     preload="false" executeScripts="true" refreshOnShow="false" loadingMessage="<%=pleaseWait%>" 
		     extractContent="false" selected="true" >
		</div>
		<% } else { %>
		<div id="tab<%=index%>" style="display: none; overflow: auto;" widgetId="tab<%=index%>" 
		     dojoType="dijit.layout.ContentPane" title="<bean:message key="<%=label%>"/>" 
		     scriptSeparation="false" parseContent="false" cacheContent="false" adjustPaths="false" 
		     preload="false" executeScripts="true" refreshOnShow="false" loadingMessage="<%=pleaseWait%>" 
		     extractContent="false" >
		</div>
		<% } %>
	<% index++;
	} %>
</div>
<% } else { %>
<div class="customWASDojoTabLayout" style="width:100%; height:350px">
    <div id="tabPane">
</div>
<% } %>

<% } catch (Exception e) {e.printStackTrace();} %>

</div>
