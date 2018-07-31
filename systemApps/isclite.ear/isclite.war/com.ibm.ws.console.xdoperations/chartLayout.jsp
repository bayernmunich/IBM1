<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004,2012 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.chart.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.*"%>
<%@ page import="com.ibm.ws.xd.visualizationengine.cacheservice.util.*"%>

<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>

<%@ page errorPage="/secure/error.jsp"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<ibmcommon:detectLocale />

<style type="text/css">
	@import "<%=request.getContextPath()%>/dojo/dijit/themes/tundra/tundra.css";
	@import "<%=request.getContextPath()%>/dojo/dijit/themes/dijit.css";
	@import "<%=request.getContextPath()%>/dojo/dojox/form/resources/RangeSlider.css";
</style>

<%//System.out.println("chartLayout:: begin"); %>
<%
  String csrfIdValue = (String)session.getAttribute("com.ibm.ws.console.CSRFToken");
  String chartLite = (String)request.getAttribute("chartLite");
  if (chartLite == null) chartLite = "";
  //TODO -- get rid of this and just have contextType be correct.
  String dashboardContext = (String)request.getAttribute("dashboard");
  if (dashboardContext == null) dashboardContext = "";

  boolean tabContainerExists = true;
  if (request.getParameter("single") != null) {
	  tabContainerExists = false;
  }
%>

<script type="text/javascript">
	var dojoConfig = { parseOnLoad: true, isDebug: true };
</script>

<script type="text/javascript">
	try {
        if (typeof dojo == 'undefined') {
            document.writeln('<script type=\"text/javascript\" src=\"<%=request.getContextPath()%>/dojo/dojo/dojo.js\" dojoConfig=\"parseOnLoad:true, isDebug: true\"><\/script>');
            document.writeln('<script type=\"text/javascript\">');
            document.writeln('dojo.require(\"dijit.layout.TabContainer\");');
            document.writeln('dojo.require(\"dojox.layout.ContentPane\");');
            document.writeln('dojo.require(\"dojox.form.RangeSlider\");');
            document.writeln('dojo.require(\"dijit.form.HorizontalRule\");');
            document.writeln('dojo.require(\"dijit.form.HorizontalRuleLabels\");');
            document.writeln('<\/script>');
            document.writeln('<script type=\"text/javascript\" src=\"<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/svgchart.js\"><\/script>');
            document.writeln('<link href=\"<%=request.getContextPath()%>/css/ISCTheme/en/Styles.css\" rel=\"styleSheet\" type=\"text/css\">');
            document.writeln('<link href=\"<%=request.getContextPath()%>/adminconsole.css\" rel=\"stylesheet\" type=\"text/css\"/>');
        } else {
	        dojo.require("dijit.layout.TabContainer");
	        dojo.require("dojox.layout.ContentPane");
			dojo.require("dojox.form.RangeSlider");
			dojo.require("dijit.form.HorizontalRule");
			dojo.require("dijit.form.HorizontalRuleLabels");
        }
    } catch (e) {
    }
</script>

<%//System.out.println("chartLayout:: after browser detection"); %>

<%try {
MessageResources msgs = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);

String oldsvgviewer = getString("svg.viewer.old.version", msgs, request);
String vieweravail = getString("svg.viewer.available", msgs, request);
String viewernotavail = getString("svg.viewer.not.available", msgs, request);%>

