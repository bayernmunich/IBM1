// THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
// 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp. 2007,2008
// All Rights Reserved * Licensed Materials - Property of IBM
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

function initSelectAddDeleteLayout(prop) {
    var finalList = document.getElementById(prop);
    if (finalList != null && finalList.length > 0) {
        for (var i = 0; i < finalList.options.length; i++) {
            finalList.options[i].selected = true;
        }
    }
}

function resetSelectAddDeleteLayout(prop) {
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

function removeAllListOptions(list){
    if (list != null && list.length > 0) {
        for (var i = list.length; i > 0; i--) {
            list.options[i-1] = null;
        }
    }
}

function copyList(fromList, toList, select) {
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

function addDualListProperty(prop){
	var availList = document.getElementById("add" + prop + "OptionValues");
	var selectedList = document.getElementById("removeSelected" + prop);
	var finalList = document.getElementById("finalSelected" + prop);
	switchDualListSelected(availList, selectedList, finalList, "add");
} 

function deleteDualListProperty(prop){
	var availList = document.getElementById("add" + prop + "OptionValues");
	var selectedList = document.getElementById("removeSelected" + prop);
	var finalList = document.getElementById("finalSelected" + prop);
	switchDualListSelected(selectedList, availList, finalList, "delete");
}

function switchDualListSelected(fromList, toList, finalList, action){
    if (fromList != null && toList != null && fromList.selectedIndex >= 0) {
        for (var curSelected = fromList.length - 1; curSelected >=0; curSelected--) {
            if (fromList.options[curSelected].selected) {
		        fromList.options[curSelected].selected = false;
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
            }
        }
    }
}
