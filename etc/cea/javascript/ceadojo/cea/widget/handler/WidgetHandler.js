/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.WidgetHandler"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.WidgetHandler"] = true;
dojo.provide ("cea.widget.handler.WidgetHandler");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.WidgetHandler", null, {
     //
     //   summary:
     //        An abstract class for sending and receiving widget change events
     //        via a two-way form.
     //
     //   description:
     //        This class provides the basic functionality required to handle
     //        sending and receiving change events for a widget.  This class
     //        must be subclassed to handle new widget types.
     //

     //   attributes: array
     //        The attributes prefixed with "ceaCollab" that are present on the
     //        widget associated with this widget handler.  These are used to
     //        provide special context to the widget.
     attributes: { },
     //   id: String
     //        The id of the widget associated with this widget handler.
     id: "",
     //   widget: Object
     //        The widget associated with this widget handler.
     widget: null,

     _twoWayForm: null,
     _validatorWidget: null,

     // summary: creates a WidgetHandler instance.

     constructor: function(widget,id,attributes,validatorWidget,twoWayForm) {
          this.attributes = attributes;
          this.id = id;
          this.widget = widget;
          this._twoWayForm = twoWayForm;
          this._validatorWidget = validatorWidget;

          if (this._validatorWidget) {
               // Make sure the validation manager is aware that the widget
               // associated with this widget handler must be validated.

               this._validatorWidget._validationManager._requireValidationForWidget
                    (this.id);
          }
     },

     // summary: called whenever a filtered value for the widget associated
     // with this widget handler is received.

     getFilteredValue: function(value) {
          var filter = this.attributes.ceacollabfilter;
          var result = value;

          // If the "ceaCollabFilter" attribute is set, evaluate the given
          // method if it is not called "default".

          if (filter) {
               if (filter.toLowerCase() == "default") {
                    result = this._defaultFilter (value);
               }

               else {
                    result = this._callMethod (filter, value);
               }
          }

          return result;
     },

     // summary: called whenever a change event for the widget associated with
     // this widget handler is received.

     receiveChangeEvent: function(changeEvent) {
          // Remove any existing notifications.

          this.removeNotification();

          if (this._validatorWidget) {
               // If validation is enabled for this widget, prompt the user
               // with the validation widget.

               this._validatorWidget.show();
          }
     },

     // summary: registers all applicable event handlers with the widget
     // associated with this widget handler.

     registerEventHandlers: function() {
     },

     // summary: removes any notifications for the widget associated with this
     // widget handler.

     removeNotification: function() {
          var handler = this.attributes.ceacollabhandleremovenotification;

          // If the "ceaCollabHandleRemoveNotification" attribute is set,
          // evaluate its contents instead of doing the default behavior.

          if (handler) {
               this._callMethod (handler, this.widget);
          }

          else {
               this._defaultRemoveNotification();
          }
     },

     // summary: sends a change event for the widget associated with this
     // widget handler.  This method should not be overridden.

     sendChangeEvent: function(changeEvent) {
          this._twoWayForm._sendData ("{\"collaborationData\":{\"widgetChangeEvent\":{\"id\":\"" + this.id + "\",\"changeEvent\":" + changeEvent + "}}}");

          // The widget's value has changed, so the validation manager needs to
          // be made aware.

          if (this._validatorWidget) {
               this._validatorWidget._validationManager._setValidationStatus
                    (this.id, false);

               // There's a possibility that the validation status widget is
               // showing, and if new data has been sent out, clearly the status
               // isn't valid anymore, so hide the widget.

               this._validatorWidget.hideStatus();
          }
     },

     // summary: displays a notification for the widget associated with this
     // widget handler.

     showNotification: function() {
          // If the "ceaCollabHandleShowNotification" attribute is set,
          // evaluate its contents instead of doing the default behavior.

          if (this.attributes.ceacollabhandleshownotification) {
               var handler = this.attributes.ceacollabhandleshownotification;

               this._callMethod (handler, this.widget);
          }

          else {
               this._defaultShowNotification();
          }
     },

     // summary: unregisters all applicable event handlers with the widget
     // associated with this widget handler.

     unregisterEventHandlers: function() {
     },

     // summary: invokes a global method.

     _callMethod: function(name,arg) {
          if (!dojo.global[name]) {
               console.log ("unable to invoke method with name \"" + name +
                    "\"");

               return;
          }

          return dojo.global[name].apply (dojo.global, [ arg ]);
     },

     // summary: performs the default value filtering action.

     _defaultFilter: function(value) {
          var result = "";

          if (typeof (value) != "string") {
               // The value is not a string, so the value can't be filtered.

               return value;
          }

          // Simply create a string of "*" characters with the same length as
          // the original value.

          for (var i = 0; i < value.length; ++i) {
               result += "*";
          }

          return result;
     },

     // summary: performs the default action to remove a notification.

     _defaultRemoveNotification: function() {
          dojo.removeClass (this.widget.domNode,
               "ceaCollabWidgetValueChanged");
     },

     // summary: performs the default action to show a notification.

     _defaultShowNotification: function() {
          dojo.addClass (this.widget.domNode, "ceaCollabWidgetValueChanged");
     }
});

}
