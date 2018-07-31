/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.Cobrowse"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.Cobrowse"] = true;
dojo.provide("cea.widget.Cobrowse");

dojo.require('cea.widget.CollaborationDialog');
dojo.require("dijit._Templated");
dojo.require("dijit._Widget");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dojo.cookie");
dojo.require("dojo.i18n");
dojo.require("dijit.Dialog");

dojo.requireLocalization("cea.widget", "Cobrowse", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.widget.Cobrowse", [dijit._Widget, dijit._Templated], {
	//	
	//	summary:
	//		A widget for embedding collaboration functionality.
	//
	//	description: 
	//		This widget provides the ability for a user to create an invitation link to send to a peer.  After creating the invitation
	//     	the widget will start polling for join notification from the peer.  When the peer clicks on the invitation link this widget 
	//     	will load and make the appropriate call to join the collaboration session.  This widget utilizes the cea.widget.CollaborationDialog
	//		to provide a modal window to interact with the peer.
	//
	//	example:
	//	|	<div dojoType="cea.widget.Cobrowse" joinCollaborationUri="commsvc.widget/cea/tests/test_Cobrowse.html">
	//	
	
	templateString:"<div>\n\t<table class=\"cobrowseWidget\">\n\t\t<tr>\n\t\t\t<td nowrap>\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td colspan=\"2\" dojoAttachPoint=\"createCollabInviteString\" nowrap>\n\t\t\t\t\t\t\t${createCollabInviteString}\n\t\t\t\t\t\t\t<button dojoType=\"dijit.form.Button\" dojoAttachPoint=\"createCollaborationButton\" dojoAttachEvent=\"onClick:createCollaboration\" class=\"cobrowseWidgetButton\">${createButtonString}</button>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t<button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:endCollaboration\" dojoAttachPoint=\"endCollaborationButton\" iconClass=\"cobrowseWidgetIcon cobrowseWidgetEndSessionIcon\" class=\"cobrowseWidgetButton\" style=\"display:none\">${endCollabButtonString}</button>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t<button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:openCollabDialog\" dojoAttachPoint=\"openCollabDialogButton\" iconClass=\"cobrowseWidgetIcon cobrowseWidgetShowWindowIcon\" class=\"cobrowseWidgetButton\" style=\"display:none\">${openCollabDialogButtonString}</button>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td colspan=\"2\" dojoAttachPoint=\"invitationLinkString\" style=\"display:none;border:1px solid #000000;\">\n\t\t\t\t\t\t\t<label dojoAttachPoint=\"invitationLinkLabel\">${invitationLinkString}:</label>\n\t\t\t\t\t\t\t<br>\n\t\t\t\t\t\t\t<input name=\"invitationLinkString\" dojoType=\"dijit.form.TextBox\" dojoAttachEvent=\"onClick:_peerCollaborationLinkClick\" dojoAttachPoint=\"peerCollaborationLink\" readonly=\"true\" class=\"cobrowseWidgetTextBox\"></input>\n\t\t\t\t\t\t\t\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td colspan=\"2\" nowrap dojoAttachPoint=\"status\" class=\"cobrowseWidgetStatus\" style=\"display:none\"></td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t</tr>\n\t</table>\n\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\" sendPageUrlRewriteCallback=\"${sendPageUrlRewriteCallback}\"></div>\n</div>\n",
	widgetsInTemplate: true,
	
	//	ceaContextRoot: String
	//		The context root of the CEA system application
	ceaContextRoot: "/commsvc.rest",
	//joinCollaborationURI: String
	//		Specifies the page to which the invitee is taken.
	//      This page must have this widget embedded and be able to accept an additional parameter
	//      Limitation:  Only an absolute URI such as "commsvc.widget/cea/tests/test_Cobrowse.html"
	//      is acceptable.  A URI such as "../commsvc.widget/cea/tests/test_Cobrowse.html" will fail.
	//      A URI such as "//http://localhost:9080/commsvc.widget/cea/tests/test_Cobrowse.html" will fail.
	joinCollaborationURI: "",
	//CEA_COLLAB_ID_PREFIX: String
	//      The prefix in the parameter included in the URI which is passed between the initiator and invitee, i.e.
    //      http://www.fooble.com/index.html?cea_collab=Ff2oiiN5apSekJNrvHB-wsB
	CEA_COLLAB_ID_PREFIX: "cea_collab=",  
	//canControlCollaboration: String
	//		Determines whether this widget can drive the collaboration session
	canControlCollaboration: "true",
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
	
	_collabLink: "",
	
	_topCEACollabDialog: null,
	
	postMixInProperties: function() {
	    this.inherited(arguments);
		this.initializeStrings();
		this._topCEACollabDialog = window.top._ceaCollabDialog;
	},
	
	postCreate: function(){
		//Associate the accessible label with the peerCollaborationLink textfield
		this.invitationLinkLabel.htmlFor = this.peerCollaborationLink.textbox.id;
		
		//Hitch the _convertToCollaborationStatusState function to a variable so it can be added/removed as an event handler
		this._convertToCollaborationStatusHitch = dojo.hitch(this, "_convertToCollaborationStatusState");
		
		this.collaborationDialog.collabParent = this;
		
		//Because the eventHandler is also used by the CollaborationDialog we need to override 
		//the ceaContextRoot otherwise it will always be the default
		this.collaborationDialog.ceaContextRoot = this.ceaContextRoot;

		console.log("Browser cookies enabled: " + dojo.cookie.isSupported());
		if (!dojo.cookie.isSupported()){
			//Check if the browser cookies are enabled and if not disable the widget and display a message
			this._convertToWidgetDisabledState(this.enableCookiesString);
		} else if ( this._topCEACollabDialog != null){
			//Check if the widget page is loaded in the CollaborationDialog and if so disable the widget and display a message
			this._convertToWidgetDisabledState(this.widgetInUseString);
		} else {
			this.collaborationDialog.detectExistingCobrowse(dojo.hitch(this, "_convertToAlreadyConnectedState"));
		}
		
 	    this.inherited(arguments);
	},
	
	initializeStrings: function(){
		// summary: Build up a mapping of variables to NLS strings for use by this widget 
		this._messages = dojo.i18n.getLocalization("cea.widget", "Cobrowse", this.lang);
		
		this.createCollabInviteString     = this._messages["CREATE_COLLAB_INVITE"];
		this.createButtonString           = this._messages["CREATE_BUTTON"];
		this.invitationLinkString         = this._messages["INVITATION_LINK"];
		this.cancelCollabButtonString     = this._messages["CANCEL_COLLAB_BUTTON"];
		this.endCollabButtonString        = this._messages["END_COLLAB_BUTTON"];
		this.openCollabDialogButtonString = this._messages["OPEN_COLLAB_DIALOG_BUTTON"];
		this.collabWaitingString          = this._messages["COLLAB_WAITING"];
		this.collabConnectedString        = this._messages["COLLAB_CONNECTED"];
		this.collabDisconnectedString     = this._messages["COLLAB_DISCONNECTED"];
		this.collabDisconnectFailedString = this._messages["COLLAB_DISCONNECT_FAILED"];
		this.collabFailString             = this._messages["COLLAB_FAIL"];
		this.serviceUnavailableString     = this._messages["SERVICE_UNAVAILABLE"];
		this.eventPollingReplacedString   = this._messages["EVENT_POLLING_REPLACED"];
		this.eventPollingFailedString 	  = this._messages["EVENT_POLLING_FAILED"];
		this.endCollabTitleString         = this._messages["END_COLLAB_TITLE"];
		this.confirmExitString			  = this._messages["CONFIRM_END_SESSION"];
		this.YES 						  = this._messages["YES"];
		this.NO 						  = this._messages["NO"];
		this.widgetInUseString			  = this._messages["WIDGET_IN_USE"];
		this.enableCookiesString 		  = this._messages["ENABLE_COOKIES"];

	},
	
	_peerCollaborationLinkClick: function(){
		// summary: Invoked when the peerCollaborationLink textfield gets clicked and selects all the text
		this.peerCollaborationLink.textbox.focus();
		this.peerCollaborationLink.textbox.select();
	},
	
	createCollaboration: function(){
		// summary: Invoked when the user clicks the create button for this widget
		this.collaborationDialog.createCollaborationSession(dojo.hitch(this,"_convertToWaitingState"));
	},
		
	openCollabDialog: function(){
		// summary: Invoked when the user clicks the open collaboration dialog button for this widget
		this.collaborationDialog.openCollaborationDialog();
	},	
	
	endCollaboration: function(){
		// summary: Invoked when the user clicks the end collaboration button for this widget
		var self = this;
		var confirmDialog = new dijit.Dialog({ id: 'queryDialog', title:this.endCollabTitleString });
		// When either button is pressed, kill the dialog and call the callbackFn.
		var cancelDialog = function(mouseEvent) {
			//Cross-Browser compatibility so that targ= the actual target button that was pressed
			var targ;
			if (!mouseEvent){
				var mouseEvent = window.event;
			}
			if (mouseEvent.target){
				targ = mouseEvent.target;
			} else if (mouseEvent.srcElement){
				targ = mouseEvent.srcElement;
			}
	
			confirmDialog.hide();
			confirmDialog.destroyRecursive();
			yesButton.destroyRecursive();
			noButton.destroyRecursive();
    	
			var targ_string = targ.id.toString();
			if (targ_string.indexOf('yesButton')!= -1){
				self.collaborationDialog.endCollaborationSession(dojo.hitch(self,"_convertToDisconnectedState"));
			}
    	
		};
		
		confirmDialog.set("content", "<p>" + this.confirmExitString + "</p>");
		var yesButton = new dijit.form.Button({ label: this.YES, id: 'yesButton', onClick: cancelDialog});
		var noButton = new dijit.form.Button({ label: this.NO, id: 'noButton', onClick: cancelDialog});

		confirmDialog.containerNode.appendChild(yesButton.domNode);
		confirmDialog.containerNode.appendChild(noButton.domNode);

		confirmDialog.show();
	},
		
	constructPeerURI: function(response){
		// summary: extract the addressOfRecord and nonce then append it to the URI yielding something similar to:
		// http://localhost:9080/commsvc.widget/cea/tests/test_Cobrowse.html?cea_collab=BhmhFhfs58_VL509Wg7ulLy&nonce=1031656204
		
		if (this.joinCollaborationURI.indexOf("http") >= 0) {
			//this is an absolute url so no need to prepend
			prefixToURI = "";
		} else {
			//this is an relative url will need to prepend
			docLocStr = document.location.href;	
			//in a URI like below find the index of the slash after .com
			//http://www.foobar.com/index.html
			//searching starting at index 8 accounts for 'https' and 'http'
			indexOfSlash = docLocStr.indexOf("/",8);
			prefixToURI = docLocStr.slice(0,indexOfSlash+1);
			
			//the prefix will always contain the slash at the start of the context-root so strip it if we find it here
			if (this.joinCollaborationURI.indexOf("/") == 0){
				this.joinCollaborationURI = this.joinCollaborationURI.slice(1)
			}
		}
		
		var questOrAmp = "?";
		if (this.joinCollaborationURI.indexOf("?") > 0) {
			questOrAmp = "&";
		}

		collaborationId = response.collaborationId;
		forPeerCollabUri = response.forPeerCollaborationUri;
		indexOfNonceStr = forPeerCollabUri.indexOf("&nonce=");
		nonceStr = forPeerCollabUri.slice(indexOfNonceStr);
		newURI = prefixToURI + this.joinCollaborationURI + questOrAmp + this.CEA_COLLAB_ID_PREFIX + collaborationId + nonceStr;
		console.log("constructPeerURI.newURI: " +newURI);
		return newURI;		
		
	},

	extractCollaborationID: function(peerCollabStr){
		// summary: extract the collaborationID from the URL of party-2
		// the collaborationID is similar to "cea_collab=BhmhFhfs58_V......"
		index = peerCollabStr.lastIndexOf(this.CEA_COLLAB_ID_PREFIX);
		collabID = peerCollabStr.slice(index +this.CEA_COLLAB_ID_PREFIX.length);
		console.log("extractCollaborationID.collabID: " +collabID);
		return collabID;
	},
	
	_convertToAlreadyConnectedState: function(response){
		// summary: Callback invoked after the rest service request for detectExistingCobrowse has completed.  
		//		Styles the widget appropriately based on the response to show default, waiting or connected states
		// response: The JSON response from the detectExistingCobrowse rest service request
		console.log("_convertToAlreadyConnectedState entry: " + response.returnCode);	
		
		//If the widget is a greater version than the rest service we need to disable the widget and log a message
		//If the ceaVersion is undefined the rest service is 1.0.0.0
		var ceaVersion = response.ceaVersion
		if (ceaVersion == null || ceaVersion == ""){
			ceaVersion = "1.0.0.0";
		}

		//Split the ceaVersion into individual numbers so that we can compare it to the CEA widget version numbers.
		version = ceaVersion.split(".");
		var disableWidget = false;
		if (dojo.version.major > version[0]) {
			disableWidget = true;
		} else if (dojo.version.major == version[0] && dojo.version.minor > version[1]) {
			disableWidget = true;
		} else if (dojo.version.major == version[0] && dojo.version.minor == version[1] && dojo.version.patch > version[2]) {
			disableWidget = true;
		} else if (dojo.version.major == version[0] && dojo.version.minor == version[1] && dojo.version.patch == version[2] && dojo.version.flag > version[3]) {
			disableWidget = true;
		}
		
		//If the server returns a 4xx or 5xx error put the widget into the unavailable state ( the returnCode will be undefined )
		if (!response.returnCode){
			this.status.innerHTML = this.serviceUnavailableString;
			dojo.style(this.status, 'display', '');
			this.createCollaborationButton.set("disabled", true);
		} else if (disableWidget == true) {
			this.status.innerHTML = this.serviceUnavailableString;
			dojo.style(this.status, 'display', '');
			this.createCollaborationButton.set("disabled", true);
			
			widgetVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
			console.log("The widget version " + widgetVersion + " is at a newer level than the CEA service version " + ceaVersion + " and will be disabled");
			
		} else if (response.returnCode == 200) {
			if (response.collaborationStatus == "ESTABLISHED") {
				dojo.style(this.endCollaborationButton.domNode,    'display', '');//show it
		    	dojo.style(this.openCollabDialogButton.domNode,    'display', '');//show it
		    	dojo.style(this.createCollabInviteString,          'display', 'none'); //hide it
		    	dojo.style(this.createCollaborationButton.domNode, 'display', 'none'); //hide it
		    	dojo.style(this.invitationLinkString,              'display', 'none'); //hide it
		    	dojo.style(this.status,                    	 	   'display', '');//show it
		    	this.status.innerHTML = this.collabConnectedString;
		    	
		    	//grab the collaborationUri cookie that was set the last time a new page was loaded in the iFrame and it as the current page
		    	dojo.io.iframe.setSrc(this.collaborationDialog.collaborationDialogContentPane.domNode, dojo.cookie("collaborationUri"), true);
		    	this.collaborationDialog.cobrowseTextBox.set('value', dojo.cookie("collaborationUri"));
		    	this.collaborationDialog._peerCanControlCollaboration = (dojo.cookie("peerCanControlCollaboration") == "true") ? true:false;
		    	this.collaborationDialog._hasCollaborationControl = (dojo.cookie("hasCollaborationControl") == "true") ? true:false;
		    	this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":dojo.cookie("peerDialogStatus")}});
		    	
		    	this.collaborationDialog.startCollaborationStatusPolling(this._convertToCollaborationStatusHitch);
   	   	    	this.collaborationDialog.startDataPolling();
   	   	    	this.collaborationDialog.sendConnectedEventToPeer();
		    	this.openCollabDialog();
			} else {
				this.collaborationDialog.startCollaborationStatusPolling(this._convertToCollaborationStatusHitch);
				
				this.peerCollaborationLink.set('value', this.constructPeerURI(response));
				dojo.style(this.endCollaborationButton.domNode,    'display', '');//show it
				dojo.style(this.openCollabDialogButton.domNode,    'display', 'none'); //hide it
				dojo.style(this.createCollabInviteString,          'display', 'none'); //hide it
				dojo.style(this.createCollaborationButton.domNode, 'display', 'none'); //hide it
				dojo.style(this.invitationLinkString,              'display', '');//show it
				dojo.style(this.status,                    		   'display', '');//show it
				this.status.innerHTML = this.collabWaitingString;
			}
		} else {
			//If the returnCode is not 200 then an existing session does not exist and we should look to see if this is a join invitation
			if (response.returnCode != 200 ) {
				//If this is the invitee/peer/party-2 then take action to join the requested collaboration 
				docLocStr = document.location.href;
				//The initiator/creator/caller/party-1 will not have a Collaboration ID 
				//that is, there is NO CEA_COLLAB_ID_PREFIX in the initiator's URI, so do nothing.
	        	//The invitee/peer/party-2 DOES have a CEA_COLLAB_ID_PREFIX
	        	if ( -1 < docLocStr.indexOf(this.CEA_COLLAB_ID_PREFIX)){
	      	   		this._collabLink = "CommServlet/collaborationSession?addressOfRecord=" +this.extractCollaborationID(docLocStr);
	      	   		console.log("postCreate.collabLink: " + this._collabLink);
	      	   		this.collaborationDialog.joinCollaborationSession(this._collabLink, dojo.hitch(this,"_convertToConnectedState"));  	   
	        	}
	      }
		}
		console.log("_convertToAlreadyConnectedState exit");
	},
	
	_convertToWidgetDisabledState: function(nlsMessage){
		// summary: Callback invoked when the widget is embedded on a page loaded into the CollaborationDialog.  
		//		Disables the widget and displays an info message
		// nlsMessage: The NLS message explaining why the widget was disabled
		console.log("_convertToWidgetDisabledState entry");
		
		this.status.innerHTML = nlsMessage;
		dojo.style(this.status, 'display', '');
		this.createCollaborationButton.set("disabled", true);
		
		console.log("_convertToWidgetDisabledState exit");
	},

	_convertToWaitingState: function(response){
		// summary: The initiator has attempted to create an invitation link.  Show the correct state
		console.log("_convertToWaitingState entry: " + response.returnCode);
		if (response.returnCode == 200) {
			this.collaborationDialog.startCollaborationStatusPolling(this._convertToCollaborationStatusHitch);
			
			this.peerCollaborationLink.set('value', this.constructPeerURI(response));
			dojo.style(this.endCollaborationButton.domNode,    'display', '');//show it
			dojo.style(this.openCollabDialogButton.domNode,    'display', 'none'); //hide it
			dojo.style(this.createCollabInviteString,          'display', 'none'); //hide it
			dojo.style(this.createCollaborationButton.domNode, 'display', 'none'); //hide it
			dojo.style(this.invitationLinkString,              'display', '');//show it
			dojo.style(this.status,                    		   'display', '');//show it
			this.status.innerHTML = this.collabWaitingString;
		} else {
			this.status.innerHTML = this.collabFailString;
			this.peerCollaborationLink.set('value', ""); //display empty peerCollaborationLink test box
		}
		console.log("_convertToWaitingState exit");
	},

    _convertToConnectedState: function(response){
		// summary: The two collaborators should be connected.  Show the correct state
		console.log(" _convertToConnectedState entry: " + response.returnCode);
		if (response.returnCode == 200) {
	    	this.collaborationDialog.startCollaborationStatusPolling(this._convertToCollaborationStatusHitch); 
		}
		else {
			dojo.style(this.endCollaborationButton.domNode,    'display', 'none');//hide it
			dojo.style(this.openCollabDialogButton.domNode,    'display', 'none');//hide it
			dojo.style(this.createCollabInviteString,          'display', ''); //hide it
			dojo.style(this.createCollaborationButton.domNode, 'display', ''); //hide it
			dojo.style(this.invitationLinkString,              'display', 'none'); //hide it
			dojo.style(this.status,                    	 	   'display', '');//show it
			this.status.innerHTML = this.collabFailString;
		}
		console.log("_convertToConnectedState exit");
    },
	
	_convertToDisconnectedState: function(response){
		// summary: The two collaborators should be disconnected.  Show the correct state
    	console.log("_convertToDisconnectedState entry: " + response.returnCode);
    	if (response.returnCode == 200) {
		    this.status.innerHTML = this.collabDisconnectedString; 
		}
		else {
		    this.status.innerHTML = this.collabDisconnectFailedString;
		}	
		dojo.style(this.endCollaborationButton.domNode,    'display', 'none'); //hide it
		dojo.style(this.openCollabDialogButton.domNode,    'display', 'none'); //hide it
		dojo.style(this.createCollabInviteString,          'display', '');//show it
		dojo.style(this.createCollaborationButton.domNode, 'display', '');//show it
		dojo.style(this.invitationLinkString,              'display', 'none');//show it
		this.peerCollaborationLink.set('value', ""); //display empty peerCollaborationLink test box
		
		this.collaborationDialog.stopDataPolling();
		this.collaborationDialog.stopCollaborationStatusPolling(this._convertToCollaborationStatusHitch);
		console.log("_convertToDisconnectedState exit");
	},
	
	_convertToCollaborationStatusState: function(event){
		// summary: The status of the two collaborators has changed.  Show the correct state
		console.log("_convertToCollaborationStatusState entry: " + event);
		if (event.type == 2){
			this.collaborationDialog._collaborationStatus = event.data;
			
			//if we move from NOT_ESTABLISHED to ESTABLISHED reset the display and start polling
			if (event.data == "ESTABLISHED") {
				dojo.style(this.endCollaborationButton.domNode,    'display', '');//show it
				dojo.style(this.openCollabDialogButton.domNode,    'display', '');//show it
				dojo.style(this.createCollabInviteString,          'display', 'none'); //hide it
				dojo.style(this.createCollaborationButton.domNode, 'display', 'none'); //hide it
				dojo.style(this.invitationLinkString,              'display', 'none'); //hide it
				dojo.style(this.status,                    	 	   'display', '');//show it
				this.status.innerHTML = this.collabConnectedString;
			
				this.collaborationDialog.resetCollaborationDialog();
				this.collaborationDialog.startDataPolling();
				this.collaborationDialog.sendConnectedEventToPeer();
				this.openCollabDialog();
			}
			//if we move from ESTABLISHED to NOT_ESTABLISHED reset the display and stop polling
			if (event.data == "NOT_ESTABLISHED") {
				
				//Need to call delete to cleanup the initiator's session.  
				//We can determine if this is the initiator by checking that the peerCollaborationLink is not ""
			    if (this.peerCollaborationLink.get('value') != ""){
			    	this.collaborationDialog.endCollaborationSession(null);
			    }
				
				dojo.style(this.endCollaborationButton.domNode,    'display', 'none'); //hide it
				dojo.style(this.openCollabDialogButton.domNode,    'display', 'none'); //hide it
				dojo.style(this.createCollabInviteString,          'display', '');//show it
				dojo.style(this.createCollaborationButton.domNode, 'display', '');//show it
				dojo.style(this.invitationLinkString,              'display', 'none');//show it
				this.peerCollaborationLink.set('value', ""); //display empty peerCollaborationLink test box
				this.status.innerHTML = this.collabDisconnectedString;
			
				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
				this.collaborationDialog.stopDataPolling();
				this.collaborationDialog.stopCollaborationStatusPolling(this._convertToCollaborationStatusHitch);
			}
		} else if (event.type == 0){
			if (event.data == "EVENT_POLLING_REPLACED") {
				this.status.innerHTML = this.eventPollingReplacedString;
				this.endCollaborationButton.set("disabled", true);
				this.openCollabDialogButton.set("disabled", true);
				this.createCollaborationButton.set("disabled", true);
				
				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
			} else if (event.data == "EVENT_POLLING_FAILED") {
				this.status.innerHTML = this.eventPollingFailedString;
				this.endCollaborationButton.set("disabled", true);
				this.openCollabDialogButton.set("disabled", true);
				this.createCollaborationButton.set("disabled", true);

				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
			}	
		}
		console.log("_convertToCollaborationStatusState exit");
	}
	
});

}
