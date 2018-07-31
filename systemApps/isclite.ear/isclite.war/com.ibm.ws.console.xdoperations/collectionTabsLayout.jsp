<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004,2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.User" %>
<%@ page import="com.ibm.ws.console.xdoperations.chart.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.*"%>
<%@ page import="com.ibm.ws.xd.visualizationengine.cacheservice.util.*"%>

<%@ page errorPage="error.jsp"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="selectUri" classname="java.lang.String" />
<tiles:useAttribute name="detailFormAction" classname="java.lang.String" />
<tiles:useAttribute name="detailFormName" classname="java.lang.String" />
<tiles:useAttribute name="detailFormType" classname="java.lang.String" />

<ibmcommon:detectLocale />

<%
    User user = (User) request.getSession().getAttribute(com.ibm.ws.console.core.Constants.USER_KEY);
    String userId = user.getUserID();
    userId = userId.replaceAll("'", "");
    
    String currWindow = (String) request.getAttribute("currWindow");
    String contextType=(String)request.getAttribute("contextType");
    String csrfIdValue = (String)session.getAttribute("com.ibm.ws.console.CSRFToken");
    //System.out.println("collectionTabsLayout:: contextType=" + contextType);
	//System.out.println("collectionTabsLayout:: currWindow=" + currWindow);
%>

<style type="text/css">
  @import "<%=request.getContextPath()%>/dojo/dijit/themes/tundra/tundra.css";
</style>
<jsp:include page = "/com.ibm.ws.console.xdcore/styles/customDojoStyles.jsp" flush="true"/>

<% if (!contextType.equals("XDOperations")) { %>
<script type="text/javascript" src="<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/svgchart.js"></script>
<% } %>

<script type="text/javascript">
    dojo.require("dijit.layout.TabContainer");
    dojo.require("dojox.layout.ContentPane");
</script>

<script type="text/javascript">		
if (window.itsmozillacompat > 0 && window.itsgecko > 0) {
 	document.all = false;
}

var user = '<%=userId%>';
var currwindow = '<%=currWindow%>';
var detailActionUrl = '<%=response.encodeURL(request.getContextPath() + "/" + detailFormAction)%>';
var chartCollectionUrl = '<%=response.encodeURL(request.getContextPath() + "/" + formAction)%>';

var CHART_TAB = '<bean:message key="open.chart.tab"/>';
var CHART_WINDOW= '<bean:message key="open.chart.window"/>';
var CHART_LAUNCH= '<bean:message key="launch.current.chart"/>';

var collectionTabsHandles = [];
var bidiLoaded = (typeof bidiLoaded === 'undefined') ? true : bidiLoaded;
</script>

<%MessageResources msgs = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);%>

<%!
String getTranslatedPopup(MessageResources msgs, HttpServletRequest request, String scope, String name, String subdomain, String metric, String type) {
	String scopekey = "scope." + scope + ".name";
	if (scope.equals(CacheConstants.SCOPES[CacheConstants.NODE]))
		scopekey = "label.node";
	String transscope = msgs.getMessage(request.getLocale(), scopekey);
	String transname = name;
	if (name.trim().equals("-- Select Name --"))
		transname = msgs.getMessage(request.getLocale(), "select.name");

	String transtype = msgs.getMessage(request.getLocale(), "type." + type + ".name");
	String scopelabel = msgs.getMessage(request.getLocale(), "data.scope");
	String namelabel = msgs.getMessage(request.getLocale(), "data.name");
	String typelabel = msgs.getMessage(request.getLocale(), "chart.type");

	String popupString = "<b>" + scopelabel + "</b> " + transscope + "<br>";
	popupString += "<b>" + namelabel + "</b> " + transname + "<br>";
	popupString += "<b>" + typelabel + "</b> " + transtype + "<br>";

	return popupString;
}

String escape(String str) {
	if (str == null)
		return str;
	String autoinstall = "<a href=\"'+ svgAutoInstallPage+'\">";
	String adobepage = "<a href=\"'+adobeSVGPage+'\">";

	if (str.indexOf(autoinstall) > -1) {
		int index = str.indexOf(autoinstall);
		String firststr = str.substring(0, index);
		String secondstr = str.substring(index + autoinstall.length());
		return (firststr.replaceAll("'", "\\\\'") + autoinstall + secondstr.replaceAll("'", "\\\\'"));
	} else if (str.indexOf(adobepage) > -1) {
		int index = str.indexOf(adobepage);
		String firststr = str.substring(0, index);
		String secondstr = str.substring(index + adobepage.length());
		return (firststr.replaceAll("'", "\\\\'") + adobepage + secondstr.replaceAll("'", "\\\\'"));
	}
	return str.replaceAll("'", "\\\\'");
}

