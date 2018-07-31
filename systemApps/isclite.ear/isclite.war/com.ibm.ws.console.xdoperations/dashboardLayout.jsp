<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004,2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.chart.ChartCollectionForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.chart.ChartDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PreferencesDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.Constants"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.PreferencesUtil"%>

<%@ page errorPage="/secure/error.jsp"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<ibmcommon:detectLocale />

<script type="text/javascript" language="JavaScript"
	src="<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/svgchart.js"></script>

<table role="presentation">

<%
  //System.out.println("dashboardLayout.jsp:entry");
  PreferencesDetailForm prefsDetailForm = (PreferencesDetailForm) session.getAttribute("PreferencesDetailForm");
  PropertyGroupDetailForm propGroupDetailForm = prefsDetailForm.getPropertyGroup();

  MessageResources messages = MessageResources.getMessageResources("com.ibm.ws.console.core.resources.ConsoleAppResources");
  String pleaseWait = messages.getMessage(request.getLocale(),"trace.tree.pleaseWaitLabel");
  pleaseWait.replaceAll("'", "\\\\'");

  ChartCollectionForm collectionForm = (ChartCollectionForm)request.getSession().getAttribute(Constants.CHART_COLLECTION_FORM_KEY);
  //System.out.println("dashboardLayout.jsp:collectionForm: "+collectionForm);
  String enableRefresh = collectionForm.getEnableAutoRefresh();
  String refreshInterval = collectionForm.getRefreshInterval();

  int chartsPerRow = Integer.parseInt(PreferencesUtil.getPropertyValue(propGroupDetailForm, Constants.PREFS_DASHBOARD_CHARTS_PER_ROW));
  String displaySummaryCharts = PreferencesUtil.getPropertyValue(propGroupDetailForm, Constants.PREFS_DASHBOARD_DISPLAY_SUMMARY_CHARTS);
  String displayChartGroupCharts = PreferencesUtil.getPropertyValue(propGroupDetailForm, Constants.PREFS_DASHBOARD_DISPLAY_CHART_GROUP);
  String chartGroup = PreferencesUtil.getPropertyValue(propGroupDetailForm, Constants.PREFS_DEFAULT_CHART_GROUP);
  //System.out.println("dashboardLayout.jsp:chartsPerRow: "+chartsPerRow);
  Hashtable targets = collectionForm.getTargets();
  //System.out.println("dashboardLayout.jsp:targets: "+targets);
  Hashtable tabTable = collectionForm.getTabTable();
  //System.out.println("dashboardLayout.jsp:tabTable: "+tabTable);
  Set targetKeys = targets.keySet();
%>

<script type="text/javascript">
	this.reloadCharts = function () {
	<% 
		for (Iterator i_targetKeys = targetKeys.iterator(); i_targetKeys.hasNext();) {
	  		String target = (String)i_targetKeys.next();
	  		ArrayList tabList = (ArrayList)tabTable.get(target);

	  		for (int k=0; k<tabList.size(); k++) {
		  		ChartDetailForm detailForm = (ChartDetailForm) tabList.get(k);%>
		  		objectId = "<%=detailForm.getRefId()%>";
		    	if (dojo.byId(objectId)) {
					if (dojo.byId) {
						if (dojo.byId("svg"+objectId) != null) {
							try {
								dojo.byId("svg"+objectId).reload();
							} catch (e) {
								if (dojo.byId("svg"+objectId).getSVGDocument() != null) {
									dojo.byId("svg"+objectId).getSVGDocument().rootElement.suspendRedraw(100);
									dojo.byId("svg"+objectId).getSVGDocument().location.reload(); //322754 for Firefox 1.5
								}
							}
						} else {
						  	if (dojo.byId('jpeg'+objectId) != null) {
						   		dojo.byId('jpeg'+objectId).src = 'ChartServlet?selectedRefId='+objectId+'&format=jpeg&contextType=DashboardOperations&currWindow=detail&random=' + Math.random() + '&isIE=' + isIE;
								document.getElementById("com_ibm_ws_chart_settings_"+objectId).style.zIndex = 500;
								document.getElementById("chartingPreferences").style.zIndex = 499;
						   	}
						}
					}
				}<%
      		}
      	}
	%>
	}
