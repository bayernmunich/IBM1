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
<%@ page import="org.eclipse.help.internal.search.SearchHit" %>
<%@ page import="java.util.List" %>
<%@page import="java.util.Locale" %>

<% 
	String contents = request.getParameter("contents");
	if(contents != null){
		request.setAttribute("isSearchWithUrl",true);
	}	
	SearchData data = new SearchData(application, request, response);
	WebappPreferences prefs = data.getPrefs();
	Locale locale = UrlUtil.getLocaleObj(request, null);
	boolean isChrome = data.isChrome();
%>


<%@page import="java.util.ArrayList"%><html lang="<%=ServletResources.getString("locale", request)%>">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />

<title><%=ServletResources.getString("SearchResults", request)%></title>

<style type="text/css">
<%@ include file="searchList.css"%>
</style>

<base target="ContentViewFrame" />
<script language="JavaScript" src="../<%=pluginVersion%>/advanced/utils.js"></script>
<script language="JavaScript" src="../<%=pluginVersion%>/advanced/list.js"></script>
<script language="JavaScript" src="../<%=pluginVersion%>/advanced/searchView.js"></script>
<script language="JavaScript">
<!--
function refresh() { 
	window.location.replace("searchView.jsp?<%=UrlUtil.JavaScriptEncode(request.getQueryString())%>");
}
var cookiesRequired = "<%=UrlUtil.JavaScriptEncode(ServletResources.getString("cookiesRequired", request))%>";
function isShowCategories() {
	var value = getCookie("showCategories");
	return value ? value == "true" : false;
}

function isShowDescriptions() {
	var value = getCookie("showDescriptions");
	return value ? value == "true" : true;
}

function setShowCategories(value) {
	setCookie("showCategories", value);
	var newValue = isShowCategories();   	    
	parent.searchToolbarFrame.setButtonState("show_categories", newValue);
	if (value != newValue) {
	    alert(cookiesRequired);
	} else { 	    
	    window.location.reload();	   
	}
}

function setShowDescriptions(value) {
	setCookie("showDescriptions", value);
	var newValue = isShowDescriptions();   	
	parent.searchToolbarFrame.setButtonState("show_descriptions", newValue);
	if (value != newValue) {
	    alert(cookiesRequired);
	} else { 
	    setCSSRule(".description", "display", value ? "block" : "none");
	}
}

function toggleShowCategories() {
	setShowCategories(!isShowCategories());
}

function toggleShowDescriptions() {
	setShowDescriptions(!isShowDescriptions());
}

function onShow() { 
}

</script>
</head>

