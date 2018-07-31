<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<ibmcommon:detectLocale/>

<% 
String contextType= request.getParameter("contextType");
//System.out.println("insertTileLayout:: contextType=" + contextType);
request.setAttribute("contextType", contextType);

String scopeChanged = request.getParameter("scopeChanged");
//System.out.println("insertTileLayout:: scopeChanged=" + scopeChanged);
if (scopeChanged != null && scopeChanged.equals("true")) {
	request.setAttribute("scopeChanged", scopeChanged);
} else {
	request.removeAttribute("scopeChanged");
}

String attr = request.getParameter("attr");
//System.out.println("attr=" + attr);

%>
<tiles:insert definition="<%=attr%>" flush="true" />

