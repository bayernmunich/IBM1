/*
	Copyright (c) 2004-2010, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["cea.mobile.widget.iFrame"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["cea.mobile.widget.iFrame"] = true;
dojo.provide("cea.mobile.widget.iFrame");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dojox.html.ext-dojo.style");


/*
	(C) COPYRIGHT International Business Machines Corp. 2010
	All Rights Reserved * Licensed Materials - Property of IBM
*/

dojo.declare("cea.mobile.widget.iFrame", [ dijit._Widget, dijit._Templated ], {
	
	templateString:"<div dojoAttachPoint=\"mobileIFrameContainer\" class=\"mobileIFrameContainer\">\n\t<iframe dojoAttachPoint=\"mobileIFrame\" class=\"mobileIFrame\"></iframe>\t\n</div>\n",
	widgetsInTemplate: true,
	
	postCreate: function(){
		dojo.connect(this.mobileIFrame, "onload", this, this.iFrameOnload);	
	},
	
	resize: function(){
		this.inherited(arguments);

		this.viewPortWidth = dojo.style(this.mobileIFrameContainer, "width");
		this.viewPortHeight = dojo.style(this.mobileIFrameContainer, "height");
		
		if (!isNaN(this.pageWidth) && !isNaN(this.pageHeight)){
			//Determine the minimum scale since it wasn't explicitly set so the page can't be resized smaller than full screen
			widthScale = this.viewPortWidth/this.pageWidth;
			heightScale = this.viewPortHeight/this.pageHeight;
			calculatedScale = widthScale > heightScale ? widthScale:heightScale;
			this.minimumScale = this.minimumScale > calculatedScale ? this.minimumScale:calculatedScale;
			console.log("iFrame minimum-scale: " + this.minimumScale);
		}
	},

	iFrameOnload: function(){
		
		var iframeDoc = this.mobileIFrame.contentWindow.document;
		dojo.withDoc(iframeDoc, function() {
			
			dojo.connect(dojo.doc, "onclick", this, this.onClick);
			
			dojo.connect(dojo.doc, "ontouchstart", this, this.onTouchStart);
			dojo.connect(dojo.doc, "ontouchmove", this, this.onTouchMove);
			dojo.connect(dojo.doc, "ontouchend", this, this.onTouchEnd);
			
			dojo.connect(dojo.doc, "ongesturestart", this, this.onGestureStart);
			dojo.connect(dojo.doc, "ongesturechange", this, this.onGestureChange);
			dojo.connect(dojo.doc, "ongestureend", this, this.onGestureEnd);
			
			//reset the scale and translate when a new page is loaded
			this.userScalable = true;
			this.curScale = 1;
			this.curTranslateX = 0;
			this.curTranslateY = 0;
			
			this.initialScale = 1;
			this.minimumScale = 0.25;
			this.maximumScale = 1.6;
				
			//read the meta viewport tag to pull out user-scalable, initial-scale, minimum-scale, and maximum-scale
			var metaTags = dojo.doc.getElementsByTagName('meta'); 
			for(var i in metaTags){ 
				if(metaTags[i].name == "viewport"){ 
					 var viewport = metaTags[i].content;
				} 
			}
			
			if ( viewport != null){
				console.log("viewport: " + viewport);
				
				//some sites differentiate the viewport attributes by commas and some by semicolons so we need to check for both cases
				if ( viewport.indexOf(",") > 0){
					contents = viewport.split(",");
				} else {
					contents = viewport.split(";");
				}
				
				for(var j in contents){ 			
					attribute = contents[j].split("=");
					value = dojo.trim(attribute[0]);
					switch(value) {
        				case 'user-scalable':
        					if ( attribute[1] == 0 || attribute[1] == "false" || attribute[1] == "no"){
        						this.userScalable = false;
        					}
        					break;
        				case 'initial-scale': 
        					this.intialScale = attribute[1];
        					this.curScale = attribute[1];
        					break;
        				case 'minimum-scale': 
        					this.minimumScale = attribute[1];
        					break;
        				case 'maximum-scale': 
        					this.maximumScale = attribute[1];
        					break;	
					}	
				}
			}
			
			//get the width and height of the page loaded in the iFrame to be used during scaling and translates
			this.pageWidth = dojo.doc.body.scrollWidth;
			this.pageHeight = dojo.doc.body.scrollHeight;

			//Determine if the minimum scale based on page size is bigger than the default
			if (this.viewPortWidth > 0 && this.viewPortHeight > 0){
				widthScale = this.viewPortWidth/this.pageWidth;
				heightScale = this.viewPortHeight/this.pageHeight;
				calculatedScale = widthScale > heightScale ? widthScale:heightScale;
				this.minimumScale = this.minimumScale > calculatedScale ? this.minimumScale:calculatedScale;
			}
			
			console.log("iFrame user-scalable:" + this.userScalable + " initial-scale: " + this.curScale);
			console.log("iFrame minimum-scale: " + this.minimumScale + " maximum-scale: " + this.maximumScale);
			
			//On Android webkitTapHighlightColor doesn't work with the webkitTransform so we need to hide this.  We will simulate the effect when a click occurs.
			if(navigator.userAgent.match(/Android/i)) { 
				this.mobileIFrame.contentWindow.document.body.style.webkitTapHighlightColor = "rgba(0,0,0,0)";
			}
			
			dojo.style(this.mobileIFrame.contentWindow.document.body, "webkitTextSizeAdjust", "none");
			
			//Due to a bug in iOS4 if the collabPage is not visible we must hide the iFrame content otherwise Safari will crash
			if (navigator.userAgent.match(/OS 4/i)){	
				var self = this;
				setTimeout(function(){
					collaborationPage = dojo.byId(collaborationPage);
					if (dojo.style(collaborationPage,"display") == "none"){
						dojo.style(self.mobileIFrame.contentWindow.document.body, "display", "none");
						dojo.style(self.mobileIFrame.contentWindow.document.body, "transformOrigin", "0% 0%");
						dojo.style(self.mobileIFrame.contentWindow.document.body, "transform", "scale(" + self.curScale  + ") translate(" + self.curTranslateX + "px, " + self.curTranslateY + "px)");
					}
				}, 500);
				
			} else {
				dojo.style(this.mobileIFrame.contentWindow.document.body, "transformOrigin", "0% 0%");
				dojo.style(this.mobileIFrame.contentWindow.document.body, "transform", "scale(" + this.curScale  + ") translate(" + this.curTranslateX + "px, " + this.curTranslateY + "px)");
			}
			
		}, this);
	},
	
	onClick: function(event) {
		//console.log("onClick");
		//If a doubleclick is detected cancel the default action and bubbling of the click
		if (this.doubleClickDetected){
			event.preventDefault();
			event.cancelBubble = true;
			event.returnValue = false;
			return;
		}

		//This will add a gray highlight when an element is clicked to simulate the webkitTapHighlightColor that had to be disabled for Android
		if(navigator.userAgent.match(/Android/i)) { 
		
			var target = event.target;
			if (target.nodeType == 3){
				target = target.parentNode;
			}
			
			var backgroundColor = target.style.backgroundColor;
			var webkitBorderRadius = target.style.webkitBorderRadius;
		
			target.style.backgroundColor = "rgba(127,127,127,.7)";
			target.style.webkitBorderRadius = "3px";
			
			var self = this;
			setTimeout(function(){
				target.style.backgroundColor = backgroundColor;
				target.style.webkitBorderRadius = webkitBorderRadius;
				//Since webkit browsers don't always repaint based on a css style change this will force a repaint to cancel the highlight
				self.mobileIFrame.contentWindow.scrollTo(0, 1);
			}, 300);	
		}	
	},
	
	onTouchStart: function(event) {
		//console.log("onTouchStart");
		if ( event.touches.length == 1){
		
			//For Android we have to cancel the touchStart default for our scroll to work correctly
			if(navigator.userAgent.match(/Android/i)){
				event.preventDefault(); 
			}
			
			this.touchMoved = false;
			this.doubleClickDetected = false;
			
			this.curTouchX = event.touches[0].pageX;
			this.curTouchY = event.touches[0].pageY;
			
			//If the page is scalable we need to check for doubleclicks
			if ( this.userScalable ){

				//Store the time of the first click
				var self = this;
				var d = new Date();
				var firstClickTime = d.getTime();
			
				var iframeDoc = this.mobileIFrame.contentWindow.document;
				dojo.withDoc(iframeDoc, function() {
					var touchHandle = dojo.connect(dojo.doc, 'ontouchstart', function(e){
						//dojo.disconnect(touchHandle);
					
						//Get the time of the second click and see if it was quick enough to be a double click
						var d = new Date();
						var secondClickTime = d.getTime();
						if ( secondClickTime <= firstClickTime + 300 ){
							console.log("doubleClick Detected initiate zoom");
							self.doubleClickDetected = true;
													
							if ( self.curScale > self.minimumScale){
								self.curScale = self.minimumScale;
								self.curTranslateX = 0;
								self.curTranslateY = 0;
							} else {
								//Find the x-y position of the element so that we can translate the page
								var element = event.touches[0].target;
								if (element.nodeType == 3){
									element = element.parentNode;
								}
								
								var x = 0;
								var y = 0;   
								while(element.tagName != "BODY") {
									x += element.offsetLeft;
									y += element.offsetTop;
									element = element.offsetParent;
								}
							
								self.curScale = self.initialScale;
								self.curTranslateX = -x;
								self.curTranslateY = -y;

							}
							
							dojo.style(self.mobileIFrame.contentWindow.document.body, "transformOrigin", "0% 0%");
							dojo.style(self.mobileIFrame.contentWindow.document.body, "transform", "scale(" + self.curScale  + ") translate(" + self.curTranslateX + "px, " + self.curTranslateY + "px)");	
						}
					});
				}, this);
			}		
		}
	},

	onTouchMove: function(event) {
		//console.log("onTouchMove");
		if (event.touches.length == 1){

			this.touchMoved = true;
			//Since the default action of the touchMove kills the focus of the target we will do this manually with a small scroll
			event.preventDefault();			
			
			window.scrollTo(0, 2);
			window.scrollTo(0, 1);
			
			this.curTranslateX = this.curTranslateX + (event.touches[0].pageX - this.curTouchX);
			this.curTranslateY = this.curTranslateY + (event.touches[0].pageY - this.curTouchY);
			
			this.curTouchX = event.touches[0].pageX;
			this.curTouchY = event.touches[0].pageY;
			
			if ( this.curTranslateX > 0){
				this.curTranslateX = 0;
			} else if (this.curTranslateX < -(this.pageWidth - this.viewPortWidth) * this.curScale){				
				this.curTranslateX = -(this.pageWidth - this.viewPortWidth) * this.curScale;
			}
			
			if ( this.curTranslateY > 0){
				this.curTranslateY = 0;
			} else if (this.curTranslateY < -(this.pageHeight - this.viewPortHeight)  * this.curScale){
				this.curTranslateY = -(this.pageHeight - this.viewPortHeight) * this.curScale
			}

			dojo.style(this.mobileIFrame.contentWindow.document.body, "transform", "scale(" + this.curScale  + ") translate(" + this.curTranslateX + "px, " + this.curTranslateY + "px)");
			
		}

	},

	onTouchEnd: function(event) {
		//console.log("onTouchEnd");
		//If the user's touch goes outside of the iFrame the outer page may scroll.  This will cause it to bounce back to the correct position
		window.scrollTo(0, 1);
		
		if(navigator.userAgent.match(/Android/i) && !this.touchMoved){
			setTimeout(function(){
				if(!this.doubleClickDetected){
					//For Android we have to cancel the touchStart default for our scroll to work correctly.  
					//So now we also have to manually fire the click event if the the touch didn't move and wasn't part of a doubleclick
					var evt = document.createEvent("MouseEvents");
					evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
					event.target.dispatchEvent(evt);
				}
			}, 300);
		}	 
	},
	
	onGestureStart: function(event) {
		//console.log("onGestureStart");
	},

	onGestureChange: function(event) {
		//console.log("onGestureChange");
	},

	onGestureEnd: function(event) {
		//console.log("onGestureEnd");
	}

});

}
