<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2012 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,java.net.URLEncoder"%>

<%@ page import="java.util.Collection,java.util.Iterator,com.ibm.ws.sm.workspace.*"%>
<%@ page import="java.util.*"%>

<%@ page import="com.ibm.websphere.models.config.workclass.WorkClassType"%>
<%@ page import="com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.ws.console.workclass.form.MatchRuleCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassCollectionForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassDetailForm"%>
<%@ page import="com.ibm.ws.console.workclass.form.WorkClassModuleDetailForm"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassConstants"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.WorkClassXDUtil"%>
<%@ page import="com.ibm.ws.xd.config.workclass.util.MiddlewareAppUtil" %>
<%@ page import="com.ibm.ws.xd.config.workclass.util.OSGiApplicationUtil"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%
int chkcounter = 0;
%>

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String" />
<tiles:useAttribute name="selectionType" classname="java.lang.String"/>
<tiles:useAttribute name="columnList" classname="java.util.List"/>
<tiles:useAttribute name="createButtons" classname="java.lang.String"/>
<tiles:useAttribute name="selectName" classname="java.lang.String"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="includeButtonTile" classname="java.lang.String"/>
<% if ((includeButtonTile != null) && (includeButtonTile.equalsIgnoreCase("true"))) { %>
<tiles:useAttribute name="buttonCount" classname="java.lang.String"/>
<tiles:useAttribute name="definitionName" classname="java.lang.String"/>
<tiles:useAttribute name="includeForm" classname="java.lang.String"/>
<tiles:useAttribute name="actionList" classname="java.util.List"/>
<% } %>

<tiles:useAttribute name="requestType" classname="java.lang.String"/>

