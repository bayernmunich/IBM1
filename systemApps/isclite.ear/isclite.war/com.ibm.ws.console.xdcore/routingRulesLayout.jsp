<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*,com.ibm.ws.sm.workspace.RepositoryContext,com.ibm.ws.console.core.Constants"%>

<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*"%>

<!-- Row of rule that is being edited. -->
<tiles:useAttribute id="refId" name="refId" classname="java.lang.String"/>

<!-- Row of rule that is being edited. -->
<tiles:useAttribute id="rowindex" name="rowindex" classname="java.lang.String"/>

<!-- label for drop down menu -->
<tiles:useAttribute id="label" name="label" classname="java.lang.String"/>

<!-- label description for drop down menu -->
<tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>

<!-- "yes" if you want this drop down item to be required. -->
<tiles:useAttribute id="isRequired" name="isRequired" ignore="true" classname="java.lang.String"/>

<!-- give units if applicable -->
<tiles:useAttribute id="units" name="units" ignore="true" classname="java.lang.String"/>

<!-- Name of form attribute to get and set the selected value. -->
<tiles:useAttribute id="property" name="property" classname="java.lang.String"/>

<!-- Name of form attribute to get the list of drop down options.  -->
<tiles:useAttribute id="listProperty" name="listProperty" classname="java.lang.String"/>

<!-- action form  -->
<tiles:useAttribute id="formBean" name="formBean" classname="java.lang.String"/>

<!-- "true" if drop down should be read only -->
<tiles:useAttribute id="readOnly" name="readOnly" ignore="true" classname="java.lang.String"/>

<!-- "true" if you wish to allow multiple selections. -->
<tiles:useAttribute id="multiSelect" name="multiselect" ignore="true" classname="java.lang.String"/>

<tiles:useAttribute name="ruleDetailForm" classname="java.lang.String" />

