<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>

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

<!-- helpfile.txt key for rule quick help -->
<tiles:useAttribute name="quickHelpTopic" classname="java.lang.String" ignore="true"/>

<!-- Webui plugin id -->
<tiles:useAttribute name="quickPluginId" classname="java.lang.String" ignore="true" />

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>

<!-- "true" if you do not want the rule action displaying. -->
<tiles:useAttribute name="hideRuleAction" classname="java.lang.String" />

<!-- "true" value will not display the actions associated with the rules.
   Known uses:
-->
<tiles:useAttribute name="hideRuleAction" classname="java.lang.String" />

<!-- Form attribute used to set and get the rule. -->
<tiles:useAttribute name="rule" classname="java.lang.String" />

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

<!-- [OPTIONAL] Fieldset around rule text and description -->
<tiles:useAttribute name="ruleCaption" ignore="true" classname="java.lang.String" />

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes" classname="java.lang.String"/>
<tiles:useAttribute name="sortIconLocation" classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth" classname="java.lang.String"/>
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<tiles:useAttribute name="collectionList" classname="java.util.List" />
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List" />
<tiles:useAttribute name="parent" classname="java.lang.String"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="detailFormType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="ruleDetailForm" classname="java.lang.String" ignore="true" />

<script language="JavaScript">
function setRowIndex(rowindex) {
    document.getElementById("rowindex").value = rowindex;
}
function setCustomRowIndex(rowindex) {
    document.getElementById("rowindex").value = rowindex;
}

</script>

<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
	String contextType=(String)request.getAttribute("contextType");
	String cellname = null;
	String nodename = null;
	String token = null;
	java.util.Properties props= null;

	java.util.ArrayList collectionList_ext =  new java.util.ArrayList();
	for(int i=0;i<collectionList.size(); i++)
        collectionList_ext.add(collectionList.get(i));

	IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

	String extensionId = "com.ibm.websphere.wsc.collectionItem";
    IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

    IExtension[] extensions = registry.getExtensions(extensionId, ic);

	String extensionId_preferences = "com.ibm.websphere.wsc.preferences";
	IConfigurationElementSelector ic_preferences = new ConfigurationElementSelector(contextType, extensionId_preferences);

	IExtension[] extensions_preferences = registry.getExtensions(extensionId_preferences, ic);

    if((extensions!=null && extensions.length>0) ){
       //if(contextId!=null && contextId!="nocontext"){
	   //props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
	   //    }
       props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);
    }

    if(extensions!=null && extensions.length>0) {
	    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props);
	}

	pageContext.setAttribute("collectionList_ext",collectionList_ext);

	String actionHandler = actionForm.substring(0, actionForm.indexOf("Form"));	
	
	if (ruleCaption == null) {
		ruleCaption = "rule.rules";
	}
	
	String ruleCaptionDescription = ruleCaption+".desc";
		
%>

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>


<TR><TD>

<body class="content" class="table-row">
	<table><tr><td class="table-text">
    
       <bean:message key="<%=ruleCaption%>"/>
    
    </td></tr></table>

    <%@ include file="/secure/layouts/filterSetup.jspf" %>
    <tiles:insert definition="<%=buttons%>" flush="true"/>
    <html:hidden property="rowindex" styleId="rowindex" value="" />       
    <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
	  <!-- <%@ include file="/secure/layouts/tableControlsLayout.jspf" %> -->
      <tr>
<%    if (showCheckBoxes.equals ("true")) { %>
       <th nowrap valign="top" class="column-head-name" scope="col" id="selectCell" width="1%">
        <bean:message key="select.text"/>
       </th>
<%    } %>
       <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
<%
        columnField = (String)cellItem.getColumnField();
        String tmpName = cellItem.getTooltip();
        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
%>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="<%=columnField%>">
         <%=columnName%>
        </th>
         <% chkcounter = chkcounter + 1; %>
       </logic:iterate>
      </tr>

	  <!-- <%@ include file="/secure/layouts/filterControlsLayout.jspf" %> -->
<%
		   int prioritycounter = 1;
		   rowindex = 0;
		   String editClickString = "";
