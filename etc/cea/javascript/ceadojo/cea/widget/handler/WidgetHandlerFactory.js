/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.handler.WidgetHandlerFactory"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.handler.WidgetHandlerFactory"] = true;
dojo.provide ("cea.widget.handler.WidgetHandlerFactory");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.handler.WidgetHandlerFactory", null, {
     //
     //   summary:
     //        An abstract class for creating widget handlers.
     //
     //   description:
     //        This class is used to define a factory for creating widget
     //        handlers for a specific widget library.  This class must be
     //        subclassed to handle new widget libraries.
     //

     // summary: creates a WidgetHandlerFactory instance.

     constructor: function() {
     },

     // summary: creates a widget handler for a particular widget.

     createWidgetHandler: function(widget,id,attributes,validatorWidget,twoWayForm) {
          return undefined;
     },

     // summary: given an element ID, this method attempts to find a widget
     // instance.  This method must return undefined if the element is not of a
     // type understood by the widget library associated with this widget
     // handler factory.

     findWidget: function(id) {
          return undefined;
     }
});

}
