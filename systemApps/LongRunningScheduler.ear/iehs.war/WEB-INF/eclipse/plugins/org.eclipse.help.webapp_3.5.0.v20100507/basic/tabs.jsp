<%--
 Copyright (c) 2000, 2010 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="header.jsp"%>
<% 
	LayoutData data = new LayoutData(application,request, response);
	WebappPreferences prefs = data.getPrefs();
	AbstractView[] views = data.getViews();
%>

<html lang="<%=ServletResources.getString("locale", request)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title><%=ServletResources.getString("Tabs", request)%></title>
    
<base target="ViewsFrame">
<SCRIPT TYPE="text/javascript">
<!--
function resynch()
{
		var topic = parent.HelpFrame.ContentViewFrame.window.location.href;
		// remove the query, if any
		var i = topic.indexOf('?');
		if (i != -1)
			topic = topic.substring(0, i);
		// remove the fragment, if any
		var i = topic.indexOf('#');
		if (i != -1)
			topic = topic.substring(0, i);
		parent.HelpFrame.ViewsFrame.location="view.jsp?view=toc&topic="+topic;
}
//-->
</SCRIPT>
</head>
   
<body dir="<%=direction%>" bgcolor="<%=prefs.getBasicToolbarBackground()%>" link="#0000FF" vlink="#0000FF" alink="#0000FF" role="navigation">
	<table role="presentation" align="<%=isRTL?"right":"left"%>" border="0" cellpadding="0" cellspacing="0">
	<tr>

<%
	for (int i=0; i<views.length; i++) 
	{
		// do not show booksmarks view
		if("bookmarks".equals(views[i].getName())){
			continue;
		}
		// do not show non enabled views
		if(!views[i].isVisibleBasic()){
			continue;
		}
		
		// search view is not called "advanced view"
		String title = data.getTitle(views[i]);
		if("search".equals(views[i].getName())){
			title=ServletResources.getString("SearchLabel", request).replace(":","");
		}
		String title_alt = data.getAltTitle(views[i]);
		String viewHref="view.jsp?view="+views[i].getName();		
%>
		<td nowrap>
		<b>
		<a  href='<%=viewHref%>' > 
	         <img alt="<%=title_alt%>" 
	              title="<%=title%>" 
	              <%
	              String image = data.getImageURL(views[i]);
	              if(image.indexOf("/vcc/") > -1){%>
	              src="<%=image%>" border=0>
	              <%}else{%>
	              src="../<%=pluginVersion%>/basic/<%=data.getImageURL(views[i])%>" border=0>
	              <%}%>
	         
	     <%=title%>
	     </a>
	     &nbsp;
		</b>
	     </td>
<%
	}
%>
	</tr>
	</table>

<SCRIPT TYPE="text/javascript">
<!--
document.write("<table align=\"<%=isRTL?"left":"right"%>\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td nowrap><b><a  href='javascript:parent.parent.TabsFrame.resynch();' >"); 
document.write("<img alt=\"<%=ServletResources.getString("Synch", request)%>\" title=\"<%=ServletResources.getString("Synch", request)%>\" src=\"../<%=pluginVersion%>/basic/images/e_synch_toc_nav.gif\" border=0> ");
document.write("<%=ServletResources.getString("shortSynch", request)%></a>&nbsp;</b></td></tr></table>");
//-->
</SCRIPT>

	<iframe name="liveHelpFrame" title="<%=ServletResources.getString("ignore", "liveHelpFrame", request)%>" frameborder="no" width="0" height="0" scrolling="no">
	<layer name="liveHelpFrame" frameborder="no" width="0" height="0" scrolling="no"></layer>
	</iframe>
</body>
</html>

