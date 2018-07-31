/* THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
 * 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006
 * All Rights Reserved * Licensed Materials - Property of IBM
 * US Government Users Restricted Rights - Use, duplication or disclosure
 * restricted by GSA ADP Schedule Contract with IBM Corp.
 */


var enableDisableArray = new Array();
var currentField = "";
var cellwide = false;
var scrollHeight;

var isNav4 = false;
var isIE = false;
var isDom = false;


//document.onclick = setTopVarOff;
//document.onkeypress = setTopVarOff;
//document.onmouseover = whatObjectOn;
//document.onmouseout = whatObjectOff;
//document.onfocus = setTopVarOff;
//document.onmouseup = setTopVarOff;


window.onload = assignTabIndex;
window.onscroll=floatHelpPortlet;
window.onresize = doResize;

try {
    pleaseWait = pleaseWait;
} catch(e) {
    pleaseWait = top.pleaseWait;
}


var foropera = window.navigator.userAgent.toLowerCase();
var itsopera = foropera.indexOf("opera",0) + 1;
var itsgecko = foropera.indexOf("gecko",0) + 1;
var itsmozillacompat = foropera.indexOf("mozilla",0) + 1;
var itsmsie = foropera.indexOf("msie",0) + 1;


        if (itsopera > 0){
                //thebrowser = 3;
                //alert("its opera");
                isNav4 = true
        }


        if (itsmozillacompat > 0){
                //alert("its mozilla compatible");
                if (itsgecko > 0) {
                       //thebrowser = 4
                       // alert("its gecko");
                       isIE= true
                       isDom = true
                       document.all = document.getElementsByTagName("*");

                }
                else if (itsmsie > 0) {
                      //  alert("its msie");
                       // thebrowser = 2
                        isIE = true
                }
                else {
                        if (parseInt(navigator.appVersion) < 5) {
                                // alert("its ns4.x")
                                //thebrowser = 1
                                isNav4 = true
                        }
                        else {
                                //thebrowser = 2
                                isIE = true
                        }
                }

   }



// Added because Mozilla wants to use the TBODY and table-row-group to show/hide table rows
if (isDom) {
    showIt = "table-row-group";
} else {
    showIt = "inline";
}

// Preferences for various com_ibm_ws_ sections
var com_ibm_ws_inlineMessages = "inline";
var com_ibm_ws_scopeTable = "none";
var com_ibm_ws_prefsTable = "none";
var com_ibm_ca_prefsTable = "none";

var showWaitButtons = ["nextAction","previousAction","installAction","button.save","button.start","button.stop","button.install","button.uninstall","button.new","button.delete", "appmanagement.button.confirm.ok", "TAMapply", "TAMsave", "JCALifeCycleSelect.button.manage", "JCALifeCycleSelect.button.pause", "JCALifeCycleSelect.button.resume"]

function arrayContains(theArray,value) {

        len = theArray.length;
        for (i=0;i<len;i++) {
                if (theArray[i] == value) {
                        //alert("true");
                        return true;
                }
        }
        return false;
}


function setTopVarOn(e) {
        top.isloaded = 0;
        if (isNav4) { routeEvent(e) }


}

function doResize(e) {
     var oldScrollHeight = scrollHeight;

     scrollHeight = document.body.scrollHeight; 

     if (document.body.scrollHeight < oldScrollHeight) {
          floatHelpPortlet (e);
     }
}

function setTopVarOff(e) {



        top.isloaded = 1;

        var thebutton = "";
        var buttonObj = "";
        var isDisabled = false;

        if (isDom) {
            thebutton = e.target.name;
            buttonObj = e.target;
        } else {
            e = event;
            thebutton = e.srcElement.name;
            buttonObj = e.srcElement;
        }
        try {
            isDisabled = buttonObj.disabled;
        } catch (evt) { }


        if (!isDisabled) {
            if (isDom) {
                    if (arrayContains(showWaitButtons,thebutton)) {
                            document.all["progress"].style.top = e.clientY+document.body.scrollTop;
                            document.all["progress"].style.left = e.clientX+document.body.scrollLeft;
                            document.all["progress"].style.display = "block";
                    }
            }
            else {
                    if (arrayContains(showWaitButtons,thebutton)) {
                            document.all["progress"].style.pixelTop = e.clientY+document.body.scrollTop;
                            document.all["progress"].style.pixelLeft = e.clientX+document.body.scrollLeft;
                            document.all["progress"].style.display = "block";
                    }
            }

        }


        showAlt(e);

}





