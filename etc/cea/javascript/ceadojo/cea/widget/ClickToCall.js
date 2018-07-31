/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.ClickToCall"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.ClickToCall"] = true;
dojo.provide("cea.widget.ClickToCall");

dojo.require('cea.widget.CollaborationDialog');
dojo.require('cea.widget.EventHandler');
dojo.require("dijit._Templated");
dojo.require("dijit._Widget");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dojo.cookie");
dojo.require("dojo.i18n");
dojo.require("dijit.Dialog");

dojo.requireLocalization("cea.widget", "ClickToCall", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.widget.ClickToCall", [dijit._Widget, dijit._Templated, cea.widget.EventHandler], {
	//	
	//	summary: A widget for embedding click to call functionality.
	//
	//	description: 
	//		This widget provides the ability for a user to enter a phone number/sip uri and then make a phone call
	//     	between the user's phone and the phone number/sip uri coded in widgetNumber.  Once the call is initiated the widget 
	//		provides basic status updates and call control.  Optionally this widget can be configured to provide a CollaborationDialog
	//		allowing the user to engage in a co-browse scenario with the callee.	
	//
	//	example:
	//	|	 <div dojoType="cea.widget.ClickToCall" widgetNumber="xxx-xxx-xxxx" enableCollaboration="true" canControlCollaboration="true"></div>
	//	
	
	templateString:"<div>\n\t<table class=\"clickToCallWidget\">\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t<label dojoAttachPoint=\"phoneNumberLabel\" title=\"${myNumberString}\"></label>\n\t\t\t\t\t\t\t<input name=\"phoneNumber\" dojoType=\"dijit.form.TextBox\" dojoAttachPoint=\"phoneNumber\" class=\"clickToCallWidgetTextBox\" placeHolder=\"${myNumberString}\"></input>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:call\" dojoAttachPoint=\"callButton\" iconClass=\"clickToCallWidgetIcon clickToCallWidgetCallIcon\" class=\"clickToCallWidgetButton\">${callButtonString}</button></td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:hangup\" dojoAttachPoint=\"hangupButton\"  iconClass=\"clickToCallWidgetIcon clickToCallWidgetEndCallIcon\" class=\"clickToCallWidgetButton\" style=\"display:none\">${hangupButtonString}</button></td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:cobrowse\" dojoAttachPoint=\"cobrowseButton\"  iconClass=\"clickToCallWidgetIcon clickToCallWidgetCollaborateIcon\" class=\"clickToCallWidgetButton\" style=\"display:none\">${cobrowseButtonString}</button></td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td colspan=\"4\" dojoAttachPoint=\"status\" class=\"clickToCallWidgetStatus\" style=\"display:none\"></td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t</tr>\n\t</table>\n\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\" sendPageUrlRewriteCallback=\"${sendPageUrlRewriteCallback}\"></div>\n</div>\n",
	widgetsInTemplate: true,
	
	//	widgetNumber: String
	//		The phone number or unique identifier that this widget should use as the callee
	widgetNumber: "",
	//	enableCollaboration: String
	//		A flag to determine whether this widget will be available for a collaboration session
	enableCollaboration: "false",
	//canControlCollaboration: String
	//		Determines whether this widget can drive the collaboration session
	canControlCollaboration: "false",
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
	//	peerDeviceControlled: String
	//		A flag to determine which device should be controlled to initiate the call.  If true the device specified by widgetNumber is used
	//		and if false the device specified by the end user ( 'My Number' ) will be used.
	//
	peerDeviceControlled: "true",

	_addressOfRecord: "",
	_peerAddressOfRecord: "",
	_callerAddressOfRecord:"",
	_calleeAddressOfRecord:"",
	_callServiceUri: "",
	
	_topCEACollabDialog: null,

	postMixInProperties: function() {
		this.inherited(arguments);
		this.initializeNLSStrings();
		this._topCEACollabDialog = window.top._ceaCollabDialog;
	},
	
	postCreate: function() {
		//Associate the accessible label with the phoneNumber textfield
		this.phoneNumberLabel.htmlFor = this.phoneNumber.textbox.id;
		
		//Hitch the _convertToCallStatusState function to a variable so it can be added/removed as an event handler
		this._convertToCallStatusStateHitch = dojo.hitch(this,"_convertToCallStatusState");
		
		//Because the eventHandler is also used by the CollaborationDialog we need to override 
		//the ceaContextRoot otherwise it will always be the default
		if (this.collaborationDialog){
			this.collaborationDialog.ceaContextRoot = this.ceaContextRoot;
		}
		
		console.log("Browser cookies enabled: " + dojo.cookie.isSupported());
		if (!dojo.cookie.isSupported()){
			//Check if the browser cookies are enabled and if not disable the widget and display a message
			this._convertToWidgetDisabledState(this.enableCookiesString);
		} else if ( this._topCEACollabDialog != null){
			//Check if the widget page is loaded in the CollaborationDialog and if so disable the widget and display a message
			this._convertToWidgetDisabledState(this.widgetInUseString);
		} else {
			this.detectExistingCall(dojo.hitch(this,"_convertToAlreadyConnectedState"));	
		}
		
		this.inherited(arguments);	
	},
	
	initializeNLSStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget
		this._messages = dojo.i18n.getLocalization("cea.widget", "ClickToCall", this.lang);
		
		this.myNumberString = this._messages["MY_NUMBER"];
		
		this.callButtonString = this._messages["CALL_BUTTON"];
		this.hangupButtonString = this._messages["HANGUP_BUTTON"];
		this.cobrowseButtonString = this._messages["COBROWSE_BUTTON"];
		
		this.callingString = this._messages["CALLING"];
		this.connectedString = this._messages["CONNECTED"];
		this.disconnectedString = this._messages["DISCONNECTED"];
		this.callFailString = this._messages["CALL_FAIL"];
		this.hangupFailString = this._messages["HANGUP_FAIL"];
		
		this.hangupTitleString = this._messages["HANGUP_TITLE"];
		this.confirmHangupString = this._messages["CONFIRM_END"];
		this.serviceUnavailableString = this._messages["SERVICE_UNAVAILABLE"];
		
		this.eventPollingReplacedString = this._messages["EVENT_POLLING_REPLACED"];
		this.eventPollingFailedString = this._messages["EVENT_POLLING_FAILED"];
		
		this.YES = this._messages["YES"];
		this.NO = this._messages["NO"];
		
		this.widgetInUseString = this._messages["WIDGET_IN_USE"];
		this.enableCookiesString = this._messages["ENABLE_COOKIES"];
		
	},
		
	call: function() {
		// summary: Invoked when the user clicks the 'Call' button for this widget
		this.makeCall(dojo.hitch(this,"_convertToConnectingState"));	
	},
	
	hangup: function() {
		// summary: Invoked when the user clicks the 'Hangup' button for this widget
		var self = this;
		var confirmDialog = new dijit.Dialog({ id: 'queryDialog', title:this.hangupTitleString});
		
		// When either button is pressed, kill the dialog and call the callbackFn.
		var cancelDialog = function(mouseEvent) {
			//Cross-Browser compatibility so that targ= the actual target button that was pressed
			var targ;
			if (!mouseEvent) { 
				var mouseEvent = window.event; 
			}
			if (mouseEvent.target) { 
				targ = mouseEvent.target;
			} else if (mouseEvent.srcElement) {
				targ = mouseEvent.srcElement;
			}
	
			confirmDialog.hide();
			confirmDialog.destroyRecursive();
			yesButton.destroyRecursive();
			noButton.destroyRecursive();
			var targ_string = targ.id.toString();
			if (targ_string.indexOf('yesButton')!= -1){
				self.endCall(dojo.hitch(self,"_convertToDisconnectedState"));
			} else {
				return;
			}
		};
    
		confirmDialog.set("content", "<p>" + this.confirmHangupString + "</p>");
		var yesButton = new dijit.form.Button({ label: this.YES, id: 'yesButton', onClick: cancelDialog});
		var noButton = new dijit.form.Button({ label: this.NO, id: 'noButton', onClick: cancelDialog});

		confirmDialog.containerNode.appendChild(yesButton.domNode);
		confirmDialog.containerNode.appendChild(noButton.domNode);

		confirmDialog.show();
	},
	
	cobrowse: function() {
		// summary: Invoked when the user clicks the 'Cobrowse' button for this widget
		this.collaborationDialog.openCollaborationDialog();
	},
	
	makeCall: function(handler) {
		// summary:	Make a request to the rest service to initiate the call.  
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		data = '{"peerDeviceControlled":"'+ this.peerDeviceControlled +'", "addressOfRecord":"'+ this.phoneNumber.get('value') +'","peerAddressOfRecord":"'+ this.widgetNumber +'","enableCollaboration":"'+ this.enableCollaboration +'"}';
	
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
	
		var deferred = dojo.rawXhrPut({
			url: this.ceaContextRoot + "/CommServlet/call?JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			putData: data,
			sync: true,		
				
			load: function(response, ioArgs) {
				console.log("makeCall.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._callerAddressOfRecord = response.callerAddressOfRecord;
					self._calleeAddressOfRecord = response.calleeAddressOfRecord;
					self._callServiceUri 		= response.callServiceUri;	
					self._eventUri				= response.eventUri;
					
					if (self.collaborationDialog){
						self.collaborationDialog._eventUri = response.eventUri;
					}
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("makeCall.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		//If provided add the callback used to style the widget based on the rest service response
		if(handler){
			deferred.addBoth(dojo.hitch(self,handler));
		}
		return deferred;
	},
	
	endCall: function(handler) {
		// summary: Make a request to the rest service to end the call
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrDelete({
			url: this.ceaContextRoot + "/" + this._callServiceUri + "?JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			sync: true,		
				
			load: function(response, ioArgs) {
				console.log("endCall.load: " + ioArgs.xhr.responseText);
 				return response;
			},
			error: function(response, ioArgs) {
				console.log("endCall.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		//If provided add the callback used to style the widget based on the rest service response
		if(handler){
			deferred.addBoth(dojo.hitch(self,handler));
		}
		return deferred;
	},
	
	joinCollaborationSession: function(event) {
		// summary: Make a request to the rest service using the peerCollaborationUri to join the collaboration session
		this.collaborationDialog.joinCollaborationSession(event.infoMsg, dojo.hitch(this,"_convertToCollaborationStatusState"));				
	},
	
	startPollingForCallStatus: function(handler) {
		// summary: Add the call status event handler to start polling for call status changes
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		this.addEventHandler(handler);
	},
	
	stopPollingForCallStatus: function(handler) {
		// summary: Remove the call status event handler to stop polling for call status changes
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("stopPollingForCallStatus");
		this.removeEventHandler(handler);
	},
		
	detectExistingCall: function(handler) {
		// summary: Used to determine if there is an existing call session when the widget loads.
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrGet({
			url: this.ceaContextRoot + "/CommServlet/call?JSON=true&ceaVersion=" + ceaVersion, 
			sync: false,
			handleAs: "json-comment-optional",
			preventCache: true,
				
			load: function (response, ioArgs) {
				console.log("detectExistingCall.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._callerAddressOfRecord = response.callerAddressOfRecord;
					self._calleeAddressOfRecord = response.calleeAddressOfRecord;
					self._callServiceUri = response.callServiceUri;
					self._eventUri = response.eventUri;
					if (response.collaborationStatus == "ESTABLISHED"){
						if (self.collaborationDialog){
							self.collaborationDialog._callServiceUri = response.callServiceUri;
							self.collaborationDialog._collaborationStatus = response.collaborationStatus;
							self.collaborationDialog._collaborationServiceUri = response.collaborationServiceUri;
							self.collaborationDialog._forPeerCollaborationUri = response.forPeerCollaborationUri;
							self.collaborationDialog._eventUri = response.eventUri;
						}
					}
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("detectExistingCall.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(dojo.hitch(self,handler));
		}
		return deferred;
	},

	addEventHandler: function(handler){
		// summary: Add an event handler to the list that will be triggered when a CEA event occurs
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		if (this.collaborationDialog){
			this.collaborationDialog.addEventHandler(handler);
		} else {
			this.inherited(arguments);
		}
	},
	
	removeEventHandler: function(handler){
		// summary: Remove an event handler from the list that will be triggered when a CEA event occurs
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		if (this.collaborationDialog){
			this.collaborationDialog.removeEventHandler(handler);
		} else {
			this.inherited(arguments);
		}
	},
	
	_convertToAlreadyConnectedState: function(response){
		// summary: Callback invoked after the rest service request for detectExistingCall has completed.  
		//		Styles the widget appropriately based on the response to show default or connecting states
		// response: The JSON response from the detectExistingCall rest service request
		console.log("_convertToAlreadyConnectedState entry: " + response.returnCode);
		
		//Grab the cookie value for addressOfRecord and then set it appropriately to show the current number
		if (dojo.cookie("addressOfRecord") != "null" && dojo.cookie("addressOfRecord") != ""){
			this.phoneNumber.set('value',dojo.cookie("addressOfRecord"));
		}
		
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
			this.callButton.set("disabled", true);
			this.phoneNumber.set("disabled", true);
		} else if (disableWidget == true) {
			this.status.innerHTML = this.serviceUnavailableString;
			dojo.style(this.status, 'display', '');
			this.callButton.set("disabled", true);
			this.phoneNumber.set("disabled", true);
			
			widgetVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
			console.log("The widget version " + widgetVersion + " is at a newer level than the CEA service version " + ceaVersion + " and will be disabled");
			
		} else if (response.returnCode == 200) {	
			if (response.callStatus == "CALL_STATUS_INITIATED"){
				this.status.innerHTML = this.callingString;
				this.startPollingForCallStatus(this._convertToCallStatusStateHitch);
			} else if (response.callStatus == "CALL_STATUS_ESTABLISHED"){
				if (this.peerDeviceControlled == "true"){
					this.status.innerHTML = this.connectedString + this._callerAddressOfRecord;
				} else {
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				}
				this.phoneNumber.set("readOnly", true);	
			
				dojo.io.iframe.setSrc(this.collaborationDialog.collaborationDialogContentPane.domNode, dojo.cookie("collaborationUri"), true);
		    	this.collaborationDialog.cobrowseTextBox.set('value', dojo.cookie("collaborationUri"));
		    	this.collaborationDialog._peerCanControlCollaboration = (dojo.cookie("peerCanControlCollaboration") == "true") ? true:false;
		    	this.collaborationDialog._hasCollaborationControl = (dojo.cookie("hasCollaborationControl") == "true") ? true:false;
		    	this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":dojo.cookie("peerDialogStatus")}});
		    	
				this.startPollingForCallStatus(this._convertToCallStatusStateHitch);
				
				if (response.collaborationStatus == "ESTABLISHED"){
					dojo.style(this.cobrowseButton.domNode, 'display', '');
					this.collaborationDialog.startDataPolling();
					this.collaborationDialog.sendConnectedEventToPeer();
				}		
			}
			dojo.style(this.status, 'display', '');
			dojo.style(this.callButton.domNode, 'display', 'none');
			dojo.style(this.hangupButton.domNode, 'display', '');
			this.phoneNumber.set("readOnly", true);
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
		this.callButton.set("disabled", true);
		this.phoneNumber.set("disabled", true);
		
		console.log("_convertToWidgetDisabledState exit");
	},
	
	_convertToConnectingState: function(response){
		// summary: Callback invoked after the rest service request for makeCall has completed.  
		//		Styles the widget appropriately based on the response to show connected or call fail states
		// response: The JSON response from the makeCall rest service request
		console.log("_convertToConnectingState entry: " + response.returnCode);
		if (response.returnCode == 200) {	
			this.status.innerHTML = this.callingString;
			dojo.style(this.callButton.domNode, 'display', 'none');
			dojo.style(this.hangupButton.domNode, 'display', '');
			this.phoneNumber.set("readOnly", true);
			
			//When the call is invoked save the number in a cookie to be used if the page containing the widget is refreshed
			dojo.cookie("addressOfRecord", this.phoneNumber.get('value'));
			
			this.startPollingForCallStatus(this._convertToCallStatusStateHitch);
		} else {
			this.status.innerHTML = this.callFailString;
		}
		dojo.style(this.status, 'display', '');
		console.log("_convertToConnectingState exit");
	},
	
	_convertToDisconnectedState: function(response){
		// summary: Callback invoked after the rest service request for endCall has completed.  
		//		Styles the widget appropriately based on the response to show disconnected or hangup fail states
		// response: The JSON response from the endCall rest service request
		console.log("_convertToDisconnectedState entry: " + response.returnCode);
		if (response.returnCode == 200) {
			this.status.innerHTML = this.disconnectedString;
			dojo.style(this.callButton.domNode, 'display', '');
			dojo.style(this.hangupButton.domNode, 'display', 'none');
			dojo.style(this.cobrowseButton.domNode, 'display', 'none');
			this.phoneNumber.set("readOnly", false);
			
			this.collaborationDialog.stopDataPolling();
			this.stopPollingForCallStatus(this._convertToCallStatusStateHitch);
		
		} else {
			this.status.innerHTML = this.hangupFailString;
		}
		console.log("_convertToDisconnectedState exit");
	},
	
	_convertToCallStatusState: function(event){
		// summary: Callback invoked after the rest service request for call status has completed.  
		//		Styles the widget appropriately based on the response to show connected or disconnected states
		// response: The JSON response from the call status rest service request
		console.log("_convertToCallStatusState entry: " + event);
		if (event.type == 2){
			this.collaborationDialog._collaborationStatus = event.data;
			if (event.data == "PEER_URI_AVAILABLE"){
				this.joinCollaborationSession(event);
			} else if (event.data == "ESTABLISHED") {
				dojo.style(this.cobrowseButton.domNode, 'display', '');
				this.collaborationDialog.resetCollaborationDialog();
				this.collaborationDialog.startDataPolling();
				this.collaborationDialog.sendConnectedEventToPeer();
				
				//because ClickToCall does not always call joinCollaborationSession 
				//we need set the _hasCollaborationControl flag when the session starts
				this.collaborationDialog._hasCollaborationControl = false;
				dojo.cookie("hasCollaborationControl",false);
			}
		} else if (event.type == 1){
			if (event.data == "CALL_STATUS_ESTABLISHED") {
				if (this.peerDeviceControlled == "true"){
					this.status.innerHTML = this.connectedString + this._callerAddressOfRecord;
				} else {
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				}
			} else if (event.data == "CALL_STATUS_FAILED") { 
				this.status.innerHTML = this.disconnectedString;	
				dojo.style(this.callButton.domNode, 'display', '');
				dojo.style(this.hangupButton.domNode, 'display', 'none');
				dojo.style(this.cobrowseButton.domNode, 'display', 'none');
				this.phoneNumber.set("readOnly", false);
				this.stopPollingForCallStatus(this._convertToCallStatusStateHitch);
				this.status.innerHTML = this.callFailString;
			} else if (event.data == "CALL_STATUS_CLEARED") {
				this.status.innerHTML = this.disconnectedString;	
				dojo.style(this.callButton.domNode, 'display', '');
				dojo.style(this.hangupButton.domNode, 'display', 'none');
				dojo.style(this.cobrowseButton.domNode, 'display', 'none');
				this.phoneNumber.set("readOnly", false);

				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
				this.collaborationDialog.stopDataPolling();
				this.stopPollingForCallStatus(this._convertToCallStatusStateHitch);
			}		
		} else if (event.type == 0){
			if (event.data == "EVENT_POLLING_REPLACED") {
				this.status.innerHTML = this.eventPollingReplacedString;
				
				this.callButton.set("disabled", true);
				this.phoneNumber.set("disabled", true);	
				this.hangupButton.set("disabled", true);
				this.cobrowseButton.set("disabled", true);

				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
			} else if (event.data == "EVENT_POLLING_FAILED") {
				this.status.innerHTML = this.eventPollingFailedString;
				
				this.callButton.set("disabled", true);
				this.phoneNumber.set("disabled", true);	
				this.hangupButton.set("disabled", true);
				this.cobrowseButton.set("disabled", true);

				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
			}
		}
		console.log("_convertToCallStatusState exit");
	},
	
	_convertToCollaborationStatusState: function(response){
		// summary: Callback invoked after the rest service request to joinCollaboration has completed.  
		//		Styles the widget appropriately based on the response to show collaborating state
		// response: The JSON response from the joinCollaborationSession rest service request
		console.log("_convertToCollaborationStatusState entry: " + response);
		
	}
	
});

}
