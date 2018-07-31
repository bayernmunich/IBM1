// IBM Confidential OCO Source Material
// 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005
// The source code for this program is not published or otherwise divested
// of its trade secrets, irrespective of what has been deposited with the
// U.S. Copyright Office.

var SUB_MENU_IMAGE = "/ibm/console/com.ibm.ws.console.xdoperations/images/menuArrow.gif";
var MENU_BG_COLOR = "white";
var MENU_FG_COLOR = "black";
var MENU_HIGHLIGHTED_BG_COLOR = "#8691C7";
var MENU_HIGHLIGHTED_FG_COLOR = "white";
var menuClickX;
var menuClickY;

var SUB_MENU_GAP = 0;
var SUB_MENU_VERTICAL_OFFSET = 0;
var MENU_SLOT_HEIGHT = 24;
var MENU_WIDTH = 150;
var subMenuIndex = new Object();
var actionIndex = new Object();
var menuIndex = new Object();
var divIndex = new Object();
var movebyTotal = 0;


//register an event handler on the document for any mousedowns.  If it occurs on a menu div, 
//we do nothing.  if it is NOT on a menu div, we close all menus.

	

function handleMouseDownEvent(e){
	if (!e)
		e = event;
	//var targetId = getTargetId(e);
	//if (!targetId || !divIndex[targetId]){
		closeOpenMenus();
	//}
}
var newWin;

function getTargetId(eventObject){
	if (eventObject.srcElement){
		var obj = eventObject.srcElement;
		while ( (obj.tagName.toUpperCase() != "DIV") && obj.parentElement)
			obj = obj.parentElement;
		return obj.id;
	}
	else if (eventObject.target)
		return eventObject.target.id;
}


/*
x: x coordinate of top left corner of the menu
y: y coordinate of top left corner of the menu
contents: hash of Displayed Name -> Menu/MenuAction object 
		(Menu objects represent submenus, MenuAction objects represent URLs)
*/
var inited = false;
function Menu(contents, name, id, title){
	if (!inited){
		if (window.addEventListener){
			window.addEventListener("mousedown", closeOpenMenus, false);
			window.addEventListener("onclick", closeOpenMenus, false);
		} else if (document.attachEvent){
			document.body.attachEvent("onmousedown", closeOpenMenus);
			document.body.attachEvent("onclick", closeOpenMenus);
		} else {
			document.body.onmousedown=closeOpenMenus;
			document.body.onclick=closeOpenMenus;
		}
		inited = true;
	}
	
	this.menuName = name;
	this.contents = contents;
	this.title = title;
	this.openMenuId = null;
	this.parentMenu = null; //if this menu is added to a parent later, it will be set then.
	this.div = null;
	this.ifr = null;
	this.id = id;
	if (menuIndex[this.id])
		menuIndex[this.id].closeIt();	
		
	menuIndex[this.id] = this;	
	//methods
	this.display = menuRender;
		
	this.setOpenMenuId = function(newMenuId){
		if (!this.openMenuId){ //if there was previously no open menu, just store the new menu and we're done.
			this.openMenuId = newMenuId;
		} else if(this.openMenuId != newMenuId){ //this new menu was already open, just close any of its children that are open
			menuIndex[this.openMenuId].closeIt();
			this.openMenuId = newMenuId;
		}
		menuIndex[newMenuId].closeOpenMenu(); 
	};
	
	this.closeOpenMenu = function(){
		if (this.openMenuId){
			menuIndex[this.openMenuId].closeIt();
			this.openMenuId = null;
		}
	};

	this.unHighlightItem = function(item){
		if (this.highlightedItem && this.highlightedItem == item){
			item.div.style.backgroundColor = MENU_BG_COLOR;		
			item.textNode.style.color = MENU_FG_COLOR;
		}
	};

	this.closeIt = function(){
		//if this menu is the parent's highlighted item, 
		var submenu = subMenuIndex[this.id]; //menus and submenus share an id
		if (submenu){ //root menu has no submenu
			var submenuparent= submenu.parent;
			submenuparent.unHighlightItem(this);
		}
		
		if (this.openMenuId){
			menuIndex[this.openMenuId].closeIt();
		}
		this.openMenuId = null;
		
		for (var i in this.contents){
			if (this.contents[i].closeIt)
				this.contents[i].closeIt();
		}
		delete menuIndex[this.id];
		
		//now child menus are closed, remove this one's div.
		delete divIndex[this.div.id];
		this.ifr.style.display = "none";
		document.body.removeChild(this.ifr);
		document.body.removeChild(this.div);
		
	}
	
	for (var c in contents){
		contents[c].parent = this;
		contents[c].menuName = this.menuName;	
	}


}

