
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var isNav4,isIE;
var coll="";
var styleObj="";
if(parseInt(navigator.appVersion)>=4){
if(navigator.appName=="Netscape"){
isNav4=true;
}else{
isIE=true;
coll="all.";
styleObj=".style";
}
}
function refresh(){
if(refreshTree.value=="true"){
parent.navigation_tree.location.reload(true);
}
}
function confirmdelete(src,_e4){
if(src.value!="Delete"&&src.value!="Remove"){
return true;
}
var _e5=false,i,length;
var _e6=false;
for(i=0;i<myform.length;i++){
if(myform[i].name=="deleteIDs"){
_e6=true;
break;
}
}
if(_e6){
length=myform.deleteIDs.length;
if(length>=2){
for(i=0;i<myform.deleteIDs.length;i++){
if(myform.deleteIDs[i].checked){
_e5=true;
break;
}
}
}else{
if(myform.deleteIDs.checked){
_e5=true;
}
}
if(_e5){
return (confirm("Are you sure you wish to permanently delete these "+_e4+"?"));
}else{
return false;
}
}
}
function updateDeleteIDs(){
var _e7;
var _e8=false;
for(i=0;i<myform.length;i++){
if(myform[i].name=="deleteIDs"){
_e8=true;
break;
}
}
if(_e8){
_e7=myform.deleteIDs.length;
if(myform.checkAll.checked){
if(_e7>=2){
for(i=0;i<myform.deleteIDs.length;i++){
myform.deleteIDs[i].checked=true;
}
}else{
myform.deleteIDs.checked=true;
}
}else{
if(_e7>=2){
for(i=0;i<myform.deleteIDs.length;i++){
myform.deleteIDs[i].checked=false;
}
}else{
myform.deleteIDs.checked=false;
}
}
}
}
var numchecks=0;
var allchecked=false;
var multiall=new Array();
function updateCheckAll(_e9,_ea){
var _eb;
var _ec=0;
var _ed=_e9.length;
if(_ea!=null){
var _ee=_ea.substring(0,_ea.indexOf("CheckBox"));
_ee="allchecked"+_ee;
}
for(var i=0;i<_ed;i++){
var _f0=_e9.elements[i].name;
var _f1=_f0.indexOf("selectedObjectIds",0)+1;
var _f2=_f0.indexOf(_ee,0)+1;
if(_f2>0){
_ec=i;
}
if(_ea==null){
if(_f1>0){
if(allchecked!=true){
_e9.elements[i].checked=true;
_eb=true;
}else{
_e9.elements[i].checked=false;
_eb=false;
}
}
var _f3=_e9.elements[i].name;
var _f4=_f3.indexOf("checkBoxes",0)+1;
if((_f3=="checkBoxes1")||(_f3=="checkBoxes2")){
_f4=0;
}
if(_f4>0){
if(allchecked!=true){
_e9.elements[i].checked=true;
_eb=true;
}else{
_e9.elements[i].checked=false;
_eb=false;
}
}
}else{
var _f5=_e9.elements[i].name;
var _f6=_f5.indexOf(_ea,0)+1;
if(_f6>0){
if((allchecked!=true)&&(multiall[_ee]!=true)){
_e9.elements[i].checked=true;
_eb=true;
}else{
_e9.elements[i].checked=false;
_eb=false;
}
}
}
}
if(_eb==true){
if(_ea==null){
allchecked=true;
_e9.allchecked.checked=true;
}else{
multiall[_ee]=true;
_e9.elements[_ec].checked=true;
}
}else{
if(_ea==null){
allchecked=false;
_e9.allchecked.checked=false;
}else{
multiall[_ee]=false;
_e9.elements[_ec].checked=false;
}
}
}
function checkChecks(_f7,_f8){
var _f9=0;
var _fa=0;
var _fb=_f7.length;
for(var i=0;i<_fb;i++){
var _fd=_f7.elements[i].name;
var _fe=_fd.indexOf("selectedObjectIds",0)+1;
var _ff=_f7.elements[i].name;
var _100=_ff.indexOf("checkBoxes",0)+1;
if((_ff=="checkBoxes1")||(_ff=="checkBoxes2")){
_100=0;
}
if(_f8!=null){
var _101=_fd.indexOf(_f8.name,0)+1;
}
if(_fe>0){
if(_f7.elements[i].checked==true){
_f9+=1;
}else{
_fa+=1;
}
}
if(_101>0){
if(_f7.elements[i].checked==true){
_f9+=1;
}else{
_fa+=1;
}
}
if(_100>0){
if(_f7.elements[i].checked==true){
_f9+=1;
}else{
_fa+=1;
}
}
}
if(allchecked==true){
if(_fa>0){
allchecked=false;
_f7.allchecked.checked=false;
}
}else{
if(_fa==0){
allchecked=true;
_f7.allchecked.checked=true;
}
}
}
