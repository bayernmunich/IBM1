<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>
 
<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page  errorPage="/secure/error.jsp" %>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.console.taskmanagement.util.*"%>
<%@ page import="com.ibm.ws.taskmanagement.util.TaskConstants"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>

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
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="htmlFilter" classname="java.lang.String"/>

<tiles:useAttribute name="isSubTab" ignore="true" classname="java.lang.String" />

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/>

<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%!
String escape(String str){
	if (str == null)
		return str;
	return str.replaceAll("'", "\\\\'");
}

String escapequotes(String str){
	if (str == null)
		return str;
	return str.replaceAll("\"", " ");
}

%>

<%
if (isSubTab == null) { isSubTab = "false"; }
String taskTypeHeader = "null";
String taskTypeNonPlanned = "null";
String taskTypeExecuting = "null";
String taskTypeApproval = "null";
String taskTypeManual = "null";

MessageResources taskTypeMessages = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);
try {
	taskTypeNonPlanned = taskTypeMessages.getMessage(request.getLocale(), "task.type.nonplanned");
} catch (Exception e) {
}
try {
	taskTypeExecuting = taskTypeMessages.getMessage(request.getLocale(), "task.type.executing");
} catch (Exception e) {
}
try {
	taskTypeApproval = taskTypeMessages.getMessage(request.getLocale(), "task.type.approval");
} catch (Exception e) {
}
try {
	taskTypeManual = taskTypeMessages.getMessage(request.getLocale(), "task.type.manual");
} catch (Exception e) {
}
try {
	taskTypeHeader = taskTypeMessages.getMessage(request.getLocale(), "task.type.header");
} catch (Exception e) {
}
%>

<script>
top.taskTypeCollection = "no";
var taskTypeNonPlanned = "<%=taskTypeNonPlanned%>";
var taskTypeExecuting = "<%=taskTypeExecuting%>";
var taskTypeApproval = "<%=taskTypeApproval%>";
var taskTypeManual = "<%=taskTypeManual%>";
var taskTypeHeader = "<%=taskTypeHeader%>";

if (taskTypeNonPlanned == "null") { taskTypeNonPlanned = "Non-Planned" }
if (taskTypeExecuting == "null") { taskTypeNonPlanned = "Executing" }
if (taskTypeApproval == "null") { taskTypeNonPlanned = "Approval" }
if (taskTypeManual == "null") { taskTypeNonPlanned = "Manual" }
if (taskTypeHeader == "null") { taskTypeHeader = "Task Types" }

function openActionPlan(link) {
	var features = "height=600,width=800,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
  	var parentWin = window.name;
	var newWin = open(link, 'ActionPlan', features, parentWin);
}
</script>



<%
String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

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


 %>



<%


if(extensions_preferences!=null && extensions_preferences.length>0){

collectionPreferenceList_ext = PreferenceSelector.getPreferences(extensions_preferences,collectionPreferenceList_ext,props);

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
           }%>

        <tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
            <tiles:put name="parent" value="<%=parent%>"/>
            <tiles:put name="preferences" beanName="preferences" beanScope="session" />
        </tiles:insert>


