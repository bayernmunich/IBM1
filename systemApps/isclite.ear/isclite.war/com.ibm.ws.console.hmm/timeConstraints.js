// IBM Confidential OCO Source Material
// 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005
// The source code for this program is not published or otherwise divested
// of its trade secrets, irrespective of what has been deposited with the
// U.S. Copyright Office.

var FIRST_CONSTRAINT_INDEX=1; //0 is buttons, 1 is TH row, 2 is first data row
var TABLE_ID = "timeConstraints";
var TCBODY_ID = "tcBody";
var numRows = -1;
var nextRowIdNum = 0;

var tmp;
var DAYS = ["sunday", "monday", "tuesday", "wednesday", "thursday" , "friday", "saturday"];

if (!IS_SUNDAY_FIRST_DAY_OF_WEEK)
   DAYS = ["monday", "tuesday", "wednesday", "thursday" , "friday", "saturday", "sunday"];

var HOURS = new Array(24);
populateCountArray(24, HOURS);
function populateCountArray(numCells, array){
	for (var h = 0; h < numCells; h++){
		tmp = "";
		if (h < 10)
			tmp = "0";
		tmp = tmp + h;		
		array[h] = new SelectOption(tmp, tmp);
	}
}

var MINUTES = new Array(60);
populateCountArray(60, MINUTES);

function setInitialNumRows(){
	var tctable = document.getElementById(TABLE_ID);
	var body = document.getElementById(TCBODY_ID);
	var trs = body.getElementsByTagName("TR");
	numRows = trs.length - FIRST_CONSTRAINT_INDEX;
	nextRowIdNum = numRows;
}

function removeConstraints(){
		if (IS_READ_ONLY)
			return;
        var tr;
        var tctable = document.getElementById(TABLE_ID);
        var body = document.getElementById(TCBODY_ID);
        var trs = body.getElementsByTagName("TR");
        var td;
        var element;
        var rowNum;
        var thisNum;
        for (var rowNum = FIRST_CONSTRAINT_INDEX; rowNum < trs.length; rowNum++){
                tr = trs.item(rowNum);
                element  = tr.getElementsByTagName("INPUT")[0];
                thisNum = getRowNumber(element);
                if (isRemoveChecked(thisNum) && (numRows - 1) > 0){
                    numRows--;
                    body.removeChild(tr);
                }
		
        }
}

function isRemoveChecked(rowNum){
        var name = getFormElemName(rowNum, "remove");
        var box = document.HMMDetailForm[name];
        return (box && box.checked);
}


function getRowNumber(elem){
        var name = elem.name;
        if (!name)
        		return -1;
        var firstBracket = name.indexOf("[");
        var secondBracket = name.indexOf("]");
        if (firstBracket < 0 || secondBracket < 0)
        		return -1;
        var numStr = name.substring(firstBracket + 1, secondBracket);
        if (!numStr)
        		return -1;
        return parseInt(numStr);
}

function changeRowNum(oldNum, newNum){
	var form = document.HMMDetailForm;
	var oldStartHourName = getFormElemName(oldNum, "startHour");
	var oldStartMinuteName = getFormElemName(oldNum, "startMinute");
	var oldEndHourName = getFormElemName(oldNum, "endHour");
	var oldEndMinuteName = getFormElemName(oldNum, "endMinute");
	for (var i = 0; i < DAYS.length; i++){
		days[i] = form[getFormElemName(oldNum, DAYS[i])];
	}
	
	var startHours = form[oldStartHourName];
	var endHours = form[oldEndHourName];
	var startMinutes = form[oldStartMinuteName];
	var endMinutes = form[getFormElemName(oldNum, "endMinute")];
	var remove = form[getFormElemName(oldNum, "remove")];
	var days = new Array(7);
		
}

