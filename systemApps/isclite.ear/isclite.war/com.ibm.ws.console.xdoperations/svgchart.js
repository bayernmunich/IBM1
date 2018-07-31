// IBM Confidential OCO Source Material
// 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005
// The source code for this program is not published or otherwise divested
// of its trade secrets, irrespective of what has been deposited with the
// U.S. Copyright Office.

var svgAutoInstallPage="http://www.adobe.com/svg/viewer/install/auto";
var adobeSVGPage="http://www.adobe.com/svg";

var chartPopup = null;
var chartIfr = null;

function createChartPopup() {
    document.writeln('<div id="chartPanel" style="z-index: 100;font-weight: normal; font-size:70.0%; font-family: Arial,Helvetica, sans-serif;  position:absolute; top:0; left:0; padding:5; background-color:white; border-color:black; border-style:solid; border-width:1;"><span class="provPanel" id="provPanelSpan"></span></div>');
	document.writeln('<iframe id="chartFrame" src="javascript:false;" scrolling="no" frameborder="0" style="position:absolute; top:0px; left:0px; display:none;"></iframe>');
       
	chartPopup = document.getElementById("chartPanel");
	chartIfr = document.getElementById("chartFrame");
    hideChartPopup();
    return chartPopup;
}


function displayChartPopup(text, id) {
	if(!chartPopup) return; //none exists...return before we get errors
	
	hideChartPopup();
		
	var element = document.getElementById(id);
	populateChartPopup([text]);
	if(!placeChartPopup(element))
	return;
	showChartPopup();
}

//returns true if the popup has been populated
function placeChartPopup(element) {
	var x = calculateLeft(element);
	var y = calculateTop(element);
	
	var windowWidth, windowHeight;
	if (document.layers){
   		windowWidth=window.outerWidth;
  		windowHeight=window.outerHeight;
	}
	if (document.all){
   		windowWidth=document.body.clientWidth;
   		windowHeight=document.body.clientHeight;
	}

	var temp = x + element.offsetWidth + 27;
	if (temp >= windowWidth) {
		x = x-chartPopup.offsetWidth;
	} else {
		x = x + element.offsetWidth - 8;
	}
	
	// add width and height but subtract the cell padding
	placeChartPanel(x, y + element.offsetHeight-8);
	return true;
}

function placeChartPanel(x, y) {
	if(chartPopup.style) {
		chartPopup.style.top = y;
		chartPopup.style.left = x;

 		chartIfr.style.top = chartPopup.style.top;
        chartIfr.style.left = chartPopup.style.left;
        chartIfr.style.width = chartPopup.offsetWidth;
        chartIfr.style.height = chartPopup.offsetHeight;
        chartIfr.style.zIndex = chartPopup.style.zIndex-1;
	} else {
		chartPopup.top = y;
		chartPopup.left = x;
	}
}

function hideChartPopup() {	
	if(chartPopup == null) return;
	
	//handle it in a browser by browser fashion
	if(chartPopup.style)
	{
		chartPopup.style.visibility = "hidden";
		chartIfr.style.visibility = "hidden";
		chartPopup.style.display = "none";
		chartIfr.style.display = "none";
	}
	else 
	{
		chartPopup.visibility = "hide";
		chartIfr.visibility = "hide";
	}
}

function showChartPopup() {
	if(chartPopup == null) return;
	
	//handle it in a browser by browser fashion
	if(chartPopup.style) {
		chartPopup.style.visibility = "visible";
		chartPopup.style.display = "block";

		chartIfr.style.top = chartPopup.style.top;
		chartIfr.style.left = chartPopup.style.left;
		chartIfr.style.width = chartPopup.offsetWidth;
		chartIfr.style.height = chartPopup.offsetHeight;
		chartIfr.style.zIndex = chartPopup.style.zIndex-1;
		chartIfr.style.display = "block";	
		chartIfr.style.visibility = "visible";
	} else {
		chartPopup.visibility = "show";
	}
}

function populateChartPopup(list) {
	var text = "";
	var notFirst = false;
	for(var i = 0; i < list.length; i++) {
		if(notFirst) text += "<BR>";
		text += list[i];
		notFirst = true;
	}
	
	if(chartPopup.innerHTML)
		chartPopup.innerHTML = text;
	else if(chartPopup.layers) {
		var doc = chartPopup.layers["chartPanel"].document;
		doc.open();
		doc.write(text);
	}
}

function showHideSection(sectionId) {
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.xdoperations/images/minus_sign.gif";
            }
        } else {
            document.getElementById(sectionId).style.display = "none";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.xdoperations/images/plus_sign.gif";
            }
        }
    }
}