/*
menuCreatorMethod: method (as a string, including parameter values) to be called to create & return a Menu object in the event this subMenu is clicked.
*/
function SubMenu(menuCreator, id){
	this.id = id;
	this.parent = null; //this is set when this submenu is attached to a parent.
	this.createMenuSliver = submenuRender;
	this.div = null; //this is set when the menu sliver is created for this submenu.  it's only used in the onMouseOver handler, which obviously can't get called until the menu sliver exists.
	this.menuCreator = menuCreator;
	subMenuIndex[this.id] = this;	
	this.divleft = null;
	this.divtop = null;

	/*
	div: the div whose onmouseover caused this call.
	*/
	this.displayMenu = function(){ 
		//first, tell parentMenu that this SubMenu is open.
		if (menuIndex[this.id])
			menuIndex[this.id].closeOpenMenu();

		var menu = menuCreator.create(this.id);
		if (!menu)
			return;

		menuIndex[this.id] = menu;
		menu.id = this.id;
		this.parent.setOpenMenuId(menu.id);
		
		menu.display(this.divleft + MENU_WIDTH + SUB_MENU_GAP + 10, this.divtop + SUB_MENU_VERTICAL_OFFSET + 10);
	};	

	this.closeIt = function(){
		delete subMenuIndex[this.id];
		delete divIndex[this.div.id];
	};
	
}

/*
url: URL to be followed when this action is clicked
*/
function MenuAction(url, targetFrame){
	this.parent = null; //this is set when this submenu is attached to a parent.
	this.url = url;	
	this.targetFrame = targetFrame;
	this.createMenuSliver = menuActionRender;	
	this.closeIt = function(){
		delete( divIndex[this.div.id]);
		delete( actionIndex[this.id]);
	};
	this.mouseOver = function(){
		var p = this.parent;
		if (p)
			p.closeOpenMenu();
	};
}

//================================================================================================
//================================================================================================
//================================================================================================

function menuActionRender(text, divId){
	this.id = "ACTION" + divId;
	var theId = this.id;
	actionIndex[theId] = this;
	var div = createMenuSliver(this, text, "", divId, this.url, this.targetFrame, this.id);
	div.onmouseover = function(){ highlightMenuItem(theId); getActionById(theId).mouseOver();};
	this.div = div;
	return div;
}


function getSubMenuById(id){
	return (subMenuIndex[id]);
}

function getActionById(id){
	return (actionIndex[id]);
}

function createIframe() {
	var menuIfr = document.createElement('iframe');
	menuIfr.src = 'javascript:false';
	menuIfr.scrolling = 'no';
	menuIfr.frameborder = 0;
	menuIfr.style.position = 'absolute';
	menuIfr.style.top = 0;
	menuIfr.style.left = 0;
	menuIfr.style.display = 'none';
      
	return menuIfr;
}


//
function menuRender(x, y){
	var mainDivId = "MENU_DIV_" + this.id;
	var div = createDiv(mainDivId, x, y);
	this.div = div;
	divIndex[mainDivId] = this;
	div.style.backgroundColor = MENU_BG_COLOR;
	div.style.width = MENU_WIDTH;
	div.style.overflow="hidden";
	div.style.borderWidth = "1 1 0 1";
	div.style.borderColor="black";
	div.style.borderStyle="solid";
	div.style.zIndex = 100;
	div.onmousedown= function(e){
		if (!e)
			e = event;
		e.cancelBubble = true;
		return false;
	}
	
	var subDiv, id, item;
	var num = 0;
	var suby = y;
	
	for (var text in this.contents){
		num++;
		item = this.contents[text];
		id = mainDivId + "_" + num;
		item.divleft=x;
		item.divtop=suby;	
		subDiv = item.createMenuSliver(text, id);
		divIndex[id] = item;
		if (subDiv)
			div.appendChild(subDiv);
		suby += MENU_SLOT_HEIGHT + num + 1; //there is a border of width 1 for each level.
	}	

	document.body.appendChild(div);


    positionMenuAgain(mainDivId);

	menuIfr = createIframe();
	this.ifr = menuIfr;
	menuIfr.style.top = div.style.top;
   	menuIfr.style.left = div.style.left;
 	menuIfr.style.width = div.offsetWidth -5;  // add 5px fudge factor for Mozilla
   	menuIfr.style.height = div.offsetHeight-5;  // add 5 px fudge factor for Mozilla
    menuIfr.style.zIndex = div.style.zIndex-1;
	menuIfr.style.display = "block";
	
	document.body.appendChild(menuIfr);




}

function positionMenuAgain(divid) {
    //alert(document.body.scrollLeft);
    //alert(document.body.clientWidth);
    var tmpmove = 0;
    var tmpmovestatic = 0;
    if (movebyTotal > 0) {
        tmpmove = movebyTotal;
        tmpmovestatic = 15;
    }
    if (document.body.scrollWidth > document.body.clientWidth) {
        moveby = document.body.scrollWidth - document.body.clientWidth;
        //alert(parseInt(document.getElementById(divid).style.left));
        movebyTotal = parseInt(document.getElementById(divid).style.left) - moveby;
        if (movebyTotal < 0) {
            movebyTotal = 0;
        }
        movebyTotal += document.body.scrollLeft;
        document.getElementById(divid).style.left = movebyTotal-tmpmovestatic;
        tmpmovestatic = 0;
    }


}

