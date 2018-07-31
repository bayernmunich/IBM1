/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.dijit._DateTimeTextBoxHandler"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.dijit._DateTimeTextBoxHandler"] = true;
dojo.provide ("cea.widget.handler.dijit._DateTimeTextBoxHandler");

dojo.require ("cea.widget.handler.WidgetHandler");

/*
	(C) COPYRIGHT International Business Machines Corp., 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.dijit._DateTimeTextBoxHandler", [ cea.widget.handler.WidgetHandler ], {
     	//
     	//   summary:
     	//        A class that defines a widget handler for Dijit DateTextBox widgets.
     	//
     	//   description:
     	//        This class defines a widget handler for Dijit  DateTextBox widgets.
     	//
     
     	_changedByUser: true,
     	_onChangeHandler: null,

     	// summary: creates a _DateTextBoxHandler instance.
     	constructor: function(widget,id,attributes,validatorWidget,twoWayForm) {
     	},

     	receiveChangeEvent: function(changeEvent) {
     		// Indicate that this value was not changed by the user since the
     		// onChange handler will be invoked by the following "set" call.
     		this._changedByUser = false;

     		isoDate = dojo.date.stamp.fromISOString(changeEvent.value);
         
     		this.widget.set("value", isoDate);
         
     		if (changeEvent.filteredValue) {
     			// The widget value is supposed to be filtered, so set the
     			// display value to be the filtered value.
     			this.widget.set ("displayedValue", changeEvent.filteredValue);
     		}
     	},

     	registerEventHandlers: function() {
     		this._onChangeHandler = dojo.connect (this.widget, "onChange", dojo.hitch (this, "_handleOnChange"));
     	},

     	unregisterEventHandlers: function() {
     		dojo.disconnect (this._onChangeHandler);
     	},

     	// summary: handles an "onChange" event for the widget associated with this widget handler.
     	_handleOnChange: function(evt) {
     		// Only send out the widget's value if the user changed it.
    	 
     		if (this._changedByUser) {
     			//convert the date to the standard isoDate format to send it to the peer
     			isoDate = dojo.date.stamp.toISOString(evt); 
        	  
     			var filteredValue = this.getFilteredValue (isoDate);
     			var changeEvent = "{\"value\":\"" + isoDate +"\"";

     			if (filteredValue != isoDate) {
     				// Filtering is enabled for this value, so send out the filtered value accordingly.
     				changeEvent += ",\"filteredValue\":\"" + filteredValue + "\"";
     			}

     			this.sendChangeEvent (changeEvent + "}");

     			// Remove any existing notifications.
     			this.removeNotification();
     		}

     		else {
     			if (this._validatorWidget) {
     				// If validation is enabled for this widget, prompt the user with the validation widget.
     				this._validatorWidget.show();
     			}
     		}
     	}
});

}