function whatObjectOn(e) {
    if (isDom) {
            obj = e.target;
    }
    else {
            e = event;
            obj = e.srcElement;
    }
    if (obj != null) {
        if ((obj.tagName == "LI") && (obj.className == "nav-bullet") && (document.getElementById("fieldHelpPortlet") != null)) {
                //obj.style.color = "black";
                obj.style.cursor = "help";
        // Inserted for the summary view LI's
        } else if ((obj.parentNode.parentNode != null) && (obj.parentNode.parentNode.tagName == "LI") && (obj.tagName == "A") && (document.getElementById("fieldHelpPortlet") != null)) {
                //obj.style.color = "black";
                obj.parentNode.style.cursor = "help";
        }
        else {
            if (((obj.tagName == "LABEL") || (obj.tagName == "LEGEND")) && (document.getElementById("fieldHelpPortlet") != null)) {

                if ((obj.getAttribute("TITLE")) || (obj.getAttribute("DESC")) || (obj.getAttribute("title")) || (obj.getAttribute("desc"))) {
                    if (obj.getAttribute("TITLE").indexOf(selectText+":") < 0) {
                        obj.style.cursor = "help";
                    }
                }
            }
        }
    }
}
function whatObjectOff(e) {
    if (isDom) {
            obj = e.target;
    }
    else {
            e = event;
            obj = e.srcElement;
    }
    if (obj != null) {
        if ((obj.tagName == "LI") && (obj.className == "nav-bullet")) {
            //showAlt(e);
            obj.style.color = "#BCBCBC";
            //obj.style.listStyleImage = "none";
            //obj.style.backgroundImage = "none";

        }
    }
}

var ProgressImage = new Image();
ProgressImage.src = "/ibm/console/images/appInstall_animated.gif";





function floatHelpPortlet(e) {
    var helpPortlet = document.getElementById("wasHelpPortletPos");
    var currentPos;

    if (helpPortlet != null) {
        var height = helpPortlet.scrollHeight;

        if (isDom) {
            currentPos = parseInt(helpPortlet.style.top);
            if (currentPos != document.body.scrollTop) {
                helpPortlet.style.visibility = "hidden";
            }

            if (isNaN (currentPos)) {
                currentPos = 0;
            }

            if ((height + document.body.scrollTop + federationAdder) < scrollHeight) {
			//WSC Console: needed for Federation
                helpPortlet.style.top = document.body.scrollTop + federationAdder;
            }

            if (document.body.scrollTop > 20) {
                helpPortlet.style.position = "relative";
            }
            setTimeout('document.getElementById("wasHelpPortletPos").style.visibility = "visible"',750);

        } else {
            currentPos = helpPortlet.style.pixelTop;
            if (currentPos != document.body.scrollTop) {
                helpPortlet.style.visibility = "hidden";

                //document.getElementById("wasPDPortletPos").style.visibility = "hidden";
            }

            if ((height + document.body.scrollTop + federationAdder) < scrollHeight) {
                //WSC Console: needed for Federation
                helpPortlet.style.pixelTop = document.body.scrollTop + federationAdder;
            }

            //document.getElementById("wasPDPortletPos").style.pixelTop = document.getElementById("wasHelpPortletPos").style.pixelHeight + document.body.scrollTop;

            setTimeout('document.getElementById("wasHelpPortletPos").style.visibility = "visible"',750);

            //setTimeout('document.getElementById("wasPDPortletPos").style.visibility = "visible"',750);

        }

    }

}


function appInstallWaitShow() {
        if (isDom) {
                        document.all["progress"].style.display = "block";
        } else if (isNav4) {
                        document.layers["progress"].visibility="show";
        }
        else {
                        document.all["progress"].style.display = "block";
        }

}

function appInstallWaitHide() {

        if (isDom) {
                        document.all["progress"].style.display = "none";
        } else if (isNav4) {
                        document.layers["progress"].visibility="hide";
        }
        else {
                        document.all["progress"].style.display = "none";
        }

}

function findPageHelpLink(linkText) {
    linkLength = document.links.length;
    fallout = true;
    for (t=0;t<linkLength;t++) {
        if (document.links[t].getAttribute("target") == "WAS_help") {
            document.write('<a href="'+document.links[t].getAttribute("href")+'" target="WAS_help">');
            document.write(linkText);
            document.write('</a>');
            fallout = false;
            break;
        }
    }
    if (fallout) {
        document.write(statusUnavailable);
    }
}

function findTaskHelpLink(pageId,linkText) {

    if (document.getElementById("taskHelpDiv") != null) {
        if (document.getElementById("taskHelpDivImg").src.indexOf("collapsed") > -1) {
            document.getElementById("taskHelpDiv").style.display = showIt;
            if (document.getElementById("taskHelpDivImg")) {
                document.getElementById("taskHelpDivImg").src = "/ibm/console/images/arrow_expanded.gif";
            }

            document.getElementById("taskHelpDiv").style.height = "200";

            document.getElementById("taskHelpIFrame").height = "100%";
            state = "inline";

        } else {
            document.getElementById("taskHelpDiv").style.display = "none";
            if (document.getElementById("taskHelpDivImg")) {
                document.getElementById("taskHelpDivImg").src = "/ibm/console/images/arrow_collapsed.gif";
            }

            document.getElementById("taskHelpDiv").style.height = "50";

            document.getElementById("taskHelpIFrame").height = "1%";

            state = "none";
        }
    }
}


