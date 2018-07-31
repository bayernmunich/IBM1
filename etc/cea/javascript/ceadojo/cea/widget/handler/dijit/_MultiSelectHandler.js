/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.dijit._MultiSelectHandler"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.dijit._MultiSelectHandler"] = true;
dojo.provide ("cea.widget.handler.dijit._MultiSelectHandler");

dojo.require ("cea.widget.handler.WidgetHandler");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.dijit._MultiSelectHandler",
     [ cea.widget.handler.WidgetHandler ], {
     //
     //   summary:
     //        A class that defines a widget handler for the Dijit multi select
     //        widget.
     //
     //   description:
     //        This class defines a widget handler for the Dijit multi select
     //        widget.
     //
     
     _onChangeHandler: null,

     // summary: creates a _MultiSelectHandler instance.

     constructor: function(widget,id,attributes,validatorWidget,twoWayForm) {
     },

     receiveChangeEvent: function(changeEvent) {
          this.inherited (arguments);

          this.widget.set ("value", changeEvent.value.split (","));
     },

     registerEventHandlers: function() {
          this._onChangeHandler = dojo.connect (this.widget, "onChange",
               dojo.hitch (this, "_handleOnChange"));
     },

     unregisterEventHandlers: function() {
          dojo.disconnect (this._onChangeHandler);
     },

     // summary: handles an "onChange" event for this widget associated with
     // this widget handler.

     _handleOnChange: function(evt) {
          // Send out the new value of the widget.

    	   this.sendChangeEvent ("{\"value\":\"" + evt + "\"}");  

          // Remove any existing notification.

          this.removeNotification();
     }
});

}
