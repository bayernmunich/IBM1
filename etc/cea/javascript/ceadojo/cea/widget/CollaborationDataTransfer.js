/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource['cea.widget.CollaborationDataTransfer']){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource['cea.widget.CollaborationDataTransfer'] = true;
dojo.provide('cea.widget.CollaborationDataTransfer');

dojo.require('cea.widget.EventHandler');
/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.widget.CollaborationDataTransfer", [cea.widget.EventHandler], {
	//	
	//	summary: A class for creating/destroying collaboration session also
	// 		sending/receiving data using the rest service once the collaboration session has been created.
	//
	//	description: 
	//		This widget provides the basic calls to create, join and end a collaboration session with a peer.  Once the collaboration 
	//		session is initialized this widget can be used to send data to the peer or get data sent by the peer.
	//
	//	example:
	//	|	dojo.declare('cea.widget.CollaborationDialog', [dijit.Dialog, cea.widget.CollaborationDataTransfer], {

	//canControlCollaboration: String
	//		Determines whether this widget can drive the collaboration session
	canControlCollaboration: "false",
	
	_collaborationStatus: "", 
	_collaborationServiceUri: "", 
	_forPeerCollaborationUri: "", 
	
	_peerCanControlCollaboration: false,
	_hasCollaborationControl: true,
	
	createCollaborationSession: function(handler){
		// summary: Queries rest service to create a collaboration session link
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		data = '';

		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;

		var deferred = dojo.rawXhrPut({
			url: this.ceaContextRoot + "/CommServlet/collaborationSession?JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			putData: data,
			sync: true,		
			
			load: function(response, ioArgs) {
				console.log("createCollaborationSession.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._collaborationStatus     = response.collaborationStatus;
					self._collaborationServiceUri = response.collaborationServiceUri;
					self._forPeerCollaborationUri = response.forPeerCollaborationUri;
					self._eventUri         		  = response.eventUri;
					self._hasCollaborationControl = true;
					dojo.cookie("hasCollaborationControl",true);
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("createCollaborationSession.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
		}
		return deferred;
	},

	joinCollaborationSession: function(collabLink, handler) {
		// summary: Makes a call to the rest service to joins an existing collaboration session
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrGet({
			url: this.ceaContextRoot + "/" + collabLink + "&JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			sync: true,		
			preventCache: true,
			
			load: function(response, ioArgs) {		
				console.log("joinCollaborationSession.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					self._callServiceUri 		  = response.callServiceUri;
					self._collaborationStatus 	  = response.collaborationStatus;
					self._collaborationServiceUri = response.collaborationServiceUri;
					self._forPeerCollaborationUri = response.forPeerCollaborationUri;
					self._eventUri         		  = response.eventUri;
					self._hasCollaborationControl = false;
					dojo.cookie("hasCollaborationControl",false);
				}
				return response;
			},
			error: function(response, ioArgs) {	
				console.log("joinCollaborationSession.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
		}
		return deferred;
	},

	endCollaborationSession: function(handler) {
		// summary:  Makes a call to the rest service to end a collaboration session
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrDelete({
			url: this.ceaContextRoot + "/" + this._collaborationServiceUri + "?JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			headers: {"Content-Type": "text/html"}, 
			sync: true,		
     	
			load: function(response, ioArgs) {
				console.log("endCollaborationSession.load: " + ioArgs.xhr.responseText);
				return response;
			},
			error: function(response, ioArgs) {
				console.log("endCollaborationSession.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
		}
		return deferred;
	},
	
	detectExistingCobrowse: function(handler) {
		// summary: Used to determine if there is an existing cobrowse session when the widget loads.
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		var deferred = dojo.xhrGet({
			url: this.ceaContextRoot + "/CommServlet/collaborationSession?JSON=true&ceaVersion=" + ceaVersion,
			sync: false,
			handleAs: "json-comment-optional",
			preventCache: true,
				
			load: function (response, ioArgs) {
				console.log("detectExistingCobrowse.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200) {
					//The values we need to set are the same regardless if its ESTABLISHED or NOT_ESTABLISHED
					self._collaborationStatus     = response.collaborationStatus;
					self._collaborationServiceUri = response.collaborationServiceUri;
					self._forPeerCollaborationUri = response.forPeerCollaborationUri;
					self._eventUri         		  = response.eventUri;
				}
				return response;
			},
			error: function(response, ioArgs) {
				console.log("detectExistingCobrowse.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
		if(handler){
			deferred.addBoth(handler);
		}  
		return deferred;
	},
	
	sendConnectedEventToPeer: function() {
		// summary: Sends an events to the peer to show that they are connected and whether they can control navigation.
		this.sendDataEvent('{"collaborationData":{"dialogStatusEvent":"peerConnected"}}');
		//need to send the data as string instead of a boolean
		this.sendDataEvent('{"collaborationData":{"peerCanControlCollaboration":"'+ this.canControlCollaboration +'"}}');
	},

	startCollaborationStatusPolling: function(handler){
		// summary: Add the collaboration status event handler to start polling for collaboration status changes
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("startCollaborationStatusPolling");
		this.addEventHandler(handler);
	},

	stopCollaborationStatusPolling: function(handler){
		// summary: Remove the collaboration status event handler to stop polling for collaboration status changes
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("stopCollaborationStatusPolling");
		this.removeEventHandler(handler);
	},
	
	sendDataEvent: function(data) {
		// summary: Wrapper for the sendDataEvent that checks to be sure the collaborationStatus is ESTABLISHED.
		if ( this._collaborationStatus == "ESTABLISHED" ){
			this.inherited(arguments);
		} else {
			console.log("sendDataEvent " + data + " canceled, collaborationStatus: " + this._collaborationStatus);
		}
	}

});

}
