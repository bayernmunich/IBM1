<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.websphere.models.config.workclass.WorkClassType"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.console.workclass.form.MatchRuleCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.MatchRuleDetailForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.RuleBuilderConditionForm" %>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassDetailForm"%>
<%@ page import="com.ibm.ws.console.workclass.util.Constants"%>
<%@ page import="com.ibm.ws.console.workclass.util.WorkClassConfigUtils"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassXDUtil"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.MiddlewareAppUtil" %>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>

<%
        int chkcounter = 0;
		  int rowindex = 0;
		  boolean debug =  false;
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

<tiles:useAttribute name="formAction" classname="java.lang.String" scope="request"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />
<tiles:useAttribute name="statusType" classname="java.lang.String"/>

<script language="JavaScript">

function popUpLimitedWindow(winUrl) {
    var features = "height=500,width=600,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
    var parentWin = window.name;
    var newWin = open(winUrl, 'SupportingEvidence', features, parentWin);
}

</script>

<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
String contextType=(String)request.getAttribute("contextType");
contextType = "ServicePolicy";

String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

java.util.ArrayList collectionList_ext =  new java.util.ArrayList();
for(int i=0;i<collectionList.size(); i++) {
    collectionList_ext.add(collectionList.get(i));

}

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.collectionItem";
    IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

    IExtension[] extensions = registry.getExtensions(extensionId, ic);

String extensionId_preferences = "com.ibm.websphere.wsc.preferences";
IConfigurationElementSelector ic_preferences = new ConfigurationElementSelector(contextType, extensionId_preferences);

IExtension[] extensions_preferences = registry.getExtensions(extensionId_preferences, ic);

    if((extensions!=null && extensions.length>0)){
//    if(contextId!=null && contextId!="nocontext"){
//        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
//    }
        props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);
    }

    if(extensions!=null && extensions.length>0){

    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props);
}

pageContext.setAttribute("collectionList_ext",collectionList_ext);

%>
<ibmcommon:detectLocale/>


<%
int wcscope = -1;
int wcview = -1;
String scopeName = "";
String labelext = "";

MatchRuleCollectionForm collectionForm = null;
String wcName = (String)request.getAttribute(Constants.KEY_WORKCLASS_NAME);
String encodedWCName = URLEncoder.encode(wcName, "UTF-8");
if (debug) System.out.println("matchRuleLayout.jsp:  name attribute: " +wcName);
WorkClassCollectionForm wccf = (WorkClassCollectionForm)request.getSession().getAttribute(Constants.KEY_WORKCLASS_COLLECTION_FORM);
if (debug) System.out.println("matchRuleLayout.jsp:  WorkClassCollectionForm attribute: " +wccf);

RuleBuilderConditionForm conditionForm = (RuleBuilderConditionForm)request.getSession().getAttribute(Constants.KEY_RULEBUILDER_CONDITION_DETAIL_FORM);
if (conditionForm == null) { 
	conditionForm = new RuleBuilderConditionForm("rulebuilder.clientipv4");
	request.getSession().setAttribute(Constants.KEY_RULEBUILDER_CONDITION_DETAIL_FORM, conditionForm); 
}

WorkClassDetailForm wcdf = null;

if (wccf != null) {
	// Retrieve the Scope and View for this collection.   This determines the layout of this page.
	wcview = wccf.getWCView();  // View is either Service or Routing Policy
	wcscope = wccf.getWCScope();  // Scope is either App or ODR
	if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
		labelext = ".routing";
	} else {
		labelext = "";
	}

	wcdf = WorkClassConfigUtils.getWorkClassDetailForm(wcName, wccf);
	if (wcdf != null) {		
		collectionForm = WorkClassConfigUtils.getMatchRuleCollectionForm(wcName, wccf);		
		if (debug) System.out.println("matchRuleLayout.jsp: collectionForm: " +collectionForm);         
		//collectionForm = wcdf.getMatchRuleCollectionForm();
		request.getSession().setAttribute("MatchRuleCollectionForm", collectionForm);  // Used for iterate loop later.
	} else {
			System.out.println("matchRuleLayout.jsp: Couldn't get WorkClassDetailForm for attribute: " +wcName +"WorkClassDetailForm");
	}
} else {
		System.out.println("matchRuleLayout.jsp: Couldn't get WorkClassCollectionForm for attribute WorkClassCollectionForm");
}

WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
ArrayList tcNames = new ArrayList();
ArrayList editionNames = new ArrayList();
ArrayList clusterNames = new ArrayList();
ArrayList routeTypes = new ArrayList();
String[] actionList = {"permit", "permit sticky", "redirect", "reject","permitMaint","permitAffMaint"};

String noactionLabel = "";
String permitLabel = "";
String permitStickyLabel= "";
String rejectLabel = "";
String redirectLabel = "";
String labelkey = "";
String scriptedResize = "";
String permitMaintLabel = "";
String permitMaintAff = "";

if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
	// Move this list to a Util.
	// Ordering of this list matters.   We are using mapping arrays between the display text and the action type.
	// 0 - permit
	// 1 - permit sticky
	// 2 - redirect
	// 3 - reject
	//routTypes = wcdf.getActions(wksp, wcview);
	MessageResources messages = MessageResources.getMessageResources("com.ibm.ws.console.core.resources.ConsoleAppResources");
	//noactionLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.action");
	//routeTypes.add(noactionLabel);
	permitLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.permit");
	routeTypes.add(permitLabel);
	permitStickyLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.permitsticky");
	routeTypes.add(permitStickyLabel);
	redirectLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.redirect");
	routeTypes.add(redirectLabel);
	rejectLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.reject");
	routeTypes.add(rejectLabel);
	permitMaintLabel = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.maintenance");
	routeTypes.add(permitMaintLabel);
	permitMaintAff = messages.getMessage(request.getLocale(),"workclass.matchrule.routing.label.affinity");
	routeTypes.add(permitMaintAff);

	//String appName = (String)session.getAttribute("appName");
	String appName = wccf.getApplicationName();
	//System.out.println("requestLayout.jsp:  appName = " +appName);
	if ((appName != null) && (!appName.equals(""))) {
		String normalizedAppName = WorkClassXDUtil.normalizeAppName(appName);
		if (wcscope == WorkClassConstants.WCSCOPE_MWA) {
			editionNames = (ArrayList) MiddlewareAppUtil.listApplicationEditions(appName, wksp);
		} else if (wcscope == WorkClassConstants.WCSCOPE_CU) {
		   editionNames.add(appName);
		} else {
			editionNames = wcdf.getEditions(wksp, normalizedAppName);
		}
	}
		clusterNames = wcdf.getGSClusters(wksp);
} else {
	tcNames = wcdf.getTCs(wksp, wcscope);
}

//String selectedTC = detailForm.getSelectedTC();
pageContext.setAttribute(iterationName, collectionForm);
pageContext.setAttribute("MatchRuleCollectionForm", collectionForm);
pageContext.setAttribute("editionNamesBean", editionNames);
pageContext.setAttribute("gscNamesBean", clusterNames);
pageContext.setAttribute("routeTypesBean", routeTypes);
pageContext.setAttribute("tcNamesBean", tcNames);

String tableSummary = "workclass" + labelext + ".rules.title";
String legendTxt = "workclass.matchrule.column.rule" + labelext;
%>

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>

<%--
    NOTES:
            The sorting icons are specified in defaultIconList.  The icons are assumed to be located in the images folder.
            Checkboxes are NOT displayed for all objects whose refIds start with "builtin_"
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<HEAD>
<title><bean:message key="workclass.matchrule.name"/></title>

<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/collectionform.js"></script>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<script language="JavaScript">
var actionList = ["permit", "permit", "redirect", "reject", "permitMaint","permitAffMaint"];
var showActionList;
var inited = false;

function initVars(formElem, index){
	if (inited){ return inited; }

	showActionList = formElem.options;

	inited=true;
	return inited;
}
function mapToAction(docId) {
	//alert("matchRuleLayout.docId:" + docId);
	if (docId.indexOf("Permit") != -1) {
		return actionList[0];
	}
	for (var i=0; i<showActionList.length;i++) {
		if (docId == showActionList[i].value) {
			return actionList[i];
		}
	}
	return "";	
}
function showSection(docId, refId) {
	var sectionId = mapToAction(docId) + refId;
	
	for (var i=0;i<actionList.length;i++) {
		var shownElement = actionList[i] +refId;
		if (document.getElementById(shownElement) != null) {
			document.getElementById(shownElement).style.display = "none";
		}
	 }
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
        } else {
            document.getElementById(sectionId).style.display = "none";
        }
    }
}
function applyButtonClicked(refId) {
	document.getElementById("rowIndex").value = refId;
}


