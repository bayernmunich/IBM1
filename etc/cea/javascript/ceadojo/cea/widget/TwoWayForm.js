/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.TwoWayForm"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.TwoWayForm"] = true;
dojo.provide ("cea.widget.TwoWayForm");

dojo.require ("dijit.form.Form");
dojo.require ("dijit.form.TextBox");
dojo.require ("cea.widget.CollaborationDataTransfer");
dojo.require ("cea.widget.handler.dijit._DijitWidgetHandlerFactory");
dojo.require ("cea.widget.validation._DefaultValidationWidget");
dojo.require ("cea.widget.validation._ValidationManager");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.TwoWayForm", [dijit.form.Form], {
     //
     //   summary:
     //        A widget for enabling two-way input on a form.
     //
     //   description:
     //        This widget provides the ability for two users to collaborate on
     //        a form.  That is, either of the connected users can provide
     //        input for the fields in a form.  Optionally, fields can be
     //        designated as only editable by one of the connected users or
     //        require validation by either of the connected users.
     //
     //        Note: this widget can only be used on pages that are accessed
     //        via the cea.widget.Cobrowse widget.
     //
     //   example:
     //   |    <form dojoType="cea.widget.TwoWayForm" ...>
     //

     _ceaAttributes: { },
     _elements: [ ],
     _isWriter: false,
     _handleDataHandler: null,
     _oldWidgetHandler: null,
     _unloadHandler: null,
     _validationManager: null,
     _widgetHandlerFactories: [ ],
     _widgetHandlers: { },

     // summary: handles form submission by checking for any invalid widget values.
     onSubmit: function(evt) {
          var widgets = this._validationManager._getNonValidatedWidgets();

          if (widgets.length > 0) {
               var response = "The following widget(s) must be validated " +
                    "by the reader before the form can be submitted: ";

               for (var i = 0; i < widgets.length; ++i) {
                    var widgetName = widgets[i];

                    if (this._ceaAttributes[widgetName].ceacollabname) {
                    	widgetName = this._ceaAttributes[widgetName].ceacollabname;
                    }

                    response += "\"" + widgetName + "\"";

                    if (i < (widgets.length - 1)) {
                         response += ", ";
                    }
               }

               alert (response);

               return false;
          }

          // If the "ceaCollabOnSubmit" attribute is set, evaluate the given
          // value.  Otherwise, simply return true.
          if (this.domNode.attributes.ceacollabonsubmit) {
               return eval (this.domNode.attributes.ceacollabonsubmit);
          }

          return true;
     },

     // summary: performs post-create actions for this two-way form widget.
     postCreate: function() {
          var self = this;

          this.inherited (arguments);

          this._clearData();

          // Always add the default widget handler factory, which supports the Dijit widget library.
          this._widgetHandlerFactories.push(new cea.widget.handler.dijit._DijitWidgetHandlerFactory());

          // Add in user-defined widget handler factories.
          this._addWidgetHandlerFactories();

          // Begin finding the widgets associated with this two-way form.
          this._findWidgetNamesAndAttributes();

          // Create a validation manager for widgets that require validation.
          this._validationManager = new cea.widget.validation._ValidationManager (this);

          // Make this two-way form available to the collaboration dialog so it can pass read data to this form.
          window.top._ceaTwoWayForm = this;

          this._unloadHandler = dojo.connect (window, "onunload", this, "_handleUnload");
     },

     // summary: performs startup actions for this two-way form widget.
     startup: function() {
          if (window.top._ceaCollabDialog) {
               this._finishStartup(window.top._ceaCollabDialog._hasCollaborationControl);
          }
     },

     // summary: attempts to create all user-defined widget handler factories.
     _addWidgetHandlerFactories: function() {
          var factoryNames = this.domNode.attributes.ceacollabwidgethandlerfactories;

          if (factoryNames) {
               var factoryArray = this._parseConfigString (factoryNames);

               for (var i = 0; i < factoryArray.length; ++i) {
                    var factory = factoryArray[i];

                    if (factory) {
                         this._widgetHandlerFactories.push (eval ("new " + factory + "();"));
                    }
               }
          }
     },

     // summary: clears all instance variables.  Due to the way the collaboration dialog widget is written, 
     // this widget may be loaded more than once in the same page.
     _clearData: function() {
          this._ceaAttributes = { };
          this._elements = [ ];
          this._isWriter = false;
          this._widgetHandlerFactories = [ ];
          this._widgetHandlers = { };
     },

     // summary: collects information related to a single widget contained in this two-way form.
     _collectWidgetInformation: function(widget,elem,handlerFactory) {
          var writeEnabled = true;
          var handler = null;
          var validationWidget = null;

          console.log ("collecting information for widget with id \"" + elem.id + "\"");

          // See if the ceaCollabWriteAccess attribute is set on the widget;
          // its value will determine whether or not the widget is read-only.
          if (this._ceaAttributes[elem.id].ceacollabwriteaccess) {
               var writeAccess = this._parseConfigString(this._ceaAttributes[elem.id].ceacollabwriteaccess);

               if (!writeAccess["writer"] && this._isWriter) {
                    // Write access for the writer is disabled.
                    writeEnabled = false;
               }

               if (!writeAccess["reader"] && !this._isWriter) {
                    // Write access for the reader is disabled.
                    writeEnabled = false;
               }
          }

          // If write access is disabled, make the widget read-only.
          if (!writeEnabled) {
               console.log ("  marking widget read-only");

               widget.set ("readOnly", true);
          }

          if (this._ceaAttributes[elem.id].ceacollabvalidation) {
               var validationWidgetName = this._ceaAttributes[elem.id].ceacollabvalidation;

               // If the "ceaCollabValidation" attribute is set, use it to
               // create the validation widget if it is not set to "default".
               if (validationWidgetName.toLowerCase() == "default") {
                    console.log ("  creating default validator");
                    validationWidget = new cea.widget.validation._DefaultValidationWidget(widget, elem.id, this._validationManager);
               }

               else {
                    console.log ("  creating validator " + validationWidgetName);

                    // Evaluate the constructor for the defined validation widget.
                    validationWidget = eval ("new " + validationWidgetName + "(widget, elem.id, this._validationManager);");
               }

          }

          // Create a handler for the current widget. 
          handler = handlerFactory.createWidgetHandler (widget, elem.id, this._ceaAttributes[elem.id], validationWidget, this);

          // Add the handler for the current widget.  All widgets are readable, but not all are writeable.
          if (handler) {
               this._widgetHandlers[elem.id] = handler;

               // Register event handlers.
               handler.registerEventHandlers();

               console.log ("  created widget handler");
          }

          else {
               console.log ("  unable to create widget handler");
          }
     },

     // summary: determines the names and attributes of all the widgets associated with this two-way form.
     _findWidgetNamesAndAttributes: function() {
          var root = this.domNode;
          var self = this;

          // Since Dojo's templating will wipe out any CEA-specific attributes,
          // collect them now so they can be referenced later.

          dojo.query ("*", root).forEach (function(elem) {
               var attributes = { };

               if (elem.id && (elem.id != "")) {
                    self._elements.push (elem);

                    for (var i = 0; i < elem.attributes.length; ++i) {
                         var attr = elem.attributes[i];
                         // IE doesn't return attribute names in all lowercase like the other browsers
                         if (attr.name.toLowerCase().indexOf ("ceacollab") == 0) {
                              attributes[attr.name.toLowerCase()] = attr.value;
                         }
                    }

                    self._ceaAttributes[elem.id] = attributes;
               }
          });
     },

     // summary: handles incoming data from the collaboration session.
     _handleData: function(event) {
    	  if ( event.type == 0 ){
 			   var eventData = event.data;

               if (eventData.validationStatusEvent) {
                    this._handleValidationStatusEvent(eventData.validationStatusEvent);
               }

               if (eventData.widgetChangeEvent) {
                    this._handleWidgetChangeEvent(eventData.widgetChangeEvent);
               }
          }
     },
                  
     // summary: performs final startup actions for this two-way form widget.
     _finishStartup: function(writerStatus) {
          // See if this widget is being used on the side of the "writer" who
          // initiated the collaboration or not.

          this._isWriter = writerStatus;

          console.log ("is this two-way form used by the writer? " + this._isWriter);

          this._initWidgets();

          // Show an icon and status message indicating that two-way form
          // editing is available.

          if (window.top._ceaCollabDialog) {
               window.top._ceaCollabDialog._toggleCoauthorStatus();

               // Also, add a data handler.
               this._handleDataHandler = dojo.hitch (this, "_handleData");

               window.top._ceaCollabDialog.addEventHandler(this._handleDataHandler);
          }
     },

     // summary: handles an unload of the page that contains this two-way form.
     _handleUnload: function() {
          // Remove any event handlers that were created.

          for (var curHandler in this._widgetHandlers) {
               this._widgetHandlers[curHandler].unregisterEventHandlers();
          }

          // Indicate that this is no longer a two-way form.

          if (window.top._ceaCollabDialog) {
               window.top._ceaCollabDialog._toggleCoauthorStatus();
          }

          // Remove the "onload" and "onunload" handlers for the window.
          dojo.disconnect (this._unloadHandler);

          // Remove the data handler.
          if (window.top._ceaCollabDialog) {
               window.top._ceaCollabDialog.removeEventHandler(this._handleDataHandler);
          }

          // Clear out instance data for good measure.
          this._clearData();

          // Destroy the two-way form widget and any child widgets.
          this.destroyRecursive();

          // Remove global variables.
          window.top._ceaTwoWayForm = null;
     },

     // summary: handles incoming validation status events from the collaboration session.
     _handleValidationStatusEvent: function(data) {
          console.log ("received validationStatusEvent for widget with id \"" +
               data.id + "\"");

          // Accept or decline the value of the widget based on the information provided.

          if (data.state == "true") {
               this._validationManager.accept (data.id, false);
          } else {
               this._validationManager.decline (data.id, false);
          }
     },

     // summary: handles incoming widget change events from the collaboration session.
     _handleWidgetChangeEvent: function(data) {
          var widgetHandler;

          console.log ("received widgetChangeEvent for widget with id \"" + data.id + "\"");

          // Find a widget handler for the widget and notify it of the received data.

          widgetHandler = this._widgetHandlers[data.id];

          if (!widgetHandler) {
               console.log ("  unable to find widget handler");
          }

          widgetHandler.receiveChangeEvent (data.changeEvent);

          // Also show a notification that the value changed.
          if (this._oldWidgetHandler) {
               this._oldWidgetHandler.removeNotification();
          }

          widgetHandler.showNotification();

          this._oldWidgetHandler = widgetHandler;
     },

     // summary: initializes the widgets contained in this two-way form.
     _initWidgets: function() {
          var root = this.domNode;

          // Using the previously-discovered widget names, attempt to create
          // widget handlers.

          for (var i = 0; i < this._elements.length; ++i) {
               var elem = this._elements[i];
               var widget = null;
               var widgetHandlerFactory = null;

               // Iterate over all the widget handler factories and try to
               // find one that can handle the current element.

               for (var j = 0; j < this._widgetHandlerFactories.length; ++j) {
                    widgetHandlerFactory = this._widgetHandlerFactories[j];
                    widget = widgetHandlerFactory.findWidget (elem.id);
               
                    if (widget) {
                         break;
                    }
               }

               if (widget) {
                    this._collectWidgetInformation (widget, elem, widgetHandlerFactory);
               }
          }
     },

     // summary: parses a config string (of form "a,b,c,...") into a map.
     _parseConfigString: function(str) {
          var result = { };
          var strArray = str.split (",");

          for (var curStr in strArray) {
               curStr = strArray[curStr].toLowerCase().replace(/^\s+|\s+$/g, '');

               result[curStr] = true;
          }

          return result;
     },

     // summary: sends data to the collaboration session.
     _sendData: function(data) {
          if (window.top._ceaCollabDialog) {
               window.top._ceaCollabDialog.sendDataEvent (data);
          }
     }
});

}