function findtheLabel(anObj) {
    var objFound = false;

    if ((anObj.parentNode.getAttribute("TITLE")) || (anObj.parentNode.getAttribute("DESC"))) {
        anObj = anObj.parentNode;
    } else {
        if (anObj.parentNode.childNodes) {
            if (anObj.parentNode.childNodes.length > 1) {
                for (q=0;q<anObj.parentNode.childNodes.length;q++ ) {
                    if (anObj.parentNode.childNodes[q].tagName == "LABEL") {
                        anObj = anObj.parentNode.childNodes[q];

                        objFound = true;

                        break;
                    }
                }
            }
        }
    }

    if (!objFound) {
         var labelElems = document.getElementsByTagName ("label");
         var objID = anObj.getAttribute ("id");
         var objName = anObj.getAttribute ("name");
         
         for (i = 0; i < labelElems.length; ++i) {
              var labelID = labelElems[i].getAttribute ("for");

              if (labelID != null) {
                   if (objID != null) {
                        try {
                             if (labelID.equals (objID)) {
                                  return labelElems[i];
                             }
                        }

                        catch (ex) {
                             if (labelID == objID) {
                                  return labelElems[i];
                             }
                        }
                   }

                   if (objName != null) {
                        try {
                             if (labelID.equals (objName)) {
                                  return labelElems[i];
                             }
                        }

                        catch (ex) {
                             if (labelID == objName) {
                                  return labelElems[i];
                             }
                        }
                   }
              }
         }
    }

    return anObj;
}



var titleText="";
var setTitleText="no";
function showAlt(e) {

        var oT, oL, thisWin, thisWinscroll, visibleWin = 0;
        var obj = "";

        if (isDom) {
                oT = e.clientY+document.body.scrollTop;
                oL = e.clientX;
                obj = e.target;
                thisWin = document.body.clientHeight;
                thisWinscroll = document.body.scrollTop;
                visibleWin = thisWinscroll + thisWin;
                //objName = obj.tagName;
        }
        else {
                e = event;
                oT = e.clientY+document.body.scrollTop;
                oL = e.clientX;
                obj = e.srcElement;
                thisWin = document.body.clientHeight;
                thisWinscroll = document.body.scrollTop;
                visibleWin = thisWinscroll + thisWin;
                //objName = obj.tagName;
        }

        oT = oT + thisWinscroll;

        labelList = document.getElementsByTagName("LABEL");
        for (q=0;q<labelList.length;q++) {
            if (labelList[q].getAttribute("htmlFor") != null && labelList[q].getAttribute("htmlFor") != "") {
                if (labelList[q].getAttribute("htmlFor") == obj.id) {
                    obj = labelList[q];
                    break;
                }

            }
        }

        specSlashRE=/(\/)/g;
        specColonRE=/:/g;
        specUnderRE=/_/g;


        if ((obj.tagName != "IMG") && (obj.name != "selectedObjectIds") && (!isDom || !(obj instanceof XULElement)) ) {
            try {
                //alert(obj.getAttribute("TITLE"));

                if ((obj.getAttribute("TITLE")) || (obj.getAttribute("DESC")) || (obj.getAttribute("title")) || (obj.getAttribute("desc"))) {
                    if (obj.getAttribute("TITLE").indexOf(selectText+":") < 0) {
                        writeOutHelpPortlet(obj);
                    }
                }
                else {
                    obj = findtheLabel(obj);
                    //alert(obj.tagName);
                    writeOutHelpPortlet(obj);
                }

            } catch(err) {
                return;
            }
            //else if (obj.title) {
            //    writeOutHelpPortlet(obj);
            //}

        }
        if ((obj.name == "reset") && (e.type != "focus")) {
            for (u=0;u<enableDisableArray.length;u++) {
                enableDisable(enableDisableArray[u],"reset");
                //alert(enableDisableArray[u]);
            }
            obj.click();
        }
}

