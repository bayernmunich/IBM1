/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource['cea.widget.EventHandler']){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource['cea.widget.EventHandler'] = true;
dojo.provide('cea.widget.EventHandler');

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.widget.EventHandler", null, {
	//	
	//	summary: A class for receiving CEA events using the rest service
	//
	//	description: 
	//		This widget provides the basic calls to get events, add/remove event handlers and start/stop polling for events
	//
	//	example:
	//	|	dojo.declare("cea.widget.CollaborationDataTransfer", [cea.widget.EventHandler], {
	
	//	ceaContextRoot: String
	//		The context root of the CEA system application
	ceaContextRoot: "/commsvc.rest",
	//	maxEventPollingErrors: String
	//		The number of times event polling can fail in a row before the polling loop will be stopped and the user notified.
	maxEventPollingErrors: "30",
	
	_eventUri: "",
	_eventHandlers: new Array(),
	_eventPolling: false,
	_eventPollingErrors: 0,
	
	getEvent: function(replaceRequest){
		// summary: Queries the rest service for CEA events
		var self = this;

		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;

		// If the collaborationSession didn't established correctly, simply return.
		if (!self._eventUri || (self._eventUri == "")) {
			console.log("getEvent canceled, eventUri: " + self._eventUri);
			return null;
		}

		dojo.xhrGet({
			url: this.ceaContextRoot + "/" + self._eventUri + "?JSON=true&replaceRequest=" + replaceRequest + "&ceaVersion=" + ceaVersion, 
			sync: false,
			handleAs: "json-comment-optional",
			preventCache: true,
				
			load: function (response, ioArgs){
				console.log("getEvent.load: " + ioArgs.xhr.responseText);
				if (response.returnCode == 200){		
					//Each successful request should reset the eventPollingError counter
					self._eventPollingErrors = 0;
					
					if (response.eventList){
						var events = response.eventList;
						for (var i=0; i<events.length; i++){
							for (var j=0; j< self._eventHandlers.length; j++){
								self._eventHandlers[j](events[i]);
							}			
						}	
					}	
					if (self._eventPolling == true){
						self.getEvent(false);
					} 
				} else if (response.returnCode == 201){
					//Each successful request should reset the eventPollingError counter
					self._eventPollingErrors = 0;
					
					//201 means no data is available so we'll wait 3 seconds before making the next getEvent request
					//This is especially useful on ZOS since the rest service returns immediately if no data is available
					if (self._eventPolling == true){
						thisObj = self;
						setTimeout(function() { thisObj.getEvent(false); }, 3000);
					}
				} else {
					//If the response is anything but 200 or 201 we will handle it in the error function
					this.error(response, ioArgs);
				}
				return response;
			},
			error: function(response, ioArgs){
				console.log("getEvent.error: " + ioArgs.xhr.responseText);
				if (response.returnCode == 304){
					//If the return code is 304 the request has been replaced and event polling should be stopped.
					//This scenario occurs when the page containing the widget is refreshed or a new tab is used in the browser	
					for (var i=0; i< self._eventHandlers.length; i++){
						self._eventHandlers[i]({"type": 0, "data":"EVENT_POLLING_REPLACED"});
					}
				} else {
					self._eventPollingErrors ++;
                    if ( self._eventPollingErrors >= parseInt(self.maxEventPollingErrors)){
						for (var i=0; i< self._eventHandlers.length; i++){
							self._eventHandlers[i]({"type": 0, "data":"EVENT_POLLING_FAILED"});
						}
					} else if (self._eventPolling == true){
						self.getEvent(false);
					} 
				}
				return response;
			}
		});
	},
	
	sendDataEvent: function(data) {
		// summary: Make a call to the rest service to send data to the peer
		console.log("sendDataEvent: " + data);
		var self = this;
		
		//ceadojo.version will return in the format 1.0.01 and must convert this to the version that the rest service expects 1.0.0.1
		ceaVersion = dojo.version.major + "." + dojo.version.minor + "." + dojo.version.patch + "." + dojo.version.flag;
		
		// If the collaborationSession didn't established correctly, simply return.
		if (!self._eventUri || (self._eventUri == "")) {
			console.log("getEvent canceled, eventUri: " + self._eventUri);
			return null;
		}
		
	 	dojo.rawXhrPost({
			url: this.ceaContextRoot + "/" + this._eventUri + "?JSON=true&ceaVersion=" + ceaVersion,
			handleAs: "json-comment-optional",
			headers: {"Content-Type": "text/html"}, 
			postData: data,
			sync: true,
         	
			load: function(response, ioArgs) {
				console.log("sendDataEvent.load: " + ioArgs.xhr.responseText);
				return response;
			},
			error: function(response, ioArgs) {
				console.log("sendDataEvent.error: " + ioArgs.xhr.responseText);
				return response;
			}
		});
	},
	
	addEventHandler: function(handler){
		// summary: Add an event handler to the list that will be triggered when a CEA event occurs
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("addEventHandler");
		this._eventHandlers.push(handler);
		//if this is the first event handler start polling for CEA events
		if (this._eventHandlers.length == 1){
			this._startEventPolling();
		}
	},
	
	removeEventHandler: function(handler){
		// summary: Remove an event handler from the list that will be triggered when a CEA event occurs
		// handler: A handle to the function that needs to be called to style the widget based on the rest service response
		console.log("removeEventHandler");
		for (var i=0; i<this._eventHandlers.length; i++){
			if ( handler == this._eventHandlers[i]){
				this._eventHandlers.splice(i, 1);
			}
		}
		//if this is the last event handler stop polling for CEA events
		if (this._eventHandlers.length == 0){
			this._stopEventPolling();
		}
	},
		
	_startEventPolling: function() {
		// summary: Start polling the rest service for CEA events, invoked when the first handler is added to the list
		console.log("startEventPolling");
		this._eventPolling = true;
		this.getEvent(true);
	
	},

	_stopEventPolling: function(){
		// summary: Stop polling the rest service for CEA events, invoked when the last handler is removed to the list
		console.log("stopEventPolling");
		this._eventPolling = false;
	}

});

}
