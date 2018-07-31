/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.mobile.widget.CollaborationDialog"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.mobile.widget.CollaborationDialog"] = true;

dojo.provide("cea.mobile.widget.CollaborationDialog");

dojo.require("cea.mobile.widget.iFrame");
dojo.require('cea.widget.CollaborationDataTransfer');
dojo.require('cea.widget.CollaborationDialogBrowser');

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.layout.BorderContainer");
dojo.require('dijit.layout.LayoutContainer');
dojo.require("dojo.io.iframe");
dojo.require('dojox.layout.ContentPane');
dojo.require('dijit.layout.ContentPane');

dojo.requireLocalization("cea.widget", "CollaborationDialog", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");
dojo.requireLocalization("cea.mobile.widget", "CollaborationDialog", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.mobile.widget.CollaborationDialog", [dijit._Widget, dijit._Templated, cea.widget.CollaborationDataTransfer, cea.widget.CollaborationDialogBrowser], {
	
	//	
	//	summary: A widget for embedding collaboration dialog functionality into other widgets.
	//
	//	description: 
	//		This widget provides a modal dialog	that extends the cea.widget.CollaborationDataTransfer to share pages, links, etc with a peer.
	//      Specifically this widget provides the event handlers to style the modal dialog and send data to the peer as well as the result handlers that
	//		are invoked when data is received.
	//
	//	example:
	//	|	<div dojoAttachPoint="collaborationDialog" dojoType="cea.widget.CollaborationDialog" canControlCollaboration="true"></div>
	//	
	
	templateString:"<div class=\"collaborationDialogWidget\" tabindex=\"-1\">\n\t\n\t<div dojoType=\"dijit.layout.BorderContainer\" design=\"headline\" gutters=\"false\" liveSplitters=\"true\" dojoAttachPoint=\"collaborationDialogBorderContainer\" class=\"collaborationDialogBorderContainer\">\n\t\n\t\t<!-- ------------------------------------------------------------------------ -->\n\t\n\t\t<div dojoType=\"dijit.layout.ContentPane\" splitter=\"false\" region=\"top\" dojoAttachPoint=\"collaborationDialogBorderContainerTop\" class=\"collaborationDialogBorderContainerTop\">\n\t\t\t<div dojoAttachPoint=\"collaborationDialogButtons\" class=\"collaborationDialogWidgetTitleBar\"></div>\n\t\t\t<div dojoAttachPoint=\"collaborationDialogLocationBar\" class=\"collaborationDialogWidgetLocationBar\" style=\"display:none\"></div>\n\t\t</div>\n\t\t\n\t\t<!-- ------------------------------------------------------------------------ -->\n\t\n\t\t<div dojoType=\"dijit.layout.ContentPane\" splitter=\"false\" region=\"center\" dojoAttachPoint=\"collaborationDialogBorderContainerCenter\" class=\"collaborationDialogBorderContainerCenter\">\n\t\n\t\t\t<div dojoAttachPoint=\"collaborationDialogMessageArea\" class=\"collaborationDialogWidgetMessages\" style=\"display:none\">\n\t\t\t\t<table width=\"100%\">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td width=\"5%\" align=\"middle\" dojoAttachPoint=\"collaborationDialogMessageAreaIcon\" class=\"collaborationDialogWidgetMessages\"></td>\n\t\t\t\t\t\t<td width=\"90%\" align=\"right\" dojoAttachPoint=\"collaborationDialogMessageAreaMessage\" class=\"collaborationDialogWidgetMessages\"></td>\n\t\t\t\t\t\t<td width=\"5%\" align=\"right\" dojoAttachPoint=\"collaborationDialogMessageAreaAction\" class=\"collaborationDialogWidgetMessages\">\n\t\t\t\t\t\t\t<span dojoAttachPoint=\"collaborationDialogMessageOKButtonNode\" class=\"collaborationDialogCloseMessageIcon collaborationDialogWidgetIcon collaborationDialogWidgetAcceptIcon\" dojoAttachEvent=\"onclick: hideMessageArea\" style=\"display:none\"></span>\n\t\t\t\t\t\t\t<span dojoAttachPoint=\"collaborationDialogMessageCloseButtonNode\" class=\"collaborationDialogCloseMessageIcon collaborationDialogWidgetIcon collaborationDialogWidgetCloseIcon\" dojoAttachEvent=\"onclick: hideMessageArea\" style=\"display:none\"></span>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t\n\t\t\t<div dojoAttachPoint=\"containerNode\" class=\"collaborationDialogPaneContent\">\n\t\t\t\t<div dojoAttachPoint=\"collaborationDialogIFrame\" dojoType=\"cea.mobile.widget.iFrame\"></div>\n\t\t\t</div>\n\n\t\t</div>\n\t\n\t\t<!-- ------------------------------------------------------------------------ -->\n\t\t\n\t\t<div dojoType=\"dijit.layout.ContentPane\" splitter=\"false\" region=\"bottom\" dojoAttachPoint=\"collaborationDialogBorderContainerBottom\" class=\"collaborationDialogBorderContainerBottom\">\n\n\t\t\t<div dojoAttachPoint=\"collaborationDialogFooterBar\" class=\"dijitDialogTitleBar collaborationDialogWidgetFooterBar\">\n\t\t\t\t<table width=\"100%\">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td align=\"left\" dojoAttachPoint=\"collaborationDialogConnectionStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetConnectedIcon\" style=\"display:inline-block; vertical-align:middle\"></span> ${connectedString}</td>\n\t\t\t\t\t\t<td align=\"center\" dojoAttachPoint=\"collaborationDialogPeerWindowStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsClosedIcon\" style=\"display:inline-block; vertical-align:middle\"></span> ${peerWindowClosedString}</td>\n\t\t\t\t\t\t<td align=\"right\" dojoAttachPoint=\"collaborationDialogActionStatusStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseWebIcon\" style=\"display:inline-block; vertical-align:middle\"></span> ${cobrowsingWebString}</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t\n\t\t<!-- ------------------------------------------------------------------------ -->\n\t\t\n\t</div>\n\t\n</div>\n",
	widgetsInTemplate: true,
	
	//defaultCollaborationUri: String
	//		A string containing the default Uri that CollaborationDialog will load by default
	defaultCollaborationUri: "",
	//	highlightElementList: String
	//		A string containing the comma separated list of HTML elements that can be highlighted
	highlightElementList: "DIV,SPAN,TR,TH,TD,P",
	//	isHighlightableCallback: String
	//		A string containing the name of the callback function to execute to determine if the current element is highlightable.
	//		If null this will be skipped and only the highlightElementList will be used.
	isHighlightableCallback: "",	
	//	isClickableCallback: String
	//		A string containing the name of the callback function to execute to determine if the current element is clickable.
	//		This is useful to stop certain actions from being executed when follow me mode is enabled.
	isClickableCallback: "",
	//	sendPageUrlRewriteCallback: String
	//		A string containing the name of the callback function to execute when send page is called to rewrite the current URL.
	//		This is useful when one of the peers will be using an Ajax Proxy to access the pages.
	sendPageUrlRewriteCallback: "",
	
	_highlightElementArray: null,
	_followMeEnabled: false,
	
	postMixInProperties: function() {
	      this.inherited(arguments);
	      this.initializeStrings();
	      //Convert the comma separated string of highlightable elements into an array
	      this._highlightElementArray = this.highlightElementList.split(",");
	},
	
	cobrowseTextBoxReturn: function(e){
		// summary: Capture when the enter/return key is pressed inside the cobrowseTextBox and then update the iFrame to the new url
		enterKeyPressed = false;
		
		//iOS3 uses a different keyCode for the return button than iOS4 and Android
		if(navigator.userAgent.match(/OS 3/i)) {
			if(e.keyCode == 10){
				enterKeyPressed = true;
			}
		} else {
			if(e.keyCode == 13){
				enterKeyPressed = true;
			}
		}
		
		if (enterKeyPressed){
			
			url = this.cobrowseTextBox.get('value');
			dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, url, true);
			
			e.cancelBubble = true;
			e.returnValue = false;
		}
	},
	
	postCreate: function() {
	
		//Hitch the handleResult function to a variable so it can be added/removed as an event handler
		this._handleResultHitch = dojo.hitch(this,"handleResult");

		this.collaborationDialogContentPane = new dojox.layout.ContentPane({executeScripts:"true", scriptHasHooks:"true", adjustPaths:"true"}, this.collaborationDialogContentPane);
		this.collaborationDialogContentPane.startup();
		
		//connect to the onbeforeunload to send that the dialog is closed
		dojo.connect(window, 'onbeforeunload', this, this.onBeforeUnload);
		
		this.backButton = this.addButton(this.backButtonString, 'back', 'collaborationDialogWidgetIcon ');
		this.forwardButton = this.addButton(this.forwardButtonString, 'forward', 'collaborationDialogWidgetIcon collaborationDialogWidgetForwardIcon');
		this.refreshButton = this.addButton(this.refreshButtonString, 'refresh', 'collaborationDialogWidgetIcon collaborationDialogWidgetRefreshIcon');
		
		this.cobrowseTextBox = new dijit.form.TextBox({baseClass: "dijit dijitReset dijitLeft dijitTextBox collaborationDialogWidgetTextBox", value:this.defaultCollaborationUri});
		
		//Add an accessible label to the cobrowseTextBox
		var label = dojo.doc.createElement("label");
		label.title = this.collabTitleString;
		label.htmlFor = this.cobrowseTextBox.textbox.id;
		this.collaborationDialogLocationBar.appendChild(label);
		this.collaborationDialogLocationBar.appendChild(this.cobrowseTextBox.domNode);

		//Add an accessible tabIndex to the cobrowseTextBox
		this.cobrowseTextBox.textbox.tabIndex = 1;
		
		dojo.connect(this.cobrowseTextBox.domNode, 'onkeypress', this, this.cobrowseTextBoxReturn);
		dojo.connect(this.cobrowseTextBox.domNode, 'onclick', this, this.cobrowseTextBoxClick);
			
		this.sendPageButton = this.addButton(this.sendPageButtonString, 'sendPage', 'collaborationDialogWidgetIcon collaborationDialogWidgetSendPageIcon');
		this.followMeButton = this.addToggleButton(this.followMeButtonString, 'followMe', 'collaborationDialogWidgetIcon collaborationDialogWidgetFollowMeIcon', false);
		this.grantControlButton = this.addButton(this.grantControlButtonString, 'grantControl', 'collaborationDialogWidgetIcon collaborationDialogWidgetControlNavigationIcon');
		this.highlightButton = this.addToggleButton(this.highlightButtonString, 'highlight', 'collaborationDialogWidgetIcon collaborationDialogWidgetHighlightIcon', false);
		this.locationBarButton = this.addToggleButton(this.showLocationBarButtonString, 'locationBar', 'collaborationDialogWidgetIcon collaborationDialogWidgetShowAddressFieldIcon', false);
		
		this.inherited(arguments);
		
		window._ceaCollabDialog = this;
		
		//The iPhone automatically adds padding to these buttons so we need to code a similar padding for Android since we can't add it into the css
		if(navigator.userAgent.match(/Android/i)) { 
			dojo.style(this.backButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.forwardButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.refreshButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			
			dojo.style(this.sendPageButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.followMeButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.grantControlButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.highlightButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
			dojo.style(this.locationBarButton.domNode.childNodes[0].childNodes[0], "padding", "0px 5px 0 5px");
		}
		
		//Since the iFrame is now nested inside a new widget we'll assign it to the original attachPoint to it so we can re-use code
		this.collaborationDialogContentPane.domNode = this.collaborationDialogIFrame.mobileIFrame;
		dojo.connect(this.collaborationDialogContentPane.domNode, "onload", this, this._iFrameOnloadHandler);
	
		this.collaborationDialogContentPane.domNode.title = this.collabTitleString;
		
	},
	
	initializeStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget 
		this._messages = dojo.i18n.getLocalization("cea.widget", "CollaborationDialog", this.lang);
		
		this.collabDialogTitleString = "";
		this.collabTitleString = this._messages["COLLAB_TITLE"];
    	this.coauthorFormString = this._messages["COAUTHOR_FORM"];
		this.connectedString = this._messages["CONNECTED"];
		this.disconnectedString = this._messages["DISCONNECTED"];
		this.peerWindowOpenString = this._messages["PEER_WINDOW_OPEN"];
		this.peerWindowClosedString = this._messages["PEER_WINDOW_CLOSE"];
		this.cobrowsingWebString = this._messages["COBROWSING_WEB"];
		this.controllingNavigationString = this._messages["CONTROLLING_NAVIGATION"];
		this.backButtonString = this._messages["BACK_BUTTON"];	
		this.forwardButtonString = this._messages["FORWARD_BUTTON"];	
		this.refreshButtonString = this._messages["REFRESH_BUTTON"];	
		this.sendPageButtonString = this._messages["SEND_PAGE_BUTTON"];
		this.followMeButtonString = this._messages["FOLLOW_ME_BUTTON"];
		this.grantControlButtonString = this._messages["GRANT_CONTROL_BUTTON"];	
		this.highlightButtonString = this._messages["HIGHLIGHT_BUTTON"];	

		this._messages = dojo.i18n.getLocalization("cea.mobile.widget", "CollaborationDialog", this.lang);
		
		this.controlGrantedByPartnerString = this._messages["CONTROL_GRANTED"];
		this.unableToHighlightString = this._messages["UNABLE_TO_HIGHLIGHT"];
		this.unableToFollowString = this._messages["UNABLE_TO_FOLLOW"];
		this.peerUnableToFollowString = this._messages["PEER_UNABLE_TO_FOLLOW"];
		this.pagesNotInSyncString = this._messages["NO_LONGER_SYNCHRONIZED_SEND_PAGE"];
		this.eventPollingReplacedString = this._messages["EVENT_POLLING_REPLACED"];
		this.eventPollingFailedString = this._messages["EVENT_POLLING_FAILED"];
		this.failoverEventActiveString = this._messages["FAILOVER_EVENT_ACTIVE"];
		this.failoverEventPassiveString = this._messages["FAILOVER_EVENT_PASSIVE"];
		
		this.showLocationBarButtonString = this._messages["SHOW_LOCATION_BAR_BUTTON"];
		this.hideLocationBarButtonString = this._messages["HIDE_LOCATION_BAR_BUTTON"];
	},
	
	setSize: function(height, width){
		console.log("setSize: " + height + " " + width);
		dojo.style(this.collaborationDialogBorderContainer.domNode, "height", height + "px");
		dojo.style(this.collaborationDialogBorderContainer.domNode, "width", width + "px");
		this.resize();
	},
	
	_resizeIframe: function(){
		//this.collaborationDialogIFrame.resize();
	},
	
	resize: function(){
		this.inherited(arguments);
		
		borderContainerHeight = this.collaborationDialogBorderContainer.domNode.offsetHeight;
		borderContainerWidth = this.collaborationDialogBorderContainer.domNode.offsetWidth;
		
		topHeight = this.collaborationDialogBorderContainerTop.domNode.offsetHeight;
		bottomHeight = this.collaborationDialogBorderContainerBottom.domNode.offsetHeight;
		
		//offsetHeight will be 0 if the messageArea is hidden
		messageAreaHeight = this.collaborationDialogMessageArea.offsetHeight;
		
		height = borderContainerHeight - topHeight - messageAreaHeight - bottomHeight;
		width = borderContainerWidth;
		
		dojo.style(this.collaborationDialogIFrame.mobileIFrameContainer, "height", height + "px");
		dojo.style(this.collaborationDialogIFrame.mobileIFrameContainer, "width", width + "px");
		
		this.collaborationDialogIFrame.resize();
		
		window.scrollTo(0, 1);
		
	},
	
	resetCollaborationDialog: function(){
		// summary: Used to reset the collaboration dialog to the defaultUri in between collaboration sessions
		console.log("Resetting the CollaborationDialog to the initial state");
		//clear the browser history array
		this.clearBrowserHistory();
		this.cobrowseTextBox.set('value', this.defaultCollaborationUri);
		dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, this.defaultCollaborationUri, true);
		//Clear the cookie in between collaboration sessions
		dojo.cookie("collaborationUri",null);
		
		//Reset all toggle buttons to un-toggled state
		this.followMeButton.set('checked', false);
		this.highlightButton.set('checked', false);
		 
	},
	
	openCollaborationDialog: function(){
		// summary: Invoked when the user clicks the 'Open Collaboration Dialog' button for this widget
		
		//Due a to a bug in iOS4 Safari we have to hide the iFrame's content before the slide transition.
		//So in closeCollaborationDialog we hide it and in openCollaborationDialog we unhide it
		if (navigator.userAgent.match(/OS 4/i)){
			dojo.style(this.collaborationDialogContentPane.domNode.contentWindow.document.body, "display", "");
		}
		
		//Since openCollaborationDialog is sometimes called during sendPage, etc we need to be sure that the CollaborationDialog is visible
		//Invoke the dojox.mobile.List's transitionTo function to slide the page.  Skip if the CollaborationDialog is already visible
		collabDialogPageVisible = dojo.style(this.domNode.parentNode,"display");
		if(this.openCollabRoundRectListItem.moveTo && collabDialogPageVisible == "none"){
			this.openCollabRoundRectListItem.transitionTo(this.openCollabRoundRectListItem.moveTo);
		}
		
		this.resize();
		this._toggleCollaborationDialogButtons();
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerDialogOpened"}}');
	},
	
	closeCollaborationDialog: function(){
		// summary: Invoked when the user clicks the button to return to the main widget
		
		//Due a to a bug in iOS4 Safari we have to hide the iFrame's content before the slide transition.
		//So in closeCollaborationDialog we hide it and in openCollaborationDialog we unhide it
		if (navigator.userAgent.match(/OS 4/i)){
			dojo.style(this.collaborationDialogContentPane.domNode.contentWindow.document.body, "display", "none");
		}
		
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerDialogClosed"}}');
	},
	
	onBeforeUnload: function(){
		// summary: Invoked when the user closes the browser, the tab or refreshes/changes the page
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerDialogClosed"}}');
	},
	
	click: function(e) {
		// Summary: Handler for all click events within the CollaborationDialog iFrame	
		if ( this._hasCollaborationControl == true ){	
			//If followme is enabled and highlight is not send the click
			if (this._followMeEnabled && !this.highlightButton.get('checked')){
				
				//IE handles IMG tags differently than the other browsers and includes the image link as the href
				//We need to override this so that the normal findNode process can be used when a user clicks an IMG
				var ie_IMG_Tag = false;
				if (dojo.isIE && e.target.nodeName == "IMG"){
					ie_IMG_Tag = true;
				}
				
				if ( e.target.href && e.target.href.indexOf("http://") != -1 && ie_IMG_Tag == false){
					this.sendDataEvent('{"collaborationData":{"url":"' + e.target.href + '"}}');
				} else {
					this.sendDataEvent('{"collaborationData":{"followMe":' + this._identifyNode(e.target) + '}}');
				}
			}
		}
	},
	
	sendPage: function() {
		// summary: Invoked when the user clicks the 'Send Page' button for this widget
		url = this.collaborationDialogContentPane.domNode.contentWindow.document.location.href;	
		dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, url, true);
		
		url = this._sendPageUrlRewriteCallback(url);
		
		this.sendDataEvent('{"collaborationData":{"url":"' + url + '"}}');
		
		//When a new page is loaded hide the displayMessageArea if its visible
		this.hideMessageArea();
		
	},
	
	followMe: function(){
		// summary: Invoked when the user clicks the 'Follow Me' button for this widget
		if (this._followMeEnabled){
			this._followMeEnabled = false;
		} else {
			this._followMeEnabled = true;
		}
		
		this._toggleCollaborationDialogStatus();
	},
	
	highlight: function(){
		// summary: Invoked when the user clicks the 'Highlight' button for this widget
		var self = this;
		
		if(!(navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/Android/i))) { 
			//If not one of the supported mobile browsers default to click/mouseover highlighting instead of touch
			this.highlightForNonTouch();
			return;
		}
		
		//If the user un-toggles the highlight button disconnect the highlight handlers.
		if (!this.highlightButton.get('checked')){
			dojo.disconnect(this.touchHandle);
			return;	
		}
		
		//If the current status message was the unableToHighlight message, remove that message.  
		var messageHTML = this.collaborationDialogMessageAreaMessage.innerHTML;
		if (messageHTML.indexOf(this.unableToHighlightString)>0){
			this.hideMessageArea();
		}
	
		//Set the dojo context to the iFrame document
		var iframeDoc = this.collaborationDialogContentPane.domNode.contentWindow.document;
		dojo.withDoc(iframeDoc, function() {

			self.touchHandle = dojo.connect(dojo.doc, 'ontouchstart', function(e){
				// skip processing if this is event is part of a gesture
				if ( e.touches.length == 1){
					
					//If we happen to touch an actionable element this will stop the highlight touch from taking the action
					e.preventDefault();
					e.cancelBubble = true;
					e.returnValue = false;
					
					//If the click was on text this will set the target to the parentNode
					var target = e.target;
					if (target.nodeType == 3){
						target = target.parentNode;
					}
					
					if(!self._isHighlightable(target)){
						//at this point a unhighlightable element was clicked.  Show the message and disconnect the handlers 
						self.displayMessageArea("collaborationDialogWidgetWarningIcon", self.unableToHighlightString, false, true);

						dojo.disconnect(self.touchHandle);
					
						self.highlightButton.set('checked', false);
						return;
					}
						
					//at this point a highlightable element was clicked.  Disconnect the handler
					dojo.disconnect(self.touchHandle);
					
					//after element is highlighted, revert highlight button back to unchecked
					self.highlightButton.set('checked', false);
							
					//if a previous target was highlighted remove the highlight style
					if(self.oldSentHighlightTarget){
						dojo.removeClass(self.oldSentHighlightTarget, 'collaborationDialogWidgetSentHighlight');
					}
					
					self.sendDataEvent('{"collaborationData":{"highlight":' +self._identifyNode(target)+ '}}');
					self.oldSentHighlightTarget = target;
					dojo.addClass(target, 'collaborationDialogWidgetSentHighlight');
				}
				
			});
			
		}, this);
		
	},
	
	highlightForNonTouch: function(){
		// summary: Invoked when the user is using the widget in a browser that doesn't support touch
		var self = this;
		
		//If the user un-toggles the highlight button disconnect the highlight handlers.
		if (!this.highlightButton.get('checked')){
			dojo.disconnect(this.clickHandle);
			dojo.disconnect(this.mouseMoveHandle);
			return;	
		}
		
		//If the current status message was the unableToHighlight message, remove that message.  
		var messageHTML = this.collaborationDialogMessageAreaMessage.innerHTML;
		if (messageHTML.indexOf(this.unableToHighlightString)>0){
			this.hideMessageArea();
		}
	
		//Set the dojo context to the iFrame document
		var iframeDoc = this.collaborationDialogContentPane.domNode.contentWindow.document;
		dojo.withDoc(iframeDoc, function() {
		    
			//connect a handler to the onmousemove event so that the highlight can follow the mouse
			self.mouseMoveHandle = dojo.connect(dojo.doc, 'onmousemove', function(e){

				var isHighlightableElement = self._isHighlightable(e.target);
				
				//if its a new target and a highlightable element apply the highlight style
				if(e.target != self.oldHoverTarget && isHighlightableElement){
					
					if(self.oldHoverTarget){ 
						dojo.removeClass(self.oldHoverTarget, 'collaborationDialogWidgetSentHighlight'); 
						
						if (self.tempHighlightOnclick){
							self.oldHoverTarget.onclick = self.tempHighlightOnclick;	
						}
						self.tempHighlightOnclick = e.target.onclick;
						e.target.onclick = null;
					}
					dojo.addClass(e.target, 'collaborationDialogWidgetSentHighlight');

					self.oldHoverTarget = e.target;
				}
				
				//if the target is not a highlightable element remove the highlight style from the old target
				if(!isHighlightableElement){
					if (self.oldHoverTarget){
						dojo.removeClass(self.oldHoverTarget, 'collaborationDialogWidgetSentHighlight');
						
						if (self.tempHighlightOnclick){
							self.oldHoverTarget.onclick = self.tempHighlightOnclick;	
						}
						self.tempHighlightOnclick = e.target.onclick;
						e.target.onclick = null;
					}
					self.oldHoverTarget = e.target;
				}
			});
			
			// Handle the next click on the iFrame document
			self.clickHandle = dojo.connect(dojo.doc, 'click', function(e){
				console.log("highlightForNonTouch clicked: " + e.target);
				
				//If we happen to click an actionable element this will stop the highlight click from taking the action
				dojo.stopEvent(e);
				
				//Now that the click has happened we can set the onclick function back to the domNode
				e.target.onclick = self.tempHighlightOnclick;
				
				if(!self._isHighlightable(e.target)){
					//at this point a unhighlightable element was clicked.  Show the message and disconnect the handlers 
					self.displayMessageArea("collaborationDialogWidgetWarningIcon", self.unableToHighlightString, false, true);

					dojo.disconnect(self.clickHandle);
					dojo.disconnect(self.mouseMoveHandle);
					
					self.highlightButton.set('checked', false);
					return;
				}
				
				//at this point a highlightable element was clicked.  Disconnect the handlers
				dojo.disconnect(self.clickHandle);
				dojo.disconnect(self.mouseMoveHandle);
				
				//after element is highlighted, revert highlight button back to unchecked
				self.highlightButton.set('checked', false);
				
				
				//if a previous target was highlighted remove the highlight style
				if(self.oldSentHighlightTarget){
					dojo.removeClass(self.oldSentHighlightTarget, 'collaborationDialogWidgetSentHighlight');
				}
				
				self.sendDataEvent('{"collaborationData":{"highlight":' +self._identifyNode(e.target)+ '}}');
				self.oldSentHighlightTarget = e.target;
				dojo.addClass(e.target, 'collaborationDialogWidgetSentHighlight');
			});
			
		}, this);
	
	},
	
	grantControl: function() {
		// summary: Invoked when the user clicks the 'Grant Control' button for this widget	
		//Disable this widgets control and then send an event to the peer to takeover control
		
		//If the current status message was the gra message, remove that message.  
		var messageHTML = this.collaborationDialogMessageAreaMessage.innerHTML;
		if (messageHTML.indexOf(this.controlGrantedByPartnerString)>0){
			this.hideMessageArea();
		}
		
		this._hasCollaborationControl = false;
		dojo.cookie("hasCollaborationControl",false);
		this._toggleCollaborationDialogButtons();
		this.sendDataEvent('{"collaborationData":{"grantControl": "true"}}');
		
	},
	
	locationBar: function(){

		if (this.collaborationDialogLocationBar.style.display == "none"){
			dojo.style(this.collaborationDialogLocationBar,'display', '');
			this.locationBarButton.set('label', this.hideLocationBarButtonString);
			this.locationBarButton.set('title', this.hideLocationBarButtonString);
			this.locationBarButton.set("iconClass", "collaborationDialogWidgetIcon collaborationDialogWidgetHideAddressFieldIcon");
		} else {
			dojo.style(this.collaborationDialogLocationBar,'display', 'none');
			this.locationBarButton.set('label', this.showLocationBarButtonString);
			this.locationBarButton.set('title', this.showLocationBarButtonString);
			this.locationBarButton.set("iconClass", "collaborationDialogWidgetIcon collaborationDialogWidgetShowAddressFieldIcon");
		}
		
		this.resize();
	},
	
	startDataPolling: function() {
		// summary: Add the data event handler to start polling for data from the peer
		console.log("startDataPolling");
		this.addEventHandler(this._handleResultHitch);
	},

	stopDataPolling: function(){
		// summary: Remove the data event handler to stop polling for data from the peer
		console.log("stopDataPolling");
		this.removeEventHandler(this._handleResultHitch);
	},
	
	handleResult: function(event) {
		// summary: Invoked when the widget receives data sent by the peer.  Parses the JSON response and calls the correct CollaborationDialog data handler
		if ( event.type == 0 ){
			var data = event.data;
			if (data.dialogStatusEvent){
				this._handleDialogStatusEvent(data.dialogStatusEvent);
			}

			if (data.highlight){
				this._handleHighlight(data.highlight);
			}
			
			if (data.grantControl){
				this._handleGrantControl(data.grantControl);
			}
			
			if (data.peerCanControlCollaboration){
				this._handlePeerCanControlCollaboration(data.peerCanControlCollaboration);
			}
			if (data.pageChanged){
				var myPage = this.collaborationDialogContentPane.domNode.contentWindow.document.location.href;
				var theirPage = data.pageChanged;

				//since we are comparing URLs we need to apply the same rewrite logic we used during a sendpage before comparing.
				myPage = this._sendPageUrlRewriteCallback(myPage);
				
				if (this._hasCollaborationControl == true && myPage!=theirPage){
					this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.pagesNotInSyncString, false, true);
				} else if (myPage == theirPage){
					//If pages are equal, and the current status message was the pagesNotInSync message, remove that message.  
					var messageHTML = this.collaborationDialogMessageAreaMessage.innerHTML;
					if (messageHTML.indexOf(this.pagesNotInSyncString)>0){
						this.hideMessageArea();
					}
				}
			}
			
			if (data.peerFollowMeClickBlocked){
				this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.peerUnableToFollowString, false, true);
			}
			
			if (data == "EVENT_POLLING_REPLACED") {
				this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.eventPollingReplacedString, false, true);	
			}
			if (data == "EVENT_POLLING_FAILED") {
				this.displayMessageArea("collaborationDialogWidgetErrorIcon", this.eventPollingFailedString, false, true);
			}
			
			//The following data events should only be processed when the widget does not have collaboration control
			if (this._hasCollaborationControl == false){
				if(data.url) {
					this._handleSendPage(data.url);	
				}
				if (data.followMe){
					this._handleFollowMe(data.followMe);
				}
			}
		}
		else if (event.type == 3){
			if (this._hasCollaborationControl == true){
				this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.failoverEventActiveString, false, true);
			}
			else {
				this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.failoverEventPassiveString, false, true);
			}
		
		}
	},

	_handleSendPage: function(url){
		//summary: Result handler invoked when a sendPage event is received.  Sets the content pane href to the new url.
		dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, url, true);
		this.openCollaborationDialog();

		this._toggleCollaborationDialogStatus();
		
		//When a new page is loaded hide the displayMessageArea if its visible
		this.hideMessageArea();
	},
	
	_handleHighlight: function(data){		
		//summary: Result handler invoked when a highlight event is received.  Finds the highlighted node and then applies the appropriate style.
		var iframeDoc = this.collaborationDialogContentPane.domNode.contentWindow.document;
		dojo.withDoc(iframeDoc, function() {
			var node = this._findNode(data);
			if ( node != null){
				if(this.oldReceivedHighlightTarget){
					dojo.removeClass(this.oldReceivedHighlightTarget, 'collaborationDialogWidgetReceivedHighlight');
				}
				dojo.addClass(node, 'collaborationDialogWidgetReceivedHighlight');
				this.oldReceivedHighlightTarget = node;
			} else {
				this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.unableToHighlightString, false, true);
			}
		}, this);
		
		//Since webkit browsers don't always repaint based on a css style change this will force a repaint to display the highlight
		this.collaborationDialogContentPane.domNode.contentWindow.scrollTo(0, 1);
	},
	
	_handleFollowMe: function(data){
		//summary: Result handler invoked when a followMe event is received.  Finds the clicked node and then simulates the appropriate browser click.
		var node = this._findNode(data);
		if ( node != null && this._isClickable(node)){
			this._simulateClickEvent(node);
		} else {
			this.sendDataEvent('{"collaborationData":{"peerFollowMeClickBlocked":"true"}}');
			this.displayMessageArea("collaborationDialogWidgetWarningIcon", this.unableToFollowString, false, true);
		}
	},
	
	_handleGrantControl: function(url){
		//summary: Result handler invoked when a grantControl event is received.
		this._hasCollaborationControl = true;
		dojo.cookie("hasCollaborationControl",true);
		this._toggleCollaborationDialogButtons();
		this.displayMessageArea("collaborationDialogWidgetInformationIcon", this.controlGrantedByPartnerString, false, true);
	},
	
	_handlePeerCanControlCollaboration: function(peerCanControlCollaboration){
		//summary: Result handler invoked when a peerCanControlCollaboration event is received.
		//the peer sends this event after connecting so that this widget can determine whether to enable/disable the grant control icon
		this._peerCanControlCollaboration = (peerCanControlCollaboration == "true") ? true:false;
		dojo.cookie("peerCanControlCollaboration",this._peerCanControlCollaboration);    	

		if (this._peerCanControlCollaboration == true && this._hasCollaborationControl == true){
			this.grantControlButton.set("disabled", false);
		} else {
			this.grantControlButton.set("disabled", true);
		}
	},
		
	_handleDialogStatusEvent: function(data){
		//summary: Result handler invoked when a dialogStatusEvent event is received.  Sets the appropriate status connected/disconnected and peer window open/closed.
		console.log("_handleDialogStatusEvent: " + data);
		
		if ( data == "peerDialogOpened"){
			console.log("peerDialogOpened");
			this.collaborationDialogPeerWindowStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsOpenIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.peerWindowOpenString;
			dojo.cookie("peerDialogStatus","peerDialogOpened");
		}
		if ( data == "peerDialogClosed"){
			console.log("peerDialogClosed");
			this.collaborationDialogPeerWindowStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsClosedIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.peerWindowClosedString;
			dojo.cookie("peerDialogStatus","peerDialogClosed");
		}
		if ( data == "peerConnected"){
			console.log("peerConnected");
			this.collaborationDialogConnectionStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetConnectedIcon' style='display:inline-block;vertical-align: middle'></span>&nbsp; " + this.connectedString;
		}
		if ( data == "peerDisconnected"){
			console.log("peerDialogDisconnected");
			this.collaborationDialogConnectionStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWaitingForConnectIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.disconnectedString;
			
			//If followMe is enabled call the button handler to disable followMe and change the status
			if (this._followMeEnabled){
				this.followMe();
			}
			
			//Disable the buttons that will try to send data to the peer
			this.sendPageButton.set("disabled", true);
			this.followMeButton.set("disabled", true);
			this.grantControlButton.set("disabled", true);
			this.highlightButton.set("disabled", true);
			
			//Reset all toggle buttons to un-toggled state
			this.followMeButton.set('checked', false);
			this.highlightButton.set('checked', false);
			
			//this will ensure that future iFrame loads don't disable the Browser buttons since it keys off whether the user has control
			this._hasCollaborationControl = true;
			//enable the browser controls so the user can navigate the collaboration dialog after the session is over
			this.updateBrowserHistoryButtons(true);
		}	
			
	},
	
	_toggleCollaborationDialogButtons: function(){
		//Summary: If this widget hasCollaborationControl enable the buttons to drive the collaboration session
		if (this._hasCollaborationControl == true) {
			var disabled = false;
		} else {
			var disabled = true;
		}
		
		this.cobrowseTextBox.set("readOnly", disabled);
		this.sendPageButton.set("disabled", disabled);
		this.followMeButton.set("disabled", disabled);
		
		if (!disabled && this._peerCanControlCollaboration == true){
			this.grantControlButton.set("disabled", false);
		} else {
			this.grantControlButton.set("disabled", true);
		}
		
		//always enable the highlightButton for both parties
		this.highlightButton.set("disabled", false);
		
		this.updateBrowserHistoryButtons(this._hasCollaborationControl);
		
		this._toggleCollaborationDialogStatus();
	},

    _toggleCoauthorStatus: function() {
		this._isCoauthor = !this._isCoauthor;
        this._toggleCollaborationDialogStatus();
    },
        
	_toggleCollaborationDialogStatus: function(){
    	// Above all other status messages, see if this is a two-way form.
    	if (this._isCoauthor == true) {
        	this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCoauthorFormIcon' style='display:inline-block; vertical-align: middle'></span>&nbsp; " + this.coauthorFormString;
        	return;
        }

		//Summary: If this widget hasCollaborationControl change collaboration session status
		if (this._hasCollaborationControl == true) {
			if (this._followMeEnabled){
				this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetFollowMeIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.followMeButtonString;
			} else {
				this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseControllingIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.controllingNavigationString;
			}
		} else {
			this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseWebIcon' style='display:inline-block; vertical-align:middle'></span>&nbsp; " + this.cobrowsingWebString;
		}
	},
	
	displayMessageArea: function(icon, message, bool_ok, bool_close){
		dojo.style(this.collaborationDialogMessageArea,'display', '');//show it
		
		this.collaborationDialogMessageAreaIcon.innerHTML = "<span class='collaborationDialogWidgetIcon " + icon + "' style='display:inline-block'></span>";
		this.collaborationDialogMessageAreaMessage.innerHTML = "&nbsp; " + message;
		if (bool_ok){
			dojo.style(this.collaborationDialogMessageOKButtonNode, 'display', 'inline-block');
		}
		if (bool_close){
			dojo.style(this.collaborationDialogMessageCloseButtonNode, 'display', 'inline-block');
		}
		this.resize();
	},
	
	hideMessageArea: function(e) {
		// summary: Invoked when the user clicks the cancel button (x) for the CollaborationDialog 
		dojo.style(this.collaborationDialogMessageArea,'display','none');//show it
		this.resize();
	},
	
	_isClickable: function (node){
		if (this.isClickableCallback && this.isClickableCallback != ""){
			if (!dojo.global[this.isClickableCallback]) {
				console.log ("unable to invoke isClickable callback with name \"" + this.isClickableCallback +"\" so assuming true");
				return true;
	         }
	         return dojo.global[this.isClickableCallback].apply (dojo.global, [ node ]);
		} else {
			return true;	
		}
	},
	
	_isHighlightable: function (node){
		if (this.isHighlightableCallback && this.isHighlightableCallback != "" && dojo.global[this.isHighlightableCallback]){
	         return dojo.global[this.isHighlightableCallback].apply (dojo.global, [ node ]);
		} else {
			if (this.isHighlightableCallback && this.isHighlightableCallback != "" && !dojo.global[this.isHighlightableCallback]) {
				console.log ("unable to invoke isHighlightable callback with name \"" + this.isHighlightableCallback +"\" so using highlightElementList");
	        }
			
			var isHighlightableElement = false;
			for (var i=0; i<this._highlightElementArray.length; i++){
		    	 if (node.nodeName == this._highlightElementArray[i].toUpperCase()){
		    		 isHighlightableElement = true;
		    	 }
			}
			console.log("isHighlightableElement: " + isHighlightableElement);
			return isHighlightableElement;	
		}
	},
	
	_sendPageUrlRewriteCallback: function (url){
		if (this.sendPageUrlRewriteCallback && this.sendPageUrlRewriteCallback != ""){
			if (!dojo.global[this.sendPageUrlRewriteCallback]) {
				console.log ("unable to invoke sendPageUrlRewrite callback with name \"" + this.sendPageUrlRewriteCallback +"\" so skipping URL rewrite");
				return url;
	         }
	         return dojo.global[this.sendPageUrlRewriteCallback].apply (dojo.global, [ url ]);
		} else {
			return url;	
		}
	}
	
});

}