function writeOutHelpPortlet(obj) {
    try {
        if (obj.id == "" && obj.tagName == "A") {
           return;
        }

        if ((obj.getAttribute("TITLE")) || (obj.getAttribute("DESC"))) {
            titleText = obj.getAttribute("TITLE");

            addPageText = " "+lookInPageHelp;

            if (titleText == "") {
                titleText = obj.getAttribute("DESC");
            } else {
                obj.setAttribute("DESC",titleText);
            }
            /*if (titleText.indexOf("/") > -1) {
                titleText=titleText.replace(specSlashRE,"/ ");
            }*/
            if (titleText.indexOf(":") > -1) {
                titleText=titleText.replace(specColonRE,": ");
            }
            /*if (titleText.indexOf("_") > -1) {
                titleText=titleText.replace(specUnderRE,"_ ");
            }*/
            scriptLabel = document.createTextNode(titleText);

            if (document.getElementById("fieldHelpPortlet") != null) {
                document.getElementById("fieldHelpPortlet").innerHTML = "";
                document.getElementById("fieldHelpPortlet").appendChild(scriptLabel);
                document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width = "20%";

                if (!isDom) {
                    if (document.getElementById("fieldHelpPortlet").offsetHeight >= 200) {
                        document.getElementById("fieldHelpPortlet").style.height = 200;
                    } else {
                        document.getElementById("fieldHelpPortlet").style.height = "";
                    }
                } else {
                    document.getElementById("fieldHelpPortlet").style.display = "none";
                    document.getElementById("fieldHelpPortlet").style.display = "block";
                }


                floatHelpPortlet();

            }
        } else if ((obj.getAttribute("title")) || (obj.getAttribute("desc"))) {

                titleText = obj.getAttribute("title");


                addPageText = " "+lookInPageHelp;

                if (titleText == "") {
                    titleText = obj.getAttribute("desc");
                } else {
                    obj.setAttribute("desc",titleText);
                }
                /*if (titleText.indexOf("/") > -1) {
                    titleText=titleText.replace(specSlashRE,"/ ");
                }*/
                //if (titleText.indexOf(":") > -1) {
                //    titleText=titleText.replace(specColonRE,": ");
                //}
                /*if (titleText.indexOf("_") > -1) {
                    titleText=titleText.replace(specUnderRE,"_ ");
                }*/
                scriptLabel = document.createTextNode(titleText);

                if (document.getElementById("fieldHelpPortlet") != null) {
                    document.getElementById("fieldHelpPortlet").innerHTML = "";
                    document.getElementById("fieldHelpPortlet").appendChild(scriptLabel);
                    document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width = "20%";

                    //alert(document.getElementById("fieldHelpPortlet").offsetHeight);

                    if (!isDom) {
                        document.getElementById("fieldHelpPortlet").style.height = "";
                        if (document.getElementById("fieldHelpPortlet").offsetHeight >= 200) {
                            document.getElementById("fieldHelpPortlet").style.height = 200;
                        }
                    } else {
                        document.getElementById("fieldHelpPortlet").style.display = "none";
                        document.getElementById("fieldHelpPortlet").style.display = "block";
                    }


                    floatHelpPortlet();
                }
        } else {
            // Added this check to let users copy and paste text from inside the fieldHelpPortlet
            secondParId = obj.parentNode.parentNode.id;
            thirdParId = obj.parentNode.parentNode.parentNode.id;
            if ((obj.id != "fieldHelpPortlet") && (secondParId != "wasHelpPortlet") && (thirdParId != "wasHelpPortlet")) {
            if (!noInfoAvailable) {
                titleText = "No information available";
            }  else {
                titleText = noInfoAvailable;
            }
            titleText = noInfoAvailable;
            scriptLabel = document.createTextNode(titleText);
            if (document.getElementById("fieldHelpPortlet") != null) {
                document.getElementById("fieldHelpPortlet").innerHTML = "";
                document.getElementById("fieldHelpPortlet").innerHTML = titleText;
                document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width = "20%";
                if (!isDom) {
                    document.getElementById("fieldHelpPortlet").style.height = "";
                }
            }

            floatHelpPortlet();
           }
        }

        titleText = "";
    } catch(err) {
        return;
    }
}

function changeObjectVisibility(objId) {
    document.getElementById(objId).style.visibility="visible";
}


function hideAlt(e) {

        var o, oT, oL, obj = "";

        if (isIE) {
                if (isDom) {
                        obj = e.target;
                }
                else {
                        e = event;
                        obj = e.srcElement;
                }
        }
        //if ((obj.tagName != "LABEL") && (objName != "LEGEND")) {
            if (isDom) {
                            document.all["bubbleHelp"].style.visibility="hidden";
                            //if (setTitleText == "yes") {
                            //    obj.setAttribute("TITLE",titleText);
                            //}
                            return false;
            } /*else {
                            document.all["bubbleHelp"].style.visibility="hidden";
                            return false;
            }   */
        //}


}



function assignTabIndex() {
   scrollHeight = document.body.scrollHeight;

   if (isIE) {
       var numberForms = document.forms.length;
       var formIndex,elIndex;
       document.body.tabIndex = 1;
       for (formIndex = 0; formIndex < numberForms; formIndex++)
       {
           elIndex = document.forms[formIndex].length;

           for (elmIndex = 0; elmIndex < elIndex; elmIndex++) {

               document.forms[formIndex].elements[elmIndex].onfocus = showAlt;

               if (document.forms[formIndex].elements[elmIndex].tagName != "FIELDSET") {
                       document.forms[formIndex].elements[elmIndex].tabIndex = 1;
               }

           }

       }



       var numberLinks = document.links.length;
       for (formIndex = 0; formIndex < numberLinks; formIndex++)  {
           if (((document.links[formIndex].parentNode.tagName == "TH") || (document.links[formIndex].parentNode.tagName == "TD"))
               && (document.links[formIndex].target != "WAS_help")) {
                document.links[formIndex].tabIndex = 1;
           }

       }

       var pArray =  document.getElementsByTagName("P");
       var numberPs = pArray.length;
       for (pIndex = 0; pIndex < numberPs; pIndex++)  {
           if (pArray[pIndex].className == "readOnlyElement") {
               content = pArray[pIndex].firstChild.nodeValue;
               aLen = content.length;
               //if (pArray[pIndex].offsetWidth < (content.length*5)) {
               //    pArray[pIndex].style.overflow = "scroll";
               //}
               if (content.length < 10) {
                   pArray[pIndex].style.width = "25%";
               } else if (content.length < 35) {
                       pArray[pIndex].style.width = "50%";
               } else {
                   if (content.length < 55) {
                       pArray[pIndex].style.width = "75%";
                   }
               }
               //alert(content.length);
               //pArray[pIndex].style.overflow = "auto";
               pArray[pIndex].tabIndex = 1;
           }
       }

       var iArray =  document.images;
       var numberIs = iArray.length;
       for (iIndex = 0; iIndex < numberIs; iIndex++)  {
           if (!iArray[iIndex].alt) {
               iArray[iIndex].alt = "";
           } else {
               if (!iArray[iIndex].title) {
                   iArray[iIndex].title = iArray[iIndex].alt;
               }
           }
       }



       // Added this here to determine whether to show Hide the message portlet
       // This will do the check on page load
       determinePortletPrefs("com_ibm_ws_inlineMessages");
       //determinePortletPrefs("scopeTable");
       //determinePortletPrefs("prefsTable");


       //set min width of additional props panel to 100
       var dArray =  document.getElementsByTagName("DIV");
       var numberDs = dArray.length;
       for (dIndex = 0; dIndex < numberDs; dIndex++)  {
           if (dArray[dIndex].className == "main-category") {
               if (dArray[dIndex].offsetWidth < 100) {
                   dArray[dIndex].style.width="100px";
               }
               break;
           }
       }

   }

   runtimeMessageLookup();

}

