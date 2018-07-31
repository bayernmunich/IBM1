/*******************************************************************************
 * Copyright (c) 2000, 2010 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Pierre Candela  - fix for Bug 194911
 *******************************************************************************/

var isIE = navigator.userAgent.indexOf('MSIE') != -1;

function toggleAutosynch(button) {
    var tocFrame = window.parent.tocViewFrame;
    tocFrame.toggleAutosynch();
    if (tocFrame.isAutosynchEnabled()) {
        try {
		    parent.parent.parent.parent.ContentFrame.ContentToolbarFrame.autosynch();
	    } catch(e){
	    }
    }
    if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function toggleShowAll(button){
	window.parent.parent.toggleShowAll();
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function toggleShowCategories(button){
	parent.searchViewFrame.toggleShowCategories();
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function toggleShowDescriptions(button){
	parent.searchViewFrame.toggleShowDescriptions();
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function removeBookmark(button){
	try {
		parent.bookmarksViewFrame.removeBookmark();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function removeAllBookmarks(button){
	try {
		parent.bookmarksViewFrame.removeAllBookmarks();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function filter(button){
	window.parent.parent.selectScope();
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function printTopic(errorMsg) {
	var isSelectedTopicPrint = true;
	printContent(errorMsg, isSelectedTopicPrint);
}

function printToc(errorMsg) {
	var isSelectedTopicPrint = false;
	printContent(errorMsg, isSelectedTopicPrint);
}

function printContent(errorMsg, isSelectedTopicPrint){
	var topic = parent.tocViewFrame.getSelectedTopic();
	if (topic && topic != ":blank") {
		if(topic.indexOf(".pdf")!=-1)
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.window);
		else 
			contentRect = getWindowBounds(parent.parent.parent.parent.ContentFrame.ContentViewFrame.window);
		var topRect = getWindowBounds(parent.parent.parent.parent.parent);
		var w = contentRect.width;
		var h = topRect.height;
		var x = topRect.x + (topRect.width - w)/2;
		var y = topRect.y;
		var indexAnchor=topic.indexOf('#');
	    var parameters;			
	    if (indexAnchor!=-1) {
		    var anchor=topic.substr(indexAnchor+1);
		    topic=topic.substr(0,indexAnchor);
		    parameters = "?topic="+topic+"&anchor="+anchor;	
	     } else {
		    parameters = "?topic="+topic;
	     }
	    if(isSelectedTopicPrint){
	    	parameters += "&isSelectedTopicPrint=true";
	    }
		var printWindow = window.open("print.jsp" + parameters, "printWindow", "directories=yes,location=no,menubar=yes,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=yes,width=" + w + ",height=" + h + ",left=" + x + ",top=" + y);
	}
	else {
		alert(errorMsg);
	}
}

function collapseAll(button) {
    try {
		parent.tocViewFrame.collapseAll();
	} catch(e){
	}
	if (button && document.getElementById(button)){
		document.getElementById(button).focus();
	}
}

function getWindowBounds(window) {
	var rect = new Object();
	if (window.screenLeft) {
		rect.x = window.screenLeft;
		rect.y = window.screenTop;
	}
	else {
		rect.x = window.screenX;
		rect.y = window.screenY;
	}

	if (window.innerWidth) {
		rect.width = window.innerWidth;
		rect.height = window.innerHeight;
	}
	else {
		rect.width = window.document.body.clientWidth;
		rect.height = window.document.body.clientHeight;
	}
	return rect;
}

function getSearchWord() {
    var navFrame = parent.parent.parent;
	var searchFrame = navFrame.parent.parent.HelpToolbarFrame.frames["SearchFrame"];
	return searchFrame.document.forms["searchForm"].searchWord.value;
}

function quickSearchTopic(errorMsg) {
	quickSearch("QuickSearchTopic", errorMsg);
}

function quickSearchToc(errorMsg) {
	quickSearch("QuickSearchToc", errorMsg);
}

function quickSearch(quickSearchType, errorMsg) {		//search this topic and all subTopics
	var topic = parent.tocViewFrame.getSelectedTopic();
	if (topic) {
		var node = parent.tocViewFrame.getActiveAnchor();
		var treeItem = parent.tocViewFrame.getTreeItem(node);
        if (!treeItem) { return; }  // TODO need better error
	    var parameters = "?searchWord=" + getSearchWord();
	    parameters = parameters + "&quickSearchType=" + quickSearchType;
	     
	    // Defect 593: resize search window     2/2
	    var w = 315;
		var h = 120;
		if (isIE){		
			var l = top.screenLeft + (top.document.body.clientWidth - w) / 2;
			var t = top.screenTop + (top.document.body.clientHeight - h) / 2;		
		} else {		
			var l = top.screenX + (top.innerWidth - w) / 2;
			var t = top.screenY + (top.innerHeight - h) / 2;		
		}		
		// move the dialog just a bit higher than the middle
		if (t-50 > 0) t = t-50;
	  	window.location="javascript://needModal";  
	  	// Defect 593 ends

		var quickSearchWindow = window.open("quickSearch.jsp" + parameters, "QuickSearch", "location=no, status=no,resizable=yes,height="+h+",width="+w +",left="+l+",top="+t);		
	    quickSearchWindow.focus();
	}
	else {
		alert(errorMsg);
	}	
}


function getScope(){
	var helpToolbarFrame = window.top.HelpToolbarFrame;
	var searchFrame = helpToolbarFrame.frames["SearchFrame"];
	return searchFrame.document.forms["searchForm"].workingSet.value;
}


function searchFor(searchWord, quickSearchType) {  
	var node = parent.tocViewFrame.getActiveAnchor();
	var treeItem = parent.tocViewFrame.getTreeItem(node);
    var topAncestor = parent.tocViewFrame.getTopAncestor(treeItem);
    if (!topAncestor) { return; } 
	var toc = topAncestor.nodeid;
	var maxHits = 500;
	var query ="searchWord="+encodeURIComponent(searchWord)+"&maxHits="+maxHits + "&quickSearch=true&toc="+toc +"&quickSearchType=" + quickSearchType;
    if (topAncestor !== treeItem) {
        query += "&path=";
        query += treeItem.nodeid;
    }
	
	var scope =  getScope();
	query += "&scope="+scope;
	
    var navFrame = parent.parent.parent;
	var searchFrame = navFrame.parent.parent.HelpToolbarFrame.frames["SearchFrame"];
	navFrame.showView('search');
	var searchView = navFrame.ViewsFrame.search.searchViewFrame;
	searchView.location.replace("searchView.jsp?"+query);	
	searchFrame.document.forms["searchForm"].searchWord.value	= searchWord;
}

function toggleHiddenCategoriesButton(){
	document.getElementById("tdb_show_categories").style.display = "none";
}

function toggleShowCategoriesButton(){
	document.getElementById("tdb_show_categories").style.display = "";
}