<html:form action="<%=formAction%>" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">

        <tiles:insert definition="<%=buttons%>" flush="true"/>

                 <table CLASS="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Generic funtions for the table, such as content filtering">
        <tr valign="top">
        <td class="function-button-section"  nowrap>
        <%  
            if (showCheckBoxes.equals ("true"))
            {
        %>
        <A id=selectAllButton" HREF="javascript:iscSelectAll('<%=formName%>')" CLASS="expand-task">
            <IMG id="selectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_select_all.gif" ALT='<bean:message key="select.all.items"/>' title='<bean:message key="select.all.items"/>' BORDER="0" ALIGN="texttop"> 
        </A>
        <A id="deselectAllButton" HREF="javascript:iscDeselectAll('<%=formName%>')" CLASS="expand-task">
            <IMG id="deselectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_deselect_all.gif" ALT='<bean:message key="deselect.all.items"/>' title='<bean:message key="deselect.all.items"/>' BORDER="0" ALIGN="texttop"> 
        </A>  
        <%
            }
		%>
        <A HREF="javascript:showHideFilter()" CLASS="expand-task">
            <IMG id="filterTableImg" align="top" SRC="<%=request.getContextPath()%>/images/<%=filterImage%>.gif" ALT='<bean:message key="show.filter"/>' title='<bean:message key="show.filter"/>' BORDER="0" ALIGN="texttop"> 
        </A>
        
        <A HREF="javascript:clearTMFilter('<%=formName%>')" CLASS="expand-task">
            <IMG  id="clearFilterImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_clear_filters.gif" ALT='<bean:message key="clear.filter.value"/>' title='<bean:message key="clear.filter.value"/>' BORDER="0" ALIGN="texttop"/> 
        </A>
        </td>        
        </tr>
        </table>
            
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

                       if (chkcounter == 0) {
                          if (searchFilter.equals("")) {
                             searchFilter = columnField;
                          }
                       }
                    %>

                        <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
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
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13" ALT="" title=""/>
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
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.ascending"/>" title="<bean:message key="sorted.ascending"/>"></A>
                    <%
                                }
                                else if (order.equalsIgnoreCase ("DSC"))
                                {
                    %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.descending"/>" title="<bean:message key="sorted.descending"/>"></A>
                    <%
                                }
                                else {
                    %>
                            </A>
                    <%			}
                            }
                            else
                            {
                    %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0" align="texttop" ALT="<bean:message key="not.sorted"/>" title="<bean:message key="not.sorted"/>"></A>
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
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13" ALT="" title=""/>
                    <%
                            }
                        }
                    %>
                    <% //add refresh.gif after status column to refresh page
                        if (columnField.equals("status")) { %>
                        		<% if (isSubTab.equals("true")) { %>
                        			<A HREF="javascript:switchTab()">
                        				<IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
                        					 title="<bean:message key="refresh.view"/>"
                        					 ALT="<bean:message key="refresh.view"/>" 
                        					 align="texttop" 
                        					 border="0"/>
                        			</A>
                        		<% } else {%>
							        <A HREF="<%=request.getContextPath()%>/<%=parent%>">
								        <IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
								        	 title="<bean:message key="refresh.view"/>"
								        	 ALT="<bean:message key="refresh.view"/>" 
								        	 align="texttop" 
								        	 border="0"/>
								    </A>
							    <% }
                        }


                       //add refresh.gif after state column to refresh page
						if (columnField.equals("currentState")) {%>
                        		<% if (isSubTab.equals("true")) { %>
                        			<A HREF="javascript:switchTab()">
                        				<IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
                        					 title="<bean:message key="refresh.view"/>"
                        					 ALT="<bean:message key="refresh.view"/>" 
                        					 align="texttop" 
                        					 border="0"/>
                        			</A>
                        		<% } else {%>
							        <A HREF="<%=parent%>">
								        <IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
								        	 title="<bean:message key="refresh.view"/>"
								        	 ALT="<bean:message key="refresh.view"/>" 
								        	 align="texttop" 
								        	 border="0"/>
								    </A>
							    <% }
						}

                        if (!filterDisplay.equals("none")) {
                           if (columnField.equals(searchFilter)) {
                    %>
                                <HR SIZE="1"><bean:message key="quick.search.label"/>: <%=searchPattern%>
                    <%
                           }
                        }


                    %>

                        </TH>

                        <% chkcounter = chkcounter + 1; %>

                        </logic:iterate>
                    </TR>

			
          <bean:define id="selectedStates" name="<%=iterationName%>" property="selectedStates" type="java.util.List"/>
<bean:define id="selectedSeverities" name="<%=iterationName%>" property="selectedSeverities" type="java.util.List"/>

