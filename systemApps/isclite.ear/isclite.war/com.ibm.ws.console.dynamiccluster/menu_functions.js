// IBM Confidential OCO Source Material
// 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004
// The source code for this program is not published or otherwise divested
// of its trade secrets, irrespective of what has been deposited with the
// U.S. Copyright Office.

if (isIE) {
        if (top.opmodeCollection == "yes") {
                document.write("<div id='opmodeLegend' style=\"position:absolute;width:150;height=90;visibility:hidden;top:0;left:0;border: 0px black solid;padding:0px 0px 0px 0px;background-color:#999999;\">");
                document.write("<table width='150' border=0 cellpadding=3 cellspacing=1 role='presentation'>");
                document.write("<tr><td class='column-head'> "+opmodeHeader+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/manual_mode.gif'  align='texttop'  border='0' alt='manual'> "+opmodeManual+"</td></tr>");   
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/supervised_mode.gif' align='texttop'  border='0' alt='supervised'> "+opmodeSupervised+"</td></tr>");     
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/automatic_mode.gif' align='texttop'  border='0' alt='automatic'> "+opmodeAutomatic+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/unavail.gif'  align='texttop'  border='0' alt='unavailable'> "+opmodeUnavailable+"</td></tr>");                
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/unknown.gif'  align='texttop'  border='0' alt='unknown'> "+opmodeUnknown+"</td></tr>");
                document.write("</table>");
                document.write("</div>");
                top.opmodeCollection = "no";
        }
        

}
if (isNav4) {        
        if (top.opmodeCollection == "yes") {
                document.write("<layer id='opmodeLegend'  visibility='hide' width='150' height='90' top='200' left='200' bgColor='#999999'>");
                document.write("<table width='150' border=0 cellpadding=3 cellspacing=1 role='presentation'>");
                document.write("<tr><td class='column-head'> "+opmodeHeader+"</td></tr>");
               	document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/manual_mode.gif'  align='texttop'  border='0' alt='manual'> "+opmodeManual+"</td></tr>");   
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/supervised_mode.gif' align='texttop'  border='0' alt='supervised'> "+opmodeSupervised+"</td></tr>");     
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/automatic_mode.gif' align='texttop'  border='0' alt='automatic'> "+opmodeAutomatic+"</td></tr>");
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/unavail.gif'  align='texttop'  border='0' alt='unavailable'> "+opmodeUnavailable+"</td></tr>");                
                document.write("<tr><td class='table-text'><img src='/ibm/console/com.ibm.ws.console.dynamiccluster/images/unknown.gif'  align='texttop'  border='0' alt='unknown'> "+opmodeUnknown+"</td></tr>");
                document.write("</table>");
                document.write("</layer>");
                top.opmodeCollection = "no";
        }
}
        


function showOpModeLegend(e) {

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
        if (obj == "opmodeIcon") {
                legendBottom = oT+200;

                if (legendBottom > visibleWin) {
                        oT = oT - (legendBottom - visibleWin);
                }
                if (isDom) {
                                document.all["opmodeLegend"].style.top = oT;
                                document.all["opmodeLegend"].style.left = oL+10;
                                document.all["opmodeLegend"].style.visibility="visible";
                                return false;
                } else if (isNav4) {
                                document.layers["opmodeLegend"].top = oT;
                                document.layers["opmodeLegend"].left = oL+10;
                                document.layers["opmodeLegend"].visibility="show";
                }
                else {
                                document.all["opmodeLegend"].style.pixelTop = oT;
                                document.all["opmodeLegend"].style.pixelLeft = oL+10;
                                document.all["opmodeLegend"].style.visibility="visible";
                                return false;
                }
                
        }
        
        if (isNav4) {routeEvent(e);}
        
        

}

function hideOpModeLegend(e) {

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
        if (obj == "opmodeIcon") {
                
                if (isDom) {
                                document.all["opmodeLegend"].style.visibility="hidden";
                                 return false; 
                } else if (isNav4) {
                                document.layers["opmodeLegend"].visibility="hide";
        
                }
                else {
                                document.all["opmodeLegend"].style.visibility="hidden";
                                return false; 
                }
        }
                
        if (isNav4) {routeEvent(e);}
        
              
        
}