<body dir="<%=direction%>" role="navigation">
<%
if (!data.isSearchRequest()) {
	out.write(ServletResources.getString("doSearch", request));
} else if (data.getQueryExceptionMessage()!=null) {
	out.write(data.getQueryExceptionMessage());
} else if (data.isProgressRequest()) {
%>

<TABLE role="presentation" BORDER='0'>
	<TR><TD><%=ServletResources.getString("Indexing", request)%></TD></TR>
	<TR><TD ALIGN='<%=isRTL?"RIGHT":"LEFT"%>'>
		<DIV STYLE='width:100px;height:16px;border:1px solid ThreeDShadow;'>
			<DIV ID='divProgress' STYLE='width:<%=data.getIndexedPercentage()%>px;height:100%;background-color:Highlight'></DIV>
		</DIV>
	</TD></TR>
	<TR><TD><%=data.getIndexedPercentage()%>% <%=ServletResources.getString("complete", request)%></TD></TR>
	<TR><TD><br /><%=ServletResources.getString("IndexingPleaseWait", request)%></TD></TR>
</TABLE>
<script language='JavaScript'>
setTimeout('refresh()', 2000);
</script>
</body>
</html>

<%
	return;
} else {
%>
<div class="bodyTitle" id="bodyTitle">

<div id="totalresult">
	<span id='resultTotal' style='font:<%=prefs.getViewFont()%>;'></span>
</div>

<%
if (data.getSearchViewContributors().size()>0){   // iehsc
%>

<div id="iehsc-tabs" style="margin-left:0px;margin-right:0px;" align='<%=isRTL?"right":"left"%>'>
	<table role="presentation" id="iehsc-task-nav" align='<%=isRTL?"right":"left"%>' border="0" cellspacing="0" cellpadding="0" valign="middle">
		<tr>
			<td id="iehsc-tab-topics" class="iehsc-selected-tab"><a id="topicsNum" onclick="clickTab(false);" href="javascript:void(0)"><span style="display:none;">Topics</span></a></td>
			<td id="iehsc-tab-comments" class="iehsc-nonselected-tab"><a id="commentNum" onclick="clickTab(true);" href="javascript:void(0)"><span style="display:none;">Comments</span></a></td>
		</tr>
	</table>
</div>
<%}%>	
</div>
<div class="bodyContent" id="topic-content">
	<table role="presentation" cellspacing="0" cellpadding="0" border="0">
		<tr height="0">
			<td class="icon"></td>
			<td></td>
		</tr>
		<% 
			String currentCategory = "";
			List<SearchHit> searchHitList = data.getSearchHitList();
			int resultsCount = searchHitList.size();
			int count = -1;
			for (int i = 0; i < searchHitList.size(); i++) {
				count = count + 1;
				SearchHit searchHit1 = (SearchHit)searchHitList.get(i);
				if(data.isActivityFiltering() && !data.isEnabled(searchHit1)){
					continue;
				}
				if(data.isShowCategories()){					
					if(!currentCategory.equals(data.getCategoryLabel(searchHit1))){
						currentCategory = data.getCategoryLabel(searchHit1);
		%>
		<tr id='r_topic<%=count%>'>
			<td colspan="2" class="category" style="padding-<%=isRTL?"left":"right"%>:10px;padding-<%=isRTL?"right":"left"%>:4px;">
				<a href="<%=UrlUtil.htmlEncode(data.getCategoryHref(searchHit1))%>"
						id="a_topic<%=count%>"
						class="link" title="<%=currentCategory%>">
					<%=UrlUtil.htmlEncode(currentCategory)%>
				</a>				
			</td>
		</tr>
		<tr><td colspan="2" height="6px"></td></tr>
		<%count = count + 1;}}%>
		<tr id='r_topic<%=count%>'>
			<td class="icon">
			<%
			boolean isPotentialHit = data.isPotentialHit(searchHit1);
			String href = UrlUtil.htmlEncode(data.getTopicHref(searchHit1));
			if (isPotentialHit) {
			%>
				<img src="../<%=pluginVersion%>/advanced/<%=prefs.getImagesDirectory()%>/d_topic.gif" alt=""/>
			<%}else {%>
				<img src="../<%=pluginVersion%>/advanced/<%=prefs.getImagesDirectory()%>/topic.gif" alt=""/>
			<%}%>
			</td>
			<td>
				<a class='link' id='a_topic<%=count%>' 
				   href="<%=UrlUtil.htmlEncode(data.getTopicHref(searchHit1))%>" 
				   <%
					int lastSlash = href.lastIndexOf("/");
					if (lastSlash>-1) href = href.substring(lastSlash);
					int pos = href.lastIndexOf("?");
					if (pos>-1) href = href.substring(0,pos);
					String label = null;
					if (isPotentialHit)
						label = ServletResources.getString("PotentialHit", data.getTopicLabel(searchHit1), request);
					else
						label = data.getTopicLabel(searchHit1);
					%>
				   title="<%=label%>">				
					        <%=label%>
				</a>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
			<%
			List<SearchHit> similarPageList = new ArrayList<SearchHit>();
			for (int j = i+1; j < searchHitList.size();) {
				SearchHit searchHit2 = (SearchHit)searchHitList.get(j);
				if(data.isShowCategories() && !currentCategory.equals(data.getCategoryLabel(searchHit2))){
					break;
				}				
				if(searchHit1.getLabel().equalsIgnoreCase(searchHit2.getLabel()) &&
						searchHit1.getDescription().equalsIgnoreCase(searchHit2.getDescription())){
					similarPageList.add(searchHit2);
					searchHitList.remove(j);
				}else{
					j++;
				}				
			}
			int similarPageLength = similarPageList.size();
			String desc = data.getTopicDescription(searchHit1);
			if (desc!=null) {
			%>
			<div class="description" style="margin-top:5px;margin-<%=isRTL?"left":"right"%>:5px;margin-bottom:<%=similarPageLength>0?"4px;":"8px;"%>"><%=desc%></div>
			<%}%>
			</td>
		</tr>	
		<%	
			if(similarPageLength > 0){	
				count = count + 1;
		%>
		<tr>
			<td></td>
			<td id="r_topic<%=count%>">
				<div class="similarpages" style="text-align: center;">
					<div style="margin-left:auto; margin-right:auto; "><a href="javascript:void(0)" id="a_topic<%=count%>" onclick="scrollContent('similarpages<%=count%>', this.parentNode.parentNode);return false;" class="similarLinks" title="<%=ServletResources.getString("similarAmount",String.valueOf(similarPageLength),request)%>"><%=ServletResources.getString("similar",String.valueOf(similarPageLength), request) %></a>
					</div>
				</div>
			</td>
		</tr>		
		<tr>
			<td></td>
			<td>
				<div class="similarPagesCss" id="similarpages<%=count%>" style="display:none;height:<%if(data.isIE()){%>0px;<%}else{%>auto;<%}%>">
				<%	
					int similarCount = count;
					for (int k = 0; k < similarPageList.size(); k++) {
						SearchHit similarSearchHit = (SearchHit)similarPageList.get(k);
						if(!data.isEnabled(similarSearchHit)){
							continue;
						}
						similarCount ++;
				%>
					<div style="margin-<%=isRTL?"left":"right"%>:10px;<%if(data.isIE()){%>height:auto;<%}%>">
						<div style="margin-top:8px;">
							<div class="sicon" >
								<%
									if (data.isPotentialHit(similarSearchHit)){
										%>
										<img src="../<%=pluginVersion%>/advanced/<%=prefs.getImagesDirectory()%>/d_topic.gif" alt=""/>
										<%
									}
									else{
										%>
										<img src="../<%=pluginVersion%>/advanced/<%=prefs.getImagesDirectory()%>/topic.gif" alt=""/>
										<%
									}
								%>
							</div>
							<div align='<%=isRTL?"right":"left"%>'>
								<a class='link' id='a_stopic<%=similarCount%>' 
								   href="<%=UrlUtil.htmlEncode(data.getTopicHref(similarSearchHit))%>" 
								   <%
									String similarLabel = null;
									if (data.isPotentialHit(similarSearchHit))
										similarLabel = ServletResources.getString("PotentialHit",data.getTopicLabel(similarSearchHit), request);
									else
										similarLabel = data.getTopicLabel(similarSearchHit);
									%>
								   title="<%=similarLabel%>">									
					        		<%=similarLabel%></a>
							</div>
						</div>
					<% 
					    String breadCrumbInformation = BreadCrumbData.getBreadCrumbPath(similarSearchHit.getHref(), locale.toString());
					    if(null != breadCrumbInformation && breadCrumbInformation.length() > 0){
					%>
						<div class="BreadCrumbInformation" align='<%=isRTL?"right":"left"%>'><%=breadCrumbInformation%></div>
					<% }%>
					<%
					    String criteriaInformation = CriteriaData.getCriteriaInformation(similarSearchHit, locale.toString());
					if(null != criteriaInformation && criteriaInformation.length() > 0){
					%>
					<div class="criteriaInformation" align='<%=isRTL?"right":"left"%>'><%=criteriaInformation%></div>
					<%} %>
					<%
						String description = data.getTopicDescription(similarSearchHit);
						if (description!=null) {
						%>
						<div class="description" align='<%=isRTL?"right":"left"%>' style="margin-<%=isRTL?"right":"left"%>:33px;margin-top:5px;margin-<%=isRTL?"left":"right"%>:20px;margin-bottom:10px;"><%=description%></div>
						<%}%>
					</div>
					<%}%>
				</div>
			</td>
		</tr>
		<%}}
			String[] args = {String.valueOf(resultsCount),data.getSearchWord().replace("\\", "\\\\")};
		String totalResults = UrlUtil.htmlEncode(ServletResources.getString("totalresults",args,request)).replaceAll("&lt;strong&gt;","<strong>").replaceAll("&lt;/strong&gt;","</strong>");
		String topicsNumber = ServletResources.getString("topics",String.valueOf(resultsCount),request);
		String topicsNumberTitle = ServletResources.getString("resultAmount",String.valueOf(resultsCount),request);%>		
	</table>
</div>
<script language="JavaScript">
	var topicsNumbers = <%=resultsCount%>;
	document.getElementById("resultTotal").innerHTML = "<%=totalResults%>";
	if(document.getElementById("topicsNum")){
		document.getElementById("topicsNum").innerHTML = "<%=topicsNumber%>";
		document.getElementById("topicsNum").setAttribute("title","<%=topicsNumberTitle%>");
	}
</script>
<div class="bodyContent" id="comment-content" style="display:none;"></div>
<%
	for(String path: data.getSearchViewContributors()){
		path = path + "?" + request.getQueryString();
%>
	<jsp:include page="<%=path %>" flush="true" /><%}%>
<%}%>
<script language="JavaScript">
	var titleHeight = 0;
	var isRTL = <%=isRTL%>;
	function adjust(){
		var obj = null;
		if (titleHeight==0){
			obj = document.getElementById("iehsc-task-nav");
			if (obj){
				titleHeight = parseInt(titleHeight) + obj.offsetHeight;
			}
			obj = document.getElementById("totalresult");
			if (obj){
				titleHeight = parseInt(titleHeight) + obj.offsetHeight;
			}
		}
		obj = document.getElementById("topic-content");
		if (obj){
			obj.style.height = document.body.offsetHeight - 10-parseInt(titleHeight) +"px";
		}
		obj = document.getElementById("comment-content");
		if (obj){
			 obj.style.height = document.body.offsetHeight - 10-parseInt(titleHeight) +"px";
		}
	}
	window.onresize = function(){
		adjust();
	}
	window.onload = function(){
		adjust();	
	}
</script>
</body>
</html>