function runtimeMessageLookup() {

    if (document.getElementById("messageName") != null) {
        try {
            TmpMsg = document.getElementById("messageName").innerHTML;
            //msgId = TmpMsg.substring(0,TmpMsg.indexOf(":"));
            var match4 = TmpMsg.match("(([A-Z][A-Z][A-Z][A-Z])[0-9][0-9][0-9][0-9][I|W|E])(:)");
            var match5 = TmpMsg.match("(([A-Z][A-Z][A-Z][A-Z][A-Z])[0-9][0-9][0-9][0-9][I|W|E])(:)");
            if (match5 != null) {
                searchText = "<a target='support' href='http://www-1.ibm.com/support/search.wss?rs=180&tc=SSEQTP&q="+match5[1]+"%20OR%20"+match5[2]+"*'>"+match5[0]+"</a>";
                rege = new RegExp(match5[0]);
                str = TmpMsg.replace(rege,searchText);
                document.getElementById("messageName").innerHTML = str;
            } else if (match4 != null) {
                searchText = "<a target='support' href='http://www-1.ibm.com/support/search.wss?rs=180&tc=SSEQTP&q="+match4[1]+"%20OR%20"+match4[2]+"'>"+match4[0]+"</a>";
                rege = new RegExp(match4[0]);
                str = TmpMsg.replace(rege,searchText);
                document.getElementById("messageName").innerHTML = str;
            }

        } catch (e) {
            //failed to execute, do nothing
        }
    }

}                                                  


function resizeInputField(el,direction) {

   // This code resizes text input elements based upon the size of their value
    /***if ((elType == "text") || (elType == "textarea")) {

       elSize = ((document.forms[formIndex].elements[elmIndex].size * .65) * .95) - 2;
       parSize = document.forms[formIndex].elements[elmIndex].parentNode.offsetWidth * .90;

       valSize = document.forms[formIndex].elements[elmIndex].value.length;
       if (elType == "text") {
           if (elSize < valSize) {
               resizeInputField(document.forms[formIndex].elements[elmIndex], "up");
           }
       }

    } ***/
    if (direction == "up") {
        el.style.width = "90%";
    } else {
        el.size = "30";
    }

}



function determinePortletPrefs(objectId) {
    if (document.getElementById(objectId) != null) {
           if (objectId == "com_ibm_ws_inlineMessages") {
               //  This is included here because the message box HTML is not printed out
               //  by a JSP with access to session data, as is the Prefs and Scope.
               //  In the case of inline messages, the script has to access the session
               //  to retrieve the visibility
               uriState = "secure/javascriptToSession.jsp?req=get&sessionVariable=com_ibm_ws_inlineMessages";
               setState = doXmlHttpRequest(uriState);
               js_state = setState.substring(0,setState.indexOf("+endTransmission"));
           }

           if (js_state == "none") {
              document.getElementById(objectId).style.display = "none";
              if (document.getElementById(objectId+"Img")) {
                    document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_collapsed.gif";
              }
           } else {
              document.getElementById(objectId).style.display = showIt;
              if (document.getElementById(objectId+"Img")) {
                    document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_expanded.gif";
              }
           }



            if (objectId == "com_ibm_ws_inlineMessages") {

                numErr = document.getElementById(objectId).innerHTML.split("Error.gif").length - 1;
                if (numErr > 0) {
                    //  If there are errors, then expand by default
                    js_state = "inline";
                    document.getElementById(objectId).style.display = showIt;
                    if (document.getElementById(objectId+"Img")) {
                        document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_expanded.gif";
                    }
                }


                if (js_state == "none") {
                    theMess = document.getElementById(objectId).innerHTML;
                    numE = 0;
                    numW = 0;
                    numI = 0;
                    Es = theMess.match(/Error.gif/g);
                    if (Es != null) {
                        numE = Es.length;
                    }
                    Ws = theMess.match(/Warning.gif/g);
                    if (Ws != null) {
                        numW = Ws.length;
                    }
                    Is = theMess.match(/Information.gif/g);
                    if (Is != null) {
                        numI = Is.length;
                    }
                    createSummary(numE,numW,numI,objectId);

                } else {

                    removeSummary();

                }

            }


       }

}




