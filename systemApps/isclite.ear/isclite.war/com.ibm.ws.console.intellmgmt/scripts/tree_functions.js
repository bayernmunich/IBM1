// IBM Confidential OCO Source Material

var coreImagePath = "/ibm/console/images/";
var currFullSpec = "";
var currScope = "";
var currDefaultLevel = "";
var clearance = 15;
var availLevels = ["emerg_level", "alert_level", "critical_level", 
                   "error_level", "warning_level", "notice_level", 
                   "info_level", "debug_level", "all_level"];

function openClose(id) {
	var treeImg = document.getElementById("pm_"+id);
	
	if (treeImg.src.indexOf('lplus.gif') != -1) {
		openTree(id);
	} else {
		closeTree(id);
	}
}

function openTree(id) {
	var branch = document.getElementById("branch_"+id);
	var treeImg = document.getElementById("pm_"+id);

	if (branch !== null && treeImg !== null && treeImg.src.indexOf('lplus.gif') != -1) {
		treeImg.src = coreImagePath+"lminus.gif";
		branch.style.display = "block";
	}
}

function closeTree(id) {
	var branch = document.getElementById("branch_"+id);
	var treeImg = document.getElementById("pm_"+id);

	if (branch !== null && treeImg !== null && treeImg.src.indexOf('lminus.gif') != -1) {
		treeImg.src = coreImagePath+"lplus.gif";
		branch.style.display = "none";
	}
}

function setTraceSpec(level, currTraceText) {
	var currLevelObj = document.getElementById(currScope + "_" + level.toLowerCase() + "_level");
	if (currLevelObj != null && currLevelObj.name == "disabledLevel") {
		return;
	}
	
	if (level == "ALL"){
		level = "";
	} else {
		level = ":" + level;
	}
	var fullSpecText = document.getElementById(currTraceText);
	if (fullSpecText.value != "") {
		fullSpecText.value += ",";
	}
	fullSpecText.value += currFullSpec + level;
	hideContextMenu();
}

function openLevels(event, fullSpec, scope, level, defaultLevel) {
	if (currFullSpec != "" && currScope != "") {
		//Levels is already open, need to hide and reset before opening for new level
		hideContextMenu();
	}
	
	currFullSpec = fullSpec; 
	currScope = scope;
	
	highlightText("#FFFFFF", "#0000FF");
	
	if (!event) {
		event = window.event;
	}
	var x = event.clientX + document.body.scrollLeft;
	var y = event.clientY + document.body.scrollTop;
	
	var levels = document.getElementById(scope + "Context");
	if (levels) {
		if (level != "") {
			level = scope + "_" + level.toLowerCase() + "_level";
			disableLevels(scope, level);
		} else if (defaultLevel != "") {
			currDefaultLevel = scope + "_" + defaultLevel.toLowerCase() + "_level";
			setDefaultLevel(currDefaultLevel, "bold");
		}
		levels.style.display = "block";
		levels.style.top = y + "px";
		levels.style.left = x + "px";
	
		// scroll window to bring the popup menu in view
		var menuWidth = levels.style.width;
		if (menuWidth.indexOf('px') > -1) {
			menuWidth = menuWidth.substring(0, menuWidth.indexOf('px'));
		}
		var scrollByX = (event.clientX + parseInt(menuWidth, 10) + clearance) - document.body.clientWidth;
		var scrollByY = (event.clientY + levels.offsetHeight + clearance) - document.body.clientHeight;
		if (scrollByX < 0 || isNaN(scrollByX)) {scrollByX = 0;}
		if (scrollByY < 0 || isNaN(scrollByY)) {scrollByY = 0;}
		window.scrollBy(scrollByX, scrollByY);
	}
}

function wheresTheClick(event) {
	var elem = ""
	if (!event) {
		event = window.event;
		elem = event.srcElement;
	} else {
		elem = event.target;
	}
	
	if (elem.name == "treeitem") {
		//DO NOTHING HERE!!!!!!
	} else if (elem.name == "disabledLevel") {
		//DO NOTHING HERE!!!!!!
	} else if (elem.name == "enabledLevel") {
		//DO NOTHING HERE!!!!!!
	} else {
		hideContextMenu();
	}
}

function hideContextMenu() {
	hideLevels(currScope);
	highlightText("#0000FF", "#FFFFFF");
	setDefaultLevel(currDefaultLevel, "normal");
	enableLevels(currScope);
	currScope = "";
	currFullSpec = "";
	currDefaultLevel = "";
}

function hideLevels(scope) {
	if (scope) {
		var levels = document.getElementById(scope + "Context");
		if (levels) levels.style.display = "none";
	}
}

function highlightText(color, bkgd) {
	if (currFullSpec && currScope) {
		var specLink = document.getElementById(currScope + "_" + currFullSpec);
		if (specLink) {
			specLink.style.color = color;
			specLink.style.backgroundColor = bkgd;
		}
	}
}


function setDefaultLevel(defaultLevel, fontWeight) {
	if (defaultLevel) {
		var elem = document.getElementById(defaultLevel);
		if (elem) elem.style.fontWeight = fontWeight;
	}
}

function disableLevels(scope, level) {
	for (var i = 0; i < availLevels.length; i++) {
		var id = scope + "_" + availLevels[i];
		var elem = document.getElementById(id);
		if (elem && id != level) {
			elem.className = "levelitemoff table-text";
			elem.name = "disabledLevel";
		}
	}
	
}

function enableLevels(scope) {
	if (scope) {
		for (var i = 0; i < availLevels.length; i++) {
			var id = scope + "_" + availLevels[i];
			var elem = document.getElementById(id);
			if (elem && elem.className == "levelitemoff table-text") {
				elem.className = "levelitem table-text"
				elem.name = "enabledLevel";
			}
		}
	}
}
