<%-- IBM Confidential OCO Source Material --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>
<%@ page language="java" import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.core.form.RuleDetailForm"%>
<%@ page language="java" import="com.ibm.ws.console.core.util.ExpressionUtil"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="detailFormType" ignore="true" classname="java.lang.String" />
<tiles:useAttribute name="label" classname="java.lang.String" />
<tiles:useAttribute name="desc" classname="java.lang.String" />

<!-- helpfile.txt key for rule quick help -->
<tiles:useAttribute name="quickHelpTopic" classname="java.lang.String" ignore="true"/>

<!-- Webui plugin id -->
<tiles:useAttribute name="quickPluginId" classname="java.lang.String" ignore="true" />

<!-- Action class to use for editing an individual rule -->
<tiles:useAttribute name="detailActionHandler" ignore="true" classname="java.lang.String" />

<!-- "true" if you do not want to use only one rule. -->
<tiles:useAttribute name="hideValidate" classname="java.lang.String" />

<!-- "true" if you do not want the rule action displaying. -->
<tiles:useAttribute name="hideRuleAction" classname="java.lang.String" />

<!-- If using collection layout this must be passed into this layout. -->
<tiles:useAttribute name="rowindex" classname="java.lang.String" />

<!-- If using collection layout this must be passed into this layout. -->
<tiles:useAttribute name="refId" classname="java.lang.String" />

<!-- Form attribute used to set and get the rule. -->
<tiles:useAttribute name="rule" classname="java.lang.String" />

<tiles:useAttribute name="ruleDetailForm" ignore="true" classname="java.lang.String" />

<!-- To use a different ruleBuilderLayout.jsp if this attribute is set -->
<tiles:useAttribute name="customRuleBuilderLayout" ignore="true" classname="java.lang.String" />

<tiles:useAttribute name="sipAction" classname="java.lang.String" ignore="true"/>

<!-- Context of action
  Known uses:
  (1) "service" policy
  (2) "routing" policy
  (3) "odr.service" policy
  (4) "odr.routing" policy

  Potential future uses:
  (5) "job" policy
  (6) "health" policy
  (7) "sip" policy
-->
<tiles:useAttribute name="ruleActionContext" classname="java.lang.String" />

<!-- Template to follow for action layout
   Valid templates:
   (1) service
   (2) routing

   Template allows us to not have unique message keys per reusable component.  Some
   labels are global and always apply to either service or routing.  If completely
   new set of labels are desired just add a new valid value for tempalte similar to
   the ruleActionContext.

   Labels that need to be unique will use the ruleActionContext instead of the template.
-->
<tiles:useAttribute name="template" classname="java.lang.String" />

<!-- Name of form attribute to get and set some needed object.
   Known uses:
   (1) Hold selected transaction class.
   (2) Hold selected action type: permit, reject, redirect, permitsticky
-->
<tiles:useAttribute name="actionItem0" classname="java.lang.String" />

<!-- Name of form attribute to get and set a List of some needed objects.
   Known uses:
   (1) Hold list of available transaction classes.
   (2) Hold list of available action types: permit, reject, redirect, permitsticky
-->
<tiles:useAttribute name="actionListItem0" classname="java.lang.String" />

<!-- Name of form attribute to get and set some needed object.
   Known uses:
   (1) Hold selected GSC
   (2) Hold selected application edition
-->
<tiles:useAttribute name="actionItem1" classname="java.lang.String" />

<!-- Name of form attribute to get and set a List of some needed objects.
   Known uses:
   (1) Hold available list of GSCs.
   (2) Hold available list of application editions.
-->
<tiles:useAttribute name="actionListItem1" classname="java.lang.String" />

<tiles:useAttribute name="customOperands" ignore="true" classname="java.lang.String" />

<!-- Specifies the add/remove button property name for the IN operator. 
   Known uses:
   (1) SIP rules custom expression.
-->
<tiles:useAttribute name="inButtonPropertyName" ignore="true" classname="java.lang.String" />

<% 
   if (inButtonPropertyName == null) { inButtonPropertyName = "installAction"; }
%>

<script language="JavaScript">
var actionList = ["permit", "permit", "redirect", "reject"];
var showActionList;
var inited = false;

