/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource['cea.widget.CollaborationDialog']){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource['cea.widget.CollaborationDialog'] = true;
dojo.provide('cea.widget.CollaborationDialog');

dojo.require('cea.widget.CollaborationDataTransfer');
dojo.require('cea.widget.CollaborationDialogBrowser');
dojo.require('dijit.Dialog');
dojo.require('dijit.form.Button');
dojo.require('dijit.layout.LayoutContainer');
dojo.require("dojo.io.iframe");
dojo.require('dojox.layout.ContentPane');

dojo.requireLocalization("cea.widget", "CollaborationDialog", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare('cea.widget.CollaborationDialog', [dijit.Dialog, cea.widget.CollaborationDataTransfer, cea.widget.CollaborationDialogBrowser], {
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
	
	templateString:"<div class=\"dijitDialog collaborationDialogWidget\" tabindex=\"-1\" waiRole=\"dialog\" waiState=\"labelledby-${id}_title\">\n\t\n\t<div dojoAttachPoint=\"collaborationDialogCloseBar\" class=\"dijitDialogTitleBar collaborationDialogWidgetCloseBar\">\n\t\t<span dojoAttachPoint=\"collaborationDialogTitleNode\" class=\"dijitDialogTitle collaborationDialogWidgetTitle\" id=\"${id}_title\">${collabDialogTitleString}</span>\n\t\t<span dojoAttachPoint=\"closeButtonNode\" class=\"dijitDialogCloseIcon collaborationDialogWidgetCloseDialogIcon\" dojoAttachEvent=\"onclick: onCancel\">\n\t\t\t<span dojoAttachPoint=\"collaborationDialogCloseText\" class=\"closeText\">x</span>\n\t\t</span>\n\t</div>\n\t<div dojoAttachPoint=\"collaborationDialogTitleBar\" class=\"dijitDialogTitleBar collaborationDialogWidgetTitleBar\">\n\t\t<span dojoAttachPoint=\"collaborationDialogButtons\"></span>\n\t</div>\n\t\n\t<div dojoAttachPoint=\"collaborationDialogMessageArea\" class=\"collaborationDialogWidgetMessages\" style=\"display:none\">\n\t\t<table width=\"100%\">\n\t\t\t<tr>\n\t\t\t\t<td width=\"5%\" align=\"middle\" dojoAttachPoint=\"collaborationDialogMessageAreaIcon\" class=\"collaborationDialogWidgetMessages\"></td>\n\t\t\t\t<td width=\"90%\" align=\"right\" dojoAttachPoint=\"collaborationDialogMessageAreaMessage\" class=\"collaborationDialogWidgetMessages\"></td>\n\t\t\t\t<td width=\"5%\" align=\"right\" dojoAttachPoint=\"collaborationDialogMessageAreaAction\" class=\"collaborationDialogWidgetMessages\">\n\t\t\t\t\t<span dojoAttachPoint=\"collaborationDialogMessageOKButtonNode\" class=\"collaborationDialogCloseMessageIcon collaborationDialogWidgetIcon collaborationDialogWidgetAcceptIcon\" dojoAttachEvent=\"onclick: hideMessageArea\" style=\"display:none\"></span>\n\t\t\t\t\t<span dojoAttachPoint=\"collaborationDialogMessageCloseButtonNode\" class=\"collaborationDialogCloseMessageIcon collaborationDialogWidgetIcon collaborationDialogWidgetCloseIcon\" dojoAttachEvent=\"onclick: hideMessageArea\" style=\"display:none\"></span>\n\t\t\t\t</td>\n\t\t\t</tr>\n\t\t</table>\n\t</div>\n\t\n\t<div dojoAttachPoint=\"containerNode\" class=\"collaborationDialogPaneContent\">\n\t\t<iframe dojoAttachPoint=\"collaborationDialogContentPane\" onload=\"if (ceadojo.isIE){this.click();}\" dojoAttachEvent=\"onclick:_iFrameOnloadHandler, onload:_iFrameOnloadHandler\" class=\"collaborationDialogWidgetIFrame\" tabindex=\"9\"></iframe>\n\t</div>\n\n\t<div dojoAttachPoint=\"collaborationDialogFooterBar\" class=\"dijitDialogTitleBar collaborationDialogWidgetFooterBar\">\n\t\t<table width=\"100%\">\n\t\t\t<tr>\n\t\t\t\t<td align=\"left\" dojoAttachPoint=\"collaborationDialogConnectionStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetConnectedIcon\" style=\"display:inline-block\"></span>&nbsp; ${connectedString}</td>\n\t\t\t\t<td align=\"center\" dojoAttachPoint=\"collaborationDialogPeerWindowStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsClosedIcon\" style=\"display:inline-block\"></span>&nbsp; ${peerWindowClosedString}</td>\n\t\t\t\t<td align=\"right\" dojoAttachPoint=\"collaborationDialogActionStatusStatus\" class=\"collaborationDialogWidgetStatusBar\"><span class=\"collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseWebIcon\" style=\"display:inline-block\"></span>&nbsp; ${cobrowsingWebString}</td>\n\t\t\t</tr>\n\t\t</table>\n\t</div>\n\n</div>\n",
	
	//	defaultCollaborationUri: String
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
		
	postCreate: function() {
		//Hitch the handleResult function to a variable so it can be added/removed as an event handler
		this._handleResultHitch = dojo.hitch(this,"handleResult");

		this.collaborationDialogContentPane = new dojox.layout.ContentPane({executeScripts:"true", scriptHasHooks:"true", adjustPaths:"true"}, this.collaborationDialogContentPane);
		this.collaborationDialogContentPane.startup();
		this.collaborationDialogContentPane.domNode.title = this.collabTitleString;
		
		
		//connect the iFrame resize handler to keep the iFrame header and footer appropriately positioned.
		dojo.connect(window, "onresize", this, this._resizeIframe);
		
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
		this.collaborationDialogButtons.appendChild(label);
		this.collaborationDialogButtons.appendChild(this.cobrowseTextBox.domNode);
		
		//Add an accessible tabIndex to the cobrowseTextBox
		this.cobrowseTextBox.textbox.tabIndex = 1;
		
		dojo.connect(this.cobrowseTextBox.domNode, 'onkeypress', this, this.cobrowseTextBoxReturn);
		dojo.connect(this.cobrowseTextBox.domNode, 'onclick', this, this.cobrowseTextBoxClick);
			
		this.sendPageButton = this.addButtonWithLabel(this.sendPageButtonString, 'sendPage', 'collaborationDialogWidgetIcon collaborationDialogWidgetSendPageIcon');
		this.followMeButton = this.addToggleButton(this.followMeButtonString, 'followMe', 'collaborationDialogWidgetIcon collaborationDialogWidgetFollowMeIcon');
		this.grantControlButton = this.addButtonWithLabel(this.grantControlButtonString, 'grantControl', 'collaborationDialogWidgetIcon collaborationDialogWidgetControlNavigationIcon');
		this.highlightButton = this.addToggleButton(this.highlightButtonString, 'highlight', 'collaborationDialogWidgetIcon collaborationDialogWidgetHighlightIcon');
		
		this.inherited(arguments);
		
		window._ceaCollabDialog = this;
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

		this.controlGrantedByPartnerString = this._messages["CONTROL_GRANTED"];
		this.unableToHighlightString = this._messages["UNABLE_TO_HIGHLIGHT"];
		this.unableToFollowString = this._messages["UNABLE_TO_FOLLOW"];
		this.peerUnableToFollowString = this._messages["PEER_UNABLE_TO_FOLLOW"];
		this.pagesNotInSyncString = this._messages["NO_LONGER_SYNCHRONIZED_SEND_PAGE"];
		this.eventPollingReplacedString = this._messages["EVENT_POLLING_REPLACED"];
		this.eventPollingFailedString = this._messages["EVENT_POLLING_FAILED"];
		this.failoverEventActiveString = this._messages["FAILOVER_EVENT_ACTIVE"];
		this.failoverEventPassiveString = this._messages["FAILOVER_EVENT_PASSIVE"];
	},

	onCancel: function(e) {
		// summary: Invoked when the user clicks the cancel button (x) for the CollaborationDialog 
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerDialogClosed"}}');
		this.inherited(arguments);
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
	
	resetCollaborationDialog: function(){
		// summary: Used to reset the collaboration dialog to the defaultUri in between collaboration sessions
		console.log("Resetting the CollaborationDialog to the initial state");
		//clear the browser history array
		this.clearBrowserHistory();
		this.destroyContentPaneDescendants();
		this.cobrowseTextBox.set('value', this.defaultCollaborationUri);
		dojo.io.iframe.setSrc(this.collaborationDialogContentPane.domNode, this.defaultCollaborationUri, true);
		//Clear the cookie in between collaboration sessions
		dojo.cookie("collaborationUri",null);
		
		//Reset all toggle buttons to un-toggled state
		this.followMeButton.set('checked', false);
		this.highlightButton.set('checked', false);
	},
	
	destroyContentPaneDescendants: function(){
		// summary: If the content loaded in the CollaborationDialog contains dojo widgets this ensures that they are destroyed 
		//		correctly before a new page loads.  This helps to reduce potential ID conflicts. 
		dojo.forEach(this.collaborationDialogContentPane.getDescendants(), function(widget){
			widget.destroyRecursive();
        });
	},
		
	openCollaborationDialog: function(){
		// summary: Invoked when the user clicks the 'Open Collaboration Dialog' button for this widget
		this._toggleCollaborationDialogButtons();
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerDialogOpened"}}');
		this.show();
		//added this additional call to _resizeIfame() since some browsers won't let you change the size unless the dialog is visible
		this._resizeIframe();
	},
	
	sendPage: function() {
		// summary: Invoked when the user clicks the 'Send Page' button for this widget
		this.destroyContentPaneDescendants();
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
				console.log("highlight clicked: " + e.target);
				
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
		this.destroyContentPaneDescendants();
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
			this.collaborationDialogPeerWindowStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsOpenIcon' style='display:inline-block'></span>&nbsp; " + this.peerWindowOpenString;
			dojo.cookie("peerDialogStatus","peerDialogOpened");
		}
		if ( data == "peerDialogClosed"){
			console.log("peerDialogClosed");
			this.collaborationDialogPeerWindowStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWindowIsClosedIcon' style='display:inline-block'></span>&nbsp; " + this.peerWindowClosedString;
			dojo.cookie("peerDialogStatus","peerDialogClosed");
		}
		if ( data == "peerConnected"){
			console.log("peerConnected");
			this.collaborationDialogConnectionStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetConnectedIcon' style='display:inline-block'></span>&nbsp; " + this.connectedString;
		}
		if ( data == "peerDisconnected"){
			console.log("peerDialogDisconnected");
			this.collaborationDialogConnectionStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetWaitingForConnectIcon' style='display:inline-block'></span>&nbsp; " + this.disconnectedString;
			
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
        	this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCoauthorFormIcon' style='display:inline-block'></span>&nbsp; " + this.coauthorFormString;
        	return;
        }

		//Summary: If this widget hasCollaborationControl change collaboration session status
		if (this._hasCollaborationControl == true) {
			if (this._followMeEnabled){
				this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetFollowMeIcon' style='display:inline-block'></span>&nbsp; " + this.followMeButtonString;
			} else {
				this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseControllingIcon' style='display:inline-block'></span>&nbsp; " + this.controllingNavigationString;
			}
		} else {
			this.collaborationDialogActionStatusStatus.innerHTML = "<span class='collaborationDialogWidgetIcon collaborationDialogWidgetCobrowseWebIcon' style='display:inline-block'></span>&nbsp; " + this.cobrowsingWebString;
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
		this._resizeIframe();
	},
	
	hideMessageArea: function(e) {
		// summary: Invoked when the user clicks the cancel button (x) for the CollaborationDialog 
		dojo.style(this.collaborationDialogMessageArea,'display','none');//show it
		this._resizeIframe();
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
