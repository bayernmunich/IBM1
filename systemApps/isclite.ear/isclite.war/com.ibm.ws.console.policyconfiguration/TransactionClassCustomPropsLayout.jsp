<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.TransactionClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="formFocus" classname="java.lang.String" />


<script language="JavaScript">
var changing = false;
var selectedAvailableNodes; // array of currently selected available nodes 
var selectedCurrentNodes; // array of currently selected member nodes 
var availNodes;
var currentNodes;
var availField;
var outputField;
var inited = false;
var originalAvailField;
var originalOutputField;
var filterValue;
var contextRootField;
var descField;

//removes leading and trailing whitespace from a string
function trimString(string){
    var s = string.replace(/^\s+/g, ""); //remove leading whitespace
    return s.replace(/\s+$/g, ""); //remove leading whitespace;
}
//this function resets the membership form to the initial state (before any changes were made by the user)
function resetForm(){
	window.location = "/ibm/console/TransactionClassDetail.do?&ResetClicked=true" 
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function initVars(formElem, firstMembershipFormElemIndex){
	if (inited){
		return inited;
	}
	
	var theform = formElem.form;
	
	changing = false;
	selectedAvailableNodes = new Array(); //associative array of currently selected available nodes (keyed on Node Name)
	selectedCurrentNodes = new Array(); //associative array of currently selected member nodes (keyed on Node Name)
	
	availNodes = theform.elements[2 + firstMembershipFormElemIndex]; //leave 0 in case firstMembershipFormElemIndex is a string
	currentNodes = theform.elements[5 + firstMembershipFormElemIndex];
	filterField = theform.elements[6 + firstMembershipFormElemIndex];
	appField = theform.elements[0+ firstMembershipFormElemIndex];
	modField = theform.elements[1+ firstMembershipFormElemIndex];
	contextRootField =	theform.elements[8 + firstMembershipFormElemIndex];
	descField = theform.elements[1];	
	inited=true;
	return inited;
}


function appNameChange() {
	//When the app name changes we need to reset the WebModName lists
	var selectedApp = appField.value;
	var newDesc = descField.value;
	window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&AppChanged=true" + "&desc=" + encodeURI(newDesc)
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}
	
function webModNameChange() {
	var selectedMod = modField.value;
	var selectedApp = appField.value;
	var newDesc = descField.value;
	window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&ModChanged=true" + "&desc=" + encodeURI(newDesc)   
       + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
}

function addClicked(optionsToAdd) {
	if (optionsToAdd.length > 0) {
		var selectedMod = modField.value;
		var selectedApp = appField.value;
		var contextRoot = contextRootField.value;
		var newDesc = descField.value;
		
		var optionsToAddString = "";
		for(var x = 0; x < optionsToAdd.length; x++){
			if (optionsToAdd[x].value != "-------------------------------------------")
				optionsToAddString = optionsToAddString + ";;" + contextRoot + optionsToAdd[x].value;
		}
		if (optionsToAddString.length != 0) {
			optionsToAddString=optionsToAddString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddClicked=true" + "&uriStringToAdd=" + encodeURI(optionsToAddString) + "&desc=" + encodeURI(newDesc)  
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
		}
	}
}

function removeClicked(optionsToRemove) {
	if (optionsToRemove.length > 0) {
		var selectedMod = modField.value;
		var selectedApp = appField.value;
		var contextRoot = contextRootField.value;
		var optionsToRemoveString = "";
		var newDesc = descField.value;
		
		for(var x = 0; x < optionsToRemove.length; x++){
			if (optionsToRemove[x].value != "-------------------------------------------")
				optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
		}
		if (optionsToRemoveString.length != 0) {
			optionsToRemoveString=optionsToRemoveString.substring(2); //take off the first 2 ";;"
			window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&RemoveClicked=true" + "&uriStringToRemove=" + encodeURI(optionsToRemoveString) + "&desc=" + encodeURI(newDesc)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
		}
	}
}

function addFilterClicked() {
	var selectedMod = modField.value;
	var selectedApp = appField.value;
	var contextRoot = contextRootField.value;
	var filterValueString = trimString(filterField.value);
	var newDesc = descField.value;
	
	
	if (filterValueString.length > 0) {
		if (filterValueString.charAt(0) != "/")
			filterValueString = "/" + filterValueString;
		var newFilterValue = contextRoot + filterValueString;
		window.location = encodeURI("/ibm/console/TransactionClassDetail.do?appName=" + encodeURI(selectedApp) + "&mod=" + encodeURI(selectedMod) + "&AddFilter=true" + "&newFilterValue=" + newFilterValue + "&desc=" + encodeURI(newDesc)  
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>";
	}
}


/*
This function sets the global selectedAvailableNodes array to correspond with the selected 
objects in the box represented by "nodeList" (either currentNodes or availNodes)
*/
function setSelectedNodes(nodeList, selectObject){
	changing = true;
	empty(nodeList);
	var numSelected = 0;	
	var itemSelected;
	if (selectObject.selectedIndex != -1){
		var index=0;
		var str;
		for (var x = 0; x < selectObject.options.length; x++) {
			if (selectObject.options[x].selected){				
				nodeList[index++] = selectObject.options[x]; //copy a reference to this field into our list of selected Options
				itemSelected = selectObject.options[x].value;
				numSelected = numSelected + 1;
			}				
		}		
	}	
	var tempString="";
	first = true;
	for (var y = 0; y < nodeList.length; y++){
		if (!first){
			tempString += "!";			
		}
		tempString += nodeList[y].value;
		first = false;
	}	

	changing = false;
}


//this function removes all elements from the array "nodeList"
function empty(nodeList){
	for (x=0; x<nodeList.length; x++){
		nodeList.pop();
	}
}


function submitIt(){
	while (changing){}
	changing=true;
	//document.forms[0].submit();
}


</script>


<%  String renderReadOnlyView = "no";
if( (readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes")) ) {
  renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
    renderReadOnlyView = "yes";
    if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
    }
    else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
    }
}
%>

<%  
		Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
        String numberOfColumns = "3";
        if (descriptionsOn.booleanValue() == false)
        	numberOfColumns = "2";	
        WASDirectory directory = new WASDirectory();
%>

<%
   String fieldLevelHelpTopic = "";
   String fieldLevelHelpAttribute = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formType.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formType.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
   }
   fieldLevelHelpTopic = objectType+".detail.";
   String topicKey = fieldLevelHelpTopic;