function forceShowRuleBuilderDiv(){
	objectId = "ruleBuilder";
	if (document.getElementById(objectId) != null) {
		if (document.getElementById(objectId).style.display == "block") {
			document.getElementById(objectId).style.zIndex = 500;
		}
	}
}

function initVars(formElem, index){
	if (inited){ return inited; }

	showActionList = formElem.options;

	inited=true;
	return inited;
}
function mapToAction(docId) {
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
	//document.getElementById("rowIndex").value = refId;
}

function showHideSection(objectId, refId) {
	//alert("showHideSection, ruleEditLayout");
	//alert("object id:  "+ objectId);
    if (document.getElementById(objectId) != null) {
    //alert("object != null");
        if (document.getElementById(objectId).style.display == "none") {
        	//alert("display is none");
            document.getElementById(objectId).style.display = "block";
            positionSubexpressionBuilder(objectId, refId);
        } else {
        	//alert("display is block");
            document.getElementById(objectId).style.display = "block";
            document.getElementById(objectId).style.display = "none";
        }
    }
}

function positionSubexpressionBuilder(objectId, refId) {
	if (refId != "") {
		//alert("positionSubexpressionBuilder");
		var ruleAction = getElementPosition("ruleAction"+refId);
		var actionTop = ruleAction.top;
		var actionLeft = ruleAction.left;		
		var objectHeight = document.getElementById(objectId).offsetHeight;
		var newObjectTop = actionTop-objectHeight;
		if(newObjectTop >  0 && actionLeft > 0){	
			document.getElementById(objectId).style.left = actionLeft;
			document.getElementById(objectId).style.top = newObjectTop;
		}
		//alert("actionLeft: "+actionLeft);
		//alert("newObjectTop: "+ newObjectTop);
		
	}
}

function getElementPosition(id) {
	var offsetTrail = document.getElementById(id);
	var offsetLeft = 0;
	var offsetTop = 0;
	while (offsetTrail) {
		offsetLeft += offsetTrail.offsetLeft;
		offsetTop += offsetTrail.offsetTop;
		offsetTrail = offsetTrail.offsetParent;
	}
	
	if (navigator.userAgent.indexOf("Mac") != -1 &&
		typeof document.body.leftMargin != "undefined") {
		offsetLeft += document.body.leftMargin;
		offsetTop += document.body.topMargin;	
	}

	return {left:offsetLeft, top:offsetTop};
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
}
</script>

