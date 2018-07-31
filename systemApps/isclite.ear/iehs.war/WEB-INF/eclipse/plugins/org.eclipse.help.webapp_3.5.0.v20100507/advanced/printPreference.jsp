<%--
 Copyright (c) 2010 IBM Corporation and others.
 All rights reserved. This program and the accompanying materials 
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Contributors:
     IBM Corporation - initial API and implementation
--%>
<%@ include file="header.jsp"%>
<% 
    String qs = request.getQueryString();
    String location = "";
    if (qs != null) {
	    location = "print.jsp?" + qs + "&pageBreak=true";
    }
    String[] args = new String[] {
			ServletResources.getString("yes", request),
			ServletResources.getString("no", request)};
	String notice = ServletResources.getString("pageBreak", args, request);
%>


<html lang="<%=ServletResources.getString("locale", request)%>">
<head>
<title><%=ServletResources.getString("alert", request)%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="stylesheet" href="../<%=pluginVersion%>/advanced/printAlert.css" charset="utf-8" type="text/css">
<script language="JavaScript">

function onloadHandler() {
	sizeButtons();
}

function sizeButtons() {
	var minWidth=60;

	if(document.getElementById("ok").offsetWidth < minWidth){
		document.getElementById("ok").style.width = minWidth+"px";
	}
	if(document.getElementById("cancel").offsetWidth < minWidth){
		document.getElementById("cancel").style.width = minWidth+"px";
	}
}

function getParam(){
	var url = top.location.href;
	var param = url.substring(url.indexOf('?')+1);
	return param;
}
function pageBreak(){
	var form = document.getElementsByName("pageBreakForm")[0];
	form.action = "print.jsp?"+getParam()+"&pageBreak=true&breakConfirmed=true";
	form.submit();
}
function cancelBreak(){
	var form = document.getElementsByName("pageBreakForm")[0];
	form.action = "print.jsp?"+getParam()+"&pageBreak=false&breakConfirmed=true";
	form.submit();
}
</script>

</head>
<body role="main" dir="<%=direction%>" onload="onloadHandler()">
<p/>
<div align="center">
<div class="printAlertDiv">
<table role="presentation" align="center" cellpadding="10" cellspacing="0" width="400">
	<form name="pageBreakForm" method="post">
	<tbody>
		<tr>
			<td class="caption"><strong><%=ServletResources.getString("alert", request)%></strong></td>
		</tr>
		<tr>
			<td class="message">
			<p><%=notice%></p>
			</td>
		</tr>
		<tr>
			<td class="button">
			<div align="center">
				<button id="ok" onClick="pageBreak()"><%=ServletResources.getString("yes", request)%></button>
				<button id="cancel" onClick="cancelBreak()"><%=ServletResources.getString("no", request)%></button>
            </div>
			</td>
		</tr>
	</tbody>
	</form>
</table>
</div>
</div>
</body>
</html>
