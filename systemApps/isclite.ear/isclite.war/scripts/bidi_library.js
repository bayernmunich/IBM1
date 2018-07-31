
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var LRM="\u200e";
var VK_SHIFT=16;
var VK_END=35;
var VK_HOME=36;
var VK_LEFT=37;
var VK_RIGHT=39;
function isIE(){
var _b4=navigator.appName;
if(_b4=="Microsoft Internet Explorer"){
return true;
}
return false;
}
function isInternetExplorer(){
var _b5=navigator.appName;
if(_b5=="Microsoft Internet Explorer"){
return true;
}
return false;
}
function processCopy(obj){
var _b7="";
try{
if(isIE()){
var w=obj.document.parentWindow;
var e=w.event;
var _ba=obj.document.selection.createRange();
_b7=_ba.text;
}else{
_b7=obj.document.getSelection();
}
var _bb=removeMarkers(_b7);
if(window.clipboardData){
window.clipboardData.setData("Text",_bb);
e.returnValue=false;
}
}
catch(ex){
}
}
function isBidiChar(c){
if(c>1424&&c<1791){
return true;
}else{
return false;
}
}
function isLatinChar(c){
if((c>64&&c<91)||(c>96&&c<123)){
return true;
}else{
return false;
}
}
function isCharBeforeBiDiChar(_be,i,_c0){
while(i>0){
if(i==_c0){
return false;
}
if(isBidiChar(_be.charCodeAt(i-1))){
return true;
}else{
if(isLatinChar(_be.charCodeAt(i-1))){
return false;
}
}
i--;
}
return false;
}
function parse(str){
var i,i1;
var _c3;
var _c4=-1;
var _c5=new Array();
var _c6=0;
_c3="/\\:.";
for(i=0;i<str.length;i++){
if((_c3.indexOf(str.charAt(i))>=0)&&isCharBeforeBiDiChar(str,i,_c4)){
_c4=i;
_c5[_c6]=i;
_c6++;
}
}
return _c5;
}
function insertMarkers(str){
if(isIE){
if(str.indexOf("fakepath")>-1){
shift=9;
str=str.substring(str.indexOf("fakepath")+shift,str.length);
}
}
var _c8=parse(str);
var buf=str;
shift=0;
var n;
var _cb=LRM;
for(var i=0;i<_c8.length;i++){
n=_c8[i];
if(n!=null){
preStr=buf.substring(0,n+shift);
postStr=buf.substring(n+shift,buf.length);
buf=preStr+_cb+postStr;
shift++;
}
}
return buf;
}
function removeMarkers(str){
var _ce=str.replace(/\u200E/g,"");
_ce=_ce.replace(/\u200F/g,"");
_ce=_ce.replace(/\u202A/g,"");
_ce=_ce.replace(/\u202B/g,"");
return _ce.replace(/\u202C/g,"");
}
function fakeOnFocus(obj){
setRelatedElements(obj);
}
function fileOnFocus(obj){
setRelatedElements(obj);
obj.relatedElement.value=insertMarkers(obj.value);
}
function processChange(obj){
obj.relatedElement.value=insertMarkers(obj.value);
obj.relatedElement.focus();
}
function onFakeKeyDown(_d2,obj){
setRelatedElements(obj);
var e;
var _d5=navigator.appName;
if(!isInternetExplorer()){
e=_d2;
}else{
var w=obj.document.parentWindow;
e=w.event;
}
var _d7=e.keyCode;
if(e.altKey||e.ctrlKey||_d7==VK_SHIFT){
return true;
}else{
if(!(_d7==VK_HOME||_d7==VK_END||_d7==VK_LEFT||_d7==VK_RIGHT)){
obj.relatedElement.focus();
return false;
}else{
return true;
}
}
}
function onFileMouseDown(obj){
setRelatedElements(obj);
obj.relatedElement.focus();
return false;
}
function onFakeFileMouseDown(obj){
setRelatedElements(obj);
obj.relatedElement.focus();
obj.relatedElement.onmousedown();
return false;
}
function onFileKeyDown(obj){
setRelatedElements(obj);
obj.relatedElement.focus();
return false;
}
function onFileKeyUp(obj){
return false;
}
function onFileKeyPress(obj){
return false;
}
function setRelatedElements(obj){
if(obj.relatedElement){
return;
}
var _de=obj.parentNode.childNodes;
var _df;
var _e0=obj.id+"_bidi";
var _e1=""+obj.id;
for(var i=0;i<_de.length;i++){
if(obj.id==_e0&&_de[i].id==_e1||obj.id==_e1&&_de[i].id==_e0){
_df=_de[i];
break;
}
}
obj.relatedElement=_df;
_df.relatedElement=obj;
}