%>

      <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="viewContents">
       <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
       <tr class="table-row">
		<input type="hidden" name="formAction" value="<%=actionHandler%>"/>
		<html:hidden name="listcheckbox" property="refId"/>
        <% if (showCheckBoxes.equals("true")) { %>
           <td valign="top"  width="1%" class="collection-table-text" headers="selectCell">
            <label class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
             <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>"  onclick="checkChecks(this.form)" onkeypress="checkChecks(this.form)" styleId="<%=refId%>"/>
            </label>
           </td>
        <% } else { %>
           <td valign="top"  width="1%" class="collection-table-text" headers="selectCell">&nbsp;</td>
        <% } %>

           <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
           <%
               columnField = (String)cellItem.getColumnField();
               String colwidth = "1%";
      		   if (columnField.equalsIgnoreCase("rule")) {
                   colwidth = "50%";
			   }                        
           %>
              
            <TD VALIGN="top" name="listcheckbox" class="collection-table-text" width="<%=colwidth%>" headers="<%=columnField%>">
             <%  if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0) { %>
                     <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop" alt="" title=""></IMG>&nbsp;
             <%  } else if (columnField.equalsIgnoreCase("priority")) { %>
			         <%=prioritycounter%>
			 <%  } else if (columnField.equalsIgnoreCase("rule")) { %>
			 	     <html:errors property="<%=refId%>"/>
					 <bean:define id="matchExpression" name="listcheckbox" property="matchExpression" type="java.lang.String"/>
		     <% 
				     String handShow = "none";
					 String quickEdit = "block";
					 if (matchExpression.equals("")) {
					     handShow = "block";
					     quickEdit = "none";
					 }
						  
					 String ri = rowindex+"";
             		 request.getSession().setAttribute("Rule_"+refId,listcheckbox);

             		 //System.out.println("ruleLayout:line 273: actionForm: "+actionForm);

             %>
         		<tiles:insert page="/com.ibm.ws.console.gridclassrules/ruleEditLayout.jsp" flush="false">
                   <tiles:put name="quickHelpTopic" value="<%=quickHelpTopic%>" />
                   <tiles:put name="quickPluginId" value="<%=quickPluginId%>" />
			       <tiles:put name="actionForm" value="<%=actionForm%>" />
	    		   <tiles:put name="detailFormType" value="<%=detailFormType%>" />
			       <tiles:put name="label" value="rule.edit.matchrule.label" />
	    		   <tiles:put name="desc" value="rule.edit.matchrule.label.desc" />
			       <tiles:put name="hideValidate" value="false" />
			       <tiles:put name="hideRuleAction" value="false" />
		       	   <tiles:put name="rule" value="<%=rule%>" />
		       	   <tiles:put name="rowindex" value="<%=ri%>" />
		       	   <tiles:put name="refId" value="<%=refId%>" />
		       	   <tiles:put name="ruleActionContext" value="<%=ruleActionContext%>" />
		       	   <tiles:put name="template" value="<%=template%>" />
		       	   <tiles:put name="actionItem0" value="<%=actionItem0%>" />
		       	   <tiles:put name="actionListItem0" value="<%=actionListItem0%>" />
		       	   <tiles:put name="actionItem1" value="<%=actionItem1%>" />
		       	   <tiles:put name="actionListItem1" value="<%=actionListItem1%>" />
		       	   <tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
		       	   <!--  tiles:put name="sipAction" value="sip" / -->
		       	 <!--   <tiles:put name="actionForm" value="<%=formName%>" /> -->
		       	 </tiles:insert>								
			<% } %>
           </td>
          </logic:iterate>
         </tr>
         <% 
		    prioritycounter = prioritycounter + 1;
		    rowindex = rowindex + 1;
		 %>
        </logic:iterate>

        <input type="hidden" name="collectionFormAction" value="<%=actionHandler%>"/>
	    <%
	        if (rowindex == 0) {
		       servletContext = (ServletContext)pageContext.getServletContext();
		       MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
		       String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
	           out.println("<tr class='table-row'><td colspan='3'>"+nonefound+"</td></tr>");
	        }
	    %>
       </table>
                
       <% String defaultaction = "default"+actionItem0; %>
       <% String ri = rowindex+"";%>
       <html:hidden property="refId" styleId="refId" value="" />
	   <tiles:insert page="/com.ibm.ws.console.gridclassrules/ruleActionLayout.jsp" flush="false">
		<tiles:put name="actionForm" value="<%=formName%>" />
		<tiles:put name="refId" value="" />
		<tiles:put name="rowindex" value="<%=ri%>" />
		<tiles:put name="ruleActionContext" value="<%=ruleActionContext%>" />
		<tiles:put name="template" value="<%=template%>" />
		<tiles:put name="actionItem0" value="<%=defaultaction%>" />
		<tiles:put name="actionListItem0" value="<%=actionListItem0%>" />
		<tiles:put name="actionItem1" value="<%=actionItem1%>" />
		<tiles:put name="actionListItem1" value="<%=actionListItem1%>" />
		<tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
	   </tiles:insert>
	
       <input type="hidden" name="collectionFormAction" value="<%=actionHandler%>"/>
</body>

<% } catch (Exception e) {e.printStackTrace(); } %>
</TD></TR>