String getString(String key, org.apache.struts.util.MessageResources msgs, HttpServletRequest request) {
	String str = msgs.getMessage(request.getLocale(), key);
	return escape(str);
}
%>

<bean:define id="tabTable" name="<%=iterationName%>" property="tabTable" type="java.util.Hashtable" />
<bean:define id="targets" name="<%=iterationName%>" property="targets" type="java.util.Hashtable" />
<bean:define id="chartGroup" name="<%=iterationName%>" property="chartGroup" type="java.lang.String" />

<%
String rname = Utils.getResourceName(session, contextType);
String target = contextType + Constants.DATASET_NAME_SEPARATOR + currWindow;
if (rname.length() > 0) 
	target = contextType + Constants.DATASET_NAME_SEPARATOR + rname + Constants.DATASET_NAME_SEPARATOR + currWindow;


ChartDetailForm selectedForm = null;
String selectedRefId = "";

//System.out.println("collectionTabsLayout:: chartGroup=" + chartGroup);
//System.out.println("collectionTabsLayout:: target=" + target);
ArrayList tabs = (ArrayList) tabTable.get(target);
selectedRefId = (String) targets.get(target);
//System.out.println("selectedRefId=" + selectedRefId);

String pleaseWait = getString("trace.tree.pleaseWaitLabel", msgs, request);
%>

<script>
var selectedRefId = "<%=selectedRefId%>";
var isReloading = false;
this.reloadChart = function (refId) {
	//console.debug('collectionTabsLayout.jsp].reloadChart: refId =' + refId);
    if (dijit.byId(refId) && dijit.byId(refId).scriptScope.reload) {       
        isReloading = true;
        dijit.byId(refId).scriptScope.reload();
		//console.debug('collectionTabsLayout.jsp].reloadChart: true');
        isReloading = false;
    }
	//console.debug('collectionTabsLayout.jsp].reloadChart: refId =' + refId);
}

this.switchTabs = function () {
	//console.debug('[collectionTabsLayout.jsp].switchTabs: Entered');
	var tabContainer = dijit.byId("chartTabContainer");
	var prevTab = dijit.byId(selectedRefId);
	//console.debug('[collectionTabsLayout.jsp].switchTabs:tabContainer:'+tabContainer);
	if (prevTab) {
		//console.debug('[collectionTabsLayout.jsp].main:prevTab.id:'+prevTab.id);
		prevTab.set("content", "<p>Chart</p>");
	}
	var selectedTab = tabContainer.selectedChildWidget;
	var refId = selectedTab.id;
	uriState = "TargetServlet?switchTabs=true&refId=" + refId + "&contextType=<%=contextType%>&currWindow=<%=currWindow%>";
	setState = scriptScope.doXmlHttpRequest(uriState);
	selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>");    
	selectedRefId = refId;
	//console.debug('[collectionTabsLayout.jsp].switchTabs: Exit selectedRefId:' + selectedRefId);
}

this.doXmlHttpRequest = function (sUri) {
	//console.debug('[collectionTabsLayout.jsp].doXmlHttpRequest:entry - sUri = ' + sUri);
    var isMoz = false;
    var mozLoaded = false;
    var xmlhttp = null;
    var xmlDoc = null;
    if (window.ActiveXObject) {
        try {
            xmlhttp = new ActiveXObject('Msxml2.XMLHTTP');
        } catch (e1) {
            try {
                xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
            } catch (e2) {
                // Ignore
            }
        }
    } else if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    }

    if (xmlhttp) {
        // Add random number parameter to try generating a unique URL 
        // to avoid getting a cached result which is a problem in IE
        sUri += '&_random_=' + Math.floor(Math.random() * 10000);
        xmlhttp.open('GET', sUri, false);
        xmlhttp.send(null);
        xmlDoc = xmlhttp.responseText;
        mozLoaded = true;
    }
    //console.debug('[collectionTabsLayout.jsp].doXmlHttpRequest: Exit - xmlhttp = ' +xmlhttp);
    return xmlDoc;
}

