
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var treeNodeId="";
var cookieId="";
var selectedFilterOptionIndex="0";
function initTree(item,data){
treeNodeId=item;
for(var i=0;i<data.length;i++){
createNode(item,data[i].context,data[i].name,data[i].checkable,data[i].expandable,data[i].checked,data[i].disabled,data[i].resource,data[i].description,data[i].style,data[i].iconArray,data[i].iconDescriptionArray);
}
cookieId="tree.state."+treeType+"."+refId;
var _105=readCookie(cookieId);
if(_105==null||_105.length==0){
restoreState("tree.state."+treeType+".");
}else{
restoreState(cookieId);
}
}
function resetTree(){
nodeCount=0;
document.getElementById(treeNodeId).innerHTML="";
}
function applyFilter(_106){
resetTree();
var url="."+treeServletPath+"/applyFilter?filter="+_106+"&tree="+treeType;
var uid=(new Date()).getTime();
url=url+"&refId="+refId+"&u="+uid;
var _109=createXMLHttpRequest();
treeDebug("Opening url "+url);
_109.open("GET",url,false);
_109.send(null);
var _10a=_109.responseText;
var data=eval("("+_10a+")");
initTree(treeNodeId,data);
}
function generateSelectFilter(){
var div=document.getElementById("treeFilterDiv");
if(!div){
return;
}
var _10d;
if(isDom){
_10d=document.createElementNS("http://www.w3.org/1999/xhtml","select");
}else{
_10d=document.createElement("select");
}
_10d.setAttribute("id","tree.filter.select.control");
if(filterLabel){
var _10e;
if(isDom){
_10e=document.createElementNS("http://www.w3.org/1999/xhtml","label");
}else{
_10e=document.createElement("label");
}
_10e.setAttribute("for","tree.filter.select.control");
_10e.appendChild(document.createTextNode(filterLabel));
div.appendChild(_10e);
div.appendChild(document.createElement("<br>"));
}
_10d.onchange=function(){
selectedFilterOptionIndex=this.selectedIndex;
applyFilter(this.options[this.selectedIndex].value);
};
for(var i=0;i<filterData.length;i++){
_10d.options.add(new Option(filterData[i].name,filterData[i].id),i);
if(filterData[i].selected==true){
selectedFilterOptionIndex=i;
_10d.options[i].selected=true;
}
}
div.appendChild(_10d);
_10d.form.onreset=function(){
window.setTimeout(function(){
var _110=document.getElementById("tree.filter.select.control");
_110.selectedIndex=selectedFilterOptionIndex;
},0);
return true;
};
}
function treeDebug(data){
if(treeDebug==true){
var div=document.getElementById("treeDebug");
div.appendChild(document.createTextNode(data));
div.appendChild(document.createElement("br"));
}
}
function findDivByContext(_113){
var divs=document.getElementsByTagName("div");
for(var i=0;i<divs.length;i++){
if(divs[i].getAttribute("class")=="tree-node"){
var _116=divs[i].getAttribute("context");
if(_116==_113){
return divs[i];
}
}
}
return null;
}
function createXMLHttpRequest(){
try{
return new ActiveXObject("Msxml2.XMLHTTP");
}
catch(e){
}
try{
return new ActiveXObject("Microsoft.XMLHTTP");
}
catch(e){
}
try{
return new XMLHttpRequest();
}
catch(e){
}
alert("XMLHttpRequest not supported");
return null;
}
function doRequest(_117,_118){
var url="."+treeServletPath+"?tree="+treeType+"&treecontext=";
var uid=(new Date()).getTime();
url=url+_117+"&refId="+refId+"&u="+uid;
var _11b=createXMLHttpRequest();
treeDebug("Opening url "+url);
_11b.open("GET",url,false);
_11b.send(null);
var _11c=_11b.responseText;
var data=eval("("+_11c+")");
if(data.command){
if(data.command.name=="REDIRECT"){
window.location=data.command.url;
return;
}
}
for(var i=0;i<data.length;i++){
var _11f=data[i].context;
var _120=data[i].checkable;
var _121=data[i].expandable;
createNode(_118,_11f,data[i].name,_120,_121,data[i].checked,data[i].disabled,data[i].resource,data[i].description,data[i].style,data[i].iconArray,data[i].iconDescriptionArray);
}
if(data.length==0){
createNode(_118,"",noneText,false,false,false,false,"","","");
}
}
var STATE_COLLAPSED="collapsed";
var STATE_UNPOPULATED="unpop";
var STATE_OPENED="opened";
var ELEMENT_NODE=1;
function nodeClick(_122){
if(document.activeElement.tagName.toLowerCase()=="input"){
return;
}
saveState(_122);
var _123=document.getElementById("treeNode"+_122);
var _124=document.getElementById("imageNode"+_122);
var _125="";
if(_123){
_125=_123.getAttribute("state");
}
if(_125==STATE_UNPOPULATED){
_125=STATE_COLLAPSED;
doRequest(_123.getAttribute("context"),_123.getAttribute("id"));
}
if(_125==STATE_COLLAPSED){
_124.setAttribute("src","images/lminus.gif");
_123.setAttribute("state",STATE_OPENED);
var _126=_123.childNodes;
for(var i=0;i<_126.length;i++){
if(_126[i].nodeType==ELEMENT_NODE){
if(_126[i].getAttribute("class")=="tree-node"){
_126[i].style.display="block";
}
}
}
}else{
if(_125==STATE_OPENED){
_124.setAttribute("src","images/lplus.gif");
_123.setAttribute("state",STATE_COLLAPSED);
var _126=_123.childNodes;
for(var i=0;i<_126.length;i++){
if(_126[i].nodeType==ELEMENT_NODE){
if(_126[i].getAttribute("class")=="tree-node"){
_126[i].style.display="none";
}
}
}
}
}
}
var nodeCount=0;
function createNode(_128,_129,_12a,_12b,_12c,_12d,_12e,_12f,_130,_131,_132,_133){
var _134=document.getElementById(_128);
nodeCount++;
var _135;
if(isDom){
_135=document.createElementNS("http://www.w3.org/1999/xhtml","div");
}else{
_135=document.createElement("div");
}
_134.appendChild(_135);
_135.setAttribute("class","tree-node");
_135.style.cssText="margin-left: 10px; display: block";
_135.setAttribute("context",_129);
_135.setAttribute("state",STATE_UNPOPULATED);
if(_134.getAttribute("state")==STATE_COLLAPSED){
_135.style.display="none";
}
var href;
if(isDom){
href=document.createElementNS("http://www.w3.org/1999/xhtml","a");
}else{
href=document.createElement("a");
}
href.setAttribute("title",_12a);
var _137="color: rgb(0,0,0); text-decoration:none;";
if(_131){
_137+=_131;
}
href.style.cssText=_137;
href.setAttribute("onkeypress","return hrefKeyPress(event);");
_135.appendChild(href);
var _138;
if(isDom){
_138=document.createElementNS("http://www.w3.org/1999/xhtml","img");
}else{
_138=document.createElement("img");
}
_138.style.cssText="border: none;";
_138.setAttribute("src","images/lplus.gif");
_138.setAttribute("alt","Expand or collapse");
href.appendChild(_138);
if(_12b==true){
var _139;
if(isDom){
_139=document.createElementNS("http://www.w3.org/1999/xhtml","label");
}else{
_139=document.createElement("label");
}
if(_12f==null){
_139.setAttribute("for","AGNODE:"+"");
_139.innerHTML="for AGNODE:"+"";
}else{
_139.setAttribute("for","AGNODE:"+_12f);
_139.innerHTML="for AGNODE:"+_12f;
}
_139.setAttribute("class","hidden");
_135.appendChild(_139);
var _13a;
if(isDom){
_13a=document.createElementNS("http://www.w3.org/1999/xhtml","input");
}else{
_13a=document.createElement("input");
}
_13a.setAttribute("type","checkbox");
if(_12f==null){
_13a.setAttribute("name","AGNODE:"+"");
_13a.setAttribute("id","AGNODE:"+"");
}else{
_13a.setAttribute("name","AGNODE:"+_12f);
_13a.setAttribute("id","AGNODE:"+_12f);
}
href.appendChild(_13a);
if(_12d){
if(isDom){
_13a.checked=true;
_13a.defaultChecked=true;
}else{
_13a.setAttribute("checked","true");
_13a.setAttribute("defaultChecked","true");
}
}
if(_12e){
if(isDom){
_13a.disabled=true;
}else{
_13a.setAttribute("disabled","true");
}
}else{
if(_12d){
var _13b;
if(isDom){
_13b=document.createElementNS("http://www.w3.org/1999/xhtml","input");
}else{
_13b=document.createElement("input");
}
_13b.setAttribute("type","hidden");
if(_12f==null){
_13b.setAttribute("name","AGHIDDEN:"+"");
_13b.setAttribute("id","AGHIDDEN:"+"");
}else{
_13b.setAttribute("name","AGHIDDEN:"+_12f);
_13b.setAttribute("id","AGHIDDEN:"+_12f);
}
href.appendChild(_13b);
}
}
}
var _13c=document.createTextNode(_12a+" ");
href.appendChild(_13c);
if(_130){
var _13d;
if(isDom){
_13d=document.createElementNS("http://www.w3.org/1999/xhtml","span");
}else{
_13d=document.createElement("span");
}
_13d.setAttribute("class","tree-node-desc");
_13d.appendChild(document.createTextNode("  "+_130));
href.appendChild(_13d);
}
if(_132){
for(iconIndex in _132){
var _13e;
if(isDom){
_13e=document.createElementNS("http://www.w3.org/1999/xhtml","img");
}else{
_13e=document.createElement("img");
}
_13e.style.cssText="border: none;";
_13e.setAttribute("src",_132[iconIndex]);
if(_133&&_133.length>iconIndex){
_13e.setAttribute("title",_133[iconIndex]);
_13e.setAttribute("alt",_133[iconIndex]);
}
href.appendChild(_13e);
href.appendChild(document.createTextNode(" "));
if(_12c){
_13e.setAttribute("id","imageNode"+nodeCount+iconIndex);
}
}
}
var _13f="treeNode"+nodeCount;
var _140="imageNode"+nodeCount;
if(!_12c){
_138.style.visibility="hidden";
}else{
href.setAttribute("href","javascript:nodeClick("+nodeCount+")");
_135.setAttribute("id",_13f);
_138.setAttribute("id",_140);
}
return _135;
}
function saveState(_141){
var _142=readCookie(cookieId);
var _143=false;
if(!_142){
_142="";
}
if(_142.length>0){
var ar=_142.split(",");
var _145=new String("");
for(var i=0;i<ar.length;i++){
if(ar[i]==_141){
_143=true;
}else{
if(_145.length>0){
_145+=",";
}
_145+=ar[i];
}
}
_142=_145;
}
if(!_143){
if(_142.length>0){
_142+=",";
}
_142+=_141;
}
storeCookie(cookieId,_142);
}
function restoreState(cid){
var _148=readCookie(cid);
storeCookie(cookieId,"");
storeCookie(cid,"");
if(_148){
var _149=_148.split(",");
for(var i=0;i<_149.length;i++){
nodeClick(_149[i],true);
}
}
}
function storeCookie(key,_14c){
if(_14c.length>500){
return;
}
var date=new Date();
date.setTime(date.getTime()+(2*60*1000));
var _14e="; expires="+date.toGMTString();
document.cookie=key+"="+_14c+_14e+"; path=/";
}
function readCookie(key){
var vals=document.cookie.split(";");
for(var i=0;i<vals.length;i++){
var val=vals[i];
while(val.charAt(0)==" "){
val=val.substring(1,val.length);
}
if(val.indexOf(key+"=")==0){
return val.substring(key.length+1,val.length);
}
}
return null;
}
function hrefKeyPress(_153){
var _154=_153.charCode?_153.charCode:_153.keyCode;
if(_154==32){
if(document.activeElement&&document.activeElement.tagName&&document.activeElement.tagName.toLowerCase()=="input"){
return false;
}
}
return true;
}