function showSectionParent(objectNum) {

    objectId = "handEditDiv"+objectNum;

    objectIdStatic = "staticEditDiv"+objectNum;

    //alert(window.name);

    if (document.getElementById(objectId) != null) {

        if (document.getElementById(objectId).style.display == "none") {
            document.getElementById(objectId).style.display = "block";
            document.getElementById(objectIdStatic).style.display = "none";
        } else {
            document.getElementById(objectId).style.display = "none";
            document.getElementById(objectIdStatic).style.display = "block";
        }
    } 

    getISize();
    //parent.adjustISize(window.name);

}
</script>

</HEAD>

<BODY CLASS="content" class="table-row" role="main">

        <%@ include file="/secure/layouts/filterSetup.jspf" %>

 <html:form action="collectionButton.do" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">
 		<fieldset style="border:0px; padding:0pt; margin: 0pt;">
			<legend class="hidden"><bean:message key="select.text"/> <bean:message key="<%=legendTxt%>"/></legend>
                <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" CLASS="framing-table" summary="<bean:message key='<%=tableSummary%>'/>">
						<!--
						<%@ include file="/secure/layouts/tableControlsLayout.jspf" %>
						-->

					<tr>
						<th class="function-button-section" nowrap colspan="4">
							<!-- <input disabled type="submit" name="workclass.matchrule.button.add" value="<bean:message key="workclass.matchrule.button.add" />" class="buttons" id="functions"/>-->
