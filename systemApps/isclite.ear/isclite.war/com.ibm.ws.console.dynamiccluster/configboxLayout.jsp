<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp. 1997, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator,org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.error.*,com.ibm.ws.console.core.bean.*,com.ibm.ws.console.core.Constants"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="com.ibm.ws.console.core.utils.StatusUtils" %>
<%!
  private boolean isDmgr = StatusUtils.isND();
%>

<%-- Layout component 
  Render a list of tiles in a vertical column
  @param : list List of names to insert 
  
--%>

<tiles:useAttribute name="showHelpPortlet" classname="java.lang.String" ignore="true" />
<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String" />
<% request.setAttribute("contextType",contextType);%>


<ibmcommon:detectLocale/>

<%
	WorkSpace workSpace = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
    UserPreferenceBean userBean = (UserPreferenceBean)session.getAttribute(com.ibm.ws.console.core.Constants.USER_PREFS);
	if (workSpace != null) {
		if (workSpace.getModifiedList().size() > 0) {
			if (request.getRequestURL().toString().indexOf("syncworkspace.do") == -1 && request.getRequestURL().toString().indexOf("logoff.do") == -1) {
		        java.util.Locale locale = (java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
	    	    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
                    boolean noOverwrite = (request.getSession().getAttribute (Constants.NO_OVERWRITE_KEY) != null);
				if((!com.ibm.ws.security.core.SecurityContext.isSecurityEnabled() || 
					(request.isUserInRole("administrator") || request.isUserInRole ("adminsecuritymanager") || request.isUserInRole ("auditor") || request.isUserInRole("configurator") || request.isUserInRole("deployer"))) && !noOverwrite){
	                IBMErrorMessage errorMessage1 = IBMErrorMessages.createURLWarningMessage(locale, messages, "warning.config.changes.made", null,request);//PM18909 secure the save link
	                //LIDB3795-28 Added direct "Save" link and "Preferences" link under messages
	                IBMErrorMessage errorMessage2 = null;
	                if(userBean.getProperty("System/workspace", "syncWithNodes", "false").equalsIgnoreCase("true"))
	                   errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.disabled", null);
	                else
	                    errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.enabled", null);
					IBMErrorMessage errorMessage3 = null;
					if(com.ibm.ws.console.core.utils.ConsoleUtils.requiresServerRestart(workSpace.getModifiedList())){
						errorMessage3 = IBMErrorMessages.createWarningMessage(locale, messages, "info.restart.server", null);
					}
		        	Object obj = request.getAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY);
		        	if (obj == null || !(obj instanceof IBMErrorMessage[])) {
						obj = new IBMErrorMessage[0];
					}
		        	IBMErrorMessage[] errorArray = (IBMErrorMessage[])obj;
	        		ArrayList newErrorArray = new ArrayList(errorArray.length + 3);
	        		newErrorArray.add(errorMessage1);
                                if (this.isDmgr) {
          	        		newErrorArray.add(errorMessage2);
                                }
					if(errorMessage3!=null){
	                	newErrorArray.add(errorMessage3);
					}
					newErrorArray.addAll(Arrays.asList(errorArray));
			        request.setAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY, (IBMErrorMessage[]) newErrorArray.toArray(new IBMErrorMessage[newErrorArray.size()]));
				}
		    }
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">

<html:html locale="true">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">
<% // strip the periods from the contextType so it will pass RPT dynamic assessment for WAI-ARIA
   if (contextType != null && contextType.length() > 0) { %>
<TITLE><%=contextType.replace(".", "")%></TITLE> 
<% } else { %>
<TITLE><bean:message key="detail.page.title"/></TITLE> 
<% } %>
<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<SCRIPT LANGUAGE="javascript" SRC="scripts/menu_functions.js"></script>

</head>
                                  
<body CLASS="content"  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 


<jsp:include page="/secure/layouts/content_accessibility.jsp" flush="true"/>

 
   
<tiles:useAttribute id="list" name="list" classname="java.util.List" />
<%-- Iterate over names.
  We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
 --%>
<%
Iterator i=list.iterator();
while( i.hasNext() )
  {
  String name= (String)i.next();

%>
<tiles:insert name="<%=name%>" flush="true" />

<%
  } // end loop
%>

<!-- Finishes table started in breadcrumb/title layouts  -->    
 </td>
 </tr>
 </TBODY>
 </table>
 
  </TD>
  
   
 <% if ((showHelpPortlet == null) || !showHelpPortlet.toLowerCase().equals ("false")) { %>
        <%@ include file="helpPortlet.jspf" %>
 <% } %>

</TR>
</TABLE>

 </body>
 </html:html>
