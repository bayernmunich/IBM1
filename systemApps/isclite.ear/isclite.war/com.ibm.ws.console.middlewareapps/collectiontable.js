// IBM Confidential OCO Source Material
// 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006, 2007
// The source code for this program is not published or otherwise divested
// of its trade secrets, irrespective of what has been deposited with the
// U.S. Copyright Office.

var hideOptions = true;

function showHideSubmitOptions(showMsg, hideMsg) {
	if (hideOptions) {
        document.getElementById("other").value = hideMsg;
        document.getElementById("optionsControl").style.display = "inline";
        hideOptions = false;
    } else {
        document.getElementById("other").value = showMsg;
        document.getElementById("optionsControl").style.display = "none";
        hideOptions = true;
    }
}

function setCheckBox(theID, entry) {
    var theForm = entry.form;
    var formlen = entry.form.length;

    for (var i = 0; i < formlen; i++) {
        var theitem = theForm.elements[i].name;
        var ischeck = theitem.indexOf("selectedObjectIds", 0) + 1;

        if (ischeck > 0) {
            var isEntry = theForm.elements[i].value.indexOf(theID, 0) + 1;
            if (isEntry > 0) {
                theForm.elements[i].checked = true;
                break;
            }
        }
    }
}

function getMiddlewareAppStatus(sUri, statusImage, sRefId) {
    statusImage.alt = pleaseWait;
    statusImage.title = pleaseWait;

    tmpsrc = statusImage.src;

    var my_date = new Date()
    dummy = my_date.getMilliseconds();
    sUri = sUri + "&dummy=" + dummy;

    xmlDoc = doXmlHttpRequest(sUri);
    // alert(xmlDoc);

    xmlDoc.replace(/\n/, '');

    for (j = xmlDoc.length - 1; j >= 0 && xmlDoc.charAt(j) <= " "; j--);

    xmlDoc = xmlDoc.substring(0, j + 1);

    for (i = 0; i < deployStatusArray.length; i++) {
        if (xmlDoc == deployStatusArray[i]) {
            xmlDoc = deployStatusArray[i];
            tmpsrc = deployStatusIconArray[i];
            break;
        }
    }

    // alert(xmlDoc);
    statusImage.alt = xmlDoc;
    statusImage.title = xmlDoc;
    statusImage.src = tmpsrc;

    dst = document.getElementById("deploymentStatusText" + sRefId);
    // alert(dst);
    dst.innerHTML = xmlDoc;
}
