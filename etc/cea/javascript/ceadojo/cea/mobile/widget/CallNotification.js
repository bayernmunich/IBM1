/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.mobile.widget.CallNotification"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.mobile.widget.CallNotification"] = true;

dojo.provide("cea.mobile.widget.CallNotification");

dojo.require("cea.mobile.widget.CollaborationDialog");
dojo.require("cea.widget.CallNotification");
dojo.require("dojox.mobile");

dojo.requireLocalization("cea.mobile.widget", "CallNotification", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.mobile.widget.CallNotification", [ cea.widget.CallNotification ], {
	
	templateString:"<div class=\"mblPage callNotificationWidget\">\n\t\n\t<div id=\"callNotificationPage\" dojoType=\"dojox.mobile.View\" selected=\"true\" dojoAttachPoint=\"callNotificationPage\" class=\"callNotificationPage\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" dojoAttachPoint=\"callNotificationHeading\" class=\"callNotificationHeading\">${callNotificationString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"callNotificationPageContent\" class=\"callNotificationPageContent\">\t\t\n\t\t\t<div>\n\t\t\t\t<label dojoAttachPoint=\"phoneNumberLabel\" title=\"${myNumberString}\"></label>\n\t\t\t\t<input name=\"phoneNumber\" dojoType=\"dijit.form.TextBox\" dojoAttachPoint=\"phoneNumber\" class=\"callNotificationWidgetTextBox\" placeHolder=\"${myNumberString}\"></input>\t\n\t\t\t</div>\n\t\t\t<div><button dojoType=\"dojox.mobile.Button\" dojoAttachEvent=\"onClick:start\" dojoAttachPoint=\"startButton\" showLabel=\"true\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetRegisterIcon\" class=\"callNotificationWidgetButton\">${startCallNotificationButtonString}</button></div>\n\t\t\t<div><button dojoType=\"dojox.mobile.Button\" dojoAttachEvent=\"onClick:stop\" dojoAttachPoint=\"stopButton\" showLabel=\"true\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetUnregisterIcon\" class=\"callNotificationWidgetButton\" style=\"display:none\">${stopCallNotificationButtonString}</button></div>\n\t\t\t<div><button dojoType=\"dojox.mobile.Button\" dojoAttachEvent=\"onClick:hangup\" dojoAttachPoint=\"hangupButton\" showLabel=\"true\" iconClass=\"callNotificationWidgetIcon callNotificationWidgetHangupIcon\" class=\"callNotificationWidgetButton\" style=\"display:none\">${hangupButtonString}</button></div>\n\t\t\t\t\t\n\t\t\t<div dojoAttachPoint=\"status\" class=\"callNotificationWidgetStatus\" style=\"display:none\"></div>\n\n\t\t\t<ul dojoType=\"dojox.mobile.RoundRectList\" dojoAttachPoint=\"cobrowseButton\" class=\"openCollabButtonList\" style=\"display:none\">\n\t\t\t\t<li dojoType=\"dojox.mobile.ListItem\" moveTo=\"collaborationPage\" dojoAttachPoint=\"openCollabRoundRectListItem\" dojoAttachEvent=\"onClick:cobrowse\" class=\"openCollabButtonListItem\">\n\t\t\t\t${showCollaborationWindowString}\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t</div>\n\t</div>\n\t\n\t<div id=\"collaborationPage\" dojoType=\"dojox.mobile.View\" dojoAttachPoint=\"collaborationPage\" class=\"collaborationPage\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" back=\"${callNotificationString}\" moveTo=\"callNotificationPage\"\" dojoAttachPoint=\"collaborationHeading\" dojoAttachEvent=\"onClick:closeCollabDialog\" class=\"collaborationHeading\">${collaborationWindowString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.mobile.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\"></div>\t\n\t<div>\n\t\n</div>\n",
	widgetsInTemplate: true,
	
	initializeNLSStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget
		this.inherited(arguments);
	
		this._messages = dojo.i18n.getLocalization("cea.mobile.widget", "CallNotification", this.lang);
	
		this.callNotificationString = this._messages["CALL_NOTIFICATION"];
		this.showCollaborationWindowString = this._messages["SHOW_COLLABORATION_WINDOW"];
		this.collaborationWindowString = this._messages["COLLABORATION_WINDOW"];
	
	},
	
	postCreate: function(){
		this.inherited(arguments);
		
		this.resizeWidget();
		
		//Since the mobile CallNotification widget its more usable to show/hide buttons vs enable/disable 
		//we will connect to set function for these buttons to instead show/hide.
		dojo.connect(this.stopButton, "set", this, "stopButtonAttr");
		dojo.connect(this.hangupButton, "set", this, "hangupButtonAttr");
		dojo.connect(this.cobrowseButton, "set", this, "cobrowseButtonAttr");
		
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
			widgetTitleHeight = this.callNotificationHeading.domNode.offsetHeight;
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
		
		dojo.style(this.callNotificationPage.domNode, "height",screenHeight + "px");
		dojo.style(this.callNotificationPage.domNode, "width",screenWidth + "px");
		
		dojo.style(this.collaborationPage.domNode, "height",screenHeight + "px");
		dojo.style(this.collaborationPage.domNode, "width",screenWidth + "px");
		
		this.collaborationDialog.setSize(screenHeight, screenWidth);

	},
	
	stopButtonAttr: function(attrName, attrValue) {	
		// summary: Map calls to enable/disable the stop button to instead show/hide it
		if (attrName == "disabled"){
			if ( attrValue == true){
				dojo.style(this.stopButton.domNode, 'display', 'none');
			} else {
				dojo.style(this.stopButton.domNode, 'display', '');
			}
		}	
	},
	
	hangupButtonAttr: function(attrName, attrValue) {	
		// summary: Map calls to enable/disable the hangup button to instead show/hide it
		if (attrName == "disabled"){
			if ( attrValue == true){
				dojo.style(this.hangupButton.domNode, 'display', 'none');
			} else {
				dojo.style(this.hangupButton.domNode, 'display', '');
			}
		}	
	},
	
	cobrowseButtonAttr: function(attrName, attrValue) {
		// summary: Map calls to enable/disable the cobrowse button to instead show/hide it
		if (attrName == "disabled"){
			if ( attrValue == true){
				dojo.style(this.cobrowseButton.domNode, 'display', 'none');
			} else {
				dojo.style(this.cobrowseButton.domNode, 'display', '');
			}
		}	
	},
	
	stop: function() {
		// summary: Invoked when the user clicks the 'Stop call notification' button for this widget
		var confirm = window.confirm(this.confirmStopString);
		if (confirm) {
			this.unregisterForCallNotification(dojo.hitch(this, "_convertToUnregisteredState"));
		}
	},
	
	hangup: function() {
		// summary: Invoked when the user clicks the 'Hangup' button for this widget
		var confirm = window.confirm(this.confirmHangupString);
		if (confirm) {
			this.endCall(dojo.hitch(this,"_convertToDisconnectedState"));
		}
	},
	
	closeCollabDialog: function(){
		// summary: Invoked when the user clicks the slide transition button to get back to the CallNotification screen
		this.collaborationDialog.closeCollaborationDialog();
	}
	
});

}
