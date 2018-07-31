/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
 
// Common scripts for IE and Mozilla.
// requires utils.js

var isMozilla = navigator.userAgent.indexOf('Mozilla') != -1 && parseInt(navigator.appVersion.substring(0,1)) >= 5;
var isIE = navigator.userAgent.indexOf('MSIE') != -1;

// selected node
var active;
var oldActive;

/**
 * Returns the row of this click
 */
function getTRNode(node) {
  if (node.nodeType == 3){  //"Node.TEXT_NODE") 
	return node.parentNode.parentNode.parentNode;
  } else if (node.tagName == "A"){
	  if(node.parentNode.tagName == "DIV"){
		  return node.parentNode.parentNode.parentNode; 
	  }
	  return node.parentNode.parentNode; 
  } else if (node.tagName == "TD"){
	  return node.parentNode;
  } else if (node.tagName == "TR"){
	  return node;
  } else if (node.tagName == "IMG"){
	  return node.parentNode.parentNode.parentNode;
  } else{
	  return null;
  }  	
}

function getFocusId(trId, isNext){
	var aId = "a" + trId.substring(1);
	var index = 0;
	for(var i=0;i<trId.length;i++){
		var c = trId.charAt(i);
		if(c<=9 && c>=0){
			index = i;
			break;
		}
	}
	var aId_number = parseInt(aId.substring(index));
	var aId_number = isNext?aId_number + 1:aId_number - 1;
	if(aId_number >= 0){
		return document.getElementById(aId.substring(0, index) + aId_number);
	}else{
		return null;
	}	
}

/**
 * Returns the anchor node in this row
 */
function getAnchorNode(tr)
{
	var id = tr.id.substring(1);	
	return document.getElementById("a"+id);
}

/**
 * Return next item in the list
 */
function getNextDown(node)
{
	if(node.className == "similarLinks"){
		var number = node.id.substring("a_topic".length);
		var obj = document.getElementById("similarpages" + number);
		if(obj && obj.style.display == "block"){
			return document.getElementById("a_stopic" + (parseInt(number) + 1));
		}else{
			return document.getElementById("a_topic" + (parseInt(number) + 1));
		}
	}else if(node.id.indexOf("a_stopic") > -1){
		var number = node.id.substring("a_stopic".length);
		var obj = document.getElementById("a_stopic" + (parseInt(number) + 1));
		if(!obj){
			number = node.parentNode.parentNode.parentNode.parentNode.id.substring("similarpages".length);
			obj = document.getElementById("a_topic" + (parseInt(number) + 1));			
		}
		return obj;
	}else{
		var tr = getTRNode(node);
		if (tr == null) return null;
		return getFocusId(tr.id, true);
	}	
}

/**
 * Return previous item in the list
 */
function getNextUp(node)
{
	if(node.id.indexOf("a_stopic") > -1){
		var number = node.id.substring("a_stopic".length);
		var obj = document.getElementById("a_stopic" + (parseInt(number) - 1));
		if(!obj){
			obj = document.getElementById("a_topic" + (parseInt(number) - 1));
		}
		return obj;
	}else{
		var tr = getTRNode(node);
		if (tr == null) return null;
		var obj = getFocusId(tr.id, false);
		if(obj && obj.className == "similarLinks"){
			var number = obj.id.substring("a_topic".length);
			var similarPages = document.getElementById("similarpages" + number);
			if(similarPages && similarPages.style.display == "block"){
				number = parseInt(number) + 1;
				obj = document.getElementById("a_stopic" + number);
				while(obj){
					number++;
					obj = document.getElementById("a_stopic" + number);
				}
				obj = document.getElementById("a_stopic" + (number-1));
			}
		}
		return obj;
	}	
}

var oldTrClassName = "";
var oldAClassName = "";
/**
 * Highlights link. Returns true if highlights.
 */
function highlightTopic(topic)
{
	if (!topic || (topic.tagName != "A" && topic.parentNode.tagName != "A"))
		return false;
		
	if (topic.className =="similarLinks") return false;	
	
	
  	var tr = getTRNode(topic);
	
 	if (tr != null)
  	{
  	   	if (oldActive && oldActive != tr) {
  	   		oldActive.className = oldTrClassName;  
  	   		var oldA = active;  	   				 
    		if (active) oldA.className = oldAClassName;
  	   	}
    
		oldActive = tr;
		oldTrClassName = tr.className;
		var a = null;
		if(tr.tagName == "TR"){
			tr.className = "active";
			a = getAnchorNode(tr);
		}else if(tr.tagName == "DIV"){
			a = topic;
		}  		 
  		if (a)
  		{
  			oldAClassName = a.className;
  			a.className = "active";
  			// set toolbar title
  			if (a.onclick)
  				a.onclick();
  			//if (isIE)
  			//	a.hideFocus = "true";
   		}
   		active = a;
   		return true;
  	}
  	return false;
}

/**
 * Selects a topic in the tree: expand tree and highlight it
 */