%>

<% try { %>

<a name="general"></a>

<% if (renderReadOnlyView.equalsIgnoreCase("yes")) { %>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
      
      <table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="Properties Table" >
        
        <tbody>
        <tr valign="top">
          <th colspan="<%= numberOfColumns %>" class="column-head" scope="rowgroup">
            <a name="general"></a><bean:message key="config.general.properties"/></th>
        </tr>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
  
<%      
		fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
        //this code gets productId from icon attribute of PropertyItem 
        //and checks if product is installed 
        // If product  is installed , then make row visible
        String productId = item.getIcon();
        boolean productEnabled = true;
        if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
            productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }

        if (productEnabled) { 
%>

           
        <tr valign="top">
            <% if (item.getType().equalsIgnoreCase("Custom")) { %>
                    <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="size" value="30" />
                    </tiles:insert>

            <% } else if (item.getType().equalsIgnoreCase("jsp")) { %>
                    <tiles:insert page="<%=item.getUnits()%>" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="size" value="30" />
                    </tiles:insert>

                <% } else if (item.getType().equalsIgnoreCase("Select")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
                    Vector descVector = new Vector();
                    while(st1.hasMoreTokens()) 
                    {
                        String enumDesc = st1.nextToken();
                        descVector.addElement(enumDesc);
                    }
                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
                    Vector valueVector = new Vector();
                    while(st.hasMoreTokens()) 
                    {
                        String str = st.nextToken();
                        valueVector.addElement(str);
                    }
        
                    session.setAttribute("descVector", descVector);
                    session.setAttribute("valueVector", valueVector);
                    
                    %>
                    
                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/submitLayoutWithOnChange.jsp"  flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="valueVector" value="<%=valueVector%>" />
                        <tiles:put name="descVector" value="<%=descVector%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="onChange" value="myOnChange()" />
                    </tiles:insert>
                    
                    <% } else if (item.getType().equalsIgnoreCase("DynamicSelect")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                    Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

                    session.setAttribute("descVector", descriptVector);
                    session.setAttribute("valueVector", valVector);
                    %>

                    <tiles:insert page="/secure/layouts/dynamicSelectionLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
        		    </tiles:insert>
                <% } else if (item.getType().equalsIgnoreCase("Password")) { %>
                
          <td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
          <td class="table-text" valign="top">******</td>
          
                <% } else { %>

          <td class="table-text" scope="row" nowrap><label  for="{attributeName}"><bean:message key="<%= item.getLabel() %>"/></label></td>
          <td class="table-text" valign="top"><bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/></td>
          
          <% } %>
          
		  <% if (descriptionsOn.booleanValue() == true) { %>  

                  <td class="table-text" valign="top">

                  <ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
                  <bean:message key="<%= item.getDescription() %>"/>

                  </td>
          <% } %>  

        </tr>
        
        <% }%>  
        
        </logic:iterate>
        
        <%
        TransactionClassDetailForm testForm = (TransactionClassDetailForm)session.getAttribute("TransactionClassDetailForm");
		String tcName = testForm.getRefId();
		ArrayList selectedNodesBean = (ArrayList)testForm.getSelectedURIs();

		//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
		if (!selectedNodesBean.contains("-------------------------------------------"))
			selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");

		pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
		%>


          <!-- INSERT THE MEMBERSHIP ROW HERE -->
		<% int numMembershipColumns = Integer.parseInt(numberOfColumns); 
           if (numMembershipColumns > 0) 
           		numMembershipColumns--; 
	    	fieldLevelHelpTopic = topicKey + "membership"; 		
		%>      

        <tr>        
        <td class="table-text"  scope="row" valign="top" nowrap>
            <label for="membership"> <bean:message key="transactionclass.membership" /></label>                                
        </td>

		<td class="table-text" nowrap valign="top" colspan="<%= numMembershipColumns %>">
		<% if (descriptionsOn.booleanValue() == true) { %>  
          	<ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
           	<bean:message key="transactionclass.membership.description"/>
			<br>
		<% } %>  
		                                 

		<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">				
						
		<tr>
			<td class="table-text">
				<table>
					<tr>
						<td valign="top"> <span class="table-text"><center>
							<bean:message key="transactionclass.details.membersOf" arg0="<%=tcName%>" />
							</center></span> 
						</td>
					</tr>
					<tr>
						<td rowspan="2" valign="top"  class="table-text">
							<html:select multiple="true" size="12" property="notUsed">
								<html:options name="selectedNodesBean" />
							</html:select>
						</td>
					</td>
				</tr>
			</table>
	</td>
        </tr>
       </table>       
        
        <tr>
          <th class="button-section" colspan="<%= numberOfColumns %>">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons" id="navigation">
          </th>
        </tr>
        
        </tbody>
        
      </table>

</html:form>

<% } %>

<% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>
<%int fields = 0; %>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" >
<html:hidden property="action"/>
    <table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="Properties Table" >
        <tbody>
        <tr valign="top">
            <th colspan="<%= numberOfColumns %>" class="column-head" scope="rowgroup">
            <bean:message key="config.general.properties"/></th>
        </tr>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
            
<%  
        fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;

        //this code gets productId from icon attribute of PropertyItem 
        //and checks if product is installed 
        // If product  is installed , then make row visible
        String productId = item.getIcon();
        boolean productEnabled = true;
        if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
            productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }

        if (productEnabled) {
%>

        <tr valign="top">    
 
                <% 
                String isRequired = item.getRequired(); 
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
                %>
 
                 <% if (strType.equalsIgnoreCase("Text")) {
                 
                 		if (item.getAttribute().equalsIgnoreCase("goalValue")) { 
		                    try {
		                        session.removeAttribute("valueVector");
		                        session.removeAttribute("descVector");
		                    }
		                    catch (Exception e) {
		                    }
		                    
		                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
		                    Vector descVector = new Vector();
		                    while(st1.hasMoreTokens()) 
		                    {
		                        String enumDesc = st1.nextToken();
		                        descVector.addElement(enumDesc);
		                    }
		                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
		                    Vector valueVector = new Vector();
		                    while(st.hasMoreTokens()) 
		                    {
		                        String str = st.nextToken();
		                        valueVector.addElement(str);
		                    }
		                    session.setAttribute("descVector", descVector);
		                    session.setAttribute("valueVector", valueVector);
		                    
		                  %>
			                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/goalValueTextFieldLayout.jsp" flush="false">
			                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
			                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
			                        <tiles:put name="isRequired" value="<%=isRequired%>" />
			                        <tiles:put name="label" value="<%=item.getLabel()%>" />
			                        <tiles:put name="size" value="15" />
			                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
			                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
			                        <tiles:put name="bean" value="<%=formName%>" />
			                        <tiles:put name="valueVector" value="<%=valueVector%>" />
		                        	<tiles:put name="descVector" value="<%=descVector%>" />
			                    </tiles:insert>             		
		               	<% 
       	                fields++; 
       	                } 
		               	
		               	else if (item.getAttribute().equalsIgnoreCase("goalPercent")) { %>
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="3" />
		                        <tiles:put name="units" value="percent.sign"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=formName%>" />
		                    </tiles:insert>
		                <% 
		                fields++; 
		                } 
		                else  { %>
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="30" />
		                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=formName%>" />
		                    </tiles:insert>
		                <% 
		                fields++;
		                }
		           } %>
		                
    
                <% if (strType.equalsIgnoreCase("TextArea")) { %>
                    <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="5" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <%  fields++; } %>
        
                <% if (strType.equalsIgnoreCase("checkbox")) { %>
                    <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <%  fields++; } %>
        
                <% if (strType.equalsIgnoreCase("Password")) { %>
                    <tiles:insert page="/secure/layouts/passwordLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <%  fields++; } %>
                
                <% if (strType.equalsIgnoreCase("Custom")) { %>
                    <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="readOnly" value="false" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                    </tiles:insert>
                <%  fields++; } %>
                
                <% if (strType.equalsIgnoreCase("jsp")) { %>
                    <tiles:insert page="<%=item.getUnits()%>" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="readOnly" value="false" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                    </tiles:insert>
                <%  fields++; } %>
        
                <% if (strType.equalsIgnoreCase("Select")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
                    Vector descVector = new Vector();
                    while(st1.hasMoreTokens()) 
                    {
                        String enumDesc = st1.nextToken();
                        descVector.addElement(enumDesc);
                    }
                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
                    Vector valueVector = new Vector();
                    while(st.hasMoreTokens()) 
                    {
                        String str = st.nextToken();
                        valueVector.addElement(str);
                    }
        
                    session.setAttribute("descVector", descVector);
                    session.setAttribute("valueVector", valueVector);
                    %>
                    
                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/submitLayoutWithOnChange.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="onChange" value="myOnChange()" />
        		    </tiles:insert>
                <% 
                 fields++; } %>
                
                <% if (strType.equalsIgnoreCase("DynamicSelect")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                    Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

                    session.setAttribute("descVector", descriptVector);
                    session.setAttribute("valueVector", valVector);
                    %>

                    <tiles:insert page="/secure/layouts/dynamicSelectionLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                        <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
        		    </tiles:insert>
                <%  fields++; } %>
                

                <% if (strType.equalsIgnoreCase("Radio")) { 
                    
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
                    Vector descVector = new Vector();
                    while(st1.hasMoreTokens()) 
                    {
                        String enumDesc = st1.nextToken();
                        descVector.addElement(enumDesc);
                    }
                    StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
                    Vector valueVector = new Vector();
                    while(st.hasMoreTokens()) 
                    {
                        String str = st.nextToken();
                        valueVector.addElement(str);
                    }
        
                    session.setAttribute("descVector", descVector);
                    session.setAttribute("valueVector", valueVector);
                    %>
                    
                    <tiles:insert page="/secure/layouts/radioButtonLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
		              </tiles:insert>
                <% fields++; } %>

<% if (descriptionsOn.booleanValue() == true) { %>  

        <td class="table-text" valign="top" width="33%">

           <ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
           <bean:message key="<%=item.getDescription()%>"/>

        </td>

<% } %>  

<% } %>  

        </tr>

        </logic:iterate>

<%
TransactionClassDetailForm testForm = (TransactionClassDetailForm)session.getAttribute("TransactionClassDetailForm");

ArrayList selectedNodesBean = (ArrayList)testForm.getSelectedURIs();
Collection appNames = testForm.getAppNamesToShow();
Collection webModNames = testForm.getWebModNamesToShow();
ArrayList uriNames = (ArrayList) testForm.getUrisToShow();

//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
if (!selectedNodesBean.contains("-------------------------------------------"))
	selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");
if (!uriNames.contains("-------------------------------------------"))
	uriNames.add(uriNames.size(),"-------------------------------------------");

String selectedApp = testForm.getSelectedApp();
String selectedMod = testForm.getSelectedMod();
String contextRoot = testForm.getContextRoot();
String tcName = testForm.getRefId();

pageContext.setAttribute("availableNodesBean", uriNames);
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
pageContext.setAttribute("appNamesBean", appNames);
pageContext.setAttribute("webModNamesBean", webModNames);
pageContext.setAttribute("contextRoot", contextRoot);


String availNodesSelectChange = "initVars(this, " + fields + "); setSelectedNodes(selectedAvailableNodes, availNodes)";
String currNodesSelectChange = "initVars(this, " + fields + ");setSelectedNodes(selectedCurrentNodes, currentNodes)";
String removeButtonClicked = "initVars(this, " + fields + ");removeClicked(selectedCurrentNodes)";
String addButtonClicked = "initVars(this, " + fields + ");addClicked(selectedAvailableNodes)";
String addFilterButtonClicked = "initVars(this, " + fields + ");addFilterClicked()";
String appDropDownChanged = "initVars(this, " + fields + ");appNameChange()";
String modDropDownChanged = "initVars(this, " + fields + ");webModNameChange()";


%>


          <!-- INSERT THE MEMBERSHIP ROW HERE -->
		<% int numMembershipColumns = Integer.parseInt(numberOfColumns); 
           if (numMembershipColumns > 0) 
           		numMembershipColumns--; 
	    	fieldLevelHelpTopic = topicKey + "membership"; 		
		%>      

        <tr>        
        <td class="table-text"  scope="row" valign="top" nowrap>
            <label for="membership"> <bean:message key="transactionclass.membership" /></label>                                
        </td>

		<td class="table-text" nowrap valign="top" colspan="<%= numMembershipColumns %>">
		<% if (descriptionsOn.booleanValue() == true) { %>  
          	<ibmcommon:info image="help.additional.information.image.align" topic="<%=fieldLevelHelpTopic%>"/>
           	<bean:message key="transactionclass.membership.description"/>
			<br>
		<% } %>  
		                                 

		<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">				
						
		<tr>
			<td class="table-text">
				<table>
					<tr>
						<td class="table-text">
							<bean:message key="policy.App" /> 
							&nbsp;&nbsp;
							<html:select size="1" value="<%=selectedApp%>" property="notUsed" 
										 onchange="<%=appDropDownChanged%>">
								<html:options name="appNamesBean"/>
							</html:select>
							&nbsp;&nbsp; 
							<bean:message key="policy.Mod" /> &nbsp;&nbsp;
							<html:select size="1" value="<%=selectedMod%>" property="notUsed" 
										 onchange="<%=modDropDownChanged%>">
								<html:options name="webModNamesBean" />
							</html:select>
						</td>
					</tr>
				</table>
				<br>
				<table>
					<tr>
						<td valign="top"><span class="table-text"><center>
							<bean:message key="transactionclass.details.availableURIs" arg0="<%=selectedApp%>" arg1="<%=selectedMod%>" /> 
							</center></span>
						</td>
						<td>&nbsp;</td>
						<td valign="top"> <span class="table-text"><center>
							<bean:message key="transactionclass.details.membersOf" arg0="<%=tcName%>" />
							</center></span> 
						</td>
					</tr>
					<tr>
						<td valign="top"  class="table-text" >
							<html:select multiple="true" size="8" property="notUsed" 
										 onchange="<%=availNodesSelectChange%>">
								<html:options name="availableNodesBean" />
							</html:select>
						</td>	
						<td align="center" valign="middle"  width="160px">	
							<html:button styleClass="buttons" property="notUsed" 
										 onclick="<%=addButtonClicked%>">
								<bean:message key="transactionclass.button.add" /> 
							</html:button> 
						<br>
						<br>
							<html:button styleClass="buttons" property="notUsed"
										 onclick="<%=removeButtonClicked%>">
								 <bean:message key="transactionclass.button.remove" />
							</html:button>
						</td>
						<td rowspan="2" valign="top"  class="table-text">
							<html:select multiple="true" size="12" property="notUsed" 
										 onchange="<%=currNodesSelectChange%>">
								<html:options name="selectedNodesBean" />
							</html:select>
						</td>
					</td>
				</tr>

				<tr>
					<td valign="bottom">
						<span class="table-text"><bean:message key="filterFieldLabel" /><br>
            			<html:text property="filterField" style="width:200px" styleId="filterField" disabled="false" /></span>
            		</td>
            		<td align="center" valign="bottom"><br>
            			<html:button styleClass="buttons" property="notUsed"
									 onclick="<%=addFilterButtonClicked%>">
							<bean:message key="transactionclass.button.addFilter"  />
            			</html:button>   
 					</td>
				</tr>
			</table>
	</td>
        </tr>
        
        <% String initVars = "initVars(this, " + fields + ");";
           String applyClick = initVars + " submitIt()";
           String resetClick = initVars + " resetForm()";
        %>          
                        
        <tr>		<html:hidden property="currentContextRoot" 	value="<%=contextRoot%>"/>
        
              <td class="button-section" colspan="<%= numberOfColumns %>">
                <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons" id="navigation" onclick="<%=applyClick%>">
                <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons" id="navigation" onclick="<%=applyClick%>">
                <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons" id="navigation" onclick="<%=resetClick%>">
                <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons" id="navigation">
              </td>
        </tr>
                
        </tbody>
    </table>

</html:form>

<%}
} 
catch (Exception e) {System.out.println(e.toString());}%>
