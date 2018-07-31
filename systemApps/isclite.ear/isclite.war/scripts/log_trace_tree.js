
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var browser=browserDetection();
var rootId=1;
var rootName="*";
var rootLevel="";
var traceSpecIds=new Array();
var traceSpecNames=new Array();
var traceSpecLevels=new Array();
var currLangTraceSpecLevels=new Array();
var levelsArray=new Array("off","info","all","fatal","severe","warning","audit","config","detail","fine","finer","finest");
var engLevelsArray=new Array("off","fatal","finest","all","severe","warning","audit","info","config","detail","fine","finer");
var nlsLevelsArray;
var groupTraceExpanded;
var currSelectedCompId=0;
var currSelectedCompName="";
var currSelectedCompLevel="";
var currSelectedCompExist=false;
var currSelectedCompParentLevel="";
var currSelectedCompParentExist=false;
var coreImagePath="/ibm/console/images/";
var imagePath="images/";
var clearance=15;
var MAIN_LEVEL_MENU="mainLevelMenu";
var MESSAGE_TRACE_LEVEL_MENU="messageTraceLevelMenu";
var waitIconLeft=150;
var waitIconTop=25;
var altString="expandCollapse";
function browserDetection(){
var _163;
var _164=window.navigator.userAgent.toLowerCase();
var _165=_164.indexOf("opera",0)+1;
var _166=_164.indexOf("gecko",0)+1;
var _167=_164.indexOf("mozilla",0)+1;
var _168=_164.indexOf("msie",0)+1;
if(_165>0){
_163=3;
document.all=document.getElementsByTagName("*");
}
if(_167>0){
if(_166>0){
if(_164.indexOf("applewebkit")!=-1){
_163=5;
}else{
_163=4;
}
document.all=document.getElementsByTagName("*");
}else{
if(_168>0){
_163=2;
}else{
_163=1;
}
}
}
return _163;
}
function initTraceSpecs(id,name,_16b,_16c){
traceSpecIds.push(id);
traceSpecNames.push(name);
traceSpecLevels.push(_16b);
currLangTraceSpecLevels.push(_16c);
}
function finishLoading(){
for(var i=0;i<traceSpecIds.length;i++){
if(traceSpecIds[i]!=rootId){
updateTraceLevel(traceSpecIds[i],traceSpecLevels[i],currLangTraceSpecLevels[i]);
makeItemVisible(traceSpecIds[i]);
}
}
document.getElementById("waitIndicator").style.visibility="hidden";
}
function doNothing(_16e){
try{
if(_16e.readyState==4&&_16e.status==200){
groupTraceExpanded=_16e.responseText;
}
}
catch(e){
logError(e,"");
}
}
function setAltString(altS){
altString=altS;
}
function initCache(_170){
document.oncontextmenu=wheresTheClick;
var _171=getXMLHTTP();
var url=location.protocol+"//"+location.host+"/ibm/console/getTraceStrings";
var _173="name=init";
_171.open("POST",url,true);
_171.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
_171.setRequestHeader("csrfid",getCookie("com.ibm.ws.console.CSRFToken"));
_171.onreadystatechange=function(){
doNothing(_171);
};
_171.send(_173);
var n=_170.split("|");
nlsLevelsArray=new Array();
for(var l=0;l<n.length;l++){
nlsLevelsArray.push(n[l]);
}
}
function getXMLHTTP(){
var _176=false;
switch(browser){
case 1:
break;
case 2:
try{
_176=new ActiveXObject("Msxml2.XMLHTTP");
}
catch(e){
try{
_176=new ActiveXObject("Microsoft.XMLHTTP");
}
catch(e2){
_176=false;
}
}
break;
case 3:
if(!_176&&typeof XMLHttpRequest!="undefined"){
_176=new XMLHttpRequest();
}
break;
case 4:
_176=new XMLHttpRequest();
break;
default:
_176=new XMLHttpRequest();
break;
}
return _176;
}
function callServer(id,name){
var _179=getXMLHTTP();
var _17a=false;
if("*"==name){
_17a=document.getElementById("item_1.1")===null?false:true;
}else{
_17a=document.getElementById("branch_"+id).hasChildNodes();
}
if(!_17a){
showWaitIcon();
var dots=name.split(".");
var _17c=dots.length;
var _17d=1;
if(_17c>3){
_17d=_17c-3;
}
var _17e=false;
var _17f=parent.document.getElementById("com.ibm.ws.console.probdetermination.groupView");
var _180;
if(browser==2){
_180=_17f.style.display;
}else{
_180=_17f.getAttribute("style");
}
var _181="false";
if(_180.indexOf("none")==-1){
_17e=true;
if(id.indexOf(".",2)==-1){
_181=name;
}else{
var _182=id.substring(0,id.indexOf(".",2));
var xxx=document.getElementById("link_"+_182);
_181=xxx.firstChild.nodeValue;
}
}
var url=location.protocol+"//"+location.host+"/ibm/console/getTraceStrings";
var _185="name="+escape(name)+"&level="+escape(_17d)+"&group="+escape(_17e)+"&parentGroup="+escape(_181);
_179.open("POST",url,true);
_179.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
_179.setRequestHeader("csrfid",getCookie("com.ibm.ws.console.CSRFToken"));
_179.onreadystatechange=function(){
updatePage(_179,id,_17e);
};
_179.send(_185);
}else{
openTree(id,true);
document.getElementById("waitIndicator").style.visibility="hidden";
}
}
function updatePage(_186,id,_188){
if(_186.readyState==4){
try{
if(_186.status==200){
var _189=_186.responseText;
var data=eval("("+_189+")");
if(data.error==="invalid_session"){
top.location=location.protocol+"//"+location.host+"/ibm/console/";
return;
}
if(data.error){
alert(data.error);
}
var _18b=false;
if("1"==id){
_18b=document.getElementById("item_1.1")===null?false:true;
}else{
_18b=document.getElementById("branch_"+id).hasChildNodes();
}
if(_18b){
return;
}
try{
var _18c=getSelectedComponents();
for(var i=0;i<_18c.length;i++){
if(_18c[i].indexOf("=info")!=-1){
_18c.splice(i,1);
i=i-1;
}
}
var _18e=data.items;
for(loopx=0;loopx<_18e.length;loopx=loopx+1){
var _18f=_18e[loopx];
var _190=(_18f.indexOf("*")==-1)?false:true;
if(_188&&id=="1"){
_190=true;
}
if(_190){
addFolder(_18e,id,_18c,loopx);
}else{
addLeaf(_18e,id,_18c,loopx);
}
}
}
catch(e){
alert(e.name+"\n"+e.message);
logError(e,"ras.unexpected.error");
}
finally{
openTree(id,true);
document.getElementById("waitIndicator").style.visibility="hidden";
}
}else{
showNLSMessage("ras.unexpected.error");
}
}
catch(err){
logError(err,"");
}
}
}
function logError(e,_192){
document.getElementById("waitIndicator").style.visibility="hidden";
var name=e.name;
var _194=e.message+" - -"+navigator.userAgent;
var _195=getXMLHTTP();
var url=location.protocol+"//"+location.host+"/ibm/console/traceLogServlet";
var _197="message="+escape(name+":=:"+_194)+"&level=severe";
_195.open("POST",url,true);
_195.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
_195.setRequestHeader("csrfid",getCookie("com.ibm.ws.console.CSRFToken"));
_195.onreadystatechange=function(){
if(_192!==""){
showNLSMessage(_192);
}
};
_195.send(_197);
}
function showNLSMessage(_198){
var _199=getXMLHTTP();
var url=location.protocol+"//"+location.host+"/ibm/console/traceLogServlet?getNLSMessage="+escape(_198)+"&json=true";
_199.open("GET",url,true);
_199.onreadystatechange=function(){
displayNLSMessage(_199);
};
_199.send(null);
}
function displayNLSMessage(_19b){
try{
if(_19b.readyState==4&&_19b.status==200){
alert(eval(_19b.responseText));
}
}
catch(e){
logError(e,"Error Displaying NLS Message");
}
}
function getSelectedComponents(){
var _19c;
if(parent.document.getElementById("selectedComponents")===null){
_19c=parent.document.getElementById("selectedComponentsRuntime").value;
}else{
_19c=parent.document.getElementById("selectedComponents").value;
}
if(groupTraceExpanded!==""){
_19c+=":"+groupTraceExpanded;
}
var text=_19c.split(":");
return text;
}
function getIndexOf(_19e){
for(var i=0;i<engLevelsArray.length;i++){
if(_19e==engLevelsArray[i]){
return i;
}
}
return -1;
}
function trimString(_1a0){
if(null===_1a0||""===_1a0){
return _1a0;
}
return _1a0.replace(/^\s+|\s+$/g,"");
}
function getTraceLevelImage(_1a1,_1a2,id){
var zzz=document.getElementById("level_"+id);
var _1a5=[zzz.src,nlsLevelsArray[getIndexOf(zzz.title)]];
if(_1a1.length<1){
return _1a5;
}
if(_1a2.indexOf("*")!=-1){
_1a2=trimString(_1a2.substring(0,_1a2.indexOf("*")-1));
}
for(var i=0;i<_1a1.length;i++){
var _1a7=_1a1[i].split("=");
if(_1a7[0].indexOf(trimString(_1a2))!=-1){
var drt=trimString(_1a7[1]);
_1a1.splice(i,1);
_1a5[0]="images/"+drt+".png";
_1a5[1]=nlsLevelsArray[getIndexOf(drt)];
break;
}else{
_1a5[0]="images/info.png";
_1a5[1]=nlsLevelsArray[getIndexOf("off")];
}
}
return _1a5;
}
function addLeaf(_1a9,_1aa,_1ab,_1ac){
var _1ad=document.createDocumentFragment();
var _1ae=document.createElement("div");
var str="item_";
var fstr=str.concat(_1aa,".",_1ac+1);
_1ae=document.createElement("div");
_1ae.id=fstr;
var _1b1=document.createElement("img");
_1b1.setAttribute("src","/ibm/console/images/onepix.gif");
_1b1.setAttribute("alt","");
_1b1.setAttribute("width","16");
_1b1.setAttribute("height","1");
var _1b2;
var xzy=getTraceLevelImage(_1ab,_1a9[_1ac],_1aa);
str="level_";
var _1b4=str.concat(_1aa,".",_1ac+1);
_1b2=document.createElement("img");
_1b2.setAttribute("name",_1b4);
_1b2.setAttribute("src",xzy[0]);
_1b2.id=_1b4;
_1b2.setAttribute("width","16");
_1b2.setAttribute("height","16");
_1b2.setAttribute("title",xzy[1]);
_1b2.setAttribute("alt",xzy[1]);
var _1b5;
_1b5=document.createElement("a");
_1b5.setAttribute("href","#");
_1b5.setAttribute("name","treeitem");
str="link_";
_1b4=str.concat(_1aa,".",_1ac+1);
_1b5.id=_1b4;
str="setSelection('";
_1b4=str.concat(_1aa,".",_1ac+1,"', '",_1a9[_1ac],"');return false;");
_1b5.setAttribute("onclick",_1b4);
_1b5.setAttribute("role","button");
var _1b6=document.createTextNode(_1a9[_1ac]);
_1b5.appendChild(_1b6);
_1ae.appendChild(_1b1);
_1ae.appendChild(_1b2);
_1ae.appendChild(_1b5);
_1ad.appendChild(_1ae);
document.getElementById("branch_"+_1aa).appendChild(_1ad);
if(browser==2){
_1ae.innerHTML=_1ae.innerHTML;
}
}
function addFolder(_1b7,_1b8,_1b9,_1ba){
var _1bb=document.createElement("div");
var strx="branch_";
var _1bd=strx.concat(_1b8,".",_1ba+1);
_1bb.id=_1bd;
_1bb.className="treebranch";
var _1be=document.createElement("div");
strx="item_";
_1bd=strx.concat(_1b8,".",_1ba+1);
_1be.id=_1bd;
var _1bf=document.createElement("a");
strx="openClose('";
_1bd=strx.concat(_1b8,".",_1ba+1,"', '",_1b7[_1ba],"');return false;");
_1bf.setAttribute("href","#");
_1bf.setAttribute("onclick",_1bd);
_1bf.setAttribute("role","button");
var _1c0=document.createElement("img");
strx="pm_";
_1bd=strx.concat(_1b8,".",_1ba+1);
_1c0.setAttribute("name",_1bd);
_1c0.setAttribute("src","/ibm/console/images/lplus.gif");
_1c0.id=_1bd;
_1c0.setAttribute("width","16");
_1c0.setAttribute("height","16");
_1c0.setAttribute("alt",altString);
_1bf.appendChild(_1c0);
var _1c1=document.createElement("img");
strx="level_";
_1bd=strx.concat(_1b8,".",_1ba+1);
_1c1.setAttribute("name",_1bd);
var xzy=getTraceLevelImage(_1b9,_1b7[_1ba],_1b8);
_1c1.setAttribute("src",xzy[0]);
_1c1.id=_1bd;
_1c1.setAttribute("width","16");
_1c1.setAttribute("height","16");
_1c1.setAttribute("title",xzy[1]);
_1c1.setAttribute("alt",xzy[1]);
var _1c3;
_1c3=document.createElement("a");
_1c3.setAttribute("href","#");
_1c3.setAttribute("name","treeitem");
strx="link_";
_1bd=strx.concat(_1b8,".",_1ba+1);
_1c3.id=_1bd;
var str="setSelection('";
var _1c5=str.concat(_1b8,".",_1ba+1,"', '",_1b7[_1ba],"');return false;");
_1c3.setAttribute("onclick",_1c5);
var _1c6=document.createTextNode(_1b7[_1ba]);
_1c3.appendChild(_1c6);
_1be.appendChild(_1bf);
_1be.appendChild(_1c1);
_1be.appendChild(_1c3);
var _1c7=document.createDocumentFragment();
var _1c8=document.createDocumentFragment();
_1c7.appendChild(_1be);
_1c8.appendChild(_1bb);
document.getElementById("branch_"+_1b8).appendChild(_1c7);
document.getElementById("branch_"+_1b8).appendChild(_1c8);
if(browser==2){
_1be.innerHTML=_1be.innerHTML;
}
}
function setSelection(id,name){
removeSelection();
currSelectedCompId=id;
currSelectedCompName=name;
highlightSelection("#FFFFFF","#0000FF");
}
function removeSelection(){
if(currSelectedCompId!==null&&currSelectedCompId!==""){
highlightSelection("#0000FF","#FFFFFF");
}
currSelectedCompId="";
currSelectedCompName="";
}
function highlightSelection(_1cb,_1cc){
var _1cd;
if(browser==3){
_1cd=document.getElementById("item_"+currSelectedCompId);
}else{
_1cd=document.all["item_"+currSelectedCompId];
}
if(_1cd){
var _1ce=_1cd.childNodes;
for(var i=0;i<_1ce.length;i++){
if(_1ce[i]!==null&&_1ce[i].name!==null&&_1ce[i].name=="treeitem"){
_1ce[i].style.color=_1cb;
_1ce[i].style.backgroundColor=_1cc;
}
}
}
}
function updateTraceSpec(_1d0,_1d1,_1d2){
if(_1d0!==null&&_1d0.name=="DisabledLevel"){
return;
}
if(currSelectedCompId==rootId){
traceSpecIds=new Array();
traceSpecNames=new Array();
traceSpecLevels=new Array();
traceSpecIds.push(currSelectedCompId);
traceSpecNames.push(currSelectedCompName);
traceSpecLevels.push(_1d1);
}else{
updateTraceSpecArrays();
var _1d3=false;
for(var i=0;i<traceSpecNames.length;i++){
if(currSelectedCompName==traceSpecNames[i]){
traceSpecLevels[i]=_1d1;
traceSpecIds[i]=currSelectedCompId;
_1d3=true;
break;
}
}
if(!_1d3){
traceSpecIds.push(currSelectedCompId);
traceSpecNames.push(currSelectedCompName);
traceSpecLevels.push(_1d1);
}
optimizeTraceString();
}
showWaitIcon();
var str="refreshTraceLevel('";
var fstr=str.concat(currSelectedCompId,"','",_1d1,"','",_1d2,"')");
window.setTimeout(fstr,0);
}
function refreshTraceLevel(_1d7,_1d8,_1d9){
updateTraceLevel(_1d7,_1d8,_1d9);
printTraceSpec();
hidePopupMenu(MAIN_LEVEL_MENU);
document.getElementById("waitIndicator").style.visibility="hidden";
}
function updateTraceSpecArrays(){
var _1da="";
if(parent.document.getElementById("selectedComponents")===null){
if(parent.document.getElementById("selectedComponentsRuntime")!==null){
_1da=parent.document.getElementById("selectedComponentsRuntime").value;
}
}else{
_1da=parent.document.getElementById("selectedComponents").value;
}
_1da=_1da.replace(/\s/g,"");
var _1db=new Array();
if(_1da.length>0){
_1db=_1da.split(":");
}
var _1dc=new Array();
var _1dd=new Array();
var _1de=new Array();
for(var i=0;i<_1db.length;i++){
var _1e0=_1db[i];
var _1e1=_1e0.indexOf("=");
if(_1e1===-1){
continue;
}
_1dd.push(_1e0.substring(0,_1e1));
_1de.push(_1e0.substring(_1e1+1));
_1dc.push(0);
var _1e2=_1dd[_1dd.length-1];
for(var j=0;j<traceSpecNames.length;j++){
if(_1e2==traceSpecNames[j]){
_1dc[_1dc.length-1]=traceSpecIds[j];
break;
}
}
}
rootLevel="";
currSelectedCompLevel="";
currSelectedCompExist=false;
currSelectedCompParentLevel="";
currSelectedCompParentExist=false;
traceSpecIds=new Array();
traceSpecNames=new Array();
traceSpecLevels=new Array();
var _1e4="";
for(i=0;i<_1dc.length;i++){
traceSpecIds.push(_1dc[i]);
traceSpecNames.push(_1dd[i]);
traceSpecLevels.push(_1de[i]);
if(_1dd[i]==rootName){
rootLevel=_1de[i];
}
if(_1dd[i]==currSelectedCompName){
currSelectedCompLevel=_1de[i];
currSelectedCompExist=true;
}
if(currSelectedCompId.length>(_1dc[i]).length&&_1dc[i]!=rootId){
var _1e5=currSelectedCompId.substring(0,(_1dc[i]).length);
if(_1e5==_1dc[i]&&_1e5.length>_1e4.length){
_1e4=_1e5;
currSelectedCompParentLevel=_1de[i];
currSelectedCompParentExist=true;
}
}
}
}
function optimizeTraceString(){
for(var i=0;i<traceSpecNames.length;i++){
if(traceSpecNames[i]!="*"&&traceSpecLevels[i]!==""&&traceSpecLevels[i]==rootLevel){
traceSpecIds.splice(i,1);
traceSpecNames.splice(i,1);
traceSpecLevels.splice(i,1);
i=i-1;
}
}
}
function printTraceSpec(){
var _1e7="";
for(var i=0;i<traceSpecNames.length;i++){
if(i>0){
_1e7=_1e7+": ";
}
_1e7=_1e7+traceSpecNames[i]+"="+traceSpecLevels[i];
}
if(parent.document.getElementById("selectedComponents")===null){
if(parent.document.getElementById("selectedComponentsRuntime")!==null){
parent.document.getElementById("selectedComponentsRuntime").value=_1e7;
}
}else{
parent.document.getElementById("selectedComponents").value=_1e7;
}
}
function updateTraceLevel(id,_1ea,_1eb){
var _1ec=document.getElementById("level_"+id);
if(_1ec!==null){
_1ec.src=imagePath+_1ea+".png";
_1ec.title=_1eb;
}
var _1ed=1;
var _1ee=id+"."+_1ed;
var _1ef;
if(browser==3){
_1ef=document.getElementById("item_"+_1ee);
}else{
_1ef=document.all["item_"+_1ee];
}
while(_1ef){
if(!isIdAlreadySelected(_1ee)){
_1ec;
if(browser==3){
_1ec=document.getElementById("level_"+_1ee);
}else{
_1ec=document.all["level_"+_1ee];
}
if(_1ec!==null&&!isIdAlreadySelected(_1ee)){
updateTraceLevel(_1ee,_1ea,_1eb);
}
}
_1ed++;
_1ee=id+"."+_1ed;
if(browser==3){
_1ef=document.getElementById("item_"+_1ee);
}else{
_1ef=document.all["item_"+_1ee];
}
}
}
function isIdAlreadySelected(id){
var ret=false;
for(var i=0;i<traceSpecIds.length;i++){
if(id==traceSpecIds[i]){
ret=true;
break;
}
}
return ret;
}
function makeItemVisible(id){
var n=id.lastIndexOf(".");
if(n>0){
id=id.substring(0,n);
openTree(id,false);
makeItemVisible(id);
}
}
function openClose(id,name){
var _1f7;
if(browser==3){
_1f7=document.getElementById("pm_"+id);
}else{
if(browser==2){
_1f7=document.getElementById("pm_"+id);
}
}
if(browser==5){
_1f7=document.getElementsByName("pm_"+id)[0];
}else{
_1f7=document.all["pm_"+id];
}
if(_1f7.src.indexOf("lplus.gif")!=-1){
callServer(id,name);
}else{
closeTree(id);
}
}
function openTree(id,_1f9){
var _1fa;
if(browser==3){
_1fa=document.getElementById("branch_"+id);
}else{
_1fa=document.all["branch_"+id];
}
var _1fb;
if(browser==3||browser==5){
_1fb=document.getElementById("pm_"+id);
}else{
_1fb=document.all["pm_"+id];
}
if(_1fa!==null&&_1fb!==null&&_1fb.src.indexOf("lplus.gif")!=-1){
_1fb.src=coreImagePath+"lminus.gif";
_1fa.style.display="block";
if(_1f9===true){
var _1fc=_1fa.offsetTop-document.body.scrollTop;
var _1fd=_1fa.offsetHeight;
var _1fe=(_1fc+_1fd+clearance)-document.body.clientHeight;
if(_1fe>0){
if(_1fe>=(_1fc-clearance)){
_1fe=_1fc-clearance;
}
window.scrollBy(0,_1fe);
}
}
}
}
function closeTree(id){
var _200;
if(browser==3){
_200=document.getElementById("branch_"+id);
}else{
_200=document.all["branch_"+id];
}
var _201;
if(browser==3||browser==4){
_201=document.getElementById("pm_"+id);
}else{
_201=document.all["pm_"+id];
}
if(_200!==null&&_201!==null&&_201.src.indexOf("lminus.gif")!=-1){
_201.src=coreImagePath+"lplus.gif";
_200.style.display="none";
}
var _202=1;
var _203=id+"."+_202;
var _204;
if(browser==3){
_204=document.getElementById("item_"+_203);
}else{
_204=document.all["item_"+_203];
}
while(_204){
if(browser==3){
_200=document.getElementById("branch_"+_203);
}else{
_200=document.all["branch_"+_203];
}
if(browser==3||browser==4){
_201=document.getElementById("pm_"+_203);
}else{
_201=document.all["pm_"+_203];
}
if(_200!==null&&_201!==null&&_201.src.indexOf("lminus.gif")!=-1){
closeTree(_203);
}
_202++;
_203=id+"."+_202;
if(browser==3){
_204=document.getElementById("item_"+_203);
}else{
_204=document.all["item_"+_203];
}
}
}
function showPopupMenu(e,_206){
if(_206==MAIN_LEVEL_MENU){
hidePopupMenu(MESSAGE_TRACE_LEVEL_MENU);
}
var _207=document.getElementById(_206);
var _208;
var _209;
if(browser==4||browser==3){
_209=e.clientX+document.documentElement.scrollLeft;
_207.style.left=new String(_209)+"px";
_208=e.clientY+document.documentElement.scrollTop;
_207.style.top=new String(_208)+"px";
}else{
if(browser==5){
_207.style.pixelLeft=event.pageX+document.documentElement.scrollLeft;
_207.style.pixelTop=event.pageY+document.documentElement.scrollTop;
}else{
_207.style.pixelLeft=event.clientX+document.documentElement.scrollLeft;
_207.style.pixelTop=event.clientY+document.documentElement.scrollTop;
}
}
if(_206!=MESSAGE_TRACE_LEVEL_MENU||_207.style.display=="none"){
enableDisableLevels(_206);
}
_207.style.display="block";
var _20a=_207.style.width;
if(_20a.indexOf("px")>-1){
_20a=_20a.substring(0,_20a.indexOf("px"));
}
var _20b=(e.clientX+parseInt(_20a,10)+clearance)-document.body.clientWidth;
var _20c=(e.clientY+_207.offsetHeight+clearance)-document.body.clientHeight;
if(_20b<0||isNaN(_20b)){
_20b=0;
}
if(_20c<0||isNaN(_20c)){
_20c=0;
}
window.scrollBy(_20b,_20c);
}
function hidePopupMenu(_20d){
if(_20d==MAIN_LEVEL_MENU){
document.getElementById(MAIN_LEVEL_MENU).style.display="none";
document.getElementById(MESSAGE_TRACE_LEVEL_MENU).style.display="none";
removeSelection();
}else{
if(_20d==MESSAGE_TRACE_LEVEL_MENU){
document.getElementById(MESSAGE_TRACE_LEVEL_MENU).style.display="none";
}
}
}
function wheresTheClick(e){
var what="";
if(browser==2){
e=event;
what=e.srcElement;
}else{
what=e.target;
}
if(what.name==="treeitem"){
showPopupMenu(e,MAIN_LEVEL_MENU);
}else{
if(what.name==="MessageTraceLevelItem"){
showPopupMenu(e,MESSAGE_TRACE_LEVEL_MENU);
}else{
if(what.name==="MessageTraceLevelCaption"){
}else{
if(what.name==="EnabledLevel"){
}else{
if(what.name==="EnabledLevelImg"){
}else{
if(what.name==="DisabledLevel"){
}else{
if(what.name==="DisabledLevelImg"){
}else{
hidePopupMenu(MAIN_LEVEL_MENU);
}
}
}
}
}
}
}
return false;
}
function wheresTheClickInParent(e){
hidePopupMenu(MAIN_LEVEL_MENU);
}
function enableDisableLevels(_211){
var _212=0;
var nEnd=levelsArray.length;
if(_211==MAIN_LEVEL_MENU){
updateTraceSpecArrays();
nEnd=3;
}else{
_212=3;
}
for(var i=_212;i<nEnd;i++){
var _215=document.getElementById(levelsArray[i]+"_level_id");
if(_215!==null){
_215.name="EnabledLevel";
_215.className="levelitem";
}
var _216=document.getElementById(levelsArray[i]+"_level_img_id");
if(_216!==null){
_216.name="EnabledLevelImg";
}
}
if(_212==3){
_215=document.getElementById("info1_level_id");
if(_215!==null){
_215.name="EnabledLevel";
_215.className="levelitem";
}
_216=document.getElementById("info1_level_img_id");
if(_216!==null){
_216.name="EnabledLevelImg";
}
}
for(i=0;i<2;i++){
var _217="";
if(i===0){
if(!currSelectedCompExist&&!currSelectedCompParentExist){
_217=rootLevel;
}
}else{
if(i==1){
_217=currSelectedCompLevel;
if(!currSelectedCompExist&&currSelectedCompParentExist){
_217=currSelectedCompParentLevel;
}
}
}
if(_217!==""){
var _218=document.getElementById(_217+"_level_id");
if(_218!==null){
_218.name="DisabledLevel";
_218.className="levelitemoff";
}
var _219=document.getElementById(_217+"_level_img_id");
if(_219!==null){
_219.name="DisabledLevelImg";
}
if(_212==3&&_217=="info"){
_218=document.getElementById("info1_level_id");
if(_218!==null){
_218.name="DisabledLevel";
_218.className="levelitemoff";
}
_219=document.getElementById("info1_level_img_id");
if(_219!==null){
_219.name="DisabledLevelImg";
}
}
}
}
}
function showWaitIcon(){
var _21a=document.getElementById("waitIndicator");
if(browser==4){
_21a.style.left=parseInt(waitIconLeft,10)+document.body.scrollLeft;
_21a.style.top=parseInt(waitIconTop,10)+document.body.scrollTop;
}else{
_21a.style.pixelLeft=parseInt(waitIconLeft,10)+document.body.scrollLeft;
_21a.style.pixelTop=parseInt(waitIconTop,10)+document.body.scrollTop;
}
_21a.style.zIndex=100;
_21a.style.visibility="visible";
}
function getCookie(_21b){
if(null===_21b||""===_21b){
return "";
}
var _21c=window.document.cookie;
var _21d=_21c.lastIndexOf(_21b+"=");
if(_21d==-1){
return "";
}
var _21e=_21d+_21b.length+1;
var _21f=_21c.indexOf(";",_21e);
if(_21f==-1){
_21f=_21c.length;
}
var _220=_21c.substring(_21e,_21f);
return _220;
}
