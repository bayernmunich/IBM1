/* THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
 * 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp. 1997, 2007
 * All Rights Reserved * Licensed Materials - Property of IBM
 * US Government Users Restricted Rights - Use, duplication or disclosure
 * restricted by GSA ADP Schedule Contract with IBM Corp.
 */

 function enableDisableExt(controlSet,origin) {

    if (origin != "reset") {
        enableDisableArray[enableDisableArray.length] = controlSet;
    }

    controlArray = controlSet.split(",");

    // set up variable default values
    disStatus = false;
    textStyle = "textEntry";
    textColor = "#000000";
    textAreaStyle = "textAreaEntry";

    // loop through controls to assign enablement/disablement to children
    for (i=0;i<controlArray.length;i++) {

        tmp = controlArray[i];

        cArray = tmp.split(":");

        // if this control is a master of 1 or more controls
        if (cArray.length > 1) {

            // master control is at 0
            masterControlId = cArray[0];
            var flip = false;
            if (masterControlId.substr(0,1) == "!") {
            	masterControlId = masterControlId.substr(1);
            	flip = true;
            }
            if (document.getElementById (masterControlId)) {
                 masterControlStatus = document.getElementById(masterControlId).checked;
                 masterControlStatusdisabled = document.getElementById(masterControlId).disabled;
	            if (flip) {
	            	masterControlStatus = !masterControlStatus;
	            }
            }

            //alert("master = "+masterControlId + "   " +masterControlStatus);

            // determine variable values for children based on master attribute
            // CHECKED attribute applies to both checkbox and radio buttons
            // For radio buttons, make sure ID attribute is assigned to the value of that
            // specific radio button
            if (masterControlStatus && (!masterControlStatusdisabled)) {
                disStatus = false;
                textStyle = "textEntry";
                textColor = "#000000";
                textAreaStyle = "textAreaEntry";
            } else {
                disStatus = true;
                textStyle = "textEntryReadOnly";
                textColor = "#CCCCCC";
                textAreaStyle = "textAreaEntryReadOnly";
            }
			
            for (j=1;j<cArray.length;j++) {
				
                if (document.getElementById(cArray[j])) {
                	
                    // If child control is required, then "+Required" follows child control id
                    // If child control is long, then "+Long" follows
                    rcArray = cArray[j].split("+");
                    if (rcArray.length > 1) {
                        textStyle = textStyle+rcArray[1];
                        cArray[j] = rcArray[0];
                    }

                    // assign child control styles according to type
                    //alert(document.getElementById(cArray[j]).style.width);
                    //alert(document.getElementById(cArray[j]).type);
                    if ((document.getElementById(cArray[j]).type == "text") ||
                        (document.getElementById(cArray[j]).type == "password")) {
                        document.getElementById(cArray[j]).className = textStyle;
                    }
                    if (document.getElementById(cArray[j]).type == "textarea") {
                        document.getElementById(cArray[j]).className = textAreaStyle;
                    }
                    if (isDom) {
                        document.getElementById(cArray[j]).parentNode.style.color = textColor;
                    } else {
                        document.getElementById(cArray[j]).parentElement.style.color = textColor;
                    }
                    document.getElementById(cArray[j]).disabled = disStatus;
                                    
                } else {
                    // document.getElementById(cArray[j]) does not exist
                    // Check for existence of document.getElementById(cArray[j] + '0')
                    // and document.getElementById(cArray[j] + '1') and so on until
                    // the object is not found
            		for (k=0;true;k++) {
            			var elem = cArray[j]+k;
            			
						if (document.getElementById(elem)) {
		                    if ((document.getElementById(elem).type == "text") ||
        		                (document.getElementById(elem).type == "password")) {
                		        document.getElementById(elem).className = textStyle;
                    		}
                    		if (document.getElementById(elem).type == "textarea") {
                        		document.getElementById(elem).className = textAreaStyle;
                    		}
                    		if (isDom) {
                        		document.getElementById(elem).parentNode.style.color = textColor;
                    		} else {
                        		document.getElementById(elem).parentElement.style.color = textColor;
                    		}
                    		document.getElementById(elem).disabled = disStatus;
						} else {
							break;
						}
            		}
            	}
            } 


        }

    }
}