<%
List states = new ArrayList();
states.add(TaskMgmtConstants.ALL);
states.add(TaskMgmtConstants.STATE_NEW);
states.add(TaskMgmtConstants.STATE_RENEWED);
states.add(TaskMgmtConstants.STATE_SUPPRESSED);
states.add(TaskMgmtConstants.STATE_INPROGRESS);
//states.add(TaskMgmtConstants.STATE_INPROGRESS_PREVIEW);
//states.add(TaskMgmtConstants.STATE_INPROGRESS_COMMIT);
//states.add(TaskMgmtConstants.STATE_INPROGRESS_ROLLBACK);
//states.add(TaskMgmtConstants.STATE_PREVIEWED);
states.add(TaskMgmtConstants.STATE_DENIED);
states.add(TaskMgmtConstants.STATE_CLOSED);
states.add(TaskMgmtConstants.STATE_FAILED);
states.add(TaskMgmtConstants.STATE_EXPIRED);
//XD601_M2_LTM1
states.add(TaskMgmtConstants.STATE_SUCCEEDED);
states.add(TaskMgmtConstants.STATE_UNKNOWN);

List severities = new ArrayList();
severities.add(TaskMgmtConstants.ALL);
severities.add(TaskMgmtConstants.SEVERITY_FATAL);
severities.add(TaskMgmtConstants.SEVERITY_CRITICAL);
severities.add(TaskMgmtConstants.SEVERITY_SEVERE);
severities.add(TaskMgmtConstants.SEVERITY_MINOR);
severities.add(TaskMgmtConstants.SEVERITY_WARNING);
severities.add(TaskMgmtConstants.SEVERITY_HARMLESS);
severities.add(TaskMgmtConstants.SEVERITY_INFORMATION);
%>


