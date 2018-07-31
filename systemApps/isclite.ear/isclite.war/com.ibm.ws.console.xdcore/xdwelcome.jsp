<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>

<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>

<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<!-- WSC Console Federation -->
<%@ page import="com.ibm.ws.console.core.WSCDefines" %>
<%@ page import="com.ibm.ws.console.core.servlet.WSCRequestWrapper" %>


<% session.removeAttribute (com.ibm.ws.console.core.Constants.CURRENT_FORMTYPE); %>

<ibmcommon:detectLocale/>

<% 
 //WSC Console Federation
 boolean isFederated = false;
 if ( request instanceof WSCRequestWrapper ) {
	isFederated = ((WSCRequestWrapper)request).isFromIsc();
 }
 if (ConfigFileHelper.isSessionValid(request) == false)  
 {
	 String urlValue = request.getContextPath() + "/unsecure/invalidSession.jsp";
	 //WSC Console Federation 
	 if ( isFederated ) {	 
	 	//add a parameter to verify that we didn't come from the welcome page and launched from ISC
	 	urlValue = urlValue + "?" + WSCDefines.PARAM_SEPARATOR + WSCDefines.WSC_WELCOME_PAGE_FLAG + WSCDefines.KEY_VAL_SEPARATOR + "true";
	 }
     
     response.sendRedirect(urlValue);
     return;
 } 
%>
<tiles:insert definition="xd.welcome.page" flush="true" />

