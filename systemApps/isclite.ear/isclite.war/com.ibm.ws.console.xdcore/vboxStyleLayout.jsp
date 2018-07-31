<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.struts.action.Action" %>
<%@ page import="org.apache.struts.util.MessageResources" %>
<%@ page import="com.ibm.ws.console.core.breadcrumbs.Breadcrumb" %>
<%@ page import="com.ibm.ws.console.core.breadcrumbs.impl.BreadcrumbImpl" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.console.core.item.PropertyItem" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute id="modifyCSS" name="modifyCSS" ignore="true" classname="java.lang.String" />
<%
  String userAgent = request.getHeader( "User-Agent" );
  boolean isMSIE = ((userAgent != null) && (userAgent.indexOf("MSIE") != -1));
%>
<style>
.fixUp {
  padding: 0.75em;
<% if (isMSIE && ((modifyCSS != null) && "true".equalsIgnoreCase(modifyCSS))) { %>
  overflow: hidden;
  width: 100%
<% } %>
}
</style>
<%-- Layout component 
  Render a list of tiles in a vertical column
  @param : list List of names to insert 
  
--%>
<tiles:useAttribute id="list" name="list" classname="java.util.List" />
<tiles:useAttribute id="helpTopic" name="helpTopic" ignore="true" classname="java.lang.String" />
<tiles:useAttribute id="pluginId" name="pluginId" ignore="true" classname="java.lang.String" />

<tiles:useAttribute id="breadcrumbTitle" name="breadcrumbTitle" ignore="true" classname="java.lang.String" />
<tiles:useAttribute id="breadcrumbTileDefinition" name="breadcrumbTileDefinition" ignore="true" classname="java.lang.String" />

<!-- [OPTIONAL, Default value: false] Includes a table html tag around the entire set of tiles. -->
<tiles:useAttribute id="enableTableTags" name="enableTableTags" ignore="true" classname="java.lang.String" />
<%
	if (enableTableTags == null) { enableTableTags = "false"; }
	boolean showHelp = false;
	if (helpTopic != null && !helpTopic.equals("")) {
		if (pluginId != null && !pluginId.equals("")) {
			showHelp = true;
		}
	}
%>
<div class="fixUp">
<% if (showHelp) { %>
	<div align="right">
		<table>
			<tr><td class="table-text" align="right" valign="top">
				<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="" />
				<ibmcommon:info label="wsc.field.help.page.link" topic="<%=helpTopic%>" />
			</td></tr>
		</table>
	</div>
<% } %>
<%-- Iterate over names.
  We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
 --%>
<script language="JavaScript" src="<%=request.getContextPath()%>/com.ibm.ws.console.xdcore/scripts/menu_functions.js"></script> 

<script language="JavaScript">
	showString = ""
	isDom2 = ""
</script>
   		<%
			//Bug 9676: creating new breadcrumb for current tab
			if (breadcrumbTitle != null && breadcrumbTileDefinition != null) {
			    MessageResources msgs = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);
				String title = msgs.getMessage(request.getLocale(), breadcrumbTitle);
				String link = request.getContextPath()+breadcrumbTileDefinition;
		   		
		   		String reset = (String) session.getAttribute("xd_bc_reset");
		   		if (reset == null) {
		   			Breadcrumb crumb = new BreadcrumbImpl(title, link, title+link, title+link);
					java.util.List l = new java.util.ArrayList();
	   				l.add(crumb);		   			
					com.ibm.ws.console.core.breadcrumbs.BreadcrumbHelper.setBreadcrumbTrail(request, l);
		   		}
		   	}
   		%>

<% if (enableTableTags.equals("true")) {%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" role="presentation">
<% }
String savePaging = "";
Iterator i=list.iterator();
while (i.hasNext()) {
  String name= (String)i.next();
    if (name.indexOf("paging") > -1) {
      savePaging = name;
    } else {
%>
    <tiles:insert name="<%=name%>" flush="true" />
<%
    }
  } // end loop

  //  Used as a temporary fix to place paging layout at the bottom of collections
  if (!savePaging.equals("")) {
%>
    <tiles:insert name="<%=savePaging%>" flush="true" />
<%
  }
%>
<% if (enableTableTags.equals("true")) { %>
</table>
<% } %>
</div>