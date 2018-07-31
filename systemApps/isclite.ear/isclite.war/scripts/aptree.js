
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
var tree_root=null;
var maxNodes=0;
var browser=0;
var nodeIndex=null;
var totalWidth=0;
var abort=null;
var selected=null;
var expandDepth=-1;
var showselect=0;
var selectedicon="select.gif";
var selectednode=null;
var blankIcon="/ibm/console/images/blank20.gif";
var openFolder="/ibm/console/images/open_folder.gif";
var closedFolder="/ibm/console/images/closed_folder.gif";
var plusIcon="";
var minusIcon="";
var targetFrame="";
var inTable="";
var keepState="";
var showHealth="";
var showExpanders="";
var imagePath="";
var helpPath="";
var ns4InFormAdjustment=10;
var beginBreak="<NOBR>";
var endBreak="</NOBR>";
var isitblank=-1;
function TreeNode(_1,_2,_3,_4,id,_6,_7,_8){
this.browser=0;
this.icon=_1;
this.link=_3;
this.level=_6;
this.content=_2;
this.parent=_4;
this.children=new Array;
this.childCount=0;
this.id=id;
this.layer=null;
this.width=0;
this.height=0;
this.expanded=false;
this.visible=false;
this.PSrc=null;
this.MSrc=null;
this.button=null;
this.img=null;
this.selectable=_7;
this.health=_8;
this.imagePath=imagePath;
this.blankIcon=blankIcon;
this.showExpanders=showExpanders;
this.openFolder=openFolder;
this.closedFolder=closedFolder;
this.plusIcon=plusIcon;
this.minusIcon=minusIcon;
this.targetFrame=targetFrame;
this.showHealth=showHealth;
if(imagePath!=""){
this.icon=imagePath+this.icon;
this.blankIcon=imagePath+this.blankIcon;
this.plusIcon=imagePath+this.plusIcon;
this.minusIcon=imagePath+this.minusIcon;
this.openFolder=imagePath+this.openFolder;
this.closedFolder=imagePath+this.closedFolder;
}
var _9=_1;
this.isitblank=isitblank;
this.isitblank+=_9.indexOf("onepix.gif",0);
this.isitblank+=_9.indexOf("blank20.gif",0);
if(_9==""){
this.isitblank=1;
}
var _a=document.location.href;
this.isitblank+=_a.indexOf("/navigator.jsp",0);
this.displayTree=displayTree;
this.layout=JSTree_Layout;
this.displayStaticTree=displayStaticTree;
}
function initialize(){
var _b=tree_root;
if(_b==null){
return;
}
nodeIndex=new Array();
createNodeIndex(_b);
if(keepState){
top.treeopen.length=nodeIndex.length;
}
document.node=tree_root;
if(_b.browser==1||_b.browser==3){
var k;
for(k=0;k<nodeIndex.length;k++){
var _d=(nodeIndex[k].content.length*7)+(22*nodeIndex[k].level);
if(_d>totalWidth){
totalWidth=_d;
}
}
var _e=(nodeIndex.length*22)+20;
if(!inTable){
if(_b.browser==1){
document.write("<layer ID='Sizer'  visibility='visible' width='"+totalWidth+"' height='"+_e+"' Z-INDEX='0'></LAYER>");
}
if(_b.browser==3){
document.write("<div ID='Sizer' style='visibility:VISIBLE' width='"+totalWidth+"'  Z-INDEX='0'></div>");
}
}
}
if(inTable&&(_b.browser==1||_b.browser==3)){
displayStaticTree(_b,"",false,true,1);
}else{
displayTree(_b,"",false,true,1);
}
if((keepState)&&(!inTable)){
refreshCheck();
}
if(expandDepth!=null&&expandDepth!=0){
_b.visible=true;
}
if(_b.browser==1){
if(!inTable){
_b.layer.visibility="show";
}
}else{
if(_b.browser==3){
if(!inTable){
document.getElementById("Item0").style.visibility="VISIBLE";
}
}else{
document.all["Item0"].style.display="block";
}
}
_b.expanded=true;
if(_b.browser==1||_b.browser==3){
if(!inTable){
expandChildren(_b,expandDepth);
}
}else{
expandChildren(_b,expandDepth);
}
if(_b.browser==1||_b.browser==3){
if(!inTable){
_b.layout();
}
}
expandDepth=null;
if(!inTable){
if(_b.browser==1){
document.Sizer.visibility="hide";
}
if(_b.browser==3){
document.getElementById("Sizer").style.visibility="HIDDEN";
}
}
if(keepState){
top.treecounter=top.treecounter+1;
}
}
function createNodeIndex(_f){
nodeIndex[_f.id]=_f;
if(keepState){
if(top.treecounter==0){
top.treeopen[_f.id]=1;
}
}
var i;
for(i=0;i<_f.childCount;i++){
createNodeIndex(_f.children[i]);
}
}
function displayTree(_11,_12,_13,_14,_15){
if(_11.browser==1){
if(_14){
document.write("&#13;<layer class='indent"+_11.level+"' id='Item"+_11.id+"' visibility=hide width="+totalWidth+" z-index=1 >"+beginBreak);
}else{
if(_11.childCount>0){
document.write("&#13;<layer class='indent"+_11.level+"kids' id='Item"+_11.id+"' visibility=hide width="+totalWidth+" z-index=1 >"+beginBreak);
}else{
document.write("&#13;<layer class='indent"+_11.level+"' id='Item"+_11.id+"' visibility=hide width="+totalWidth+" z-index=1 >"+beginBreak);
}
}
}else{
if(browser==3){
if(_11.childCount>0){
document.write("<div class='indent"+_11.level+"kids' id=Item"+_11.id+" style='visibility: HIDDEN; font-size:110%' >"+beginBreak);
}else{
document.write("<div class='indent"+_11.level+"' id=Item"+_11.id+" style='visibility: HIDDEN; font-size:110%' >"+beginBreak);
}
}else{
if(_11.childCount>0){
document.write("<div class='indent"+_11.level+"kids' id=Item"+_11.id+"  style=\"display:'none'\" >"+beginBreak);
}else{
document.write("<div class='indent"+_11.level+"' id=Item"+_11.id+"  style=\"display:'none'\"  >"+beginBreak);
}
}
}
if(_11.browser==1){
_11.layer=document.layers["Item"+_11.id];
}else{
if(browser==3){
_11.layer=document.getElementById("Item"+_11.id);
}else{
_11.layer=document.all["Item"+_11.id];
}
}
if(_11.childCount>0){
if(!_14){
if(_11.showExpanders){
_11.PSrc=_11.plusIcon;
_11.MSrc=_11.minusIcon;
}else{
_11.PSrc=_11.blankIcon;
_11.MSrc=_11.blankIcon;
}
if(expandDepth==null||expandDepth<0||_15<=expandDepth){
useSrc=_11.MSrc;
}else{
useSrc=_11.PSrc;
}
document.write("<a onclick='expandCompressNode("+_11.id+");return false' href='javascript:expandCompressNode("+_11.id+")'>");
document.write("<img src='"+useSrc+"' name='PM"+_11.id+"' align='texttop' border='0' alt='"+_11.content+" image'>");
if(_11.isitblank<0){
document.write("<img src="+_11.icon+" name='icon"+_11.id+"'   align='texttop'  border='0' alt='"+_11.content+" image' >");
}
document.write("</a> ");
if(_11.browser==1){
_11.button=_11.layer.document.images["PM"+_11.id];
}else{
if(_11.browser==3||_11.browser==4){
_11.button=document.getElementsByName("PM"+_11.id)[0];
}else{
_11.button=document.all["PM"+_11.id];
}
}
}
if(_11.selectable){
document.write("<a target='"+_11.targetFrame+"' href=\""+ebs(_11.link)+" \">");
}else{
if(!_14){
document.write("<a onclick='expandCompressNode("+_11.id+");return false' href='javascript:expandCompressNode("+_11.id+")'>");
}
}
if(_14){
document.write(_11.content);
}else{
document.write(_11.content+"</a>");
}
if(_11.browser==1){
document.write(endBreak+"</layer>");
}else{
document.write(endBreak+"</div>");
}
if(_11.browser==1){
_11.img=_11.layer.document.images["icon"+_11.id];
}else{
if(_11.browser==3||_11.browser==4){
_11.img=document.getElementsByName("icon"+_11.id)[0];
}else{
_11.img=document.all["icon"+_11.id];
}
}
for(var i=0;i<_11.childCount;i++){
var _17=false;
if(i==(_11.childCount-1)){
_17=true;
}
_11.children[i].displayTree(_11.children[i],_12,_17,false,_15+1);
}
}else{
if(_11.isitblank<0){
document.write("<img src="+_11.icon+" name='icon"+_11.id+"'   align='texttop'  border='0' alt='"+_11.content+" image' > ");
}
if(_11.selectable){
document.write("<a target='"+_11.targetFrame+"' href=\""+ebs(_11.link)+"\">");
}
document.write(_11.content);
if(_11.selectable){
document.write("</a>");
}
if(_11.browser==1){
document.write(endBreak+"</layer>");
}else{
document.write(endBreak+"</div>");
}
}
if(_11.browser==1){
_11.img=_11.layer.document.images["icon"+_11.id];
}else{
if(_11.browser==3||_11.browser==4){
_11.img=document.getElementsByName("icon"+_11.id)[0];
}else{
_11.img=document.all["icon"+_11.id];
}
}
if(_11.browser==2||_11.browser==4){
if(_11.parent!=tree_root){
document.all["Item"+_11.id].style.display="none";
}
}
}
function addItem(_18,_19,_1a,_1b,_1c){
var _1d=true;
if(_18==null){
_18=tree_root;
}
if(_1b==""){
_1d=false;
}
if(helpPath!=""){
_1b=helpPath+_1b;
}
var _1e=_1c;
var _1f=new TreeNode(_19,_1a,_1b,_18,maxNodes++,_18.level+1,_1d,_1e);
_1f.browser=browser;
_18.children[_18.childCount++]=_1f;
return _1f;
}
function browserDetection(){
var _20;
var _21=window.navigator.userAgent.toLowerCase();
var _22=_21.indexOf("opera",0)+1;
var _23=_21.indexOf("gecko",0)+1;
var _24=_21.indexOf("mozilla",0)+1;
var _25=_21.indexOf("msie",0)+1;
if(_22>0){
_20=3;
document.all=document.getElementsByTagName("*");
}
if(_24>0){
if(_23>0){
_20=4;
document.all=document.getElementsByTagName("*");
}else{
if(_25>0){
_20=2;
}else{
_20=1;
}
}
}
return _20;
}
function addRoot(_26,_27,_28){
var _29=true;
if(_28==""){
_29=false;
}
browser=browserDetection();
var _2a=new TreeNode(_26,_27,_28,null,maxNodes++,1,_29);
_2a.browser=browser;
tree_root=_2a;
return _2a;
}
function setAbort(url){
abort=url;
}
function setImagePath(ip){
imagePath=ip;
}
function setHelpPath(ip){
helpPath=ip;
}
function setExpandDepth(_2e){
if(_2e!=null&&_2e>=0){
expandDepth=_2e;
}
}
function setShowExpanders(_2f){
showExpanders=_2f;
}
function setKeepState(ks){
keepState=ks;
}
function setShowHealth(sh){
showHealth=sh;
}
function setInTable(it){
inTable=it;
}
function setTargetFrame(tf){
targetFrame=tf;
}
function expandChildren(_34,_35){
var i;
if(_35){
_35--;
}
_34.expanded=true;
if(keepState){
if(top.treeopen){
top.treeopen[_34.id]=0;
}
}
for(i=0;i<_34.childCount;i++){
var _37=_34.children[i];
if(_37.browser==1){
document.layers["Item"+_37.id].visibility="show";
}else{
if(_37.browser==3){
document.getElementById("Item"+_37.id).style.visibility="VISIBLE";
}else{
document.all["Item"+_37.id].style.display="block";
}
}
_37.visible=true;
if(_35==null&&_37.expanded){
expandChildren(_37);
}else{
if(_35!=null&&_35!=0){
expandChildren(_37,_35);
}
}
}
}
function expandCompressNode(id){
var _39=nodeIndex[id];
var _3a=_39.icon;
var _3b=_3a.split("/");
var _3c=_3b[_3b.length-1];
var _3d=_39.openFolder.indexOf(_3c,0)+1;
var _3e=_39.closedFolder.indexOf(_3c,0)+1;
if(!_39.expanded){
_39.button.src=_39.MSrc;
if(_39.isitblank<0){
if(_3e>0){
_39.img.src=_39.openFolder;
}else{
_39.img.src=_39.icon;
}
}
_39.expanded=true;
expandChildren(_39);
}else{
_39.button.src=_39.PSrc;
if(_39.isitblank<0){
if(_3d>0){
_39.img.src=_39.closedFolder;
}else{
_39.img.src=_39.icon;
}
}
_39.expanded=false;
compressChildren(_39);
}
if(!inTable){
if(_39.browser==1||_39.browser==3){
_39.layout();
}
}
}
function compressChildren(_3f){
var i;
if(keepState){
if(top.treeopen){
top.treeopen[_3f.id]=1;
}
}
for(i=0;i<_3f.childCount;i++){
var _41=_3f.children[i];
if(_41.browser==1){
document.layers["Item"+_41.id].visibility="hide";
}else{
if(_41.browser==3){
document.getElementById("Item"+_41.id).style.visibility="HIDDEN";
}else{
document.all["Item"+_41.id].style.display="none";
}
}
_41.visible=false;
if(_41.childCount>0){
compressChildren(_41);
}
}
}
function JSTree_Layout(){
var _42;
if(browser==1){
_42=document.layers;
var i=0;
var _44=_42[i].pageY+_42[i].document.height-ns4InFormAdjustment;
for(i=1;i<_42.length;i++){
if(_42[i].visibility!="hide"){
_42[i].moveTo(_42[i].x,_44);
_44+=_42[i].document.height;
}
}
}else{
_42=document.getElementsByTagName("DIV");
var i=0;
var _44=_42[i].offsetTop+_42[i].style.pixelHeight+10;
for(i=1;i<_42.length;i++){
if(_42[i].style.visibility!="HIDDEN"){
_42[i].style.top=_44;
_44+=_42[i].style.pixelHeight;
}
}
}
}
function Sel(id){
var _46=nodeIndex[id];
if(selected!=null){
selected.img.src=selected.icon;
}
selected=_46;
selected.img.src=selectedicon;
var _47=selected.parent;
var _48=false;
while(_47&&_47!=tree_root){
if(!_47.expanded){
_47.button.src=_47.MSrc;
expandChildren(_47);
_47=_47.parent;
_48=true;
}else{
break;
}
}
}
function ebs(str){
if(!str||str==null){
return ("");
}
str=csrfProtectURI(str);
return (str.replace(/\\/g,"\\\\"));
}
var csrfCookie=null;
function csrfProtectURI(str){
if(csrfCookie==null){
csrfCookie=getCookie("com.ibm.ws.console.CSRFToken");
}
if(csrfCookie!=""){
str=str.replace(".do?",".do?csrfid="+csrfCookie+"&");
if(endsWith(str,".do")){
str=str+"?csrfid="+csrfCookie;
}
}
return str;
}
function getCookie(_4b){
if(null===_4b||""===_4b){
return "";
}
var _4c=window.document.cookie;
var _4d=_4c.lastIndexOf(_4b+"=");
if(_4d==-1){
return "";
}
var _4e=_4d+_4b.length+1;
var _4f=_4c.indexOf(";",_4e);
if(_4f==-1){
_4f=_4c.length;
}
var _50=_4c.substring(_4e,_4f);
return _50;
}
function endsWith(str,_52){
return str.indexOf(_52,str.length-_52.length)!==-1;
}
function clk(_53,_54){
_53.location=_54;
}
function refreshCheck(){
for(j=0;j<top.treeopen.length;j++){
if(top.treeopen[j]==0){
var _55=nodeIndex[j];
if(_55.button){
_55.button.src=_55.MSrc;
}
if(_55.isitblank<0){
var _56=_55.icon;
var _57=_56.split("/");
var _58=_57[_57.length-1];
var _59=_55.openFolder.indexOf(_58,0)+1;
var _5a=_55.closedFolder.indexOf(_58,0)+1;
if(_5a>0){
_55.img.src=_55.openFolder;
}
}
_55.expanded=true;
expandChildren(_55);
}
}
}
function displayStaticTree(_5b,_5c,_5d,_5e,_5f){
if(_5e){
document.write("<div class='indent"+_5b.level+"'>"+beginBreak);
}else{
document.write("<div class='indent"+_5b.level+"'>"+beginBreak);
}
if(_5b.childCount>0){
document.write("<img src="+_5b.icon+" name='icon"+_5b.id+"'   align='texttop'  border='0' alt='"+_5b.content+" image' > ");
if(_5b.selectable){
document.write("<a target='"+_5b.targetFrame+"' href=\""+ebs(_5b.link)+" \">");
}
if(_5e){
document.write(_5b.content);
}else{
document.write(_5b.content+"</a>");
}
document.write(endBreak+"</div>");
for(var i=0;i<_5b.childCount;i++){
var _61=false;
if(i==(_5b.childCount-1)){
_61=true;
}
_5b.children[i].displayStaticTree(_5b.children[i],_5c,_61,false,_5f+1);
}
}else{
document.write("<img src="+_5b.icon+" name='icon"+_5b.id+"'   align='texttop'  border='0' alt='"+_5b.content+" image' > ");
if(_5b.selectable){
document.write("<a target='"+_5b.targetFrame+"' href=\""+ebs(_5b.link)+"\">");
}
document.write(_5b.content);
if(_5b.selectable){
document.write("</a>");
}
document.write(endBreak+"</div>");
}
}
