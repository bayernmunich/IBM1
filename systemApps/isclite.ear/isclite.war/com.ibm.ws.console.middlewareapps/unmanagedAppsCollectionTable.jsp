<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
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
<%@ page import="com.ibm.ws.*" %>
<%@ page import="com.ibm.wsspi.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.*"%>
<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="com.ibm.ws.console.middlewareapps.form.*"%>
<%@ page import="com.ibm.ws.console.core.utils.VersionHelper"%>
<%@ page import="org.apache.struts.util.MessageResources"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />




<%

InstallMiddlewareAppForm UnmanagedAppForm = (InstallMiddlewareAppForm) session.getAttribute(actionForm);
MiddlewareUnmanagedAppModulesCollectionForm collectionForm = (MiddlewareUnmanagedAppModulesCollectionForm) request.getSession().getAttribute("MiddlewareAppsCollectionForm");
//boolean isForeignServer = UnmanagedAppForm.isForeignServer();
//String membershipType = UnmanagedAppForm.getMembershipType();
//String manualType = UnmanagedAppForm.getManualType();
%>

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
  <tr> 
     <td>           
	      <table class="button-section" border="0" cellpadding="3" cellspacing="0" width="100%">
	        <tr>
	          <td valign="top" class="function-button-section">        
	            <html:submit property="installAction" styleClass="buttons_other">
	              <bean:message key="button.new"/>
	            </html:submit>      
	            <html:submit property="installAction" styleClass="buttons_other">
	              <bean:message key="button.remove"/>
	            </html:submit>
	          </td>
	        </tr>
	      </table>
	      <table class="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Generic funtions for the table, such as content filtering">
	        <tr valign="top">
	          <td class="function-button-section"  nowrap>
	            <a id="selectAllButton" HREF="javascript:iscSelectAll('<%=actionForm%>')" CLASS="expand-task">
	              <img id="selectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_select_all.gif" ALT="<bean:message key="select.all.items"/>" BORDER="0" ALIGN="texttop"> 
	            </a>
	            <a id="deselectAllButton" HREF="javascript:iscDeselectAll('<%=actionForm%>')" CLASS="expand-task">
	              <img id="deselectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_deselect_all.gif" ALT="<bean:message key="deselect.all.items"/>" BORDER="0" ALIGN="texttop"> 
	            </a>         
	          </td>        
	        </tr>
	      </table>
	      
	      <fieldset style="border:0px; padding:0pt; margin: 0pt;">
			<legend class="hidden"><bean:message key="middlewareapps.unmanaged.wizard.deployment.edit"/></legend>
	      <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
	        <tr> 
	          <th class="column-head-name" scope="col" width="1%" >
	            <bean:message key="select.text"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="middlewareapps.unmanaged.displayName"/>
	          </th>
	          
	          <th class="column-head-name" scope="col" >
	            <bean:message key="middlewareapps.unmanaged.contextRoot"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="middlewareapps.unmanaged.virtualHost"/>
	          </th>
	          <th class="column-head-name" scope="col" >
	            <bean:message key="middlewareapps.unmanaged.deploymentTarget"/>
	          </th>
	        </tr>

<%  
ArrayList column0 = UnmanagedAppForm.getAvailableModuleNames();
ArrayList column1 = UnmanagedAppForm.getAvailableModuleContextRoot();
ArrayList column2 = UnmanagedAppForm.getAvailableModuleVirtualHosts();
ArrayList column3 = UnmanagedAppForm.getAvailableModuleDeploymentTargets();
String target = "";
for (int i=0; i < column0.size(); i++)
 { 
	target =""; 
	String checkboxId = column0.get(i) + "_select";	
%>

<tr class="table-row"> 
   <td CLASS="collection-table-text" width="1%">
      <label class="collectionLabel" for="<%=checkboxId %>" title="<bean:message key="select.text"/> <%=column0.get(i)%>">
         <html:checkbox property="checkBoxes" styleId="<%=checkboxId %>" value="<%=Integer.toString(i)%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)"/>
      </label>
   </td>
   <td CLASS="collection-table-text"><%=column0.get(i)%></td>
   <td CLASS="collection-table-text"><%=column1.get(i)%></td>
   <td CLASS="collection-table-text"><%=column2.get(i)%></td>
 <%   for (int j=0; j < ((ArrayList)column3.get(i)).size(); j++)
  		target = target + ((ArrayList)column3.get(i)).get(j) + ";" + "<BR>"; %>
   <td CLASS="collection-table-text"><%=target%></td>
</tr>
   
<%
} 
// Column size is null	
ServletContext servletContext = (ServletContext) pageContext.getServletContext();
MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
if (column0.size() == 0) {
  String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
  //out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
  out.println("<tr class='table-row'><td colspan='5'>"+nonefound+"</td></tr>");
}

%>

      </table>
      </fieldset>
    </td>
  </tr>
</table>
