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
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.xdcore.form.RuleDetailForm"%>
<%@ page language="java" import="com.ibm.ws.console.xdcore.util.ExpressionUtil"%>

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

<tiles:useAttribute name="httpAction" classname="java.lang.String" ignore="true"/>

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


function showSectionParent(objectNum, refId) {

    objectId = "handEditDiv"+refId;
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
    String contextId = (String)request.getAttribute("contextId");

    AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
    String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

	session.removeAttribute("builder");
    String actionHandler = actionForm;
  	//System.out.println("line 240: actionHandler: "+actionHandler);
	RuleDetailForm detailForm = (RuleDetailForm)request.getSession().getAttribute("Rule_"+refId);
	if(detailForm == null) {
		//System.out.println("default SIPRulesDetailForm");
		detailForm = (RuleDetailForm)request.getSession().getAttribute("com.ibm.ws.console.rules.form.RulesDetailForm");
	}

	String subexpressionOpen = null;
	String subexpressionOpenCustom = null;
	String editruleOpen = null;
	Map subMap = new HashMap();
	
	String handEditDiv = "handEditDiv" + refId;
	String str = "httpRouting";
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
		openCustom = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + tempRef + ExpressionUtil.HTTP_ROUTING;
	}else {
		open = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + refId;
		openCustom = ExpressionUtil.KEY_SUBEXPRESSION_OPEN + refId + ExpressionUtil.HTTP_ROUTING;
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
	window.onload = loadFunction();
} else {
	window.onload = function(){
		//if (!initCurrentOnLoadDone) {
        //	initCurrentOnLoadDone = true;
		//   	currentOnLoad();
        //}
		if (!initCurrentOnLoadDone) {
                 initCurrentOnLoadDone = true;
		   		  currentOnLoad();
               }
		loadFunction();
	}
}

function loadFunction() {
	if ("<%=refId%>" == "") {
		forceShowRuleBuilderDiv();
	}

	if ("<%=positionSubexpressionBuilder%>" == "true") {
		positionSubexpressionBuilder('ruleBuilder<%=refId%>', '<%=refId%>');
	}
}
</script>

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	<tbody>
		<tr valign="top">
			<td class="table-text" nowrap valign="top">
		 
				<div id="<%=handEditDiv%>" style="display:<%=handShow%>;z-index:101;background-color:white;" >
					<fieldset>
						<legend title="<bean:message key="condition.edit.desc"/>">
							<bean:message key="condition.edit"/>				                							                	
						</legend>

			   			<table cellpadding="5" cellspacing="0" role="presentation">
			   				<tr>
								<td class="table-text-white" valign="top">
									<label class="<%=rule%>Label" for="<%=rule%>" title="<bean:message key="<%=desc%>"/>">
							  			<bean:message key="<%=label%>"/>
							 		</label>
						   		</td>
						 	</tr>
						 	
							<tr>
				   				<td class="table-text" valign="top">
                                <%
                                    String ruleBuilderLayout = "/com.ibm.ws.console.intellmgmt/requestBuilderLayout.jsp";
                                    
                                  	//System.out.println("actionHandler before substring: "+actionHandler);
				     		        //actionHandler = actionHandler.substring(0, actionHandler.indexOf("Form"));
				     		        actionHandler = "traceSpecDetail";
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
                   					
                  	                [ <a href="#" onclick="showHideSection('ruleBuilder<%=refId%>', '<%=refId%>')">
					                    <bean:message key="rule.edit.link.subexpression"/>
                                    </a> ]

								<% if (quickHelpTopic != null && quickHelpTopic.length() > 0 && quickPluginId != null && quickPluginId.length() > 0) {%>
									[ <a href="/ibm/help/index.jsp?topic=/<%=quickPluginId%>/<%=quickHelpTopic%>" target="_blank">
										<bean:message key="rule.syntax.help"/>
									</a> ]
								<% } %>

				   				</td>
							</tr>
				 			
						 	<tr>
					       		<td class="table-text-white" valign="top">
					       			<% String styleId = rule+rowindex; %>
							 		<html:textarea property="<%=rule%>" name="<%=actionForm%>" cols="60" rows="3" styleClass="textEntry" styleId="<%=styleId%>">
							 		</html:textarea>
						   		</td>
						 	</tr>
		               </table>
					</fieldset>
				</div>
			</td>
		</tr>		
	</tbody>
</table>
