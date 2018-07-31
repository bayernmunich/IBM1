// Licensed Materials - Property of IBM
//
// 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp. 2007
// All Rights Reserved * Licensed Materials - Property of IBM
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

// this function initializes the jsp.
function initSelectAddDeleteLayout(prop) {
    //alert("in initSelectAddDeleteLayout");
    var finalList = document.getElementById(prop);
    if (finalList != null && finalList.length > 0) {
        for (var i = 0; i < finalList.options.length; i++) {
            finalList.options[i].selected = true;
        }
    }
}

// This function is for a reset button.
function resetSelectAddDeleteLayout(prop) {
    //alert("in resetSelectAddDeleteLayout");
    theform = document.forms[0];
    for (var i = 0; i < theform.length; i++) {
        var tempobj = theform.elements[i];
        if (tempobj.type != null) {
            if (tempobj.type.toLowerCase() == "checkbox" || tempobj.type.toLowerCase() == "radio") {
                tempobj.checked = tempobj.defaultChecked;
            } else if (tempobj.type.toLowerCase() == "text") {
                tempobj.value = tempobj.defaultValue;
            } else if (tempobj.type.toLowerCase() == "select-one" || tempobj.type.toLowerCase() == "select-multiple") {
                if (tempobj.name.indexOf("finalSelected") > -1) {
                    // do nothing - this is what we are trying to fix here
                } else {
                    for (var j = 0; j < tempobj.length; j++) {
                        tempobj.options[j].selected = tempobj.options[j].defaultSelected;
                    }
                }
            }
        }
    }

    var availList = document.getElementById("add" + prop + "OptionValues");
    var selectedList = document.getElementById("removeSelected" + prop);
    var origAvailList = document.getElementById("origOption" + prop);
    var origSelectedList = document.getElementById("origSelect" + prop);
    var finalSelectedList = document.getElementById("finalSelected" + prop);
    removeAllListOptions(availList);
    removeAllListOptions(selectedList);
    removeAllListOptions(finalSelectedList);
    copyList(origAvailList, availList, "no");
    copyList(origSelectedList, selectedList, "no");
    copyList(origSelectedList, finalSelectedList, "yes");

    return false;
}

// removes all options from a list
function removeAllListOptions(list){
    //alert("in removeAllListOptions");
    if (list != null && list.length > 0) {
        for (var i = list.length; i > 0; i--) {
            list.options[i-1] = null;
        }
    }
}

// copy options from one list to another.
function copyList(fromList, toList, select) {
    //alert("in copyList");
    if (fromList != null && toList != null && fromList.length > 0) {
        for (var i = 0; i < fromList.length; i++) {
            var newOpt = new Option(fromList.options[i].text, fromList.options[i].value);
            if (select == "yes") {
                newOpt.selected = true;
            }
            toList.options.add(newOpt);
        }
    }
}

// moves options from the left list to the right list
function addDualListProperty(prop){
    //alert("in addDualListProperty");
	var availList = document.getElementById("add" + prop + "OptionValues");
	var selectedList = document.getElementById("removeSelected" + prop);
	var finalList = document.getElementById("finalSelected" + prop);
	switchDualListSelected(availList, selectedList, finalList, "add");
	enableDisableOK("finalSelected" + prop);
} 

// move options from the right list to the left list.
function deleteDualListProperty(prop){
    //alert("in deleteDualListProperty");
	var availList = document.getElementById("add" + prop + "OptionValues");
	var selectedList = document.getElementById("removeSelected" + prop);
	var finalList = document.getElementById("finalSelected" + prop);
	switchDualListSelected(selectedList, availList, finalList, "delete");
	enableDisableOK("finalSelected" + prop);	
}

// function to actually move the options from one list to another
function switchDualListSelected(fromList, toList, finalList, action){
    //alert("in switchDualListSelected");
    if (fromList != null && toList != null && fromList.selectedIndex >= 0) {
       for (var i = 0; i < fromList.length; i++) {
          //alert("i = " + i);
          if (fromList.options[i].selected) {
              //alert("position " + i + " is selected");
              var curSelected = i; 
              //fromList.options[curSelected].selected = false;
              if (isDom) {
                 if (action == "delete") {
                    finalList.remove(curSelected);
                 } else {
                    var newOpt = new Option(fromList.options[curSelected].text, fromList.options[curSelected].value);
                    newOpt.selected = true;
                    finalList.add(newOpt, null);
                 }
                 toList.add(fromList.options[curSelected], null);
              } else {
                 if (action == "delete") {
                    finalList.options.remove(curSelected);
                 } else {
                    var newOpt = new Option(fromList.options[curSelected].text, fromList.options[curSelected].value);
                    newOpt.selected = true;
                    finalList.options.add(newOpt);
                 }
                 var newOpt = new Option(fromList.options[curSelected].text, fromList.options[curSelected].value);
                 toList.options.add(newOpt);
                 fromList.options.remove(curSelected);
             }
             i--;
         }
         else {
            //alert("position " + i + " is NOT selected");
         }
      }
   }
}

// sized the lists
function sizeSelectList(field, twoLists){
    //alert("in sizeSelectList");
    var size = "25em";
    if (!twoLists) {
       size = "50em";
    }
	var field = document.getElementById(field);
	if (field != null) {
	    field.style.width = size;
	}
}

// select everything in the list
function selectAllInList(field, value){
    //alert("in selectAllInList");
	var field = document.getElementById(field);
	if (field != null && field.length > 0) {
       for (var i = 0; i < field.options.length; i++) {
          field.options[i].selected = value;
       }
    }
}

// enables the OK button depending on if anything is in the right list
function enableDisableOK(listID){
    // based on the provided list, enable or disable the 
    // ok button.
    //alert("in EnableDisableOK");
	var list = document.getElementById(listID);
	var okButtons = document.getElementsByName("save");

	if (list != null && okButtons != null && okButtons.length > 0) {
	    okButtons[0].disabled = ((list.options.length > 0) ? false : true);
    }
}