this.openNewChart = function () {
	var location = "TargetServlet?openTab=true&contextType=<%=contextType%>&scope=cell&name=-- Select Name --&subdomain=sc&metric=rt&type=line&yaxis2=none&filter=none&currWindow=" + currwindow;
	setState = this.doXmlHttpRequest(location);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
	//console.debug('[collectionTabsLayout.jsp].openNewChart:setState=' + setState);
	var refId = setState.substring(0,setState.indexOf(":"));
	var label = setState.substring(setState.indexOf(":")+1);
	//console.debug('[collectionTabsLayout.jsp].openNewChart:refId=' + refId + ' label=' + label);
	
	var newTab = new dojox.layout.ContentPane({ 
		widgetId:refId,
		id:refId, 
		title:label, 
		style: "overflow: auto;", 
		preload:"false", 
		cacheContent:"false", 
		refreshOnShow:"false", 
		executeScripts:"true", 
		closable:"true", 
		loadingMessage:"<%=pleaseWait%>", 
		adjustPaths:"false", 
		parseContent:"false", 
		extractContent:"false" 
	});
	
	var tabContainer = dijit.byId("chartTabContainer");
	if (tabContainer) {
		tabContainer.addChild(newTab);
		tabContainer.selectChild(newTab);
		var prevTab = dijit.byId(selectedRefId);
		if (prevTab) 
			prevTab.set("setContent", "<p>Chart</p>");
		this.setContent();
		selectedRefId = refId;
	}
	//window.location = chartCollectionUrl + "?new=true&contextType=<%=contextType%>&scope=cell&name=-- Select Name --&subdomain=sc&metric=rt&type=line&yaxis2=none&filter=none&currWindow=" + currwindow;
}

this.launchChart = function () {
    //console.debug('[collectionTabsLayout.jsp].launchChart: entry');
    var tabContainer = dijit.byId("chartTabContainer");
    //console.debug('[collectionTabsLayout.jsp].launchChart: tabContainer' + tabContainer);
    var selectedTab = tabContainer.selectedChildWidget;
    if (selectedTab) {
        //console.debug('[collectionTabsLayout.jsp].launchChart: selectedTab' + selectedTab);
        var refId = selectedTab.id;
        var newWinName = user + 'graphFrame' + Math.round(Math.random()*100);
        var features = "height=700,width=700,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
        var parentWin = currwindow;
        var url = "TargetServlet?launchChart=" + refId + "&currWindow=" + parentWin + "&newWindow=" + newWinName + "&contextType=<%=contextType%>";
        setState = scriptScope.doXmlHttpRequest(url);
        tabContainer.closeChild(selectedTab); // Close tab
    	
        // Wait if a chart is currently reloading
        var date = new Date();
        var mins = date.getMinutes();
        var newmins = mins;
        while (newmins < mins + 1) {
            if (!isReloading) {
                var chartFormat = '';
                var defaultChartFormat = dojo.byId('defaultChartFormat');
                if (defaultChartFormat) {
                	chartFormat = defaultChartFormat.options[defaultChartFormat.selectedIndex].value;
                }
                var singleChartURL = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>&currWindow=" + newWinName + "&originalWindow=" + parentWin + "&single=true&chartFormat=" + chartFormat;
                //console.debug('[collectionTabsLayout.jsp].launchChart: url = ' + singleChartURL);
                var newWin = window.open(singleChartURL, newWinName, features, parentWin);
                break;
            }
            tmp = new Date();
            newmins = tmp.getMinutes();
        }
    }
    //console.debug('[collectionTabsLayout.jsp].launchChart: exit');
}

this.closeTab = function (tab) {
	//console.debug('collectionTabsLayout.jsp].closeTab: entry');
	var refId = tab.id;
	//var refId = tab.widgetId;
	uriState = "TargetServlet?closeTab=" + refId + "&currWindow=" + currwindow + "&contextType=<%=contextType%>";
	setState = scriptScope.doXmlHttpRequest(uriState);
	selectedRefId = setState.substring(0,setState.indexOf("+endTransmission"));
	//console.debug('collectionTabsLayout.jsp].closeTab: exit');
}

this.disconnectTabs = function () {
	//console.debug('collectionTabsLayout.jsp].disconnectTabs: entry');
	scriptScope.disconnect();
	//console.debug('collectionTabsLayout.jsp].disconnectTabs: exit');
}

