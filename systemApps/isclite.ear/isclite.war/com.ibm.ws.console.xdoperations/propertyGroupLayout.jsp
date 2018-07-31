<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyDetailForm"%>
<%@ page import="com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="formName" classname="java.lang.String" />
<% 
PropertyGroupDetailForm form = (PropertyGroupDetailForm) session.getAttribute(formName);
List propertyGroups = form.getPropertyGroups();
List properties = form.getProperties();
%>
   
<tr valign="top">
	<td class="table-text" valign="top">
		<fieldset>
   		<legend>
			<bean:message key="<%=form.getDisplayNameKey()%>"/>
		</legend> 
           
  		<table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" summary="ForeignServer Table" >
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
        	<%}%>
    	
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
		        	<tiles:put name="formName" value="com.ibm.ws.console.xdoperations.prefs.PropertyGroupDetailForm"/>
		        </tiles:insert>
        	<%}%>
           </tbody>
    	</table>
		</fieldset>
	</td>
</tr>