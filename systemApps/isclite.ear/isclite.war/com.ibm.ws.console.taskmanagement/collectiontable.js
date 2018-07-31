// THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
// 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2004, 2012
// All Rights Reserved * Licensed Materials - Property of IBM
// US Government Users Restricted Rights - Use, duplication or disclosure
// restricted by GSA ADP Schedule Contract with IBM Corp.


function showHideSection(sectionId) {
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.taskmanagement/images/minus_sign.gif";
            }
        } else {
            document.getElementById(sectionId).style.display = "none";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.taskmanagement/images/plus_sign.gif";
            }
        }
    }
}

function addChart(target, name, metric) {

	if (metric == 'PROCESSCPU')
		metric = 'cpu';
	else if (metric == 'FREEMEMORY')
		metric = 'mem';

	var scope = 'ng';
	if (target == 'application')
		scope = 'app';
	else if (target == 'cluster')
		scope = 'clstr';
	else if (target == 'nodegroup')
		scope = 'ng';
	else if (target == 'dynamiccluster')
		scope = 'dc';
	else if (target == 'node')
		scope = 'node';
	else if (target == 'server')
		scope = 'srv';
	else if (target == 'serviceclass')
		scope = 'sc';
	else if (target == 'healthclass')
		scope = 'cell';


	var xmlhttp;
	if(window.ActiveXObject) {
		xmlhttp = new ActiveXObject('MSXML2.XMLHTTP');
	} else  {
		xmlhttp = new XMLHttpRequest();
	}
   sUri1 = chartCollectionUrl + "?new=true&scope=" + scope + "&name=" + name +"&datasets="+name+ "&subdomain=none&metric=" + metric + "&type=line&yaxis2=none&filter=none";
	var random = "&random=" + Math.random();
	sUri1 = sUri1 + random;	
	if(xmlhttp) {
		try {
			xmlhttp.open('GET', sUri1, false);
			xmlhttp.send(null);
			
		} catch(ex) {
			//something bad happened with the connection attempt, catch the exception
		}
	}
}

var taskPopup = null;
var taskIfr = null;


function createTaskPopup()
{
    document.writeln('<div id="taskPanel" style="z-index: 100;font-weight: normal; font-size:70.0%; font-family: Arial,Helvetica, sans-serif;  position:absolute; top:0; left:0; padding:5; background-color:white; border-color:black; border-style:solid; border-width:1;"><span class="provPanel" id="provPanelSpan"></span></div>');
	document.writeln('<iframe id="taskFrame" src="javascript:false;" scrolling="no" frameborder="0" style="position:absolute; top:0px; left:0px; display:none;" title="taskPopup"><html role="tooltip"><head><title>taskPanel</title></head></html></iframe>');

	taskPopup = document.getElementById("taskPanel");
	taskIfr = document.getElementById("taskFrame");
    hideTaskPopup();
    return taskPopup;
}


function displayTaskPopup(text, id)
{
	if(!taskPopup) return; //none exists...return before we get errors
	
	hideTaskPopup();
		
	var element = document.getElementById(id);
	populateTaskPopup([text]);
	if(!placeTaskPopup(element))
	return;
	showTaskPopup();
}

//returns true if the popup has been populated
function placeTaskPopup(element)
{
	var x = calculateLeft(element);
	var y = calculateTop(element);
	// add width and height but subtract the cell padding
	placeTaskPanel(x + element.offsetWidth-8, y + element.offsetHeight-8);
	return true;
}

function placeTaskPanel(x, y)
{
	if(taskPopup.style)
	{
		taskPopup.style.top = y;
		taskPopup.style.left = x;

 		taskIfr.style.top = taskPopup.style.top;
        taskIfr.style.left = taskPopup.style.left;
        taskIfr.style.width = taskPopup.offsetWidth;
        taskIfr.style.height = taskPopup.offsetHeight;
        taskIfr.style.zIndex = taskPopup.style.zIndex-1;

	}
	else
	{
		taskPopup.top = y;
		taskPopup.left = x;
	}
}

function hideTaskPopup()
{	
	if(taskPopup == null) return;
	
	//handle it in a browser by browser fashion
	if(taskPopup.style)
	{
		taskPopup.style.visibility = "hidden";
		taskIfr.style.visibility = "hidden";
		taskPopup.style.display = "none";
		taskIfr.style.display = "none";
	}
	else
	{
		taskPopup.visibility = "hide";
		taskIfr.visibility = "hide";
	}
}

function showTaskPopup()
{
	if(taskPopup == null) return;
	
	//handle it in a browser by browser fashion
	if(taskPopup.style)
	{
		taskPopup.style.visibility = "visible";
		taskPopup.style.display = "block";

		taskIfr.style.top = taskPopup.style.top;
		taskIfr.style.left = taskPopup.style.left;
		taskIfr.style.width = taskPopup.offsetWidth;
		taskIfr.style.height = taskPopup.offsetHeight;
		taskIfr.style.zIndex = taskPopup.style.zIndex-1;
		taskIfr.style.display = "block";	
		taskIfr.style.visibility = "visible";
	}
	else
	{
		taskPopup.visibility = "show";
	}
}

function populateTaskPopup(list)
{
	var text = "";
	var notFirst = false;
	for(var i = 0; i < list.length; i++)
	{
		if(notFirst) text += "<BR>";
		text += list[i];
		notFirst = true;
	}
	
	if(taskPopup.innerHTML)
	taskPopup.innerHTML = text;
	else if(taskPopup.layers)
	{
		var doc = taskPopup.layers["taskPanel"].document;
		doc.open();
		doc.write(text);
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

function showFullText(refid) {
    alltext = "fullText_"+refid;
    if (document.getElementById(alltext) != null) {
        document.getElementById("fullTextDiv").innerHTML = document.getElementById(alltext).title;
        ctop = calculateTop(document.getElementById(alltext));
        document.getElementById("fullTextDiv").style.top = ctop;
        document.getElementById("fullTextDiv").style.display = "block";
        document.getElementById("fullTextDiv").style.top = ctop - document.getElementById("fullTextDiv").offsetHeight;
    }

}

function hideFullText(refid) {
    alltext = "fullText_"+refid;
    if (document.getElementById(alltext) != null) {
        document.getElementById("fullTextDiv").style.display = "none";
    }

}



document.write("<div id='fullTextDiv' style=\"position:absolute;display:none;top:200;left:200;border:1px solid black;color:#000000;padding:5px;background-color:#FFFFFF;font-family: Verdana,sans-serif;font-size: 70%;z-index:100\">&nbsp;</div>");



function popUpLimitedWindow(winUrl) {
    var features = "height=500,width=600,alwaysLowered=0,alwaysRaised=0,channelmode=0,dependent=0,directories=0,fullscreen=0,hotkeys=1,location=0,menubar=0,resizable=1,scrollbars=1,status=0,titlebar=1,toolbar=0,z-lock=0";
    var parentWin = window.name;
    var newWin = open(winUrl, 'SupportingEvidence', features, parentWin);

}

function clearTMFilter(theForm) {
    document.getElementById("stateFilter").selectedIndex = 0;
    document.getElementById("severityFilter").selectedIndex = 0;
    iscDeselectAll(theForm);
    document.getElementById("searchAction").click();
}
