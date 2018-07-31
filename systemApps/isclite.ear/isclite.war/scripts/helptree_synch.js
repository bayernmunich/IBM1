
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
function selectCheck(){
var _155=top.HelpDetail.location.href;
var _156="no";
var _157=top.nodeIndex;
for(var a=0;a<_157.length;a++){
if(_157[a].link.indexOf(".html")>-1){
if(_155.indexOf(_157[a].link)>-1){
_156="yes";
break;
}
}
}
if(_156=="yes"){
var _159=_157[a];
var _15a=_157[top.prioron];
top.prioron=top.currenton;
top.currenton=a;
var lev=_159.level-1;
var _15c=_159;
for(var x=1;x<lev;x++){
parennode=_157[_15c.parent.id];
if(browser==1){
parennode.layer=document.layers["Item"+parennode.id];
parennode.button=parennode.layer.document.images["PM"+parennode.id];
}else{
if(browser==3){
parennode.button=document.getElementsByName("PM"+parennode.id);
}else{
parennode.button=document.all["PM"+parennode.id];
}
}
if(parennode.button){
parennode.button.src=imagePath+"/ibm/console/images/lminus.gif";
}
parennode.expanded=true;
expandChildren(parennode);
if(browser==1||browser==3){
parennode.layout();
}
_15c=parennode;
}
var _15e="Item"+top.prioron;
var now="Item"+top.currenton;
if(browser==2){
if(top.prioron!=""){
document.all[_15e].style.backgroundColor="#FFFFFF";
}
document.all[now].style.backgroundColor="#E2E2E2";
thisItem=document.all[now].offsetTop;
thisWin=document.body.clientHeight;
thisWinscroll=document.body.scrollTop;
visibleWin=thisWinscroll+thisWin;
if(thisItem>visibleWin){
vis=thisItem-100;
window.scrollTo(0,vis);
}
if(thisItem<thisWinscroll){
vis=thisItem-100;
window.scrollTo(0,vis);
}
}else{
if(browser==4){
if(top.prioron!=""){
document.all[_15e].style.backgroundColor="#FFFFFF";
}
document.all[now].style.backgroundColor="#E2E2E2";
thisItem=document.all[now].offsetTop;
window.scrollTo(0,thisItem-25);
}else{
if(top.prioron!=""){
document.layers[_15e].bgColor=null;
}
document.layers[now].bgColor="#E2E2E2";
thisItem=document.layers[now].top;
thisWin=window.innerHeight;
thisWinscroll=window.pageYOffset;
visibleWin=thisWinscroll+thisWin;
if(thisItem>visibleWin){
vis=thisItem-100;
window.scrollTo(0,vis);
}
if(thisItem<thisWinscroll){
vis=thisItem-200;
window.scrollTo(0,vis);
}
}
}
if(browser==1||browser==3){
var _160=document.layers;
var i=0;
var posY=_160[i].pageY+_160[i].document.height-ns4InFormAdjustment;
for(i=1;i<_160.length;i++){
if(_160[i].visibility!="hide"){
_160[i].moveTo(_160[i].x,posY);
posY+=_160[i].document.height;
}
}
}
return false;
}
}
