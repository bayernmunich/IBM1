<%--
 Copyright (c) 2000, 2010 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="fheader.jsp"%>

<% 
	LayoutData data = new LayoutData(application,request, response);
	FrameData frameData = new FrameData(application,request, response);
	WebappPreferences prefs = data.getPrefs();
%>

<html lang="<%=ServletResources.getString("locale", request)%>">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("Help", request)%></title>

<style type="text/css">
<% 
if (data.isMozilla()) {
%>
HTML {
	border-<%=isRTL?"left":"right"%>:1px solid ThreeDShadow;
}
<% 
} else {
%>
FRAMESET {
	border-top:1px solid ThreeDShadow;
	border-left:1px solid ThreeDShadow;
	border-right:1px solid ThreeDShadow;
	border-bottom:1px solid ThreeDShadow;
}
<%
}
%>
</style>
<script type="text/javascript">
//for vcc to focus on detail topic/comment
function onloadHandler(e)
{
        <%
        Object qs =  request.getSession().getAttribute("preurl");
        String path = null;
        if(null != qs) {
			request.getSession().removeAttribute("preurl");
			String qString = qs.toString();
			String prefix = request.getSession().getAttribute("addressprefix").toString();
			path = prefix + "/topic/" + qString.substring("/topic/".length());
        } 
        if(null != path) {
        %>
        window.frames.ContentViewFrame.location = '<%=path%>';
        <%}%>
}
</script>
</head>
<div role="main">
    <frameset id="contentFrameset" rows="<%=frameData.getContentAreaFrameSizes()%>" frameborder="1" framespacing="3" border="6" spacing="0">
	<frame name="ContentToolbarFrame" title="<%=ServletResources.getString("topicViewToolbar", request)%>" src='<%="contentToolbar.jsp"+UrlUtil.htmlEncode(data.getQuery())%>'  marginwidth="0" marginheight="0" scrolling="no" frameborder="0" noresize>
	<frame ACCESSKEY="K" name="ContentViewFrame" title="<%=ServletResources.getString("topicView", request)%>" src='<%=UrlUtil.htmlEncode(data.getContentURL())%>'  marginwidth="10"<%=(data.isIE() && Float.compare(data.getIEVersion(), 6.0F) >= 0)?"scrolling=\"yes\"":""%> marginheight="0" frameborder=<%=data.isChrome()? "1":"0"%>>
	<%
	    AbstractFrame[] frames = frameData.getFrames(AbstractFrame.BELOW_CONTENT);
	    for (int f = 0; f < frames.length; f++) {
	        AbstractFrame frame = frames[f];
	        String url = frameData.getUrl(frame);
	%>
	<frame id= "<%=frame.getID()%>" name="<%=frame.getName()%>" title="<%=frame.getTitle(UrlUtil.getLocaleObj(request, null))%>" src="<%=url%>" <%=frame.getFrameAttributes()%> >
	<% 
	 } 
	%>
	</frameset>
</div>
</html>

