/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.mobile.widget.ClickToCall"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.mobile.widget.ClickToCall"] = true;

dojo.provide("cea.mobile.widget.ClickToCall");

dojo.require("cea.mobile.widget.CollaborationDialog");
dojo.require("cea.widget.ClickToCall");
dojo.require("dojox.mobile");

dojo.requireLocalization("cea.mobile.widget", "ClickToCall", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.mobile.widget.ClickToCall", [ cea.widget.ClickToCall ], {
	//	
	//	summary: A widget for embedding click to call functionality for mobile devices.
	//
	//	description: 
	//		This widget provides the ability for a user to enter a phone number/sip uri and then make a phone call
	//     	between the user's phone and the phone number/sip uri coded in widgetNumber.  Once the call is initiated the widget 
	//		provides basic status updates and call control.  Optionally this widget can be configured to provide a CollaborationDialog
	//		allowing the user to engage in a co-browse scenario with the callee.	
	//
	//	example:
	//	|	 <div dojoType="cea.mobile.widget.ClickToCall" widgetNumber="xxx-xxx-xxxx" enableCollaboration="true" canControlCollaboration="true"></div>
	//	
	
	templateString:"<div class=\"mblPage clickToCallWidget\">\n\t\n\t<div id=\"clickToCallPage\" dojoType=\"dojox.mobile.View\" selected=\"true\" dojoAttachPoint=\"clickToCallPage\" class=\"clickToCallPage\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" dojoAttachPoint=\"clickToCallHeading\" class=\"clickToCallHeading\">${clickToCallString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"clickToCallPageContent\" class=\"clickToCallPageContent\">\t\n\t\t\t<div>\n\t\t\t\t<label dojoAttachPoint=\"phoneNumberLabel\" title=\"${myNumberString}\"></label>\n\t\t\t\t<input name=\"phoneNumber\" dojoType=\"dijit.form.TextBox\" dojoAttachPoint=\"phoneNumber\" class=\"clickToCallWidgetTextBox\" placeHolder=\"${myNumberString}\"></input>\n\t\t\t</div>\n\t\t\t<div><button dojoType=\"dojox.mobile.Button\" dojoAttachEvent=\"onClick:call\" dojoAttachPoint=\"callButton\" iconClass=\"clickToCallWidgetIcon clickToCallWidgetCallIcon\" class=\"clickToCallWidgetButton\">${callButtonString}</button></div>\n\t\t\t<div><button dojoType=\"dojox.mobile.Button\" dojoAttachEvent=\"onClick:hangup\" dojoAttachPoint=\"hangupButton\"  iconClass=\"clickToCallWidgetIcon clickToCallWidgetEndCallIcon\" class=\"clickToCallWidgetButton\" style=\"display:none\">${hangupButtonString}</button></div>\n\t\t\t\n\t\t\t<div dojoAttachPoint=\"status\" class=\"clickToCallWidgetStatus\" style=\"display:none\"></div>\n\t\t\t\n\t\t\t<ul dojoType=\"dojox.mobile.RoundRectList\" dojoAttachPoint=\"cobrowseButton\" class=\"openCollabButtonList\" style=\"display:none\">\n\t\t\t\t<li dojoType=\"dojox.mobile.ListItem\" moveTo=\"collaborationPage\" dojoAttachPoint=\"openCollabRoundRectListItem\" dojoAttachEvent=\"onClick:cobrowse\" class=\"openCollabButtonListItem\">\n\t\t\t\t\t${showCollaborationWindowString}\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t</div>\t\t\n   \t</div>\t\n   \t\n\t<div id=\"collaborationPage\" dojoType=\"dojox.mobile.View\" dojoAttachPoint=\"collaborationPage\" class=\"collaborationPage\" style=\"display:none\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" back=\"${clickToCallString}\" moveTo=\"clickToCallPage\" dojoAttachPoint=\"collaborationHeading\" dojoAttachEvent=\"onClick:closeCollabDialog\" class=\"collaborationHeading\">${collaborationWindowString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.mobile.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\"></div>\n\t<div>\n\t\n</div>\n",
	widgetsInTemplate: true,
	
	initializeNLSStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget
		this.inherited(arguments);
	
		this._messages = dojo.i18n.getLocalization("cea.mobile.widget", "ClickToCall", this.lang);
	
		this.clickToCallString = this._messages["CLICK_TO_CALL"];
		this.showCollaborationWindowString = this._messages["SHOW_COLLABORATION_WINDOW"];
		this.collaborationWindowString = this._messages["COLLABORATION_WINDOW"];
	
	},
	postCreate: function(){
		this.inherited(arguments);
		
		this.resizeWidget();
		
		if((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) { 
			dojo.connect(document.body, "onorientationchange", this, this.resizeWidget);
		} else {
			dojo.connect(window, "onresize", this, this.resizeWidget);
		}
		
		//Set a reference to the Show collaboration window button to the CollaborationDialog so it can be "clicked" when a sendpage etc occurs.
		this.collaborationDialog.openCollabRoundRectListItem = this.openCollabRoundRectListItem;
		
	},
	
	resizeWidget: function(){
		//summary: Invoked during an orientation change to resize the widget appropriately
		console.log("resizeWidget" + " height: " + screen.height + " width:" + screen.width + " orientation:" + window.orientation);
		
		screenHeight = screen.height;
		screenWidth = screen.width;
		
		if((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) { 
			//iPhone always incorrectly reports width=320 height=396 regardless of orientation.
			//The button bar is 44 pixels in portrait and 32 pixels in landscape
			//Subtract status bar, button bar and widget title height from screen height 
			 
			//since offsetHeight returns 0 for a hidden element we have to check both headings
			widgetTitleHeight = this.clickToCallHeading.domNode.offsetHeight;
			if (widgetTitleHeight == 0){
				widgetTitleHeight = this.collaborationHeading.domNode.offsetHeight;
			}

			switch(window.orientation) {
        		case 0: case 180:
        			screenHeight = 480 - 20 - 44 - widgetTitleHeight;
        			screenWidth = 320;
        			break;
        		case 90: case -90: 
        			screenHeight = 320 - 20 - 32 - widgetTitleHeight;
        			screenWidth = 480;
        			break;
			}	
        } else {
        	//Subtract status bar and widget title height from screen height
        	screenHeight = screenHeight - 25 - 44;	
        }
		
		dojo.style(this.clickToCallPage.domNode, "height",screenHeight + "px");
		dojo.style(this.clickToCallPage.domNode, "width",screenWidth + "px");
		
		dojo.style(this.collaborationPage.domNode, "height",screenHeight + "px");
		dojo.style(this.collaborationPage.domNode, "width",screenWidth + "px");
		
		this.collaborationDialog.setSize(screenHeight, screenWidth);

	},
	
	hangup: function() {
		// summary: Invoked when the user clicks the 'Hangup' button for this widget
		var confirm = window.confirm(this.confirmHangupString);
		if (confirm) {
			this.endCall(dojo.hitch(this,"_convertToDisconnectedState"));
		}
	},
	
	closeCollabDialog: function(){
		// summary: Invoked when the user clicks the slide transition button to get back to the ClickToCall screen
		this.collaborationDialog.closeCollaborationDialog();
	}
	
});

}
