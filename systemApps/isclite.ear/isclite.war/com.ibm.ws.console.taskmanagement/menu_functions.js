// THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
// 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2004, 2006
// All Rights Reserved * Licensed Materials - Property of IBM
// US Government Users Restricted Rights - Use, duplication or disclosure
// restricted by GSA ADP Schedule Contract with IBM Corp.

if (isIE) {
        if (top.taskTypeCollection == "yes") {
                document.write("<div id='taskTypeLegend' style=\"position:absolute;width:150;height=90;visibility:hidden;top:0;left:0;border: 0px black solid;padding:0px 0px 0px 0px;background-color:#999999;\">");
                document.write("<table width='150' border=0 cellpadding=3 cellspacing=1 >");
                document.write("<tr><td class='column-head'> "+taskTypeHeader+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/executing.gif'  align='texttop'  border='0' alt='Executing'> "+taskTypeExecuting+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/approval.gif'  align='texttop'  border='0' alt='Approval'> "+taskTypeApproval+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/manual.gif'  align='texttop'  border='0' alt='Manual'> "+taskTypeManual+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/nonplanned.gif'  align='texttop'  border='0' alt='Non-Planned'> "+taskTypeNonPlanned+"</td></tr>");
                document.write("</table>");
                document.write("</div>");
                top.taskTypeCollection = "no";
        }


}
if (isNav4) {
        if (top.taskTypeCollection == "yes") {
                document.write("<layer id='taskTypeLegend'  visibility='hide' width='150' height='90' top='200' left='200' bgColor='#999999'>");
                document.write("<table width='150' border=0 cellpadding=3 cellspacing=1 >");
                document.write("<tr><td class='column-head'> "+taskTypeHeader+"</td></tr>");
 		     	document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/executing.gif'  align='texttop'  border='0' alt='Executing'> "+taskTypeExecuting+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/approval.gif'  align='texttop'  border='0' alt='Approval'> "+taskTypeApproval+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/manual.gif'  align='texttop'  border='0' alt='Manual'> "+taskTypeManual+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.taskmanagement/images/nonplanned.gif'  align='texttop'  border='0' alt='Non-Planned'> "+taskTypeNonPlanned+"</td></tr>");
                document.write("</table>");
                document.write("</layer>");
                top.taskTypeCollection = "no";
        }
}



function showTaskTypeLegend(e) {

        var o, oT, oL, obj = "";
        if (isIE) {
                if (isDom) {
                        oT = e.clientY;
                        oL = e.clientX;
                        obj = e.target.name;
                        thisWin = document.body.clientHeight;
                        thisWinscroll = document.body.scrollTop;
                        visibleWin = thisWinscroll + thisWin;
                }
                else {
                        e = event;
                        oT = e.clientY+document.body.scrollTop;
                        oL = e.clientX;
                        obj = e.srcElement.name;
                        thisWin = document.body.clientHeight;
                        thisWinscroll = document.body.scrollTop;
                        visibleWin = thisWinscroll + thisWin;
                }
        } else {

                oT = e.pageY;
                oL = e.pageX;
                obj = e.target.target;
                thisWin =  window.innerHeight;
                thisWinscroll = window.pageYOffset;
                visibleWin = thisWinscroll + thisWin;
        }
        if (obj == "taskTypeIcon") {
                legendBottom = oT+200;

                if (legendBottom > visibleWin) {
                        oT = oT - (legendBottom - visibleWin);
                }
                if (isDom) {
                                document.all["taskTypeLegend"].style.top = oT;
                                document.all["taskTypeLegend"].style.left = oL+10;
                                document.all["taskTypeLegend"].style.visibility="visible";
                                return false;
                } else if (isNav4) {
                                document.layers["taskTypeLegend"].top = oT;
                                document.layers["taskTypeLegend"].left = oL+10;
                                document.layers["taskTypeLegend"].visibility="show";
                }
                else {
                                document.all["taskTypeLegend"].style.pixelTop = oT;
                                document.all["taskTypeLegend"].style.pixelLeft = oL+10;
                                document.all["taskTypeLegend"].style.visibility="visible";
                                return false;
                }

        }

        if (isNav4) {routeEvent(e);}



}

function hideTaskTypeLegend(e) {

        var o, oT, oL, obj = "";

        if (isIE) {
                if (isDom) {
                        obj = e.target.name;
                }
                else {
                        e = event;
                        obj = e.srcElement.name;
                }
        } else {
                obj = e.target.target;
        }
        if (obj == "taskTypeIcon") {

                if (isDom) {
                                document.all["taskTypeLegend"].style.visibility="hidden";
                                 return false;
                } else if (isNav4) {
                                document.layers["taskTypeLegend"].visibility="hide";

                }
                else {
                                document.all["taskTypeLegend"].style.visibility="hidden";
                                return false;
                }
        }

        if (isNav4) {routeEvent(e);}



}