this.disconnect = function () {
	//console.debug('[collectionTabsLayout.jsp].disconnect: entry');
	var tabContainer = dijit.byId("chartTabContainer");
	if (tabContainer) {
		dojo.forEach(collectionTabsHandles, dojo.disconnect);
	}
	//console.debug('[collectionTabsLayout.jsp].disconnect: exit');
} 

this.setContent = function () {
	//console.debug('[collectionTabsLayout.jsp].setContent: entry');
	var tabContainer = dijit.byId("chartTabContainer");
	if (tabContainer) {
		//console.debug('[collectionTabsLayout.jsp].setContent: found tab container ' + tabContainer);
		var selectedTab = tabContainer.selectedChildWidget;
		if (selectedTab) {
			var refId = selectedTab.id;
			//console.debug('[collectionTabsLayout.jsp].setContent: refId = ' + refId);
			selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>");
		} else {
			//no initial tab, need to create it and then do stuff. 
			scriptScope.openNewChart();
		}
	}
	//console.debug('[collectionTabsLayout.jsp].setContent: exit');
}

function init() {
	var tabContainer = dijit.byId("chartTabContainer");
	if (tabContainer) {
		scriptScope.setContent();
		collectionTabsHandles.push(dojo.connect(tabContainer, "selectChild", scriptScope, "switchTabs"));
		collectionTabsHandles.push(dojo.connect(tabContainer, "removeChild", scriptScope, "closeTab"));
	} else {
	 	setTimeout(init, "50");
	}
}

var scriptScope = this;
if(typeof _container_ == 'undefined'){
	var _container_ = dojo;
}

dojo.ready(function() {
  <% if (!contextType.equals("XDOperations")) { %>
    var tc = new dijit.layout.TabContainer({
        id:"chartTabContainer",
        style: "height: 100%; width: 100%;"
    }, "tabContainer");
    
    <% for (int t = 0; t < tabs.size(); t++) {
        ChartDetailForm tab = (ChartDetailForm) tabs.get(t);
        String refId = tab.getRefId();
        String displayName = tab.getDisplayName();
        String href = "";
        if (selectedRefId.equalsIgnoreCase(refId)) {
            selectedForm = tab;
            request.getSession().setAttribute("ChartDetailForm", selectedForm);
            href = request.getContextPath() + "/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=" + contextType;
        }
        
        String label = displayName;
        if (displayName.trim().equals("-- Select Name --")) {
            label = getString("select.name", msgs, request);
        } else if (displayName.trim().equals("-- Select an application/EJB pair --")) {
            label = getString("select.app.ejb.pair", msgs, request);
        }
    %>
        var cp = dojox.layout.ContentPane({
            id:"<%=refId%>",
            title:"<%=label%>",
            loadingMessage:"<%=pleaseWait%>", 
            preload:"false", 
            refreshOnShow:"false",
            cacheContent:"false",
            executeScripts:"true",
            closeable:"true",
            adjustPaths:"false", 
            parseContent:"false", 
            extractcontent:"false"
        });
        tc.addChild(cp);
    <% } %>
    
    tc.startup();
    tc.resize();
  <% } %>
    init();
});
</script>

<script>
function saveChartGroup () {
	scriptScope.disconnect();
	var group = dijit.byId('chartGroup');
	window.location = chartCollectionUrl + "?saveChartGroup=true&contextType=<%=contextType%>&chartGroup=" + group.value
         + "&csrfid=" + "<%=csrfIdValue%>";
}

function switchChartGroup(cg) {
	scriptScope.disconnect()
	window.location = chartCollectionUrl + "?switchChartGroup=true&contextType=<%=contextType%>&chartGroup=" + cg
         + "&csrfid=" + "<%=csrfIdValue%>";
}

function removeChartGroup(cg) {
	scriptScope.disconnect()
	window.location = chartCollectionUrl + "?removeChartGroup=true&contextType=<%=contextType%>&chartGroup=" + cg
         + "&csrfid=" + "<%=csrfIdValue%>";
}
</script>

<div class="customWASDojoTabLayout">

<table border="0" cellpadding="3" cellspacing="1" valign="top" width="100%" role="presentation">
	<tr valign="top">
        <td nowrap>
			<input class="buttons_navigation" type="button" name="newchart" value="<bean:message key="open.chart.tab"/>" onclick="scriptScope.openNewChart();"/>
			<input class="buttons_navigation" type="button" name="popoffChart" value="<bean:message key="launch.current.chart"/>" onclick="scriptScope.launchChart();"/>
		</td>
	</tr>