var ELEMENT_CHART = "chart";
function ChartMenuCreator(id, level){
	this.level = level;
	this.id = id;
	
	this.create = function(){
		var name = "ChartMenu";
		var contents = new Object();
		var menuAction;

		var graphWindow = window.parent.graphFrame;
		var cellWidth, totalWidth;
		if (graphWindow) {
			var table = graphWindow.document.getElementById("collectionTable");
			var chartTable = graphWindow.document.getElementById("chartTable");
			if (table) {	
				var firstCell = table.rows[0].cells[0];
				cellWidth = firstCell.offsetWidth;
				//alert('cellWidth=' + cellWidth);
				if (chartTable) {
					totalWidth = chartTable.offsetWidth;
					//alert('totalWidth=' + totalWidth);
				}
			}
		}
		
		if (parent.name == 'detail')
			currWindow = 'graphFrame';
			
		var state = 'open';
		if (document.getElementById('com_ibm_ws_chart_settings').style.display == "none") {
			state = 'closed';
		}
	
		menuAction = new MenuAction("javascript:launchChart('" + this.id + "', cellWidth, totalWidth);", "");
		contents[CHART_LAUNCH] = menuAction
		
		menuAction = new MenuAction(chartCollectionUrl + "?new=true&scope=cell&name=-- Select Name --&subdomain=sc&metric=rt&type=line&yaxis2=none&filter=none&currWindow=" + currwindow + "&cellWidth=" + cellWidth + "&totalWidth=" + totalWidth + "&state=" + state, "");
		contents[CHART_TAB] = menuAction;
	
		menuAction = new MenuAction("javascript:openNewChart(cellWidth, totalWidth);", "");
		contents[CHART_WINDOW] = menuAction;
			
		var menu = new Menu(contents, name, id, level);
		return menu;
	}
}

function launchChart(refId, cellWidth, totalWidth) {
	var date = new Date();
	var mins = date.getMinutes();
	//alert("startTime=" + mins);
	
	var newWinName = user + 'graphFrame' + Math.round(Math.random()*100);

  	var features = "height=700,width=700,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";

  	var parentWin = currwindow;

	var url = detailActionUrl + "?single=true&removeRefId=" + refId + "&currWindow=" + newWinName + "&cellWidth=" + cellWidth + "&totalWidth=" + totalWidth + "&scope=" + scope + "&name=" + name + "&subdomain=" + subdomain + "&metric=" + metric + "&type=" + type + "&yaxis2=" + yaxis2 + "&filter=" + filter + "&saveAsDefaultSize=" + saveAsDefaultSize + "&showShapes=" + showShapes + "&showGoals=" + showGoals;
	
	var newmins = mins;
	while (newmins < mins + 1) {
		//alert("refreshTime="+newmins);
		if (!isReloading) {	
			//alert('not reloading');
			var newWin = window.open(url, newWinName, features, parentWin);	
			tmp = new Date();
			var test = tmp.getSeconds();
			var check = test;
			while (check < test + 2) {
				tmp = new Date();
				check = tmp.getSeconds();
			}
			newWin.opener.location = "/ibm/console/com.ibm.ws.console.xdruntime/chart.jsp?initial=true&currWindow=graphFrame";
			break;
		}
		tmp = new Date();
		newmins = tmp.getMinutes();
	}
}

function openNewChart(cellWidth, totalWidth) {
	var newWinName = 'graphFrame' + Math.round(Math.random()*100);
	
 	var features = "height=700,width=700,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";

	var parentWin = currwindow;

	var url = detailActionUrl + "?single=true&scope=ng&name=-- Select Name --&subdomain=sc&metric=rt&type=line&yaxis2=none&filter=none&currWindow=" + newWinName + "&cellWidth=" + cellWidth + "&totalWidth=" + totalWidth;

	var newWin = open(url, newWinName, features, parentWin); 
}

function createChartMenuOnEvent(element, id, e){
	if (!e)
		e = event;
	e.cancelBubble=true;
	
	var x = calculateLeft(element);
	var y = calculateTop(element);
	createChartMenu(x + element.offsetWidth - 8, y + element.offsetHeight - 8, id);
}

function createChartMenu(x, y, id){
	var type = ELEMENT_CHART;
	
	var constructor = ChartMenuCreator
	if (!constructor)
		return;
		
	var menuCreator = new constructor(id, 0);	
	var menu = menuCreator.create();
	if (menu) {
		menu.display(x, y);
	}
}

function calculateTop(element) {
	var etop = element.offsetTop;
	var eparent = element.offsetParent;
	
	while (eparent != null) {
		etop += eparent.offsetTop;
		eparent = eparent.offsetParent;
	}	
	
	return etop;
}

function calculateLeft(element) {
	var eleft = element.offsetLeft;
	var eparent = element.offsetParent;
	
	while (eparent != null) {
		eleft += eparent.offsetLeft;
		eparent = eparent.offsetParent;
	}	
		
	return eleft;
}