<%
	session.removeAttribute("builder");
    String actionHandler = actionForm;
  	//System.out.println("line 240: actionHandler: "+actionHandler);
	RuleDetailForm detailForm = (RuleDetailForm)request.getSession().getAttribute("Rule_"+refId);
	if(detailForm == null) {
		//System.out.println("default SIPRulesDetailForm");
		detailForm = (RuleDetailForm)request.getSession().getAttribute("com.ibm.ws.console.siprules.form.SIPRulesDetailForm");
	}

	String subexpressionOpen = null;
	String subexpressionOpenCustom = null;
	String editruleOpen = null;
	Map subMap = new HashMap();
	
	String str = "sipRouting";
	String open = null;
	String openCustom = null;
	
    if(refId.contains(str)){
    	//System.out.println("rel -- refId contains sipRouting");
		int index = refId.indexOf(str);
		//System.out.println("rel -- index = "+index);
		//System.out.println("rel -- substring from 0 to index = "+refId.substring(0, index).trim());
		String tempRef = refId.substring(0, index).trim();
		//System.out.println("tempRef: "+tempRef);
		open = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + tempRef;
		openCustom = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + tempRef + ExpressionUtil.SIP_ROUTING;
	}else {
		open = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + refId;
		openCustom = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + refId + ExpressionUtil.SIP_ROUTING;
	}

	if(request.getAttribute("submap") != null) {
		//System.out.println("subMap is not null.");
		subMap = (Map)request.getAttribute("submap");
		
		//System.out.println("***The Keys of subMap ***");
		Iterator it = subMap.keySet().iterator();
		//System.out.println("Keys: ");
		
    	while (it.hasNext()) {
        	// Get the key
        	Object key = it.next();
       		//System.out.println(" "+key+" ");
       		}

    	it = subMap.values().iterator();
   		//System.out.println("Values: ");
    
    	while (it.hasNext()) {
       		// Get the value
        	Object value = it.next();
    		//System.out.println(" "+value+" ");
    	}
        
    }

	if (subMap.get(open) != null){
		//System.out.println("subMap(open) != null");
		//System.out.println("subMap.get(open) = "+ subMap.get(open));
		subexpressionOpen = (String) subMap.get(open);
		//clear the subMap
		subMap.clear();
		request.setAttribute("submap",subMap);
	} else if (subMap.get(openCustom)!= null) {
		//System.out.println("subMap(openCustom != null)");
		//System.out.println("subMap.get(openCustom) = "+ subMap.get(openCustom));
		subexpressionOpenCustom = (String) subMap.get(openCustom); 
		//clear the subMap
		subMap.clear();
		request.setAttribute("submap",subMap);	
	} else if(request.getAttribute(open)!= null){
		//System.out.println("getAttribute open");
		subexpressionOpen =(String) request.getAttribute(open);
		request.setAttribute(open,null);
	} else if(request.getAttribute(openCustom)!= null){
		//System.out.println("getAttribute openCustom");
		subexpressionOpenCustom = (String) request.getAttribute(openCustom);
		request.setAttribute(openCustom,null);
	}
	
	String positionSubexpressionBuilder = "false";
	
	if (subexpressionOpen != null) {
		subexpressionOpen = "block";
		positionSubexpressionBuilder = "true";
	} else {
		subexpressionOpen = "none";
	}
	
	if (subexpressionOpenCustom != null) {
		subexpressionOpenCustom = "block";
		positionSubexpressionBuilder = "true";
	} else {
		subexpressionOpenCustom = "none";
	}
	
	if(request.getAttribute(ExpressionUtil.KEY_EDITRULE_OPEN+refId) != null){
		editruleOpen = "block";
	}
	
	
	if (detailForm != null && detailFormType != null) {
		pageContext.getSession().setAttribute(detailFormType,detailForm); %>
		<bean:define id="actionForm" value="<%=detailFormType%>" />
<%  } %>

<bean:define id="myRule" name="<%=actionForm%>" property="<%=rule%>" />

<%
	String editClickString = "";
	String  handShow = "none";
	String  quickEdit = "block";
	
	if (myRule.equals("")
			|| hideRuleAction.equalsIgnoreCase("true")
			|| subexpressionOpen.equals("block")
			|| subexpressionOpenCustom.equals("block")
			|| editruleOpen != null) {
		handShow = "block";
		quickEdit = "none";
	}
%>

<script language="JavaScript">
var currentOnLoad = window.onload;
if (typeof window.onload != 'function') {
	  function(){
		if ("<%=refId%>" == "") {
			window.onload = forceShowRuleBuilderDiv();
		}
		
		if ("<%=positionSubexpressionBuilder%>" == "true") {
			positionSubexpressionBuilder('ruleBuilder<%=refId%>', '<%=refId%>');
		}
	}
} else {
	window.onload = function(){
		if (!initCurrentOnLoadDone) {
                 initCurrentOnLoadDone = true;
		   		  currentOnLoad();
               }
		if ("<%=refId%>" == "") {
			forceShowRuleBuilderDiv();
		}

		if ("<%=positionSubexpressionBuilder%>" == "true") {
			positionSubexpressionBuilder('ruleBuilder<%=refId%>', '<%=refId%>');
		}
	}
}
</script>
<%

