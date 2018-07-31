<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2013 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator,com.ibm.ws.console.core.item.ActionSetItem,com.ibm.ws.security.core.SecurityContext,com.ibm.ws.console.core.item.MenuActionSetItem,org.apache.struts.util.MessageResources"%>

<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


<%@page import="com.ibm.ws.console.core.json.JSONArray"%>
<%@page import="com.ibm.ws.console.core.json.JSONObject"%>
<%@page import="com.ibm.ws.console.core.json.JSUtil"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.List"%>

<%@page import="com.ibm.ws.console.core.SecurityHelper"%>
<%@page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@page import="com.ibm.ws.console.core.Constants"%>
<%@page import="com.ibm.ws.console.core.form.ContextScopeForm"%>
<tiles:useAttribute name="buttonCount" classname="java.lang.String" />
<tiles:useAttribute name="definitionName" classname="java.lang.String" />
<tiles:useAttribute name="includeForm" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="desc" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="rolemap" classname="java.util.Map" ignore="true"/>
<tiles:useAttribute name="contextType" classname="java.lang.String" ignore="true"/>

<%
       String hiddenButtonId = "hiddenButton" + System.nanoTime();
       int count = 0;

       try {
              count = Integer.parseInt(buttonCount);
       }
       catch( java.lang.NumberFormatException ex){
              count = 8;
       }
%>

<%-- Layout component 
  Render a list of tiles in a vertical column
  @param : list List of names to insert 
  
<tiles:useAttribute id="list" name="actionList" classname="java.util.List" />
--%>  

<!-- gets all the action list items which matches with the contextType and 
     compatibilty criteria using plugin registry API -->

<%

List list = (List) session.getAttribute("actionList");
    MessageResources messages = (MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
    if(contextType == null || contextType.length() == 0) {
         contextType = (String)request.getAttribute("contextType");
    }
       String contextId = (String)request.getAttribute("contextId");
       String perspective = (String)request.getAttribute("perspective");
       String formAction = (String)request.getAttribute("formAction");
		//616543: Sanitize objects taken from the request. Remove double quotes before writing in the hidden input fields.
		// This prevents cross-site scripting attacks.
		if (contextType!=null){
			contextType=contextType.replaceAll("\"","");
		}
		if (contextId!=null){
			contextId=contextId.replaceAll("\"","");
		}
		if (perspective!=null){
			perspective=perspective.replaceAll("\"","");
		}
		if (formAction!=null){
			formAction=formAction.replaceAll("\"","");
		}
	
       //Build scope list
       Set rolesInCurrentContext = null;

       if (rolemap != null) {
           rolesInCurrentContext = new HashSet();

           for (Iterator j = rolemap.values().iterator(); j.hasNext(); ) {
               rolesInCurrentContext.addAll((Set) j.next());
           }
       }

       java.util.Properties props= null;
       
       java.util.ArrayList actionList_ext =  new java.util.ArrayList();
       for(int i=0;i<list.size(); i++)
              actionList_ext.add(list.get(i));
       
       IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();
       
       String extensionId = "com.ibm.websphere.wsc.actionSet";
       IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);
       
       IExtension[] extensions= registry.getExtensions(extensionId,ic);
       
       if(extensions!=null && extensions.length>0){
              if(contextId!=null && contextId!="nocontext"){
                     props = ConfigFileHelper.getNodeMetadataProperties((String)contextId, request); //213515 //LIDB4138-39
              }
              if(formName!=null)
                     props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName); // LIDB2303A
              else
                     props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props);
           
              actionList_ext = ActionSetSelector.getButtons(extensions,actionList_ext,props,perspective, definitionName);
       } 
       pageContext.setAttribute("actionList_ext",actionList_ext);
       
       boolean buttonsShown = false;

%>
<%
       Iterator i = actionList_ext.iterator();
       int listsize = actionList_ext.size();
       int excessItems = 0;
       String buttonName = "";
       if (listsize > (count+1) ) {
              excessItems = 0;     
       } else {
              count = listsize;
       }

%>
        
