/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.dijit._ToggleHandler"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.dijit._ToggleHandler"] = true;
dojo.provide ("cea.widget.handler.dijit._ToggleHandler");

dojo.require ("cea.widget.handler.WidgetHandler");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.dijit._ToggleHandler",
     [ cea.widget.handler.WidgetHandler ], {
     //
     //   summary:
     //        A class that defines a widget handler for the Dijit checkbox and
     //        radio button widgets.
     //
     //   description:
     //        This class defines a widget handler for the Dijit checkbox and
     //        radio button widgets.
     //
     
     _labelNode: null,
     _onClickHandler: null,
     
     // summary: creates a _ToggleHandler instance.

     constructor: function(widget,id,attributes,validatorWidget,twoWayForm) {
          var siblingNode = widget.domNode.nextSibling;

          // Try to find the label node for the checkbox widget associated with
          // this widget handler.  Search the sibling nodes until a label
          // element is found with the widget's ID.

          while (siblingNode) {
               if (siblingNode.tagName && (siblingNode.tagName.toLowerCase() == "label")) {
                    if (siblingNode.htmlFor && (siblingNode.htmlFor == id)) {
                         this._labelNode = siblingNode;

                         return;
                    }
               }

               siblingNode = siblingNode.nextSibling;
          }
     },

     receiveChangeEvent: function(changeEvent) {
          this.inherited (arguments);

          if (changeEvent.value == "false") {
               this.widget.set ("checked", false);
          }

          else {
               this.widget.set ("checked", true);
          }
     },

     registerEventHandlers: function() {
          this._onClickHandler = dojo.connect (this.widget, "onClick", dojo.hitch (this, "_handleOnClick"));
     },

     unregisterEventHandlers: function() {
          dojo.disconnect (this._onClickHandler);
     },

     _defaultRemoveNotification: function() {
          // If there's a label for the widget associated with this widget
          // handler, try to remove the default notification style from it.

          if (this._labelNode) {
               dojo.removeClass (this._labelNode, "ceaCollabWidgetValueChanged");
          }

          else {
               // Otherwise, add the notification style to the widget itself.

               this.inherited (arguments);
          }
     },

     _defaultShowNotification: function() {
          // If there's a label for the widget associated with this widget
          // handler, try to add the default notification style to it.

          if (this._labelNode) {
               dojo.addClass (this._labelNode, "ceaCollabWidgetValueChanged");
          }

          else {
               // Otherwise, add the notification style to the widget itself.

               this.inherited (arguments);
          }
     },

     // summary: handles an "onClick" event for this widget associated with
     // this widget handler.

     _handleOnClick: function(evt) {
          // Send out the new value of the widget.
          
    	 this.sendChangeEvent ("{\"value\":\"" + this.widget.get ("checked") + "\"}");
     }
});

}
