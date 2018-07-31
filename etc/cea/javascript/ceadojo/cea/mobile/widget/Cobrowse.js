/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.mobile.widget.Cobrowse"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.mobile.widget.Cobrowse"] = true;

dojo.provide("cea.mobile.widget.Cobrowse");

dojo.require("cea.mobile.widget.CollaborationDialog");
dojo.require("cea.widget.Cobrowse");
dojo.require("dojox.mobile");

dojo.requireLocalization("cea.mobile.widget", "Cobrowse", null, "ROOT,cs,de,es,fr,hu,it,ja,ko,pl,pt-br,ro,ru,zh,zh-tw");

/*
	(C) COPYRIGHT International Business Machines Corp. 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.mobile.widget.Cobrowse", [ cea.widget.Cobrowse ], {
	
	templateString:"<div class=\"mblPage cobrowseWidget\">\n\t\n\t<div id=\"cobrowsePage\" dojoType=\"dojox.mobile.View\" selected=\"true\" dojoAttachPoint=\"cobrowsePage\" class=\"cobrowsePage\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" dojoAttachPoint=\"cobrowseHeading\" class=\"cobrowseHeading\">${cobrowseString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"cobrowsePageContent\" class=\"cobrowsePageContent\">\t\n   \t\t\n   \t\t\t<div dojoAttachPoint=\"createCollabInviteString\" class=\"createCollabInviteString\">\n\t\t\t\t${createCollabInviteString}\n\t\t\t</div>\t\t\t\t\t\n\t\t\n\t\t\t<div class=\"cobrowseButtons\">\n\t\t\t\t<button dojoType=\"dojox.mobile.Button\" dojoAttachPoint=\"createCollaborationButton\" dojoAttachEvent=\"onClick:createCollaboration\" class=\"cobrowseWidgetButton\">${createButtonString}</button>\n\t\t\t\t<button dojoType=\"dojox.mobile.Button\" dojoAttachPoint=\"endCollaborationButton\" dojoAttachEvent=\"onClick:endCollaboration\" iconClass=\"cobrowseWidgetIcon cobrowseWidgetEndSessionIcon\" class=\"cobrowseWidgetButton\" style=\"display:none\">${endCollabButtonString}</button>\n\t\t\t</div>\n\t\t\t\n\t\t\t<div dojoAttachPoint=\"invitationLinkString\" class=\"invitationLinkString\" style=\"display:none\">\n\t\t\t\t<label dojoAttachPoint=\"invitationLinkLabel\">${invitationLinkString}:</label>\n\t\t\t\t<br>\n\t\t\t\t<input name=\"invitationLinkString\" dojoType=\"dijit.form.TextBox\" dojoAttachPoint=\"peerCollaborationLink\" dojoAttachEvent=\"onClick:_peerCollaborationLinkClick\" readonly=\"false\" class=\"cobrowseWidgetTextBox\"></input>\n\t\t\t\t\n\t\t\t</div>\n\t\t\n\t\t\t<div dojoAttachPoint=\"status\" class=\"cobrowseWidgetStatus\"></div>\n\t\t\t\n\t\t\t<ul dojoType=\"dojox.mobile.RoundRectList\" dojoAttachPoint=\"openCollabDialogButton\" class=\"openCollabButtonList\" style=\"display:none\">\n\t\t\t\t<li dojoType=\"dojox.mobile.ListItem\" moveTo=\"collaborationPage\" dojoAttachPoint=\"openCollabRoundRectListItem\" dojoAttachEvent=\"onClick:openCollabDialog\" class=\"openCollabButtonListItem\">\n\t\t\t\t${showCollaborationWindowString}\n\t\t\t\t</li>\n\t\t\t</ul>\n\t\t\t\n\t\t</div>\n\t</div>\n\t\n\t<div id=\"collaborationPage\" dojoType=\"dojox.mobile.View\" dojoAttachPoint=\"collaborationPage\" class=\"collaborationPage\">\n\t\t<h1 dojoType=\"dojox.mobile.Heading\" back=\"${cobrowseString}\" moveTo=\"cobrowsePage\" dojoAttachPoint=\"collaborationHeading\" dojoAttachEvent=\"onClick:closeCollabDialog\" class=\"collaborationHeading\">${collaborationWindowString}</h1>\t\n\t\t\n\t\t<div dojoAttachPoint=\"collaborationDialog\" dojoType=\"cea.mobile.widget.CollaborationDialog\" canControlCollaboration=\"${canControlCollaboration}\" defaultCollaborationUri=\"${defaultCollaborationUri}\" highlightElementList=\"${highlightElementList}\" isHighlightableCallback=\"${isHighlightableCallback}\" isClickableCallback=\"${isClickableCallback}\"></div>\n\t<div>\n\t\n</div>\n",
	widgetsInTemplate: true,

	initializeStrings: function() {
		// summary: Build up a mapping of variables to NLS strings for use by this widget
		this.inherited(arguments);
	
		this._messages = dojo.i18n.getLocalization("cea.mobile.widget", "Cobrowse", this.lang);
	
		this.cobrowseString = this._messages["COBROWSE"];
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
			widgetTitleHeight = this.cobrowseHeading.domNode.offsetHeight;
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
		
		dojo.style(this.cobrowsePage.domNode, "height",screenHeight + "px");
		dojo.style(this.cobrowsePage.domNode, "width",screenWidth + "px");
		
		dojo.style(this.collaborationPage.domNode, "height",screenHeight + "px");
		dojo.style(this.collaborationPage.domNode, "width",screenWidth + "px");
		
		this.collaborationDialog.setSize(screenHeight, screenWidth);

	},
	
	endCollaboration: function(){
		// summary: Invoked when the user clicks the end collaboration button for this widget
		var confirm = window.confirm(this.confirmExitString);
		if (confirm) {
			this.collaborationDialog.endCollaborationSession(dojo.hitch(this,"_convertToDisconnectedState"));
		}
	},
	
	closeCollabDialog: function(){
		// summary: Invoked when the user clicks the slide transition button to get back to the Cobrowse screen
		this.collaborationDialog.closeCollaborationDialog();
	}
	
});

}
