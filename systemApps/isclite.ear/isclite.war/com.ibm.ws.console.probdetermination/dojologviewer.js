	/*******************************************************************************
	 * IBM Confidential OCO Source Material  
	 * 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2009 , 2012
	 * The source code for this program is not published or otherwise divested 
	 * of its trade secrets, irrespective of what has been deposited with the  U.S. Copyright Office. 
	 * * All Rights Reserved * Licensed Materials - Property of IBM * US Government Users Restricted Rights - Use,
	 * duplication or disclosure * restricted by GSA ADP Schedule Contract with IBM Corp. 
	 * @(#) 1.71 WEBUI/ws/code/webui.problemdetermination/src/probdetermination/com.ibm.ws.console.probdetermination/dojologviewer.js, WAS.webui.ras, WAS855.WEBUI, cf131750.06 10/18/12 16:47:17 [12/17/17 20:08:06]
	 ******************************************************************************/
	
	//dojo.require("dojox.data.QueryReadStore");
	dojo.require("dojo.data.ItemFileReadStore");
	dojo.require("dojox.grid.DataGrid");
	dojo.require("dojo.parser");
	dojo.require("dijit.dijit");
	dojo.require("dijit.form.Form");
	dojo.require("dijit.form.TextBox");
	dojo.require("dijit.form.TimeTextBox");
	dojo.require("dijit.form.Textarea");
	dojo.require("dijit.form.CheckBox");
	dojo.require("dijit.form.Button");
	dojo.require("dijit.form.DateTextBox");
	dojo.require("dijit.form.NumberTextBox");
	dojo.require("dijit.form.FilteringSelect");
	dojo.require("dijit.Dialog");
	dojo.require("dijit.TooltipDialog");
	dojo.require("dojox.validate");
	dojo.require("dojo.io.iframe");
	dojo.require("dijit.Menu");
	dojo.require("dijit.Tree");
	dojo.require("dojo.date.locale");
	dojo.require("dijit.form.SimpleTextarea");	
	dojo.require('dojox.uuid.generateRandomUuid');
	dojo.require('dijit.layout.ContentPane');
	dojo.require('dojox.widget.PlaceholderMenuItem');

	/*
	 * override xhrpost and get so we can add customer header
	 */
	var origXhrPost = dojo.xhrPost;
	var origXhrGet = dojo.xhrGet;
	dojo.xhrPost = function(args) {
		checkAndAddHeaders(args);
	    // return original
		return origXhrPost(args);
	};
	dojo.xhrGet = function(args) {
		checkAndAddHeaders(args);
	    // return original
		return origXhrGet(args);
	};

	/*
	 * check weather xhrArgs has header, if not add one
	 */
	function checkAndAddHeaders(args){
		// check if we have headers object
		if (args.headers) {
			// we do, check if we have csrfid
			if (args.headers.csrfid) {
				// we do just print and continue
				console.debug('Found a csrfid ' + args.headers.csrfid);
			} else {
				// we do not, add csrfid to existing header
				args.headers.csrfid = getCookie('com.ibm.ws.console.CSRFToken');
			}
		} else {
			// add headers
			args.headers= {
		        	csrfid: getCookie('com.ibm.ws.console.CSRFToken')
	     	};
			
		}
	}

	//F04026-42139
	//gets the asked cookie value. Returns "" if not found.
	function getCookie(cookieName) {
		if(null === cookieName || "" === cookieName) { return ""; }
		var allCookies = window.document.cookie;
		var index = allCookies.lastIndexOf(cookieName + '=');
		if (index == -1) { return ""; }
		var startingIndex = index + cookieName.length + 1;
		var endingIndex = allCookies.indexOf(';', startingIndex);
		if (endingIndex == -1) { endingIndex = allCookies.length; }
		var cookieValue = allCookies.substring(startingIndex, endingIndex);
		//alert('getCookie exit ' + cookieValue);
		return cookieValue; 
	}
	
	/*
	 * Override dojox.grid.DataGrid so we can turn off sorting
	 */
	dojo.declare("probdeter.DataGrid", dojox.grid.DataGrid, {
		canSort:function(){
		return false;
	} //,
	//refresh:function() {
	//	var oldStore = this.store;
	//	console.debug(oldStore);
	//	console.debug(oldStore.url);
	//	var newstore = new probdeter.ItemFileReadStore({url:oldStore.url});
	//	setStore(storeheader);
	//}
	
	});
	/*
	 * Override filtering select
	 * This is so we can not give error on a number value in level select
	 */
	dojo.declare("probdeter.FilteringSelect", dijit.form.FilteringSelect, {
	    isValid:function(){
	    	//console.debug("in isValid");
	    	var x = this.get('displayedValue');
	    	//console.log(x);
	    	if (x === "" || x.toString().search(/^[0-9]+$/) === 0) {
	    	    return true;
	    	}
	    	return this.inherited(arguments);
	    }
	});
	
	/*
	 * Override _getItemsFromLoadedData() to do error check common to all models using this store.
	 */
	dojo.declare("probdeter.ItemFileReadStore", dojo.data.ItemFileReadStore, {
        _getItemsFromLoadedData: function(data){
        appInstallWaitHideProbDeter();
	        if (data.errors) {
	        	/*
	        	 * clear all previous errors
	        	 */
	            var dlg = dijit.byId('errorDialog');

	            var show = dlg.processError(data);

	            if (show) {
	                dlg.show();
	            }
	
	        }
	        // If this is a record grid handle page buttons enable state
	        if (this.url === '/ibm/console/logViewerServlet') {
	            var firstButton = dojo.byId("com.ibm.ws.console.probdetermination.firstPage");
	            dojo.attr(firstButton, "disabled", !(data.hasPrev==="true"));
	            var prevButton = dojo.byId("com.ibm.ws.console.probdetermination.prevPage");
	            dojo.attr(prevButton,  "disabled", !(data.hasPrev==="true"));
	            var nextButton = dojo.byId("com.ibm.ws.console.probdetermination.nextPage");
	            dojo.attr(nextButton, "disabled", !(data.hasNext==="true"));
	            var lastButton = dojo.byId("com.ibm.ws.console.probdetermination.lastPage");
	            dojo.attr(lastButton, "disabled", !(data.hasNext==="true"));
	        }
         
            // Allow normal processing of the arguments.
		    this.inherited(arguments);
		}
	});
	
	
	/*
	 * Override the dialog box so we can disable the close button
	 */
	dojo.declare("probdeter.ErrorDialog", dijit.Dialog, {
		processError:function(data){
		    var show = true;
	        if (data.errors) {
	        	
	            
	            dojo.forEach(data.errors, function(e){
	            	if (e.error) {
	            		console.error(e.error);
	            		if ('invalid_session' === e.error) {
	            			show = false;
	                        dijit.byId("invalidSession").show();
	            		} else {
	                        this.addError(e.error, null);
	                        
	            		}
	            	} else if (e.warning) {
	            		this.addWarning(e.warning, null);
	                    
	            	}
	            }, this); // process this in current context
	
	        }
	        
	        return show;
	    },
		_displayErr: function(titleText, detailText, img) {
	        var ec = dojo.byId("errorContainer");
	        
	        var spanNode= dojo.doc.createElement("span");
	        dojo.attr(spanNode, "class", "validation-warn-info");
	        
	        
	        var imageNode = dojo.doc.createElement("img");
	        dojo.attr(imageNode, {width:'16', height:'16', align:'baseline', src:img.src, alt:errorString, title:errorString});
	        
	        var newText = dojo.doc.createTextNode(titleText);
	        spanNode.appendChild(imageNode);
	        if(detailText) {
		        var textArea= dojo.doc.createElement("textarea");
		        dojo.attr(textArea, {dojoType:'dijit.form.SimpleTextarea', readonly:'readonly', rows:'5', style:'width:500px;font-size:100%;', value:detailText});
		        var newDiv= dojo.doc.createElement("div");
		        dojo.attr(newDiv, {id:dojox.uuid.generateRandomUuid(), style:'display:none'});
		        
		        var detailTextNode = dojo.doc.createTextNode(detailText);
		        textArea.appendChild(detailTextNode);
		        
	        	
	        	var newLink = dojo.doc.createElement("a");
		        dojo.attr(newLink, {title:titleText, href:'javascript:expandCollapseDetailError("'+newDiv.id+'");'});
	        	spanNode.appendChild(newLink);
	        	newLink.appendChild(newText);
	        	newDiv.appendChild(textArea);
	        	spanNode.appendChild(newDiv);
	        } else {
	        	spanNode.appendChild(newText);
	        }
	        ec.appendChild(spanNode);
	        
	        ec.appendChild(dojo.doc.createElement("br"));
		},
	    addWarning: function(titleText, detailText){
	    	this._displayErr(titleText, detailText, warningImage);	
    	    var xhrArgs = {
    		        url: "/ibm/console/traceLogServlet",
    		        content: {
    	        		message: titleText + " " + detailText,
    	                level: "warning"
         	        },
    	            handleAs: "text",
    	            sync:true,
    		        
    		        load: function(data){
    		        },
    		        error: function(error){
    		        }
    		    };
    		    
    		    // send it to the server
    		    var deferred = dojo.xhrPost(xhrArgs);
	    },
	    addError: function(titleText, detailText){
	    	this._displayErr(titleText, detailText, errorImage);
    	    var xhrArgs = {
    		        url: "/ibm/console/traceLogServlet",
    		        content: {
    	    	        message: titleText + " " + detailText,
    	                level: "severe"
         	        },
    	            handleAs: "text",
    	            sync:true,
    		        
    		        load: function(data){
    		        },
    		        error: function(error){
    		        }
    		    };
    		    
    		    // send it to the server
    		    var deferred = dojo.xhrPost(xhrArgs);
	    },
	    clearAll: function(){
	    	dojo.query('#errorContainer > *').orphan();
	    	dojo.query('#errorContainer > *').forEach(dojo.empty);
	    	idCount = 0;
	    }
	});
	
	/*
	 * Override the dialog box so we can disable the close button
	 */
	dojo.declare("probdeter.WaitDialog", dijit.Dialog, {
	    postCreate: function(){
	        this.inherited(arguments);
	        this.closeButtonNode.style.display = "none";
	    }
	});
	
	
	/*
	 * the row number that we are formatting
	 */
	var currentRow = -1;
	/*
	 * whwather or not we are are filtering by date
	 */
	var dateFilterSet = false;
	
	/*
	 * this adds a bar on left side of grid, that can be used for selecting row
	 */
//	var rowBar = {
//	    type: 'dojox.GridRowView',
//	    width: '20px'
//	};
	
	/*
	 * Regular expression for message id
	 */
    var messageId = /([A-Z][A-Z0-9]{3,4}[0-9]{4}[A-Z])/;