function selectTopic(topic) 
{
	if (!topic || topic == "") return;
	
	var links = document.getElementsByTagName("a");

	for (var i=0; i<links.length; i++)
	{
		// take into account the extra ?toc=.. or &toc=
		if (links[i].href.indexOf(topic+"?toc=") == 0 ||
			links[i].href.indexOf(topic+"&toc=") == 0 ||
			links[i].href.indexOf(topic+"/?toc=") == 0)
		{
			highlightTopic(links[i]);
			scrollUntilVisible(links[i], SCROLL_VERTICAL);
			links[i].scrollIntoView(true);
			return true;
		}
	}
	return false;
}

/**
 * Selects a topic in the list
 */
function selectTopicById(id)
{
	var topic = document.getElementById(id);
	if (topic)
	{
		highlightTopic(topic);
		scrollUntilVisible(topic, SCROLL_VERTICAL);
		return true;
	}
	return false;
}

function hidePopupMenu() {
	// hide popup if open
	var menu = document.getElementById("menu");
	if (!menu)
		return;
	if (menu.style.display == "block")
		menu.style.display = "none";
}

var popupMenuTarget;

function showPopupMenu(e) {
	// show the menu
	var x = e.clientX;
	var y = e.clientY;

	e.cancelBubble = true;

	var menu = document.getElementById("menu");
	if (!menu) 
		return;	
	menu.style.left = (x+1)+"px";
	menu.style.top = (y+1)+"px";
	menu.style.display = "block";
	if (isMozilla)
		popupMenuTarget = e.target;
}

/**
 * display topic label in the status line on mouse over topic
 */
function showStatus(e) {
	try {
		var overNode;
		if (isIE)
			overNode = window.event.srcElement;
		else
			overNode = e.target;

		overNode = getTRNode(overNode);
		if (overNode == null) {
			window.status = "";
			return true;
		}

		if (!isIE)
			e.cancelBubble = false;

		var a = getAnchorNode(overNode);
		var statusText = "";
		if (isIE)
			statusText = a.innerText;
		else 
			statusText = a.lastChild.nodeValue;
			
		if (a.title && statusText != a.title)
			statusText += " - " + a.title;
			
		window.status = statusText;
	} catch (e) {
	}

	return true;
}

function clearStatus() {
	window.status="";
}

/**
 * Popup a menu on right click over a bookmark.
 */
function contextMenuHandler(e)
{
	// hide popup if open
	hidePopupMenu();

	if (isIE)
		e = window.event;
		
  	var clickedNode = getEventTarget(e);

  	if (!clickedNode)
  		return true;
  	
  	// call the click handler to select node
  	mouseClickHandler(e);
  	
  	if(clickedNode.tagName == "A")
  		active = clickedNode;
  	else if (clickedNode.parentNode.tagName == "A")
  		active = clickedNode.parentNode;
  	else
  		return true;
	
	showPopupMenu(e);
	
	return false;
}

/**
 * handler for clicking on a node
 */
function mouseClickHandler(e) {

	if (isIE || e && e.target && e.target != popupMenuTarget)
		hidePopupMenu();
		
  	var clickedNode = getEventTarget(e);
  	
  	highlightTopic(clickedNode);
}


function focusHandler(e)
{
	if (oldActive){
		try{
			oldActive.focus();
		} catch (e) {
		}
	}
}

/**
 * Handler for key down (arrows)
 */
function keyDownHandler(e)
{
	var key;

	if (isIE) {
		key = window.event.keyCode;
	} else {
		key = e.keyCode;
	}

	if (key != 38 && key != 40) {
		return true;
	}
	
	var clickedNode = getEventTarget(e);
    if (!clickedNode) {
        return;
    }
	    
  	cancelEventBubble(e);
  	
  	if (key == 40 ) { // down arrow
		var next = getNextDown(clickedNode);
  		//highlightTopic(next);
		if (next) {
		    next.focus();
		    // Scroll a little beyond this element so the description
		    // of a search result shows in full
			var sibling1 = getTRNode(next).nextSibling;
			if (sibling1 !== null) {
			    var sibling2 = sibling1.nextSibling;
			    if (sibling2 !== null) {
			        scrollUntilVisible(sibling2, SCROLL_VERTICAL + SCROLL_LEFT);
			    } else {		        
			        scrollUntilVisible(sibling1, SCROLL_VERTICAL + SCROLL_LEFT);
			    }
			} else {
			    scrollUntilVisible(next, SCROLL_VERTICAL + SCROLL_LEFT); 
			}
			return false;
		} 
  	} else if (key == 38 ) { // up arrow
		var next = getNextUp(clickedNode);
		//highlightTopic(next);
		if (next) {
			next.focus();
			scrollUntilVisible(getTRNode(next), SCROLL_VERTICAL + SCROLL_LEFT);
			return false;
		}
  	}
  	// Keystroke not consumed 
  	return true;
  				
}


// listen for events
 
if (isIE){
  document.onclick = mouseClickHandler;
  document.onkeydown = keyDownHandler;
  window.onfocus = focusHandler;
} else {
  document.addEventListener('click', mouseClickHandler, true);
  document.addEventListener('keydown', keyDownHandler, true);
  //document.addEventListener("focus", focusHandler, true);
	if (isSafari) {
		// workaround for lack of good system colors in Safari
		document.write('<style type="text/css">');
		document.write('.active {background:#B5D5FF;color:#000000;}');
		document.write('</style>');
	}
}