function showHideSection(objectId) {
    if (document.getElementById(objectId) != null) {
        if (document.getElementById(objectId).style.display == "none") {
            document.getElementById(objectId).style.display = showIt;
            if (document.getElementById(objectId+"Img")) {
                document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_expanded.gif";
            }
            state = "inline";
        } else {
            document.getElementById(objectId).style.display = "none";
            if (document.getElementById(objectId+"Img")) {
                document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_collapsed.gif";
            }
            state = "none";
        }

       if (objectId == "com_ibm_ws_inlineMessages") {
           //top.navigation_tree.com_ibm_ws_inlineMessages = state;
           uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_inlineMessages&variableValue="+state;
           setState = doXmlHttpRequest(uriState);
           setState = setState.substring(0,setState.indexOf("+endTransmission"));
       } else if (objectId == "com_ibm_ws_scopeTable") {
           // top.navigation_tree.scopeTable = state;
           uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_scopeTable&variableValue="+state;
           setState = doXmlHttpRequest(uriState);
           // This next reg exp supposed to trim leading/trailing spaces, but doesn't seem to
           //setState = setState.replace(/^\s*|\s*$/,"");
           //  Use this if we need to reuse this value anywhere
           setState = setState.substring(0,setState.indexOf("+endTransmission"));
       } else if (objectId == "com_ibm_ws_prefsTable") {
               //top.navigation_tree.com_ibm_ws_prefsTable = state;
               uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_prefsTable&variableValue="+state;
               setState = doXmlHttpRequest(uriState);
               setState = setState.substring(0,setState.indexOf("+endTransmission"));
       } else if (objectId == "com_ibm_ca_prefsTable") {
            uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ca_prefsTable&variableValue="+state;
            setState = doXmlHttpRequest(uriState);
            setState = setState.substring(0,setState.indexOf("+endTransmission"));
       }


        if (objectId == "com_ibm_ws_inlineMessages") {

            if (state == "none") {
                theMess = document.getElementById(objectId).innerHTML;
                numE = 0;
                numW = 0;
                numI = 0;
                Es = theMess.match(/Error.gif/g);
                if (Es != null) {
                    numE = Es.length;
                }
                Ws = theMess.match(/Warning.gif/g);
                if (Ws != null) {
                    numW = Ws.length;
                }
                Is = theMess.match(/Information.gif/g);
                if (Is != null) {
                    numI = Is.length;
                }
                createSummary(numE,numW,numI,objectId);

            } else {

                removeSummary();

            }

        }




    }

}




// Will need to include the following for Mozilla
//document.all = document.getElementsByTagName("*");
function showHideNavigation(item) {
    taskSet = document.getElementById("child_"+item);
    taskImg = document.getElementById("img_"+item);
    if (taskSet.style.display == "block") {
        taskSet.style.display = "none";
        taskImg.src = "/ibm/console/images/arrow_collapsed.gif";
    } else {
        taskSet.style.display = "block";
        taskImg.src = "/ibm/console/images/arrow_expanded.gif";
    }
}

function showHideChanges() {

    if (document.getElementById("changesTableImg").src.indexOf("arrow_collapsed") > 0) {
        document.getElementById("changesTableImg").src = "/ibm/console/images/arrow_expanded.gif";
        document.getElementById("changesTable").style.display = showIt;
    } else {
        document.getElementById("changesTableImg").src = "/ibm/console/images/arrow_collapsed.gif";
        document.getElementById("changesTable").style.display = "none";
    }
}





function createSummary(numE,numW,numI,objectId) {
    myMessagespan = document.createElement("SPAN");
    myMessagespan.setAttribute("id","com_ibm_ws_MessageBox");
    myMessagespan.setAttribute("style","padding-left: 2em");
    myPad1 = document.createTextNode("      ");
    myPad2 = document.createTextNode("      ");
    myPad3 = document.createTextNode("      ");

    targ =  document.getElementById(objectId).parentNode;
    targ2 = targ.getElementsByTagName('TD')[0];
    targ2.appendChild(myPad1);
    targ2.appendChild(myMessagespan);

    if (numE > 0) {
        myImgE = document.createElement("IMG");
        myImgE.setAttribute("src","images/Error.gif");
        myImgE.setAttribute("border","0");
        myImgE.setAttribute("align","absmiddle");
        myImgE.setAttribute("alt","Error messages");
        myImgE.setAttribute("style","margin-left:2em");
        numtxtE = document.createTextNode(": "+numE);
        myMessagespan.appendChild(myImgE);
        myMessagespan.appendChild(numtxtE);
        myMessagespan.appendChild(myPad2);
    }
    if (numW > 0) {
        myImgW = document.createElement("IMG");
        myImgW.setAttribute("src","images/Warning.gif");
        myImgW.setAttribute("border","0");
        myImgW.setAttribute("align","absmiddle");
        myImgW.setAttribute("alt","Warning messages");
        myImgW.setAttribute("style","margin-left:2em");
        numtxtW = document.createTextNode(": "+numW);
        myMessagespan.appendChild(myImgW);
        myMessagespan.appendChild(numtxtW);
        myMessagespan.appendChild(myPad3);
    }
    if (numI > 0) {
        myImgI = document.createElement("IMG");
        myImgI.setAttribute("src","images/Information.gif");
        myImgI.setAttribute("border","0");
        myImgI.setAttribute("align","absmiddle");
        myImgI.setAttribute("alt","Information messages");
        myImgI.setAttribute("style","margin-left:2em");
        numtxtI = document.createTextNode(": "+numI);
        myMessagespan.appendChild(myImgI);
        myMessagespan.appendChild(numtxtI);
    }

}