if(sipAction != null) {
	actionHandler = "SIPRulesCollectionForm";
	//System.out.println("actionHandler: " + actionHandler);
} else
{
	actionHandler = "GridClassRulesCollectionForm";
}
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
           <div id="handEditDiv<%=rowindex%>" style="display:<%=handShow%>;z-index:101;background-color:white;" >
	     	 <fieldset>
			   <legend title="<bean:message key="rule.edit.desc"/>">
				   <bean:message key="rule.edit"/>					                							                	
               </legend>

			   <table cellpadding="5" cellspacing="0">
				 <tr>
				   <td class="table-text" valign="top">
				     <%
                        String ruleBuilderLayout = "/com.ibm.ws.console.gridclassrules/ruleBuilderLayout.jsp";
                        if (customRuleBuilderLayout != null && customRuleBuilderLayout.length() > 0) {
                        	ruleBuilderLayout = customRuleBuilderLayout;
                         }
                         
                        //Bug 14149 -- Complete hack to show SIP action expression help
                        //There currently is not a good way to make this reusable.  Have to hack
                        // it based on the label.
                        if (label.equals("routing.rules.policy.expression")) {
                        	//"sip.routing.rules.expression.help"
                        	quickHelpTopic = "sip_subexpression.html";
                        	quickPluginId = "com.ibm.ws.console.siprules";
                        }
						 
				     	if(customOperands != null) {
				     		//System.out.println("actionHandler:line 346: " + actionHandler);
				     		//System.out.println("actionHandler before substring: "+actionHandler);
				     		actionHandler = actionHandler.substring(0, actionHandler.indexOf("Form"));
				     		//System.out.println("actionHandler after substring: "+actionHandler);
				     	    //System.out.println(" ruleEditLayout[customOperand]=" + customOperands); 
				     %>
				      <div id="ruleBuilder<%=refId%>" height="100%" style="display:<%=subexpressionOpenCustom%>; position:absolute; top:135; left:170; border-top:1px solid #E2E2E2; border-left:1px solid #E2E2E2; border-right:3px outset #CCCCCC; border-bottom:3px outset #CCCCCC; z-index:105;">
                       <tiles:insert page="<%=ruleBuilderLayout%>" flush="false">
                         <tiles:put name="quickHelpTopic" value="<%=quickHelpTopic%>" />
                         <tiles:put name="quickPluginId" value="<%=quickPluginId%>" />
	                     <tiles:put name="formAction" value="<%=actionForm%>" />
	                     <tiles:put name="actionHandler" value="<%=actionHandler%>" />
	                     <tiles:put name="refId" value="<%=refId%>" />
	                     <tiles:put name="rule" value="<%=rule%>" />
	                     <tiles:put name="rowindex" value="<%=rowindex%>" />
	                     <tiles:put name="customOperands" value="<%=customOperands%>" />
						 <tiles:put name="inButtonPropertyName" value="<%=inButtonPropertyName%>"/>
                   	   </tiles:insert>
                   	 </div>
				     		
				     		
				     <%	} else {
				     		//System.out.println("actionHandler before substring: "+actionHandler);
				     		actionHandler = actionHandler.substring(0, actionHandler.indexOf("Form"));
				     		//System.out.println("actionHandler after substring: "+actionHandler);
				     %>

				     <div id="ruleBuilder<%=refId%>" height="100%" style="display:<%=subexpressionOpen%>; position:absolute; top:135; left:170; border-top:1px solid #E2E2E2; border-left:1px solid #E2E2E2; border-right:3px outset #CCCCCC; border-bottom:3px outset #CCCCCC; z-index:105;">
                       <tiles:insert page="<%=ruleBuilderLayout%>" flush="false">
                         <tiles:put name="quickHelpTopic" value="<%=quickHelpTopic%>" />
                         <tiles:put name="quickPluginId" value="<%=quickPluginId%>" />
	                     <tiles:put name="formAction" value="<%=actionForm%>" />
	                     <tiles:put name="actionHandler" value="<%=actionHandler%>" />
	                     <tiles:put name="refId" value="<%=refId%>" />
	                     <tiles:put name="rule" value="<%=rule%>" />
	                     <tiles:put name="rowindex" value="<%=rowindex%>" />
	                     <tiles:put name="inButtonPropertyName" value="<%=inButtonPropertyName%>"/>
	                   </tiles:insert>
                   	 </div>
                   	
                   	  <% } %>

                  	 <!--[ <a href="#" onclick="showHideSection('ruleBuilder<%=refId%>', '<%=refId%>')" onkeydown="doSubmit(event)">
					 <bean:message key="rule.edit.link.subexpression"/></a> ]-->
					 [ <a href="javascript:showHideSection('ruleBuilder<%=refId%>', '<%=refId%>')">
					 <bean:message key="rule.edit.link.subexpression"/></a> ]

					<% if (quickHelpTopic !=null && quickHelpTopic.length()>0 && quickPluginId !=null && quickPluginId.length()>0) {%>
						[ <a href="/ibm/help/index.jsp?topic=/<%=quickPluginId%>/<%=quickHelpTopic%>"
						     target="_blank">
						<bean:message key="rule.syntax.help"/></a> ]
				    <%}%>

				   </td>
				 </tr>
				 <tr>
				   <td class="table-text-white" valign="top">
			         <% String styleId = rule+rowindex; 
			         	// populate from the collection form when working with the default rule
			         	if(rule.contains("defaultSipRoutingmatchExpression")){
			         %>
			        <label class="<%=rule%>Label" for="<%=styleId%>" title="<bean:message key="<%=desc%>"/>"/>
					   <bean:message key="<%=label%>"/>
					 </label>
				   </td>
				 </tr>
				 <tr>
			       <td class="table-text-white" valign="top">
					 <html:textarea property="<%=rule%>" name="com.ibm.ws.console.siprules.form.SIPRulesCollectionForm" cols="60" rows="3" styleClass="textEntry" styleId="<%=styleId%>">
					 </html:textarea>
				   </td>
				 </tr>
			         
			     <%	 }else {  %>
			     	<label class="<%=rule%>Label" for="<%=styleId%>" title="<bean:message key="<%=desc%>"/>"/>
					   <bean:message key="<%=label%>"/>
					 </label>
				   </td>
				 </tr>
				 <tr>
			       <td class="table-text-white" valign="top">
					 <html:textarea property="<%=rule%>" name="<%=actionForm%>" cols="60" rows="3" styleClass="textEntry" styleId="<%=styleId%>">
					 </html:textarea>
				   </td>
				 </tr>
			     
			         	
			      <% }

				    String patternClick = "applyButtonClicked('" +rowindex +"')";
		            editClickString = patternClick;
				 %>				
			     <% if (hideRuleAction == null || !hideRuleAction.equalsIgnoreCase("true")) { %>
				 <tr id="ruleAction<%=refId%>">
				   <td class="table-text-white" valign="top" colspan=2>
                     <tiles:insert page="/com.ibm.ws.console.gridclassrules/ruleActionLayout.jsp" flush="false">
	                   <tiles:put name="actionForm" value="<%=actionForm%>" />
	                   <tiles:put name="refId" value="<%=refId%>" />
	                   <tiles:put name="rowindex" value="<%=rowindex%>" />
                   	   <tiles:put name="ruleActionContext" value="<%=ruleActionContext%>" />
                   	   <tiles:put name="template" value="<%=template%>" />
                   	   <tiles:put name="actionItem0" value="<%=actionItem0%>" />
                   	   <tiles:put name="actionListItem0" value="<%=actionListItem0%>" />
                   	   <tiles:put name="actionItem1" value="<%=actionItem1%>" />
                   	   <tiles:put name="actionListItem1" value="<%=actionListItem1%>" />
                   	   <tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
                   	 </tiles:insert>
		           </td>
				 </tr>
                 <% } %>
			     <% if (hideValidate == null || !hideValidate.equalsIgnoreCase("true")) { %>
                 <tr>
            	   <td class="table-text" valign="top" colspan=2>
                     <span style="margin-left:1em">
                       <% String setRowIndex = "setRowIndex('"+rowindex+"')"; %>
				       <html:submit styleClass="buttons" property="rule.action.matchrule.validate.button" styleId="otherValidate" onclick="<%=setRowIndex%>">
				         <bean:message key="rule.action.matchrule.validate.button" />
				       </html:submit>
                       <input type="button" name="Cancel" value="<bean:message key="button.cancel"  />" class="buttons" id="otherCancel" onclick="showSectionParent('<%=rowindex%>')"/>
                     </span>
                   </td>
				 </tr>
				 <% } %>
               </table>
             </fieldset>
            </div>