//divId: id to be used for the created DIV
function submenuRender(text, divId){
	var theId = this.id;
	var div = createMenuSliver(this, text, SUB_MENU_IMAGE, divId, "javascript:focusOnSubmenu('"+ this.id  +"');", null, theId);
	div.onmouseover = function(){highlightMenuItem(theId); getSubMenuById(theId).displayMenu();};
	this.div = div;
	return div;
}


function focusOnSubmenu(submenuId){
	var menuObj = menuIndex[submenuId];
	var menuContents = menuObj.contents;	
	var item = null;
	for (var label in menuContents){
		item = menuContents[label];
		break;
	}
	if (!item){
		return;
	}
	var textNode = item.textNode;
	if (textNode.focus)
		textNode.focus();
	else
		textNode.onFocus();
	return true;
}

function highlightMenuItem(itemId){
	var item = subMenuIndex[itemId];
	if (!item)
		item = actionIndex[itemId];
	if (!item)
		return;
	
	var parent = item.parent;
	
	if (parent.highlightedItem){
		parent.unHighlightItem(parent.highlightedItem);
	}
	parent.highlightedItem = item;
	item.div.style.backgroundColor=MENU_HIGHLIGHTED_BG_COLOR;
	item.textNode.style.color=MENU_HIGHLIGHTED_FG_COLOR;
	
}

function createMenuSliver(node, text, imgPath, id, url, targetFrame, sliverId){
	//create a small DIV containing this item.
	var subDiv = createDiv(id);
	//subDiv.style.height = MENU_SLOT_HEIGHT; // commenting this out, since Mozilla chokes on it
	subDiv.style.width = MENU_WIDTH;
	subDiv.style.borderColor="black";
	subDiv.style.borderWidth = "0 0 1 0"; //T L B R
	subDiv.style.borderStyle="solid";
	subDiv.style.color = MENU_FG_COLOR;
	
	var table = document.createElement("TABLE");
	var tbody = document.createElement("TBODY");
	var tr = document.createElement("TR");
	
	table.width="100%";
	var td1 = document.createElement("TD");
	var onFocus = "function(){return false;}";
	var action = getActionById(sliverId);
	var submenu = getSubMenuById(sliverId);
	if (action)	
		onFocus = function(){ highlightMenuItem(sliverId); action.mouseOver();};
	else if (submenu) {
		onFocus = function(){highlightMenuItem(sliverId); submenu.displayMenu()};
	} else {
		url = null;	
	}
	
	var textNode = getTextNode(text, url, targetFrame, onFocus);
	node.textNode = textNode;
	td1.appendChild(textNode);	
	tr.appendChild(td1);

	if (imgPath && imgPath != ""){
		td2 = document.createElement("TD");
		td2.style.width = 20;
		td2.align="right";
		img = document.createElement("img");
		img.setAttribute("src", imgPath);	
		img.setAttribute("width", 5);
		img.setAttribute("height", 10);	
		td2.appendChild(img); 
		tr.appendChild(td2);
	}
		
	tbody.appendChild(tr);
	table.appendChild(tbody);
	subDiv.appendChild(table);
	return subDiv;
}

//if url is a javascript url like: javascript:functionName(); , the part after javascript: will be 
//evaluated.  If it returns nothing, or something else that resolves to false, then the menus will be 
//closed after it is evaluated.  Otherwise, the menus are left open.
function getTextNode(text, url, targetFrame, onfocus){
	var textContainer;		
	
	if (url){
		var oldUrl = url;
		url=url.replace(/^\s*/,""); //trim the string's beginning
		var isJs = false;
		if (url.match(/^[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]:/)){ //if it starts with javascript, any case
			url = url.substr(11);//cut off the javascript: beginning
			isJs = true;
		}

		//make a link using the variable "text" for the link's text and "url" for the link's url
		textContainer = document.createElement("A");
		textContainer.setAttribute("href", oldUrl);
		if (targetFrame)
			textContainer.setAttribute("target", targetFrame);
	
		if (!isJs)
			textContainer.onclick=function(e){if(!e) e=event; menuClickX=e.clientX; menuClickY=e.clientY; closeOpenMenus(); return true;};
		else
			textContainer.onclick=function(e){if(!e) e=event; menuClickX=e.clientX; menuClickY=e.clientY; if(!eval(url))closeOpenMenus(); return false;};
	
		textContainer.onfocus=onfocus;
		textContainer.appendChild(document.createTextNode(text));
		textContainer.style.textDecoration="none";		
	} else {
		textContainer = document.createElement("SPAN");		
		textContainer.appendChild(document.createTextNode(text));
	}
	textContainer.style.color="black";
	textContainer.style.fontSize="70%";
	textContainer.style.fontFamily="Arial,Helvetica,sans-serif";
	textContainer.style.verticalAlign="middle";
	
	return textContainer;
}


function createDiv(id, x, y){
	var div = document.createElement("DIV");
	div.id = id;
	if (x){
		div.style.position = "absolute";
		div.style.top = y;
        
		div.style.left = x;

	}	
	return div;
}

function closeOpenMenus(){
	for (var menuId in menuIndex) {
        menuIndex[menuId].closeIt();	
    }
    movebyTotal = 0;
}