function addConstraint(startHour, startMinute, endHour, endMinute){
	if (IS_READ_ONLY){
		return;
	}
	if (numRows == -1)
		setInitialNumRows();
	var form = document.HMMDetailForm;
	var rowNum = nextRowIdNum;
	var tctable = document.getElementById(TABLE_ID);
	var body = document.getElementById(TCBODY_ID);
	var newRow = document.createElement("TR");
	var styleClass="tcRow";
	//newRow.setAttribute("class", styleClass);
	var tr = document.createElement("TR");
	var td;	
	
	//add remove checkbox
	td = document.createElement("TD");
	td.setAttribute("class", styleClass);
	td.style.backgroundColor="#F7F7F7";
	var remName = getFormElemName(rowNum, "remove");
	var remCheckBox = createCheckBox(remName, false, form);
	var remLabelName = remName + ".label";
	var remLabel = createHiddenLabel(remLabelName, "Select", remName, form);
	addCheckBoxToTdAndForm(remCheckBox, remLabel, td, form, remName, remLabelName);
	tr.appendChild(td);
	
	//add start time
	td = document.createElement("TD");
	td.style.backgroundColor="#F7F7F7";
	td.style.paddingLeft="7px";
	//td.setAttribute("class", styleClass);
	td.style.whiteSpace="nowrap";
	var hoursName = getFormElemName(rowNum, "startHour");
	var hoursLabelName = hoursName + ".label";
	var minutesName = getFormElemName(rowNum, "startMinute");
	var minutesLabelName = minutesName + ".label";
	var startHours = createSelectBox(HOURS, hoursName, startHour);
	var startHoursLabel = createHiddenLabel(hoursLabelName, "Start", hoursName, form);
	//startHours.setAttribute("class", styleClass);
	var startMinutes = createSelectBox(MINUTES, minutesName, startMinute);
	var startMinutesLabel = createHiddenLabel(minutesLabelName, "Start", minutesName, form);
	//startMinutes.setAttribute("class", styleClass);
	addTimeToTdAndForm(startHours, startHoursLabel, startMinutes, startMinutesLabel, td, form, hoursName, hoursLabelName, minutesName, minutesLabelName);
	tr.appendChild(td);
	
	//add end time
	td = document.createElement("TD");
	td.style.paddingLeft="7px";
	td.style.backgroundColor="#F7F7F7";
	//td.setAttribute("class", styleClass);
	td.style.whiteSpace="nowrap";
	hoursName = getFormElemName(rowNum, "endHour");
	hoursLabelName = hoursName + ".label";
	minutesName = getFormElemName(rowNum, "endMinute");
	minutesLabelName = minutesName + ".label";
	var endHours = createSelectBox(HOURS, hoursName, endHour);
	var endHoursLabel = createHiddenLabel(hoursLabelName, "End", hoursName, form);
	var endMinutes = createSelectBox(MINUTES, minutesName, endMinute);
	var endMinutesLabel = createHiddenLabel(minutesLabelName, "End", minutesName, form);
	addTimeToTdAndForm(endHours, endHoursLabel, endMinutes, endMinutesLabel, td, form, hoursName, hoursLabelName, minutesName, minutesLabelName);
	tr.appendChild(td);
	
	//add days
	var dayName, dayCheckBox, dayLabelName, dayLabel, dayKey;
	for (var i = 0; i < DAYS.length; i++){
		dayName = getFormElemName(rowNum, DAYS[i]);
		dayLabelName = dayName + ".label";
		dayKey = DAYS[i];
		td = document.createElement("TD");
		if (i == 0)
			td.style.paddingLeft="7px";
		td.style.backgroundColor="#F7F7F7";
		td.setAttribute("class", styleClass);
		dayCheckBox = createCheckBox(dayName, false, form);
		dayLabel = createHiddenLabel(dayLabelName, dayKey, dayName, form);
		addCheckBoxToTdAndForm(dayCheckBox, dayLabel, td, form, dayName, dayLabelName);
		tr.appendChild(td);			
	}	
	
	numRows++;
	nextRowIdNum++;
	body.appendChild(tr);
}

function getFormElemName(rowNum, property){
	return "constraint[" + rowNum + "]." + property;	
}

function addTimeToTdAndForm(hours, hoursLabel, minutes, minutesLabel, td, form, hoursName, hoursLabelName, minutesName, minutesLabelName){
	td.appendChild(hoursLabel);
	td.appendChild(hours);
	var span = document.createElement("SPAN");
	//var colon = '<bean:message key="timeconstraints.colon"/>';
	var colon = ':';
	//span.appendChild(document.createTextNode(":"));
	span.innerHTML = colon;
	span.setAttribute("style", "font-weight:bold; font-family:Arial,Helvetica,sans-serif; font-size:100%");
	td.appendChild(span);
	td.appendChild(minutesLabel);
	td.appendChild(minutes);
	var hoursLabelObj = document.getElementById(hoursLabelName);
	form[hoursLabelName] = hoursLabelObj;
	var hoursObj = document.getElementById(hoursName);
	form[hoursName] = hoursObj;
	var minutesLabelObj = document.getElementById(minutesLabelName);
	form[minutesLabelName]=minutesLabelObj;
	var minutesObj = document.getElementById(minutesName);
	form[minutesName]=minutesObj;
}

function addCheckBoxToTdAndForm(boxSpan, labelSpan, td, form, boxName, labelName){
	td.appendChild(boxSpan);
	var obj = document.getElementById(boxName);
	form[boxName]=obj;	
	td.appendChild(labelSpan);
	var obj = document.getElementById(labelName);
	form[labelName]=obj;
}

function createSelectBox(values, name, selected){
	var span = document.createElement("SPAN");
	var selectBegin = '<SELECT size="1" class="tcRow" ' +'" id="' + name + '" name="'+name+'">';
	var option;
	var value;
	var options = "";
	
	for (var i = 0; values && (i < values.length); i++){
		value = values[i];
		option = '<OPTION value="' + value.value + '"';
		if (value.value == selected)
			option += " SELECTED ";
		option += '>' + value.text + '</OPTION>';
		options += option;			
	}
	
	var selectEnd = "</SELECT>";
	span.innerHTML = selectBegin + options + selectEnd;
	
	return span;
}

function createCheckBox(name, isChecked, form){
	var span = document.createElement("SPAN");
	var checkedText = "";
	if (isChecked)
		checkedText = " CHECKED ";
	var checkbox = '<input type="checkbox" '+ checkedText +'" id="' + name+'" name="' + name + '"/>';
	var option;
	var value;
	var options = "";
	var option;

	span.innerHTML = checkbox;
	return span;
}

function createHiddenLabel(name, key, item, form) {
	var span = document.createElement("SPAN");
	//var message = '<bean:message key="' + key + '"/>';
	//var label = '<label id="' + name + '" class="hidden" for="' + item + '" title="' + message +'">' + message + '</label>';
	var message = key;
	var label = '<label id="' + name + '" class="hidden" for="' + item + '" title="' + message +'">' + message + '</label>';
	span.innerHTML = label;
	return span;
}

function SelectOption(text, value){
	this.text = text;
	this.value = value;	
}

function isEven(x){
	return ( (x/2) != (x-1)/2 );		
}
