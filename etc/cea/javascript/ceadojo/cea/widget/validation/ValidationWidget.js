/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.validation.ValidationWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.validation.ValidationWidget"] = true;
dojo.provide ("cea.widget.validation.ValidationWidget");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.validation.ValidationWidget", null, {
     //
     //   summary:
     //        An abstract class for displaying a widget that receives input
     //        field validation from the user in a two-way form.
     //
     //   description:
     //        This class provides the basic functionality required to display
     //        a validation widget when a two-way form requires the user to
     //        validate information entered by another party.
     //

     //   id: String
     //        The id of the widget associated with this validation widget.
     id: "",
     //   widget: Object
     //        The widget being validated.
     widget: null,

     _statusWidget: null,
     _validationManager: null,
     _validationWidget: null,

     // summary: creates a ValidationWidget instance.

     constructor: function(widget,id,validationManager) {
          this.id = id;
          this.widget = widget;

          this._validationManager = validationManager;
          
          this.create();

          this.registerEventHandlers();
     },

     // summary: called to create a new instance of the validation widget.  All
     // implementing classes must override this method.  Note: it is assumed
     // that the widget for which validation is being performed contains
     // positioning information suitable for positioning this validation
     // widget.
     //
     // This method should set this._validationWidget to the actual validation
     // widget and this._statusWidget to the widget that reports the validation
     // status.

     create: function() {
     },

     // summary: default handler for the "accept" event.  If this method is
     // overridden, this method should always be called in addition to any
     // processing.

     handleAccept: function(evt) {
          // By default, simply alert the validation manager that "accept" was
          // clicked and hide the validation widget.

          this._validationManager.accept (this.id, true);

          this.hide();
     },

     // summary: default handler for the "decline" event.  If this method is
     // overridden, this method should always be called in addition to any
     // processing.

     handleDecline: function(evt) {
          // By default, simply alert the validation manager that "decline" was
          // clicked and hide the validation widget.

          this._validationManager.decline (this.id, true);

          this.hide();
     },

     // summary: hides the validation widget.  This method assumes the created
     // validation widget is a simple DOM node.  If not, this method must be
     // overridden.

     hide: function() {
          dojo.style (this._validationWidget, "display", "none");

          dojo.fadeOut ({ node: this._validationWidget,
               duration: 1000 }).play();
     },
     
     // summary: hides the status widget.  This method assumes the created
     // validation widget is a simple DOM node.  If not, this method must be
     // overridden.

     hideStatus: function() {
          dojo.style (this._statusWidget, "display", "none");

          dojo.fadeOut ({ node: this._statusWidget, duration: 1000 }).play();
     },

     // summary: registers event handlers associated with the validation
     // widget.  Implementors should attach events for "accept" and "decline"
     // buttons on the validation widget.

     registerEventHandlers: function() {
     },

     // summary: shows the validation widget.  This method assumes the created
     // validation widget is a simple DOM node.  If not, this method must be
     // overridden.

     show: function() {
          this.hideStatus();

          dojo.style (this._validationWidget, "display", "inline");

          dojo.fadeIn ({ node: this._validationWidget,
               duration: 1000 }).play();

          // Make sure the validation manager knows that the value has to be
          // validated again.

          this._validationManager._setValidationStatus (this.id, false);
     },

     // summary: shows the status widget.  This method assumes the created
     // status widget is a simple DOM node.  If not, this method must be
     // overridden.

     showStatus: function(value) {
          var newClass = "ceaCollabStatusNo";

          this.hide();

          dojo.style (this._statusWidget, "display", "inline");

          if (value) {
               newClass = "ceaCollabStatusYes";
          }

          dojo.attr (this._statusWidget, { "class" : newClass });

          dojo.fadeIn ({ node: this._statusWidget, duration: 1000 }).play();
     },

     // summary: unregisters event handlers associated with the validation
     // widget.

     unregisterEventHandlers: function() {
     }
});

}
