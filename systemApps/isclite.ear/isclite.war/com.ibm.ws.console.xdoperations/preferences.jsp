<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PreferencesDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.Utils"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="showButtons" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showOkButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showApplyButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showCancelButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showResetButton" classname="java.lang.String" ignore="true"/>

<% 
PreferencesDetailForm prefsDetailForm = (PreferencesDetailForm) session.getAttribute(formName);
String contextType = (String) request.getAttribute("contextType");
//System.out.println("preferences:: contextType=" + contextType);
%>
<script>
function showHideSection(sectionId) {
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.xdoperations/images/minus_sign.gif";
            }
        } else {
            document.getElementById(sectionId).style.display = "none";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.xdoperations/images/plus_sign.gif";
            }
        }
    }
}
</script>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
	<input type="hidden" name="contextType" value="<%=contextType%>"/>
	<% 
	String currentPluginId = (String) pageContext.getAttribute("pluginId", PageContext.REQUEST_SCOPE);
	String helpTopic = Utils.getHelpTopic(contextType); 
	String bcHandler = "";
	%>
	
	<% if (!helpTopic.equals("")) { %>
		<div align="right" class="table-text">
			<ibmcommon:setPluginInformation pluginIdentifier="com.ibm.ws.console.xdoperations" pluginContextRoot="" />
			<ibmcommon:info label="wsc.field.help.page.link" topic="<%=helpTopic%>" />
		</div>
		<ibmcommon:breadcrumbs title="name" id="<%=helpTopic%>" handler="<%=bcHandler%>" renderer="false"/>
	<%  
		// need to reset pluginId for help portlet link
		pageContext.setAttribute ("pluginId", currentPluginId, PageContext.REQUEST_SCOPE);
	} %>
	<table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" ><tbody>

		<% if (prefsDetailForm != null) {
			//System.out.println("found PrferencesDetailForm");
			PropertyGroupDetailForm form = prefsDetailForm.getPropertyGroup();
			boolean isExpandable = form.isExpandable();
			List propertyGroups = form.getPropertyGroups();
			List properties = form.getProperties();
		%>
   
			<tr valign="top"> <td class="table-text-white" valign="top">
					<a href="javascript:showHideSection('<%=formAction%>')" class="expand-task">
		            	<img id="<%=formAction%>Img" SRC="<%=request.getContextPath()%>/com.ibm.ws.console.xdoperations/images/plus_sign.gif" alt="" title="" border="0" align="texttop"/>            
						<bean:message key="<%=form.getDisplayNameKey()%>"/>
					</a>
			 </td></tr></tbody></table>
			  	<table id="<%=formAction%>" style="display: none;" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
			 		<tbody>
			
			        	<%
			        	ArrayList propItems = new ArrayList();
			        	for (Iterator i = properties.iterator(); i.hasNext(); ) {
			            	PropertyDetailForm propDetailForm = (PropertyDetailForm) i.next();
			            	//System.out.println("prop=" + propDetailForm.getName());
			            	// Only display the property if not hidden.  Ex: discoverymode is usually hidden.
			            	if (propDetailForm.isHidden()) {
			                	continue;
			            	}
			            	propItems = propDetailForm.getPropertyItems();
			            	session.setAttribute("com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm", propDetailForm);
			        	%>
					        <tiles:insert page="/com.ibm.ws.console.xdoperations/propertyLayout.jsp" flush="true">
						        <tiles:put name="formName" value="com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm" />
						        <tiles:put name="formType" value="com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm" />
						        <tiles:put name="attributeList" value="<%=propItems%>" />
						        <tiles:put name="readOnlyView" value="no" />					   
					        </tiles:insert>
			        	<% } %>
			    	 
			    		<%
			       		for (Iterator i = propertyGroups.iterator(); i.hasNext(); ) {
			            	PropertyGroupDetailForm propGroupDetailForm = (PropertyGroupDetailForm) i.next();
			            	//System.out.println("propgroup=" + propGroupDetailForm.getName());
			            	// Only display the property if not hidden.  Ex: discoverymode is usually hidden.
			            	if (propGroupDetailForm.isHidden()) {
			                	continue;
			            	}
			            	session.setAttribute("com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm", propGroupDetailForm);
			        	%>
					        <tiles:insert page="/com.ibm.ws.console.xdoperatoins/propertyGroupLayout.jsp" flush="true">
					        	<tiles:put name="formName" value="com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm" />
					        </tiles:insert>
			        	<% } %>
			        	
			        	<% if (showButtons!=null && showButtons.equalsIgnoreCase("yes")) { %>
							<tr> <td class="navigation-button-section" nowrap VALIGN="top">
				            	<% if (showApplyButton!=null && showApplyButton.equals("yes")){ %>
				            		<input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation">
				            	<% } %>
				            
				            	<% if (showOkButton!=null && showOkButton.equals("yes")){ %> 
				            		<input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons_navigation"> 
				            	<% } %>
				            
				            	<% if (showResetButton!=null && showResetButton.equals("yes")){ %>
				            		<input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation">
				            	<%  }%>
				            
				            	<% if (showCancelButton!=null && showCancelButton.equals("yes")){ %>
									<input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
				            	<% } %>
			            	</td></tr>
		            	<% }%>
	
			 		</tbody>
			    </table>
		<% } %>
</html:form>
