dojo.provide("ibm.rpc.BatchService");

dojo.declare("ibm.rpc.BatchService", null, {    
	constructor: function(url){
	//summary:
	//	Takes a string as a url to indicate that batching will be used in the application 
	//
	//	url: object
	//		It also accepts a string.It creates a handle to be used for batch calls.
	//		strictArgChecks forces the system to verify that the # of arguments provided in a call
	//		matches those defined in the smd. 
		this._reqArray = [];			
		this._callbackHandlers = [];					
		this._jsonServices = [];
		this._url=url;
		this._batchId=0;
		this._serviceId=0;
	},
	_bustCache: false,
	_contentType: "application/json-rpc",
	_lastSubmissionId: 0,
	_batchId: 0,
	_serviceId: 0,
	_batchService: null,
	_reqArray: [],		
	_callbackHandlers: [],
	_jsonServices: [],
	_serviceNames: [],
	_url: "",
	_initialized: false,
	_strictArgChecks: true,
	error: null, 
	clear: function(){
	//summary:
	//		clears the previous state of batch service
		this._bustCache = false;
		this._contentType = "application/json-rpc";
		this._lastSubmissionId = 0;
		this._batchId = 0;		    
		this._serviceId = 0;
		this._batchService = null;
		this._reqArray = [];		
		this._callbackHandlers = [];
		this._jsonServices = [];
		this._serviceNames = [];		    
		this._initialized = false;

	},
	createService: function(/*String*/ args){	
    //	summary:
	//		the method creates a reference to a single service in the batch 
	//		if one already exists,the same is returned else a new one is created,
	//		added to the array of service names and returned.
	//		args:    the url used to access the service individually
		var obj = new ibm.rpc.BatchService("");			
		var i; 
		var currentServiceName = "\""+args.substring(args.lastIndexOf("/")+1)+"\"";
		for(i in this._serviceNames){
			if(currentServiceName == this._serviceNames[i]){
				return this._jsonServices[i];
			}
		}
		this._jsonServices[this._serviceId] = obj;
		obj._batchService = this;
		obj.serviceUrl=args;
		this._serviceNames[this._serviceId] = currentServiceName;
		this._serviceId++;
		return obj;			
	},
	
	initialize: function(){
	//	summary:
	//		used in retrieving the smd for all the services that were called using 
	//		createService method.It is only after this call is made that
	//		the 'stubs' created in the createService are populated with actual data
		var def = dojo.rawXhrPost({
			url: this._url,
			postData: "["+this._serviceNames+"]",
			contentType: this._contentType,
			timeout: this._timeout, 
			handleAs: "json",
			sync: true
		});			            			
		def.addCallback(this.processSmds(this));
		def.addErrback(function() {
			throw new Error("Unable to load SMDs for ", this.serviceNames);					
		});
	},
	
	isInitialized: function(){
	// summary:
	//		returns the state of the object
	//		allows to check if the smd for the corresponding
	//		service has been sucessfully retrieved
		return this._initialized;
	},
				
	bind: function(/*string*/ method,/*array*/ parameters,/*dojo.Deferred*/ deferredRequestHandler,/*String*/ url){
    //summary:
	//		called to associate a given service name with its corresponding callback handlers and methods
    //	method :	call to be executed 
    // 	parameters: 	arguments to be passed to the method
	//	deferredRequestHandler:		functions that handle the response after method execution
	//	url :	the url through which the actual service is referenced 
		var service = dojo.toJson(this.serviceUrl.substring(this.serviceUrl.lastIndexOf("/")+1));	
		this._batchService.createBatchRequest(method, parameters, service);							   
		this._batchService._callbackHandlers[(this._batchService._batchId-2)/2] = deferredRequestHandler;            
	},

	submit: function(){		
	//  summary:
	//   		submits the  batched method calls  for execution 	
		var def = dojo.rawXhrPost({
			url: this._url,
			postData: "["+this._reqArray+"]",
			contentType: this._contentType,
			timeout: this._timeout, 
			handleAs: "json"
		});			
												
		def.addCallbacks(this.resultCallback(this._callbackHandlers), this.errorCallback(this._callbackHandlers));
		this._reqArray = [];
		this._batchId = 0;
		this._lastSubmissionId=0;
		this._callbackHandlers = [];			
	},		
							
	createBatchRequest: function(/* string */ method, /* array */ params, /*string */ service){
		//	summary:
		//		create a JSON-RPC envelope for the requests			
		var req = { "params": params, "method": method, "id": ++this._lastSubmissionId };
		var data = dojo.toJson(req);			
		this._reqArray[this._batchId]=data;
		this._batchId++;
		this._reqArray[this._batchId]=service;
		this._batchId++;			
		return;
	},

	parseResults: function(obj){
		//	summary:
		//		parses the result envelope and passes the results back to the callback function
		if(obj==null){ return; }
		if(obj["Result"]!=null){ 
			return obj["Result"]; 
		}else if(obj["result"]!=null){ 
			return obj["result"]; 
		}else if(obj["ResultSet"]){
			return obj["ResultSet"];
		}else{
			return obj;
		}
	},
	
	processSmds: function(/*object*/ obj){		
        // summary:
		// 		callback method for receipt of the smd object.Parses the smd
		// 		and generates functions based on the description by calling 
		//      processSmd for each service in the batched call only if it 
		//		has been successfully initialized
		//	obj: smd object defining entire batch of called services.    
		return function(smdArr){		    
			var x;
			for(x in smdArr){		
				if(typeof smdArr[x].SMDVersion != 'undefined'){                 
					obj.processSmd(obj._jsonServices[x], smdArr[x]);		
				}else{			   
					obj._jsonServices[x].initialized = false;
					obj._jsonServices[x].error = smdArr[x];
				}
			}			
		};
	},
	
	generateMethod: function(/*object*/  object, /*string*/ method, /*array*/ parameters, /*string*/ url){
		//	summary:
		//		generates the local bind methods for the remote object
		return dojo.hitch(object, function(){
			var deferredRequestHandler = new dojo.Deferred();
			// if params weren't specified, then we can assume it's varargs
			if( (object._strictArgChecks) &&
				(parameters !== null) &&
				(arguments.length !== parameters.length)
			){
				// put error stuff here, not enough params
				throw new Error("Invalid number of parameters for remote method.");
			}else{
				object.bind(method, dojo._toArray(arguments), deferredRequestHandler, url);
			}
			return deferredRequestHandler;  //dojo.Deferred 
		});
	},

	processSmd: function(/*object*/obj, /*json*/ object){
		// 	summary:
		//		callback method for receipt of a smd object.Parses the smd
		//		and generates method bindings based on the description
		//		obj:	object that references the Batch Service
		//		object:	smd object defining the services in the batch
		if(object.methods){
			dojo.forEach(object.methods, function(m){
				if(m && m["name"]){
					obj[m.name] = obj.generateMethod(obj, m.name,
									m.parameters, 
									m["url"]||m["serviceUrl"]||m["serviceURL"]);
					if(!dojo.isFunction(obj[m.name])){ 
						throw new Error("RpcService: Failed to create" + m.name + "()");
						/*console.debug("RpcService: Failed to create", m.name, "()");*/
					}
				}
			}, obj);
		}			
		obj.serviceUrl = object.serviceUrl||object.serviceURL;
		obj.required = object.required;
		obj.smd = object;
		obj._initialized = true;
	}, 

	errorCallback: function(/* dojo.Deferred */ deferredRequestHandlers){
	// 	summary:
	//		create callback that calls each of the Deferred error callback methods in the batch
		return function(data){
			var i; 
			for(i in deferredRequestHandlers){                   
				var deferredRequestHandler = deferredRequestHandlers[i];	
				deferredRequestHandler.errback(new Error(data[i].message));
			}
		};
	},		
	
	resultCallback: function(/* dojo.Deferred */ deferredRequestHandlers){
	//	summary:
	//		create callback that calls each of the Deferred callback methods in the batch if the 
	//		corresponding error is seen.
		var tf = dojo.hitch(this, function(obj){
			var i; 
			for(i in deferredRequestHandlers){                   
				var deferredRequestHandler = deferredRequestHandlers[i];					
				if(obj[i]["error"]!==null){
					var err;
					if(typeof obj[i].error === 'object'){
						err = new Error(obj[i].error.message);
						err.code = obj[i].error.code;
						err.error = obj[i].error.error;
					}else{
						err = new Error(obj[i].error);
					}
					err.id = obj[i].id;
					err.errorObject = obj[i];
					deferredRequestHandler.errback(err);
				}else{
					deferredRequestHandler.callback(this.parseResults(obj[i])); 							
				}
			}
		});            				
		return tf;
	}		
});