<%
							if (    !SecurityContext.isSecurityEnabled()   || 
								(request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))
								) {
%>
								<input type="submit" name="workclass.matchrule.button.add" value="<bean:message key="workclass.matchrule.button.add" />" class="buttons_functions"/>
								<input type="submit" name="workclass.matchrule.button.delete" value="<bean:message key="workclass.matchrule.button.delete"/>" class="buttons_functions"/>							
								<input type="submit" name="workclass.matchrule.button.up" value="<bean:message key="workclass.matchrule.button.up"/>" class="buttons_functions"/>
								<input type="submit" name="workclass.matchrule.button.down" value="<bean:message key="workclass.matchrule.button.down"/>" class="buttons_functions"/>
<%							} %>
							<input type="hidden" name="buttoncontextType" value="ServicePolicy"/>
							<input type="hidden" name="buttoncontextId" value="none"/>
							<input type="hidden" name="buttonperspective" value="config"/> 
							<input type="hidden" name="formAction" value="MatchRuleCollectionAction"/> 
							<input type="hidden" name="wcName" value="<%=encodedWCName%>"/>
							<html:hidden property="rowIndex" styleId="rowIndex" value="" />
						</th>
					</tr>

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
                        columnField = (String)cellItem.getColumnField();
                        String tmpName = cellItem.getTooltip();
								// hack to change the rule column name
								if (tmpName.endsWith("column.rule")) {
									tmpName = tmpName + labelext;
								}
                        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
                    %>
						<TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  ID="<%=columnField%>">
                            <%=columnName%>
                        </TH>

                        <% chkcounter = chkcounter + 1; %>

                        </logic:iterate>
                    </TR>

			<!--
            <%@ include file="/secure/layouts/filterControlsLayout.jspf" %>
			-->

            <%
				   int prioritycounter = 1;
				   rowindex = 0;
				   String editClickString = "";
			%>

            <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="viewContents">

            <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>



                    <TR CLASS="table-row">
								<input type="hidden" name="formAction" value="MatchRuleCollectionAction"/> 
								<input type="hidden" name="wcName" value="<%=encodedWCName%>"/>
								<html:hidden name="listcheckbox" property="refId"/>

                    <%
                        if (showCheckBoxes.equals("true"))
                        {
							String multiboxId = refId + "_" + rowindex;
                  %>
                        <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            <LABEL class="collectionLabel" for="<%=multiboxId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
                            <% boolean isDisabled = true; 
                              
                              if(!SecurityContext.isSecurityEnabled() ){
                              		isDisabled = false;
                              }else {
                              		isDisabled = (  !request.isUserInRole("administrator") && !request.isUserInRole("configurator") && !request.isUserInRole("deployer") );
                              }
                            
                            %>
                            
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this.form)" onkeypress="checkChecks(this.form)" styleId="<%=multiboxId%>" disabled="<%=isDisabled%>" />
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
                        %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
                    <%
                        columnField = (String)cellItem.getColumnField();
                        String colwidth = "1%";
						if (columnField.equalsIgnoreCase("rule")) {
                           colwidth = "50%";
						}                        
                    %>
                        <TD VALIGN="top" name="listcheckbox" class="collection-table-text" width="<%=colwidth%>" headers="<%=columnField%>">
                       <%
                        if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0) {
                        %>
                            <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop"></IMG>&nbsp;
                        <%
                        } else if (columnField.equalsIgnoreCase("priority")) { 									// Need to customize this column to handle a text field and a pulldown menu.
									%>
									<%=prioritycounter%>
							<%	} else if (columnField.equalsIgnoreCase("rule")) { 
									%>
					 				<html:errors property="<%=refId%>"/>
						           <bean:define id="matchExpression" name="listcheckbox" property="matchExpression" type="java.lang.String"/>
		            <% 
									String  handShow = "none";
					                String  quickEdit = "block";
									if (matchExpression.equals("")) {
						               handShow = "block";
					                   quickEdit = "none";
									}
					%>                                    
						            <div id="handEditDiv<%=rowindex%>" style="display:<%=handShow%>;z-index:101;background-color:white" >
										<fieldset>
						                	<legend title="<bean:message key="workclass.matchrule.quickedit.description"/>">
								                <bean:message key="workclass.matchrule.quickedit"/>						                							                	
							                </legend>

											<%
												String matchExpressionId = "matchExpression" + rowindex;
											%>

											<TABLE CELLPADDING="5" CELLSPACING="0" role="presentation">
												<tr>
													<td class="table-text" VALIGN="top">
														<% //String href = "/ibm/console/com.ibm.ws.console.workclass.forwardCmd.do?forwardName=workclass.rulebuilder.condition.detail.panel"; %>
														<% String href = "/ibm/console/com.ibm.ws.console.workclass.forwardCmd.do?forwardName=workclass.rulebuilder.condition.detail.panel&isNewSession=true&wcName="+wcName
															+ "&closeURL=javascript:self.close()&csrfid=" + session.getAttribute("com.ibm.ws.console.CSRFToken");
														   String imgId = "allSPsImg" + rowindex;
														%>
                  										[ <a href="#" onclick="popUpLimitedWindow('<%=href%>')" onkeypress="popUpLimitedWindow('<%=href%>')">
										                  <img id="<%=imgId %>" SRC="<%=request.getContextPath()%>/com.ibm.ws.console.workclass/images/popup_icon.gif" alt="Open in new window" border="0" align="texttop" tabindex="1">
														  <bean:message key="workclass.matchrule.button.rulebuilder"/></a> ]
									    	        </td>
									    	    </tr>											
												<TR>
													<TD class="table-text-white" VALIGN="top">
														<LABEL class="matchExpressionLabel" for="<%=matchExpressionId%>" title="<bean:message key="workclass.matchrule.label.rule.description"/>"/>
															<bean:message key="workclass.matchrule.label.rule"/>
														</LABEL>
													</TD>
												</TR>
												<TR>
													<TD class="table-text-white"  VALIGN="top">
														<html:textarea property="matchExpression" name="listcheckbox" cols="50" rows="2" styleClass="textEntry" styleId="<%=matchExpressionId%>">
														</html:textarea>
													</TD>
												</TR>
												<TR>
													<TD class="table-text-white" VALIGN="top" COLSPAN=2>                                    
													<% labelkey = "workclass.matchrule" +labelext +".label.class"; %>
													<% String descriptionkey = "workclass.matchrule" +labelext +".label.class.description"; %>
													<% String tcListId = "tcList" + rowindex; %>
                                    					<LABEL class="matchActionLabel" for="<%=tcListId%>" title="<bean:message key="<%=descriptionkey%>"/>">
                                    						<bean:message key="<%=labelkey%>"/>
                                    					</LABEL>
									<% 
									String selectionChanged = "initVars(this);" +"showSection(" + "this.value" +",'" + refId + "')";
									String selectedItem = "";
									String selectProperty = "";
									String selectPropertyId = "";
									String selectList = "";
									String displayField = "display:none";
									String selectedType = "";
									if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
										selectProperty = "selectedType";
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getSelectedType();
										selectedType = selectedItem;
										if ( (selectedType != null) && (!selectedType.equals("")) ) {
											routeTypes.remove(noactionLabel);
										}
										selectList = "routeTypesBean";
									} else {
										// Never show the other fields.
										selectionChanged = "";
										selectProperty = "selectedTC";
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getSelectedTC();
										selectedType = selectedItem;
										selectList = "tcNamesBean";
									}
									
									%>
									<html:select size="1" value="<%=selectedItem%>" name="listcheckbox" property="<%=selectProperty%>" styleId="<%=tcListId%>" onchange="<%=selectionChanged%>">
									<html:options name="<%=selectList%>" />
									</html:select>
									<br>
									<%
										// Start of routing block - not needed for service policies
										if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
										// permit routing with affinity to generic server cluster or app edition
										// both permit and permit sticky actions will use this selection list.
										String docId = actionList[0]  +refId;
										if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
											selectProperty = "selectedGSCluster";
											selectedItem = ((MatchRuleDetailForm) listcheckbox).getSelectedGSCluster();
											selectList = "gscNamesBean";
		
											if ( (selectedType == null) || (selectedType.equals("")) ) {
												// The default selected type will be permit so display this field too.
												displayField = "display:block";
											} else if ( selectedType.equalsIgnoreCase(permitLabel)
													|| selectedType.equalsIgnoreCase(permitStickyLabel) ) {
												displayField = "display:block";
											} else {
												displayField = "display:none";
											}
											labelkey = "workclass.matchrule.routing.label.gsc";
										} else {
											selectProperty = "selectedEdition";
											selectedItem = ((MatchRuleDetailForm) listcheckbox).getSelectedEdition();
											selectList = "editionNamesBean";
											if ( (selectedType == null) || (selectedType.equals("")) ) {
												// The default selected type will be permit so display this field too.
												displayField = "display:block";
											} else if ( selectedType.equalsIgnoreCase(permitLabel)
													|| selectedType.equalsIgnoreCase(permitStickyLabel) ) {
												displayField = "display:block";
											} else {
												displayField = "display:none";
											}
											labelkey = "workclass.matchrule.routing.label.edition";
										}
										selectPropertyId = selectProperty + rowindex;
									%>
									<div id="<%=docId%>" style="<%=displayField%>">
										<label for="<%=selectPropertyId%>">
											<bean:message key="<%=labelkey%>"/>
										</label>
										<html:select size="1" value="<%=selectedItem%>" name="listcheckbox" property="<%=selectProperty%>" styleId="<%=selectPropertyId%>" onchange="" >
											<html:options name="<%=selectList%>" />
										</html:select>
									</div>
									<% 
										// redirect to URL
										docId = actionList[2] +refId;
										selectProperty = "redirectURL";
										selectPropertyId = selectProperty + rowindex;
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getRedirectURL();
										if ( (selectedType != null) && (selectedType.equalsIgnoreCase(redirectLabel)) ) {
											displayField = "display:block";
										} else {
											displayField = "display:none";
										}
										labelkey = "workclass.matchrule.routing.label.uri";
									%>
									<div id="<%=docId%>" style="<%=displayField%>">
										<label for="<%=selectPropertyId%>">
											<bean:message key="<%=labelkey%>"/>
										</label>
										<html:text property="<%=selectProperty%>" styleId="<%=selectPropertyId%>" name="listcheckbox" size="40" styleClass="textEntry" value="<%=selectedItem%>" onchange="" >
										</html:text>
									</div>
									<% 
										// reject with return code
										docId = actionList[3] +refId;
										selectProperty = "rejectCode";
										selectPropertyId = selectProperty + rowindex;
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getRejectCode();
										if ( (selectedType != null) && (selectedType.equalsIgnoreCase(rejectLabel)) ) {
											displayField = "display:block";
										} else {
											displayField = "display:none";
										}
										labelkey = "workclass.matchrule.routing.label.returncode";
									%>
									<div id="<%=docId%>" style="<%=displayField%>">
										<label for="<%=selectPropertyId%>">
											<bean:message key="<%=labelkey%>"/>
										</label>
										<html:text property="<%=selectProperty%>" name="listcheckbox" size="10" styleId="<%=selectPropertyId%>" styleClass="textEntry" value="<%=selectedItem%>" onchange="" >
										</html:text>
									</div>
									
									<% 
										// permit to servers in maint. mode
										docId = actionList[4] +refId;
										selectProperty = "serverMode";
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getServerMode();
										if ( (selectedType != null) && (selectedType.equalsIgnoreCase(permitMaintLabel)) ) {
											displayField = "display:block";
										} else {
											displayField = "display:none";
										}
										labelkey = "workclass.matchrule.routing.label.maintenance";
									%>
									<div id="<%=docId%>" style="<%=displayField%>">
										<html:hidden property="<%=selectProperty%>" name="listcheckbox" styleClass="textEntry" value="permitServerMM" onchange="" >
										</html:hidden>
									</div>	
									
									<% 
										// permit to servers in aff. maint. mode
										docId = actionList[5] +refId;
										selectProperty = "serverMode";
										selectedItem = ((MatchRuleDetailForm) listcheckbox).getServerMode();
										if ( (selectedType != null) && (selectedType.equalsIgnoreCase(permitMaintAff)) ) {
											displayField = "display:block";
										} else {
											displayField = "display:none";
										}
										labelkey = "workclass.matchrule.routing.label.affinity";
									%>
									<div id="<%=docId%>" style="<%=displayField%>">
										<html:hidden property="<%=selectProperty%>" name="listcheckbox" styleClass="textEntry" value="permitServerAMM" onchange="" >
										</html:hidden>
									</div>	
									
									<% 
									}  // End of routing block
										String rowString = new Integer(rowindex).toString();
									   String patternClick = "applyButtonClicked('" +rowString +"')";
                                       editClickString = patternClick;
									%>
		                        </td>
							</tr>  
                        	<tr>
                        		<td class="table-text" valign="top" colspan=2>                                    
                                    <span style="margin-left:1em">                                    
										<html:submit styleClass="buttons_other" property="workclass.matchrule.button.apply">
											<bean:message key="workclass.matchrule.button.apply" />
										</html:submit>
                                    <INPUT TYPE="button" NAME="Cancel" VALUE="<bean:message key="button.cancel"  />" class="buttons_other" ONCLICK="showSectionParent('<%=rowindex%>')"/>
                                    </SPAN>
                                    
		                        </td>
							</tr>           
                        </table>                                                                                                 
                  </fieldset>
            </div>
            
            <bean:define id="thenExpression" name="listcheckbox" property="<%=selectProperty%>" type="java.lang.String"/>            
            <div id="staticEditDiv<%=rowindex%>" style="display:<%=quickEdit%>">
            
            <% if (matchExpression.equals("")) {  %>
	            <script>
        	        <%=editClickString%>;
    	        </script>            
	            <i><span style="color:gray"><bean:message key="workclass.matchrule.emptyrule" /></span></i><br/> 
<%
			if (!SecurityContext.isSecurityEnabled() || 
				(request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) {
%>
    		       [ <a id="quickEditLink<%=rowindex%>" href="javascript:<%=editClickString%>;showSectionParent('<%=rowindex%>')">
						<bean:message key="workclass.matchrule.quickedit" /></a> ]
<%			} %>
           		<br/>            			   
			<% } else { 
				String routingAction = "";
				String matchActionItem = "";
			%>            
	            <bean:message key="workclass.matchrule.label.rule" />
	            <span STYLE="color:gray"><%=matchExpression%></span><br/>
	            <% if (wcview == WorkClassConstants.WCVIEW_SERVICE) {%>
   	            <bean:message key="workclass.matchrule.label.class" />
   	            <% } else { %>
   	            <bean:message key="workclass.matchrule.routing.label.class" />
				<%  routingAction = ((MatchRuleDetailForm) listcheckbox).getSelectedType();
				    matchActionItem = ((MatchRuleDetailForm) listcheckbox).getMatchAction();
				    int i = matchActionItem.indexOf(":");
				    matchActionItem = matchActionItem.substring(i+1);
				    thenExpression = routingAction+" "+matchActionItem;
				   } %>
    	        <span style="color:gray" id="te<%=rowindex%>"><%=thenExpression%></span><br/> 
                <% if (!SecurityContext.isSecurityEnabled() || (request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) { %>
                    [ <a id="quickEditLink<%=rowindex%>" href="javascript:<%=editClickString%>;showSectionParent('<%=rowindex%>')">
                        <bean:message key="workclass.matchrule.quickedit" /></a> ]
                <% } %>
           		<br/>                               
			<% }%>            
            </div>						
							<%	} %>
                        </td>
                        </logic:iterate>
                    </tr>
                    <% 
						     prioritycounter = prioritycounter + 1;
							  rowindex = rowindex + 1;
						  %>
                    </logic:iterate>

               <input type="hidden" name="collectionFormAction" value="<%=formAction%>"/>


                </TABLE>
            </fieldset>           
</html:form>

<script>
function getISize() {
    parent.adjustISize(window.name);
}

window.onload=function(){
    getISize();
}
</script>

</body>
</html:html>

<% } catch (Exception e) {e.printStackTrace();
} %>

    <%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        if (rowindex == 0) {
           out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
           out.println("<tr class='table-row'><td>"+nonefound+"</td></tr></table>");
        }
    %>

