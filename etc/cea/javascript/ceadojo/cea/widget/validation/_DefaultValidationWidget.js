/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.widget.validation._DefaultValidationWidget"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.widget.validation._DefaultValidationWidget"] = true;
dojo.provide ("cea.widget.validation._DefaultValidationWidget");

dojo.require ("cea.widget.validation.ValidationWidget");

/*
	(C) COPYRIGHT International Business Machines Corp., 2009
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare ("cea.widget.validation._DefaultValidationWidget",
     [ cea.widget.validation.ValidationWidget ], {
     //
     //   summary:
     //        A class that defines a default validation widget.
     //
     //   description:
     //        This class defines a default validation widget.
     //

     _acceptNode: null,
     _declineNode: null,
     _onClickAcceptHandler: null,
     _onClickDeclineHandler: null,

     // summary: creates a DefaultValidationWidget instance.

     constructor: function(widget,id,validationManager) {
     },

     create: function() {
          var outerNode = dojo.doc.createElement ("div");
          var statusNode = dojo.doc.createElement ("div");
          var widgetCoords = dojo.coords (this.widget.domNode);

          this._acceptNode = dojo.doc.createElement ("div");
          this._declineNode = dojo.doc.createElement ("div");

          dojo.attr (outerNode, { "class" : "ceaCollabValidatorOuter" });
          dojo.attr (statusNode, { "class" : "ceaCollabStatusNo" });

          // Fix the size and position of the validation widget relative to the
          // widget whose value is being validated.

          //Dojo style is no longer working for this scenario so have to set the left and top style directly
          //dojo.style (outerNode, "left", widgetCoords.x + widgetCoords.w + 10);
          //dojo.style (outerNode, "top", widgetCoords.y);
          //dojo.style (statusNode, "left", widgetCoords.x + widgetCoords.w + 10);
          //dojo.style (statusNode, "top", widgetCoords.y);

          //If the widget is followed by a label we will append this width when placing the validation divs
          var siblingNode = this.widget.domNode.nextSibling;
          while (siblingNode) {
        	    if (siblingNode.tagName && (siblingNode.tagName.toLowerCase() == "label")) {
        		     if (siblingNode.htmlFor && (siblingNode.htmlFor == this.id)) {
        			      this._labelNode = siblingNode;
        		     }
        	    }
        	    siblingNode = siblingNode.nextSibling;
          }
 
          var labelWidth = 0;
          if (this._labelNode){
        	     labelWidth =  dojo.coords(this._labelNode).w;
          }
          
          outerNode.style.left = widgetCoords.x + widgetCoords.w + labelWidth + 10 + "px";
          outerNode.style.top = widgetCoords.y + "px";
          statusNode.style.left = widgetCoords.x + widgetCoords.w + labelWidth + 10 + "px";
          statusNode.style.top = widgetCoords.y + "px";
          
          dojo.attr (this._acceptNode, { "class" : "ceaCollabValidatorYes" });
          dojo.attr (this._declineNode, { "class" : "ceaCollabValidatorNo" });

          outerNode.appendChild (this._acceptNode);
          outerNode.appendChild (this._declineNode);

          // Essentially, lump all these elements at the very end of the <body>
          // element.

          dojo.doc.lastChild.lastChild.appendChild (outerNode);
          dojo.doc.lastChild.lastChild.appendChild (statusNode);

          this._validationWidget = outerNode;
          this._statusWidget = statusNode;
     },

     registerEventHandlers: function() {
          this._onClickAcceptHandler = dojo.connect (this._acceptNode, "onclick", dojo.hitch (this, "handleAccept"));
          this._onClickDeclineHandler = dojo.connect (this._declineNode, "onclick", dojo.hitch (this,"handleDecline"));
     },

     unregisterEventHandlers: function() {
          dojo.disconnect (this._onClickAcceptHandler);
          dojo.disconnect (this._onClickDeclineHandler);
     }
});

}
