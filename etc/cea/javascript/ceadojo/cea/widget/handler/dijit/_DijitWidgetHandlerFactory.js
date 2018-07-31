/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.dijit._DijitWidgetHandlerFactory"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.dijit._DijitWidgetHandlerFactory"] = true;
dojo.provide ("cea.widget.handler.dijit._DijitWidgetHandlerFactory");

dojo.require ("dijit.form.CheckBox");
dojo.require ("dijit.form.ComboBox");
dojo.require ("dijit.form.FilteringSelect");
dojo.require ("dijit.form.MultiSelect");
dojo.require ("dijit.form.HorizontalSlider");
dojo.require ("dijit.form.VerticalSlider");
dojo.require ("dijit.form.Textarea");
dojo.require ("dijit.form.TextBox");
dojo.require ("cea.widget.handler.WidgetHandlerFactory");
dojo.require ("cea.widget.handler.dijit._DateTimeTextBoxHandler");
dojo.require ("cea.widget.handler.dijit._MultiSelectHandler");
dojo.require ("cea.widget.handler.dijit._SimpleValueHandler");
dojo.require ("cea.widget.handler.dijit._ToggleHandler");

/*
	(C) COPYRIGHT International Business Machines Corp. 2009, 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.dijit._DijitWidgetHandlerFactory",
     [ cea.widget.handler.WidgetHandlerFactory ], {
     //
     //   summary:
     //        A class that creates widget handlers for the Dijit widget
     //        library.
     //   
     //   description:
     //        This class defines a widget handler factory that is capable of
     //        creating widget handlers for the Dijit widget library.
     //

     // summary: creates a _DijitWidgetHandlerFactory instance.

     constructor: function() {
     },

     createWidgetHandler: function(widget,id,attributes,validatorWidget,twoWayForm) {
          var handler = undefined;

          //DateTimeTextBox widgets
          if (widget instanceof dijit.form.DateTextBox || 
        	  widget instanceof dijit.form.TimeTextBox  ) {
              handler = new cea.widget.handler.dijit._DateTimeTextBoxHandler(widget, id, attributes, validatorWidget, twoWayForm);
          }
          
          // Widgets with simple values.
          else if ((widget instanceof dijit.form.ComboBox) ||
               (widget instanceof dijit.form.HorizontalSlider) ||
               (widget instanceof dijit.form.FilteringSelect) ||
               // dijit.form.NumberSpinner extends TextBox, so it's covered.
               (widget instanceof dijit.form.Textarea) ||
               (widget instanceof dijit.form.TextBox) ||
               (widget instanceof dijit.form.VerticalSlider)) {
               handler = new cea.widget.handler.dijit._SimpleValueHandler(widget, id, attributes, validatorWidget, twoWayForm);
          }

          //Toggle button widgets.
          else if (widget instanceof dijit.form.ToggleButton) {
       	   //dijit.form.Checkbox extends ToggleButton, so it's covered.
       	   //dijit.form.RadioButton extends ToggleButton, so it's covered.
        	  handler = new cea.widget.handler.dijit._ToggleHandler (widget, id, attributes, validatorWidget, twoWayForm);
         }

          // Multi select widget.
          else if (widget instanceof dijit.form.MultiSelect) {
               handler = new cea.widget.handler.dijit._MultiSelectHandler(widget, id, attributes, validatorWidget, twoWayForm);
          }
          
          return handler;
     },

     findWidget: function(id) {
          return dijit.byId (id);
     }
});

}