<% if (!hideRuleAction.equalsIgnoreCase("true")) { %>
            <bean:define id="thenExpression" name="<%=actionForm%>" property="<%=actionItem0%>" type="java.lang.String"/>
            <div id="staticEditDiv<%=rowindex%>" style="display:<%=quickEdit%>">

            <% if (rule.equals("")) {  %>
	            <script>
        	        <%=editClickString%>;
    	        </script>
	            <i><span style="color:gray"><bean:message key="rule.action.matchrule.emptyrule" /></span></i><br/>
<%
			     if (!SecurityContext.isSecurityEnabled() ||
				     (request.isUserInRole("administrator") || request.isUserInRole("configurator"))) {
%>
    		       [ <a id="quickEditLink<%=rowindex%>" href="javascript:<%=editClickString%>;showSectionParent('<%=rowindex%>')">
						<bean:message key="rule.edit" /></a> ]
<%			     } %>
           		<br/>
			<% } else { %>
	            <bean:message key="rule.edit.matchrule.label" />
	            <span style="color:gray">
					<bean:write name="<%=actionForm%>" property="<%=rule%>" />
				</span>
				<br/>
	            <%
			      //rule.action.matchrule.service OR rule.action.matchrule.routing
			      
			      //TODO: "sip.rules.routing" removal
			      // (1) Remove all need for "sip.rules.routing" template to be hardcoded here. 
			      // (2) NLS keys are not added properly
			      //	Modify these values in webui.xd.core plugin.nlsprops:
			      //	  rule.action.matchrule.sip.rules.routing.desc= SIP Routing Rules
				  //	  rule.action.matchrule.sip.rules.routing=SIP Routing Rules
				  //	To be the same as these values:
				  //	  rule.action.matchrule.routing=Then
				  //	  rule.action.matchrule.routing.desc=An action that occurs when the conditional expression is true.
				  //  (3) Remove org.apache.struts.util.MessageResources import
				  //
				  //TODO: This need could be removed by forcing everyone useing this layout to specify
				  //	a tile definition that defines how they want their rule to be displayed.
			      String labelkey = "rule.action.matchrule."+template;
			      String descriptionkey = labelkey+".desc";
			      if (template.equals("sip.rules.routing")) {
			      	labelkey = labelkey.replace("sip.rules.routing","routing");
			      	descriptionkey = descriptionkey.replace("sip.rules.routing","routing");
			      }
	            %>
   	            <bean:message key="<%=labelkey%>" />
   	
				<%  if (template.equals("routing")) { %>
			            <bean:define id="routingAction" name="<%=actionForm%>" property="<%=actionItem1%>" type="java.lang.String"/>
	                    <bean:define id="matchActionItem" name="<%=actionForm%>" property="<%=actionItem0%>" type="java.lang.String"/> <%
					    int i = matchActionItem.indexOf(":");
					    matchActionItem = matchActionItem.substring(i+1);
					    thenExpression = routingAction+" "+matchActionItem;
				    } else if (template.equals("sip.rules.routing")) { %>
	                    <bean:define id="matchActionItem2" name="<%=actionForm%>" property="<%=actionItem0%>" type="java.lang.String"/> <%
	                    String[] matchActionItems = matchActionItem2.split(":");
						MessageResources messages = MessageResources.getMessageResources("com.ibm.ws.console.core.resources.ConsoleAppResources");
						String routingPolicy ="";
	                    String routingAction = "";
	                    String input = "";
	                    if (matchActionItems.length == 3) {
	                		routingAction = "workclass.matchrule.routing.label.permit";
	                		
							//routingPolicy = matchActionItems[1];
		                	//if (routingPolicy.equals("Error"))
		                	//	routingPolicy = "routing.rules.policy.error"; 
		                	//else if (routingPolicy.equals("Failover"))
		                	//	routingPolicy = "routing.rules.policy.failover";
		                	//if (routingPolicy.equals("WRR"))
		                	//	routingPolicy = "routing.rules.policy.weightedroundrobin";
							//routingPolicy = " "+messages.getMessage(request.getLocale(),routingPolicy);
	                    	input = "<br />"+matchActionItems[2];
	                    } else if (matchActionItems.length == 2) {
	                		routingAction = "workclass.matchrule.routing.label.reject";
	                    	input = " "+matchActionItems[1];
	                    }
						routingAction = messages.getMessage(request.getLocale(),routingAction);
					    thenExpression = routingAction+routingPolicy+input;
				   } %>

    	        <span style="color:gray" id="te<%=rowindex%>"><%=thenExpression%></span><br/>
		           [ <a id="quickEditLink<%=rowindex%>" href="javascript:<%=editClickString%>;showSectionParent('<%=rowindex%>')">
						<bean:message key="rule.edit" /></a> ]
           		<br/>
			<% }%>
            </div>
<% } %>

         </td>
	  </tr>		
	</tbody>
</table>