<script language="JavaScript">
	var initCurrentOnLoadDone = false;

	function specifyByFilterClicked<%=refId%>(rowindex, refId) {
	    var ri = parseInt(rowindex);
	    showTargetClusterItemsDiv<%=refId%>(rowindex,refId);
	}
	
	function cellFilterClicked<%=refId%>(rowindex, refId) {
		var selectedLevel = "2";
		var selectedTarget = null;
		var selectedAction = null;
		var selectedCell = null;
		var ri = parseInt(rowindex);
		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		} else {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}	

		if ((ri == 0) && (refId == "")) {
			selectedCell = document.forms[0].selectedCellName.value;
		} else if( (ri >= 0)) {
			//alert("Block 2:: rowindex: "+ rowindex +" refId: "+refId);
			selectedCell = document.forms[0].selectedCellName[rowindex].value;
		}
		//alert("cellFilterClicked:: selectedTarget: "+ selectedTarget + "  selectedCell: " + selectedCell);
		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?selectedTarget="+selectedTarget 
		  + "&selectedCell=" + selectedCell +"&selectedAction=" + selectedAction + "&level=" + selectedLevel + "&rowindex=" + rowindex 
		  + "&refId=" + refId + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	
	function moduleFilterClicked<%=refId%>(rowindex, refId) {
		var selectedLevel = 3;
		var selectedAppName=null;
		var selectedTarget=null;
		var selectedAction = null;
		var ri = parseInt(rowindex);
		
		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		} else {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}	
		
		if ((ri == 0) && (refId == "")) {
			selectedAppName=document.forms[0].selectedAppName.value;
		} else if ((ri >= 0)) {
			selectedAppName=document.forms[0].selectedAppName[rowindex].value;
		}
		
		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?selectedAppName=" + selectedAppName 
		   + "&selectedAction=" + selectedAction + "&level=" + selectedLevel + "&rowindex=" + rowindex 
		   + "&refId=" + refId + "&selectedTarget=" + selectedTarget
		   + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	
	function appEditionFilterClicked<%=refId%>(rowindex, refId) {
		var selectedLevel = 4;
		var selectedAppEdition = null;
		var selectedServer = null;
		var selectedTarget = null;
		var selectedAction = null;
		var ri = parseInt(rowindex);
		
		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		} else {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}	
		
		if ((ri == 0) && (refId == "")) {
			selectedAppEdition =document.forms[0].selectedAppEdition.value;
			selectedServer = document.forms[0].selectedServerName.value;
		} else if((ri >= 0)) {
			selectedAppEdition =document.forms[0].selectedAppEdition[rowindex].value;
			selectedServer = document.forms[0].selectedServerName[rowindex].value;
		}

		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?selectedAppEdition=" + selectedAppEdition 
		  + "&selectedAction=" + selectedAction + "&level=" + selectedLevel +"&selectedServer=" +selectedServer 
		  + "&rowindex=" + rowindex + "&refId=" + refId + "&selectedTarget=" + selectedTarget
		  + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	} 
	
	function serverFilterClicked<%=refId%>(rowindex, refId) {
		var selectedLevel = 3;
		var selectedNode=null;
		var selectedTarget = null;
		var selectedAction = null;
		var ri = parseInt(rowindex);

		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		} else {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}		

		if ((ri == 0) && (refId == "")) {
			selectedNode = document.forms[0].selectedNodeName.value;		
		} else if((ri >= 0)) {
			selectedNode=document.forms[0].selectedNodeName[rowindex].value;
		}

		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?selectedNode=" + selectedNode 
		  + "&selectedAction=" + selectedAction + "&level=" + selectedLevel + "&rowindex=" + rowindex 
		  + "&refId=" + refId + "&selectedTarget=" + selectedTarget
		  + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	
	function addClicked<%=refId%>(rowindex, refId) {
		var transferTarget = "transferToMultiSelect";
		var selectedTarget = null;
		var selectedAction = null;
		var botElement = "cluster";

		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		}  else if (rowindex >= 0) {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}

		if (rowindex == 0 && refId == "") {
			if(selectedTarget == "cluster"){
				botElement = document.forms[0].selectedClusterName.value;
			} else if(selectedTarget == "server"){
		 		botElement = document.forms[0].selectedServerName.value;
		 	} else if(selectedTarget == "module"){
				botElement =  document.forms[0].selectedAppModule.value;
		 	}
		} else if (rowindex >= 0) {
			if(selectedTarget == "cluster"){
				botElement = document.forms[0].selectedClusterName[rowindex].value;
			} else if(selectedTarget == "server"){
				botElement = document.forms[0].selectedServerName[rowindex].value;
			} else if(selectedTarget == "module"){
				botElement = document.forms[0].selectedAppModule[rowindex].value;
			}
		}

		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?transferTarget=" + transferTarget 
		  + "&selectedAction=" + selectedAction + "&selectedTarget=" + selectedTarget + "&botElement=" + botElement 
		  + "&refId=" + refId + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	
	
	function removeClicked<%=refId%>(rowindex, refId) {
		var removeTarget = "removeFromMultiSelect";
		var remElement = null;
		var selectedTarget = null;
		var selectedAction = null;
		var ri = parseInt(rowindex);

		if (refId == "") {
			selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
			selectedAction = document.forms[0].defaultselectedAction.value;
		} else if (rowindex==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
			selectedAction = document.forms[0].selectedAction.value;
		} else {
			selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
			selectedAction = document.forms[0].selectedAction[rowindex].value;
		}		

		if ((ri == 0) && (refId == "")) {
			remElement = document.forms[0].selectedRemove.value;
		} else if ((ri >= 0)) {
			remElement = document.forms[0].selectedRemove[rowindex].value;
		}

		//alert("remElement: "+remElement);
		window.location = encodeURI("/ibm/console/SIPRulesCollection.do?removeTarget=" + removeTarget
		  + "&selectedAction=" + selectedAction + "&selectedTarget=" + selectedTarget + "&remElement=" + remElement 
		  + "&refId=" + refId + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
	
    function showActionDiv<%=refId%>(rowindex,refId) {
    	//alert("showActionDiv<%=refId%>:entry: ("+rowindex+", "+refId+")");
    	var selectedAction = null;
    	if (refId == "") {
    		selectedAction = document.forms[0].defaultselectedAction.value;
    	} else if (rowindex==0 && refId != "") {
    		selectedAction = document.forms[0].selectedAction.value;
    	} else if((rowindex >= 0)) {
    		selectedAction = document.forms[0].selectedAction[rowindex].value;
    	}
        //alert("showActionDiv<%=refId%>:selectedAction : ("+selectedAction +")");
        if (selectedAction == "permit") {
	        document.getElementById('actionDiv<%=refId%>').style.display = "block";
            document.getElementById('rejectDiv<%=refId%>').style.display = "none";
        } else {
            document.getElementById('actionDiv<%=refId%>').style.display = "none";
            document.getElementById('rejectDiv<%=refId%>').style.display = "block";
        }
        
    }
    
    function showTargetClusterItemsDiv<%=refId%>(rowindex,refId) {
    	//alert("showTargetClusterItemsDiv<%=refId%>:entry: ("+rowindex+", "+refId+")");
    	var selectedTarget = null;
    	var ri = parseInt(rowindex);

    	if (refId =="") {
    		selectedTarget = document.forms[0].defaultselectedSpecifyBy.value;
		} else if (ri==0 && refId != "") {
			selectedTarget = document.forms[0].selectedSpecifyBy.value;
    	} else if( (ri >= 0)) {
    		selectedTarget = document.forms[0].selectedSpecifyBy[rowindex].value;
    	}
    	
		//alert("showTargetClusterItemsDiv<%=refId%>:selectedTarget: ("+selectedTarget+")");
        if(selectedTarget == "expression") {
        	document.getElementById('expDiv<%=refId%>').style.display = "block"; 
        	document.getElementById('cellDiv<%=refId%>').style.display = "none"; 
        	document.getElementById('clusterDiv<%=refId%>').style.display = "none";    
            document.getElementById('serverDiv<%=refId%>').style.display = "none";  
            document.getElementById('moduleDiv<%=refId%>').style.display = "none";
            document.getElementById('addRemoveDiv<%=refId%>').style.display = "none";
             
        } else if (selectedTarget == "cluster") {
        	document.getElementById('expDiv<%=refId%>').style.display = "none";
        	document.getElementById('cellDiv<%=refId%>').style.display = "block"; 
            document.getElementById('clusterDiv<%=refId%>').style.display = "block";    
            document.getElementById('serverDiv<%=refId%>').style.display = "none";  
            document.getElementById('moduleDiv<%=refId%>').style.display = "none";
            document.getElementById('addRemoveDiv<%=refId%>').style.display = "block";
          
        } else if (selectedTarget == "server") {
        	document.getElementById('expDiv<%=refId%>').style.display = "none";
        	document.getElementById('cellDiv<%=refId%>').style.display = "block"; 
         	document.getElementById('clusterDiv<%=refId%>').style.display = "none";    
            document.getElementById('serverDiv<%=refId%>').style.display = "block";  
            document.getElementById('moduleDiv<%=refId%>').style.display = "none";
            document.getElementById('addRemoveDiv<%=refId%>').style.display = "block";
     
        } else if (selectedTarget == "module") {
            document.getElementById('expDiv<%=refId%>').style.display = "none";
            document.getElementById('cellDiv<%=refId%>').style.display = "block"; 
            document.getElementById('clusterDiv<%=refId%>').style.display = "none";    
            document.getElementById('serverDiv<%=refId%>').style.display = "none";  
            document.getElementById('moduleDiv<%=refId%>').style.display = "block";
            document.getElementById('addRemoveDiv<%=refId%>').style.display = "block";
             
        } else {
        	document.getElementById('expDiv<%=refId%>').style.display = "block";
        	document.getElementById('cellDiv<%=refId%>').style.display = "none"; 
            document.getElementById('clusterDiv<%=refId%>').style.display = "none";    
            document.getElementById('serverDiv<%=refId%>').style.display = "none";  
            document.getElementById('moduleDiv<%=refId%>').style.display = "none";
            document.getElementById('addRemoveDiv<%=refId%>').style.display = "none";
        }           
    }   	
</script>

<%
String selectedAction = "selectedAction";
String rejectCode = "rejectCode";
String selectedSpecifyBy = "selectedSpecifyBy";
if (property.startsWith("default")) {
	selectedAction = "default"+selectedAction;
	rejectCode = "default"+rejectCode;
	selectedSpecifyBy = "default"+selectedSpecifyBy;
}

String selectedActionId = selectedAction + refId;
String selectedSpecifyById = selectedSpecifyBy + refId;
String rejectCodeId = rejectCode + refId;

String selectedClusterName = "selectedClusterName" + refId;
String selectedCellName = "selectedCellName" + refId;
String selectedServerName = "selectedServerName" + refId;
String selectedNodeName = "selectedNodeName" + refId;
String selectedAppName = "selectedAppName" + refId;
String selectedAppEdition = "selectedAppEdition" + refId;
String selectedAppModule = "selectedAppModule" + refId;
String selectedRemove = "selectedRemove" + refId;

%>
<bean:define id="tempTarget" property="<%=selectedSpecifyBy%>" name="<%=formBean%>" type="java.lang.String" />
<bean:define id="actionType" property="<%=selectedAction%>" name="<%=formBean%>" type="java.lang.String" />
<%
String none = "none.text";
String target = null;
String actionEdit = "block";
String cellEdit = "none";
String expressionEdit = "none";
String clusterEdit = "none";
String serverEdit = "none";
String moduleEdit= "none";
String rejectEdit = "none";
String addRemoveEdit = "none";

String specifyFilterClicked = "specifyByFilterClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String cellFilterClicked = "cellFilterClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String appEditionFilterClicked = "appEditionFilterClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String addTarget = "addClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String removeTarget = "removeClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String showActionMethod = "showActionDiv"+refId+"('"+rowindex+"', '"+refId+"')";
String showTargetClusterItemsMethod = "showTargetClusterItemsDiv"+refId+"('"+rowindex+"', '"+refId+"')";
String serverFilterClicked = "serverFilterClicked"+refId+"('"+rowindex+"', '"+refId+"')";
String moduleFilterClicked = "moduleFilterClicked"+refId+"('"+rowindex+"', '"+refId+"')";


//TODO: Make the following change when Pii permits
//String actKeyArr[]  = {"routing.rules.permit","routing.rules.reject"};
//Change:
//routing.rules.permit=permit
//routing.rules.reject=reject
//To:
//routing.rules.permit=Permit routing to
//routing.rules.reject=Reject routing with return code
String actKeyArr[]  = {"workclass.matchrule.routing.label.permit","workclass.matchrule.routing.label.reject"};
String specKeyArr[] = {"routing.rules.module","routing.rules.cluster","routing.rules.server","routing.rules.expression"};
String polKeyArr[] = {"routing.rules.policy.error","routing.rules.policy.failover","routing.rules.policy.weightedroundrobin"};
String charLines = "---------------------------------";

int actKeyArrIndex=0;
int specKeyArrIndex=0;
int polKeyIndex=0;
int defaultLevel=1;


//System.out.println("tempTarget:"+refId+": " + tempTarget);

if (!actionType.equals("permit")) {
	actionEdit = "none";
	rejectEdit = "block";
}

if(tempTarget.equals("expression")) { 
		//System.out.println("expressionLayout"); 
	    expressionEdit = "block";
	    addRemoveEdit = "none";
}

if(tempTarget.equals("cluster")){ 
		//System.out.println("clusterLayout, not setting to block"); 
		cellEdit = "block";
	 	clusterEdit = "block";
	 	addRemoveEdit = "block";
	 	expressionEdit = "none";
}

if(tempTarget.equals("server")){ 
		//System.out.println("serverLayout");
		cellEdit = "block";
		serverEdit = "block";
		addRemoveEdit = "block";
		expressionEdit = "none";
}

if(tempTarget.equals("module")){ 
		//System.out.println("moduleLayout");
		cellEdit = "block";
		moduleEdit = "block";
		addRemoveEdit = "block";
		expressionEdit = "none";
}

%>


<body>

<style>
.main-categoryCustom { 
    padding: 0em;
    margin-top: .5em; 
    margin-bottom:0em; 
    text-decoration: none; 
    color: #336699; 
    font-weight:bold;
    border-bottom: 2px solid #336699; 
    width: 100%;
    margin-left:0em;
    white-space: nowrap; 
       
}
</style>
<% if (property.startsWith("default")) { //TODO: add this label to NLS file & make this more reusable.%>
  <br />
  <div id="title<%=property%><%=refId%>" class="main-categoryCustom" style='margin-left:0.3em;'>
  	<bean:message key="workclass.routing.default.action.label"/>
  </div>
  <br />
<% } %>

   		<label for="<%=selectedActionId%>" title="<bean:message key="select.action"/>">
 		  <bean:message key="select.action"/>
   		</label>
   		<br>
   		
   		<html:select property="<%=selectedAction%>" name="<%=formBean%>" size="1" styleId="<%=selectedActionId%>" onchange="<%=showActionMethod%>">
      		<logic:iterate id="dropDownItem" name="<%=formBean%>" property="actionTypes">
 		  	<% String value = ((String)dropDownItem).trim(); 
 		  	   String key = (String) actKeyArr[actKeyArrIndex];
 		  	   actKeyArrIndex++;
 		  	%>
	    	<html:option value="<%=value%>" key="<%=key%>" />
	   		</logic:iterate>
		</html:select>
		 
<div id="actionDiv<%=refId%>" style="display:<%=actionEdit%>" >

<fieldset>
  <legend><b><bean:message key="routing.rules.specify"/></b></legend>
  <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation"> 
    <tr valign="top" >
      <td class="table-text" nowrap valign="top">
   		<label for="<%=selectedSpecifyById%>" title="<bean:message key="routing.rules.specify.by"/>">
 		  <bean:message key="routing.rules.specify.by"/>
   		</label>
	    <br>        
        <html:select property="<%=selectedSpecifyBy%>" name="<%=formBean%>" size="1" styleId="<%=selectedSpecifyById%>" onchange="<%=specifyFilterClicked%>">
          <logic:iterate id="dropDownItem" name="<%=formBean%>" property="specifyByList">													  
 		  	<% String value = ((String)dropDownItem).trim(); 
 		  	   String key = (String) specKeyArr[specKeyArrIndex];
 		  	   specKeyArrIndex++;
 		  	%>
		    <html:option value="<%=value%>" key="<%=key%>" />
		  </logic:iterate>
        </html:select>
   	  </td>
    </tr>
       
    <tr valign="top">
      <td class="table-text" nowrap valign="top">    
       <div id="expDiv<%=refId%>" style= "display:<%=expressionEdit%>" >
         <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table"> 		 	
          
          <%  	String newStr = refId + "sipRouting"; 
          		//default case
                if(refId.equals("")) {  %>
          		<tr valign="top">
           			<td class="table-text" nowrap valign="top"> 	        
						<tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
					       <tiles:put name="actionForm" value="<%=ruleDetailForm%>" /> 
					       <tiles:put name="label" value="routing.rules.policy.expression" />
					       <tiles:put name="desc" value="routing.rules.policy.expression.desc" />
					       <tiles:put name="hideValidate" value="true" />
				       	   <tiles:put name="hideRuleAction" value="true" />
				       	   <tiles:put name="rule" value="defaultSipRoutingmatchExpression" />
				       	   <tiles:put name="rowindex" value="<%=rowindex%>" />
				       	   <tiles:put name="refId" value="<%=newStr%>" />
				       	   <tiles:put name="ruleActionContext" value="routing" />
				       	   <tiles:put name="template" value="sip.rules.routing" />
				       	   <tiles:put name="actionItem0" value="notUsed" />
				       	   <tiles:put name="actionListItem0" value="notUsed" />
				       	   <tiles:put name="actionItem1" value="notUsed" />
       	   				   <tiles:put name="actionListItem1" value="notUsed" />
       	   				   <tiles:put name="customOperands" value="custom" />
       	   				   <tiles:put name="sipAction" value="sip" />
       	   				   <tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
       	   				   <tiles:put name="detailFormType" value="com.ibm.ws.console.siprules.form.SIPRulesDetailForm" />
       	   				   <tiles:put name="inButtonPropertyName" value="installActionCustom"/>
       	 				</tiles:insert>
					</td>
		   		</tr>     	
          
          
          <% }else {%>
          		 <tr valign="top">
           			<td class="table-text" nowrap valign="top"> 	        
						<tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
					       <tiles:put name="actionForm" value="<%=ruleDetailForm%>" /> 
					       <tiles:put name="label" value="routing.rules.policy.expression" />
					       <tiles:put name="desc" value="routing.rules.policy.expression.desc" />
					       <tiles:put name="hideValidate" value="true" />
				       	   <tiles:put name="hideRuleAction" value="true" />
				       	   <tiles:put name="rule" value="sipRoutingMatchExpression" />
				       	   <tiles:put name="rowindex" value="<%=rowindex%>" />
				       	   <tiles:put name="refId" value="<%=newStr%>" />
				       	   <tiles:put name="ruleActionContext" value="routing" />
				       	   <tiles:put name="template" value="sip.rules.routing" />
				       	   <tiles:put name="actionItem0" value="notUsed" />
				       	   <tiles:put name="actionListItem0" value="notUsed" />
				       	   <tiles:put name="actionItem1" value="notUsed" />
       	   				   <tiles:put name="actionListItem1" value="notUsed" />
       	   				   <tiles:put name="customOperands" value="custom" />
       	   				   <tiles:put name="sipAction" value="sip" />
       	   				   <tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
						   <tiles:put name="inButtonPropertyName" value="installActionCustom"/>
       	 				</tiles:insert>
					</td>
		   		</tr>     		
          <% } %>
          
          
		  
		
        </table>
      </div> 
    
    <tr valign="top">
      <td class="table-text" nowrap valign="top">    
       <div id="cellDiv<%=refId%>" style="display:<%=cellEdit%>">
         <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">  
           <tr valign="top">
            <td class="table-text" nowrap valign="top"> 	        
    	      <label for="<%=selectedCellName%>" title="<bean:message key="routing.rules.select.cell.name"/>">
                <bean:message key="routing.rules.select.cell.name"/>
              </label>
              <br>		
		      	<html:select property="selectedCellName" name="<%=formBean%>" size="1" styleId="<%=selectedCellName%>" onchange="<%=cellFilterClicked%>" >
		  	    <html:option value="*">*</html:option>
                <logic:iterate id="dropDownItem" name="<%=formBean%>" property="cellNameList">
 		  	    <% String value = ((String)dropDownItem).trim(); %>
		       	<html:option value="<%=value%>"><%=value%></html:option>
		  	    </logic:iterate>
		      </html:select>
            </td>
           </tr>
        </table>
      </div> 
   
   <tr valign="top">
	<td class="table-text"  nowrap valign="top">
		<div id="clusterDiv<%=refId%>" style="display:<%=clusterEdit%>" >
		  <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
			<tr valign="top">
            	<td class="table-text" nowrap valign="top">
		        <label for="<%=selectedClusterName%>" title="<bean:message key="routing.rules.select.cluster.name"/>"><bean:message key="routing.rules.select.cluster.name"/></label>
				<br>
				<html:select property="selectedClusterName" name="<%=formBean%>" size="1" styleId="<%=selectedClusterName%>"  >
				<html:option value="*">*</html:option>
		        <logic:iterate id="dropDownItem" name="<%=formBean%>" property="clusterNameList">
		 		<% String value = ((String)dropDownItem).trim(); %>
				<html:option value="<%=value%>"><%=value%></html:option>
				</logic:iterate>
				</html:select>
		   		</td>
		   	</tr>
		  </table>
		 </div>
   
   
   <tr valign="top">
	<td class="table-text"  nowrap valign="top">
		<div id="serverDiv<%=refId%>" style="display:<%=serverEdit%>" >
		  <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
			<tr valign="top">
            	<td class="table-text" nowrap valign="top">
		            <label  for="<%=selectedNodeName %>" TITLE="<bean:message key="routing.rules.select.node.name"/>">
				    <bean:message key="routing.rules.select.node.name"/>
				    </label>
				    <br>
				    <html:select property="selectedNodeName" name="<%=formBean%>" size="1" styleId="<%=selectedNodeName %>" onchange="<%=serverFilterClicked%>" >
				  	<html:option value="*">*</html:option>
		            <logic:iterate id="dropDownItem" name="<%=formBean%>" property="nodeNameList">
		 		  	<% String value = ((String)dropDownItem).trim(); %>
				    <html:option value="<%=value%>"><%=value%></html:option>
				  	</logic:iterate>
				    </html:select>
		   		</td>
		   	</tr>
		   	<tr valign="top">
            	<td class="table-text" nowrap valign="top">
		            <label  for="<%=selectedServerName%>" TITLE="<bean:message key="routing.rules.select.server.name"/>">
				    <bean:message key="routing.rules.select.server.name"/>
	 	        	</label>
				    <br>
				    <html:select property="selectedServerName" name="<%=formBean%>" size="1" styleId="<%=selectedServerName%>">
		  	      	<html:option value="*">*</html:option>
                  	<logic:iterate id="dropDownItem" name="<%=formBean%>" property="serverNameList">
 		  	      	<% String value = ((String)dropDownItem).trim(); %>
		          	<html:option value="<%=value%>"><%=value%></html:option>
		  	      	</logic:iterate>
		        	</html:select>
		   		</td>
		   	</tr>
		  </table>
		 </div>
		 
	<tr valign="top">
	  <td class="table-text"  nowrap valign="top">
		<div id="moduleDiv<%=refId%>" style="display:<%=moduleEdit%>">
		  <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
			<tr valign="top">
            		<td class="table-text" nowrap valign="top">
		    		<label for="<%=selectedAppName%>" title="<bean:message key="routing.rules.select.app.name"/>"><bean:message key="routing.rules.select.app.name"/></label>
					<br>
				    <html:select property="selectedAppName" name="<%=formBean%>" size="1" styleId="<%=selectedAppName%>" onchange="<%=moduleFilterClicked%>" >
		            <html:option value="*">*</html:option>
                  	<logic:iterate id="dropDownItem" name="<%=formBean%>" property="appNameList">
 		  	      	<% String value = ((String)dropDownItem).trim(); %>
		          	<html:option value="<%=value%>"><%=value%></html:option>
		  	      	</logic:iterate>
		        	</html:select>
		   			</td>
		   	</tr>
		   	<tr valign="top">
            		<td class="table-text" nowrap valign="top">
		          	<label for="<%=selectedAppEdition%>" title="<bean:message key="routing.rules.select.app.edition"/>"><bean:message key="routing.rules.select.app.edition"/></label>
				    <br>
				    <html:select property="selectedAppEdition" name="<%=formBean%>" size="1" styleId="<%=selectedAppEdition%>"   onchange="<%=appEditionFilterClicked%>"   >
		  	      	<html:option value="*">*</html:option>
                  	<logic:iterate id="dropDownItem" name="<%=formBean%>" property="appEditionNameList">
 		  	      	<% String value = ((String)dropDownItem).trim(); %>
		          	<html:option value="<%=value%>"><%=value%></html:option>
		  	    	</logic:iterate>   	
		        	</html:select>
		   			</td>
		   	</tr>
		   	<tr valign="top">
            		<td class="table-text" nowrap valign="top">
		          	<label for="<%=selectedAppModule%>" title="<bean:message key="routing.rules.select.app.module"/>"><bean:message key="routing.rules.select.app.module"/></label>
				    <br>
				    <html:select property="selectedAppModule" name="<%=formBean%>" size="1" styleId="<%=selectedAppModule%>">
		  	     	<html:option value="*">*</html:option>
                 	<logic:iterate id="dropDownItem" name="<%=formBean%>" property="appModuleNameList">
 		  	     	<% String value = ((String)dropDownItem).trim(); %>
		         	<html:option value="<%=value%>"><%=value%></html:option>
		  	    	</logic:iterate>
		      		</html:select>
		      		</td>
		   	</tr>
		  </table>
		 </div>
		 
	  	 <div id="addRemoveDiv<%=refId%>" style= "display:<%=addRemoveEdit%>" >
	  	 	<table border="0" cellpadding="0" cellspacing="0" width="100%" role="presentation">
      			<td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">
				    	<html:button styleClass="buttons_other" property="<%=property%>" onclick="<%=addTarget%>" >
				      	<bean:message key="workclass.button.add"/>
				    	</html:button>
				    	<br/><br/>
				    	<html:button styleClass="buttons_other" property="<%=property%>" onclick="<%=removeTarget%>" >
				      	<bean:message key="workclass.button.remove"/>
				    	</html:button>
      			</td>
      			<td class="table-text" valign="top">
      				<label for="<%=selectedRemove%>" class="hidden" title="<bean:message key="routing.rules.selected.filters.text"/>">
				    	<bean:message key="routing.rules.selected.filters.name"/>
				    </label>
        			<html:select multiple="true" size="8" property="selectedRemove" name="<%=formBean%>" styleId="<%=selectedRemove%>">
		          		<logic:iterate id="dropDownItem" name="<%=formBean%>" property="targetList">
		 		  		<% String value = ((String)dropDownItem).trim(); %>
				    	<html:option value="<%=value%>"><%=value%></html:option>
				  		</logic:iterate>
		          		<html:option value=""><%=charLines%></html:option>
        			</html:select>
      			</td>	
      		</table>
      	 </div>
    </tr>
  </table>
</fieldset>

 <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation"> 
    <tr valign="top" >
      <td class="table-text" nowrap valign="top">  
	    
		   <% 	String selectedRoutingPolicy = "selectedRoutingPolicy";
		   		if(refId.equals("") ){ 
		   			selectedRoutingPolicy = "default"	+ selectedRoutingPolicy;
		   		}
		   		String selectedRoutingPolicyId = selectedRoutingPolicy + refId;
		   %>
		   		
		      		<label for="<%=selectedRoutingPolicyId %>" title="<bean:message key="select.routing.policy"/>">
			 		  <bean:message key="select.routing.policy"/>
			   		</label>
				    <br>   
			    	<html:select property="<%=selectedRoutingPolicy %>" name="<%=formBean%>" size="1" styleId="<%=selectedRoutingPolicyId %>">
				    <logic:iterate id="dropDownItem" name="<%=formBean%>" property="routingPolices">
			 		  	<% 	String value = ((String)dropDownItem).trim(); 
			 		  	   	String key = (String)polKeyArr[polKeyIndex];
			 		  	   	polKeyIndex++;
			 		  	%>
					<html:option value="<%=value%>" key="<%=key%>" />
					</logic:iterate>
					</html:select>  
   	  </td>
    </tr>
 </table>

</div>

<div id="rejectDiv<%=refId%>" style="display:<%=rejectEdit%>" >
  <table border="0" cellpadding="0" cellspacing="0" width="100%" summary="SIP Routing Error Message" >
    <tr>
     <tiles:insert page="/com.ibm.ws.console.xdcore/textFieldLayout.jsp" flush="false">
       <tiles:put name="property" value="<%=rejectCode%>" />
       <tiles:put name="isReadOnly" value="no" />
       <tiles:put name="isRequired" value="yes" />
       <tiles:put name="label" value="siprules.routing.policy.rejectcode" />
       <tiles:put name="desc" value="siprules.routing.policy.rejectcode.desc" />
       <tiles:put name="size" value="30" />
       <tiles:put name="units" value=""/>
       <tiles:put name="bean" value="<%=formBean%>" />
       <tiles:put name="propId" value="<%=rejectCodeId %>" />
     </tiles:insert>
    </tr>
  </table>
</div>


</body>