</table>
<% if (chartGroup != null && !chartGroup.equals("")) { %>
<br>
	<font size="+2" class="graybold">
		<b><bean:message key="chart.group"/><bean:message key="xdoperations.paging.token"/>  <%=chartGroup%></b>
	</font>
<br>
<% } %>
<br>

<% if (contextType.equals("XDOperations")) { %>
<div widgetId="chartTabContainer" id="chartTabContainer" dojoType="dijit.layout.TabContainer" style="width:100%; overflow:auto;" doLayout="false" selectedChild="<%=selectedRefId%>" lang="<%=request.getLocale().toString().replace('_', '-')%>" dir="ltr" role="region" aria-label="Runtime Operations">
	<%		
	//System.out.println("collectionTabsLayout.jsp:tabs.size=" + tabs.size());	
	for (int t = 0; t < tabs.size(); t++) {
		ChartDetailForm tab = (ChartDetailForm) tabs.get(t);
		String refId = tab.getRefId();
		String displayName = tab.getDisplayName();
		//System.out.println("Tab: displayName[" + t + "]: " + displayName);
		//System.out.println("Tab: refId[" + t + "]: " + refId);
		String href = "";
		if (selectedRefId.equalsIgnoreCase(refId)) {
			selectedForm = tab;
			request.getSession().setAttribute("ChartDetailForm", selectedForm);
			href = request.getContextPath() + "/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=" + contextType;
		}
		
		String label = displayName;
		if (displayName.trim().equals("-- Select Name --")) {
			label = getString("select.name", msgs, request);
		} else if (displayName.trim().equals("-- Select an application/EJB pair --")) {
			label = getString("select.app.ejb.pair", msgs, request);
		}
		
		%>

		<div widgetId="<%=refId%>" id="<%=refId%>" dojoType="dojox.layout.ContentPane" title="<%=label%>" role="region" aria-label="<bean:message key="nav.reporting"/>"
			 style="overflow: auto;" preload="false" cacheContent="false" refreshOnShow="true" executeScripts="true"
			 closable="true" loadingMessage="<%=pleaseWait%>" adjustPaths="false" parseContent="false" extractContent="false">
		</div>
	<% } %>
</div>
<% } else { %>
<div style="width: 100%; height: 600px">
    <div id="tabContainer"></div>
</div>
<% } %>

<style>
.chartgroup-button-section { 
    padding-left: 8px; 
    font-family: Verdana,Helvetica, sans-serif;  
    text-align: left;  
    color: #000000;  
    font-weight: normal; 
    background-color: #d1d9e8;  
    padding-top: 0.25em; 
}
</style>

<div parseWidgets="false">
<% List chartGroups = (List) request.getSession().getAttribute("chartGroups"); %>
	
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
<input type="hidden" name="contextType" value="<%=contextType%>"/>
	<table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" class="button-section">
		<tbody>
			<tr class="table-row" valign="top">
				<td colspan="<%=chartGroups.size() + 2%>" class="chartgroup-button-section">
					<label for="chartGroup"><bean:message key="save.chart.group.msg"/></label>
					<input type="text" name="chartGroup" id="chartGroup" value="<%=chartGroup%>">
					<input class="buttons_functions" type="submit" name="saveChartGroup" value="<bean:message key="button.save"/>"/>
				</td>
			</tr>
			<tr class="table-row" valign="top">
				<td width="20%" class="chartgroup-button-section">
					<label><bean:message key="saved.chart.groups"/></label>
				</td>
				<% for (Iterator itr = chartGroups.iterator(); itr.hasNext();) {
					String cg = (String) itr.next();
				%>
					<td class="chartgroup-button-section">
				<%		if (cg == null || cg == "") { %>
							&nbsp;
				<%		} else { %>
							<a id="<%="url_chartgroup_"+cg%>" href="#" onclick="switchChartGroup('<%=cg%>');">
								<%=cg%>
							</a>
				<%		} %>
					</td>
				<% } %>
				<td width="90%" class="chartgroup-button-section">
				</td>
			</tr>	
			<tr valign="top">
				<td colspan="<%=chartGroups.size() + 2%>" class="chartgroup-button-section">
					<input class="buttons_functions" type="submit" name="removeChartGroup" value="<bean:message key="remove.group.label"/>"/>
				</td>
			</tr>	
				
		</tbody>
	</table>
</html:form>
</div>

<%//System.out.println("collectionTabsLayout:: end"); %>

</div>
