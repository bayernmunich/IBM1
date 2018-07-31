/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.CallNotification"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.CallNotification"] = true;
dojo.provide("cea.widget.CallNotification");

dojo.require('cea.widget.CollaborationDataTransfer');
dojo.require('cea.widget.CollaborationDialog');
dojo.require('cea.widget.EventHandler');
dojo.require("dijit._Templated");
dojo.require("dijit._Widget");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dojo.cookie");
dojo.require("dojo.i18n");
dojo.require("dijit.Dialog");

dojo.requireLocalization("cea.widget", "CallNotification", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.widget.CallNotification", [dijit._Widget, dijit._Templated, cea.widget.EventHandler], {
	//	
	//	summary: A widget for embedding call notification functionality.
	//
	//	description: 
	//		This widget provides the ability for a user to enter a phone number/sip uri and then monitor their line for call notifications
	//     	When an incoming call is detected the widget alerts the user and then offers basic status updates and call control.
	//		Optionally this widget can be configured to provide a CollaborationDialog allowing the user to engage in a co-browse scenario with the caller.	
	//
	//	example:
	//	|	 <div dojoType="cea.widget.CallNotification" widgetNumber="xxx-xxx-xxxx" enableCollaboration="true" canControlCollaboration="true"></div>
	//	
	
	templateString:"<div>\n\t<table class=\"callNotificationWidget\">\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t<label dojoAttachPoint=\"phoneNumberLabel\" title=\"${myNumberString}\"></label>\n\t\t\t\t\t\t\t<input name=\"phoneNumber\" dojoType=\"dijit.form.TextBox\" dojoAttachPoint=\"phoneNumber\" class=\"callNotificationWidgetTextBox\" placeHolder=\"${myNumberString}\"></input>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:start\" dojoAttachPoint=\"startButton\" showLabel=\"false\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetRegisterIcon\" class=\"callNotificationWidgetButton\">${startCallNotificationButtonString}</button></td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:stop\" dojoAttachPoint=\"stopButton\" showLabel=\"false\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetUnregisterIcon\" class=\"callNotificationWidgetButton\" style=\"display:none\">${stopCallNotificationButtonString}</button></td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:cobrowse\" dojoAttachPoint=\"cobrowseButton\" showLabel=\"false\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetCobrowseIcon\" class=\"callNotificationWidgetButton\" disabled=\"disabled\">${cobrowseButtonString}</button></td>\n\t\t\t\t\t\t<td><button dojoType=\"dijit.form.Button\" dojoAttachEvent=\"onClick:hangup\" dojoAttachPoint=\"hangupButton\" showLabel=\"false\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetHangupIcon\" class=\"callNotificationWidgetButton\" disabled=\"disabled\">${hangupButtonString}</button></td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td COLSPAN=\"5\" dojoAttachPoint=\"status\" class=\"callNotificationWidgetStatus\" style=\"display:none\"></td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td dojoAttachPoint=\"debug\" style=\"display:none\"></td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</td>\n\t\t</tr>\n\t</table>\n\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\" sendPageUrlRewriteCallback=\"${sendPageUrlRewriteCallback}\"></div>\n</div>\n",
	widgetsInTemplate: true,
	
	//	widgetNumber: String
	//		The phone number or unique identifier that this widget should use to register for call notification
	widgetNumber: "",
	//	enableCollaboration: String
	//		A flag to determine whether this widget will be available for a collaboration session
	enableCollaboration: "false",
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
	
	_addressOfRecord: "",
	_callerAddressOfRecord: "",
	_calleeAddressOfRecord: "",
	_callServiceUri: "",
	_callNotifyUri: "",
	
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
		this._convertToCallStatusStateHitch = dojo.hitch(this, "_convertToCallStatusState");
		
		//Because the eventHandler is also used by the CollaborationDialog we need to override 
		//the ceaContextRoot otherwise it will always be the default
		if (this.collaborationDialog){
			this.collaborationDialog.ceaContextRoot = this.ceaContextRoot;
		}
			
		if ( this.widgetNumber != "") {
			this.phoneNumber.set('value', this.widgetNumber);
			dojo.style(this.phoneNumber.domNode, 'display', 'none');
		}
		
		console.log("Browser cookies enabled: " + dojo.cookie.isSupported());
		if (!dojo.cookie.isSupported()){
			//Check if the browser cookies are enabled and if not disable the widget and display a message
			this._convertToWidgetDisabledState(this.enableCookiesString);
		} else if ( this._topCEACollabDialog != null){
			//Check if the widget page is loaded in the CollaborationDialog and if so disable the widget and display a message
			this._convertToWidgetDisabledState(this.widgetInUseString);
		} else {
			this.detectExistingCallNotification(dojo.hitch(this, "_convertToAlreadyConnectedState"));
		}
		
		this.inherited(arguments);
	},
	
	initializeNLSStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget 
		this._messages = dojo.i18n.getLocalization("cea.widget", "CallNotification", this.lang);
		
		this.myNumberString = this._messages["MY_NUMBER"];
		
		this.startCallNotificationButtonString = this._messages["START_CALL_NOTIFICATION_BUTTON"];
		this.stopCallNotificationButtonString = this._messages["STOP_CALL_NOTIFICATION_BUTTON"];
		this.hangupButtonString = this._messages["HANGUP_BUTTON"];
		this.cobrowseButtonString = this._messages["COBROWSE_BUTTON"];

		this.availableString = this._messages["AVAILABLE"];
		this.connectedString = this._messages["CONNECTED"];
		this.disconnectedString = this._messages["DISCONNECTED"];
		
		this.startCallNotificationFailString = this._messages["START_CALL_NOTIFICATION_FAIL"];
		this.stopCallNotificationFailString = this._messages["STOP_CALL_NOTIFICATION_FAIL"];
	 	this.serviceUnavailableString = this._messages["SERVICE_UNAVAILABLE"];
	 	this.eventPollingReplacedString = this._messages["EVENT_POLLING_REPLACED"];
		this.eventPollingFailedString = this._messages["EVENT_POLLING_FAILED"];
		
		
		this.hangupTitleString = this._messages["HANGUP_TITLE"];
		this.stopCallNotificationTitleString = this._messages["STOP_CALL_NOTIFICATION_TITLE"];
	 	this.confirmStopString = this._messages["CONFIRM_STOP"];
		this.confirmHangupString = this._messages["CONFIRM_HANGUP"];
		this.YES = this._messages["YES"];
		this.NO = this._messages["NO"];
		
		this.widgetInUseString = this._messages["WIDGET_IN_USE"];
		this.enableCookiesString = this._messages["ENABLE_COOKIES"];

	},
	
	start: function() {
		// summary: Invoked when the user clicks the 'Start call notification' button for this widget
		this.registerForCallNotification(dojo.hitch(this, "_convertToRegisteringState"));		
	},
	
	stop: function() {
		// summary: Invoked when the user clicks the 'Stop call notification' button for this widget
		var self = this;
		var confirmDialog = new dijit.Dialog({ id: 'queryDialog', title:this.stopCallNotificationTitleString});
    
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
				self.unregisterForCallNotification(dojo.hitch(self, "_convertToUnregisteredState"));
			}
		};
		
		confirmDialog.set("content", "<p>" + this.confirmStopString + "</p>");
		var yesButton = new dijit.form.Button({ label: this.YES, id: 'yesButton', onClick: cancelDialog});
		var noButton = new dijit.form.Button({ label: this.NO, id: 'noButton', onClick: cancelDialog});

		confirmDialog.containerNode.appendChild(yesButton.domNode);
		confirmDialog.containerNode.appendChild(noButton.domNode);

		confirmDialog.show();
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
			} else if (mouseEvent.srcElement){
				targ = mouseEvent.srcElement;
			}
	
			confirmDialog.hide();
			confirmDialog.destroyRecursive();
			yesButton.destroyRecursive();
			noButton.destroyRecursive();
    	
			var targ_string = targ.id.toString();
			if (targ_string.indexOf('yesButton')!= -1){
				self.endCall(dojo.hitch(self, "_convertToDisconnectedState"));
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
	
	registerForCallNotification: function(handler) {
		// summary:	Make a request to the rest service to initiate call notification
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		data = '{"addressOfRecord":"'+ this.phoneNumber.get('value') +'","enableCollaboration":"'+ this.enableCollaboration +'"}';
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.rawXhrPut({
			url: this.ceaContextRoot + "/CommServlet/callerNotification?JSON=true&ceaVersion=" + ceaVersion, 
			handleAs: "json-comment-optional",
			putData: data,
			sync: true,		
				
			load: function(response, ioArgs) {
				console.log("registerForCallNotification.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._calleeAddressOfRecord = response.calleeAddressOfRecord;
					self._callNotifyUri = response.callNotifyUri;
					self._eventUri = response.eventUri;
					
					if (self.collaborationDialog){
						self.collaborationDialog._collaborationServiceUri = response.collaborationServiceUri;
						self.collaborationDialog._forPeerCollaborationUri = response.forPeerCollaborationUri;
						self.collaborationDialog._eventUri				  = response.eventUri;
					}
					
					return response;
				}
			},
			error: function(response, ioArgs) {
				console.log("registerForCallNotification.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
		}
		return deferred;
	},
	
	unregisterForCallNotification: function(handler) {
		// summary: Make a request to the rest service to stop call notification
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrDelete({
			url: this.ceaContextRoot + "/" + this._callNotifyUri + "?JSON=true&ceaVersion=" + ceaVersion, 
			handleAs: "json-comment-optional",
			sync: true,		
				
			load: function(response, ioArgs) {
				console.log("unregisterForCallNotification.load: " + ioArgs.xhr.responseText);
 				return response;
			},
			error: function(response, ioArgs) {
				console.log("unregisterForCallNotification.error: " + ioArgs.xhr.responseText);	
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
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
		if(handler){
			deferred.addBoth(handler);
		}
		return deferred;
	},
	
	joinCollaborationSession: function(event) {
		// summary: Make a request to the rest service using the peerCollaborationUri to join the collaboration session
		this.collaborationDialog.joinCollaborationSession(event.infoMsg, dojo.hitch(this,"_convertToCollaborationStatusState"));				
	},
	
	getCallStatus: function() {
		// summary: Make a request to the rest service to get the call	status
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;

		dojo.xhrGet({
			url: this.ceaContextRoot + "/" + self._callNotifyUri + "?JSON=true&ceaVersion=" + ceaVersion,
			sync: true,
			handleAs: "json-comment-optional",
			preventCache: true,
				
			load: function (response, ioArgs) {
				console.log("getCallStatus.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					if (response.callStatus == "CALL_STATUS_ESTABLISHED") {
						self._callServiceUri 		= response.callServiceUri;
						self._callerAddressOfRecord = response.callerAddressOfRecord;
						self._calleeAddressOfRecord = response.calleeAddressOfRecord;
					}
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("getCallStatus.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
	},
	
	startPollingForCallStatus: function(handler) {
		// summary: Once a call notification has been initialized poll the rest service for incoming call notification
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("startPollingForCallStatus");
		this.addEventHandler(handler);
	},
	
	stopPollingForCallStatus: function(handler) {
		// summary: Stop polling the rest service for call status notifications
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("stopPollingForCallStatus");
		this.removeEventHandler(handler);
	},
		
	detectExistingCallNotification: function(handler) {
		// summary: Used to determine if there is an existing call notification session when the widget loads.
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrGet({
			url: this.ceaContextRoot + "/CommServlet/callerNotification?JSON=true&ceaVersion=" + ceaVersion,
			sync: false,
			handleAs: "json-comment-optional",
			preventCache: true,
				
			load: function (response, ioArgs) {
				console.log("detectExistingCallNotification.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._callNotifyUri = response.callNotifyUri;
					self._eventUri = response.eventUri;
					
					if (self.collaborationDialog){
						self.collaborationDialog._collaborationStatus = response.collaborationStatus;
						self.collaborationDialog._collaborationServiceUri = response.collaborationServiceUri;
						self.collaborationDialog._forPeerCollaborationUri = response.forPeerCollaborationUri;
						self.collaborationDialog._eventUri				  = response.eventUri;
					}
					
					if (response.callStatus == "CALL_STATUS_ESTABLISHED") {
						self._callServiceUri 		= response.callServiceUri;
						self._callerAddressOfRecord = response.callerAddressOfRecord;
						self._calleeAddressOfRecord = response.calleeAddressOfRecord;
					}
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("detectExistingCallNotification.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
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
		// summary: Callback invoked after the rest service request for detectExistingCallNotification has completed.  
		//		Styles the widget appropriately based on the response to show default or connected states
		// response: The JSON response from the detectExistingCallNotification rest service request
		console.log("_convertToAlreadyConnectedState entry: " + response.returnCode);	
		
		//Grab the cookie values for addressOfRecord and then set it appropriately to show the current number
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
			this.startButton.set("disabled", true);
			this.phoneNumber.set("disabled", true);
		} else if (disableWidget == true) {
			this.status.innerHTML = this.serviceUnavailableString;
			dojo.style(this.status, 'display', '');
			this.startButton.set("disabled", true);
			this.phoneNumber.set("disabled", true);
			
			widgetVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
			console.log("The widget version " + widgetVersion + " is at a newer level than the CEA service version " + ceaVersion + " and will be disabled");
			
		} else if (response.returnCode == 200) {
			if (response.callStatus == "CALL_STATUS_ESTABLISHED") {
				
				if ( this.phoneNumber.get('value') == this._callerAddressOfRecord) {
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				} else if (this.phoneNumber.get('value') == this._calleeAddressOfRecord){
					this.status.innerHTML = this.connectedString + this._callerAddressOfRecord;
				} else {
					//Call center scenario therefore we know the callee is the peer
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				}
				
				this.phoneNumber.set("readOnly", true);
				dojo.io.iframe.setSrc(this.collaborationDialog.collaborationDialogContentPane.domNode, dojo.cookie("collaborationUri"), true);
		    	this.collaborationDialog.cobrowseTextBox.set('value', dojo.cookie("collaborationUri"));
		    	this.collaborationDialog._peerCanControlCollaboration = (dojo.cookie("peerCanControlCollaboration") == "true") ? true:false;
		    	this.collaborationDialog._hasCollaborationControl = (dojo.cookie("hasCollaborationControl") == "true") ? true:false;
		    	this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":dojo.cookie("peerDialogStatus")}});
		    	
				dojo.style(this.startButton.domNode, 'display', 'none');
				dojo.style(this.stopButton.domNode, 'display', '');
				this.stopButton.set("disabled", true);
				this.phoneNumber.set("readOnly", true);
				if (response.collaborationStatus == "ESTABLISHED"){
					this.cobrowseButton.set("disabled", false);
					this.collaborationDialog.startDataPolling();
					this.collaborationDialog.sendConnectedEventToPeer();
				}
				this.hangupButton.set("disabled", false);
			} else {			
				this.status.innerHTML = this.availableString;
				dojo.style(this.startButton.domNode, 'display', 'none');
				dojo.style(this.stopButton.domNode, 'display', '');
				this.phoneNumber.set("readOnly", true);
			}
			dojo.style(this.status, 'display', '');
			this.startPollingForCallStatus(this._convertToCallStatusStateHitch);
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
		this.startButton.set("disabled", true);
		this.phoneNumber.set("disabled", true);
		
		console.log("_convertToWidgetDisabledState exit");
	},
		
	_convertToRegisteringState: function(response){
		// summary: Callback invoked after the rest service request for registerForCallNotification has completed.  
		//		Styles the widget appropriately based on the response to show registered or register fail states
		// response: The JSON response from the registerForCallNotification rest service request
		console.log("_convertToRegisteringState entry: " + response.returnCode);
		if (response.returnCode == 200) {
			this.status.innerHTML = this.availableString;
			dojo.style(this.startButton.domNode, 'display', 'none');
			dojo.style(this.stopButton.domNode, 'display', '');
			this.phoneNumber.set("readOnly", true);
			//When the registration is invoked save the number in a cookie to be used if the page containing the widget is refreshed
			dojo.cookie("addressOfRecord", this.phoneNumber.get('value'));
			
			this.startPollingForCallStatus(this._convertToCallStatusStateHitch);
		} else {
			this.status.innerHTML = this.startCallNotificationFailString;
		}
		dojo.style(this.status, 'display', '');
		console.log("_convertToRegisteringState exit");
	},
	
	_convertToUnregisteredState: function(response){
		// summary: Callback invoked after the rest service request for unregisterForCallNotification has completed.  
		//		Styles the widget appropriately based on the response to show unregistered or unregister fail states
		// response: The JSON response from the unregisterForCallNotification rest service request
		console.log("_convertToUnregisteredState entry: " + response.returnCode);
		if (response.returnCode == 200) {
			this.status.innerHTML = this.disconnectedString;
			dojo.style(this.startButton.domNode, 'display', '');
			dojo.style(this.stopButton.domNode, 'display', 'none');	
			this.cobrowseButton.set("disabled", true);
			this.hangupButton.set("disabled", true);
			this.phoneNumber.set("readOnly", false);
			
			this.stopPollingForCallStatus(this._convertToCallStatusStateHitch);	
		} else {
			this.status.innerHTML = this.stopCallNotificationFailString;
		}
		console.log("_convertToUnregisteredState exit");
	},
	
	_convertToDisconnectedState: function(response){
		// summary: Callback invoked after the rest service request for endCall has completed.  
		//		Styles the widget appropriately based on the response to show available or hangup fail states
		// response: The JSON response from the endCall rest service request
		console.log("_convertToDisconnectedState entry: " + response.returnCode);
		if (response.returnCode == 200) {
			this.status.innerHTML = this.availableString;
			this.stopButton.set("disabled", false);
			this.cobrowseButton.set("disabled", true);
			this.hangupButton.set("disabled", true);
			
			this.collaborationDialog.stopDataPolling();
			
			//In between sessions we will clean up the CollaborationSession so that each caller gets a new session
			//since the CallNotification side already called endCollaboration we only need to start the new session
			this.collaborationDialog.createCollaborationSession(null);
			
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
		if (event.type == 1){
			if (event.data == "CALL_STATUS_ESTABLISHED") {
				//Make this call to get initialize the call variables
				this.getCallStatus();
				
				if ( this.phoneNumber.get('value') == this._callerAddressOfRecord) {
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				} else if (this.phoneNumber.get('value') == this._calleeAddressOfRecord){
					this.status.innerHTML = this.connectedString + this._callerAddressOfRecord;
				} else {
					//Call center scenario therefore we know the callee is the peer
					this.status.innerHTML = this.connectedString + this._calleeAddressOfRecord;
				}
				
				this.stopButton.set("disabled", true);
				this.hangupButton.set("disabled", false);
				//when a new call comes in hide the CollaborationDialog if it is open so that the CSR can see who is calling
				this.collaborationDialog.hide();
			}
			
			if (event.data == "CALL_STATUS_CLEARED") {
				this.status.innerHTML = this.availableString;
				this.stopButton.set("disabled", false);
				this.cobrowseButton.set("disabled", true);
				this.hangupButton.set("disabled", true);
				
				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
				this.collaborationDialog.stopDataPolling();
				
				//In between sessions we will clean up the CollaborationSession so that each caller gets a new session
				this.collaborationDialog.endCollaborationSession(null);
				this.collaborationDialog.createCollaborationSession(null);
			}		
		} else if (event.type == 2){
			this.collaborationDialog._collaborationStatus = event.data;
			if (event.data == "PEER_URI_AVAILABLE"){
				this.joinCollaborationSession(event);
			} else if (event.data == "ESTABLISHED"){
				this.cobrowseButton.set("disabled", false);
				//because CallNotification does not explicitly call createCollaborationSession 
				//we need set the _hasCollaborationControl flag when each session starts
				this.collaborationDialog._hasCollaborationControl = true;
				dojo.cookie("hasCollaborationControl",true);
				
				this.collaborationDialog.resetCollaborationDialog();
				this.collaborationDialog.startDataPolling();
				this.collaborationDialog.sendConnectedEventToPeer();
			} 
		} else if (event.type == 0){
			if (event.data == "EVENT_POLLING_REPLACED") {
				this.status.innerHTML = this.eventPollingReplacedString;
				this.stopButton.set("disabled", true);
				this.cobrowseButton.set("disabled", true);
				this.hangupButton.set("disabled", true);

				this.collaborationDialog.handleResult({"type": 0,"data": {"dialogStatusEvent":"peerDisconnected"}});
			} else if (event.data == "EVENT_POLLING_FAILED") {
				this.status.innerHTML = this.eventPollingFailedString;
				this.stopButton.set("disabled", true);
				this.cobrowseButton.set("disabled", true);
				this.hangupButton.set("disabled", true);

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