<%!String escape(String str) {
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

<%
ChartCollectionForm collectionForm = (ChartCollectionForm) request.getSession().getAttribute(Constants.CHART_COLLECTION_FORM_KEY);
String enableRefresh = collectionForm.getEnableAutoRefresh();
if (chartLite.equalsIgnoreCase("true")) {
	enableRefresh = "false";
}
String refreshInterval = collectionForm.getRefreshInterval();
Hashtable tabTable = collectionForm.getTabTable();

String chartFormat = (String) request.getParameter("chartFormat");
String contextType = (String) request.getParameter("contextType");
//System.out.println("chartLayout:: contextType=" + contextType);
if (contextType == null || contextType.contains("Dashboard")) {
    contextType = (String)request.getAttribute("contextType");
}
String originalWindow = (String) request.getParameter("originalWindow");
String currWindow = (String) request.getAttribute(Constants.CURRENT_FRAME);
if (currWindow == null) {
    currWindow = (String) request.getParameter(Constants.CURRENT_FRAME);
    if (currWindow == null) {
        currWindow = Constants.GRAPH_FRAME_NAME;
    }
}
//String maxTime = "-1";
//String minTime = "-1";

String rname = Utils.getResourceName(session, contextType);
String target = contextType + Constants.DATASET_NAME_SEPARATOR + currWindow;
if (rname.length() > 0) 
	target = contextType + Constants.DATASET_NAME_SEPARATOR + rname + Constants.DATASET_NAME_SEPARATOR + currWindow;

ArrayList tabList = (ArrayList) tabTable.get(target);
if (tabList == null) {
	//System.out.println("null tabList");
	Set keys = tabTable.keySet();
	Iterator i_keys = keys.iterator();
	while (i_keys.hasNext()) {
		String key = (String) i_keys.next();
		//System.out.println("chartLayout:: tabTable key=" + key);
		if (key.startsWith(contextType)) {
			tabList = (ArrayList) tabTable.get(key);
			target = key;
		}
	}
}
String selectedRefId = request.getParameter("refId");
//System.out.println("[chartLayout.jsp]:find refId=" + selectedRefId);
if (selectedRefId == null || selectedRefId.equals("undefined")) {
    selectedRefId = (String)request.getAttribute("refId");
	//System.out.println("[chartLayout.jsp]:find refId 2=" + selectedRefId);
	if (selectedRefId == null) {
		ChartDetailForm detailForm = (ChartDetailForm)request.getSession().getAttribute("ChartDetailForm");
		selectedRefId = detailForm.getRefId();
		//System.out.println("[chartLayout.jsp]:find refId 3=" + selectedRefId);
	}
}

String multiChartRefId = selectedRefId.replace('.','_');
multiChartRefId = multiChartRefId.replace('-', '_');

ChartDetailForm selectedForm = null;
//System.out.println("chartLayout:: tabList.size=" + tabList.size());
for (int t = 0; t < tabList.size(); t++) {
	//System.out.println("chartLayout:: tabList index" + t);
	ChartDetailForm tab = (ChartDetailForm) tabList.get(t);
	//System.out.println("chartLayout:: tab" + tab);
	String refId = tab.getRefId();
	//System.out.println("chartLayout:: tab refId2=" + refId);
	//System.out.println("chartLayout:: tab selectedRefId2=" + selectedRefId);
	if (refId.equals(selectedRefId)) {
		selectedForm = tab;
	}
}

String[] availableHistoricModes = selectedForm.getAvailableHistoricModes();
int sizeOfAvailableHistoricModes = availableHistoricModes.length;

//for (int test = 0; test < sizeOfAvailableHistoricModes; ++test) {
//	System.out.println("availableHistoricModes["+ test+ "]:"+ availableHistoricModes[test]);
//}
//If for some reason the selectedRefId is not on the request or session but there
//is a chart in the tab list, just display it.
//if (selectedRefId.equals("undefined") && tabList.size() > 0) {
//	ChartDetailForm tab = (ChartDetailForm) tabList.get(0);
//	System.out.println("chartLayout:: tab2" + tab);
//	selectedForm = tab;
//	selectedRefId = tab.getRefId();
//	System.out.println("chartLayout:: tab selectedRefId3=" + selectedRefId);
//}

String refId = selectedForm.getRefId();
String scope = selectedForm.getScope();
String name = selectedForm.getScopeName();
String subdomain = selectedForm.getSubdomain();
String metric = selectedForm.getMetric();
String type = selectedForm.getType();
String filter = selectedForm.getFilter();
String prevDataSets = selectedForm.getPreviousDataSets();
String size = selectedForm.getSize();
String historicMode = selectedForm.getTimeWindow();

List scopes = selectedForm.getScopeList();
List names = selectedForm.getNamesList();
List subdomains = selectedForm.getSubdomainList();
List metrics = selectedForm.getMetricList();
List filters = selectedForm.getFilterList();
List availDataSets = selectedForm.getAvailableDataSets();

Hashtable metricScales = selectedForm.getMetricScales();
List dataSets = selectedForm.getDataSets();
Hashtable shapes = selectedForm.getChartShapes();

String prefsState = (String) request.getSession().getAttribute(currWindow + "_com_ibm_ws_chart_settings_" + selectedRefId);
String scopeState = (String) request.getSession().getAttribute(currWindow + "_scopeTable_" + selectedRefId);
String subdomainState = (String) request.getSession().getAttribute(currWindow + "_subdomainTable_" + selectedRefId);

//System.out.println("chartLayout:: prefsState=" + prefsState + " scopeState=" + scopeState + " subdomainState=" + subdomainState);

if (prefsState == null) prefsState = "none";
if (scopeState == null) scopeState = "none";
if (subdomainState == null) subdomainState = "none";

String chartSize = selectedForm.getSize();
int svgwidth = Constants.SMALL_WIDTH;
int svgheight = Constants.SMALL_HEIGHT;
if (chartSize.equals(Constants.SIZES[Constants.MEDIUM])) {
	svgwidth = Constants.MED_WIDTH;
	svgheight = Constants.MED_HEIGHT;
} else if (chartSize.equals(Constants.SIZES[Constants.LARGE])) {
	svgwidth = Constants.LG_WIDTH;
	svgheight = Constants.LG_HEIGHT;
}

String detailFormAction = "ChartDetail.do";
String detailFormName = "ChartDetailForm";
String detailFormId = "ChartDetailForm_" + refId;
String detailFormType = "com.ibm.ws.console.xdoperations.chart.ChartDetailForm";

String minValueId = "minValue_" + refId;
String maxValueId = "maxValue_" + refId;

String scopeNameWarning = "scopeNameWarning_" + refId;
String scopeTable = "scopeTable_" + refId;
String subdomainTable = "subdomainTable_" + refId;
String ODRFiltersToggle = "ODRFiltersToggle_" + refId;

String chartScope = "chartScope_" + refId;
String chartScopeName = "chartScopeName_" + refId;

String subdomainId = "subdomain_" + refId;
String datasetName = "datasetName_" + refId;
String metricId = "metric_" + refId;

String odrfilter = "odrfilter_" + refId;
String ODRFilterDiv = "ODRFilterDiv_" + refId;
String filterId = "filter_" + refId;

String timeWindow = "timeWindow_" + refId;
%>

<script>
window.onload="";

var scope;
var name;
var subdomain;
var metric;
var type;
var filter;
var datasets;

var showShapes = 'on';
var showGoals = 'on';
var size;

var state = '<%=prefsState%>';
var state2 = '<%=scopeState%>';
var state3 = '<%=subdomainState%>';
//console.debug('[chartLayout.jsp].main:state=' + state + ' state2=' + state2 + ' state3=' + state3);

var intervalId;

var isNav4 = false;
var isIE = false;
var isDom2 = false;
var showIt = "";
var foropera = window.navigator.userAgent.toLowerCase();
var itsopera = foropera.indexOf("opera",0) + 1;
var itsgecko = foropera.indexOf("gecko",0) + 1;
var itsmozillacompat = foropera.indexOf("mozilla",0) + 1;
var itsmsie = foropera.indexOf("msie",0) + 1;

var isPopupOpen = false;
<% if (!prefsState.equals("none") || !scopeState.equals("none") || !subdomainState.equals("none")) { %>
    isPopupOpen = true;
<% } %>

if (itsopera > 0){
	this.isNav4 = true
}
if (itsmozillacompat > 0){
	if (itsgecko > 0) {
     	this.isDom2 = true
       	//document.all = document.getElementsByTagName("*");
	} else if (itsmsie > 0) {
		isIE = true
	} else {
		if (parseInt(navigator.appVersion) < 5) {
			this.isNav4 = true
		} else {
			//isIE = true
		}
	}
}

if (isDom2) {
    this.showIt = "table-row-group";
} else {
    this.showIt = "inline";
}

var jsObject = new Object();
<%
int count = 0;
for (Iterator iter = dataSets.iterator(); iter.hasNext();) {
	String key = (String) iter.next(); %>
    jsObject['<%=count++%>'] = '<%=key%>';
<%}%>


function positionChartPrefs() {
	var chartPrefs = dojo.byId("chartingPreferences");
	if (chartPrefs) {
		chartPrefs.style.top = 8;
		if (size=="small") 
			chartPrefs.style.left = 350;
		else if (size=="medium")
			chartPrefs.style.left = 510;
		else if (size == "large")
			chartPrefs.style.left = 670;
	}
}

function init<%=multiChartRefId%>() {
	//console.debug('[chartLayout.jsp].init.<%=multiChartRefId%>: Start');
    var chartPane = dojo.byId("div_<%=selectedRefId%>");
    if (chartPane) {
        var chartFormat = '';
        var defaultChartFormat = dojo.byId('defaultChartFormat');
        if (defaultChartFormat) {
            chartFormat = defaultChartFormat.options[defaultChartFormat.selectedIndex].value;
        } else {
            // Single chart display
            chartFormat = '<%=chartFormat%>';
        }
        //console.debug('[chartLayout.jsp].init.<%=multiChartRefId%>.chartFormat=' + chartFormat);
        if (chartFormat == 'svg') {
            chartPane.innerHTML = '<embed style="z-index: 1" wmode="transparent" type="image/svg+xml" id="svg<%=selectedRefId%>" width="<%=svgwidth%>" height="<%=svgheight%>" src="<%=request.getContextPath()%>/ChartServlet?scope=<%=scope%>&name=<%=name%>&subdomain=<%=subdomain%>&selectedRefId=<%=selectedRefId%>&currWindow=<%=currWindow%>&contextType=<%=contextType%>&isIE=' + isIE + '">';
        } else if (chartFormat == 'jpeg') {
            chartPane.innerHTML = '<img id="jpeg<%=selectedRefId%>" src="<%=request.getContextPath()%>/ChartServlet?scope=<%=scope%>&name=<%=name%>&subdomain=<%=subdomain%>&selectedRefId=<%=selectedRefId%>&currWindow=<%=currWindow%>&format=jpeg&contextType=<%=contextType%>&historicMode=<%=historicMode%>&isIE=' + isIE + '"/><br/>';
        } else {
            // Invalid chartFormat, use svg as default
            chartPane.innerHTML = '<embed style="z-index: 1" wmode="transparent" type="image/svg+xml" id="svg<%=selectedRefId%>" width="<%=svgwidth%>" height="<%=svgheight%>" src="<%=request.getContextPath()%>/ChartServlet?scope=<%=scope%>&name=<%=name%>&subdomain=<%=subdomain%>&selectedRefId=<%=selectedRefId%>&currWindow=<%=currWindow%>&contextType=<%=contextType%>&isIE=' + isIE + '">';
        }
    }
    //This means we are a frame in the adminConsole display and need to behave as such
    if(window.parent.frames.length==3 && window.parent.frames[2].name!='detail') {
    	//console.debug('frame name reset to details');
    	//console.debug(window.parent);
    	window.parent.frames[2].name='detail'
    }
<% if (!chartLite.equalsIgnoreCase("true")) { %>
	document.getElementById("chartingPreferences").style.zIndex = 499;
	//console.debug("[chartLayout.jsp].init.<%=multiChartRefId%>:prefs: "+document.getElementById("chartingPreferences").style.zIndex);
	
	document.getElementById("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.zIndex = 500;
	//console.debug("[chartLayout.jsp].init.<%=multiChartRefId%>: "+document.getElementById("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.zIndex);
<% } %>
    //console.debug("[chartLayout.jsp].init.<%=multiChartRefId%>: End");
    if (typeof ariaOnLoadTop == 'function')
		ariaOnLoadTop();
    
    if (typeof bidiOnLoad == 'function' && !bidiLoaded) {
    	bidiOnLoad();
        bidiLoaded = true;
    }
}

var scriptScope = this;
//Function specific for reloading charts in the dashboard.
this.reloadDashboard = function(selectedRefId) {
	if (dojo.byId) {
		if (dojo.byId("svg"+selectedRefId) != null) {
			try {
				dojo.byId("svg"+selectedRefId).reload();
			} catch (e) {
				if (dojo.byId("svg"+selectedRefId).getSVGDocument() != null) {
					dojo.byId("svg"+selectedRefId).getSVGDocument().rootElement.suspendRedraw(100);
					dojo.byId("svg"+selectedRefId).getSVGDocument().location.reload(); //322754 for Firefox 1.5
				}
			}
		} else {
		  	if (dojo.byId('jpeg'+selectedRefId) != null) {
		   		dojo.byId('jpeg'+selectedRefId).src = 'ChartServlet?selectedRefId='+selectedRefId+'&format=jpeg&contextType=DashboardOperations&currWindow=detail&random=' + Math.random() + '&isIE=' + isIE;
				document.getElementById("com_ibm_ws_chart_settings_"+selectedRefId).style.zIndex = 500;
				document.getElementById("chartingPreferences").style.zIndex = 499;
		   	}
		}
	}
}

this.reload = function() {
	//console.debug("[chartLayout.jsp].reload: Entry");
	//Don't reload the chart if the popup for adding data/changing scope is open
	if (dojo.byId && !isPopupOpen) {
		if (dojo.byId("svg<%=selectedRefId%>") != null) {
			try {
				dojo.byId("svg<%=selectedRefId%>").reload();
			} catch (e) {
				if (dojo.byId("svg<%=selectedRefId%>").getSVGDocument() != null) {
					dojo.byId("svg<%=selectedRefId%>").getSVGDocument().rootElement.suspendRedraw(100);
					dojo.byId("svg<%=selectedRefId%>").getSVGDocument().location.reload(); //322754 for Firefox 1.5
				}
			}
		} else {
		  	if (dojo.byId('jpeg<%=selectedRefId%>') != null) {
                // dojo.byId('jpeg<%=selectedRefId%>').src = 'ChartServlet?selectedRefId=<%=refId%>&format=jpeg&contextType=<%=contextType%>&currWindow=<%=currWindow%>&random=' + Math.random() + '&isIE=' + isIE;
				//console.debug("[chartLayout.jsp].reload: Entry");
				var historicModeBox = dojo.byId("<%=timeWindow%>");
				var historicMode = historicModeBox.options[historicModeBox.selectedIndex].value;
				var maxTime = dojo.byId("<%=maxValueId%>").value;
				var minTime=  dojo.byId("<%=minValueId%>").value;
				//console.debug("[chartLayout.jsp].reload: historicMode" + historicMode);
				//console.debug("[chartLayout.jsp].reload: maxTime" + maxTime);
				//console.debug("[chartLayout.jsp].reload: minTime" + minTime);
				dojo.byId('jpeg<%=selectedRefId%>').src = '<%=request.getContextPath()%>/ChartServlet?scope=<%=scope%>&name=<%=name%>&subdomain=<%=subdomain%>&selectedRefId=<%=selectedRefId%>&currWindow=<%=currWindow%>&format=jpeg&contextType=<%=contextType%>&historicMode=' + historicMode +'&minTime=' + minTime + '&maxTime=' + maxTime+ '&isIE=' + isIE + '&random=' + Math.random();
				//console.debug("[chartLayout.jsp].reload: "+document.getElementById("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.zIndex);
				document.getElementById("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.zIndex = 500;
				document.getElementById("chartingPreferences").style.zIndex = 499;
				//console.debug("[chartLayout.jsp].reload: "+document.getElementById("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.zIndex);
		   	}
		}
	}
}

this.setSelectBox = function() {   
	type = "<%=type%>";
	scope = "<%=scope%>";
	name = "<%=name%>";
	subdomain = "<%=subdomain%>";
    metric = "<%=metric%>";
    filter = "<%=filter%>";
    datasets = "<%=prevDataSets%>";
    size = "<%=size%>";

    if (dojo.byId('<%=detailFormId%>')) {
    	//console.debug('[chartLayout.jsp].setSelectBox: found detailFormId');
		showShapes = 'on';
		showGoals = 'on';
				
		shapesBox = dojo.byId("showShapes");
		if (shapesBox && shapesBox.checked == false)
			showShapes = 'off';
			
		goalsBox = dojo.byId("showGoals");
		if (goalsBox && goalsBox.checked == false)
			showGoals = 'off';

		var typeBox = dojo.byId("chartType");
		if (typeBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: typeBox');
			var typeOpts = typeBox.options;
			for (var t=0; t<typeOpts.length; t++) {
				if (typeOpts[t].value == type) 
					typeBox.selectedIndex = t;
			}
		}
		
		var sizeBox = dojo.byId("size");
		if (sizeBox) {
			var sizeOpts = sizeBox.options;
			for (var s=0; s<sizeOpts.length; s++) {
				if (sizeOpts[s].value == size)
					sizeBox.selectedIndex = s;
			}
		}			

		var scopeBox = dojo.byId("<%=chartScope%>");
		if (scopeBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: scopeBox');
			var scopeOpts = scopeBox.options;
			for (var i=0; i< scopeOpts.length; i++) {
				if (scopeOpts[i].value == scope)
					scopeBox.selectedIndex = i;
			}
		}
	
		var nameBox = dojo.byId("<%=chartScopeName%>");
		if (nameBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: nameBox');
			var nameOpts = nameBox.options;
			for (var j=0; j< nameOpts.length; j++) {
				if (nameOpts[j].value == name)
					nameBox.selectedIndex = j;
			}
		}		
		
		var subdomainBox = dojo.byId("<%=subdomainId%>");
		if (subdomainBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: subdomainBox');		
			var subdomainOpts = subdomainBox.options;
			for (var k=0; k< subdomainOpts.length; k++) {
				if (subdomainOpts[k].value == subdomain)
					subdomainBox.selectedIndex = k;
			}
		}		
		
		var metricBox = dojo.byId("<%=metricId%>");
		if (metricBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: metricBox');
			var metricOpts= metricBox.options;
			for (var z=0; z< metricOpts.length; z++) {
				var tempM = metric;
				if ((tempM.indexOf('!') == -1) && (metricOpts[z].value == metric)) {
					metricBox.selectedIndex = z;
				} else {
					while(tempM.indexOf('!') != -1) {
						var m1 = tempM.substring(0, tempM.indexOf('!'));
						if (metricOpts[z].value == m1) {
							metricOpts[z].selected = true;
						}
						tempM = tempM.substring(tempM.indexOf('!')+1, tempM.length);
	                    if (tempM.indexOf('!') == -1) {
							m1 = tempM;
	                     	if (metricOpts[z].value == m1) {
	                        	metricOpts[z].selected = true;
	                     	}
	  					}
					}
				}
			}
		}
		
		if (scope == "proxy" || scope == "odr")
			dojo.byId("<%=filterId%>").disabled = true;
			
		var filterBox = dojo.byId("<%=filterId%>");
		if (filterBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: filterBox');
			var filterOpts = filterBox.options;
			for (var n=0; n<filterOpts.length; n++) {
				var temp = filter;
				if ((temp.indexOf('!') == -1) && (filterOpts[n].value == filter)) {
					filterBox.selectedIndex = n;
				} else {
					while(temp.indexOf('!') != -1) {
						var proxy = temp.substring(0, temp.indexOf('!'));
						if (filterOpts[n].value == proxy) {
							filterOpts[n].selected = true;
						}
						temp = temp.substring(temp.indexOf('!')+1, temp.length);
	                    if (temp.indexOf('!') == -1) {
	            			proxy = temp;
	                  		if (filterOpts[n].value == proxy) {
	                         	filterOpts[n].selected = true;
	                       	}
	            		}
					}
				}
			}
		}

		var datasetsBox = dojo.byId("<%=datasetName%>");
		if (datasetsBox) {
			//console.debug('[chartLayout.jsp].setSelectBox: datasetsBox');
			var  datasetsOpts=  datasetsBox.options;
			for (var k=0; k<  datasetsOpts.length; k++) {
				var tempD =  datasets;
				if ((tempD.indexOf('!') == -1) && ( datasetsOpts[k].value ==  datasets)) {
					 datasetsBox.selectedIndex = k;
				} else {
					while(tempD.indexOf('!') != -1) {
						var d1 = tempD.substring(0, tempD.indexOf('!'));
						if ( datasetsOpts[k].value == d1) {
							 datasetsOpts[k].selected = true;
						}
						tempD = tempD.substring(tempD.indexOf('!')+1, tempD.length);
	                   	if (tempD.indexOf('!') == -1) {
	                   		d1 = tempD;
	                      	if ( datasetsOpts[k].value == d1) {
	                        	datasetsOpts[k].selected = true;
	                       	}
	                  	}
					}
				}
			}
		}
	}
}

this.setHistoricModeBox = function() {
	//console.debug("[chartLayout.jsp].setHistoricModeBox entry");
	var timeWindowBox = dojo.byId("<%=timeWindow%>");
	if (timeWindowBox) {
		var tempHistoricMode = "<%=historicMode%>";
		if (tempHistoricMode == null || tempHistoricMode == "") {
			tempHistoricMode = "LIVE";
		}
		//console.debug("[chartLayout.jsp].setHistoricModeBox historic mode is " + tempHistoricMode);
		var i;
		for (i = 0; i < timeWindowBox.length; i++) {
			if(timeWindowBox.options[i].value == tempHistoricMode) {
				timeWindowBox.options[i].selected = true;
				break;
			}
		}
	}
	//console.debug("[chartLayout.jsp].setHistoricModeBox exit");
}

this.resetScopeName = function () {
	oldName = "<%=name%>";
	var nameBox = dojo.byId("<%=chartScopeName%>");
	var nameOpts = nameBox.options;
	for (var j=0; j< nameOpts.length; j++) {
		if (nameOpts[j].value == oldName) {
			nameBox.selectedIndex = j;
		}
	}		
}

this.repositionPop = function (objectId) {
	//console.debug('[chartLayout.jsp].repositionPop: Start');
    // used to position absolute-positioned pseudo popups
    //if (dojo.byId(objectId).style.position = "absolute") {
       if (this.isDom2) {
           dojo.byId(objectId).style.top = document.body.scrollTop;
       } else {
           dojo.byId(objectId).style.pixelTop = document.body.scrollTop;
       }
    //console.debug('[chartLayout.jsp].repositionPop: End');
}

this.doXmlHttpRequest = function (sUri) {
    var isMoz = false;
    var mozLoaded = false;
    var xmlhttp = null;
    var xmlDoc = null;
    
    if (window.ActiveXObject) {
        xmlhttp = new ActiveXObject('MSXML2.XMLHTTP');
    } else {
        xmlhttp = new XMLHttpRequest();
    }
	
    if (xmlhttp) {
        xmlhttp.open('POST',sUri,false);
        //PI12xxx
        form = document.getElementsByName("csrfid")[0];
        if (form != null) {
        	value = form.value;
        	xmlhttp.setRequestHeader("csrfid", value);
        }
        xmlhttp.send(null);
        xmlDoc = xmlhttp.responseText;
        mozLoaded = true;
    }

    return xmlDoc;
}

this.showHidePrefs = function (objectId,num) {
	//console.debug("[chartLayout.jsp].showHidePrefs::00:objectID: "+objectId+" num: "+num);
	var state;
	if (dojo.byId(objectId) != null) {
        if (dojo.byId(objectId).style.display == "none") {
            dojo.byId(objectId).style.display = this.showIt;
            if (dojo.byId(objectId+"Img")) {
                dojo.byId(objectId+"Img").src = "/ibm/console/images/arrow_expanded.gif";
            }
            //console.debug("[chartLayout.jsp].showHidePrefs::01: changing state to block");
            state = "block";
            isPopupOpen = true;
        } else {
            //console.debug("[chartLayout.jsp].showHidePrefs::02: changing object to none");
            dojo.byId(objectId).style.display = "none";
            if (dojo.byId(objectId+"Img")) {
                dojo.byId(objectId+"Img").src = "/ibm/console/images/arrow_collapsed.gif";
            }
            //console.debug("[chartLayout.jsp].showHidePrefs::03: changing state to none");
            state = "none";
            isPopupOpen = false;
        }
       	if (objectId == "com_ibm_ws_chart_settings_<%=selectedRefId%>") {
           	if (state == "") {
           	    //console.debug("[chartLayout.jsp].showHidePrefs::04: changing state to block");
            	state = "block";
           	}
           	uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_com_ibm_ws_chart_settings_<%=selectedRefId%>&variableValue="+state;
           	setState = this.doXmlHttpRequest(uriState);
           	setState = setState.substring(0,setState.indexOf("+endTransmission"));
           	//  decide which parts of the metrics adder to show
			if (num == 0) {
			    //console.debug("[chartLayout.jsp].showHidePrefs::05: num is 0");
				dojo.byId("<%=scopeTable%>").style.display = "none";
               	dojo.byId("<%=subdomainTable%>").style.display = "none";
            }  else if (num == 1) {
                //console.debug("[chartLayout.jsp].showHidePrefs::06:num is 1");
               	if (name == "-- Select Name --") {
               	    //console.debug("[chartLayout.jsp].showHidePrefs::07: num is 1:select name");
               		dojo.byId("<%=scopeTable%>").style.display = "block";
               		//console.debug("[chartLayout.jsp].showHidePrefs::07a:" + dojo.byId("<%=scopeTable%>").style.display);
               		dojo.byId("<%=scopeNameWarning%>").style.display = "block";
               		//console.debug("[chartLayout.jsp].showHidePrefs::07b:" + dojo.byId("<%=scopeNameWarning%>").style.display);
               	} else {
               		dojo.byId("<%=scopeNameWarning%>").style.display = "none";	
               		dojo.byId("<%=scopeTable%>").style.display = "none";
               		dojo.byId("<%=subdomainTable%>").style.display = "block";
               		dojo.byId("<%=ODRFiltersToggle%>").style.display = "block";
               	}
  		  		uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_scopeTable_<%=selectedRefId%>&variableValue=none";
               	setState = this.doXmlHttpRequest(uriState);
               	setState = setState.substring(0,setState.indexOf("+endTransmission"));
			} else if (num == 2) {
			    //console.debug("[chartLayout.jsp].showHidePrefs::09:num is 2");
				if (dojo.byId("<%=chartScopeName%>").selectedIndex != 0) {
               		dojo.byId("<%=scopeNameWarning%>").style.display = "none";
               	}
               	dojo.byId("<%=scopeTable%>").style.display = "block";
               	dojo.byId("<%=subdomainTable%>").style.display = "none";
               	dojo.byId("<%=ODRFiltersToggle%>").style.display = "none";
       			
 				uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_scopeTable_<%=selectedRefId%>&variableValue=block";
               	setState = this.doXmlHttpRequest(uriState);
               	setState = setState.substring(0,setState.indexOf("+endTransmission"));
			}
            //scriptScope.repositionPop(objectId);
		}
    }
    //console.debug("[chartLayout.jsp].showHidePrefs::10:exit");
}

this.storeTableState = function (newScope, newName, newSubdomain) {
	prefsTableState = dojo.byId("com_ibm_ws_chart_settings_<%=selectedRefId%>").style.display;		
	scopeTableState = dojo.byId("<%=scopeTable%>").style.display;
	subdomainTableState = dojo.byId("<%=subdomainTable%>").style.display;
	
	oldScope = "<%=scope%>";
	oldName = "<%=name%>";
	oldSubdomain = "<%=subdomain%>";
	
	//console.debug('[chartLayout.jsp].storeTableState:oldScope=' + oldScope + ' oldName=' + oldName + ' oldSubdomain=' + oldSubdomain);
	//console.debug('[chartLayout.jsp].storeTableState:newScope=' + newScope + ' newName=' + newName + ' newSubdomain=' + newSubdomain);

	if (oldScope != newScope) {
		// if scope was changed, then only show scope table to select name
		prefsTableState = "block";
		scopeTableState = "block";
		subdomainTableState = "none";
	} else if (oldName != newName) {
		// if name was changed, then show subdomain table as well to add metrics
		prefsTableState = "block";
		scopeTableState = "block";
		subdomainTableState = "block";		
	} else if (oldSubdomain != newSubdomain) {
		// if only subdomain was changed, then show subdomain table
		prefsTableState = "block";
		scopeTableState = "none";
		subdomainTableState = "block";
	} else {
		// data set was added, hide all tables
		prefsTableState = "none";
		scopeTableState = "none";
		subdomainTableState = "none";
	}
	
	//console.debug('[chartLayout.jsp].storeTableState:prefs=' + prefsTableState + ' scope=' + scopeTableState + ' subdomain=' + subdomainTableState);

	uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_com_ibm_ws_chart_settings_<%=selectedRefId%>&variableValue="+prefsTableState;
	setState = this.doXmlHttpRequest(uriState);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));

	uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_scopeTable_<%=selectedRefId%>&variableValue="+scopeTableState;
	setState = this.doXmlHttpRequest(uriState);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
	
	uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable=<%=currWindow%>_subdomainTable_<%=selectedRefId%>&variableValue="+subdomainTableState;
	setState = this.doXmlHttpRequest(uriState);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
}


this.selectChart = function (typeBox, scopeBox, nameBox, subdomainBox, filterBox, datasetsBox, metricBox){

	type = typeBox.options[typeBox.selectedIndex].value;
	scope = scopeBox.options[scopeBox.selectedIndex].value;
	name = nameBox.options[nameBox.selectedIndex].value;
	subdomain = subdomainBox.options[subdomainBox.selectedIndex].value;
	//console.debug("[chartLayout.jsp].selectChart:name:"+name);
	
	datasets = "";
	var datasetsOpts = datasetsBox.options;
	//console.debug("[chartLayout.jsp].selectChart.datasetsOpts:"+datasetsOpts.length);
	for (var i=0; i<datasetsOpts.length; i++) {
		if (datasetsOpts[i].selected) {
			if (datasets.length == 0)
				datasets = datasetsOpts[i].value;
			else
				datasets = datasets + '!' + datasetsOpts[i].value;
		}	
	}
	metric = "";
	var metricOpts = metricBox.options;
	for (var j=0; j<metricOpts.length; j++) {
		if (metricOpts[j].selected) {
			if (metric.length == 0)
				metric = metricOpts[j].value;
			else
				metric = metric + '!' + metricOpts[j].value;
		}
	}
	
	filter = "";
	if (dojo.byId("<%=odrfilter%>").checked == "false") {
		var filterOpts = filterBox.options;
		for (var n=0; n<filterOpts.length; n++) {
			if (filterOpts[n].selected) {
				if (filter.length == 0)
					filter = filterOpts[n].value;
				else
					filter = filter + '!' + filterOpts[n].value;
			}
		}
	} else {
		filter = "none";
	}
	
	if (filter == "")
		filter = "none";
		
	this.storeTableState(scope, name, subdomain);
	
	//console.debug("[chartLayout.jsp].selectChart: <%=request.getContextPath() + "/" + detailFormAction%>?selectedRefId=<%=refId%>&contextType=<%=contextType%>&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals);
	var location = "<%=request.getContextPath() + "/" + detailFormAction%>?selectedRefId=<%=refId%>&contextType=<%=contextType%>&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&csrfid=" + "<%=csrfIdValue%>";
	setState = this.doXmlHttpRequest(location);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
	
	window.clearInterval(intervalId);
	if (<%=tabContainerExists%>) {
		var tabContainer = dijit.byId("chartTabContainer");
		if (tabContainer) {
			var selectedTab = tabContainer.selectedChildWidget;
			if (selectedTab) {
				var refId = selectedTab.id;
				selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>");
			}
		}
    } else {
        // Single chart display
        location = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=<%=refId%>&contextType=<%=contextType%>&currWindow=<%=currWindow%>&originalWindow=<%=originalWindow%>&single=true&chartFormat=<%=chartFormat%>" + "&csrfid=" + "<%=csrfIdValue%>";
        window.location = location;
    }
}

this.cancelButton = function() {
	//console.debug("[chartLayout.jsp].cancelButton:entry");
	scriptScope.showHidePrefs('com_ibm_ws_chart_settings_<%=selectedRefId%>');
	
	if (<%=tabContainerExists%>) {
		var tabContainer = dijit.byId("chartTabContainer");
		if (tabContainer) {
			var selectedTab = tabContainer.selectedChildWidget;
			if (selectedTab) {
				var refId = selectedTab.id;
				selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>");
			}
		}
    } else {
        // Single chart display
        location = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=<%=refId%>&contextType=<%=contextType%>&currWindow=<%=currWindow%>&originalWindow=<%=originalWindow%>&single=true&chartFormat=<%=chartFormat%>" + "&csrfid=" + "<%=csrfIdValue%>";
        window.location = location;
    }
	isPopupOpen = false;
	//console.debug("[chartLayout.jsp].cancelButton:exit");
}

this.setChartSelections = function (filterBox, datasetsBox, metricBox) {
	datasets = "";
	var datasetsOpts = datasetsBox.options;
	for (var i=0; i<datasetsOpts.length; i++) {
		if (datasetsOpts[i].selected) {
			if (datasets.length == 0)
				datasets = datasetsOpts[i].value;
			else
				datasets = datasets + '!' + datasetsOpts[i].value;
		}	
	}
	metric = "";
	var metricOpts = metricBox.options;
	for (var j=0; j<metricOpts.length; j++) {
		if (metricOpts[j].selected) {
			if (metric.length == 0)
				metric = metricOpts[j].value;
			else
				metric = metric + '!' + metricOpts[j].value;
		}
	}
	filter = "";
	if (dojo.byId("<%=odrfilter%>").checked == "false") {
		var filterOpts = filterBox.options;
		for (var n=0; n<filterOpts.length; n++) {
			if (filterOpts[n].selected) {
				if (filter.length == 0)
					filter = filterOpts[n].value;
				else
					filter = filter + '!' + filterOpts[n].value;
			}
		}
	} else {
		filter = "none";
	}
	
	if (filter == "")
		filter = "none";
}

this.removeDataSets = function (){
	 
    var removeSets = "";
    var num = '<%=count%>';
    for (var d=0;d<num;d++) {
    	//console.debug('[chartLayout.jsp].removeDataSets:dataset=' + jsObject[d]);
    	var box = dojo.byId(jsObject[d]);
		if (box.checked == true) {
			if (removeSets.length == 0)
				removeSets = jsObject[d];
			else
				removeSets = removeSets + '!' + jsObject[d];
		}
    }
    //console.debug('[chartLayout.jsp].removeDataSets.removeSets=' + removeSets);

	var typeBox = dojo.byId("chartType");
	var scopeBox = dojo.byId("<%=chartScope%>");
	var nameBox = dojo.byId("<%=chartScopeName%>");
	var subdomainBox = dojo.byId("<%=subdomainId%>");
	var datasetsBox = dojo.byId("<%=datasetName%>");
	var metricBox = dojo.byId("<%=metricId%>");
	var filterBox = dojo.byId("<%=filterId%>");
	
	type = typeBox.options[typeBox.selectedIndex].value;
	scope = scopeBox.options[scopeBox.selectedIndex].value;
	name = nameBox.options[nameBox.selectedIndex].value;
	subdomain = subdomainBox.options[subdomainBox.selectedIndex].value;
	
	datasets = "";
	var datasetsOpts = datasetsBox.options;
	for (var i=0; i<datasetsOpts.length; i++) {
		if (datasetsOpts[i].selected) {
			if (datasets.length == 0)
				datasets = datasetsOpts[i].value;
			else
				datasets = datasets + '!' + datasetsOpts[i].value;
		}	
	}
	metric = "";
	var metricOpts = metricBox.options;
	for (var j=0; j<metricOpts.length; j++) {
		if (metricOpts[j].selected) {
			if (metric.length == 0)
				metric = metricOpts[j].value;
			else
				metric = metric + '!' + metricOpts[j].value;
		}
	}
	filter = "";
	if (dojo.byId("<%=odrfilter%>").checked == "false") {
		var filterOpts = filterBox.options;
		for (var n=0; n<filterOpts.length; n++) {
			if (filterOpts[n].selected) {
				if (filter.length == 0)
					filter = filterOpts[n].value;
				else
					filter = filter + '!' + filterOpts[n].value;
			}
		}
	} else {
		filter = "none";
	}
	
	if (filter == "")
		filter = "none";

	this.storeTableState(scope, name, subdomain);
	
	var location = "<%=request.getContextPath() + "/" + detailFormAction%>?remove=true&selectedRefId=<%=refId%>&removeSets=" + removeSets + "&contextType=<%=contextType%>&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&csrfid=" + "<%=csrfIdValue%>";
	setState = this.doXmlHttpRequest(location);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
	
	window.clearInterval(intervalId);
	
	if (<%=tabContainerExists%>) {
		var tabContainer = dijit.byId("chartTabContainer");
		if (tabContainer) {
			var selectedTab = tabContainer.selectedChildWidget;
			if (selectedTab) {
				var refId = selectedTab.id;
				selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>");
			}
		}
    } else {
        // Single chart display
        location = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=<%=refId%>&contextType=<%=contextType%>&currWindow=<%=currWindow%>&originalWindow=<%=originalWindow%>&single=true&chartFormat=<%=chartFormat%>" + "&csrfid=" + "<%=csrfIdValue%>";
        window.location = location;
    }
}

// Return popped chart to original window
this.returnChart = function () {
	if (window.opener && !window.opener.closed) {
        // Set session data
        var url = "<%=request.getContextPath()%>/TargetServlet?returnChart=<%=selectedRefId%>&singleChartWindow=<%=currWindow%>&originalWindow=<%=originalWindow%>&contextType=<%=contextType%>";
        setState = this.doXmlHttpRequest(url);
        // Reload original window
        window.opener.location.reload(true);
        window.close();
    } else {
        // Original window closed, do nothing
    }
}

this.setHistoricMode = function (timeWindowBox) {
	//console.debug("[chartLayout.jsp].setHistoricMode: entry");
	var updatedHistoricMode = getHistoricMode();
	//reset min and max times
	var maxTime = 100;
	var minTime = 0;
	
	if (<%=tabContainerExists%>) {
		var location =   "<%=request.getContextPath() + "/" + detailFormAction%>?selectedRefId=<%=refId%>&contextType=<%=contextType%>&historicMode="+ updatedHistoricMode + "&minTime=" + minTime + "&maxTime=" + maxTime + "&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&size=" + size + "&csrfid=" + "<%=csrfIdValue%>";
		//console.debug("[chartLayout.jsp].setHistoricMode: window location: " + location);
		setState = this.doXmlHttpRequest(location);
		setState = setState.substring(0,setState.indexOf("+endTransmission"));
		
		//console.debug("[chartLayout.jsp].setHistoricMode: done sending request");
		var tabContainer = dijit.byId("chartTabContainer");
		if (tabContainer) {
			var selectedTab = tabContainer.selectedChildWidget;
			if (selectedTab) {
				var refId = selectedTab.id;
				var location = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>" + "&historicMode=" + updatedHistoricMode;
				selectedTab.set("href", location);
			}
		}
	} else {
		var location =   "<%=request.getContextPath() + "/" + detailFormAction%>?selectedRefId=<%=refId%>&contextType=<%=contextType%>&historicMode="+ updatedHistoricMode + "&minTime=" + minTime + "&maxTime=" + maxTime + "&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&size=" + size + "&csrfid=" + "<%=csrfIdValue%>" + "&single=true";
		//console.debug("[chartLayout.jsp].setHistoricMode: window location: " + location);
		setState = this.doXmlHttpRequest(location);
		setState = setState.substring(0,setState.indexOf("+endTransmission"));
		window.location.reload();
	}
	//console.debug("[chartLayout.jsp].setHistoricMode: exit");
}

this.submitForm = function () { 
	var typeBox = dojo.byId("chartType");
	var scopeBox = dojo.byId("<%=chartScope%>");
	var nameBox = dojo.byId("<%=chartScopeName%>");
	var subdomainBox = dojo.byId("<%=subdomainId%>");
	var datasetsBox = dojo.byId("<%=datasetName%>");
	var metricBox = dojo.byId("<%=metricId%>");
	var filterBox = dojo.byId("<%=filterId%>");
	var maxTime = dojo.byId("<%=maxValueId%>").value;
	var minTime = dojo.byId("<%=minValueId%>").value;
			
	shapesBox = dojo.byId("showShapes");
	if (shapesBox) {
		if (shapesBox.checked == false)
			showShapes = 'off';
		else 
			showShapes = 'on';
	}
	
	goalsBox = dojo.byId("showGoals");
	if (goalsBox) {
		if (goalsBox.checked == false)
			showGoals = 'off';
		else
			showGoals = 'on';
	}
	
	sizeBox = dojo.byId("size");
	if (sizeBox)
		size = sizeBox.options[sizeBox.selectedIndex].value;
	
	if (typeBox)
		type = typeBox.options[typeBox.selectedIndex].value;
	if (scopeBox)
		scope = scopeBox.options[scopeBox.selectedIndex].value;
	if (nameBox)
		name = nameBox.options[nameBox.selectedIndex].value;
	if(subdomainBox)
		subdomain = subdomainBox.options[subdomainBox.selectedIndex].value;
	
	datasets = "";
	var datasetsOpts = datasetsBox.options;
	for (var i=0; i<datasetsOpts.length; i++) {
		if (datasetsOpts[i].selected) {
			if (datasets.length == 0)
				datasets = datasetsOpts[i].value;
			else
				datasets = datasets + '!' + datasetsOpts[i].value;
		}	
	}
	
	metric = "";
	var metricOpts = metricBox.options;
	for (var j=0; j<metricOpts.length; j++) {
		if (metricOpts[j].selected) {
			if (metric.length == 0)
				metric = metricOpts[j].value;
			else
				metric = metric + '!' + metricOpts[j].value;
		}
	}
	
	filter = "";
	if (dojo.byId("<%=odrfilter%>").checked == "false") {
		var filterOpts = filterBox.options;
		for (var n=0; n<filterOpts.length; n++) {
			if (filterOpts[n].selected) {
				if (filter.length == 0)
					filter = filterOpts[n].value;
				else
					filter = filter + '!' + filterOpts[n].value;
			}
		}
	} else {
		filter = "none";
	}
	
	var historicMode = "<%=historicMode%>";
    var historicModeBox = dojo.byId("<%=timeWindow%>");
    if (historicModeBox)
    	historicMode = historicModeBox.options[historicModeBox.selectedIndex].value;
    	
	//console.debug("[chartLayout.jsp].submitForm: historicMode = " + historicMode);
	this.storeTableState(scope, name, subdomain);
	var location = "<%=request.getContextPath() + "/" + detailFormAction%>?changePrefs=true&selectedRefId=<%=refId%>&contextType=<%=contextType%>&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&size=" + size + "&historicMode=" + historicMode + "&minTime=" + minTime + "&maxTime=" + maxTime + "&csrfid=" + "<%=csrfIdValue%>";
	
	setState = this.doXmlHttpRequest(location);
	setState = setState.substring(0,setState.indexOf("+endTransmission"));
	
	window.clearInterval(intervalId);
	if (<%=tabContainerExists%>) {
		var tabContainer = dijit.byId("chartTabContainer");
		if (tabContainer) {
			var selectedTab = tabContainer.selectedChildWidget;
			if (selectedTab) {
				var refId = selectedTab.id;
				selectedTab.set("href", "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=" + refId + "&contextType=<%=contextType%>&historicMode=" + historicMode + "&minTime=" + minTime + "&maxTime=" + maxTime);
			}
		}
    } else {
        // Single chart display
        location = "<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/chartLayout.jsp?refId=<%=refId%>&contextType=<%=contextType%>&currWindow=<%=currWindow%>&originalWindow=<%=originalWindow%>&single=true&chartFormat=<%=chartFormat%>&historicMode=" + historicMode + "&minTime=" + minTime + "&maxTime=" + maxTime + "&csrfid=" + "<%=csrfIdValue%>";
        window.location = location;
    }
}

this.selectAll = function (tmpForm,tmpBox) {
    var num = '<%=count%>';
    for (var d=0;d<num;d++) {
    	var box = dojo.byId(jsObject[d]);
		box.checked = true;
    }
}

this.deselectAll = function (tmpForm,tmpBox) {
  	var num = '<%=count%>';
    for (var d=0;d<num;d++) {
    	var box = dojo.byId(jsObject[d]);
		box.checked = false;
    }
}

this.findParentRow = function (el,st) {
    par = el.parentNode;
    if (par.tagName == "TR") {
        par.className = st;
    } else {
        this.findParentRow(par,st);
    }
}

this.checkChecks = function (chk) {
    if (chk.checked == true) {
        this.findParentRow(chk,"table-row-selected");
    } else {
        this.findParentRow(chk,"table-row");
    }
}

var newwin;
this.getTable = function (scope, name, subdomain, metric, filter) {
	var url = "<%=request.getContextPath()%>/ChartServlet?contextType=<%=contextType%>&showTable=true&selectedRefId=<%=selectedRefId%>&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&metric=" + metric + "&filter=" + filter + "&csrfid=" + "<%=csrfIdValue%>";
	var features = "height=700,width=700,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
	if (newwin && !newwin.closed)
		newwin.location = url;
	else
		newwin = window.open(url,'Data', features);
}

if(typeof _container_ == 'undefined'){
	var _container_ = dojo;
}

var setHistoricTimeValue = function (){
	//console.debug("[chartLayout.jsp].setHistoricTimeValue: entry");
	dojo.byId("<%=minValueId%>").value = dojo.number.format(arguments[0][0], { pattern:'##0' });
	var minTime = dojo.byId('<%=minValueId%>').value;
	dojo.byId("<%=maxValueId%>").value = dojo.number.format(arguments[0][1], { pattern:'##0' });
	var maxTime = dojo.byId('<%=maxValueId%>').value;

	updateTimeWindow(minTime, maxTime, getHistoricMode());
	//console.debug("[chartLayout.jsp].setHistoricTimeValue: exit");
}

var setMinMaxTimeValue = function (){
  	//console.debug("[chartLayout.jsp].setMinMaxTimeValue: entry");
    var minTime = dojo.byId('<%=minValueId%>').value;
    if (minTime==null || minTime=="") {
        dojo.byId('<%=minValueId%>').value = "0";
        minTime = "0";
    }
    var maxTime = dojo.byId('<%=maxValueId%>').value;
    if (maxTime==null || maxTime=="") {
        dojo.byId('<%=maxValueId%>').value = "100";
        maxTime = "100";
    }
    
	updateTimeWindow(minTime, maxTime, getHistoricMode());
  	//console.debug("[chartLayout.jsp].setMinMaxTimeValue: exit");
}

var getHistoricMode = function() {
	var historicMode="<%=historicMode%>";
	var timeWindowBox = dojo.byId("<%=timeWindow%>");
	if (timeWindowBox)
    	historicMode = timeWindowBox.options[timeWindowBox.selectedIndex].value;
	
	if (historicMode == null || historicMode == "")
		historicMode = "LIVE";
	
	//console.debug("[chartLayout.jsp].getHistoricMode exit " + historicMode);
	return historicMode;
}

var updateTimeWindow = function(minTime, maxTime, historicMode) {
	//console.debug("[chartLayout.jsp].updateTimeWindow entry " + minTime + ", " + maxTime + ", " + historicMode);
	
	var location = "<%=request.getContextPath() + "/" + detailFormAction%>?changePrefs=true&selectedRefId=<%=refId%>&contextType=<%=contextType%>&type=" + type + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&filter=" + filter + "&metric=" + metric + "&datasets=" + datasets + "&currWindow=<%=currWindow%>&showShapes=" + showShapes + "&showGoals=" + showGoals + "&size=" + size + "&historicMode=" + historicMode + "&minTime=" + minTime + "&maxTime=" + maxTime + "&csrfid=" + "<%=csrfIdValue%>";
	setState = scriptScope.doXmlHttpRequest(location);
    setState = setState.substring(0,setState.indexOf("+endTransmission"));
   
    scriptScope.reload();
	//console.debug("[chartLayout.jsp].updateTimeWindow exit");
}

//_container_.addOnLoad(init);
</script>

<%
	String setChartSelectionCall = "scriptScope.setChartSelections(dojo.byId('" + filterId + "'), dojo.byId('" + datasetName + "'), dojo.byId('" + metricId + "'))";
	String selectChartCall = "scriptScope.selectChart(dojo.byId('chartType'), dojo.byId('" + chartScope + "'), dojo.byId('" + chartScopeName + "'), dojo.byId('" + subdomainId + "'), dojo.byId('" + filterId + "'), dojo.byId('" + datasetName + "'), dojo.byId('" + metricId + "'))";

	String display = "";
	boolean disableHistoric = false;
	String visible="visible";
	if (chartLite.equalsIgnoreCase("true")) { 
	    disableHistoric = true;
		display = "none";
		visible="hidden";
	}

    boolean isSingleChart = false;
    if (request.getParameter("single") != null) {
        isSingleChart = true;
%>
<SCRIPT language="JavaScript">
<!--
function WasClosed () {
    // Disable for now
    // returnChart();
}
window.onunload = WasClosed;
-->
</SCRIPT>
<br>
<input class="buttons" type="button" name="movechart"
    value="<bean:message key="move.chart.to.console"/>"
    onclick="returnChart();" />
<br>
<br>
<% } %>
<% //System.out.println("chartLayout::02"); %> 
<% if (!chartLite.equalsIgnoreCase("true")) { %>
    <div id="chartingPreferences" style="background-color:#FFFFFF;position:absolute;top:8;left:340;width:100;display:block;z-index:499;">
      <table border="0" cellpadding="2" cellspacing="0" valign="top" width="100%" role="presentation" >
          <tbody>
            <tr valign="top"> 
              <td class="table-text-white" id="table_prefs" nowrap> 
                <a href="javascript:showHideSection('com_ibm_ws_chart_prefsTable_<%=selectedRefId%>')" CLASS="expand-task">
                <img id="prefsTableImg" SRC="<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/images/popup_icon.gif" alt="" title="" border="0" align="texttop"/>
                <bean:message key="statustray.preferences.label" /></a>
              </td>
            </tr>
            </tbody>
      </table>
    </div>
<% } %>
<div id="div_<%=selectedRefId%>" parseWidgets="false">
</div>
<% //System.out.println("chartLayout::03"); %>
<html:form name="<%=detailFormName%>" action="<%=detailFormAction%>" type="<%=detailFormType%>" styleId="<%=detailFormId%>">
	<input type="hidden" name="selectedRefId" value="<%=refId%>"/>
	<input type="hidden" name="currWindow" value="<%=currWindow%>"/>
	<%//System.out.println("chartLayout::04"); %>
	<table cellspacing="5" cellpadding="3" width="100%" class="layout-border" role="presentation" border="0">
		<tbody>
		    <tr style="display:<%=display%>;" >
			<td>
				  <div id="HistoricDropDown_<%=refId%>" class="find-filter">
				  	<label for="<%=timeWindow%>" class="hidden">
				  		<bean:message key="ops.requestmanagement.application.historic.mode"/>
				  	</label>
					<html:select property="timeWindow" styleId="<%=timeWindow%>" disabled="<%=disableHistoric%>"  onchange="scriptScope.setHistoricMode(this)">
							<% for (int j = 0; j < sizeOfAvailableHistoricModes; j++) {
								String key = "xdoperations.live.window";
								String currtype = availableHistoricModes[j];
								//System.out.println("currtype::" + currtype);
								if (currtype.equalsIgnoreCase("live")){
									key = "xdoperations.live.window";
								} else {
									key = "xdoperations.time.window." + currtype.toLowerCase() ;
								}
								//System.out.println("key::" + key); 
							%>
								<html:option value="<%=currtype%>">
									<bean:message key="<%=key%>" />
								</html:option>
							<% } %>
					</html:select>
					</div>
			</td>
			</tr>

		<% 
            String ua = request.getHeader( "User-Agent" );
            boolean isMSIE = ( ua != null && ua.indexOf( "MSIE" ) != -1 );
            String displayStr = "display: none;";
            if (visible == "visible") {
            	displayStr = "";
            }
            if (isMSIE) { %>
            
				<tr style="<%=displayStr%>"><td class="find-filter">
					<!-- If input type is hidden, then it is invalid to have the for attribute in the label. -->
					<% if (visible == "visible") { %>
						<label for="<%=minValueId%>">
					<% } else { %>
						<label>
					<% } %>
						<bean:message key="xdoperations.time.min"/>
					</label>
					<input TYPE="<%=visible%>" id="<%=minValueId%>" class="textEntry" onBlur="setMinMaxTimeValue()" size="10" value="0" title="<bean:message key="xdoperations.time.min"/>"/>
					<br/>
					<% if (visible == "visible") { %>
						<label for="<%=maxValueId%>">
					<% } else { %>
						<label>
					<% } %>
						<bean:message key="xdoperations.time.max"/>
					</label>
					<input TYPE="<%=visible%>" id="<%=maxValueId%>" class="textEntry" onBlur="setMinMaxTimeValue()" size="10" value="100" title="<bean:message key="xdoperations.time.max"/>"/>
					<br/><br/>
				</td></tr>

            <% } else { %>

	            <tr style="<%=displayStr%>"><td>
	            	<div class="tundra" id="hrslider_<%=refId%>" discreteValues="10" onChange="setHistoricTimeValue"
							style="width:500px;" value="0,100" intermediateChanges="false" 
							dojoType="dojox.form.HorizontalRangeSlider" role="region" aria-label="<bean:message key="svg.chart.time"/>">
						<ol dojoType="dijit.form.HorizontalRuleLabels" container="topDecoration" style="height:1.2em;font-size:75%;color:gray;<%=displayStr%>" count="10"></ol>
						<div dojoType="dijit.form.HorizontalRule" container="topDecoration" count=10 style="height:10px;margin-bottom:-5px;<%=displayStr%>"></div>
					</div>
				</td></tr>
				<tr style="<%=displayStr%>"><td class="find-filter">   
					<!-- If input type is hidden, then it is invalid to have the for attribute in the label. -->
					<% if (visible == "visible") { %>
						<label>
					<% } else { %>
						<label>
					<% } %>
						<bean:message key="xdoperations.time.min"/>
					</label>
					<input TYPE="<%=visible%>" readonly id="<%=minValueId%>" size="10" value="0" class="textEntryReadOnly" title="<bean:message key="xdoperations.time.min"/>"/>
					<br/>
					<% if (visible == "visible") { %>
						<label>
					<% } else { %>
						<label>
					<% } %>
						<bean:message key="xdoperations.time.max"/>
					</label>
					<input TYPE="<%=visible%>" readonly id="<%=maxValueId%>" size="10" value="100" class="textEntryReadOnly" title="<bean:message key="xdoperations.time.max"/>"/>
					<br/><br/>
				</td></tr>

            <% } %>
            	<tr><td class="find-filter">
					<%@ include file="tableControlsLayout.jspf" %>
					<% //System.out.println("chartLayout::05"); %>
					<div id="com_ibm_ws_chart_settings_<%=selectedRefId%>"
						style="display: <%=prefsState%>; position: absolute; top: 5; left: 15; border-top: 1px solid #E2E2E2; border-left: 1px solid #E2E2E2; border-right: 3px outset #CCCCCC; border-bottom: 3px outset #CCCCCC; z-index: 101; background-color: #eeeeee">

						<table cellspacing="0" cellpadding="5" border="0" role="presentation">							
							<tbody id="<%=scopeNameWarning%>" style="display:none">
                       			<tr>
                       				<td class="warning" valign="top">
                       					<H3><bean:message key="object.instance.warning"/></H3>
                       				</td>
                       			</tr>                     			
                       		</tbody>
					   <% //System.out.println("chartLayout::06"); 
					    //System.out.println("scopeTable="+scopeTable);
						//System.out.println("scopeState="+scopeState);
					   %>
							<tbody ID="<%=scopeTable%>" style="display:<%=scopeState%>">
								<tr>												
									<td class="find-filter" valign="top">
										<H3 style="font-size:100%;margin-left:0.5em"><bean:message key="object.type.desc"/></H3>                                                        
            							<table  cellspacing="0" cellpadding="2" border="0" role="presentation">
											<tr>
												<td class="find-filter" valign="top">        
													<label for="<%=chartScope%>"><bean:message key="object.type"/></label><br/>
													
													<html:select property="scope" styleId="<%=chartScope%>" onchange="<%=selectChartCall %>">													
													<%
													//System.out.println("chartScope="+chartScope);
													//System.out.println("chartScopeName="+chartScopeName);
												   	for (int n = 0; n < scopes.size(); n++) {
														String currscope = (String) scopes.get(n);
														//System.out.println("currscope="+currscope);
														String key = "scope." + currscope + ".name"; 
														//System.out.println("chartLayout::key:: "+key);%>
														<html:option value="<%=currscope%>">
															<bean:message key="<%=key%>" />
														</html:option>
													<% } %>
													</html:select>
												</td>
												<%//System.out.println("chartLayout:: end scope");%>
												
												<% String chartScopeVisible = "display:none";
												   if (!scope.equals(CacheConstants.SCOPES[CacheConstants.ALL])) {
												       chartScopeVisible = "display:block";
												   } 
												   //System.out.println("scope="+scope);
												   //System.out.println("chartScopeVisible="+chartScopeVisible);
												   %>
												<td class="find-filter" valign="top" style="<%=chartScopeVisible%>" >
														<label for="<%=chartScopeName%>"><bean:message key="object.instance"/></label><br/>					
														<select id="<%=chartScopeName%>" onchange="<%=selectChartCall%>">													
														<%for (int n = 0; n < names.size(); n++) {
															String currname = (String) names.get(n);
															if (currname.trim().equals("-- Select Name --")) {%>
																<option value="<%=currname%>">
																	<bean:message key="select.name" />
																</option>
															<%} else if (currname.trim().equals("-- Select an application/EJB pair --")) {%>
																<option value="<%=currname%>">
																	<bean:message key="select.app.ejb.pair" />
																</option>
															<%} else {%>
																<option value="<%=currname%>">
																	<%=currname%>
																</option>
															<%}%>
														<%}%>
														</select>
												</td>
												<%//System.out.println("chartLayout:: end scope name");%>
																
												
											</tr>
										</table>
									</td>
								</tr>
							</tbody>

                       		<tbody ID="<%=subdomainTable%>" style="display:<%=subdomainState%>">
                         		<TR>
                           			<td class="find-filter" valign="top">	
                           				<h3 title="<bean:message key="data.set.title"/>" style="font-size:100%;margin-left:0.5em"><bean:message key="data.set.desc"/></h3>
            							<bean:message key="data.set.subdesc"/>
            							<table  cellspacing="0" cellpadding="2" border="0" role="presentation">
                               				<tr>
                                				<td class="find-filter" valign="top">						
													<label for="<%=subdomainId%>"><bean:message key="data.set.type" /></label><br>
													<html:select property="subdomain" styleId="<%=subdomainId%>" onchange="<%=selectChartCall %>">													
													<%for (int n = 0; n < subdomains.size(); n++) {
														String currsubdomain = (String) subdomains.get(n);
														String key = "scope." + currsubdomain + ".name";
														if (currsubdomain.equals("none")) { %>
															<html:option value="none">
																<bean:message key="data.set.none.label"/>
															</html:option>				                                      
														<%} else {%>
															<html:option value="<%=currsubdomain%>">
																<bean:message key="<%=key%>" />
															</html:option>
														<%}%>												
													<%}%>
													</html:select>
												</td>
												<%//System.out.println("chartLayout:: end subdomain");%>

												<td class="find-filter">
													<label for="<%=datasetName%>"><bean:message key="data.set" /></label><br>
													<html:select multiple="true" size="5" property="dataset" styleId="<%=datasetName%>" onchange="<%=setChartSelectionCall%>">
													<%for (int n = 0; n < availDataSets.size(); n++) {
														String currdataset = (String) availDataSets.get(n);
														if (currdataset.trim().equals("-- Select Name --")) {%>
															<html:option value="<%=currdataset%>">
																<bean:message key="select.name" />
															</html:option>
														<%} else { %>
															<html:option value="<%=currdataset%>">
																<%=currdataset%>
															</html:option>
														<%}%>
													<%}%>
													</html:select>
												</td>
												<%//System.out.println("chartLayout:: end dataset");%>
											</tr>
										</table>
									</td>
								</tr>

								<tr>
                                    <td class="find-filter" valign="top">
                                		<H3 style="font-size:100%;margin-left:0.5em"><bean:message key="metric.desc"/></H3>   
                        			                       
                        				<table  cellspacing="0" cellpadding="2" border="0" role="presentation">
											<tr>
								
												<td nowrap class="find-filter" align="left" valign="top">
				                                    <label FOR="<%=metricId%>"><bean:message key="metric.label"/></label><br/> 
																			
													<% if (scope.equals(CacheConstants.SCOPES[CacheConstants.PART])) { %>
													
													<html:select property="metric" styleId="<%=metricId%>" onchange="<%=setChartSelectionCall%>">
														<%for (int n = 0; n < metrics.size(); n++) {
															String currmetric = (String) metrics.get(n);
															if (currmetric.equalsIgnoreCase(CacheConstants.METRICS[CacheConstants.NONE]))
																continue;
															String key = "xdoperations.metric." + currmetric + ".name";
															boolean cumulative = false;
														
															if (currmetric.equalsIgnoreCase(CacheConstants.METRICS[CacheConstants.RTCUM])) {
																cumulative = true;
																key = "xdoperations.metric.rt.name";
															} else if (currmetric.equalsIgnoreCase(CacheConstants.METRICS[CacheConstants.TTCUM])) {
																key = "xdoperations.metric.tt.name";
																cumulative = true;
															}%>
															<html:option value="<%=currmetric%>">
																<bean:message key="<%=key%>" />
																<%if (cumulative) {%>
																	(<bean:message key="xdoperations.metric.cumulative" />)
																<%}%>
															</html:option>
														<%}%>
													</html:select>
													
													<% } else { %>
													
														<html:select multiple="true" size="5" property="metric" styleId="<%=metricId%>" onchange="<%=setChartSelectionCall%>">
															<% for (int n = 0; n < metrics.size(); n++) {
																String currmetric = (String) metrics.get(n);
																String key = "xdoperations.metric." + currmetric + ".name";
																boolean cumulative = false;
													
																if (currmetric.equalsIgnoreCase(CacheConstants.METRICS[CacheConstants.RTCUM])) {
																	cumulative = true;
																	key = "xdoperations.metric.rt.name";
																} else if (currmetric.equalsIgnoreCase(CacheConstants.METRICS[CacheConstants.TTCUM])) {
																	key = "xdoperations.metric.tt.name";
																	cumulative = true;
																} %>
																<html:option value="<%=currmetric%>">
																	<bean:message key="<%=key%>" />
																	<%if (cumulative) {%>
																		(<bean:message key="xdoperations.metric.cumulative" />)
																	<% } %>
																</html:option>
															<% } %>
														</html:select>													
													<% } %>														
												</td>		
												<%//System.out.println("chartLayout:: end metric");%>						
											</tr>                         
                            			</table>                         
									</td>
        						</tr>
							</tbody>
							
							<tbody ID="<%=ODRFiltersToggle%>" STYLE="display:<%=subdomainState%>;">
                                <tr>
                                   	<td>
                                   	  <table role="presentation">
                                   	    <tr>
                                   	      <td>
	    									<input TYPE="CHECKBOX" id="<%=odrfilter%>" VALUE="odrfilter" ONCLICK="scriptScope.showHidePrefs('<%=ODRFilterDiv%>')"/>
                                   	      </td>
	                                   	  <td class="find-filter" valign="middle">
    									    <label for="<%=odrfilter%>">
    										  <bean:message key="filter.desc"/>
   										    </label>
   										  </td>
                                   	    </tr>
                                   	  </table>

                                      <div id="<%=ODRFilterDiv%>" style="position:relative;display:none">
                                        <table style="margin-left:2.5em" role="presentation">
                                     	  <tr>
                                     	    <td class="find-filter">
                                     	      <label for="<%=filterId%>"><bean:message key="ops.requestmangagement.odr"/></label><br />
                                        	  <html:select size="3" multiple="true" property="filter" styleId="<%=filterId%>" onchange="<%=setChartSelectionCall%>">
        										<%for (int n = 1; n < filters.size(); n++) {%>
        										  <html:option value="<%=(String) filters.get(n)%>">
        										    <%=(String) filters.get(n)%>
        										  </html:option>
        										<%}%>
            								  </html:select>
                                     	    </td>
                                     	  </tr>
                                     	</table>
                                      </div>   
                                  	</td>
                               	</tr>
                     		</tbody>
                                
                            <tbody id="submitButtons_<%=selectedRefId %>" style="display:block">
	                        	<tr>
	                            	<td CLASS="find-filter" valign="top">                          
	                        			<INPUT TYPE="button" NAME="OK" VALUE="<bean:message key="button.ok"/>" class="buttons-filter"  id="metricAddOKButton_<%=selectedRefId %>" onclick="<%=selectChartCall%>">
	                        			<INPUT TYPE="button" NAME="Cancel" VALUE="<bean:message key="button.cancel"/>" class="buttons-filter"  ONCLICK="scriptScope.cancelButton();"/>
	                            	</td>
	                            </tr>
	                       	</tbody>
							
						</table>
					</div>
					<%String location = response.encodeURL(request.getContextPath() + "/" + detailFormAction + "?currWindow=" + currWindow + "&contextType=" + contextType + "&selectedRefId=" + selectedRefId + "&scope=" + scope + "&name=" + name + "&csrfid=" + csrfIdValue);%>
				
				<%@ include file="dataSetsTableLayout.jspf" %>
				
				</td>
			</tr>
		</tbody>
	</table>
</html:form>

<script>
//console.debug("[chartLayout.jsp].this: "+this);
this.setSelectBox();
this.setHistoricModeBox();
init<%=multiChartRefId%>();
positionChartPrefs();

var enableRefresh = '<%=enableRefresh%>';
//console.debug('[chartLayout.jsp].main: enableRefreshRate =' + enableRefresh);
<% if (historicMode.equalsIgnoreCase("LIVE")) { %>
	if (enableRefresh == 'true') {
		var rate = '<%=refreshInterval%>';
		//console.debug('[chartLayout.jsp].main: rate =' + rate);
	<% if (isSingleChart) { %>
	    intervalId = window.setInterval( 'reload()', rate * 1000 );
	<% } else { %>
	    //intervalId = window.setInterval( 'window.reloadChart("<%=selectedRefId%>")', rate * 1000 );
		intervalId = window.setInterval( 'reload()', rate * 1000 );
	<% } %>	
	//console.debug('[chartLayout.jsp].main: intervalId =' + intervalId);
	}
<% } else { %>
	window.clearInterval(intervalId);
	//console.debug('[chartLayout.jsp].main: cleared Interval as historicMode =' + "<%=historicMode%>");
<% } %>

if (<%=tabContainerExists%>) {
	//need to update tab label if scope changed
	var tabContainer = dijit.byId("chartTabContainer");
	if (tabContainer) {
		//console.debug('[chartLayout.jsp].main: tabContainer' + tabContainer);
		var selectedTab = tabContainer.selectedChildWidget;
		
		tabContainer.setTitle = function(tab, title) { 
		//console.debug('chartLayout.jsp].tabContainer.setTitle: tab = ' + title);
		tab.set('title', title);
		this.tablist.pane2button[tab].set('label', title); 
		};
		
		if (selectedTab) {
			//console.debug('chartLayout.jsp].main: selectedTab = ' + selectedTab);
			<%
			String label = name;
			if (name.trim().equals("-- Select Name --")) { 
				label = getString("select.name", msgs, request);
			} else if (name.trim().equals("-- Select an application/EJB pair --")) {
				label = getString("select.app.ejb.pair", msgs, request);
			}
			%>
			var button = selectedTab.controlButton; 
			button.set("label", "<%=label%>"); 
			selectedTab.set('title', "<%=label%>");		
		    tabContainer.set('title', "<%=label%>");
		    //console.debug('chartLayout.jsp].main: selectedTab = ' + selectedTab);
			
		}
	}
}

</script>

<%
//System.out.println("chartLayout:: after scripts");
} catch (Throwable t) {
	System.err.println("chartLayout::cause:: " + t.getCause());
	System.err.println("chartLayout::message:: " + t.getMessage());	
	t.printStackTrace();
}%>