//    var ffdcFileId = /(on .*\.txt)/;
    var ffdcFileId = /\/.+\.txt/;
    var ffdcFileIdWin = /([a-zA-Z]:|\\{2}\w+)(\\+[^\\\/:*?<>\"|\u0001-\u001F]+)+.txt/;
    //var ffdcFileId = /.*on (.*\.txt)/;
	
	// this is for progress dialog
	var dlg;
	
	
	
	// this is rest of the columns in the grid
	var middleView = [{
	    // onBeforeRow: handleInsertion,
	    
	   
	        name: nlsArray.hpel_logview_timestamp,
	        field: 'datetime',
	        formatter: formatTime,
	        width:'115px',
	        hidden: false,
	        styles: 'font-size:9px;'
	    }, {
	        name: nlsArray.hpel_logview_threadid,
	        field: 'threadid',
	        formatter: formatThreadId,
	        width:'55px',
	        hidden: false,
	        styles: 'font-size:9px;'
	    }, {
	        name: nlsArray.hpel_logview_logger,
	        field: 'logger',
	        width:'55px',
	        hidden: false,
	        styles: 'font-size:9px;direction:rtl;'
	    }, {
	        name: nlsArray.hpel_logview_event,
	        field: 'event',
	        width:'27px',
	        hidden: false,
	        styles: 'font-size:9px;'
	    }, {
	        name: nlsArray.hpel_logview_message,
	        field: 'message',
	        get: getMessage,
	        formatter: formatMessage,
	        width:'80em',
	        hidden: false,
	        styles: 'font-size:9px;'
	    }];
	
	
   	var headerLayout = [{
   		    name: hpn,
    	    field: 'key',
    	    width: '20%',
    	    formatter: formatHeaderNames,
        	styles: 'font-size:9px;'
    	}, {
   			name: hpv,
   			field: 'value',
   			width: '80%',
   			formatter: formatHeaderValues,
   			styles: 'font-size:9px;'
   	}];
	// this is the full layout of the grid
	var layout = middleView;
	
	var fileDownloadDefered;
	
	//var minTimeForData;
		
	/*
	 * this is the new pop up menu
	 */
	var newSubMenu;
	
	/*
	 * cache some images to use if server is offline
	 */
	var errorImage;
	var warningImage;
	
	var tzoffset  = (new Date().getTimezoneOffset()) * 60000;
	
	var currentInstanceSelection = null;
	
	/*
	 * add starts with function to the string
	 */
	String.prototype.startsWith = function(str){
		return (this.match("^"+str)==str);
	};	
	

	/*
	 * 
	 */
	function formatHeaderNames(name) {
	    if (name == "?" || name == "..." || name === "") {
	        return name;
	    }
	    
	    var retval = "<strong>";
	    
	    return retval.concat(name,"</strong>");
		
	}
	
	/*
	 * format values in the header table to put each entry in new line
	 */
	function formatHeaderValues(value) {
	    if (value == "?" || value == "..." || value === "") {
	        return value;
	    }
	    	    
	    var retVal =  value;
	    
	    var x = '<table  border="0" cellspacing="0" cellpadding="0" role="presentation" class="dojoxGridRowTable"> <tr class="dojoxGridRow">';
	    var evenRow = false;
	    
	    var z = value.split(';');
	    var y = value.split(':');
	    if (z.length === 1 && y.length > 2 && y[0].length > 1) {
	    	z  = y;
	    }
	    
	    for (var i in z) {
	    	x = x.concat('<td style="font-size: 9px; width: 400px;" idx="0" class="dojoxGridCell" role="gridcell" tabindex="-1">',z[i]);
	    	if (evenRow) {
	    	    x = x.concat('</td></tr><tr class="dojoxGridRow">');
	    	} else {
	    	    x = x.concat('</td></tr><tr class="dojoxGridRow dojoxGridRowOdd">');
	    		
	    	}
	    	evenRow = !evenRow;
	    }
	    
	    x = x.concat("</tr></table>");
	    
//	    console.debug(x);
	    
	    retVal = x;
	    
	    return retVal;
		
	}

	/*
	 * we get a long string from server. format that into time.
	 */
	function formatTime(timeinmil){
	
	    /*
	     * if we get "?" or "..." do not process anything else we get "?" at the
	     * begining of the grid we get "..." when grid is loading more rows
	     */
	    if (isNaN(timeinmil) || timeinmil == "?" || timeinmil == "..." || timeinmil === "" || timeinmil === "*") {
	        return timeinmil;
	    }
	    
	    // node where we will replace time
	    var oDiv;
	    
	    // increment current row
	    currentRow++;
	    
	    // get time object from input
//	    var dateTime = new Date(timeinmil);
//	    console.debug(dateTime);
	    // get UTC time in msec
	    var utc = timeinmil + tzoffset;
	    
	    // create new Date object for different city
	    // using supplied offset
	    var dateTime = new Date(utc + offset);
	    
//	    console.debug(dateTime);
	    
	    // change it into time
	    //var time = dateTime.toLocaleString();
	    var time = dojo.date.locale.format(dateTime, {
	        formatLength: "short",
	        timePattern : "HH:mm:ss.SSS"
	    });
	    	    
	    return time;
	}
	
	/*
	 * we get integer threadid from server change this into 8 char hex string
	 */
	function formatThreadId(threadid){
	    /*
	     * if we get "?" or "..." do not process anything else we get "?" at the
	     * begining of the grid we get "..." when grid is loading more rows
	     */
	    if (isNaN(threadid) || threadid == "?" || threadid == "..." || threadid === "" || threadid === "*") {
	        return threadid;
	    }
	    
	    // the formatted string to return, default is what came in
	    var retString = "";
	    
	    // change it into a integer base 10
	    var x = parseInt(threadid, 10);
	    // change it into hex and then uppercase
	    var hex = x.toString(16).toUpperCase();
	    // calcualte its length so we can add padding
	    var length = hex.length;
	    
	    // add padding
	    for (i = length; i < 8; ++i) {
	        retString = retString.concat("0");
	    }
	    
	    // add rest of the string
	    retString = retString.concat(hex);
	    
	    return retString;
	    
	}
	
	/*
	 * 
	 */
//	function formatMessage(msg){
	function getMessage(rowIndex, recordItem) {
		var xgrid = dijit.byId('grid');
		var val = xgrid.getItem(rowIndex);
		if (val === null || val === '?' || val === '...') {
		    return val;
		}
		var message = xgrid.store.getValue(recordItem, 'message');
		var datetime = xgrid.store.getValue(recordItem, 'datetime');

		return message+"-:-:-:-"+datetime;
		
	}
    function formatMessage(message){
	    /*
	     * if we get "?" or "..." do not process anything else we get "?" at the
	     * begining of the grid we get "..." when grid is loading more rows
	     */
		if (message === null || message === '?' || message === '...') {
		    return message;
		}

		
		var marray =message.split("-:-:-:-"); 
		var str = marray[0];
		var rowDateTime = marray[1];

	    var returnString = str;



        var myArray = ffdcFileId.exec(str);
	    if (null !== myArray) {
	        var rest = myArray[0];
	        // create html for link
	        var _x = "showFFDCFileDialog(\'" + rest + "\');";
	        var x = "<a href=\"javascript:"+_x+ "\" >"+rest+"</a>";
	        returnString = str.replace(ffdcFileId, x);
//	        console.debug(returnString);
	    }
        var myArray3 = ffdcFileIdWin.exec(str);
	    if (null !== myArray3) {
	        rest = myArray3[0];
	        // create html for link
	        _x = "showFFDCFileDialog(\'" + rest.replace(/\\/g,"/") + "\');";
	        x = "<a href=\"javascript:"+_x+ "\" >"+rest+"</a>";
	        returnString = str.replace(ffdcFileIdWin, x);
//	        console.debug(returnString);
	    }

        str = returnString;
	    // apply the regular expression
	    var myArray2 = messageId.exec(str);
	    
	    
	    // create a link
	    // default return value is what came in
	    // if there are no mach then return

	    if (myArray2 !== null) {
	        var link1 = myArray2[1];
	        var link2 = str.substring(link1.length);
	        // create html for link
            var mzz = marray[0].replace(/\\/g,"\\\\");
            mzz = mzz.replace(/\"/g, '\\x22');
            mzz = mzz.replace(/\'/g, '\\x27');
            //console.debug(mzz);
            _x = "showRuntimeMessageDialog(\'" + link1 + "\',\'" + mzz + "\');";
	        x = "<a href=\"javascript:"+_x+ "\" >"+link1+"</a>";
	        returnString = str.replace(messageId, x);
	    } 
	    
	    return returnString;
	}
	
	/*
	 * the if for filtering secion Viewcontent sub section when enable log is
	 * checked then enable selection of filtering for trace levels
	 */
	function enableDisableLevels(checkEvent){
	    var enableDisableLevelSelect = !checkEvent;
        var minNode = dijit.byId("minlevel");
        var maxNode = dijit.byId("maxlevel");
        
        minNode.setDisabled(enableDisableLevelSelect);
        maxNode.setDisabled(enableDisableLevelSelect);
	}
	
	
	function selectNewInstance(path) {
		if (currentInstanceSelection == path) {
			return;
		}        
		
		currentInstanceSelection = path;

		/*
		 * reset so we calculate new time
		 */
	    currentRow = -1;

		
		
		var xhrArgs = {
			url: "/ibm/console/logViewerInstanceServlet",
			content: {
				starttime: path
			},
			handleAs: "json",
			load: function(data){
				// handle the invalid session scenarion
				if (data.error === "invalid_session") {
					// send it somewhere else
					dijit.byId("invalidSession").show();
					return; 
				}
				// find the grid and refresh it
//				grid3 = dijit.byId("headerGrid");
//				var storeheader = new probdeter.QueryReadStore({url:'/ibm/console/logHeaderServlet', requestMethod: 'post'});
//				grid3.model.refresh();
//				grid3.setStore(storeheader);

				
				grid2 = dijit.byId("grid");
				grid2.selection.deselectAll();
				var store = new probdeter.ItemFileReadStore({url:'/ibm/console/logViewerServlet', urlPreventCache:true});
//				grid2.model.refresh();
				grid2.setStore(store);
				tree = dijit.byId("probdetermination.instanceChoice");

			},
			error: function(error){
				var dlg = dijit.byId('errorDialog');
				dlg.clearAll();
				dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
				dlg.show();
				console.error("Error during filter", dojo.toJson(error, true));
				appInstallWaitHideProbDeter();
			}
		};
			
		dojo.xhrPost(xhrArgs);
		appInstallWaitShowProbDeter();
	}
	
	function pageAction(action, size) {
		var xhrArgs = {
			url: "/ibm/console/logViewerInstanceServlet",
			content: {
				pageaction: action,
				pagesize: size
			},
			handleAs: "json",
			load: function(data){
				// handle the invalid session scenarion
				if (data.error === "invalid_session") {
					// send it somewhere else
					dijit.byId("invalidSession").show();
					return; 
				}
				
				grid2 = dijit.byId("grid");
				grid2.selection.deselectAll();
				var store = new probdeter.ItemFileReadStore({url:'/ibm/console/logViewerServlet', urlPreventCache:true});
				grid2.setStore(store);
				tree = dijit.byId("probdetermination.instanceChoice");

			},
			error: function(error){
				var dlg = dijit.byId('errorDialog');
				dlg.clearAll();
				dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
				dlg.show();
				console.error("Error during filter", dojo.toJson(error, true));
				appInstallWaitHideProbDeter();
			}
		};
			
		dojo.xhrPost(xhrArgs);
		appInstallWaitShowProbDeter();
	}
	
	// Declare DndController which allows selection of instances only
	dojo.declare("dijit.InstanceDnd", dijit.tree._dndSelector, {
		userSelect: function(node, copy, shift) {
			if (node && node.item) {
				if (node.item.type[0] !== "time") {
					return;
				}
			}
		    this.inherited(arguments);
		}
	});
	
	/*
	 * create and add a tree for server startup
	 */
	function createServerStartupTree(){
		tree = dijit.byId("probdetermination.instanceChoice");
        /*
        		<div dojoType="dojo.data.ItemFileReadStore" jsId="instanceStore" url="/ibm/console/instanceListServlet"></div>
        		<div dojoType="dijit.tree.ForestStoreModel" jsId="instanceModel" store="instanceStore"
        		    rootId="instanceRoot" rootLabel="<%= instanceRoot %>" childrenAttrs="children">
        		</div>
        */
        
		// Rebuild store

		if (tree) {
			//tree.destroyDescendants(false);
        	//tree.destroyRecursive(false);

			tree.destroy();
		}
	
	    treeStore = new dojo.data.ItemFileReadStore({
	    	url: "/ibm/console/instanceListServlet", urlPreventCache:true
	    	});
	    //console.debug(treeStore);
	    
	    treeModel = new dijit.tree.ForestStoreModel({
	            store: treeStore,
	            rootId: "instanceRoot",
	            query: {type:'date'},
	            rootLabel: instanceRootString,
	            childrenAttrs: ["children"]
	        });
	    //console.debug(treeModel);
	    var dirVar = dojo.trim(getBidiTextDir().toLowerCase());
	    dirVar = dirVar===''?'ltr':'rtl';
	    var instanceTree = new dijit.Tree({
			model:      treeModel,
			id:			"probdetermination.instanceChoice",
			dndController: "dijit.InstanceDnd",
			dir: dirVar,
            showRoot: false,
			autoExpand: true
		}, document.createElement('div'));
	    
    	dojo.connect(instanceTree, "onClick", onTreeClick);
	    
	    dojo.connect(instanceTree, "onLoad", onTreeLoad);
	    
	    dojo.byId("treeNode").appendChild(instanceTree.domNode); 


	    instanceTree.startup();
	    
	    return treeStore;

	}
	
	function updateODiv(x) {
        oDiv = document.getElementById("viewServerInstance");
		if (isZOS) {
			oDiv.innerHTML = '&nbsp;'+x.getParent().getParent().label+'&nbsp;' + x.getParent().label+'&nbsp;'+x.labelNode.innerHTML+'&nbsp;';
		} else {
			oDiv.innerHTML = '&nbsp;'+x.getParent().label+'&nbsp;'+x.labelNode.innerHTML+'&nbsp;';
		}
	}
	
	function onTreeLoad(){
    	if (!currentInstanceSelection) {
    		return;
    	}
    	/*
    	 * iterate over al dijitTreeNode to find which one to select
    	 */
		var query=dojo.query('.dijitTreeNode');
		dojo.forEach(query, function(e){
			var x = dijit.byId(e.id);
			if (x.item && x.item.starttime) {
				if ( x.item.starttime[0] === currentInstanceSelection) {
					x.tree.set("path", x.getTreePath());
					updateODiv(x);
//			        x.getParent().expand();
			        return;
					
//				} else {
//				    if (!selectedTreeNode || x.getParent() !== selectedTreeNode.getParent()) {
//				    	x.getParent().collapse();						
//				    }
				}
			}
		}, this);
		
	}
	
	/*
	 * this will be called when refresh button is clicked on the button bar
	 */
	function refreshView(){
		/*
		 * we will rebuild the tree
		 */
		
		//TODO need to check this method
		
		// Update pagesize
		var pagesize = dojo.byId("com.ibm.ws.console.probdetermination.pageSize");
		var xhrArgs = {
			url: "/ibm/console/logViewerInstanceServlet",
			content: {
				pageaction: "same",
				pagesize: pagesize.value
			},
			handleAs: "json"
		};
		dojo.xhrPost(xhrArgs);

		createServerStartupTree();
	
		treeStore.fetch({
			onComplete: function(data,response) {
			
				// Check if selection can stay the same.
			    var toCheck = currentInstanceSelection;
			    
			    var instanceTree = dijit.byId("probdetermination.instanceChoice");
			    
			    // check wheather parent is avail
			    var selectionAvail = dojo.some(data, function(item) { 
			        var siStore = instanceTree.model.store;
			        if (item && siStore.isItem(item)) {
			            return siStore.getValue(item, "starttime") === toCheck;
			        } 
			        
			        return false; 
			    });
			    
			    /*
				 * if selection available just update the grid
				 */
				if ( currentInstanceSelection !== null && data.length === 0 ||  selectionAvail) {
					/*
					 * reload the grid
					 */
					//appInstallWaitShowProbDeter();
					grid3 = dijit.byId("grid");
					grid3.selection.deselectAll();
					var store = new probdeter.ItemFileReadStore({url:'/ibm/console/logViewerServlet', urlPreventCache:true});
					grid3.setStore(store);
				} else {
					/*
					 * give a warning
					 */
					console.log(nlsArray.hpel_logviewer_instanceselected_notavail);
			        var dlg = dijit.byId('errorDialog');
			        dlg.clearAll();
			        dlg.addWarning(nlsArray.hpel_logviewer_instanceselected_notavail, null);
			        dlg.show();
					
				}
			},
			onError: function(error,response) {
				console.log("Error:  failed to featch new data, with error message = " + error);
		        var dlg = dijit.byId('errorDialog');
		        dlg.clearAll();
		        dlg.addError("Error:  failed to featch new data, with error message = ", error);
		        dlg.show();
		        return;
			}
		});
	}
	

	/*
	 * binary search a array
	 */
	function binarySearch(arr, key, insertIndex) {
        var len = arr.length;
        var sp = -1;
        var m;
        var retVal = -1;

        while (len - sp > 1) {
            var index = m = len + sp >> 1;
            if (arr[index] < key) {
                sp = m;
            } else {
                len = m;
            }
        }
        
        if (arr[len] == key || insertIndex ) {
            retVal = len;   
        }
        return retVal;
}
	/*
	 * what to do when someone clicks on tree
	 */
	function onTreeClick(item, xnode) {
		if (item === this.rootNode || item.type[0] === "date" || item.type[0] === "startuptime") {
			return true;
		}
		
	    var siStore = this.model.store;
        if (item && siStore.isItem(item)) {
			selectNewInstance(this.model.store.getValue(item, "starttime"));
//    	    return siStore.getValue(item, "starttime") === currentInstanceSelection;
        } 

//        oDiv = document.getElementById("viewServerInstance");
//        oDiv.innerHTML = '&nbsp;'+selectedTreeNode.labelNode.innerHTML+'&nbsp;';
//        var ode = selectedTreeNode.getParent().label;
//        if (isZOS) { //TODO only zos use, see if we can do without it
//        	ode = '';
//        }
//        oDiv.innerHTML = '&nbsp;'+ode+'&nbsp;'+selectedTreeNode.labelNode.innerHTML+'&nbsp;';

        updateODiv(xnode);

		
		return true;
	}

	/*
	 * This method will be called when a user click on view selected thread button
	 */
	function viewSelectedThreadOnly(){
	
	    /*
	     * reset so this does not keep counting up
	     */
	    currentRow = -1;
	    
	    
	    // find the grid in dom
	    var grid2 = dijit.byId("grid");
	    
	    // following is experimenal code that prints all the method on object
	    // starting with "on"
	    // below was for debug purpose
	    // for (var i in grid2) if (i.indexOf("on")==0) console.log(i);
	    // for (var i in grid2.model) if (i.indexOf("on")==0) console.log(i);
	    
	    // get selected rows from the grid
	    var items = grid2.selection.getSelected();
	    
	    // create a array to store selected thread value
	    var threadArray = new Array();
	    
	    // check if anything was selected
	    if (items.length) {
	        // Iterate through the list of selected items.
	        // The current item is available in the variable
	        // "selectedItem" within the following function:
	        dojo.forEach(items, function(selectedItem){
	            if (selectedItem !== null) {
	                // get the thread id from the selected row
//	            	var selItem = grid2.getItem(selectedItem);
	            	//console.debug(selectedItem);
	                var currentlySelected = grid2.store.getValue(selectedItem, 'threadid');
	                // console.log("Selected Threadid"+currentlySelected);
	                
	                // store it in the array
	                threadArray.push(currentlySelected);
	            } // end if
	        }); // end forEach
	    }
	    else {
	        // if nothing was selected, show a error dialog
	
	        var dlg = dijit.byId('errorDialog');
	        dlg.clearAll();
	        dlg.addError(nlsArray.ras_logviewer_selectOneRow_error, null);
	        dlg.show();
	        return;
	        
	    }// end if
	    // create a object to send to server
	    
	    showSelectedThread(threadArray);
	    
	}
	
	/*
	 * this method will send the form using ajax
	 * form will contain selected threads only, this is refactored so we can use the submenu options
	 */
	function showSelectedThread(threadArray){
	    var xhrArgs = {
	            url: "/ibm/console/logViewerFilterServlet",
	            content: {
	                threadid: dojo.toJson(threadArray)
	            },
	            handleAs: "json", // return value will be a json
	            load: function(data){
	                // hide the busy indicator
	                appInstallWaitHideProbDeter();

	                // if return value from server had "error" set to "invalid_session"
	                // show invalid session dialog and return back to login page
	                if (data.error === "invalid_session") {
	                    // send it somewhere elseformName
	                    
	                    // top.location = location.protocol + "//" + location.host +
	                    // "/ibm/console/";
	                    dijit.byId("invalidSession").show();
	                    return;
	                    
	                }
	                
	                // server post was successful. filters are set
	                // now reload the grid
	                // console.debug("successful post in viewSelectedThreadOnly");
	                refreshView();

	            },
	            error: function(error){
	                // something went wrong with post
	                // hide the busy indicator
	                appInstallWaitHideProbDeter();
	
	                var dlg = dijit.byId('errorDialog');
	                dlg.clearAll();
	                dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
	                dlg.show();
	                console.error("Error during filter", dojo.toJson(error, true));
	            }
	        };
	        
	        // post this asynchronously to server
	        var deferred = dojo.xhrPost(xhrArgs);
	        // show busy icon after post
	        appInstallWaitShowProbDeter();
	        
	        // enable show all thread button
	        var node = dojo.byId("showAllButton");
	        dojo.attr(node, "disabled", false);
		
	}
	
	/*
	 * this method is called when show all thread button is clicked on the server
	 */
	function showAllThread(){
	
	    var xhrArgs = {
	        url: "/ibm/console/logViewerFilterServlet",
	        content: {
	            threadid: dojo.toJson(new Array("*"))
	        },
            handleAs: "json", // return value will be a json
	        load: function(data){
	            // hide the busy indicator
	            appInstallWaitHideProbDeter();
	            // if return value from server had "error" set to "invalid_session"
	            // show invalid session dialog and return back to login page
	            if (data.error === "invalid_session") {
	                // send it somewhere elseformName
	                
	                // top.location = location.protocol + "//" + location.host +
	                // "/ibm/console/";
	                dijit.byId("invalidSession").show();
	                return;
	                
	            }
	            // server post was successful. filters are set
	            // now reload the grid
	            // console.debug("successful post in viewSelectedThreadOnly");
	            refreshView();
	            
	        },
	        error: function(error){
	            // something went wrong with post
	            // hide the busy indicator
	            appInstallWaitHideProbDeter();
	
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.ras_logviewer_filterError,  dojo.toJson(error, true));
	            dlg.show();
	            console.error("Error during filter", dojo.toJson(error, true));
	        }
	    };
	    // post this asynchronously to server
	    var deferred = dojo.xhrPost(xhrArgs);
	    // show busy icon after post
	    appInstallWaitShowProbDeter();
	    
	    // now disable the show all button
	    var node = dojo.byId("showAllButton");
	    dojo.attr(node, "disabled", true);
	}
	
	/*
	 * show header grid
	 */
function showHeaderGrid(){
	
//	grid3 = dijit.byId("headerGrid");
//	var storeheader = new probdeter.QueryReadStore({url:'/ibm/console/logHeaderServlet', requestMethod: 'post'});
////	grid3.model.refresh();
//	grid3.setStore(storeheader);
    dijit.byId('serverInstanceInformation').show();

	var headerGrid = dijit.byId("headerGrid");
	
	if (headerGrid) {
		headerGrid.destroy();
	}

    
	var hrstore = new probdeter.ItemFileReadStore({url:'/ibm/console/logHeaderServlet', urlPreventCache:true});

	headerGrid = new probdeter.DataGrid({
		id:'headerGrid',
		jsId:'headerGrid',
		store:hrstore,
		structure:headerLayout,
		columnToggling:"false"
    },
    document.createElement('div'));

    // append the new grid to the div "gridContainer4":
    dojo.byId("headerGridNode").appendChild(headerGrid.domNode);

    // Call startup, in order to render the grid:
    headerGrid.startup();

}	
	
	/*
	 * 
	 */
	function restoreDefaultColumns() {
	    // find the grid
	    var grid = dijit.byId("grid");

	    for (var z in grid.layout.cells) {
			grid.layout.setColumnVisibility(z, true);
	    	//console.debug(grid.structure[z].field);
	    }

		
		dijit.byId('timestamp').set('checked',  true);
		dijit.byId('threadid').set('checked', true);
		dijit.byId('logger').set('checked', true);
		dijit.byId('event').set('checked', true);
		dijit.byId('message').set('checked',true);

//		grid.set("structure",grid.structure);
		
		dijit.byId('selectColumnDialog').hide();

	}
	/*
	 * show choose column dailog
	 */
	function showChooseColumnDialog(){
	    // find the grid
	    var grid = dijit.byId("grid");
	    
	    for (var z in grid.layout.cells) {
	    	//console.debug(grid.structure[z].field);
	    	if (grid.layout.cells[z].field === "datetime") {
	    		dijit.byId('timestamp').set('checked',  !grid.layout.cells[z].hidden);
	    	} else if (grid.layout.cells[z].field === "threadid") {
	    		dijit.byId('threadid').set('checked',  !grid.layout.cells[z].hidden);
	    	} else if (grid.layout.cells[z].field === "logger") {
	    		dijit.byId('logger').set('checked',  !grid.layout.cells[z].hidden);
	    	} else if (grid.layout.cells[z].field === "event") {	    		
	    		dijit.byId('event').set('checked',  !grid.layout.cells[z].hidden);
	    	} else if (grid.layout.cells[z].field === "message") {	    		
	    		dijit.byId('message').set('checked',  !grid.layout.cells[z].hidden);
	    	}  
	    }

		dijit.byId('selectColumnDialog').show();
	}
	/*
	 * this method is called when choose columns button is clicked and columns are
	 * choosen
	 */
	function chooseColumnsToView(selectedCol){
	
	    // find the grid
	    var grid = dijit.byId("grid");
	    
	    var z;
	    var zz;
	    
	    for (z in grid.layout.cells) {
	    	if (grid.layout.cells[z].field === "datetime") {
	    		grid.layout.setColumnVisibility(z, selectedCol.timestamp.length !== 0);
	    	} else if (grid.layout.cells[z].field === "threadid") {
	    		grid.layout.setColumnVisibility(z,selectedCol.threadid.length !== 0);	    		
	    	} else if (grid.layout.cells[z].field === "logger") {
	    		grid.layout.setColumnVisibility(z, selectedCol.logger.length !== 0);
	    	} else if (grid.layout.cells[z].field === "event") {	    		
	    		grid.layout.setColumnVisibility(z, selectedCol.event.length !== 0);
	    	} else if (grid.layout.cells[z].field === "message") {	    		
	    		grid.layout.setColumnVisibility(z, selectedCol.message.length !== 0);
	    		if(grid.layout.cells[z].hidden) {
                    for (zz in grid.layout.cells) {
                       if (grid.layout.cells[zz].field === "logger") {
                          grid.layout.cells[zz].width = '60em';
                       }
                    }
                } else {
                    for (zz in grid.layout.cells) {
                        if (grid.layout.cells[zz].field === "logger") {
                           grid.layout.cells[zz].width = '55px';
                        }
                     }
                	
                }
	    	}  
	    	
	    }
	    
	}
	
	/*
	 * This method is called when a user says ok on the export dialog. The export
	 * disalog is displayed when a user clicks on the button in the button bar
	 */
	function exportLogs(args) {
	    // prepare the structure to query the server for key
	    // message key is sent to the function
	    var xhrArgs = {
		        url: "/ibm/console/logExportServlet", // export servlet name
		        content: { // the arguments for post
		            format: args.exportFormat,
		            currentView: args.exportType === "exportView",
	            	csrfid: getCookie('com.ibm.ws.console.CSRFToken'),
			        downloadStep: 0
		        },
	            handleAs: "json", // return value will be a json
		        load: function(data){
		        	// handle the invalid session scenario
			        if (data.errors) {
			        	/*
			        	 * clear all previous errors
			        	 */
			            var dlg = dijit.byId('errorDialog');

			            dlg.processError(data);
			            
			            dlg.show();
			
			        } else { 
			            //console.debug(data);
			            /*
			             * now get the file from server
			             */
			            exportLogsDownLoad(args);
			            appInstallWaitHideProbDeter();
			        }
		        },
		        error: function(error){
		        	// show error when something goes wrong
	
		        	var dlg = dijit.byId('errorDialog');
		        	dlg.clearAll();
		        	dlg.addError(nlsArray.ras_logviewer_showidError ,  dojo.toJson(error, true));
		        	dlg.show();
	
		        	console.error("Error during filter", dojo.toJson(error, true));
		        	appInstallWaitHideProbDeter();
		        }
	    };
	    
	    // send the data to server
	    // it is ok to use get since cached information will be same
	    var deferred = dojo.xhrPost(xhrArgs);
	    appInstallWaitShowProbDeter();

	}
	function exportLogsDownLoad(args){
	    /*
	     * prepare the object to send to server
	     */
	    var url = "/ibm/console/logExportServlet?format=" + args.exportFormat;
	    url += "&currentView=" + (args.exportType === "exportView");
	    url += "&csrfid=" + getCookie('com.ibm.ws.console.CSRFToken');
	    url += "&downloadStep=1";
	    var iframe = dojo.io.iframe.create("exportDownloadIframe");
	    dojo.io.iframe.setSrc(iframe, url, true);
	    /*
	    var xhrArgs = {
	        url: "/ibm/console/logExportServlet", // export servlet name
	        method: "post", // the post method for it
	        handleAs: "json",
	        content: { // the arguments for post
	            format: args.exportFormat === "exportHPELFormat",
	            currentView: args.exportType === "exportView",
	            csrfid: getCookie('com.ibm.ws.console.CSRFToken'),
	            downloadStep: 1
	        },
	        load: function(response, ioArgs){
	            return response;
	        },
	        
	        // Callback on errors:
	        error: function(response, ioArgs){
	        	appInstallWaitHideProbDeter();
	        	
	        	if (response.message === "undefined" || response.message === "Deferred Cancelled") {
	        		return response;
	        	}
	            // show error when something goes wrong
	        	
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.hpel_logviewer_exportError ,  dojo.toJson(response, true));
	            dlg.show();
	
	            console.error(nlsArray.hpel_logviewer_exportError, dojo.toJson(response, true));
	            
	            return response;
	        }
	        
	    };
	    
	    // Use dojo.io.iframe.send so we can get a download box from browser
	    if (fileDownloadDefered) {
		    try {
	            fileDownloadDefered.cancel();
		    } catch(e) {
		    	console.debug(dojo.toJson(e, true));
		    }
	    }
	    fileDownloadDefered = dojo.io.iframe.send(xhrArgs);
	    // console.log(deferred);
	    */
	}
	
	/*
	 * This is displayed when a user click on the message key for explanation
	 */
	function showRuntimeMessageDialog(msgKey, detail){
	
	    // prepare the structure to query the server for key
	    // message key is sent to the function
	    var xhrArgs = {
	        url: "/ibm/console/logMessageLookupServlet",
	        content: {
	            messageKey: msgKey
	        },
            handleAs: "json", // return value will be a json
	        load: function(data){
	            // handle the invalid session scenario
	            if (data.error === "invalid_session") {
	                // send it somewhere else
	                dijit.byId("invalidSession").show();
	                // top.location = location.protocol + "//" + location.host +
	                // "/ibm/console/";
	                return;
	                
	            }
	            appInstallWaitHideProbDeter();
	            // update the fields in the dialog box
	            // dojo.byId("runtimemessageexplanation").value = data.explanation;
	            // dojo.byId("runtimemessageaction").value=data.recommendation;
	            // dojo.byId("runtimemessage").value=data.message;
	            dijit.byId("runtimemessageexplanation").set('value', data.explanation);
	            dijit.byId("runtimemessageaction").set('value', data.recommendation);
	            dijit.byId("runtimemessage").set('value', detail);
	            dijit.byId("runtimemessagetype").attr('value', data.message);
	            
	            // find the message dialog and show it
	            var dlg = dijit.byId('runtimeMessageDialog');
	            dlg.show();
	        },
	        error: function(error){
	            // show error when something goes wrong
	
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.ras_logviewer_showidError ,  dojo.toJson(error, true));
	            dlg.show();
	
	            console.error("Error during filter", dojo.toJson(error, true));
	            appInstallWaitHideProbDeter();
	        }
	    };
	    
	    // send the data to server
	    // it is ok to use get since cached information will be same
	    var deferred = dojo.xhrGet(xhrArgs);
	    appInstallWaitShowProbDeter();
	}
	/*
	 * This is displayed when a user click on the message key for explanation
	 */
	function showFFDCFileDialog(fname){
	
	    // prepare the structure to query the server for key
	    // message key is sent to the function
	    var xhrArgs = {
	        url: "/ibm/console/ffdcFileViewServlet",
	        content: {
	            filename: fname
	        },
            handleAs: "json", // return value will be a json
	        load: function(data){
	            appInstallWaitHideProbDeter();
	            // handle the invalid session scenario
		        if (data.errors) {
		        	/*
		        	 * clear all previous errors
		        	 */
		            var dlg = dijit.byId('errorDialog');

		            dlg.processError(data);
		            
		            dlg.show();
		
		        } else { 
			        // clear the field first
		            dijit.byId("ffdcfile").set('value', ' Empty to be filled by actual report. Only visible during error');
		            // update the fields in the dialog box
		            if (data.filecontent && data.filecontent[0]) {
		            	dijit.byId("ffdcfile").set('value', data.filecontent[0]);
		            }
		            
		            // find the message dialog and show it
		            var dlgffdc = dijit.byId('FFDCFileDialog');
		            dlgffdc.show();
		        }
	        },
	        error: function(error){
	            // show error when something goes wrong
	
	            appInstallWaitHideProbDeter();
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.ras_logviewer_showidError ,  dojo.toJson(error, true));
	            dlg.show();
	
	            console.error("Error during filter", dojo.toJson(error, true));
	        }
	    };
	    
	    // send the data to server
	    // it is ok to use get since cached information will be same
	    var deferred = dojo.xhrGet(xhrArgs);
	    appInstallWaitShowProbDeter();
	}
	
	/*
	 * this method is called when clear button is pressed in the filter section
	 */
	function clearFilter(formName){
	    // form name is supplied so just make the request structure to clear filters
	    // and send it
	    var xhrArgs = {
	        url: "/ibm/console/logViewerFilterServlet",
	        content: {
	            clearFilter: formName
	        },
            handleAs: "json", // return value will be a json
	        load: function(data){
	            appInstallWaitHideProbDeter();

	            // handle the invalid session scenarion
	            if (data.error === "invalid_session") {
	                // send it somewhere else
	                dijit.byId("invalidSession").show();
	                // top.location = location.protocol + "//" + location.host+
	                // "/ibm/console/";
	                return;
	                
	            }
	            
	            // find the grid and refresh it
	            refreshView();

	            
	        },
	        error: function(error){
	            // show error when something goes wrong
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
	            dlg.show();
	            
	            
	            console.error("Error during filter", dojo.toJson(error, true));
	            appInstallWaitHideProbDeter();
	        }
	    };
	    
	    // send the clear filter to server
	    var deferred = dojo.xhrPost(xhrArgs);
	    appInstallWaitShowProbDeter();
	    
	}
		
	/*
	 * this is called when we apply a filter the form name is supplied
	 */
	function applyFilter(formName){

		/*
		 * array for message that fail validation, so we can show them together
		 */
	    var validationFailMsg = new Array();

	    
	    /*
	     * reset so this does not keep counting up
	     */
	    var curForm = dijit.byId(formName);
	//    console.debug('Attempting to submit form w/values:\n', dojo.toJson(curForm.getValues(), true));
	    var ec;
	    var dlg;
	    /*
	     * validate form
	     */
	    if (!curForm.validate()) {
	    	
	    	validationFailMsg.push(nlsArray.hpel_logviewer_validation_error);
	    }
	    /*
	     * validate to make sure that atleast one checkbox is there
	     */
	    var lt = document.getElementById("Logs_and_Trace").checked;
	    var syserr = document.getElementById("showSysout").checked;
	    var sysout = document.getElementById("showSyserr").checked;
	    if (!lt && !syserr && !sysout) {
	    	validationFailMsg.push(nlsArray.hpel_logviewer_select_error);
	    }
	    /*
	     * validate that min level is lower than max level
	     */
	    var minlevel = dijit.byId("minlevel");
	    var maxlevel = dijit.byId("maxlevel");
	    var validateLevels = dojox.validate.isText(minlevel) && dojox.validate.isText(maxlevel);
	//    console.debug("minlevel is " + minlevel.value + " max level is " + maxlevel.value + " validate? " + validateLevels);
	    if (validateLevels) {
	        var startl = levelArray[minlevel.value];
	        var stopl = levelArray[maxlevel.value];
	//        console.debug("min level num is " + startl);
	//        console.debug("max level num is " + stopl);
	//        console.debug("is error ?" + (startl > stopl));
	        if (startl > stopl) {
		    	validationFailMsg.push(nlsArray.hpel_logviewer_wrong_errorlevel);
	        }
	    }
	    
	    
	    //validate sysout and syserr are not part of filter
	    var ilog = dijit.byId('inclloggers');
	    var xlog = dijit.byId('exclloggers');
	    if (ilog){
            ilogData = ilog.attr('value').split(':');
            
            for (i = 0; i < ilogData.length;i++) {
            	if (ilogData[i] === 'SystemOut' || ilogData[i] === 'SystemErr') {
            		validationFailMsg.push("Cannot specify SystemOut or SystemErr in include/exclude logger. Please use View Contents to select inclusion of System Streams");
            		break;
            	}
            }
	    }
	    
	    if(xlog){
            xlogData = xlog.attr('value').split(':');
            
            for (i = 0; i < xlogData.length;i++) {
            	if (xlogData[i] === 'SystemOut' || xlogData[i] === 'SystemErr') {
            		validationFailMsg.push("Cannot specify SystemOut or SystemErr in include/exclude logger. Please use View Contents to select inclusion of System Streams");
            		break;
            	}
            }
	    }
	    
	    // validate date is set with time
	    var stopdate = dijit.byId("stopdate");
	    var stoptime = dijit.byId("stoptime");
	    var startdate = dijit.byId("startdate");
	    var starttime = dijit.byId("starttime");
	    if ((stoptime.attr('value') && !stopdate.attr('value')) || (starttime.attr('value') && !startdate.attr('value')) ) {
	    	validationFailMsg.push("Date field is required if time field is specified");
	    }

	    
	    // show any validation errors
	    if (validationFailMsg.length > 0) {
            dlg = dijit.byId('errorDialog');
            dlg.clearAll();

            for (var i = 0; i < validationFailMsg.length; i++) {
                dlg.addError(validationFailMsg[i], null);
	        }
            
            
            dlg.show();
            
            
            return false;
	    	
	    }
	    
	    currentRow = -1;
	    
	    var time;
	    var oDiv;
	    
	    /*
	     * change time displayed to the value selected by filter
	     */
	    var node = dijit.byId("stopdate");
	    var node2 = dijit.byId("stoptime");
	    var z = node.attr('value');
	    var cStoD = z !== null && dojox.validate.isText(z);
	    var s = '';
	    if (cStoD) {
	//        console.debug("date string is " + s);
	        if (node2 && dojox.validate.isText(node2)) {
	            s = node.toString().replace(/-/g, '\/');
	            s = s.concat(' ', node2.toString().substring(1));
	            z = new Date(s);
	//            console.debug("final date string is " + s);
	        }
	        time = dojo.date.locale.format(z, {
	            formatLength: "short"
	        });
	//        console.debug("date time object is " + time.toString());
//	        oDiv = document.getElementById("viewStopDateTime");
//	        oDiv.innerHTML = '&nbsp;'+time+'&nbsp;';
	//        console.debug("applyFilter()  set stop date " + time);
	    }
	    
	    node = dijit.byId("startdate");
	    node2 = dijit.byId("starttime");
        z = node.attr('value');
	    var cStaT = z !== null && dojox.validate.isText(z);
	    if (cStaT) {
	//        console.debug("date string is " + s);
	        if (node2 && dojox.validate.isText(node2)) {
	            s = node.toString().replace(/-/g, '\/');
	            s = s.concat(' ', node2.toString().substring(1));
	            z = new Date(s);
	//            console.debug("final date string is " + s);
	        }
	        time = dojo.date.locale.format(z, {
	            formatLength: "short"
	        });
	//        console.debug("date time object is " + time.toString());
//	        oDiv = document.getElementById("viewStartDateTime");
//	        oDiv.innerHTML = '&nbsp;'+time+'&nbsp;';
	//        console.debug("applyFilter()  set start date " + time);
	    }
	    
	    /*
	     * change filter constraints to initial
	     */
	    if (cStoD || cStaT) {
	        dateFilterSet = true;
	    //    dijit.byId('stopdate').constraints.min = minTimeForData;
	    //    dijit.byId('startdate').constraints.min = minTimeForData;
	    //    dijit.byId('stopdate').constraints.max = null;
	    //    dijit.byId('startdate').constraints.max = null;
	//        console.debug("applyFilter()  change min constrainst for both start and stop ");
	        
	    }
	    
	    
	    
	    // prepare the structure to send to server
	    var xhrArgs = {
	        url: "/ibm/console/logViewerFilterServlet",
	        form: dojo.byId(formName),
            handleAs: "json", // return value will be a json
	        
	        load: function(data){
            	appInstallWaitHideProbDeter();

            	// handle the invalid session scenarion
	            if (data.error === "invalid_session") {
	                // send it somewhere else
	                dijit.byId("invalidSession").show();
	                // top.location = location.protocol + "//" + location.host +
	                // "/ibm/console/";
	                return;
	            } else if (data.serverError) {
	                var dlg = dijit.byId('errorDialog');
	                dlg.clearAll();
	                dlg.addError(data.serverError);
	                dlg.show();
	                console.error("Error during filter", data.serverError);
	                return;
 	            }
	            
	            // find the grid and refresh it
	            refreshView();

	            
	        },
	        error: function(error){
	            appInstallWaitHideProbDeter();
	            var dlg = dijit.byId('errorDialog');
	            dlg.clearAll();
	            dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
	            dlg.show();
	            console.error("Error during filter", dojo.toJson(error, true));
	        }
	    };
	    
	    // send it to the server
	    var deferred = dojo.xhrPost(xhrArgs);
	    appInstallWaitShowProbDeter();
	    
	    return true;
	    
	}
	
	Clipboard = {}; 
	Clipboard.utilities = {}; 
	Clipboard.utilities.createTextArea = function(value) { 
	    var txt = document.createElement('textarea'); 
	    txt.style.position = "absolute"; 
	    txt.style.left = "-100%"; 
	    if (value !== null) { 
	        txt.value = value;
	    }
	    document.body.appendChild(txt); 
	    return txt; 
	}; 
	Clipboard.copy = function(data){
	    if (data === null) {
	        return;
	    }
	    var txt = Clipboard.utilities.createTextArea(data);
	    txt.select();
	    document.execCommand('Copy');
	    document.body.removeChild(txt);
	};
	 
	Clipboard.paste = function(){
	    var txt = Clipboard.utilities.createTextArea();
	    txt.focus();
	    document.execCommand('Paste');
	    var value = txt.value;
	    document.body.removeChild(txt);
	    return value;
	};

	/*
	 *
	 */
	function copyToClipboard(copyURL){ // https://developer.mozilla.org/en/Using_the_Clipboard
	    // generate the Unicode and HTML versions of the Link
	    try {
	        netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
	    } 
	    catch (e) {
	        var dlg = dijit.byId('errorDialog');
	        dlg.clearAll();
	        dlg.addError(nlsArray.nlsArray_ns_errorDetail, dojo.toJson(e, true));
	        dlg.show();
	    	return false;
	        
	    }
	    var textUnicode = copyURL;
	    
	    // make a copy of the Unicode
	    
	    var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
	    if (!str) {
	        return false; // couldn't get string obj
	    }
	    
	    str.data = textUnicode; // unicode string?
	    // add Unicode & HTML flavors to the transferable widget
	    
	    var trans = Components.classes["@mozilla.org/widget/transferable;1"].createInstance(Components.interfaces.nsITransferable);
	    if (!trans) {
	        return false; // no transferable widget found
	    }
	    
	    trans.addDataFlavor("text/unicode");
	    trans.setTransferData("text/unicode", str, textUnicode.length * 2); // *2
	    // because
	    // it's
	    // unicode
	    
	    // copy the transferable widget!
	    
	    var clipboard = Components.classes["@mozilla.org/widget/clipboard;1"].getService(Components.interfaces.nsIClipboard);
	    if (!clipboard) {
	        return false; // couldn't get the clipboard
	    }
	    
	    clipboard.setData(trans, null, Components.interfaces.nsIClipboard.kGlobalClipboard);
	    
	    return true;
	    
	}
	
	/*
	 * This method will be called when a user click on view selected thread button
	 */
	function copyToCB(){
	
	    // find the grid in dom
	    var grid2 = dijit.byId("grid");
	    
	    // get selected rows from the grid
	    var items = grid2.selection.getSelected();
	    
	    var s = "";
	    
	    var newLine = "\n";
	    if(navigator.appVersion.indexOf("Win")!=-1) {
	    	newLine = "\r\n";
	    }
	    
	    // check if anything was selected
	    if (items.length) {
	        // Iterate through the list of selected items.
	        // The current item is available in the variable
	        // "selectedItem" within the following function:
	        dojo.forEach(items, function(selectedItem){
	            if (selectedItem !== null) {
	                // 12463713755870TRAS0017I: The startup trace state is
	                // *=info.INFO com.ibm.ejs.ras.ManagerAdmin
	                // get the thread id from the selected row
//	            	var selItem = grid2.getItem(selectedItem);
	                var thread = grid2.store.getValue(selectedItem, 'threadid');
	                var message = grid2.store.getValue(selectedItem, 'message');
	                var logger = grid2.store.getValue(selectedItem, 'logger');
	                var level = grid2.store.getValue(selectedItem, 'event');
	                var date = grid2.store.getValue(selectedItem, 'datetime');
	                if (thread === "*") {
	                	thread = "";
	                	logger = "";
	                	level = "";
	                	date = "";
	                	/*
	                	 * we need to format header
	                	 */
	                	var eqRegEx = /<\/td><td class='dojoxGrid-cell' style='font-size:9px'>/g;
	                	var evColRegEx = /<\/td><\/tr><tr class='dojoxGrid-row dojoxGrid-row-odd'><td class='dojoxGrid-cell' style='font-size:9px'>/g;
	                	var oddColRegEx = /<\/td><\/tr><tr class='dojoxGrid-row'><td class='dojoxGrid-cell' style='font-size:9px'>/g;
	            		var htmlTags = /<(?:.|\s)*?>/g;
	                	message = message.replace(eqRegEx, "=");
	                	message = message.replace(evColRegEx, newLine);
	                	message = message.replace(oddColRegEx, newLine);
	                	message = message.replace(htmlTags, "");

	                }
	                
	                s = s.concat(formatTime(date), "    ", formatThreadId(thread), "    ", logger, "    ", level, "    ", message, newLine);
	                
	            } // end if
	        }); // end forEach
	        // console.debug(s);
	        if (dojo.isIE && window.clipboardData && clipboardData.setData) {
	            clipboardData.setData("Text", s);
	        }
	        else 
	            if (dojo.isFF || dojo.isMozilla) {
	                copyToClipboard(s);
	            }
	            else 
	                if (dojo.isChrome || navigator.userAgent.indexOf('Chrome') !== -1) {
	                    Clipboard.copy(s);
	                }
	                else {
	                    // one of the unsupported behaviour. display a error
	                    var dlg = dijit.byId('errorDialog');
	                    dlg.clearAll();
	                    dlg.addError(nlsArray.hpel_logview_copytocb_unsupportedbrowser, null);
	                    dlg.show();
	
	                	return;
	                }
	    }
	    else {
	        // if nothing was selected, show a error dialog
	        dlg = dijit.byId('errorDialog');
	        dlg.clearAll();
	        dlg.addError(nlsArray.hpel_logview_copytocb_selectOneRowError, null);
	        dlg.show();
	        return;
	        
	    }// end if
	}
	
	/*
	 *
	 */
	function appInstallWaitShowProbDeter(){
	    try {
	        // appInstallWaitShow();
	        // showPleaseWaitButton();
	        var dlg = dijit.byId('pleaseWaitDialog');
	        dlg.show();
	    } 
	    catch (x) {
	        try {
	            document.getElementById("progress").style.display = "block";
	        } 
	        catch (e) {
	            console.error("Error displaying please wait");
	            console.error(e);
	        }
	    }
	    // if (isDom) {
	    // document.all["progress"].style.display = "block";
	    // } else if (isNav4) {
	    // document.layers["progress"].visibility="show";
	    // }
	    // else {
	    // document.all["progress"].style.display = "block";
	    // }
	
	}
	
	/*
	 * 
	 */
	function appInstallWaitHideProbDeter(){
		
		//console.debug(dlg);
//		dlg.hide();

		try {
			  var dlg2 = dijit.byId('pleaseWaitDialog');
			  if (dlg2) {
			      dlg2.hide();
			  }
	          try {
	        	  var xer = document.getElementById("progress");
	        	  if (xer) {
	                  xer.style.display = "none";
	        	  }
	          }
	          catch (e) {
	              //console.log("Error hiding please wait");
	              //console.log(e);
	          }
		}
	    catch (x) {
	        try {
	            document.getElementById("progress").style.display = "none";
	        } 
	        catch (e) {
	            //console.log("Error hiding please wait");
	            //console.log(e);
	            
	        }
	    }
	
	}
	
	/*
	 * 
	 */
	function updateDateFieldFrom(timeTextBox){
	    var dateBox = dijit.byId("startdate");
	    // console.log(dateBox.getDisplayedValue());
	    if (timeTextBox.attr('value') === null) {
	        dateBox.attr('displayedValue', '');	    	
	    } else if ( !dateBox.attr('displayedValue')) {
	        var constraints = dateBox.constraints;
	        constraints.selector = dateBox._selector;
	        var ds = dateBox.format(new Date(), constraints);
	        dateBox.attr('displayedValue', ds);
	    }
	    // console.log(dateBox.getDisplayedValue());
	    return true;
	    
	}
	
	/*
	 * 
	 */
	function updateDateFieldTo(timeTextBox){
	    var dateBox = dijit.byId("stopdate");
	    // console.log(dateBox.getDisplayedValue());
	    if (timeTextBox.attr('value') === null) {
	        dateBox.attr('displayedValue', '');	    	
	    } else if ( !dateBox.attr('displayedValue')) {
	        var constraints = dateBox.constraints;
	        constraints.selector = dateBox._selector;
	        var ds = dateBox.format(new Date(), constraints);
	        dateBox.attr('displayedValue', ds);
	    }
	    // console.log(dateBox.getDisplayedValue());
	    
	    return true;
	}
	
	
	function writeOutHelpPortletLogColumns(titleText) {
	    try {
	
	            addPageText = " "+lookInPageHelp;
	
	            scriptLabel = document.createTextNode(titleText);
	
	            if (document.getElementById("fieldHelpPortlet")) {
	                document.getElementById("fieldHelpPortlet").innerHTML = "";
	                document.getElementById("fieldHelpPortlet").appendChild(scriptLabel);
	                document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width = "20%";
	
	                if (!isDom) {
	                    if (document.getElementById("fieldHelpPortlet").offsetHeight >= 200) {
	                        document.getElementById("fieldHelpPortlet").style.height = 200;
	                    } else {
	                        document.getElementById("fieldHelpPortlet").style.height = "";
	                    }
	                } else {
	                    document.getElementById("fieldHelpPortlet").style.display = "none";
	                    document.getElementById("fieldHelpPortlet").style.display = "block";
	                }
	
	
	                floatHelpPortlet();
	
	            }
	        titleText = "";
	    } catch(err) {
	    	console.error(err);
	        return;
	    }
	}
	
	function setUserFilterIncludeLoggers(filterString) {
		var cellValue = escape(filterString);
		
	    ilog = dijit.byId('inclloggers');
	    	    
	    curValue = ilog.attr('value');
	    
	    if (curValue) {
	    	cellValue = cellValue + ":"+curValue;
	    }
	    ilog.attr('value',cellValue);
		/*
		 * show preference if not shown already
		 */
        if (document.getElementById('com_ibm_ws_probdetermination_prefsTable').style.display == "none") {
           showHidePreferencesCall('com_ibm_ws_probdetermination_prefsTable');
        }

	    ilog.focus();

	}
	function setUserFilterExcludeLoggers(filterString) {
		var cellValue = escape(filterString);
		
	    ilog = dijit.byId('exclloggers');
	    
	    curValue = ilog.attr('value');
	    
	    if (curValue) {
	    	cellValue = cellValue + ":"+curValue;
	    }
	    ilog.attr('value',cellValue);
		/*
		 * show preference if not shown already
		 */
        if (document.getElementById('com_ibm_ws_probdetermination_prefsTable').style.display == "none") {
           showHidePreferencesCall('com_ibm_ws_probdetermination_prefsTable');
        }
	    ilog.focus();

	}
	/*
	 * set filet
	 */
	function setUserFilter(filterKey){
		
		var cellValue;
		var ilog;
		var curValue;
		var dateTime;
		
		var xgrid = dijit.byId('grid');
    	var selItem = xgrid.getItem(cellNode.rowIndex);

		
		switch (filterKey) {
		case 1:
			// thread
		    cellValue = xgrid.store.getValue(selItem, 'threadid');
		    var threadArray = new Array();
		    threadArray.push(cellValue);
		    showSelectedThread(threadArray);
	
			break;
		case 2:
		    // level only
		    cellValue = xgrid.store.getValue(selItem, 'event');
			dijit.byId('minlevel').attr('value',cellValue);
		    dijit.byId('maxlevel').attr('value', cellValue);
		    dijit.byId('maxlevel').focus();
			
			break;
		case 3:
		    //level maximum
		    cellValue = xgrid.store.getValue(selItem, 'event');
		    dijit.byId('maxlevel').attr('value',cellValue);
		    dijit.byId('maxlevel').focus();
			
			break;
		case 4:
		    //level minimum
		    cellValue = xgrid.store.getValue(selItem, 'event');
		    dijit.byId('minlevel').attr('value',cellValue);
		    dijit.byId('minlevel').focus();
			
			break;
		case 7:
		    // append to mesgContains filter
		    cellValue = xgrid.store.getValue(selItem, 'message');
		    /*
		     * use the message id only if available
		     */
		    myArray = messageId.exec(cellValue);
		    if (myArray) {
		    	var msgId = myArray[1];
		    	if(!cellValue.startsWith(msgId)) {
		    		msgId = "*"+msgId;
		    	}

		    	cellValue = msgId +"*";
		    }
		    ilog = dijit.byId('mesgContains');
		    curValue = ilog.attr('value');
		    if (curValue) {
		    	cellValue = escape(cellValue) + ":"+curValue;
		    }
		    ilog.attr('value',cellValue);
		    ilog.focus();
			
			break;
		case 8:
		    // start from this date and time
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
			cellValue+= tzoffset + offset;
		    startDate = new Date(cellValue);
		    startDate.setHours(0,0,0,0);
		    dijit.byId('startdate').attr('value',startDate);
	        startTime = new Date(cellValue);
		    dijit.byId('starttime').attr('value',startTime);
		    dijit.byId('starttime').focus();
			
			break;
		case 9:
		    // end at this date and time
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
			cellValue+= tzoffset + offset;
		    stopDate = new Date(cellValue);
		    stopDate.setHours(0,0,0,0);
		    dijit.byId('stopdate').attr('value',stopDate);
		    stopTime = new Date(cellValue);
		    dijit.byId('stoptime').attr('value',stopTime);
		    dijit.byId('stoptime').focus();
			
			break;
		case 10:
			// end at the date
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
		    dateTime = new Date(cellValue);
		    dateTime.setHours(0,0,0,0);
		    dijit.byId('stopdate').attr('value',dateTime);
		    dijit.byId('stopdate').focus();
			break;
		case 11:
		    // start at this date
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
		    dateTime = new Date(cellValue);
		    dateTime.setHours(0,0,0,0);
		    dijit.byId('startdate').attr('value', dateTime);
		    dijit.byId('startdate').focus();
			break;
		case 12:
		    //end at this time
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
		    dateTime = new Date(cellValue);
	//	    var time = "T"+dateTime.getHours()+'/'+dateTime.getMinutes()+'/'+dateTime.getSeconds();
		    dijit.byId('stoptime').attr('value',dateTime);
		    dijit.byId('stoptime').focus();
			break;
		case 13:
		    //start at this time
		    cellValue = xgrid.store.getValue(selItem, 'datetime');
		    dateTime = new Date(cellValue);
	//	    var time = "T"+dateTime.getHours()+'/'+dateTime.getMinutes()+'/'+dateTime.getSeconds();
		    dijit.byId('starttime').attr('value',dateTime);
		    dijit.byId('starttime').focus();
			break;

		default:
			console.error("Invalid value for submenu action");
			break;
		}
		/*
		 * show preference if not shown already
		 */
        if (document.getElementById('com_ibm_ws_probdetermination_prefsTable').style.display == "none") {
           showHidePreferencesCall('com_ibm_ws_probdetermination_prefsTable');
        }
	}
	
	/*
	 * show detail of error is any
	 */
	function expandCollapseDetailError(id) {
		var textAreaDiv = dojo.byId(id);
		
		if ( textAreaDiv.style.display === 'none' ) {
			textAreaDiv.style.display = 'block';
		} else {
			textAreaDiv.style.display = 'none';
		}

	
	}
	
	function showHideGrid(objectId) {
		header = document.getElementById(objectId);
		if (header !== null) {
			headerImg = document.getElementById(objectId+"Img");
			if (header.style.visibility == "hidden") {
				dojo.attr(header ,"style", "visibility:visible;position:relative;right:0px;overflow-x:auto;");
				if (headerImg) {
					headerImg.src = "/ibm/console/images/arrow_expanded.gif";
				}
			} else {
                dojo.attr(header, "style", "visibility:hidden;position:absolute;right:-600px;overflow-x:hidden;");
				if (headerImg) {
					headerImg.src = "/ibm/console/images/arrow_collapsed.gif";
				}
			}
		}
	}
    
    var showTooltip = function(e) {
    	
    	var grid = dijit.byId('grid');
    	
    	if (!e) {
    		return;
    	}
    	
        /*
         * find out which column is logger name
         */
        var colnum = -1;
        for (var sss in grid.layout.cells) {
            if (grid.layout.cells[sss].field === 'logger') {
            	colnum = sss;
            }
        }
        /*
         * if that column mouse is over, then show the tooltip
         */
        if(parseInt(colnum, 10) === e.cellIndex) {
            var cellValue = grid.store.getValue(grid.getItem( e.rowIndex), 'logger');

            /*
             * if we are showing header then do not show tooltip on logger column
             */
            if (cellValue !== "*") {
                dijit.showTooltip(cellValue, e.cellNode);
            }
        }
        
        /*
         * now update the help portlet
         */
        switch (e.cellIndex) {
		case 0:
			writeOutHelpPortletLogColumns(nlsArray.hpel_logviewer_tscol_desc);
			break;
		case 1:
			writeOutHelpPortletLogColumns(nlsArray.hpel_logviewer_tidcol_desc);
			break;
		case 2:
			writeOutHelpPortletLogColumns(nlsArray.hpel_logviewer_logcol_desc);
			break;
		case 3:
			writeOutHelpPortletLogColumns(nlsArray.hpel_logviewer_labcol_desc);
			break;
		case 4:
			writeOutHelpPortletLogColumns(nlsArray.hpel_logviewer_mescol_desc);
			break;

		default:
			break;
		}
    };
    
   var hideTooltip = function(e) {
        dijit.hideTooltip(e.cellNode);
        dijit._masterTT._onDeck=null;
    };
    
//    var headerContextMenu = function (e) {
//        cellNode = e;
//        console.debug("header context menu", e);
//    	
//    };
    
	var addContextMenu = function(e) {
        cellNode = e;

		// remove all old menus
        if(newSubMenu) {
	    	dojo.query('#progPopupMenuItem > *').orphan();
	    	dojo.query('#progPopupMenuItem > *').forEach(dojo.empty);
        	newSubMenu.destroyDescendants(false);
        	newSubMenu.destroyRecursive(false);
        }
    	  
        //Level menu
        var grid = dijit.byId('grid');

//        var cellValue = grid.model.getDatum( cellNode.rowIndex, 3);
        var cellValue = grid.store.getValue(grid.getItem(cellNode.rowIndex), 'event');

        var progPopupMenuItem = new dijit.Menu({parentMenu:gridMenu});
        progPopupMenuItem.addChild(new dijit.MenuItem({label:jsm01+ cellValue, onClick:function(){setUserFilter(2);}}));
        progPopupMenuItem.addChild(new dijit.MenuItem({label:jsm02+ cellValue, onClick:function(){setUserFilter(3);}}));
        progPopupMenuItem.addChild(new dijit.MenuItem({label:jsm03+ cellValue, onClick:function(){setUserFilter(4);}}));
      
        
        //logger filter menu
        cellValue = grid.store.getValue(grid.getItem(cellNode.rowIndex), 'logger');
		if (cellValue === "*") {
			return;
		}
		
		var loggerName = cellValue;

		/*
		 * split the array with .
		 */
		var dotsArray=loggerName.split('.');
		/*
		 * find the length of array
		 */
        var dotLength = dotsArray.length;
        
        /*
         * add include and exclude menu
         */
        var loggerFilterSubMenu1 = new dijit.Menu({parentMenu:progPopupMenuItem});
        var loggerFilterSubMenu2 = new dijit.Menu({parentMenu:progPopupMenuItem});
        /*
         * if more then 3 dots in string
         */
        if (dotLength > 3) {
        	/*
        	 * add first 3, this is base
        	 */
        	var startString = dotsArray[0]+'.'+dotsArray[1]+'.'+dotsArray[2];
        	/*
        	 * add them to filter with a .* in the end
        	 */
        	loggerFilterSubMenu1.addChild(new dijit.MenuItem({label:startString+'.*', onClick:function(){setUserFilterIncludeLoggers(startString+".*");}}));
        	loggerFilterSubMenu2.addChild(new dijit.MenuItem({label:startString+'.*', onClick:function(){setUserFilterExcludeLoggers(startString+".*");}}));
        	/*
        	 * now loop over the rest and add them
        	 */
        	var i = 3;
        	for (i = 3; i < dotLength - 1;i++){
        		startString = startString.concat('.', dotsArray[i]);
            	loggerFilterSubMenu1.addChild(new dijit.MenuItem({label:startString+'.*', onClick:function(){setUserFilterIncludeLoggers(startString+".*");}}));
                loggerFilterSubMenu2.addChild(new dijit.MenuItem({label:startString+'.*', onClick:function(){setUserFilterExcludeLoggers(startString+".*");}}));
        	}
        	
        }
        /*
         * add the original string in end
         */
        loggerFilterSubMenu1.addChild(new dijit.MenuItem({label:loggerName, onClick:function(){setUserFilterIncludeLoggers(loggerName);}}));
        loggerFilterSubMenu2.addChild(new dijit.MenuItem({label:loggerName, onClick:function(){setUserFilterExcludeLoggers(loggerName);}}));
      
        // message contents

        
        cellValue = grid.store.getValue(grid.getItem(cellNode.rowIndex), 'message');
	    /*
	     * use the message id only if available
	     */
	    var myArray = messageId.exec(cellValue);
	    if (myArray) {

	    	/*
	    	 * if the string does not start with message id
	    	 * add a * to the begining
	    	 */
	    	var msgId = myArray[1];
	    	if(!cellValue.startsWith(msgId)) {
	    		msgId = "*"+msgId;
	    	}

	    	cellValue = msgId +"*";
	    } else {
		    cellValue = cellValue.substring(0,9) +"...";	    	
	    }
        var mcFilterSubMenu = new dijit.MenuItem({label:jsm06+cellValue, onClick:function(){setUserFilter(7);}});
				
		//Date and Time Filter
        cellValue = grid.store.getValue(grid.getItem(cellNode.rowIndex), 'datetime');
	    /*var dateTime = new Date(cellValue);
	    var dateText = dojo.date.locale.format(dateTime, {
	        formatLength: "short",
	        selector : "date"
	    });
	    var timeText = dojo.date.locale.format(dateTime, {
	        formatLength: "short",
	        timePattern : "HH:mm:ss.SSS",
		    selector : "time"
	    });*/
	    var dateTimeText = formatTime(cellValue);
	    var dateTimeFilterSubMenu = new dijit.Menu({parentMenu:gridMenu});
        dateTimeFilterSubMenu.addChild(new dijit.MenuItem({label:jsm07+dateTimeText, onClick:function(){setUserFilter(8);}}));
        dateTimeFilterSubMenu.addChild(new dijit.MenuItem({label:jsm08+dateTimeText, onClick:function(){setUserFilter(9);}}));

        // add new menu
        newSubMenu = new dijit.PopupMenuItem({label:jsm14, popup:progPopupMenuItem, id:"progPopupMenuItem"});
        gridMenu.addChild(newSubMenu);


        progPopupMenuItem.addChild(new dijit.MenuSeparator());
        progPopupMenuItem.addChild(mcFilterSubMenu);
      
        progPopupMenuItem.addChild(new dijit.MenuSeparator());
        var xloggerFilterSubMenu = new dijit.PopupMenuItem({label:jsm04, popup:loggerFilterSubMenu1});
        progPopupMenuItem.addChild(xloggerFilterSubMenu);            
        var yloggerFilterSubMenu = new dijit.PopupMenuItem({label:jsm05, popup:loggerFilterSubMenu2});
        progPopupMenuItem.addChild(yloggerFilterSubMenu);
        progPopupMenuItem.addChild(new dijit.MenuSeparator());
        var dateTimeFilterMenu = new dijit.PopupMenuItem({label:jsm13, popup:dateTimeFilterSubMenu});
        progPopupMenuItem.addChild(dateTimeFilterMenu);
        progPopupMenuItem.startup();

        
        //        cellNode = e.cellNode;
    };

	/*
	 * Add On Load functions
	 */
    dojo.addOnLoad(
	        function () {
				 
				//Check for bidirectional transfer, set specific css class for some elements
	 
				if (getBidiTextDir()==="RTL");
				{
					
					var cssId = "com.ibm.ws.console.probdetermination/wasiscblue/Menu_rtl.css";  
					if (!dijit.byId(cssId))
						{
							var mindiv  = dojo.byId('minleveltd');
							var maxdiv  = dojo.byId('maxleveltd');
			
							var link  = dojo.doc.createElement('link');
			
							link.id = 'Menu_rtl';
							link.rel  = 'stylesheet';
							link.type = 'text/css';
							link.href = cssId;
			
							mindiv.appendChild(link);
							maxdiv.appendChild(link);
			
						}
				}
			
	        	errorImage = new Image();
	        	errorImage.src = '/ibm/console/images/Error.gif';
	        	warningImage = new Image();
	        	warningImage.src = '/ibm/console/images/Warning.gif';

	    	    var xhrArgs = {
	    		        url: "/ibm/console/logViewerFilterServlet",
	    		        form: dojo.byId('PreferenceForm'),
	    	            handleAs: "json", // return value will be a json
	    	            sync:true,
	    		        
	    		        load: function(data){
	    	            	// handle the invalid session scenarion
	    		            if (data.error === "invalid_session") {
	    		                // send it somewhere else
	    		                dijit.byId("invalidSession").show();
	    		                // top.location = location.protocol + "//" + location.host +
	    		                // "/ibm/console/";
	    		                return;
	    		                
	    		            }
	    		            
	    		        },
	    		        error: function(error){
	    		            var dlg = dijit.byId('errorDialog');
	    		            dlg.clearAll();
	    		            dlg.addError(nlsArray.ras_logviewer_filterError, dojo.toJson(error, true));
	    		            dlg.show();
	    		            console.error("Error during filter", dojo.toJson(error, true));
	    		        }
	    		    };
	    		    
	    		    // send it to the server
	    		    var deferred = dojo.xhrPost(xhrArgs);

	    		    xhrArgs = {
	    			        url: "/ibm/console/logViewerFilterServlet",
	    			        content: {
	    			            threadid: dojo.toJson(new Array("*"))
	    			        },
	    			        sync:true,
	    		            handleAs: "json", // return value will be a json
	    			        load: function(data){
	    			            // if return value from server had "error" set to "invalid_session"
	    			            // show invalid session dialog and return back to login page
	    			            if (data.error === "invalid_session") {
	    			                // send it somewhere elseformName
	    			                
	    			                // top.location = location.protocol + "//" + location.host +
	    			                // "/ibm/console/";
	    			                dijit.byId("invalidSession").show();
	    			                return;
	    			                
	    			            }
	    			            
	    			        },
	    			        error: function(error){
	    			            // something went wrong with post
	    			            // hide the busy indicator
	    			
	    			            var dlg = dijit.byId('errorDialog');
	    			            dlg.clearAll();
	    			            dlg.addError(nlsArray.ras_logviewer_filterError,  dojo.toJson(error, true));
	    			            dlg.show();
	    			            console.error("Error during filter", dojo.toJson(error, true));
	    			        }
	    			    };
	    			    // post this asynchronously to server
	    			    deferred = dojo.xhrPost(xhrArgs);
	    			    // show busy icon after post
	    			    appInstallWaitShowProbDeter();

	    			    //var headMenu = new dijit.Menu({
	    		        //    id:'gridHeaderMenu',
	    		        //    jsid:'gridHeaderMenu'
	    		        //});
	    			   //headMenu.addChild(new dojox.widget.PlaceholderMenuItem({
	    				//   label:"GridColumns"
	    			   //}));
	    			   
	        	// create a new grid:
				var lrstore = new probdeter.ItemFileReadStore({url:'/ibm/console/logViewerServlet', urlPreventCache:true});

				var mainGrid = new probdeter.DataGrid({
					id:'grid',
					jsId:'grid',
					store:lrstore,
					columnReordering: true,
					structure:layout,
					//headerMenu:headMenu,
					columnToggling:"true",
					autoHeight: true   // Disable scrollbar
	            },
	            document.createElement('div'));

	            // append the new grid to the div "gridContainer4":
	            dojo.byId("gridNode").appendChild(mainGrid.domNode);

	            // Call startup, in order to render the grid:
	            mainGrid.startup();
	            //headMenu.startup();
	            
				// Call these onload functions here after grid rendering since they are not getting called.
				bidiOnLoad();
				ariaOnLoadTop();
				
	            //--
	        	// create a new grid:
//				var hrstore = new probdeter.QueryReadStore({url:'/ibm/console/logHeaderServlet', requestMethod: 'post'});
//
//				var headerGrid = new probdeter.DataGrid({
//					id:'headerGrid',
//					jsId:'headerGrid',
//					store:hrstore,
//					structure:headerLayout,
//					columnToggling:"false"
//	            },
//	            document.createElement('div'));
//
//	            // append the new grid to the div "gridContainer4":
//	            dojo.byId("headerGridNode").appendChild(headerGrid.domNode);
//
//	            // Call startup, in order to render the grid:
//	            headerGrid.startup();
	            //--

	        	
	            dojo.connect(window, "resize", mainGrid, "resize");           
	    		handle = dojo.connect(dojo.isMozilla?dojo.byId('grid'):grid.domNode, 'onkeypress', function(evt){
	            	switch(evt.charOrCode){
	            		case dojo.keys.copyKey && 'c':
	            			copyToCB();
	            			dojo.stopEvent(evt);
	            			break;
	            		case dojo.keys.copyKey && 'r':
	            			refreshView();
	            			dojo.stopEvent(evt);
	            			break;
	            		case dojo.keys.copyKey && 't':
	            			viewSelectedThreadOnly();
	            			dojo.stopEvent(evt);
	            			break;
	            		case dojo.keys.copyKey && dojo.keys.ALT && 'c':
	            			showChooseColumnDialog();
	            			dojo.stopEvent(evt);
	            			break;
	            		case dojo.keys.copyKey && dojo.keys.ALT && 'h':
	            			showHeaderGrid();
	            			dojo.stopEvent(evt);
	            			break;
	            		case dojo.keys.copyKey && 's':
	            			dijit.byId('selectExportFormat').show();
	            			dojo.stopEvent(evt);
	            			break;
	            		default:
	            			break;
	            	}
	            });      
	            
	         // cell tooltip
	            dojo.connect(mainGrid, "onCellMouseOver", showTooltip);
	            dojo.connect(mainGrid, "onCellMouseOut", hideTooltip);
	            dojo.connect(mainGrid, "onCellFocus", showTooltip);
	            dojo.connect(mainGrid, "onBlur", showTooltip);
	            // header cell tooltip
	            //dojo.connect(grid, "onHeaderCellMouseOver", showTooltip);
	            //dojo.connect(grid, "onHeaderCellMouseOut", hideTooltip);
	            	
			    // grid menu
 			   var gridMenu = new dijit.Menu({
		            id:'gridMenu',
		            jsid:'gridMenu'
		        });
  			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:refreshView,
				   label:buttonRefreshView
			   }));
 			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:viewSelectedThreadOnly,
				   label:buttonShowSelThread
			   }));
  			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:showAllThread,
				   label:buttonShowAllThread
			   }));
			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:showChooseColumnDialog,
				   label:buttonSelCol
			   }));
  			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:function(){dijit.byId('selectExportFormat').show();},
				   label:buttonExport
			   }));
			  gridMenu.addChild(new dijit.MenuItem({
				   onClick:copyToCB,
				   label:buttonCPTOC
			   }));

			  
			  gridMenu.addChild(new dijit.MenuSeparator());
			  
			  gridMenu.startup();
			   

			    window["gridMenu"] = gridMenu;
			    gridMenu.bindDomNode(mainGrid.domNode);
			    // prevent grid methods from killing the context menu event by implementing our own handler
			    
			    /*
			     * cellNode is recorded, use it for the menu
			     */
			    mainGrid.onCellContextMenu = addContextMenu;	
