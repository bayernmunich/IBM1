<%--
 Copyright (c) 2000, 2010 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="advanced/header.jsp"%>
<%
    ServerState.webappStarted(application, request, response);
    String buildTime = VersionData.BUILD_TIME;
%>
<html lang="<%=ServletResources.getString("locale", request)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=ServletResources.getString("versionTitle", request)%></title>
<style type = "text/css"> 
td { 
    padding: 10px; 
}
</style>
</head>
<body dir="<%=direction%>" role="main">
<table role="presentation" dir="<%=direction%>">	
	<tr>
		<td>
			<label><strong><%=ServletResources.getString("versionBuildTimeLabel", request)%></strong></label>
		</td>
		<td>
			<label><%=buildTime%></label>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<a href="about.html" title="<%=ServletResources.getString("versionDetailTip", request)%>"><%=ServletResources.getString("versionDetailLabel", request)%></a>
		</td>
	</tr>
</table>
</body>
</html>	