<script language="JavaScript">
function newHTTPClicked() {
    window.location="/ibm/console/WorkClassCollection.do?&NewClicked=true" + "&wcType=HTTP"	
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function newIIOPClicked() {
    window.location="/ibm/console/WorkClassCollection.do?&NewClicked=true" + "&wcType=IIOP"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function newSOAPClicked() {
    window.location="/ibm/console/WorkClassCollection.do?&NewClicked=true" + "&wcType=SOAP"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function newJMSClicked() {
    window.location="/ibm/console/WorkClassCollection.do?&NewClicked=true" + "&wcType=JMS"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

var availHosts;
var actionList = ["permit", "permit sticky", "redirect", "reject","permitMaint","permitAffMaint"];
var showActionList;
var inited = false;

function initVars(formElem, firstMembershipFormElemIndex){
	if (inited){ return inited; }
	
	var theform = formElem.form;		
	availHosts = theform.hostList;
	showActionList = formElem.options;
	inited=true;
	return inited;
}
function hostChange(formName, requestType) {
	//When the transaction class changes we need to save it in the form
	var selectedHost = availHosts.value;
	window.location = encodeURI("/ibm/console/WorkClassDetail.do?virtualHost=" + encodeURI(selectedHost) + "&wcName=" + encodeURI(formName) + "&requestType=" + encodeURI(requestType) + "&hostChanged=true"
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}
function mapToAction(docId) {
	//alert("requestLayout.docId:" + docId);
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
function selectActionClicked(refId) {
	var rowRefId = "refId" +refId;
	if (document.getElementById(rowRefId) != null) {
		document.getElementById(rowRefId).value = refId;
	}
}

//  isize adjust goes here

//  Function used to adjust the height and width of the IFRAMES
function adjustISize(sectionId,isrc) {

	if (isrc) {
		if (document.getElementById(sectionId)) {
        	if (document.getElementById(sectionId).src.indexOf("blank.html")>-1) {
            	document.getElementById(sectionId).src = isrc;
            }
        }
    }

    try {                                                                              
        // Mozilla branch
        if (document.getElementById(sectionId).contentDocument) {
        
            // Add some padding, more for the classIFrame
            if (sectionId.indexOf("classIFrame")>-1) {
                add = 25;
            } else {
                add = 10;
            }
    
            // Set the height
            sz = document.getElementById(sectionId).contentDocument.body.offsetHeight + add;       
            document.getElementById(sectionId).style.height = sz+"px";
        
            // Set the width
            szw = document.getElementById(sectionId).contentDocument.body.offsetWidth + add;
            testszw = szws - szw;
            document.getElementById(sectionId).style.width = szw+"px";
        
            // IE branch
		} else {
    
            // Set the height
            sz = document.getElementById(sectionId).Document.body.scrollHeight;
            if (sz > 0) {
                document.getElementById(sectionId).style.height = sz;
            }
    
            // Set the width
            szw = document.getElementById(sectionId).Document.body.scrollWidth;
            if (sz > 0) {
                document.getElementById(sectionId).style.width = szw;
            }
    
        }
        
    } catch(err) {
        return;
    }
}

</script>

	<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
	<%-- checks if includeButtonTile is true or false. If true then it inserts buttonLayout.jsp with the values given in the tiles configuration file --%>

<%
String csrfParm = "";
String csrfToken = (String) session.getAttribute("com.ibm.ws.console.CSRFToken");
if ((csrfToken != null) && (!csrfToken.equals("")))
	csrfParm = "&csrfid=" + csrfToken;

WorkClassCollectionForm wccf = (WorkClassCollectionForm)request.getSession().getAttribute("WorkClassCollectionForm");
int wcscope = -1;
int wcview = -1;
String scopeName = "";
String labelext = "";
String expandID = "";
boolean isDisabled = false;
boolean isJMSDisabled = false;
if (wccf != null) {
	// Retrieve the Scope and View for this collection.   This determines the layout of this page.
	wcview = wccf.getWCView();  // View is either Service or Routing Policy
	wcscope = wccf.getWCScope();  // Scope is either App or ODR
		
	if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
		expandID = wccf.getNodeName()+"_"+wccf.getODRName();
	} else {
		if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
			expandID = WorkClassXDUtil.normalizeAppName(wccf.getApplicationName());
		} else {
			expandID = wccf.getApplicationName();
		}
	}
	expandID = expandID+"_"+wcview;
	
	if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
		labelext = ".routing";
	} else {
		labelext = "";
	}	
}

//System.out.println("labelext = " +labelext);    // Debug - Remove
//System.out.println("wcview = " +wcview);    // Debug - Remove
//System.out.println("wcscope = " +wcscope);    // Debug - Remove

WorkSpace wksp = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
ArrayList editionNames = new ArrayList();
ArrayList clusterNames = new ArrayList();
ArrayList routeTypes = new ArrayList();
ArrayList tcNames = new ArrayList();
String[] actionList = {"permit", "permit sticky", "redirect", "reject","permitMaint","permitAffMaint"};

String noactionLabel = "";
String permitLabel = "";
String permitStickyLabel= "";
String rejectLabel = "";
String redirectLabel = "";
String labelkey = "";
String permitMaintLabel = "";
String permitMaintAff = "";
%>

<!--  	<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">  -->
	<table border="0" cellpadding="3" cellspacing="0" width="100%" role="presentation" class="framing-table" style="margin-left: 1em">
		<tr class="function-button-section">
			<td valign="top" width="100%" colspan="2">
<%
				if (!SecurityContext.isSecurityEnabled() || 
					(request.isUserInRole("administrator") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) {
					String onClickMethod = "new"+requestType+"Clicked()"; 
%>
					<html:button styleClass="buttons_other" property="notUsed" onclick="<%=onClickMethod%>">
						<bean:message key="workclass.button.new" /> 
					</html:button>				
				
					&nbsp;
					<input type="submit" name="workclass.button.delete" value="<bean:message key="workclass.button.delete"/>" class="buttons_functions"/>
<%
				}
%>
			    <input type="hidden" name="buttoncontextType" value="ServicePolicy"/>
				<input type="hidden" name="buttoncontextId" value="none"/>
				<input type="hidden" name="buttonperspective" value="config"/> 
				<input type="hidden" name="formAction" value="WorkClassCollectionAction"/>
			</td>
		</tr>
 
		<%-- iterates over ArrayList to display the values present in the List. An inner loop of columnList is used to display the values of each item in the column of the table. --%>
	    <logic:iterate id="collectionItem" name="<%=iterationName%>" property="contents">
        
        <tr class ="table-row"> 
		<bean:define id="type" name="collectionItem" property="type" type="com.ibm.websphere.models.config.workclass.WorkClassType" />
        <%  
			WorkClassType wcType = WorkClassType.get(WorkClassType.HTTPWORKCLASS);
			if (requestType.equals(WorkClassConstants.IIOP)) {
				wcType = WorkClassType.get(WorkClassType.IIOPWORKCLASS);
			} else if (requestType.equals(WorkClassConstants.SOAP)) {
				wcType = WorkClassType.get(WorkClassType.SOAPWORKCLASS);
			} else if (requestType.equals(WorkClassConstants.JMS)) {
				wcType = WorkClassType.get(WorkClassType.JMSWORKCLASS);
			}

			if (wcType.equals(type)) {
	    %>
            <% int collectionCount = 0; %>
            <logic:iterate id="column" name="columnList" type="com.ibm.ws.console.core.item.CollectionItem">
             <bean:define id="value" name="collectionItem" property="<%=column.getColumnField()%>" type="java.lang.String"/>
              <%  if (collectionCount++ < 1) { %>
              <td width="1%" valign="top"> 
              <!--<td class="table-text"  width="1%" valign="top">-->

			  <%
					if (value.indexOf("Default_") != -1) {
						isDisabled = true;
					} else {
					    isDisabled =false;
					}
			  %>
             <bean:define id="refId" name="collectionItem" property="refId" type="java.lang.String"/>
             <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/> <%=refId%>'>
             	<html:multibox property="selectedObjectIds" name="<%=formName%>" value="<%=refId%>" onclick="" onkeypress="" styleId="<%=refId%>" disabled="<%=isDisabled%>" styleId="<%=refId%>" />
             </LABEL>
             </td>
              <% } %>
              <td>
              <!--<td class="table-text">-->
				<%-- forms link for the column if it is required --%>
				<bean:define id="name" name="collectionItem" property="name" type="java.lang.String" />
				<%
					String expandState = (String)session.getAttribute("com_ibm_ws_"+expandID+name+chkcounter);
					String expandGraphic = request.getContextPath()+"/com.ibm.ws.console.workclass/images/plus_sign.gif";
					if (expandState == null)
						expandState = "display:none";
					else if (expandState.equals("display:block"))
						expandGraphic = request.getContextPath()+"/com.ibm.ws.console.workclass/images/minus_sign.gif";

					if (wcscope != WorkClassConstants.WCSCOPE_ODR) {%>
						<a href="javascript:showHideSection('<%=expandID%><%=name%><%=chkcounter%>');adjustISize('<%=expandID%><%=name%><%=chkcounter%>memberIFrame', 
								'/ibm/console/WorkClassDetail.do?gotoMembershipList=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>');adjustISize('<%=expandID%><%=name%><%=chkcounter%>classIFrame', 
								'/ibm/console/WorkClassDetail.do?gotoClassificationRules=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>');adjustISize('<%=expandID%><%=name%><%=chkcounter%>matchIFrame', 
								'/ibm/console/WorkClassDetail.do?gotoWCMatchAction=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>')" class="tree">
					<% } else { %>
						<a href="javascript:showHideSection('<%=expandID%><%=name%><%=chkcounter%>');adjustISize('<%=expandID%><%=name%><%=chkcounter%>classIFrame', 
								'/ibm/console/WorkClassDetail.do?gotoClassificationRules=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>');adjustISize('<%=expandID%><%=name%><%=chkcounter%>matchIFrame', 
								'/ibm/console/WorkClassDetail.do?gotoWCMatchAction=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>')" class="tree">
					<% } %>
							
    			    <img id="<%=expandID%><%=name%><%=chkcounter%>Img" border="0" align="middle" src="<%=expandGraphic%>" />
			    	<%=name%>
				</a>
				
				<div id="<%=expandID%><%=name%><%=chkcounter%>" style="<%=expandState%>">
				<%
					
					WorkClassDetailForm wcdf = (WorkClassDetailForm)collectionItem;
					//request.getSession().setAttribute(name + "WorkClassDetailForm", wcdf);
					request.setAttribute("wcName", name);
					request.setAttribute("requestType", requestType);
				%>

				<%
					String refId = name;
					String rowRefId = "refId" +refId;
					String rowRefId_Value = "";
					if (!wcdf.getIsValid()) {
						rowRefId_Value = refId;
					}
				%>
					<html:hidden property="refId" name="collectionItem" value="<%=rowRefId_Value%>" styleId="<%=rowRefId%>"/>
				<% 
					String selectionChanged = "selectActionClicked('" + refId + "')";
					if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
						WorkClassModuleDetailForm wcmdf = wcdf.getWorkClassModuleDetailForm(0);  // Get WorkClassModule for odr
						if (wcmdf == null) {
							// shouldn't get here but just in case.
							wcmdf = new WorkClassModuleDetailForm();
							wcmdf.setModuleName(wccf.getODRName());
							// Set a default URI pattern??
							// wcmdf.setMatchExpression("/*");
							wcdf.addWorkClassModuleDetailForm(wcmdf);
						}
						// Add Virtual Host selection for ODR WorkClass panels
						String uriNames = wcmdf.getMatchExpressionToShow();
						pageContext.setAttribute("uriNames", uriNames);
						//String hostDropDownChanged = "initVars(this);hostChange('" + name + "', '" + requestType + "')";
						
						String uriNamesId = "uriNames_" + rowRefId_Value;
				%>
					
		        	<fieldset >
        		       	<legend title='<bean:message key="workclass.membership.matches" arg0="URI" />'>
        	        	 	<bean:message key="workclass.membership.matches" arg0="URI" />
		               	</legend>					
					
						<label for="<%=uriNamesId%>" title='<bean:message key="workclass.membership.label.description" arg0="URI" />'>
							<bean:message key="workclass.membership.label" arg0="URI" />
	                    </label>
						<br />
						<html:textarea rows="10" cols="40" value="<%=uriNames%>" name="collectionItem" property="matchURIs" styleId="<%=uriNamesId%>"
							 onchange="<%=selectionChanged%>" disabled="<%=isDisabled%>">
						</html:textarea>
						

					<% 
						if (isDisabled) {
							wccf.setDefaultWCPosition(chkcounter);
						}
					} else {
					%>
		        	<fieldset >
        		       	<legend title='<bean:message key="workclass.membership.matches" arg0="<%=requestType%>" />'>
        	        	 	<bean:message key="workclass.membership.matches" arg0="<%=requestType%>" />
		               	</legend>					
								
						<label title='<bean:message key="workclass.membership.label.description" arg0="<%=requestType%>" />'>
	    					<bean:message key="workclass.membership.label" arg0="<%=requestType%>" />
	                    </label>		
	                    	                    
        	            <% if (expandState.equals("display:block")) {    %>
						<iframe id="<%=expandID%><%=name%><%=chkcounter%>memberIFrame" name="<%=expandID%><%=name%><%=chkcounter%>memberIFrame" 
								src="/ibm/console/WorkClassDetail.do?gotoMembershipList=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>"
								frameborder="0" scrolling="auto" width="100%" height="100%" title="<bean:message key="workclass.membership.label" arg0="<%=requestType%>" />">
						<% } else { %>
						<iframe id="<%=expandID%><%=name%><%=chkcounter%>memberIFrame" name="<%=expandID%><%=name%><%=chkcounter%>memberIFrame" 
								title="<bean:message key="workclass.membership.label" arg0="<%=requestType%>" />" src="/ibm/console/blank.html" 
								frameborder="0" scrolling="auto" width="100%" height="100%" role="presentation">
						<% } %>	                    
	                    
						</iframe>	                    
					<% } %>

					<% if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
						// Add Virtual Host selection for ODR WorkClass panels
						ArrayList hostNames = wcdf.getVirtualHosts(wksp);
						String selectedHost = wcdf.getSelectedHost();
						pageContext.setAttribute("hostList", hostNames);
						//String hostDropDownChanged = "initVars(this);hostChange('" + name + "', '" + requestType + "')";
						labelkey = "workclass.odr.routing.host.label";
						String hostListId = "hostList" + rowRefId_Value;
					%>
					<br/><br/>
					<label for="<%=hostListId%>" title='<bean:message key="<%=labelkey%>" />'>
	    				<bean:message key="<%=labelkey%>"/>
                    </label><br />					
					<html:select size="1" value="<%=selectedHost%>" name="collectionItem" property="selectedHost" styleId="<%=hostListId%>"
							 onchange="<%=selectionChanged%>">
						<html:options name="hostList"/>
					</html:select>
					<% } %>
					</fieldset>
					<br/><br/>
					
					<% 
					if (!type.equals(WorkClassType.JMSWORKCLASS_LITERAL)) {
					labelkey = "workclass.matchrule" +labelext +".description"; %>
		        	<fieldset>
        		       	<legend title='<bean:message key="<%=labelkey%>" />'>
	    					<% labelkey = "workclass" +labelext +".rules.label"; %>
	    					<% String titlekey = "workclass" + labelext + ".rules.title"; %>
							<bean:message key="<%=labelkey%>"/>
		               	</legend>
        	            <% if (expandState.equals("display:block")) {%>
						<iframe id="<%=expandID%><%=name%><%=chkcounter%>classIFrame" name="<%=expandID%><%=name%><%=chkcounter%>classIFrame" src="/ibm/console/WorkClassDetail.do?gotoClassificationRules=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>"
								frameborder="0" scrolling="auto" width="100%" height="100%" title="<bean:message key="<%=titlekey%>"/>">
						<% } else { %>
						<iframe id="<%=expandID%><%=name%><%=chkcounter%>classIFrame" name="<%=expandID%><%=name%><%=chkcounter%>classIFrame" src="/ibm/console/blank.html" 
								frameborder="0" scrolling="auto" width="100%" height="100%" title="<bean:message key="<%=titlekey%>"/>" role="presentation">
						<% } %>

						</iframe>
                    </fieldset>
					<br /><br />
					
					<%
					}
					
					if (wcview != WorkClassConstants.WCVIEW_ROUTING) {
						labelkey = "workclass" +labelext +".default.action.label";
					%>		
		        	<fieldset>
        		       	<legend title='<bean:message key="<%=labelkey%>" />'>
							<bean:message key="<%=labelkey%>"/>
		               	</legend>					
								
						<% labelkey = "workclass" +labelext +".default.action.label.label"; %>
						<% String titlekey = "workclass" +labelext +".default.action.title"; %>
        	            
        	            <% if (expandState.equals("display:block")) {%>
							<iframe id="<%=expandID%><%=name%><%=chkcounter%>matchIFrame" name="<%=expandID%><%=name%><%=chkcounter%>matchIFrame" src="/ibm/console/WorkClassDetail.do?gotoWCMatchAction=true&wcName=<%=name%>&requestType=<%=requestType%><%=csrfParm%>"
								frameborder="0" scrolling="auto" width="100%" height="100%" title="<bean:message key="<%=titlekey%>"/>">							
						<% } else { %>
							<iframe id="<%=expandID%><%=name%><%=chkcounter%>matchIFrame" name="<%=expandID%><%=name%><%=chkcounter%>matchIFrame" src="/ibm/console/blank.html"
								frameborder="0" scrolling="auto" width="100%" height="100%" title="<bean:message key="<%=titlekey%>"/>" role="presentation">
						<% } %>
						</iframe>        	            
					</fieldset>
					<%
					} else {
						labelkey = "workclass" +labelext +".default.action.label";
					%>
			        	<fieldset >
    	    		       	<legend title='<bean:message key="<%=labelkey%>" />'>
								<bean:message key="<%=labelkey%>"/>
		    	           	</legend>						
		    	           	<% labelkey = "workclass" +labelext +".default.action.label.label"; %>
		    	           	<% String tcListId = "tcList" + rowRefId_Value; %>
							<label for="<%=tcListId%>" title='<bean:message key="<%=labelkey%>" />'>
			    				<bean:message key="<%=labelkey%>"/>
        		            </label>
        		            <br />
						<%
						editionNames = new ArrayList();
						clusterNames = new ArrayList();
						routeTypes = new ArrayList();
						tcNames = new ArrayList();

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
								editionNames = (ArrayList) OSGiApplicationUtil.listApplicationEditions(appName);
							} else {
								editionNames = wcdf.getEditions(wksp, normalizedAppName);
							}
						}
						clusterNames = wcdf.getGSClusters(wksp);
						tcNames = wcdf.getTCs(wksp, wcscope);

						pageContext.setAttribute("editionNamesBean", editionNames);
						pageContext.setAttribute("gscNamesBean", clusterNames);
						pageContext.setAttribute("routeTypesBean", routeTypes);
						pageContext.setAttribute("tcNamesBean", tcNames);

						selectionChanged = "initVars(this);" +"selectActionClicked('" + refId + "');" +"showSection(" + "this.value" +",'" + refId + "')";
						String selectedItem = "";
						String selectProperty = "";
						String selectList = "";
						String displayField = "display:none";
						String selectedType = "";
						String selectedItemEdition = "";
						String selctedPropertyEdition = "";
						
						if (wcview == WorkClassConstants.WCVIEW_ROUTING) {
							selectProperty = "selectedType";
							selectedItem = wcdf.getSelectedType();
							selectedType = selectedItem;
							if ( (selectedType != null) && (!selectedType.equals("")) ) {
								routeTypes.remove(noactionLabel);
							}
							selectList = "routeTypesBean";
						} else {
							selectProperty = "selectedTC";
							selectedItem = wcdf.getSelectedTC();
							selectList = "tcNamesBean";
							selectedType = selectedItem;
						}
                        // Disable widgets if none of these roles are used: administrator, configurator, or deployer
                        if (!SecurityContext.isSecurityEnabled()) {
                            isDisabled = false;
                        } else {
                            isDisabled = (!request.isUserInRole("administrator") && !request.isUserInRole("configurator") && !request.isUserInRole("deployer"));
                        }
						%>
							<html:select size="1" value="<%=selectedItem%>" name="collectionItem" property="<%=selectProperty%>" styleId="<%=tcListId%>" onchange="<%=selectionChanged%>" disabled="<%=isDisabled%>">
								<html:options name="<%=selectList%>" />
							</html:select>
							<br>
						<%
						// permit routing with affinity to generic server cluster or app edition
						// permit, permit sticky, permitMM and permit stickyMM actions will use this selection list.
						String docId = actionList[0] +refId;
						String selectPropertyId = "";
						selectionChanged = "selectActionClicked('" + refId + "')";
						if (wcscope == WorkClassConstants.WCSCOPE_ODR) {
							selectProperty = "selectedGSCluster";
							selectedItem = wcdf.getSelectedGSCluster();
							selectList = "gscNamesBean";
							if ( (selectedType == null) || (selectedType.equals("")) ) {
								// The default selected type will be permit so display this field too.
								displayField = "display:block";
							} else if ( selectedType.equalsIgnoreCase(permitLabel)
										|| selectedType.equalsIgnoreCase(permitStickyLabel)
										|| selectedType.equalsIgnoreCase(permitMaintLabel)
										|| selectedType.equalsIgnoreCase(permitMaintAff)) {
								displayField = "display:block";
							} else {
								displayField = "display:none";
							}
							labelkey = "workclass.matchrule" +labelext +".label.gsc";
						} else {
							selectProperty = "selectedEdition";
							selectedItem = wcdf.getSelectedEdition();
							selectList = "editionNamesBean";
							if ( (selectedType == null) || (selectedType.equals("")) ) {
								// The default selected type will be permit so display this field too.
								displayField = "display:block";
							} else if ( selectedType.equalsIgnoreCase(permitLabel)
										|| selectedType.equalsIgnoreCase(permitStickyLabel)
										|| selectedType.equalsIgnoreCase(permitMaintLabel)
										|| selectedType.equalsIgnoreCase(permitMaintAff)) {
								displayField = "display:block";
							} else {
								displayField = "display:none";
							}
							labelkey = "workclass.matchrule" +labelext +".label.edition";
						}
						selectPropertyId = selectProperty + rowRefId_Value;
						%>

							<div id="<%=docId%>" style="<%=displayField%>">
							<br />
							<label for="<%=selectPropertyId%>" title='<bean:message key="<%=labelkey%>" />'>
		    					<bean:message key="<%=labelkey%>"/>
        	    	        </label><br />
							<html:select size="1" value="<%=selectedItem%>" name="collectionItem" property="<%=selectProperty%>" styleId="<%=selectPropertyId%>" onchange="<%=selectionChanged%>" disabled="<%=isDisabled%>">
								<html:options name="<%=selectList%>" />
							</html:select>
							</div>

						<% 
						// redirect to URL
						docId =  actionList[2] +refId;
						selectProperty = "redirectURL";
						selectPropertyId = selectProperty + rowRefId_Value;
						selectedItem = wcdf.getRedirectURL();
						if ( (selectedType != null) && (selectedType.equalsIgnoreCase(redirectLabel)) ) {
							displayField = "display:block";
						} else {
							displayField = "display:none";
						}
						labelkey = "workclass.matchrule.routing.label.uri";
						%>
							<div id="<%=docId%>" style="<%=displayField%>">
							<br />
							<label for="<%=selectPropertyId%>" title='<bean:message key="<%=labelkey%>" />'>
		    					<bean:message key="<%=labelkey%>"/>
        	        	    </label>
        	        	    <br />
							<html:text name="collectionItem" property="<%=selectProperty%>" styleId="<%=selectPropertyId%>" size="40" value="<%=selectedItem%>" onchange="<%=selectionChanged%>">
							</html:text>
							</div>
						<% 
						// reject with return code
						docId =  actionList[3] +refId;
						selectProperty = "rejectCode";
						selectPropertyId = selectProperty + rowRefId_Value;
						selectedItem = wcdf.getRejectCode();
						if ( (selectedType != null) && (selectedType.equalsIgnoreCase(rejectLabel)) ) {
							displayField = "display:block";
						} else {
							displayField = "display:none";
						}
						labelkey = "workclass.matchrule.routing.label.returncode";
						%>
							<div id="<%=docId%>" style="<%=displayField%>">
							<br />
							<label for="<%=selectPropertyId%>" title='<bean:message key="<%=labelkey%>" />'>
		    					<bean:message key="<%=labelkey%>"/>
        	        	    </label><br />
							<html:text name="collectionItem" property="<%=selectProperty%>" styleId="<%=selectPropertyId%>" size="10" value="<%=selectedItem%>" onchange="<%=selectionChanged%>">
							</html:text>
							</div>
						</fieldset>
				<% } %>
				
				</div>
              </td>
            </logic:iterate>            
			<% } %>
        </tr>
	    <% chkcounter = chkcounter + 1; %>
    </logic:iterate>
 
<%-- creates buttons if this is given true in the configuration file --%>   
        <logic:equal name="createButtons" value="true">
        <tr>
            <td class="button-section" colspan="4"> 
                <html:submit property="action" styleClass="buttons" styleId="navigation">
                    <bean:message key="button.ok"/>
                </html:submit>
                <input type="submit" name="org.apache.struts.taglib.html.CANCEL" 
                 value="<bean:message key="button.cancel"/>" class="buttons" 
                 id="navigation">
            </td>
        </tr>
    </logic:equal>
</table>
<!-- </html:form>   -->

<%-- MessageResources of struts is used here. Action.MESSAGES_KEY will have MessageResources type stored in the session. --%>
<%-- This instance is used to get a text message for the specified key, for the given Locale --%>
<%-- displays none if no items are present in the List --%>

<%  
    ServletContext servletContext = (ServletContext)pageContext.getServletContext();
    MessageResources messages = 
    (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
    String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
    if (chkcounter == 0) { 
    out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'><tr><td class='table-text'>"+nonefound+"</td></tr></table>"); 
    }  
%>
