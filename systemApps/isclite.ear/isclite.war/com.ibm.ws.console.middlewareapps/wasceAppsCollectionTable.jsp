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
InstallMiddlewareAppForm WASCEAppForm = (InstallMiddlewareAppForm) session.getAttribute(actionForm);
MiddlewareWASCEAppModulesCollectionForm collectionForm = (MiddlewareWASCEAppModulesCollectionForm) request.getSession().getAttribute("MiddlewareAppsCollectionForm");

ArrayList a = WASCEAppForm.getAvailableModuleDeploymentTargets();
String t = "";
for(int i = 0 ; i<a.size() ; i++){
	t = t + a.get(i) + ";" + "<BR>";
}
%>


<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List table">
	<tr> 
    	<td>           
			<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
	        	<tr> 
	        		<th class="column-head-name" scope="col" >
		        		<bean:message key="middlewareapps.wasce.displayName"/>
		          	</th> 
		          	<th class="column-head-name" scope="col" >
		            	<bean:message key="middlewareapps.wasce.contextRoot"/>
		          	</th>
		          	<th class="column-head-name" scope="col" >
		            	<bean:message key="middlewareapps.wasce.virtualHost"/>
		          	</th>		          	
	        	</tr>

				<%  
				ArrayList column1 = WASCEAppForm.getAvailableModuleNames();
				ArrayList column2 = WASCEAppForm.getAvailableModuleContextRoot();
				//ArrayList virtualHostList = new ArrayList();
				
				for (int i=0; i < column1.size(); i++)
				 { 
				%>
				<tr class="table-row"> 
									
					<td CLASS="collection-table-text"><%=column1.get(i)%></td>
					<td CLASS="collection-table-text"><%=column2.get(i)%></td>
					<td CLASS="collection-table-text">		<!-- virtual host -->
						<label for="virtualHost" title="<bean:message key="middlewareapps.wasce.virtualHost"/>">
						<%--
							<html:select property="selectedVirtualHost" styleId="virtualHost">
							       <logic:iterate id="virtualHost" name="<%=actionForm%>" property="virtualHostList">
							           <html:option value="<%=(String) virtualHost%>">
							               <%=(String) virtualHost%>
							           </html:option>
							       </logic:iterate>
							</html:select>
						--%>
							<html:select property="selectedVirtualHost">
							       <logic:iterate id="virtualHost" name="<%=actionForm%>" property="virtualHostList">
							           <option value="<%=(String) virtualHost%>">
							               <%=(String) virtualHost%>
							           </option>
							       </logic:iterate>
							</html:select>
											
						</label>
					</td>
	
				<%
				} 
				%>
					<%-- <td CLASS="collection-table-text"><%=t%></td> --%>
				</tr>
				
				<%
				//WASCEAppForm.setAvailableModuleVirtualHosts(virtualHostList);
				
				// Column size is null	
				ServletContext servletContext = (ServletContext) pageContext.getServletContext();
				MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
				
				if (column1.size() == 0) {
				  String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
				  //out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
				  out.println("<tr class='table-row'><td colspan='5'>"+nonefound+"</td></tr>");
				}
				
				%>
				
				
				
				
	      </table>
	    </td>
	  </tr>
</table>