<script>
function selectFilters() {
	
	var stateBox = document.getElementById("stateFilter");
	var stateFilter = "";
	var stateOpts = stateBox.options;
	for (var n=0; n<stateOpts.length; n++) {
		if (stateOpts[n].selected) {
			if (stateFilter.length == 0)
				stateFilter = stateOpts[n].value;
			else
				stateFilter = stateFilter + ':' + stateOpts[n].value;
		}
	}
	
	var severityBox = document.getElementById("severityFilter");
	var severityFilter = "";
	var severityOpts = severityBox.options;
	for (var m=0; m<severityOpts.length; m++) {
		if (severityOpts[m].selected) {
			if (severityFilter.length == 0)
				severityFilter = severityOpts[m].value;
			else
				severityFilter = severityFilter + ':' + severityOpts[m].value;
		}
	}
	
	alert ('stateFilter=' + stateFilter);
	alert ('severityFilter=' + severityFilter);
	var uri = "/admin/TaskCollection.do?stateFilter=" + stateFilter + "&severityFilter=" + severityFilter;
    uri = uri + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
	alert ('uri=' + uri);
	window.location = uri;
}
</script>


            <TBODY ID="filterControls" STYLE="display:<%=filterDisplay%>">
            <TR  width="100%">
            	<TD CLASS="column-filter-expanded" COLSPAN=<%=chkcounter+1%>>
            		<BR>
            		<bean:message key="task.filter.desc"/>
           	 		<table width="10%" border="0">
            			<tr>
            				<td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
            				   <LABEL for="stateFilter">
            					<b><bean:message key="taskmanagement.detail.currentstate"/></b>
								<BR><IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" BORDER="0" WIDTH="10" HEIGHT="13" ALT="" title=""/>
								<SELECT MULTIPLE SIZE="4" NAME="stateFilter" id="stateFilter">
								
								<%Iterator i_states = states.iterator();
								while (i_states.hasNext()) {
									String state = (String) i_states.next();
									//System.out.println("state=" + state);
									if (selectedStates.contains(state)) {
										//System.out.println("selectedStates contains state");%>
										<OPTION VALUE="<%=state%>" SELECTED="SELECTED">
											<bean:message key="<%=state%>" />
										</OPTION>
									<%} else { %>
										<OPTION VALUE="<%=state%>">
											<bean:message key="<%=state%>" />
										</OPTION>
									<%}
								}%>
								</SELECT>
								</LABEL>
            				
           					 </td>
            				<td NOWRAP CLASS="column-filter-expanded" align="left" valign="top">
            				       <LABEL for="severityFilter">
             						<b><bean:message key="taskmanagement.detail.globalseverity" /></b>
									<BR><IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" BORDER="0" WIDTH="10" HEIGHT="13" ALT="" title=""/>
									<SELECT MULTIPLE SIZE="4" NAME="severityFilter" id="severityFilter">
									
									<%Iterator i_severities = severities.iterator();
									while (i_severities.hasNext()) {
										String severity = (String) i_severities.next();
										//System.out.println("severity=" + severity);
										if (selectedSeverities.contains(severity)) {
											//System.out.println("selectedSeverities contains severity");%>
											<OPTION VALUE="<%=severity%>" SELECTED="SELECTED">
												<bean:message key="<%=severity%>" />
											</OPTION>
										<%} else {%>
											<OPTION VALUE="<%=severity%>">
												<bean:message key="<%=severity%>" />
											</OPTION>
										<%}
									}%>
									</SELECT>
									</label>
						
									<INPUT TYPE="submit" NAME="searchAction" VALUE="<bean:message key='quick.search.go.label'/>" CLASS="buttons-filter" ID="searchAction">
								
            				</td>
            			</tr>
            		</table>
            	</TD>
            </TR>
            </TBODY>




            <% chkcounter = 0; %>


            <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">

            <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
            <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
            <bean:define id="taskType" name="listcheckbox" property="taskType" type="java.lang.String" />
			<bean:define id="taskState" name="listcheckbox" property="currentState" type="java.lang.String" />
			<bean:define id="msg" name="listcheckbox" property="reasonMsg" type="java.lang.String" />

                    <TR CLASS="table-row">

                    <%
                        if (showCheckBoxes.equals("true"))
                        {
                            if ( ConfigFileHelper.isDeleteable(refId) == true)
                            {
                                String delId = (String)resourceUri + "#" + (String) refId ;
                    %>
                        <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            <%  if ( !idColumn.equals("") ) {%>
                            <bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
                            <LABEL class="collectionLabel" for="<%=selectId%>" TITLE='<bean:message key="select.text"/>: <%=selectId%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="selectId%>"/>
                            <%} else { %>
                            <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=refId%>"/>
                            <%}%>
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
                        %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
                    <%
                        columnField = (String)cellItem.getColumnField();
                    %>

                        <TD VALIGN="top"  class="collection-table-text" headers="<%=columnField%>" id="<%=refId%>">

                       <%
                        if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0)
                        {
                        %>
                            <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop" alt="" title=""></IMG>&nbsp;
                        <%
                        }
                if (cellItem.getLink().length() > 0) {
					//System.out.println("column has link: columnField=" + columnField + " taskType=" + taskType);
					String encoding = response.getCharacterEncoding();
                       if(encoding==null)	encoding = "UTF-8";
    				String hRef =
						cellItem.getLink()
							+ "&refId="
							+ URLEncoder.encode(refId,encoding)
							+ "&contextId="
							+ URLEncoder.encode(contextId,encoding)
							+ "&resourceUri="
							+ URLEncoder.encode(resourceUri,encoding)
							+ "&perspective="
							+ URLEncoder.encode(perspective,encoding);%>
						
						<A HREF="<%=hRef%>" alt>
                <%						
				} // end if link
             	if (columnField.equalsIgnoreCase("status")) {
                    if ( statusType.equals("unknown") ) {%>
                    <bean:define id="status" name="listcheckbox" property="status"/>
                    <A target="statuswindow" href="/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>">
                    <IMG name="statusIcon" onfocus='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' onmouseover='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' border="0" SRC="/ibm/console/status?type=<%=statusType%>&status=<%=status%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
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
                        queryString += "&" + col + "=" + URLEncoder.encode((String)colvar , "UTF-8");
                        }
                        String encodedStatusLink = "/ibm/console/status?text=true&type=" + statusType + queryString;
                        String imageSrcLink = "/ibm/console/status?type=" + statusType + queryString;
                        %>
                    <A target="statuswindow" href="<%=encodedStatusLink%>">
                    <IMG name="statusIcon" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' border="0" SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                    </A>
                   <% } %>

				<%} else if (columnField.equalsIgnoreCase("currentState")) {
					if (taskState.equals("closed") || taskState.equals("failed")) { %>
						<bean:define id="finalStatus" name="listcheckbox" property="finalStatus" type="java.lang.String"/>
        				<bean:define id="finalStatusMsg" name="listcheckbox" property="finalStatusMsg" type="java.lang.String"/>
        				
    					<% if (finalStatus.length() > 0) { %>
						<a href="#" onblur="hideTaskPopup();" onfocus="displayTaskPopup('<bean:message key="<%=finalStatus%>"/>: <%=finalStatusMsg%>', '<%=refId%>');" onmouseout="hideTaskPopup();" onmouseover="displayTaskPopup('<bean:message key="<%=finalStatus%>"/>: <%=finalStatusMsg%>', '<%=refId%>');">
					<%	}
					}%>
					
					<iframe class="table-text" frameborder="0" scrolling="no" width="100" height="20" marginwidth="0" marginheight="0" src="/ibm/console/wastask?text=true&taskId=<%=refId%>&type=state">
					</iframe>
					<% if (taskState.equals("closed") || taskState.equals("failed") || taskState.equals("denied")) { %>
						</a>
					<%}%>
				<%} else if (columnField.equalsIgnoreCase("globalSeverity")) {%>
					<iframe class="table-text" frameborder="0" scrolling="no" width="100" height="20" marginwidth="0" marginheight="0" src="/ibm/console/wastask?text=true&taskId=<%=refId%>&type=severity">
					</iframe>

				<%} else if (columnField.equalsIgnoreCase("taskId")) {
					String image = "/ibm/console/com.ibm.ws.console.taskmanagement/images/nonplanned.gif";
					if (taskType.equalsIgnoreCase(Byte.toString(TaskConstants.PLANNEDTASK_TYPE_EXECUTING))) {
						image = "/ibm/console/com.ibm.ws.console.taskmanagement/images/executing.gif";
					} else if (taskType.equalsIgnoreCase(Byte.toString(TaskConstants.PLANNEDTASK_TYPE_APPROVAL))) {
						image = "/ibm/console/com.ibm.ws.console.taskmanagement/images/approval.gif";
					} else if (taskType.equalsIgnoreCase(Byte.toString(TaskConstants.PLANNEDTASK_TYPE_MANUAL))) {
						image = "/ibm/console/com.ibm.ws.console.taskmanagement/images/manual.gif";
					}%>
				
					<IMG align="top" name="taskTypeIcon" border="0" SRC="<%=image%>">
					<bean:write name="listcheckbox" property="<%=columnField%>" />
					</a><br>

					<%  String shortMsg = escape(msg);
                        String longMsg = escape(msg);

    					if (msg.length() > 100)
							shortMsg = msg.substring(0, 100) + "&nbsp;<a href='#' id='fullText_"+refId+"' TITLE='"+longMsg+"' onfocus='showFullText(\""+refId+"\")' onmouseover='showFullText(\""+refId+"\")' onblur='hideFullText(\""+refId+"\")' onmouseout='hideFullText(\""+refId+"\")' >...</a>";
					%>
					<%=shortMsg%>
                    <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" WIDTH="250" HEIGHT="1" ALT="" title=""/>
						
				<%} else if (columnField.equalsIgnoreCase("taskAction")) { %>
				
					<bean:define id="actionList" name="listcheckbox" property="actionList" type="java.util.List"/>
				
				<%	
					Iterator i_actionList = actionList.iterator();					
					if (taskState.equals("new") || taskState.equals("renewed") ||
					    taskState.equals("suppressed") || taskState.equals("denied") ||
					    taskState.equals("previewed") || taskState.equals("inprogresspreview") )
					  {%>
						<select name="taskAction_<%=refId%>">
					<%} else {%>
						<select name="taskAction_<%=refId%>" DISABLED>
					<%}%>
					
					<% while (i_actionList.hasNext()) {
						String curraction = (String) i_actionList.next();
						String key = "task.action." + curraction;%>
						<option value="<%=curraction%>">
							<bean:message key="<%=key%>" />
						</option>

					<%} // end while %>
					</select>
		
				<%} else if (cellItem.getTranslate()) { %>

                            <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                            <bean:message key="<%=prop %>"/>
				<%} else {
                      if (htmlFilter.equalsIgnoreCase("false")) {  %>
                        <bean:write filter="false" name="listcheckbox" property="<%=columnField%>"/>
                      <% } else {  %>
                        <bean:write name="listcheckbox" property="<%=columnField%>"/>
                 <%      }
                  } %>


                            <% if (cellItem.getLink().length() > 0) { %>
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
