<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.* "%>
<%@ page import="org.apache.struts.util.MessageResources" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>


<bean:define id="appName" name="<%=actionForm%>" property="name" type="java.lang.String"/>
<bean:define id="appType" name="<%=actionForm%>" property="type" type="java.lang.String"/>
<bean:define id="edition" name="<%=actionForm%>" property="edition" type="java.lang.String"/>
<bean:define id="editionDesc" name="<%=actionForm%>" property="editionDesc" type="java.lang.String"/>
<%
	InstallMiddlewareAppForm WasceAppForm = (InstallMiddlewareAppForm) session.getAttribute(actionForm);
    
    ArrayList column1 = WasceAppForm.getAvailableModuleNames();
    ArrayList column2 = WasceAppForm.getAvailableModuleContextRoot();
    ArrayList column3 = WasceAppForm.getAvailableModuleVirtualHosts();
    ArrayList column4 = WasceAppForm.getAvailableModuleDeploymentTargets();

    String target = "";
    for(int j=0; j<column4.size(); j++){
    	target = target + column4.get(j) + ";" + "<BR>";
    }
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
    <tr valign="baseline">
        <td class="wizard-step-text" width="100%" align="left">
            <bean:message key="middlewareapps.confirm.description"/>
        </td>
    </tr>
</table>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List Table" class="framing-table">
    <tr>
        <th class="column-head-name" scope="col">
            <bean:message key="middlewareapps.confirm.summary"/>
        </th>
    </tr>
    <tr>
        <td class="table-text" valign="top">
            <bean:message key="middlewareapps.detail.name"/>=<%=appName%>
            <br/>
            <bean:message key="middlewareapps.detail.type"/>=<%=appType%>
            <br/>
            <bean:message key="middlewareapps.detail.edition"/>=<%=edition%>
            <br/>
            <bean:message key="middlewareapps.detail.editionDesc"/>=<%=editionDesc%>
            <br/>
               
        </td>
    </tr>
<%
	if(column1 != null && !column1.isEmpty() && column1.size()!=0){
%>   
	    <tr>
	        <td class="table-text" valign="top">
	
	            <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List Table" class="framing-table">
	            <tr>
	                
	                <th class="column-head-name" scope="col" >
			        	<bean:message key="middlewareapps.wasce.displayName"/>
			       	</th>
	                
	                <th class="column-head-name" scope="col">
	                    <bean:message key="middlewareapps.wasce.contextRoot"/>
	                </th>
	                <th class="column-head-name" scope="col" >
	                    <bean:message key="middlewareapps.wasce.virtualHost"/>
	                </th>
	                <th class="column-head-name" scope="col" >
	            	<bean:message key="middlewareapps.wasce.deploymentTarget"/>
	           		</th>
	            </tr>
	
	<%
	        
	    for (int i = 0; i < column1.size(); i++) {
	
	%>
	
	            <tr class="table-row">
	                <td class="collection-table-text"><%=column1.get(i)%></td>
	                <td class="collection-table-text"><%=column2.get(i)%></td>
	                <td class="collection-table-text"><%=column3.get(i)%></td>
	                <% if(target.equals("")){ %>
	                <td> </td>
	                <% }else{ %>
	                <td class="collection-table-text"><%=target%></td>
	                <% } %>
	            </tr>    
	
	<%
	    }
	
	    // Column Size is Null
	    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
	    MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
	    if (column1.size() == 0) {
	        String nonefound = messages.getMessage(request.getLocale(), "Persistence.none");
	        out.println("<tr class='table-row'><td colspan='5'>" + nonefound + "</td></tr>");
	    }
	%>
	
	            </table>
	        </td>
	    </tr>
<%
    } else { 
%>
	<tr>
		<td class="table-text" valign="top">
			<%--<bean:message key="middlewareapps.wasce.contextRoot"/>=<%=column2.get(0)%>
			<br>--%>
       	    <bean:message key="middlewareapps.wasce.deploymentTarget"/>=
            <%=target%>   
        </td>
    </tr>

<%
	}
	   
%>
</table>
