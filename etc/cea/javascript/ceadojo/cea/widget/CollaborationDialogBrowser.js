/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource['cea.widget.CollaborationDialogBrowser']){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource['cea.widget.CollaborationDialogBrowser'] = true;
dojo.provide('cea.widget.CollaborationDialogBrowser');

dojo.require("dojo.io.iframe");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare('cea.widget.CollaborationDialogBrowser', null, {
	//	
	//	summary: A widget for embedding basic browser functionality in the CollaborationDialog
	//
	//	description: 
	//		This widget provides the basic browser history handlers for the back, forward, refresh buttons as well as the location bar handler.
	//
	//	example:
	//	|	dojo.declare('cea.widget.CollaborationDialog', [dijit.Dialog, cea.widget.CollaborationDialogBrowser], {
	//	
	
	_browserHistoryArray: new Array(),
	_browserHistoryPosition: null,

	addButton: function(label, func, icon) {
		// Summary: Add a button to the CollaborationDialog Title Bar
		var b = new dijit.form.Button({baseClass: "collaborationDialogWidgetButton", showLabel:false, iconClass: icon, tabIndex:1});
		b.set('label', label);
		this.connect(b, 'onClick', func);
		this.collaborationDialogButtons.appendChild(b.domNode);
		return b;
	},
	
	addButtonWithLabel: function(label, func, icon) {
		// Summary: Add a button with a label to the CollaborationDialog Title Bar
		var b = new dijit.form.Button({baseClass: "collaborationDialogWidgetButton", showLabel:true, title:label, iconClass: icon, tabIndex:1});
		b.set('label',label);
		this.connect(b, 'onClick', func);
		this.collaborationDialogButtons.appendChild(b.domNode);
		return b;
	},
	
	addToggleButton: function(label, func, icon, show) {
		// Summary: Add a toggle button, including a label if 'show' is true,  to the CollaborationDialog Title Bar
		//backward compatability
		if (show == null){
			show = true;
		}
		
		// Summary: Add a button to the CollaborationDialog Title Bar
		var b = new dijit.form.ToggleButton({
			baseClass: "collaborationDialogWidgetButton",
			showLabel:show, 
			title:label, 
			checked:false,
			tabIndex:1,
			onchange:function() {
				var active = "collaborationDialogWidgetIconActive";
		
				//if active class is not present, add it
				if (! dojo.hasClass(btn.firstChild, active)) {
					dojo.addClass(btn.firstChild, active);
				}
				//if active class is present, remove it 
				else if (dojo.hasClass(btn.firstChild, active)) {
					dojo.removeClass(btn.firstChild, active);
				}
				else {
					console.log("couldn't find either class");
				}
			}, 
			iconClass: icon
		});
	
		b.set('label',label);
		this.connect(b, 'onClick', func);
		this.collaborationDialogButtons.appendChild(b.domNode);
		return b;
	},
	
	cobrowseTextBoxClick: function(e) {
		// summary: When the user clicks the cobrowseTextBox select all the text
		// Only handle this for click because when tabbing into the field this automatically occurs
		console.log("cobrowseTextBoxClick");
		if (this._hasCollaborationControl != true) {
			this.cobrowseTextBox.textbox.focus();
			this.cobrowseTextBox.textbox.select();
		}
	},
	
	cobrowseTextBoxReturn: function(e){
		// summary: Capture when the enter/return key is pressed inside the cobrowseTextBox and then update the iFrame to the new url
		if(dojo.isIE){ // IE
			keynum = e.keyCode;
		} else {
			keynum = e.which;
		}
		
		if(e.keyCode == 13){
			url = this.cobrowseTextBox.get('value');
			dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, url, true);
		}
	},
	
	clearBrowserHistory: function(){
		// summary: Called between session to clear our internal browser history
		this._browserHistoryArray = new Array();
		this._browserHistoryPosition = null;
	},
		
	back: function() {
		// summary: Invoked when the user clicks the 'Back' button for this widget
		if ( this._browserHistoryPosition != 0){
			this._browserHistoryPosition--;
			var uri = this._browserHistoryArray[this._browserHistoryPosition];
			dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, uri, true);
			this.cobrowseTextBox.set('value', uri);	
			
			if ( this._hasCollaborationControl && this._followMeEnabled ){	
				this.sendDataEvent('{"collaborationData":{"url":"' + uri + '"}}');
			}
		}
	},
	
	forward: function() {
		// summary: Invoked when the user clicks the 'Forward' button for this widget
		if ( this._browserHistoryPosition != this._browserHistoryArray.length-1){
			this._browserHistoryPosition++;
			var uri = this._browserHistoryArray[this._browserHistoryPosition];
			dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, uri, true);
			this.cobrowseTextBox.set('value', uri);
			
			if ( this._hasCollaborationControl && this._followMeEnabled ){	
				this.sendDataEvent('{"collaborationData":{"url":"' + uri + '"}}');
			}
		}
	},
	
	refresh: function() {
		// summary: Invoked when the user clicks the 'Refresh' button for this widget
		
		//Starting in Dojo 1.5 dojo.io.iframe.doc no longer works for IE6 and IE7 so we'll just get the uri directly
		//var uri = dojo.io.iframe.doc(this.collaborationDialogContentPane.domNode).location.href;
		
		var uri = this.collaborationDialogContentPane.domNode.contentWindow.document.location.href;
		this.cobrowseTextBox.set('value', uri);
		dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, uri, true);
		
		if ( this._hasCollaborationControl && this._followMeEnabled ){	
			this.sendDataEvent('{"collaborationData":{"url":"' + uri + '"}}');
		}
	},
	
	updateBrowserHistoryArray: function(uri, enableButtons){
		// summary: Controls the browser history array and buttons
		if ( this._browserHistoryPosition == null ){
			this._browserHistoryArray.push(uri);
			this._browserHistoryPosition = 0;
		} else if (uri != this._browserHistoryArray[this._browserHistoryPosition]){
			if (this._browserHistoryPosition < this._browserHistoryArray.length-1){
				var historyElementsToDelete = this._browserHistoryArray.length - this._browserHistoryPosition - 1;
				this._browserHistoryArray.splice(this._browserHistoryPosition + 1, historyElementsToDelete);
			}
			this._browserHistoryArray.push(uri);
			this._browserHistoryPosition++;	
		}
		
		this.updateBrowserHistoryButtons(enableButtons);
	},
	
	updateBrowserHistoryButtons: function(enableButtons){
		// summary: Enables/disables the browser control buttons based on if the widget has control and the position of the browser history
		if ( enableButtons == true){	
			if (this._browserHistoryPosition == 0){
				this.backButton.set("disabled", true);
			} else {
				this.backButton.set("disabled", false);
			}

			if (this._browserHistoryPosition == this._browserHistoryArray.length-1){
				this.forwardButton.set("disabled", true);
			} else {
				this.forwardButton.set("disabled", false);
			}

			if ( this._browserHistoryPosition == null){
				this.refreshButton.set("disabled", true);
			} else {
				this.refreshButton.set("disabled", false);
			}
			
		} else {
			//This widget is not controlling collaboration so disable all the buttons
			this.backButton.set("disabled", true);
			this.forwardButton.set("disabled", true);
			this.refreshButton.set("disabled", true);
		}
	},
	
	_resizeIframe: function() {
		//summary: Fired each time the browser window is resized.  Adjusts the size of the iFrame to keep the header and footer positioned correctly.
		
		//d593577:  Stretch the 'div's to be the full scrolling width of the iframe, if the 
		//horizontal scrollbar is present.  Otherwise, remove widths so that they automatically fill up the screen.
		dojo.style(this.collaborationDialogTitleBar, 'width', "");
		dojo.style(this.collaborationDialogCloseBar, 'width', "");
		dojo.style(this.collaborationDialogMessageArea, 'width', "");
		dojo.style(this.containerNode, 'width', "");
		dojo.style(this.collaborationDialogFooterBar, 'width', "");
		
		var scrWidth = this.domNode.scrollWidth;
		var offWidth = this.domNode.offsetWidth;
		var diffWidth = scrWidth - offWidth;
		
		if (diffWidth>0){
			dojo.style(this.collaborationDialogTitleBar, 'width', scrWidth+"px");
			dojo.style(this.collaborationDialogCloseBar, 'width', scrWidth+"px");
			dojo.style(this.collaborationDialogMessageArea, 'width', scrWidth+"px");
			dojo.style(this.containerNode, 'width', scrWidth+"px");
			dojo.style(this.collaborationDialogFooterBar, 'width', scrWidth+"px");
		}
		
		var calcFrame = this.getCalcFrame();
	  
	  var offsetDim = this.collaborationDialogCloseBar.clientHeight + this.collaborationDialogTitleBar.clientHeight + this.collaborationDialogFooterBar.clientHeight;
		if (this.collaborationDialogMessageArea.style.display != "none"){
			offsetDim = offsetDim + this.collaborationDialogMessageArea.clientHeight;
		}
		
		//Test to see if a horizontal scrollbar is present & add 8 pixels to the offset, if so
		var frameWidth = this.domNode.clientWidth;
		var containerWidth = this.containerNode.clientWidth;
		if (containerWidth>frameWidth){
			offsetDim += 8;
		}
		
		var height = calcFrame - offsetDim;
		dojo.style(this.containerNode, 'height', height+"px");
		this.collaborationDialogContentPane.resize();
		

	},
	
	getCalcFrame: function() {
		var windowHeight;
		if( typeof( window.innerWidth ) == 'number' ) {
			//Non-IE
			windowHeight = window.innerHeight;
		} 
		else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
			//IE 6+ in 'standards compliant mode'
			windowHeight = document.documentElement.clientHeight;
		} 
		else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
			//IE 4 compatible
			windowHeight = document.body.clientHeight;
		}
		
		var cssHeight = "";
		if (dojo.isIE){
  			for (var a=0; a<document.styleSheets.length; a++){	
				var theRules = new Array();
				
				if (document.styleSheets[a].rules){
					for ( var i=0; i<document.styleSheets[a].rules.length; i++){	
						theRules.push(document.styleSheets[a].rules[i]);
					}	
				}
				if (document.styleSheets[a].imports){
					for ( var i=0; i<document.styleSheets[a].imports.length; i++){	
						for ( var j=0; j<document.styleSheets[a].imports[i].rules.length; j++){	
							theRules.push(document.styleSheets[a].imports[i].rules[j]);
						}
					}
				}
				//Iterate thru the rules and find all the CollaborationDialog highlight css rules.
				for ( var i=0; i<theRules.length; i++){
					if ((theRules[i].selectorText.indexOf(".collaborationDialogWidget") != -1) && (theRules[i].selectorText.length==33)){
						cssHeight = theRules[i].style.height;
					}
				}
			}
		}
		else {
		for (var a=0; a<document.styleSheets.length; a++){	
				var theRules = new Array();
				
				if (document.styleSheets[a].cssRules){
					theRules = document.styleSheets[a].cssRules;
				}

				//Iterate thru the rules and find all the CollaborationDialog highlight css rules.
				for ( var i=0; i<theRules.length; i++){	
					if (theRules[i].styleSheet){
						var cssRules = theRules[i].styleSheet.cssRules;
						for ( var j=0; j<cssRules.length; j++){
							if ((cssRules[j].cssText.indexOf(".tundra .collaborationDialogWidget {")!= -1) || (cssRules[j].cssText.indexOf(".tundra .collaborationDialogWidget {")!= -1)){
								cssHeight = cssRules[j].style.height;
							}
						}
					} else {
						if ((theRules[i].cssText.indexOf(".tundra .collaborationDialogWidget {") != -1) || (theRules[i].cssText.indexOf(".tundra .collaborationDialogWidget")!=-1)){
							cssHeight = theRules[i].style.height;
						}
					}
				}
			}
		}
		
		//Convert the % in the height style to a regular number
		var x = cssHeight.indexOf("%");
		var calcFrame = 0;
		if (x > 0){
			cssHeight = cssHeight.substring(0,x);
			cssHeight = cssHeight/100;
			calcFrame = windowHeight*cssHeight;
		}
		//If it's not a %, then use the default of 75%
		else{
			calcFrame = windowHeight*.75;
		}
		return calcFrame;
	},
	
	_identifyNode: function(node){
		//summary: For a given node calls the helper methods to find its id and path function to send to the peer
		var Id = this._identifyNodeId(node);
		var path = this._identifyNodePath(node);
		return '[{"ID":'+ Id + '}, {"PATH":'+ path + '}]';
	},
	
	_identifyNodeId: function(node){
		//summary: For a given node finds the id and nodeName to send to the peer ( example: TD:myTD )
		if (node.id == ""){
			//if no id exists for this node we use null to denote this
			return null;
		}
		var path = "\""+ node.nodeName+':'+node.id + "\"";
		console.log("_identifyNodeId: " + path);
		return path;
	},
	
	_identifyNodePath: function(node){
		//summary: For a given node finds the path to send to the peer ( example:/DIV:2/DIV:1/DIV:3/DIV:1/TABLE:1/TBODY:1/TR:3/TD:1 )
		//  The path is '/' delimited and each part of the path consists of an nodeName and its location as a childNode ( number of that nodeName) of its parent
		var path = '';
		while(node != this.collaborationDialogContentPane.domNode.contentWindow.document.body){
			var parentNode = node.parentNode;
			var nodeName = node.nodeName;
			
			var counter = 0;
			for(var i=0; i<parentNode.childNodes.length; i++){
				if(parentNode.childNodes[i].nodeName === nodeName){
					counter++;
					if(parentNode.childNodes[i] == node){
						break;
					}
				}
			}
			path = '/'+nodeName+':'+counter+path;
			node = parentNode;
		}
		path = "\"" + path + "\"";
		return path;
	},
	
	_findNode: function(dataList){
		//summary: For a given id sent by the peer finds the local node
		//This function first tries to lookup the node by id and if that fails then tries to the path. 
		//If both approaches fail we will return null
		var node = null;
		for (var i=0; i< dataList.length; i++){
			var data = dataList[i];
			if (data.ID && data.ID != null){		
				node = this._findNodeUsingId(data.ID);
			}else if (data.PATH){
				node = this._findNodeUsingPath(data.PATH);
			}
			if (node != null){
				break;
			}
		}
		console.log("_findNode: " + node);
		return node;	
	},
	
	_findNodeUsingId: function(path){
		//summary: For a given Id sent by the peer finds the local node
		//If the node is not found or is not the proper type return null
		console.log("_findNodeUsingId");
		var node = null;
		var document = this.collaborationDialogContentPane.domNode.contentWindow.document;
		
		split = path.split(':');		

        //Since custom tags have ':' in the name we need to do some special processing here
        if (split.length == 3){
            split[0] = split[0] + ":" + split[1];
            split[1] = split[2];
        }

		var node = document.getElementById(split[1]);
		if ((node == null) || (node.nodeName != split[0])){
			return null;
		}
		
		console.log("_findNodeUsingId: " + node);
		return node;
	},

	_findNodeUsingPath: function(path){
		//summary: For a given path sent by the peer finds the local node
		//  The path is '/' delimited and each part of the path consists of an nodeName and its location as a childNode ( number of that nodeName) of its parent
		path = path.split('/');
		var node = this.collaborationDialogContentPane.domNode.contentWindow.document.body;
		for(var i=1; i<path.length; i++){
			split = path[i].split(':');

            //Since custom tags have ':' in the name we need to do some special processing here
            if (split.length == 3){
                split[0] = split[0] + ":" + split[1];
                split[1] = split[2];
            }

			counter = 0;
			for (var j=0; j<node.childNodes.length; j++){
				if(node.childNodes[j].nodeName == split[0]){
					counter++;
					if ( counter == split[1]){
						node = node.childNodes[j];
						break;
					}
				}
				
				if (j == node.childNodes.length - 1){
					//Didn't find the next node in the path so return null
					return null;
				}		
			}	
		}
		console.log("_findNodeUsingPath: " + node);
		return node;
	},
	
	_iFrameOnloadHandler: function() {
		//summary: Invoked each time a new url is loaded in the CollaborationDialog.  
		var iFrameHref = this.collaborationDialogContentPane.domNode.contentWindow.document.location.href;
		console.log("_iFrameOnloadHandler: " + iFrameHref);
		
		//skip adding the style and click handlers if no page is set in the iFrame
		if ( iFrameHref != "about:blank"){
			//Each time a new page load sets the collaborationUri cookie so if the widget page is refreshed we can set the current page
			dojo.cookie("collaborationUri",iFrameHref);
			//set the cobrowseTextBox to the current uri
			this.updateBrowserHistoryArray(iFrameHref, this._hasCollaborationControl);
			this.cobrowseTextBox.set('value', iFrameHref);
			
			this.sendDataEvent('{"collaborationData":{"pageChanged": "'+ iFrameHref +'"}}');
			
			var iframeDoc = this.collaborationDialogContentPane.domNode.contentWindow.document;
			dojo.withDoc(iframeDoc, function() {
				this._addHighlightStyleToIFrame();
				this._addOnclickHandlerToIFrame();
			}, this);		
		}
		this._resizeIframe();
		
		//reset the targets to null to avoid permission denied in IE when highlighting a new element after the page changes
		this.oldSentHighlightTarget = null;
		this.oldReceivedHighlightTarget = null;
		this.oldHoverTarget = null;

        //turn off the highlight button when a new page is loaded, since the event handlers don't exist anymore
        this.highlightButton.set('checked', false);
        this._highlightEnabled = false;
	},

	_addHighlightStyleToIFrame: function(){
		//summary: Finds the highlight css from the page that includes the CollaborationDialog and then adds the css to the iFrame document.
		console.log("Adding highlight style to iFrame");
		
		//Handles IE browser DOM differences for CSS rules.
		if ( dojo.isIE){
			var highlightClass = new Array();
			//Loop thru each of the style elements in the document
			for (var a=0; a<document.styleSheets.length; a++){	
				var theRules = new Array();

				if (document.styleSheets[a].rules){
					for ( var i=0; i<document.styleSheets[a].rules.length; i++){	
						theRules.push(document.styleSheets[a].rules[i]);
					}	
				}
				if (document.styleSheets[a].imports){
					for ( var i=0; i<document.styleSheets[a].imports.length; i++){	
						for ( var j=0; j<document.styleSheets[a].imports[i].rules.length; j++){	
							theRules.push(document.styleSheets[a].imports[i].rules[j]);
						}
					}
				}
				//Iterate thru the rules and find all the CollaborationDialog highlight css rules.
				for ( var i=0; i<theRules.length; i++){	
					if ((theRules[i].selectorText.indexOf(".collaborationDialogWidgetReceivedHighlight") != -1) || (theRules[i].selectorText.indexOf(".collaborationDialogWidgetSentHighlight") != -1)){
						console.log("CollaborationDialog highlight found");
						highlightClass.push(theRules[i].selectorText + " { " + theRules[i].style.cssText + " }");
					}
				}
			}
			//Iterate thru the array and create new style elements in the iFrame document for each rule.
			for (var i=0; i<highlightClass.length; i++){
				console.log("highlightClass: " + highlightClass[i]);
				var styleElement = dojo.doc.createElement("style");
				styleElement.type = "text/css";
				styleElement.styleSheet.cssText = highlightClass[i];
				dojo.doc.getElementsByTagName("head")[0].appendChild(styleElement);	
			}
		} else {
			var highlightClass = new Array();
			//Loop thru each of the style elements in the document
			for (var a=0; a<document.styleSheets.length; a++){	
				var theRules = new Array();
				
				if (document.styleSheets[a].cssRules){
					theRules = document.styleSheets[a].cssRules;
				}

				//Iterate thru the rules and find all the CollaborationDialog highlight css rules.
				for ( var i=0; i<theRules.length; i++){	
					if (theRules[i].styleSheet){
						var cssRules = theRules[i].styleSheet.cssRules;
						for ( var j=0; j<cssRules.length; j++){
							if ((cssRules[j].cssText.indexOf(".collaborationDialogWidgetReceivedHighlight") != -1) || (cssRules[j].cssText.indexOf(".collaborationDialogWidgetSentHighlight") != -1)){
								console.log("CollaborationDialog highlight found in stylesheet");
								highlightClass.push(cssRules[j].cssText);
							}
						}
					} else {
						if ((theRules[i].cssText.indexOf(".collaborationDialogWidgetReceivedHighlight") != -1) || (theRules[i].cssText.indexOf(".collaborationDialogWidgetSentHighlight") != -1)){
							console.log("CollaborationDialog highlight found in style");
							highlightClass.push(theRules[i].cssText);
						}
					}
				}
			} 
			//Iterate thru the array and create new style elements in the iFrame document for each rule.
			for (var i=0; i<highlightClass.length; i++){
				console.log("highlightClass: " + highlightClass[i]);
				var styleElement = dojo.doc.createElement("style");
				styleElement.type = "text/css";
				styleElement.appendChild(document.createTextNode(highlightClass[i]));
				dojo.doc.getElementsByTagName("head")[0].appendChild(styleElement);
			}
		}
	},
	
	_addOnclickHandlerToIFrame: function(){
		//summary: Adds the onclick handler to the iFrame document each time a new document is loaded.
		console.log("Adding onclick handler to iFrame");
		dojo.connect(dojo.doc, "onclick", this, this.click);
	},

	_simulateClickEvent: function(node) {
		//summary: Simulate the appropriate browser click on a given node.
		if( dojo.isIE ){
			node.click();
		} else {
			var evt = document.createEvent("MouseEvents");
			evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
			node.dispatchEvent(evt);
		}
		
		//Firefox does not execute a HREF Javascript call when a click is simulated
		//So for this scenario we need to pull out the script and execute it manually
		if ( dojo.isFF && node.href && node.href.toLowerCase().indexOf("javascript:") > -1){	
			js = node.href.split(":")[1];
			this.collaborationDialogContentPane.domNode.contentWindow.eval(js);
		}
	}
	
});

}
