
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var enableDisableArray=new Array();
var currentField="";
var cellwide=false;
var scrollHeight;
var isNav4=false;
var isIE=false;
var isDom=false;
document.onclick=setTopVarOff;
document.onmouseover=whatObjectOn;
document.onmouseout=whatObjectOff;
document.onmouseup=setTopVarOff;
window.onload=assignTabIndex;
window.onscroll=floatHelpPortlet;
window.onresize=doResize;
try{
pleaseWait=pleaseWait;
}
catch(e){
pleaseWait=top.pleaseWait;
}
var foropera=window.navigator.userAgent.toLowerCase();
var itsopera=foropera.indexOf("opera",0)+1;
var itsgecko=foropera.indexOf("gecko",0)+1;
var itsmozillacompat=foropera.indexOf("mozilla",0)+1;
var itsmsie=foropera.indexOf("msie",0)+1;
if(itsopera>0){
isNav4=true;
}
if(itsmozillacompat>0){
if(itsgecko>0){
isIE=true;
if(foropera.indexOf(".net")===-1){
isDom=true;
}
document.all=document.getElementsByTagName("*");
}else{
if(itsmsie>0){
isIE=true;
}else{
if(parseInt(navigator.appVersion)<5){
isNav4=true;
}else{
isIE=true;
}
}
}
}
if(isDom){
showIt="table-row-group";
}else{
showIt="inline";
}
var com_ibm_ws_inlineMessages="inline";
var com_ibm_ws_scopeTable="none";
var com_ibm_ws_prefsTable="none";
var com_ibm_ca_prefsTable="none";
function arrayContains(_221,_222){
len=_221.length;
for(i=0;i<len;i++){
if(_221[i]==_222){
return true;
}
}
return false;
}
function setTopVarOn(e){
top.isloaded=0;
if(isNav4){
routeEvent(e);
}
}
function doResize(e){
var _225=scrollHeight;
scrollHeight=document.body.scrollHeight;
if(document.body.scrollHeight<_225){
floatHelpPortlet(e);
}
}
function setTopVarOff(e){
top.isloaded=1;
showAlt(e);
}
function showPleaseWaitButton(){
document.all["progress"].style.top=200+document.body.scrollTop+"px";
document.all["progress"].style.left=200+document.body.scrollLeft+"px";
document.all["progress"].style.display="block";
}
function whatObjectOn(e){
if(isDom){
obj=e.target;
}else{
e=event;
obj=e.srcElement;
}
if(obj!=null){
if((obj.tagName=="LI")&&(obj.className=="nav-bullet")&&(document.getElementById("fieldHelpPortlet")!=null)){
obj.style.cursor="help";
}else{
if((obj.parentNode.parentNode!=null)&&(obj.parentNode.parentNode.tagName=="LI")&&(obj.tagName=="A")&&(document.getElementById("fieldHelpPortlet")!=null)){
obj.parentNode.style.cursor="help";
}else{
if(((obj.tagName=="LABEL")||(obj.tagName=="LEGEND"))&&(document.getElementById("fieldHelpPortlet")!=null)){
if((obj.getAttribute("TITLE"))||(obj.getAttribute("DESC"))||(obj.getAttribute("title"))||(obj.getAttribute("desc"))){
if(obj.getAttribute("TITLE").indexOf(selectText+":")<0){
obj.style.cursor="help";
}
}
}
}
}
}
}
function whatObjectOff(e){
if(isDom){
obj=e.target;
}else{
e=event;
obj=e.srcElement;
}
if(obj!=null){
if((obj.tagName=="LI")&&(obj.className=="nav-bullet")){
obj.style.color="#BCBCBC";
}
}
}
var ProgressImage=new Image();
ProgressImage.src="/ibm/console/images/appInstall_animated.gif";
document.write("<div id='progress' style=\"position:absolute;display:none;top:200;left:200;border: 1px black solid;padding:3px 3px 3px 3px;background-color:#FFFFFF;font-family: sans-serif;font-size: 80%;z-index:2\"><NOBR><img src='/ibm/console/images/appInstall_animated.gif' align='texttop' alt='"+pleaseWait+"'>"+pleaseWait+"</NOBR></div>");
function floatHelpPortlet(e){
var _22a=document.getElementById("wasHelpPortletPos");
var _22b;
if(_22a!=null){
var _22c=_22a.scrollHeight;
if(isDom){
_22b=parseInt(_22a.style.top);
if(_22b!=document.body.scrollTop){
_22a.style.visibility="hidden";
}
if(isNaN(_22b)){
_22b=0;
}
if((_22c+document.body.scrollTop+federationAdder)<scrollHeight){
_22a.style.top=document.body.scrollTop+federationAdder;
}
if(document.body.scrollTop>20){
_22a.style.position="relative";
}
setTimeout("document.getElementById(\"wasHelpPortletPos\").style.visibility = \"visible\"",750);
}else{
_22b=_22a.style.pixelTop;
if(_22b!=document.body.scrollTop){
_22a.style.visibility="hidden";
}
if((_22c+document.body.scrollTop+federationAdder)<scrollHeight){
_22a.style.pixelTop=document.body.scrollTop+federationAdder;
}
setTimeout("document.getElementById(\"wasHelpPortletPos\").style.visibility = \"visible\"",750);
}
}
}
function appInstallWaitShow(){
if(isDom){
document.all["progress"].style.display="block";
}else{
if(isNav4){
document.layers["progress"].visibility="show";
}else{
document.all["progress"].style.display="block";
}
}
}
function appInstallWaitHide(){
if(isDom){
document.all["progress"].style.display="none";
}else{
if(isNav4){
document.layers["progress"].visibility="hide";
}else{
document.all["progress"].style.display="none";
}
}
}
function findPageHelpLink(_22d){
linkLength=document.links.length;
fallout=true;
for(t=0;t<linkLength;t++){
if(document.links[t].getAttribute("target")=="WAS_help"){
document.write("<a href=\""+document.links[t].getAttribute("href")+"\" target=\"WAS_help\">");
document.write(_22d);
document.write("</a>");
fallout=false;
break;
}
}
if(fallout){
document.write(statusUnavailable);
}
}
function findTaskHelpLink(_22e,_22f){
if(document.getElementById("taskHelpDiv")!=null){
if(document.getElementById("taskHelpDivImg").src.indexOf("collapsed")>-1){
document.getElementById("taskHelpDiv").style.display=showIt;
if(document.getElementById("taskHelpDivImg")){
document.getElementById("taskHelpDivImg").src="/ibm/console/images/arrow_expanded.gif";
}
document.getElementById("taskHelpDiv").style.height="200";
document.getElementById("taskHelpIFrame").height="100%";
state="inline";
}else{
document.getElementById("taskHelpDiv").style.display="none";
if(document.getElementById("taskHelpDivImg")){
document.getElementById("taskHelpDivImg").src="/ibm/console/images/arrow_collapsed.gif";
}
document.getElementById("taskHelpDiv").style.height="50";
document.getElementById("taskHelpIFrame").height="1%";
state="none";
}
}
}
function findtheLabel(_230){
var _231=false;
if((_230.parentNode.getAttribute("TITLE"))||(_230.parentNode.getAttribute("DESC"))){
_230=_230.parentNode;
}else{
if(_230.parentNode.childNodes){
if(_230.parentNode.childNodes.length>1){
for(q=0;q<_230.parentNode.childNodes.length;q++){
if(_230.parentNode.childNodes[q].tagName=="LABEL"){
_230=_230.parentNode.childNodes[q];
_231=true;
break;
}
}
}
}
}
if(!_231){
var _232=document.getElementsByTagName("label");
var _233=_230.getAttribute("id");
var _234=_230.getAttribute("name");
for(i=0;i<_232.length;++i){
var _235=_232[i].getAttribute("for");
if(_235!=null){
if(_233!=null){
try{
if(_235.equals(_233)){
return _232[i];
}
}
catch(ex){
if(_235==_233){
return _232[i];
}
}
}
if(_234!=null){
try{
if(_235.equals(_234)){
return _232[i];
}
}
catch(ex){
if(_235==_234){
return _232[i];
}
}
}
}
}
}
return _230;
}
var titleText="";
var setTitleText="no";
function showAlt(e){
var oT,oL,thisWin,thisWinscroll,visibleWin=0;
var obj="";
if(isDom){
oT=e.clientY+document.body.scrollTop;
oL=e.clientX;
obj=e.target;
thisWin=document.body.clientHeight;
thisWinscroll=document.body.scrollTop;
visibleWin=thisWinscroll+thisWin;
}else{
e=event;
oT=e.clientY+document.body.scrollTop;
oL=e.clientX;
obj=e.srcElement;
thisWin=document.body.clientHeight;
thisWinscroll=document.body.scrollTop;
visibleWin=thisWinscroll+thisWin;
}
oT=oT+thisWinscroll;
labelList=document.getElementsByTagName("LABEL");
for(q=0;q<labelList.length;q++){
if(labelList[q].getAttribute("htmlFor")!=null&&labelList[q].getAttribute("htmlFor")!=""){
if(labelList[q].getAttribute("htmlFor")==obj.id){
obj=labelList[q];
break;
}
}
}
specSlashRE=/(\/)/g;
specColonRE=/:/g;
specUnderRE=/_/g;
if((obj.tagName!="IMG")&&(obj.name!="selectedObjectIds")&&(!isDom||!(obj instanceof XULElement))){
try{
if((obj.getAttribute("TITLE"))||(obj.getAttribute("DESC"))||(obj.getAttribute("title"))||(obj.getAttribute("desc"))){
if(obj.getAttribute("TITLE").indexOf(selectText+":")<0){
writeOutHelpPortlet(obj);
}
}else{
obj=findtheLabel(obj);
writeOutHelpPortlet(obj);
}
}
catch(err){
return;
}
}
if((obj.name=="reset")&&(e.type!="focus")){
for(u=0;u<enableDisableArray.length;u++){
enableDisable(enableDisableArray[u],"reset");
}
obj.click();
}
}
function writeOutHelpPortlet(obj){
try{
if(obj.id==""&&obj.tagName=="A"){
return;
}
if((obj.getAttribute("TITLE"))||(obj.getAttribute("DESC"))){
titleText=obj.getAttribute("TITLE");
addPageText=" "+lookInPageHelp;
if(titleText==""){
titleText=obj.getAttribute("DESC");
}else{
obj.setAttribute("DESC",titleText);
}
scriptLabel=document.createTextNode(titleText);
if(document.getElementById("fieldHelpPortlet")!=null){
document.getElementById("fieldHelpPortlet").innerHTML="";
document.getElementById("fieldHelpPortlet").appendChild(scriptLabel);
document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width="20%";
if(!isDom){
if(document.getElementById("fieldHelpPortlet").offsetHeight>=200){
document.getElementById("fieldHelpPortlet").style.height=200;
}else{
document.getElementById("fieldHelpPortlet").style.height="";
}
}else{
document.getElementById("fieldHelpPortlet").style.display="none";
document.getElementById("fieldHelpPortlet").style.display="block";
}
floatHelpPortlet();
}
}else{
if((obj.getAttribute("title"))||(obj.getAttribute("desc"))){
titleText=obj.getAttribute("title");
addPageText=" "+lookInPageHelp;
if(titleText==""){
titleText=obj.getAttribute("desc");
}else{
obj.setAttribute("desc",titleText);
}
scriptLabel=document.createTextNode(titleText);
if(document.getElementById("fieldHelpPortlet")!=null){
document.getElementById("fieldHelpPortlet").innerHTML="";
document.getElementById("fieldHelpPortlet").appendChild(scriptLabel);
document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width="20%";
if(!isDom){
document.getElementById("fieldHelpPortlet").style.height="";
if(document.getElementById("fieldHelpPortlet").offsetHeight>=200){
document.getElementById("fieldHelpPortlet").style.height=200;
}
}else{
document.getElementById("fieldHelpPortlet").style.display="none";
document.getElementById("fieldHelpPortlet").style.display="block";
}
floatHelpPortlet();
}
}else{
secondParId=obj.parentNode.parentNode.id;
thirdParId=obj.parentNode.parentNode.parentNode.id;
if((obj.id!="fieldHelpPortlet")&&(secondParId!="wasHelpPortlet")&&(thirdParId!="wasHelpPortlet")){
if(!noInfoAvailable){
titleText="No information available";
}else{
titleText=noInfoAvailable;
}
titleText=noInfoAvailable;
scriptLabel=document.createTextNode(titleText);
if(document.getElementById("fieldHelpPortlet")!=null){
document.getElementById("fieldHelpPortlet").innerHTML="";
document.getElementById("fieldHelpPortlet").innerHTML=titleText;
document.getElementById("fieldHelpPortlet").parentNode.parentNode.parentNode.width="20%";
if(!isDom){
document.getElementById("fieldHelpPortlet").style.height="";
}
}
floatHelpPortlet();
}
}
}
titleText="";
}
catch(err){
return;
}
}
function changeObjectVisibility(_23a){
document.getElementById(_23a).style.visibility="visible";
}
function hideAlt(e){
var o,oT,oL,obj="";
if(isIE){
if(isDom){
obj=e.target;
}else{
e=event;
obj=e.srcElement;
}
}
if(isDom){
document.all["bubbleHelp"].style.visibility="hidden";
return false;
}
}
function assignTabIndex(){
scrollHeight=document.body.scrollHeight;
if(isIE){
var _23d=document.forms.length;
var _23e,elIndex;
for(_23e=0;_23e<_23d;_23e++){
elIndex=document.forms[_23e].length;
for(elmIndex=0;elmIndex<elIndex;elmIndex++){
document.forms[_23e].elements[elmIndex].onfocus=showAlt;
}
}
var _23f=document.getElementsByTagName("P");
var _240=_23f.length;
for(pIndex=0;pIndex<_240;pIndex++){
if(_23f[pIndex].className=="readOnlyElement"){
content=_23f[pIndex].firstChild.nodeValue;
aLen=content.length;
if(content.length<10){
_23f[pIndex].style.width="25%";
}else{
if(content.length<35){
_23f[pIndex].style.width="50%";
}else{
if(content.length<55){
_23f[pIndex].style.width="75%";
}
}
}
}
}
var _241=document.images;
var _242=_241.length;
for(iIndex=0;iIndex<_242;iIndex++){
if(!_241[iIndex].alt){
_241[iIndex].alt="";
}else{
if(!_241[iIndex].title){
_241[iIndex].title=_241[iIndex].alt;
}
}
}
determinePortletPrefs("com_ibm_ws_inlineMessages");
var _243=document.getElementsByTagName("DIV");
var _244=_243.length;
for(dIndex=0;dIndex<_244;dIndex++){
if(_243[dIndex].className=="main-category"){
if(_243[dIndex].offsetWidth<100){
_243[dIndex].style.width="100px";
}
break;
}
}
}
runtimeMessageLookup();
}
function runtimeMessageLookup(){
if(document.getElementById("messageName")!=null){
try{
TmpMsg=document.getElementById("messageName").innerHTML;
var _245=TmpMsg.match("(([A-Z][A-Z][A-Z][A-Z])[0-9][0-9][0-9][0-9][I|W|E])(:)");
var _246=TmpMsg.match("(([A-Z][A-Z][A-Z][A-Z][A-Z])[0-9][0-9][0-9][0-9][I|W|E])(:)");
if(_246!=null){
searchText="<a target='support' href='http://www-1.ibm.com/support/search.wss?rs=180&tc=SSEQTP&q="+_246[1]+"%20OR%20"+_246[2]+"*'>"+_246[0]+"</a>";
rege=new RegExp(_246[0]);
str=TmpMsg.replace(rege,searchText);
document.getElementById("messageName").innerHTML=str;
}else{
if(_245!=null){
searchText="<a target='support' href='http://www-1.ibm.com/support/search.wss?rs=180&tc=SSEQTP&q="+_245[1]+"%20OR%20"+_245[2]+"'>"+_245[0]+"</a>";
rege=new RegExp(_245[0]);
str=TmpMsg.replace(rege,searchText);
document.getElementById("messageName").innerHTML=str;
}
}
}
catch(e){
}
}
}
function resizeInputField(el,_248){
if(_248=="up"){
el.style.width="90%";
}else{
el.size="30";
}
}
function determinePortletPrefs(_249){
if(document.getElementById(_249)!=null){
if(_249=="com_ibm_ws_inlineMessages"){
uriState="secure/javascriptToSession.jsp?req=get&sessionVariable=com_ibm_ws_inlineMessages";
setState=doXmlHttpRequest(uriState);
js_state=setState.substring(0,setState.indexOf("+endTransmission"));
}
if(js_state=="none"){
document.getElementById(_249).style.display="none";
if(document.getElementById(_249+"Img")){
document.getElementById(_249+"Img").src="/ibm/console/images/arrow_collapsed.gif";
}
}else{
document.getElementById(_249).style.display=showIt;
if(document.getElementById(_249+"Img")){
document.getElementById(_249+"Img").src="/ibm/console/images/arrow_expanded.gif";
}
}
if(_249=="com_ibm_ws_inlineMessages"){
numErr=document.getElementById(_249).innerHTML.split("Error.gif").length-1;
if(numErr>0){
js_state="inline";
document.getElementById(_249).style.display=showIt;
if(document.getElementById(_249+"Img")){
document.getElementById(_249+"Img").src="/ibm/console/images/arrow_expanded.gif";
}
}
if(js_state=="none"){
theMess=document.getElementById(_249).innerHTML;
numE=0;
numW=0;
numI=0;
Es=theMess.match(/Error.gif/g);
if(Es!=null){
numE=Es.length;
}
Ws=theMess.match(/Warning.gif/g);
if(Ws!=null){
numW=Ws.length;
}
Is=theMess.match(/Information.gif/g);
if(Is!=null){
numI=Is.length;
}
createSummary(numE,numW,numI,_249);
}else{
removeSummary();
}
}
}
}
function showHideSection(_24a){
if(document.getElementById(_24a)!=null){
var _24b="none";
if(document.getElementById(_24a).style.display=="none"){
document.getElementById(_24a).style.display=showIt;
if(document.getElementById(_24a+"Img")){
document.getElementById(_24a+"Img").src="/ibm/console/images/arrow_expanded.gif";
}
_24b="inline";
}else{
document.getElementById(_24a).style.display="none";
if(document.getElementById(_24a+"Img")){
document.getElementById(_24a+"Img").src="/ibm/console/images/arrow_collapsed.gif";
}
_24b="none";
}
if(_24a=="com_ibm_ws_scopeTable"){
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_scopeTable&variableValue="+_24b;
setState=doXmlHttpRequest(uriState);
setState=setState.substring(0,setState.indexOf("+endTransmission"));
}else{
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable="+_24a+"&variableValue="+_24b;
setState=doXmlHttpRequest(uriState);
setState=setState.substring(0,setState.indexOf("+endTransmission"));
}
if(_24a=="com_ibm_ws_inlineMessages"){
if(_24b=="none"){
theMess=document.getElementById(_24a).innerHTML;
numE=0;
numW=0;
numI=0;
Es=theMess.match(/Error.gif/g);
if(Es!=null){
numE=Es.length;
}
Ws=theMess.match(/Warning.gif/g);
if(Ws!=null){
numW=Ws.length;
}
Is=theMess.match(/Information.gif/g);
if(Is!=null){
numI=Is.length;
}
createSummary(numE,numW,numI,_24a);
}else{
removeSummary();
}
}
}
}
function showHidePreferences(_24c,_24d,_24e){
if(document.getElementById(_24c)!=null){
var _24f="none";
if(document.getElementById(_24c).style.display=="none"){
document.getElementById(_24c).style.display=showIt;
if(document.getElementById(_24c+"Img")){
document.getElementById(_24c+"Img").src="/ibm/console/images/arrow_expanded.gif";
document.getElementById(_24c+"Img").alt=_24e;
document.getElementById(_24c+"Img").title=_24e;
}
_24f="inline";
}else{
document.getElementById(_24c).style.display="none";
if(document.getElementById(_24c+"Img")){
document.getElementById(_24c+"Img").src="/ibm/console/images/arrow_collapsed.gif";
document.getElementById(_24c+"Img").alt=_24d;
document.getElementById(_24c+"Img").title=_24d;
}
_24f="none";
}
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable="+_24c+"&variableValue="+_24f;
setState=doXmlHttpRequest(uriState);
setState=setState.substring(0,setState.indexOf("+endTransmission"));
}
}
function showHideNavigation(item){
taskSet=document.getElementById("child_"+item);
taskImg=document.getElementById("img_"+item);
if(taskSet.style.display=="block"){
taskSet.style.display="none";
taskImg.src="/ibm/console/images/arrow_collapsed.gif";
}else{
taskSet.style.display="block";
taskImg.src="/ibm/console/images/arrow_expanded.gif";
}
}
function showHideChanges(){
if(document.getElementById("changesTableImg").src.indexOf("arrow_collapsed")>0){
document.getElementById("changesTableImg").src="/ibm/console/images/arrow_expanded.gif";
document.getElementById("changesTable").style.display=showIt;
}else{
document.getElementById("changesTableImg").src="/ibm/console/images/arrow_collapsed.gif";
document.getElementById("changesTable").style.display="none";
}
}
function createSummary(numE,numW,numI,_254){
myMessagespan=document.createElement("SPAN");
myMessagespan.setAttribute("id","com_ibm_ws_MessageBox");
myMessagespan.setAttribute("style","padding-left: 2em");
myPad1=document.createTextNode("      ");
myPad2=document.createTextNode("      ");
myPad3=document.createTextNode("      ");
targ=document.getElementById(_254).parentNode;
targ2=targ.getElementsByTagName("TD")[0];
targ2.appendChild(myPad1);
targ2.appendChild(myMessagespan);
if(numE>0){
myImgE=document.createElement("IMG");
myImgE.setAttribute("src","images/Error.gif");
myImgE.setAttribute("border","0");
myImgE.setAttribute("align","absmiddle");
myImgE.setAttribute("alt","Error messages");
myImgE.setAttribute("style","margin-left:2em");
numtxtE=document.createTextNode(": "+numE);
myMessagespan.appendChild(myImgE);
myMessagespan.appendChild(numtxtE);
myMessagespan.appendChild(myPad2);
}
if(numW>0){
myImgW=document.createElement("IMG");
myImgW.setAttribute("src","images/Warning.gif");
myImgW.setAttribute("border","0");
myImgW.setAttribute("align","absmiddle");
myImgW.setAttribute("alt","Warning messages");
myImgW.setAttribute("style","margin-left:2em");
numtxtW=document.createTextNode(": "+numW);
myMessagespan.appendChild(myImgW);
myMessagespan.appendChild(numtxtW);
myMessagespan.appendChild(myPad3);
}
if(numI>0){
myImgI=document.createElement("IMG");
myImgI.setAttribute("src","images/Information.gif");
myImgI.setAttribute("border","0");
myImgI.setAttribute("align","absmiddle");
myImgI.setAttribute("alt","Information messages");
myImgI.setAttribute("style","margin-left:2em");
numtxtI=document.createTextNode(": "+numI);
myMessagespan.appendChild(myImgI);
myMessagespan.appendChild(numtxtI);
}
}
function removeSummary(_255){
var _256=document.getElementById("com_ibm_ws_MessageBox");
if(_256!=null){
var _257=_256.parentNode;
_257.removeChild(_256);
}
}
function inspect(elm){
var str="";
for(var i in elm){
str+=i+": "+elm.getAttribute(i)+"\t";
}
alert(str);
}
function showHidePortlet(_25b){
if(document.getElementById(_25b)!=null){
var _25c;
if(document.getElementById(_25b).style.display=="none"){
if(document.getElementById(_25b+"Img")){
if(_25b=="wasHelpPortlet"&&federationAdder=="10"){
document.getElementById(_25b+"Img").src="/ibm/console/images/IRU_title_minimize.gif";
}else{
document.getElementById(_25b+"Img").src=minimizeImage;
}
}
document.getElementById(_25b).style.display=showIt;
_25c=showIt;
}else{
if(document.getElementById(_25b+"Img")){
if(_25b=="wasHelpPortlet"&&federationAdder=="10"){
document.getElementById(_25b+"Img").src="/ibm/console/images/IRU_title_restore.gif";
}else{
document.getElementById(_25b+"Img").src=maximizeImage;
}
}
document.getElementById(_25b).style.display="none";
_25c="none";
}
if(_25b=="wasHelpPortlet"){
if(_25c=="none"){
document.getElementById(_25b).parentNode.parentNode.parentNode.width="1%";
}else{
document.getElementById(_25b).parentNode.parentNode.parentNode.width="20%";
}
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable=wasHelpPortlet&variableValue="+_25c;
setState=doXmlHttpRequest(uriState);
setState=setState.substring(0,setState.indexOf("+endTransmission"));
}
if(_25b=="wasPDPortlet"){
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable=wasPDPortlet&variableValue="+_25c;
setState=doXmlHttpRequest(uriState);
setState=setState.substring(0,setState.indexOf("+endTransmission"));
}
}
}
function enableDisable(_25d,_25e){
if(_25e!="reset"){
enableDisableArray[enableDisableArray.length]=_25d;
}
controlArray=_25d.split(",");
disStatus=false;
textStyle="textEntry";
textColor="#000000";
textAreaStyle="textAreaEntry";
var _25f=null;
for(i=0;i<controlArray.length;i++){
tmp=controlArray[i];
cArray=tmp.split(":");
if(cArray.length>1){
masterControlId=cArray[0];
var flip=false;
if(masterControlId.substr(0,1)=="!"){
masterControlId=masterControlId.substr(1);
flip=true;
}
if(document.getElementById(masterControlId)){
_25f=document.getElementById(masterControlId).checked;
masterControlStatusdisabled=document.getElementById(masterControlId).disabled;
if(flip){
_25f=!_25f;
}
}
if(_25f&&(!masterControlStatusdisabled)){
disStatus=false;
textStyle="textEntry";
textColor="#000000";
textAreaStyle="textAreaEntry";
}else{
disStatus=true;
textStyle="textEntryReadOnly";
textColor="#CCCCCC";
textAreaStyle="textAreaEntryReadOnly";
}
for(j=1;j<cArray.length;j++){
if(document.getElementById(cArray[j])){
rcArray=cArray[j].split("+");
if(rcArray.length>1){
textStyle=textStyle+rcArray[1];
cArray[j]=rcArray[0];
}
if((document.getElementById(cArray[j]).type=="text")||(document.getElementById(cArray[j]).type=="password")){
document.getElementById(cArray[j]).className=textStyle;
}
if(document.getElementById(cArray[j]).type=="textarea"){
document.getElementById(cArray[j]).className=textAreaStyle;
}
if(isDom){
document.getElementById(cArray[j]).parentNode.style.color=textColor;
}else{
document.getElementById(cArray[j]).parentElement.style.color=textColor;
}
document.getElementById(cArray[j]).disabled=disStatus;
}
}
}
}
}
function enableDisableImage(_261,_262,_263,_264){
if(document.getElementById(_261)!=null){
var _265=document.images[_262];
if(_265!=null){
if(document.getElementById(_261).checked==true){
_265.src=_263;
}else{
_265.src=_264;
}
}
}
}
function moveInList(_266,_267){
theList=document.getElementById(_266);
if(theList.length==-1){
return;
}else{
var sel=theList.selectedIndex;
if(sel==-1){
alert(moveInListError);
}else{
if(theList.length==0){
return;
}else{
if(sel==theList.length-1){
return;
}else{
if(_267=="up"){
if(sel==0){
return;
}else{
offsetNum=sel-1;
}
}else{
if(sel==(theList.length-1)){
return;
}else{
offsetNum=sel+1;
}
}
var _269=theList[offsetNum].text;
var _26a=theList[sel].text;
var _26b=theList[offsetNum].value;
var _26c=theList[sel].value;
theList[sel].text=_269;
theList[sel].value=_26b;
theList[offsetNum].text=_26a;
theList[offsetNum].value=_26c;
theList.selectedIndex=offsetNum;
}
}
}
}
}
function sortList(_26d){
theList=document.getElementById(_26d);
var _26e=new Array();
var _26f=new Array();
for(i=0;i<theList.length;i++){
_26e[i]=theList.options[i].text;
}
_26e.sort();
for(i=0;i<_26e.length;i++){
theList.options[i].text=_26e[i];
}
}
function sendListToHidden(_270,_271){
var _272="";
theList=document.getElementById(_270);
for(i=0;i<theList.options.length;i++){
_272=_272+"\n"+theList.options[i].value;
}
document.getElementById(_271).value=_272;
}
function moveBetweenLists(_273,_274,_275){
if(isIE){
if(document.getElementById(_273)!=null){
fromList=document.getElementById(_273);
toList=document.getElementById(_274);
for(y=0;y<fromList.options.length;y++){
var _276=fromList.options[y];
if(_276.selected){
sel=true;
text=_276.text;
val=_276.value;
toList.options[toList.length]=new Option(text,val);
fromList.options[y]=null;
y--;
}
}
if(!sel){
alert("Please select an option");
}else{
sortList(_273);
sortList(_274);
if(_275!=null){
sendListToHidden(_274,_275);
}
}
}
}
}
function doXmlHttpRequest(sUri){
isMoz=false;
mozLoaded=false;
xmlhttp=null;
xmlDoc=null;
if(window.ActiveXObject){
xmlhttp=new ActiveXObject("MSXML2.XMLHTTP");
}else{
xmlhttp=new XMLHttpRequest();
}
if(xmlhttp){
xmlhttp.open("GET",sUri,false);
form=document.getElementsByName("csrfid")[0];
if(form!=null){
value=form.value;
xmlhttp.setRequestHeader("csrfid",value);
}
xmlhttp.send(null);
xmlDoc=xmlhttp.responseText;
mozLoaded=true;
}
return xmlDoc;
}
function doXmlHttpRequestPost(sUri,data){
isMoz=false;
mozLoaded=false;
xmlhttp=null;
xmlDoc=null;
if(window.ActiveXObject){
xmlhttp=new ActiveXObject("MSXML2.XMLHTTP");
}else{
xmlhttp=new XMLHttpRequest();
}
if(xmlhttp){
xmlhttp.open("POST",sUri,false);
xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
xmlhttp.setRequestHeader("Content-length",data.length);
xmlhttp.setRequestHeader("Connection","close");
form=document.getElementsByName("csrfid")[0];
if(form!=null){
value=form.value;
xmlhttp.setRequestHeader("csrfid",value);
}
xmlhttp.send(data);
xmlDoc=xmlhttp.responseText;
mozLoaded=true;
}
return xmlDoc;
}
function getObjectStatus(sUri,_27b){
_27b.alt=pleaseWait;
_27b.title=pleaseWait;
tmpsrc=_27b.src;
var _27c=new Date();
sUri=sUri+"&time="+_27c.getTime();
xmlDoc=doXmlHttpRequest(sUri);
xmlDoc.replace(/\n/,"");
for(j=xmlDoc.length-1;j>=0&&xmlDoc.charAt(j)<=" ";j--){
}
xmlDoc=xmlDoc.substring(0,j+1);
for(i=0;i<statusArray.length;i++){
if(xmlDoc==statusArray[i]){
xmlDoc=statusArray[i];
tmpsrc=statusIconArray[i];
break;
}
}
_27b.alt=xmlDoc;
_27b.title=xmlDoc;
_27b.src=tmpsrc;
}
function iscSelectAll(_27d,_27e){
theForm=document.getElementById(_27d);
if(!_27e){
for(i=0;i<theForm.length;i++){
if(theForm[i].type=="checkbox"){
theForm[i].checked=true;
quickChecks(theForm[i]);
findParentRow(theForm.elements[i],"table-row-selected");
}
}
}else{
for(i=0;i<theForm.length;i++){
if((theForm[i].type=="checkbox")&&(theForm[i].id==_27e)){
theForm[i].checked=true;
quickChecks(theForm[i]);
findParentRow(theForm.elements[i],"table-row-selected");
}
}
}
checkChecks();
}
function iscDeselectAll(_27f,_280){
theForm=document.getElementById(_27f);
if(!_280){
for(i=0;i<theForm.length;i++){
if(theForm[i].type=="checkbox"){
theForm[i].checked=false;
quickChecks(theForm[i]);
findParentRow(theForm.elements[i],"table-row");
}
}
}else{
for(i=0;i<theForm.length;i++){
if((theForm[i].type=="checkbox")&&(theForm[i].id==_280)){
theForm[i].checked=false;
quickChecks(theForm[i]);
findParentRow(theForm.elements[i],"table-row");
}
}
}
checkChecks();
}
function findParentRow(el,st){
par=el.parentNode;
if(par.tagName=="TR"){
par.className=st;
}else{
findParentRow(par,st);
}
}
function updateStatusImage(_283,_284){
if(document.getElementById(_283)!=null){
if(_284!="info"){
if(_284=="warning"){
if(document.getElementById(_283).src.indexOf("Error.gif")<0){
document.getElementById(_283).src="images/Warning.gif";
}
}else{
if(_284=="error"){
document.getElementById(_283).src="images/Error.gif";
}else{
if((document.getElementById(_283).src.indexOf("Warning.gif")<0)&&(document.getElementById(_283).src.indexOf("Error.gif")<0)){
document.getElementById(_283).src="images/complete.gif";
}
}
}
}
}
}
function intersect(_285,_286){
var _287=[];
for(var i1=0;i1<_285.length;i1++){
var _289=false;
for(var i2=0;i2<_286.length;i2++){
if(_285[i1]==_286[i2]){
_289=true;
break;
}
}
if(_289){
_287.push(_285[i1]);
}
}
return _287;
}
function enableAllButtons(){
if(window.buttonsFilter){
for(var b in buttonsFilter){
var _28c=buttonsFilter[b];
var _28d;
for(var b2 in _28c){
_28d=b2;
}
var _28f=findButton(_28d);
if(_28f){
enableButton(_28f);
}
}
}
}
function quickChecks(chk){
if(!window.checkedRows){
checkedRows={};
}
if(chk.checked==true){
findParentRow(chk,"table-row-selected");
checkedRows[chk.value]=true;
}else{
findParentRow(chk,"table-row");
delete checkedRows[chk.value];
}
}
function checkChecks(chk){
if(chk){
quickChecks(chk);
}
if(!window.checkedRows){
return;
}
enableAllButtons();
for(var _292 in checkedRows){
if(window.buttonsFilter){
for(var b in buttonsFilter){
var _294=buttonsFilter[b];
var _295;
for(var b2 in _294){
_295=b2;
}
var _297=_294[b2];
var _298=collectionFilter[_292];
if(_298){
if(intersect(_297,_298).length==0){
var _299=findButton(_295);
if(_299){
var _29a=window["roleNLS"]["button.disabled.desc"];
var _29b="";
for(var r=0;r<_297.length;r++){
_29b+=window["roleNLS"][_297[r]];
if(r<_297.length-1){
_29b+=", ";
}
}
_29a=_29a.replace("{0}",_29b);
disableButton(_299,_29a);
}
}
}
}
}
}
}
function disableButton(_29d,_29e){
_29d.setAttribute("disabled","disabled");
var div=document.createElement("div");
div.setAttribute("id",_29d.getAttribute("value")+".div");
div.setAttribute("title",_29e);
_29d.parentNode.appendChild(div);
div.style.position="absolute";
div.style.width=_29d.offsetWidth;
div.style.height=_29d.offsetHeight;
div.style.top=_29d.offsetTop;
div.style.left=_29d.offsetLeft;
div.style["z-index"]=10;
}
function enableButton(_2a0){
var div=document.getElementById(_2a0.getAttribute("value")+".div");
if(div){
_2a0.parentNode.removeChild(div);
}
_2a0.disabled=null;
}
function findButton(name){
var _2a3=document.forms;
for(var i=0;i<_2a3.length;i++){
if(_2a3[i][name]){
return _2a3[i][name];
}
}
return null;
}
ROElementValue=null;
function captureRO(el){
ROElementValue=el.value;
}
function returnRO(el){
el.value=ROElementValue;
}
function saveFormState(){
try{
var data="{";
for(var i=0;i<document.forms[0].elements.length;i++){
var _2a9=document.forms[0].elements[i];
if(_2a9.type=="radio"&&!_2a9.disabled&&_2a9.checked){
data+="\""+_2a9.name+"\":"+"{\"type\":\"radio\",\"value\":\""+_2a9.id+"\"}";
data+=",";
}else{
if(_2a9.type=="text"&&!_2a9.disabled){
data+="\""+_2a9.name+"\":"+"{\"type\":\"text\",\"value\":\""+escape(_2a9.value)+"\"}";
data+=",";
}else{
if(_2a9.type=="checkbox"&&!_2a9.disabled){
data+="\""+_2a9.name+"\":"+"{\"type\":\"checkbox\",\"value\":"+_2a9.checked+"}";
data+=",";
}else{
if(_2a9.type=="select-one"&&!_2a9.disabled){
data+="\""+_2a9.name+"\":"+"{\"type\":\"select\",\"value\":"+_2a9.selectedIndex+"}";
data+=",";
}
}
}
}
}
data+="\"_form\":\""+document.getElementById("name").getAttribute("value")+"\"}";
var _2aa="secure/javascriptToSession.jsp";
var _2ab="req=set&sessionVariable=formstate_data&variableValue="+escape(data);
doXmlHttpRequestPost(_2aa,_2ab);
}
catch(err){
}
return true;
}
function clearFormState(){
uriState="secure/javascriptToSession.jsp?req=set&sessionVariable=formstate_data&variableData=";
var data=doXmlHttpRequest(uriState);
return true;
}
function restoreFormState(){
addSaveStateOnclickToAnchor("customPropsLink");
if(!document.forms[0]){
return;
}
uriState="secure/javascriptToSession.jsp?req=get&sessionVariable=formstate_data";
var data=doXmlHttpRequest(uriState);
if(data.substring(0,6)=="inline"){
return;
}
data=data.substring(0,data.indexOf("+endTransmission"));
data=eval("("+data+")");
if(data["_form"]!=document.getElementById("name").getAttribute("value")){
return;
}
for(var i=0;i<document.forms[0].elements.length;i++){
var _2af=document.forms[0].elements[i];
if(data[_2af.name]&&data[_2af.name].type=="radio"){
var _2b0=document.getElementById(data[_2af.name].value);
_2b0.checked=true;
_2b0.click();
}else{
if(data[_2af.name]&&data[_2af.name].type=="text"){
_2af.value=unescape(data[_2af.name].value);
}else{
if(data[_2af.name]&&data[_2af.name].type=="checkbox"){
if(!_2af.checked==data[_2af.name].value){
_2af.click();
}
}else{
if(data[_2af.name]&&data[_2af.name].type=="select"){
_2af.selectedIndex=data[_2af.name].value;
}
}
}
}
}
var _2b1=document.getElementsByTagName("a");
for(var i=0;i<_2b1.length;i++){
if(_2b1[i].getAttribute("onclick")==null){
if(_2b1[i].childNodes.length==1&&_2b1[i].childNodes[0].nodeType==3){
if(_2b1[i].getAttribute("target")!="WAS_help"&&_2b1[i].getAttribute("id")!="customPropsLink"){
_2b1[i].setAttribute("onclick","return clearFormState();");
_2b1[i].onclick=function(){
return clearFormState();
};
}
}
}
}
clearFormState();
}
function addSaveStateOnclickToAnchor(id){
var _2b3=document.getElementsByTagName("a");
for(var i=0;i<_2b3.length;i++){
if(_2b3[i].childNodes.length==1&&_2b3[i].childNodes[0].nodeType==3){
if(_2b3[i].getAttribute("id")==id){
_2b3[i].setAttribute("onclick","return saveFormState();");
_2b3[i].onclick=function(){
return saveFormState();
};
}
}
}
}
function getCookie(_2b5){
if(null===_2b5||""===_2b5){
return "";
}
var _2b6=window.document.cookie;
var _2b7=_2b6.lastIndexOf(_2b5+"=");
if(_2b7==-1){
return "";
}
var _2b8=_2b7+_2b5.length+1;
var _2b9=_2b6.indexOf(";",_2b8);
if(_2b9==-1){
_2b9=_2b6.length;
}
var _2ba=_2b6.substring(_2b8,_2b9);
return _2ba;
}
