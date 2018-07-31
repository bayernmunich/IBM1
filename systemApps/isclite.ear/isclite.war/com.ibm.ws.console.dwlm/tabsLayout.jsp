<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext,java.util.*"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="org.apache.struts.tiles.beans.SimpleMenuItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="selectUri" classname="java.lang.String" />
<tiles:useAttribute name="tabList" classname="java.util.List" />
<tiles:useAttribute name="formName" classname="java.lang.String" />

<bean:define id="contextId" name="<%=formName%>" property="contextId" type="java.lang.String" toScope="request"/>
<bean:define id="perspective" name="<%=formName%>" property="perspective" type="java.lang.String" toScope="request"/>
<bean:define id="clusterName" name="<%=formName%>" property="clusterName" type="java.lang.String"/>

<!-- gets all the link items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri(contextId);

String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;


java.util.ArrayList tabList_ext =  new java.util.ArrayList();
for(int i=0;i<tabList.size(); i++)
     tabList_ext.add(tabList.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.detailTab";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions= registry.getExtensions(extensionId,ic);

if(extensions!=null && extensions.length>0){
    if(contextId!=null && contextId!="nocontext"){
      props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }

    tabList_ext = TabSelector.getTabs(extensions,tabList_ext,props);
}

    pageContext.setAttribute("tabList_ext",tabList_ext);

// RTC149386 - Behavior added in RTC135010 should not be in 855 fixpacks, should be vNext
// Read the version number and use condition to dynamically undo changes if version is 8.5.x.x
// Once this code is wholly contained in a vNext version (from 855 perspective), check and if statements can be removed
final int[] wasVersion = ConfigUtils.getWASVersionInts();
final boolean accessibilityEnabled = wasVersion[0] != 8 || wasVersion[1] != 5;
    
 %>






<bean:define id="perspectiveValue" name="<%= formName %>" property="perspective"/>
<bean:define id="mbeanId" name="<%= formName %>" property="mbeanId"/>

<% String selectedBody = null;%>

<table border="0" cellpadding="0" cellspacing="0"  width="100%" role="presentation">
<tr valign="top">
<%  List list = (List) tabList_ext;
    Iterator iter = list.iterator();
    
    //RTC135010/CMVC757616 - List of tab names for helper JavaScript
  	List<String> tabNames = new java.util.ArrayList<String>();
    
    while (iter.hasNext()) {
    org.apache.struts.tiles.beans.SimpleMenuItem tab = (org.apache.struts.tiles.beans.SimpleMenuItem) iter.next();

    boolean showItem = true;
    if (SecurityContext.isSecurityEnabled()) {
        showItem = false;

        String[] roles = {"administrator", "operator", "configurator", "monitor"};
        if (tab.getTooltip() != null && tab.getTooltip().equals("") == false) {
            StringTokenizer st = new StringTokenizer(tab.getTooltip(), ",");
            ArrayList al = new ArrayList();
            while(st.hasMoreTokens()) {
                al.add(st.nextToken());
            }
            roles = new String[al.size()];
            roles = (String[])al.toArray(roles);
        }

        for (int idx = 0; idx < roles.length; idx++) {
            if (adminAuthorizer.checkAccess(contextUri, roles[idx])) {
                showItem = true;
                break;
            }
        }
    }
    //skip displaying tab if showItem is false
    if (showItem == false) {
        continue;
    }

    String value = (String) perspectiveValue;
    String tabValue = tab.getValue();
    String href = selectUri + "?EditAction=true&perspective=" + tabValue ;
    boolean skipRuntime=false;

    javax.management.ObjectName dwlmON = null;
    String mbeanString = "WebSphere:*,type=" + com.ibm.ws.dwlm.controller.DWLMController.MBEAN_TYPE + ",cluster=" + clusterName;
    javax.management.ObjectName namePattern = new javax.management.ObjectName( mbeanString );
    java.util.Set s = com.ibm.websphere.management.AdminServiceFactory.getAdminService().queryNames( namePattern, null );
    if ( s != null && s.size() > 0 ) {
       dwlmON = (javax.management.ObjectName) s.iterator().next();
    }

    if(dwlmON == null) skipRuntime = true;

    //skip displaying runtime tab if managedbeanId is blank
    if ( (skipRuntime) && (tabValue.equalsIgnoreCase("tab.runtime")) ) {
          continue;
    }
    tabNames.add(tabValue); //RTC135010/CMVC757616 - Add tab value to names list
%>


    <% if (tabList_ext.size() == 1)  {
	  selectedBody = tab.getLink();
	  //RTC135010/CMVC757616 - In this section, onkeydown, id, and tabindex attributes added, as well as <a> for tabs-on
    %>	
    <td class="tabs-on" width="1%" nowrap height="15">
        <% if (accessibilityEnabled) { %><a class="tabs-item"  href="<%=href%>" title="<bean:message key='<%=tab.getValue()%>'/>"><% } %>
        	<bean:message key='<%=tab.getValue()%>'/>
        <% if (accessibilityEnabled) { %></a><% } %>
    </td>
     <% } else if ((tabList_ext.size() > 1)  && (value.equalsIgnoreCase(tabValue))) {
		selectedBody = tab.getLink();
	%>
	<td class="tabs-on" role="tab" width="1%" nowrap height="15" id="<%=tab.getValue()%>" onkeydown="switchTabs(event, '<%=tab.getValue()%>')">
        <% if (accessibilityEnabled) { %><a class="tabs-item" tabindex="0" id="link<%=tab.getValue()%>" href="<%=href%>" title="<bean:message key='<%=tab.getValue()%>'/>"><% } %>
        	<bean:message key='<%=tab.getValue()%>'/>
        <% if (accessibilityEnabled) { %></a><% } %>
    </td>

        <td class="blank-tab" width="1%" nowrap height="15">
        <img src="<%=request.getContextPath()+"/"%>images/onepix.gif" width="2" height="10" align="absmiddle" alt="">
        </td>


    <% } else if ((tabList_ext.size() > 1)  && (!value.equalsIgnoreCase(tabValue))) {   %>
	 <td class="tabs-off" role="tab" width="1%" nowrap height="19" id="<%=tab.getValue()%>">
        <a class="tabs-item" tabindex="-1" id="link<%=tab.getValue()%>" href="<%=href%>" title="<bean:message key='<%=tab.getValue()%>'/>"><bean:message key='<%=tab.getValue()%>'/></a>
     </td>

        <td class="blank-tab" width="1%" nowrap height="15">
        <img src="<%=request.getContextPath()+"/"%>images/onepix.gif" width="2" height="10" align="absmiddle" alt="">
        </td>


   <% } %>

<% } %>
    <td class="blank-tab" width="99%" nowrap height="15">
        <img src="<%=request.getContextPath()+"/"%>images/onepix.gif" width="1" height="10" align="absmiddle" alt="">
    </td>

</tr>
</table>

<table border="0" cellpadding="10" cellspacing="0" valign="top" width="100%" summary="Framing Table">
<tr>
<td class="layout-manager">
<tiles:insert name="<%=selectedBody%>" flush="true" />
</td>
</tr>
</table>
<% if (accessibilityEnabled) { %>
<script>
//RTC135010: Adapted from CMVC757616 - Adds accessible functionality to most tab panels
focusTab = function(){
	var tabToFocus = document.getElementsByClassName("tabs-on")[0];
	tabToFocus = tabToFocus.firstChild.nextSibling;
	tabToFocus.focus();
}
dojo.addOnLoad(focusTab);
var tabNames = [];
<% for (int i = 0; i < tabNames.size(); ++i) { %>
tabNames[<%=i%>] = '<%=tabNames.get(i)%>';
<% } %>
switchTabs = function(event, currentTab){
	var forward = false;
	var backward = false;
	if(event.keyCode == dojo.keys.LEFT_ARROW || event.keyCode == dojo.keys.UP_ARROW)
		backward = true;
	if(event.keyCode == dojo.keys.RIGHT_ARROW || event.keyCode == dojo.keys.DOWN_ARROW)
		forward = true;
	if(backward || forward){
		var tabToTurnOff = document.getElementById(currentTab);
		var linkToTurnOff = document.getElementById("link"+currentTab);
		var chosenTab;
		tabToTurnOff.className="tabs-off";
		tabToTurnOff.classList.add('tabs-off');
		var i = 0;
		while(tabNames[i] != currentTab){i++;}
		if(backward){
			if(i==0)
				chosenTab = tabNames[tabNames.length-1];
			else
				chosenTab = tabNames[i-1];
		}
		if(forward){
			if(i==tabNames.length-1)
				chosenTab = tabNames[0];
			else
				chosenTab = tabNames[i+1];
		}
		var tabToTurnOn = document.getElementById(chosenTab);
		var linkToTurnOn = document.getElementById("link"+chosenTab);
		tabToTurnOn.className = "tabs-on";
		tabToTurnOn.classList.add('tabs-on');
		window.location.href = linkToTurnOn.href;
		linkToTurnOn.focus();
	}
}
//End of RTC135010
</script>
<% } %>