//			    grid.onHeaderContextMenu = headerContextMenu;
//			    grid.onHeaderContextMenu = function(e) {
//			        cellNode = e.cellNode;
//			    };
			    

			    treeStore = createServerStartupTree();

			    treeStore.fetch({
					onComplete: function(data,response) {
			    	
				    	/*
				    	 * iterate over all data, if there is a starttime,  then find the largest,  select that entry
				    	 */
					    var startTimeArray = new Array();
	
				    	dojo.forEach(data, function(e){
				    			if (e.starttime) {
				    				var st = e.starttime[0];
				    				if(st.indexOf("/")==-1) {
				    					startTimeArray.push(st);
				    				}
				    			}
				    		}
				    	);
				    	
				    	startTimeArray.sort();
				    	
				    	/*
				    	 * last element is the biggest, select that
				    	 */
				    	
				    	var selN = startTimeArray.pop();
				    	
				    	currentInstanceSelection = selN;
				    							
						
						
					},
					onError: function(error,response) {
						console.log("Error:  failed to featch new data, with error message = " + error);
				        var dlg = dijit.byId('errorDialog');
				        dlg.clearAll();
				        dlg.addError("Error:  failed to featch new data, with error message = ", error);
				        dlg.show();
				        return;
					}
				});


	        }
	);

	/*
	 * expand the preference section
	 */
	function showHidePreferencesCall(objectId) {
        showHidePreferences(objectId, showPref,hidePref);
    }
