<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
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
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.core.form.RuleDetailForm"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<!-- If using collection layout this must be passed into this layout. -->
<tiles:useAttribute name="refId" classname="java.lang.String" />

<!-- If using collection layout this must be passed into this layout. -->
<tiles:useAttribute name="rowindex" classname="java.lang.String" />

<tiles:useAttribute name="ruleDetailForm" classname="java.lang.String" />

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

<%
	RuleDetailForm detailForm = (RuleDetailForm)request.getSession().getAttribute(actionForm+"Rule"+refId);
	if (detailForm != null) {
		pageContext.setAttribute("detailForm",detailForm); %>
		<bean:define id="actionForm" value="detailForm" />
<%  } %>


<%
   String[] actionList = {"permit", "permit sticky", "redirect", "reject"};
   String displayField = "";
   String labelkey = "rule.action.matchrule."+template;
   String descriptionkey = labelkey+".desc"; 
   
   if (actionItem0.startsWith("default")) {
	   //Since this is the default action we need to tweak the label.
	   labelkey = "default."+labelkey;
   }
%>
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
		 <% if (template.equals("service")) { %>
           <tiles:insert page="/com.ibm.ws.console.xdcore/selectDynamicLayout.jsp" flush="false">
	         <tiles:put name="formBean" value="<%=actionForm%>" />
       	     <tiles:put name="label" value="<%=labelkey%>" />
       	     <tiles:put name="desc" value="<%=descriptionkey%>" />
       	     <tiles:put name="property" value="<%=actionItem0%>" />
       	     <tiles:put name="listProperty" value="<%=actionListItem0%>" />
       	   </tiles:insert>
       	 
       	  <% } else if (template.equals("service.bizgrid")) { %>
		   <tiles:insert page="/com.ibm.ws.console.gridclassrules/comboBoxLayout.jsp" flush="false">
	         <tiles:put name="formBean" value="<%=actionForm%>" />
       	     <tiles:put name="label" value="<%=labelkey%>" />
       	     <tiles:put name="desc" value="<%=descriptionkey%>" />
       	     <tiles:put name="property" value="<%=actionItem0%>" />
       	     <tiles:put name="listProperty" value="<%=actionListItem0%>" />
       	     <tiles:put name="rowindex" value="<%=rowindex%>" />
    		 <tiles:put name="refId" value="<%=refId%>" />
       	   </tiles:insert>
       	 
		 <% } else if (template.equals("sip.rules.routing")) { %>
		   <tiles:insert page="/com.ibm.ws.console.xdcore/routingRulesLayout.jsp" flush="false">
	         <tiles:put name="formBean" value="<%=actionForm%>" />
       	     <tiles:put name="label" value="<%=labelkey%>" />
       	     <tiles:put name="desc" value="<%=descriptionkey%>" />
       	     <tiles:put name="property" value="<%=actionItem0%>" />
       	     <tiles:put name="listProperty" value="<%=actionListItem0%>" />
       	     <tiles:put name="rowindex" value="<%=rowindex%>" />
    		 <tiles:put name="refId" value="<%=refId%>" />
    		 <tiles:put name="ruleDetailForm" value="<%=ruleDetailForm%>" />
       	   </tiles:insert>
		 	 
		 <% } else if (template.equals("routing")) {
		   String selectionChanged = "initVars(this);" +"showSection(" + "this.value" +",'" + refId + "')";
		 %>

           <label class="<%=actionItem0%>" for="listcheckbox" title="<bean:message key="<%=descriptionkey%>"/>">
             <bean:message key="<%=labelkey%>"/>
           </label>
           		 
           <html:select property="<%=actionItem0%>" size="1" styleId="<%=actionItem0%>" onchange="<%=selectionChanged%>">
             <logic:iterate id="dropDownItem" name="<%=actionForm%>" property="<%=actionListItem0%>">
             <% String value = (String) dropDownItem;
			    value=value.trim();
                if (!value.equals("")) {  %>
             	  <html:option value="<%=value%>"><%=value%></html:option>
			    <% } else { %>
                  <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
             <% } %>
             </logic:iterate>
           </html:select>
           <br />
           
           <bean:define id="actionType" name="listcheckbox" property="<%=actionItem0%>" type="java.lang.String"/>
           <% 
            String docId = actionList[0]  +refId;
            if (ruleActionContext.equals("odr.routing")) { 
				if ( (actionType == null) || (actionType.equals("")) ) {
					// The default selected type will be permit so display this field too.
					displayField = "display:block";
				//} else if ( actionType.equalsIgnoreCase(permitLabel) || actionType.equalsIgnoreCase(permitStickyLabel) ) {
				//	displayField = "display:block";
				} else {
					displayField = "display:none";
				}              
            } %>
           									
		   <%
		      //rule.action.matchrule.appedition.routing OR rule.action.matchrule.gsc.odr.routing
		      //Should be select edition or select gsc
		      labelkey = "rule.action.matchrule."+ruleActionContext;
		      descriptionkey = labelkey+".desc";
		   %>
		   		
		   <div id="<%=docId%>" style="<%=displayField%>">									
             <label for="<%=actionItem1%>" title="<bean:message key="<%=descriptionkey%>"/>">
               <bean:message key="<%=labelkey%>"/>
             </label>
           		 
             <html:select property="<%=actionItem1%>" size="1" styleId="<%=actionItem1%>">
               <logic:iterate id="dropDownItem" name="<%=actionForm%>" property="<%=actionListItem1%>">
               <% String value = (String) dropDownItem;
			      value=value.trim();
                  if (!value.equals("")) {  %>
             	    <html:option value="<%=value%>"><%=value%></html:option>
			      <% } else { %>
                    <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
               <% } %>
               </logic:iterate>
             </html:select>							
		   </div>
			<% 
			   // redirect to URL
			   docId = actionList[2] +refId;
			   //if ( (actionType != null) && (actionType.equalsIgnoreCase(redirectLabel)) ) {
				//	displayField = "display:block";
			   //} else {
				 //   displayField = "display:none";
			   //}
			%>
			<div id="<%=docId%>" style="<%=displayField%>">
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                <tiles:put name="property" value="redirectURL" />
              	<tiles:put name="isReadOnly" value="no" />
       	        <tiles:put name="isRequired" value="yes" />
            	<tiles:put name="label" value="rule.action.matchrule.redirect.url" />
            	<tiles:put name="desc" value="rule.action.matchrule.redirect.url.desc" />
            	<tiles:put name="size" value="30" />
                <tiles:put name="bean" value="formBean" />
              </tiles:insert>
			</div>
			<% 
               //reject with return code
			   docId = actionList[3] +refId;
			   //if ( (actionType != null) && (actionType.equalsIgnoreCase(redirectLabel)) ) {
				//	displayField = "display:block";
			   //} else {
				//    displayField = "display:none";
			   //}
			%>
			<div id="<%=docId%>" style="<%=displayField%>">
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                <tiles:put name="property" value="rejectCode" />
              	<tiles:put name="isReadOnly" value="no" />
       	        <tiles:put name="isRequired" value="yes" />
            	<tiles:put name="label" value="rule.action.matchrule.reject.returncode" />
            	<tiles:put name="desc" value="rule.action.matchrule.reject.returncode.desc" />
            	<tiles:put name="size" value="30" />
                <tiles:put name="bean" value="formBean" />
              </tiles:insert>
			</div>					
		 <% } //END ruleActionContext.equals("odr.routing"))%>
         </td>
	  </tr>		
	</tbody>
</table>