<% if (listsize > 0) { %>

        <table border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Framing Table" CLASS="button-section">
<% if (desc != null) { %>
        <caption style="text-align:left" class="table-text"><bean:message key="%=desc%"/></caption>
<% } %>
        <tr valign="top">
        <td class="table-button-section"  nowrap> 
        
        
    <%  if (includeForm.equals("yes")){  %>          
    <form method="POST" action="toolbar.do" class="nopad">
    <input type=hidden name="csrfid" value="<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>">
    <% } %>

    
    
    <%-- Iterate over names.
      We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
     --%>
    <table style="display: inline; font-size: 95%;" cellspacing="0" cellpadding="0" border="0"><tr>
    
    <%
    JSONArray buttonsScriptingObject = new JSONArray(listsize);
    for (int ctr=0; ctr < listsize ; ++ctr) {
        ActionSetItem item = (ActionSetItem)i.next();
        String action = item.getAction();
        buttonName = action; 
        boolean showItem = true;
        String onclick=item.getShowPleaseWait() ? "onclick=\"showPleaseWaitButton("+buttonName+")\"" : "";
        JSONObject buttonScriptingObject = new JSONObject();
        JSONArray buttonRolesArray = new JSONArray();
        if (SecurityContext.isSecurityEnabled()) {
            String[] roles = item.getRoles();
            showItem = false;
            for (int idx = 0; idx < roles.length; idx++) {
                   
                   //By default if scope isn't defined, we rely on the scopes associated with ever item in the collection list, as defined in rolesInCurrentScope
                   //to determine whether to display a button.
                   //If a scope is set, then we check whether the caller has any access to that scope
                    if (item.getScope() == null || item.getScope().equals("")) {
           
                           //If rolesInCurrentScope is null, then that means we weren't given a rolemap by the collectionTableLayout,
                           //So we should probably display the buttons by default.
                           if (rolesInCurrentContext == null || rolesInCurrentContext.contains(roles[idx])) {
                                  showItem = true;
                                  buttonRolesArray.add(roles[idx]);
                           } else if (buttonName.contains("button.new")) { //Always allow new button to be displayed
		                    	if (rolesInCurrentContext != null && rolesInCurrentContext.contains(roles[idx])) {
		                    		showItem = true;
		                    	}
		                    }
                           
                    } else {
                           if (SecurityHelper.checkAccessToScope(item.getScope(), roles[idx])) {
                                  showItem = true;
                           }
                    }
            }
        }
        
             //No need to record the roles-we don't want to allow this button to be dynamically disabled if it's associated with a scope
              if (item.getScope() == null || item.getScope().equals("")) {
                     buttonScriptingObject.put(buttonName, buttonRolesArray);
                     buttonsScriptingObject.add(buttonScriptingObject);
              }
        
        if (showItem == true) {
               buttonsShown = true;
            
               if (item instanceof MenuActionSetItem){
                        MenuActionSetItem menuItem = (MenuActionSetItem) item;
                      String optionValueList = menuItem.getOptionValueList();
                      String optionLabelList = menuItem.getOptionLabelList();
                      String optionTitleList = menuItem.getOptionTitleList();
                      boolean translatable = menuItem.isTranslatable(); 
                      String actionName = menuItem.getActionName();
                      java.util.List optionValues = (java.util.List) session.getAttribute(optionValueList);
                      java.util.List optionLabels = (java.util.List) session.getAttribute(optionLabelList);
                      java.util.List optionTitles = null;
                      String titleString = null;
                      if (optionTitleList!=null) {
                          optionTitles = (java.util.List) session.getAttribute(optionTitleList);
                      } else {
                          optionTitles = (List)(new java.util.Vector());
                      }
                      if(optionValues.size()!=optionLabels.size()){
                             log("Cannot display button "+buttonName+", labels and values not aligned");
                      }
                      else{
                             %>
                      <td>
                             
                             
                            <noscript>
                             <div class="hidden">
                                    <label for="<%=actionName%>">
                                           <bean:message key="<%=buttonName %>"/>
                                    </label>
                             </div>
                             <select name="<%=actionName%>" id="<%=actionName%>" size="1">
                                    <option value="" selected="selected">
                                           <bean:message key="<%=buttonName %>"/>
                                    </option>
                                    <logic:iterate collection="<%=optionValues %>" indexId="index" id="option">
                                           <option value="<%=option %>">
                                                  <%if(translatable){ %>
                                                         <bean:message key="<%=(String) optionLabels.get(index.intValue())%>"/>
                                                  <%}else{ %>
                                                         <%=(String) optionLabels.get(index.intValue())%>
                                                  <%} %>
                                           </option>
                                    </logic:iterate>
                             </select>
                                   <input type="submit" name="go" value="<bean:message key="button.go"/>" class="buttons_functions"/>
                            </noscript>
                            <div class="hidden" id="<%=buttonName%>Div">
                      <table style="display: inline; font-size: 95%;" border="0" cellpadding="0" cellspacing="0">
                             <tr><td>
                                    <input type="hidden" name="<%=actionName%>" id="<%=buttonName%>"/>
                                             <button type="button" class="buttons_functions" id="<%=buttonName+".button"%>" 
                                                    tabindex="1"
                                                    onclick="showHideMenu('<%=buttonName%>')" ondblclick="if(!isDom){showHideMenu('<%=buttonName%>')}">
                                                    <bean:message key="<%=buttonName%>"/>
                                                    <IMG SRC="<%=request.getContextPath()%>/images/arrow_expanded_old.gif" width="10" height="10" style="text-align: right" BORDER="0" ALT="<bean:message key="button.dropdownmenu.alt"/>"/>
                                             </button>
                             </td></tr>
                             <tr><td>
                                         <table style="position:absolute;display:none;" border="1" cellpadding="0" cellspacing="0" id="<%=buttonName+".menu" %>">
                                           <logic:iterate collection="<%=optionValues %>" indexId="index" id="option">
                                              <% 
                                                 if (index.intValue()<optionTitles.size()) {
                                                     titleString = (String)optionTitles.get(index.intValue());
                                                     if (titleString.length()>0) {
                                                         titleString = messages.getMessage(request.getLocale(), titleString);
                                                     }
                                                     // If there is no translatable string found in resource, use the message key as the value.
                                                     if (titleString==null) {
                                                         titleString = (String)optionTitles.get(index.intValue());
                                                     }
                                                 } else {
                                                     titleString = "";
                                                 }
                                              %>
 	                                          <tr width="100%">
		                  						<td nowrap width="100%" style="BACKGROUND-COLOR: #eaf1ff" class="buttons_functions" role="button"
		                  							onmouseout="this.style.backgroundColor='#eaf1ff'"
		                  							onblur="this.style.backgroundColor='#eaf1ff'">
		                  							<a title="<%=titleString%>" href="javascript:selectMenuItem('<%=buttonName%>','<%=option %>','<%=hiddenButtonId%>')" 
		                  								style="text-decoration: none; color:black;" 
		                  								onfocus="this.parentNode.style.backgroundColor='#dae1ef'" 
		                  								tabindex="1"
		                  								onblur="this.parentNode.style.backgroundColor='#eaf1ff'">
	    												<p style="margin: 0;width: 100%" onkeypress="if(isInputKey(event)){selectMenuItem('<%=buttonName%>','<%=option%>','<%=hiddenButtonId%>')}"
			                  								class="menu_option" onmouseover="this.parentNode.parentNode.style.backgroundColor='#dae1ef'" role="button">
								        					<%if(translatable){ %>
								        						<bean:message key="<%=(String) optionLabels.get(index.intValue())%>"/>
								        					<%}else{ %>
								        						<%=(String) optionLabels.get(index.intValue())%>
								        					<%} %>
		                  								</p>
		                  							</a>
		                  						</td>

    									   </tr>
                                           </logic:iterate>
                                             </table>
                                      </td></tr></table>
                                      </div>
                                      <script language="JavaScript">
                                             document.getElementById("<%=buttonName%>Div").style.display="inline";
                                   </script>
                            </td>
                             
                             <%
                      }
               }
               else{

    %>
              <td>
              <%-- added this div so that tooltips would work when buttons are disabled --%>
              <div style="position:relative;">
                   <input type="submit" name="<%=action%>" value="<bean:message key="<%=buttonName %>"/>" tabindex="1" <%=onclick%>" class="buttons_functions"/>
           </div>
           </td>
   
    <%
               }
        } //end if
    %>
    <%
      } // end loop
    %>
      
        <input type="submit" name="<%=hiddenButtonId%>" value="hiddenButton" style="display:none" class="buttons" id="<%=hiddenButtonId%>"/>
        
    </tr></table>    
    <%
    
    if (excessItems > 0) { %>
    
    &nbsp;&nbsp;
    
    <SELECT name="excessAction">
    
    <% for (int ctr=0; ctr < excessItems ; ++ctr) {
        ActionSetItem item2 = (ActionSetItem)i.next();
        String action2 = item2.getAction();
        buttonName = action2; 
        boolean showExcessItem = true;
        if (SecurityContext.isSecurityEnabled()) {
            String[] roles = item2.getRoles();
            showExcessItem = false;
            for (int idx = 0; idx < roles.length; idx++) {
                if (request.isUserInRole(roles[idx])) {
                    showExcessItem = true;
                    break;
                }
            }
        }
        if (showExcessItem == true) {
    %>
    <option value="<%=action2 %>">
    <bean:message key="<%=buttonName%>"/>
    </option> 
    <%
        } //end if
    %>
    <%
      } // end loop
    %>  
    
    </SELECT>
    <input type="submit" name="go" value="<bean:message key="button.go"/>" class="buttons_functions"/>
    <% 
   
    } %>

    <input type="hidden" name="definitionName" value="<%=definitionName%>"/>
    <input type="hidden" name="buttoncontextType" value="<%=contextType%>"/>
    <input type="hidden" name="buttoncontextId" value="<%=contextId%>"/>
    <input type="hidden" name="buttonperspective" value="<%=perspective%>"/> 
     <input type="hidden" name="formAction" value="<%=formAction%>"/>  
    

    <% if (includeForm.equals("yes")) {%> 
      </form>
    <% } %>
    
        </td>
        </tr>
        </table>


<% 
       //If role filtering is disabled, then don't even write the JSON info for the button filtering.
       //The javascript will be smart enough to skip the filtering if it can't find the object.
       //Also do the same if security is disabled
       AdminAuthorizer aa = AdminAuthorizerFactory.getAdminAuthorizer();
       if (rolemap != null && aa != null && aa.isFineGrainedAdminSecurity()) {
              JSUtil.getScriptingContext(request).storeObject("buttonsFilter", buttonsScriptingObject);
       }
} else { 
//Show hidden inputs to be used by action anyways
%>
    <input type="hidden" name="definitionName" value="<%=definitionName%>"/>
    <input type="hidden" name="buttoncontextType" value="<%=contextType%>"/>
    <input type="hidden" name="buttoncontextId" value="<%=contextId%>"/>
    <input type="hidden" name="buttonperspective" value="<%=perspective%>"/> 
    <input type="hidden" name="formAction" value="<%=formAction%>"/>  

<%
}

%>

<%
if(!buttonsShown){
    request.setAttribute("hide.check.boxes","true");
} else {
	request.setAttribute("hide.check.boxes","false");
}
%>
 
<script language="JavaScript">
       function showHideMenu(buttonName){
              var table = document.getElementById(buttonName+".menu");
              if(table.style.display=="none"){
                     table.style.display="block";
              }
              else{
                     table.style.display="none";
              }       
       }
                     
       function isInputKey(e){
              var keyCodeChar;  
                           
              if (e && e.which){
                     keyCodeChar = e.which;
              }
              else{
                     e = event;
                     keyCodeChar = e.keyCode;
              }
                         
              if (keyCodeChar == 13 || keyCodeChar == 32){
                     return true;
              }
              else{
                     return false;
              }
       }
                     
       function selectMenuItem(buttonName,option,hiddenButtonId){
           var button = document.getElementById(buttonName);
           button.value=option;
           document.getElementById(hiddenButtonId).click();
       }
</script>
