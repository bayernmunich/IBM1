/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.validation._ValidationManager"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.validation._ValidationManager"] = true;
dojo.provide ("cea.widget.validation._ValidationManager");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.validation._ValidationManager", null, {
     //
     //   summary:
     //        A class used to manage validation events for all the widgets on
     //        a two-way form.
     //
     //   description:
     //        This class provides the functionality needed to manage
     //        validation events for all the widgets on a two-way form.  A
     //        validation event occurs when one of the users accepts or
     //        declines a widget value entered by the other party.
     //

     _twoWayForm: null,
     _validationStatus: { },

     // summary: creates a _ValidationManager instance.

     constructor: function(twoWayForm) {
          this._twoWayForm = twoWayForm;
     },

     // summary: called to indicate that the value for a particular widget was
     // accepted.

     accept: function(id,sendStatus) {
          console.log ("value for widget with ID \"" + id + "\" was accepted");

          this._setValidationStatus (id, true);

          if (sendStatus) {
               // Status should be synched with the validation manager on the
               // other side.

               this._sendValidationStatus (id, true);
          }

          else {
               // Need to show the status widget to indicate what value was
               // received.

               this._updateValidationStatus (id, true);
          }
     },

     // summary: called to indicate that the value for a particular widget was
     // declined.

     decline: function(id,sendStatus) {
          console.log ("value for widget with ID \"" + id + "\" was declined");

          this._setValidationStatus (id, false);

          if (sendStatus) {
               // Status should be synched with the validation manager on the
               // other side.

               this._sendValidationStatus (id, false);
          }

          else {
               // Need to show the status widget to indicate what value was
               // received.

               this._updateValidationStatus (id, false);
          }
     },

     // summary: retrieves an array of widgets that have yet to be validated.

     _getNonValidatedWidgets: function() {
          var result = [ ];

          for (var key in this._validationStatus) {
               if (!this._validationStatus[key]) {
                    result.push (key);
               }
          }

          return result;
     },

     // summary: used to indicate that validation is required for a particular
     // widget.

     _requireValidationForWidget: function(id) {
          this._validationStatus[id] = false;
     },

     // summary: used to send validation status changes to the collaboration
     // session.

     _sendValidationStatus: function(id,state) {
          this._twoWayForm._sendData ("{\"collaborationData\":{\"validationStatusEvent\":{\"id\":\"" + id + "\",\"state\":\"" + state + "\"}}}");
     },

     // summary: used to serialize the validation manager status for later
     // synching.

     _serializeStatus: function() {
          var result = "{";

          for (var id in this._validationStatus) {
               result += id + ":";

               if (this._validationStatus[id]) {
                    result += "\"true\"";
               }

               else {
                    result += "\"false\"";
               }

               result += ",";
          }

          if (result.charAt (result.length - 1) == ',') {
               result = result.substr (0, result.length - 1);
          }

          result += "}";

          return result;
     },

     // summary: used to toggle validation for a particular widget on or off.

     _setValidationStatus: function(id,state) {
          this._validationStatus[id] = state;
     },

     // summary: updates the validation status for a particular widget.

     _updateValidationStatus: function(id,value) {
          var handler = this._twoWayForm._widgetHandlers[id];

          if (handler) {
               var validatorWidget = handler._validatorWidget;

               if (validatorWidget) {
                    validatorWidget.showStatus (value);
               }
          }
     }
});

}