</script>

<%
  int count = 0;
  int chartGroupCount = 1;
  for (Iterator i_targetKeys = targetKeys.iterator(); i_targetKeys.hasNext();) {
	  String target = (String)i_targetKeys.next();
	  //System.out.println("dashboardLayout.jsp:target: "+target);
	  ArrayList tabList = (ArrayList)tabTable.get(target);

	  for (int k=0; k<tabList.size(); k++) {
		  if (count%chartsPerRow == 0) { %><tr><% }
		  ChartDetailForm detailForm = (ChartDetailForm) tabList.get(k);
		  //System.out.println("dashboardLayout.jsp:detailForm: "+detailForm.getRefId());
	  	  StringTokenizer st = new StringTokenizer(target, "*");
		  String contextType = st.nextToken();
	      //System.out.println("dashboardLayout.jsp:contextType: "+contextType);
	      
	      if ( (contextType.contains("Summary") && displaySummaryCharts.equals("true"))
	    		  || (chartGroup != null && !chartGroup.equals("") && chartGroup.equals(detailForm.getChartGroup()) && displayChartGroupCharts.equals("true"))) {
		      //System.out.println("dashboardLayout.jsp:trying to get a chart");
		  	  request.setAttribute("chartLite", "true");
		  	  request.setAttribute("dashboard", "true");
		  	  request.setAttribute("contextType", contextType);
	    	  request.setAttribute("refId", detailForm.getRefId());
	    	  String label = "nav.app.summary";
	    	  String isLabelNLSKey = "false";
	    	  if (chartGroup != null && !chartGroup.equals("") && chartGroup.equals(detailForm.getChartGroup()) && displayChartGroupCharts.equals("true")) {
	    		  label = chartGroup +" "+chartGroupCount++;
	    		  isLabelNLSKey = "false";
	    	  } else {
	    		  isLabelNLSKey = "true";
	    		  if (contextType.contains("Application"))
	    			  label = "nav.app.summary";
	    		  else if (contextType.contains("Deployment"))
		    		  label = "nav.dt.summary";
	    		  else if (contextType.contains("Service"))
		    		  label = "nav.sp.summary";
	    	  }
	    	  %>
		      <td valign="top">
				<div widgetId="<%=detailForm.getRefId()%>" id="<%=detailForm.getRefId()%>" style="overflow: none;" label="blah" dojoType="dojox.layout.ContentPane" scriptSeparation="false" executeScripts="true" refreshOnShow="false" loadingMessage="<%=pleaseWait%>" adjustPaths="false" cacheContent="false">
   			    <tiles:insert page="/com.ibm.ws.console.xdcore/portletLayout.jsp" flush="false">
					<tiles:put name="label" value="<%=label%>" />
					<tiles:put name="desc" value="<%=label%>" />
					<tiles:put name="isLabelNLSKey" value="<%=isLabelNLSKey%>" />
					<tiles:put name="tiledefinition" value="/com.ibm.ws.console.xdoperations/chartLayout.jsp" />
					<tiles:put name="tileDefinitionType" value="page" />
					<tiles:put name="refreshLink" value="com.ibm.ws.console.xdoperations.forwardCmd.do?forwardName=dashboard.xdoperations.main.extends" />
					<tiles:put name="isSubTab" value="false" />
	    	    </tiles:insert>
			  	</div>
		      </td><%
			  if (count%chartsPerRow == 3) { %></tr><% }
	    	  count++;
	      }
	 }
  }
%>
</table>
<script type="text/javascript">
	var enableDashboardRefresh = '<%=enableRefresh%>';
	if (enableDashboardRefresh == 'true') {
		var dashboardRate = '<%=refreshInterval%>';
		window.setInterval( 'window.reloadCharts()', dashboardRate * 1000 );
	}
</script>