function removeSummary(objectId) {
    var messnode = document.getElementById("com_ibm_ws_MessageBox");
    //if (messnode != null) {
    //    var delnode = messnode.removeNode(true);
    //}
    if (messnode != null) {
        var messPar = messnode.parentNode;
        messPar.removeChild(messnode)
    }

}



function inspect(elm){
  var str = "";
  for (var i in elm){
    str += i + ": " + elm.getAttribute(i) + "\t";
  }
  alert(str);
}


function showHidePortlet(objectId) {
    if (document.getElementById(objectId) != null) {

        if (document.getElementById(objectId).style.display == "none") {
            if (document.getElementById(objectId+"Img")) {
            	//WSC Conosle Federation
            	if ( objectId == "wasHelpPortlet" && federationAdder == "10" ) {
	            	document.getElementById(objectId+"Img").src = "/ibm/console/images/IRU_title_minimize.gif";
            	} else {
            		document.getElementById(objectId+"Img").src = "/ibm/console/images/title_minimize.gif";
            	}
            }
            //inspect(document.getElementById(objectId));
            //document.getElementById(objectId).setAttribute("style","width:100%");
            document.getElementById(objectId).style.display = showIt;
            state = showIt;

        } else {
            if (document.getElementById(objectId+"Img")) {
            	//WSC Conosle Federation
            	if ( objectId == "wasHelpPortlet" && federationAdder == "10" ) {
	            	document.getElementById(objectId+"Img").src = "/ibm/console/images/IRU_title_restore.gif";
            	} else {
                	document.getElementById(objectId+"Img").src = "/ibm/console/images/title_restore.gif";
                }
            }
            document.getElementById(objectId).style.display = "none";
            state = "none";
        }

        if (objectId == "wasHelpPortlet") {
            if (state == "none") {
                document.getElementById(objectId).parentNode.parentNode.parentNode.width = "1%";
            } else {
                document.getElementById(objectId).parentNode.parentNode.parentNode.width = "20%";
            }
            uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=wasHelpPortlet&variableValue="+state;
            setState = doXmlHttpRequest(uriState);
            setState = setState.substring(0,setState.indexOf("+endTransmission"));
            //alert(setState);

        }
        if (objectId == "wasPDPortlet") {

            uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=wasPDPortlet&variableValue="+state;
            setState = doXmlHttpRequest(uriState);
            setState = setState.substring(0,setState.indexOf("+endTransmission"));
            //alert(setState);

        }

    }
}


function enableDisable(controlSet,origin) {

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
                    if (document.getElementById(cArray[j]).type == "text") {
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
                }
            }


        }

    }
}


function moveInList(listId,direction) {
   theList = document.getElementById(listId);
   if ( theList.length == -1) {  // If the list is empty
      return;
   } else {
      var sel = theList.selectedIndex;
      if (sel == -1) {
         alert(moveInListError);
      } else {  // Something is selected
         if ( theList.length == 0 ) {  // If there's only one in the list
             return;
         } else {  // There's more than one in the list, rearrange the list order
            if ( sel == theList.length-1 ) {
               return;
            } else {
               if (direction == "up") {
                   if (sel == 0) {
                       return;
                   } else {
                      offsetNum = sel - 1;
                   }
               } else {
                   if (sel == (theList.length-1)) {
                       return;
                   } else {
                       offsetNum = sel + 1;
                   }
               }
               var affectedText = theList[offsetNum].text;
               var moverText = theList[sel].text;
               var affectedValue = theList[offsetNum].value;
               var moverValue = theList[sel].value;
               theList[sel].text = affectedText;
               theList[sel].value = affectedValue;
               theList[offsetNum].text = moverText;
               theList[offsetNum].value = moverValue;
               theList.selectedIndex = offsetNum;
               // Select the one that was selected before
            }  // Ends the check for selecting one which can be moved
         }  // Ends the check for there only being one in the list to begin with
      }  // Ends the check for there being something selected
   }  // Ends the check for there being none in the list
}




function sortList(listName) {
     theList = document.getElementById(listName);
     var tmpText= new Array();
     var tmpVals= new Array();
     for (i=0;i<theList.length;i++) {
          tmpText[i]=theList.options[i].text;
     }
     tmpText.sort();
     for (i=0;i<tmpText.length;i++) {
          theList.options[i].text = tmpText[i];
     }
}

function sendListToHidden(listName,hiddenName) {
     var listContent = "";
     theList = document.getElementById(listName);
     for (i=0;i<theList.options.length;i++) {
          // Give the hidden element the value of the option instead of the text
          listContent = listContent + "\n" + theList.options[i].value;
     }
     document.getElementById(hiddenName).value = listContent;
     //alert(document.getElementById(hiddenName).value);
}

