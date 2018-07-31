
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
function showHideSimpleCollectionButtons(prop){
var _2bc=document.getElementById(prop+"CollectionTable");
var trs=_2bc.tBodies[0].rows;
var _2be=0;
for(var i=1;i<trs.length;i++){
if(trs[i].style.display!="none"){
tds=trs[i].cells;
for(var j=1;j<tds.length;j++){
if(tds[j].getElementsByTagName("div").length>1){
if(tds[j].getElementsByTagName("div")[1].style.display=="none"){
_2be++;
}
}
}
}
}
var _2c1=document.getElementById(prop+"ButtonTable");
if(_2c1!=null){
if(_2be>0){
var trs=_2c1.tBodies[0].rows;
trs[0].cells[1].style.display="";
}else{
var trs=_2c1.tBodies[0].rows;
trs[0].cells[1].style.display="none";
}
}
if(dojo.byId(""+prop+"simpleCollectionDelete")){
dojo.byId(""+prop+"simpleCollectionDelete").disabled=true;
}
if(dojo.byId(""+prop+"simpleCollectionEdit")){
dojo.byId(""+prop+"simpleCollectionEdit").disabled=true;
}
}
function enterKeyNewProperty(e,prop){
var _2c4;
if(e&&e.which){
_2c4=e.which;
}else{
if(!isDom){
e=event;
}
_2c4=e.keyCode;
}
if(_2c4==13){
newProperty(prop);
return false;
}
return true;
}
function newProperty(prop){
var _2c6=document.getElementById(prop+"CollectionTable");
var trs=_2c6.tBodies[0].rows;
var tr=document.getElementById(prop+"HiddenAddRow");
var _2c9=tr.cloneNode(true);
function addRow(){
_2c6.tBodies[0].insertBefore(_2c9,tr);
var trs=_2c6.tBodies[0].rows;
trs[trs.length-2].removeAttribute("id");
trs[trs.length-2].style.display="";
tds=trs[trs.length-2].cells;
for(var j=0;j<tds.length;j++){
var z=trs.length-3;
var _2cd=tds[j].getElementsByTagName("label")[0];
var _2ce=tds[j].getElementsByTagName("input")[0];
var _2cf=tds[j].getElementsByTagName("select")[0];
var div=tds[j].getElementsByTagName("div")[0];
if(j==1&&_2ce){
_2ce.focus();
}
if(j==0){
_2cd.title=_2cd.title+(z+1);
div.title=div.title+(z+1);
}
if(_2ce){
_2ce.id=_2ce.id+z;
_2ce.name=_2ce.name+z;
}
if(_2cf){
_2cf.id=_2cf.id+z;
_2cf.name=_2cf.name+z;
}
if(_2cd){
_2cd.htmlFor=_2cd.htmlFor+z;
}
}
showHideSimpleCollectionButtons(prop);
}
window.setTimeout(addRow,0);
}
function editProperty(prop){
var _2d2=document.getElementById(prop+"CollectionTable");
var trs=_2d2.tBodies[0].rows;
for(var i=1;i<trs.length;i++){
tds=trs[i].cells;
if(tds[0].getElementsByTagName("input")[0].checked){
for(var j=1;j<tds.length;j++){
if(tds[j].getElementsByTagName("div").length>1){
tds[j].getElementsByTagName("div")[0].style.display="none";
tds[j].getElementsByTagName("div")[1].style.display="block";
}
}
tds[0].getElementsByTagName("input")[0].checked=false;
}
}
showHideSimpleCollectionButtons(prop);
}
function deleteProperty(prop){
var _2d7=document.getElementById(prop+"CollectionTable");
var trs=_2d7.tBodies[0].rows;
for(var i=1;i<trs.length;i++){
tds=trs[i].cells;
if(tds[0].getElementsByTagName("input")[0].checked){
for(var j=1;j<tds.length;j++){
if(tds[j].getElementsByTagName("input").length>0){
tds[j].getElementsByTagName("input")[0].value="";
}
}
trs[i].style.display="none";
tds[0].getElementsByTagName("input")[0].checked=false;
}
}
var _2db=0;
for(var i=1;i<trs.length;i++){
if(trs[i].style.display!="none"){
_2db++;
}
}
if(_2db==0){
newProperty(prop);
}
showHideSimpleCollectionButtons(prop);
}
function enableDisableDeleteButton(_2dc,_2dd){
var _2de=""+_2dd+"simpleCollectionDelete";
if(dojo.byId(_2de)){
var _2df=false;
var _2e0=true;
var _2e1=""+_2dd+"CollectionTable";
dojo.query("input",dojo.byId(_2e1)).forEach(function(node){
if(node.id&&node.type=="checkbox"){
if(node.checked){
if(node.getAttribute("onclick").toString().indexOf("enableDisableDeleteButton('disable'")!=-1){
_2df=true;
}
_2e0=false;
}
}
});
if(_2df||_2e0){
dojo.byId(_2de).disabled=true;
}else{
dojo.byId(_2de).disabled=false;
}
}
}
function enableDisableEditButton(_2e3,_2e4){
if(dojo.byId(""+_2e4+"simpleCollectionEdit")){
var _2e5=true;
dojo.query("input",dojo.byId(_2e4+"CollectionTable")).forEach(function(node){
if(node.id&&node.type=="checkbox"){
if(node.checked&&node.getAttribute("onclick").toString().indexOf("enableDisableEditButton('enable'")!=-1){
_2e5=false;
}
}
});
if(_2e5){
dojo.byId(""+_2e4+"simpleCollectionEdit").disabled=true;
}else{
dojo.byId(""+_2e4+"simpleCollectionEdit").disabled=false;
}
}
}