function moveBetweenLists(fromName,toName,hiddenName) {
    if (isIE) {
        if (document.getElementById(fromName) != null) {

            fromList = document.getElementById(fromName);
            toList = document.getElementById(toName);



            for (y=0;y<fromList.options.length;y++) {
                var current = fromList.options[y];
                if (current.selected) {
                    sel = true;
                    text= current.text;
                    val = current.value;
                    toList.options[toList.length] = new Option(text,val);
                    fromList.options[y] = null;
                    y--;
                }
            }

            if (!sel) {
                alert("Please select an option");
            } else {
                sortList(fromName);
                sortList(toName);
                if (hiddenName != null) {
                    // This call is not made when REMOVING items from target list
                    sendListToHidden(toName,hiddenName);
                }
            }
        }
    }
}

function doXmlHttpRequest(sUri) {
    isMoz = false;
    mozLoaded = false;
    xmlhttp = null;
    xmlDoc = null;
    if (window.ActiveXObject) {
        xmlhttp = new ActiveXObject('MSXML2.XMLHTTP');
    } else {
        xmlhttp = new XMLHttpRequest();
    }

    if (xmlhttp) {
        xmlhttp.open('GET',sUri,false);
        //PI12xxx
        form = document.getElementsByName("csrfid")[0];
        if (form != null) {
        	value = form.value;
        	xmlhttp.setRequestHeader("csrfid", value);
        }
        xmlhttp.send(null);
        xmlDoc = xmlhttp.responseText;
        mozLoaded = true;
    }

    return xmlDoc;

}


function getObjectStatus(sUri,statusImage) {

    statusImage.alt = pleaseWait;
    statusImage.title = pleaseWait;

    tmpsrc = statusImage.src;

    var my_date=new Date()
    dummy = my_date.getMilliseconds();
    sUri = sUri+"&dummy="+dummy;

    xmlDoc = doXmlHttpRequest(sUri);

    //if (mozLoaded == true) {
        xmlDoc.replace(/\n/, '');
        //alert(xmlDoc);
        // For some reason the regular expression is not working
        // so trimming off whitespace at the end manually
        //mozilla and IE need different trimming
    //    if (isDom) {
    //        len = xmlDoc.length - 2;
    //    } else {
    //        len = xmlDoc.length - 1;
    //    }
    //    xmlDoc = xmlDoc.substring (0,len);


        for (j=xmlDoc.length-1; j>=0 && xmlDoc.charAt(j)<=" " ; j--) ;

        xmlDoc = xmlDoc.substring (0,j+1);


        for (i=0;i<statusArray.length;i++) {
            if (xmlDoc == statusArray[i]) {
                xmlDoc = statusArray[i];
                tmpsrc = statusIconArray[i];
                break;
            }
        }



        statusImage.alt = xmlDoc;
        statusImage.title = xmlDoc;
        //statusImage.setAttribute("TITLE",xmlDoc);
        //statusImage.setAttribute("ALT",xmlDoc);

        statusImage.src = tmpsrc;

    //}
}



function iscSelectAll(tmpForm,tmpBox) {
    if (isDom) { theForm = document.forms[tmpForm] }
    else { theForm = document.getElementById(tmpForm) }
    if (!tmpBox) {
        for (i=0;i<theForm.length;i++) {
            if (theForm[i].type == "checkbox") {
                theForm[i].checked = true;
                findParentRow(theForm.elements[i],"table-row-selected");
            }
        }

    }  else {
        for (i=0;i<theForm.length;i++) {

            if ((theForm[i].type == "checkbox") && (theForm[i].id == tmpBox)) {
                theForm[i].checked = true;
                findParentRow(theForm.elements[i],"table-row-selected");
            }
        }
    }

}

function iscDeselectAll(tmpForm,tmpBox) {
    if (isDom) { theForm = document.forms[tmpForm] }
    else { theForm = document.getElementById(tmpForm) }

    if (!tmpBox) {
        for (i=0;i<theForm.length;i++) {
            if (theForm[i].type == "checkbox") {
                theForm[i].checked = false;
                findParentRow(theForm.elements[i],"table-row");
            }
        }

    }  else {
        for (i=0;i<theForm.length;i++) {

            if ((theForm[i].type == "checkbox") && (theForm[i].id == tmpBox)) {
                theForm[i].checked = false;
                findParentRow(theForm.elements[i],"table-row");
            }
        }


    }
}


function findParentRow(el,st) {
    par = el.parentNode;
    if (par.tagName == "TR") {
        par.className = st;
    } else {
        findParentRow(par,st);
    }

}

function updateStatusImage(imgName,state) {
    if (document.getElementById(imgName) != null) {
        //alert(document.getElementById(imgName));
        if (state != "info") {
            if (state == "warning") {
                if (document.getElementById(imgName).src.indexOf("Error.gif") < 0) {
                    document.getElementById(imgName).src = "images/Warning.gif";
                }
            } else if (state == "error") {
                document.getElementById(imgName).src = "images/Error.gif";
            } else {
                if ((document.getElementById(imgName).src.indexOf("Warning.gif") < 0)
                    && (document.getElementById(imgName).src.indexOf("Error.gif") < 0)) {
                    document.getElementById(imgName).src = "images/complete.gif";
                }
            }
        }
    }
}


function checkChecks(chk) {
    if (chk.checked == true) {
        findParentRow(chk,"table-row-selected");
    } else {
        findParentRow(chk,"table-row");
    }
}


ROElementValue = null;
function captureRO(el) {
    ROElementValue = el.value;
}
function returnRO(el) {
    el.value = ROElementValue;
}