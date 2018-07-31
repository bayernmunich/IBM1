
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
var browser=browserDetection();
var nodeIndex=null;
var selected=null;
var selectedId=0;
var expandDepth=-1;
var imagePath="";
var plusIcon="";
var minusIcon="";
var targetFrame="";
var keepState="";
var showExpanders="";
var allEnabled=false;
var ns4InFormAdjustment=-120;
var currentTraceLevel="";
var currentTraceSpec="";
var traceSpec="";
var concatSelections="";
var selections=new Array();
var indvTrace;
var levels=new Array("all=disabled","entryExit=enabled","event=enabled","debug=enabled","entryExit=enabled,event=enabled","entryExit=enabled,debug=enabled","event=enabled,debug=enabled","all=enabled");
var menuLeft="0";
var menuTop="";
if(opener.document.forms[0].selectedComponents==null){
if(opener.document.forms[0].selectedComponentsRuntime==null){
alert("The Trace Service page is not available");
}else{
traceSpec=opener.tempTraceSpec;
populateSelections();
}
}else{
traceSpec=opener.tempTraceSpec;
populateSelections();
}
for(m=0;m<selections.length;m++){
substringArray=selections[m].split("%");
if(substringArray[0]="*"){
allEnabled=true;
}
}
function TreeNode(_62,id,_64){
this.content=_64;
this.parent=_62;
this.children=new Array;
this.childCount=0;
this.id=id;
this.expanded=false;
this.visible=false;
this.button=null;
this.trace=0;
if(browser==1){
this.layer=document.layers["Item"+this.id];
this.Dimg=this.layer.document.images["Dicon"+this.id];
this.button=this.layer.document.images["PM"+this.id];
this.layout=JSTree_Layout;
if(this.id!=0){
document.layers["Item"+this.id].visibility="hide";
}else{
document.layers["Item"+this.id].visibility="show";
}
}else{
if(browser==3){
this.Dimg=document.getElementsByName("Dicon"+this.id);
}else{
this.Dimg=document.all["Dicon"+this.id];
}
}
}
function initialize(){
var _65=tree_root;
nodeIndex=new Array();
createNodeIndex(_65);
document.node=tree_root;
expandChildren(root,1);
reviewSpec();
document.temp.tmpspec.value=traceSpec;
window.status="Loaded "+nodeIndex.length+" items";
if(browser==4){
document.all["wait"].style.display="none";
}else{
if(browser==(1||3)){
document.layers["wait"].visibility="hide";
document.layers["Item0"].visibility="show";
}else{
document.all["wait"].style.display="none";
}
}
}
function populateSelections(){
var _66=traceSpec.replace(/\s/g,"");
var _67=_66.replace(/=/g,"|");
var _68=_67.replace(/,/g,"|");
var _69=_68.split(":");
var _6a="";
var _6b="";
for(v=0;v<_69.length;v++){
_6a="";
_6b="";
indvTrace=_69[v].split("|");
_6a=indvTrace[0];
var _6c=indvTrace[1]+"="+indvTrace[2];
if((indvTrace[3])&&(indvTrace[4]!="disabled")){
_6c=_6c+","+indvTrace[3]+"="+indvTrace[4];
}
if((indvTrace[5])&&(indvTrace[6]!="disabled")){
_6c=_6c+","+indvTrace[5]+"="+indvTrace[6];
}
_6b=_6c;
selections[selections.length]=_6a+"%"+_6b;
}
}
function reviewSpec(){
var _6d=traceSpec.replace(/\s/g,"");
var _6e=_6d.replace(/=/g,"|");
var _6f=_6e.replace(/,/g,"|");
var _70=_6f.split(":");
var _71="";
var _72="";
for(v=0;v<_70.length;v++){
indvTrace=_70[v].split("|");
_71=indvTrace[0];
var _73=indvTrace[1]+"="+indvTrace[2];
if((indvTrace[3])&&(indvTrace[4]!="disabled")){
_73=_73+","+indvTrace[3]+"="+indvTrace[4];
}
if((indvTrace[5])&&(indvTrace[6]!="disabled")){
_73=_73+","+indvTrace[5]+"="+indvTrace[6];
}
for(g=0;g<levels.length;g++){
if(_73==levels[g]){
_72=levels[g];
break;
}
}
for(i=0;i<nodeIndex.length;i++){
var _74=nodeIndex[i];
if(i==0){
_74.content="*";
}
if(_74.content==_71){
selectedId=_74.id;
openTree(_74);
changeLevel(g);
break;
}
}
}
}
function createNodeIndex(_75){
nodeIndex[_75.id]=_75;
var i;
for(i=0;i<_75.childCount;i++){
createNodeIndex(_75.children[i]);
}
}
function addItem(_77,id,_79){
var _7a=true;
var _7b=new TreeNode(_77,id,_79);
_77.children[_77.childCount++]=_7b;
return _7b;
}
function browserDetection(){
var _7c;
var _7d=window.navigator.userAgent.toLowerCase();
var _7e=_7d.indexOf("opera",0)+1;
var _7f=_7d.indexOf("gecko",0)+1;
var _80=_7d.indexOf("mozilla",0)+1;
var _81=_7d.indexOf("msie",0)+1;
if(_7e>0){
_7c=3;
document.all=document.getElementsByTagName("*");
}
if(_80>0){
if(_7f>0){
_7c=4;
document.all=document.getElementsByTagName("*");
}else{
if(_81>0){
_7c=2;
}else{
_7c=1;
}
}
}
return _7c;
}
function addRoot(id,_83){
selectable=false;
var _84=new TreeNode("",id,_83);
tree_root=_84;
return _84;
}
function expandChildren(_85,_86){
var i;
if(_86){
_86--;
}
_86=0;
_85.expanded=true;
for(i=0;i<_85.childCount;i++){
var _88=_85.children[i];
if(browser==1){
document.layers["Item"+_88.id].visibility="show";
}else{
if(browser==3){
document.getElementById("Item"+_88.id).style.visibility="VISIBLE";
}else{
document.all["Item"+_88.id].style.display="block";
}
}
_88.visible=true;
if(_86==null&&_88.expanded){
expandChildren(_88);
}else{
if(_86!=null&&_86!=0){
expandChildren(_88,_86);
}
}
}
}
function expandCompressNode(id){
var _8a=nodeIndex[id];
if(browser==1){
_8a.layer=document.layers["Item"+_8a.id];
_8a.button=_8a.layer.document.images["PM"+_8a.id];
}else{
if(browser==3){
_8a.button=document.getElementsByName("PM"+_8a.id);
}else{
_8a.button=document.all["PM"+_8a.id];
}
}
if(!_8a.expanded){
_8a.button.src=imagePath+"lminus.gif";
_8a.expanded=true;
expandChildren(_8a);
}else{
_8a.button.src=imagePath+"lplus.gif";
_8a.expanded=false;
compressChildren(_8a);
}
if(browser==1){
JSTree_Layout();
}
}
function compressChildren(_8b){
var i;
for(i=0;i<_8b.childCount;i++){
var _8d=_8b.children[i];
if(browser==1){
document.layers["Item"+_8d.id].visibility="hide";
}else{
if(browser==3){
document.getElementById("Item"+_8d.id).style.visibility="HIDDEN";
}else{
document.all["Item"+_8d.id].style.display="none";
}
}
_8d.visible=false;
if(_8d.childCount>0){
compressChildren(_8d);
}
}
}
function JSTree_Layout(){
var _8e;
_8e=document.layers;
var i=0;
var _90=_8e[i].pageY+_8e[i].document.height+ns4InFormAdjustment;
for(i=1;i<_8e.length;i++){
if(_8e[i].visibility!="hide"){
_8e[i].moveTo(_8e[i].x,_90);
_90+=_8e[i].document.height;
}
}
}
function changeLevel(lvl){
if(allEnabled==true){
clearTree();
}
var _92;
if(browser==4){
document.getElementById("progress").style.visibility="hidden";
}else{
if(browser==(1||3)){
document.layers["progress"].visibility="hide";
}else{
document.all["progress"].style.visibility="hidden";
}
}
selected=nodeIndex[selectedId];
if(selected.id=="0"){
selected.content="*";
}
if(selected.id=="0"){
allEnabled=true;
}else{
allEnabled=false;
}
if(lvl=="1"||lvl==1){
selected.Dimg.src=imagePath+"trace_1.gif";
selected.Dimg.alt="debug";
selected.trace=lvl;
}else{
if(lvl=="2"||lvl==2){
selected.Dimg.src=imagePath+"trace_2.gif";
selected.Dimg.alt="debug + entry/exit";
selected.trace=lvl;
}else{
if(lvl=="3"||lvl==3){
selected.Dimg.src=imagePath+"trace_3.gif";
selected.Dimg.alt="debug + entry/exit + event";
selected.trace=lvl;
}else{
if(lvl=="4"||lvl==4){
selected.Dimg.src=imagePath+"trace_4.gif";
selected.Dimg.alt="entry/exit + event";
selected.trace=lvl;
}else{
if(lvl=="5"||lvl==5){
selected.Dimg.src=imagePath+"trace_5.gif";
selected.Dimg.alt="debug + event";
selected.trace=lvl;
}else{
if(lvl=="6"||lvl==6){
selected.Dimg.src=imagePath+"trace_6.gif";
selected.Dimg.alt="entry/exit";
selected.trace=lvl;
}else{
if(lvl=="7"||lvl==7){
selected.Dimg.src=imagePath+"trace_7.gif";
selected.Dimg.alt="event";
selected.trace=lvl;
}else{
selected.Dimg.src=imagePath+"trace_0.gif";
selected.Dimg.alt="all disabled";
selected.trace=lvl;
}
}
}
}
}
}
}
currentTraceLevel=selected.Dimg.src;
currentTraceSpec=selected.content+levels[selected.trace];
if(selected.id!="0"){
for(j=0;j<selected.childCount;j++){
var _93=selected.children[j];
if(_93.childCount>0){
_93.Dimg.src=currentTraceLevel;
_93.trace=selected.trace;
changeDIconChild(_93.id);
}else{
_93.Dimg.src=currentTraceLevel;
_93.trace=selected.trace;
}
}
}else{
for(i=1;i<nodeIndex.length;i++){
var _94=nodeIndex[i];
_94.Dimg.src=currentTraceLevel;
_94.trace=selected.trace;
}
}
storeSelection(selected.content,levels[selected.trace]);
printSelection();
}
function clearTree(){
clearImage=imagePath+"trace_0.gif";
traceLevel=0;
for(i=0;i<nodeIndex.length;i++){
var _95=nodeIndex[i];
_95.Dimg.src=clearImage;
_95.trace=traceLevel;
}
}
function storeSelection(_96,_97){
if(_96=="*"){
for(m=0;m<selections.length;m++){
selections[m]="blank%blank";
}
}else{
if(_96!="*"){
for(n=0;n<selections.length;n++){
selectionContent=selections[n].split("%");
if(selectionContent[0]=="*"){
selections[n]="blank%blank";
}
}
}
}
var _98=false;
if(selections.length==0){
selections[0]=_96+"%"+_97;
}else{
for(i=0;i<selections.length;i++){
substringArray=selections[i].split("%");
if(substringArray[0]==_96){
selections[i]=substringArray[0]+"%"+_97;
_98=true;
}
}
if(_98==false){
selections[selections.length]=_96+"%"+_97;
}
}
_98=false;
}
function printSelection(){
concatSelections="";
if(selections.length==1){
substringArray=selections[0].split("%");
document.temp.tmpspec.value=substringArray[0]+"="+substringArray[1];
}else{
for(i=0;i<selections.length;i++){
substringArray=selections[i].split("%");
var _99=substringArray[0]+"="+substringArray[1];
if(_99!="blank=blank"){
if(concatSelections==""){
concatSelections=_99;
}else{
concatSelections=concatSelections+": "+_99;
}
}
}
document.temp.tmpspec.value=concatSelections;
}
}
function publishSpec(){
if(opener.document.forms[0].selectedComponents==null){
if(opener.document.forms[0].selectedComponentsRuntime==null){
alert("The console Trace Service page is not available, please navigate to that page in the console clicking Apply");
}else{
if(document.temp.tmpspec.value!=""){
opener.document.forms[0].selectedComponentsRuntime.value=document.temp.tmpspec.value;
opener.tempTraceSpec=document.temp.tmpspec.value;
}else{
opener.document.forms[0].selectedComponentsRuntime.value="*=all=disabled";
opener.tempTraceSpec="*=all=disabled";
}
}
}else{
if(document.temp.tmpspec.value!=""){
opener.document.forms[0].selectedComponents.value=document.temp.tmpspec.value;
opener.tempTraceSpec=document.temp.tmpspec.value;
}else{
opener.document.forms[0].selectedComponents.value="*=all=disabled";
opener.tempTraceSpec="*=all=disabled";
}
}
}
function openTree(_9a){
node=_9a;
if(!node.expanded){
if(browser==1){
node.layer=document.layers["Item"+node.id];
node.button=node.layer.document.images["PM"+node.id];
}else{
if(browser==3){
node.button=document.getElementsByName("PM"+node.id);
}else{
node.button=document.all["PM"+node.id];
}
}
if(node.button){
node.button.src=minusIcon;
}
node.expanded=true;
expandChildren(node);
openTree(node.parent);
}
}
function setAbort(url){
abort=url;
}
function setImagePath(ip){
imagePath=ip;
}
function setExpandDepth(_9d){
if(_9d!=null&&_9d>=0){
expandDepth=_9d;
}
}
function setShowExpanders(_9e){
showExpanders=_9e;
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
function ebs(str){
if(!str||str==null){
return ("");
}
return (str.replace(/\\/g,"\\\\"));
}
function clk(_a4,_a5){
_a4.location=_a5;
}
function changeDIcon(id){
var _a7=0;
var _a8=nodeIndex[id];
selectedId=id;
}
function changeDIconChild(id){
var _aa=nodeIndex[id];
for(k=0;k<_aa.childCount;k++){
var _ab=_aa.children[k];
if(_ab.childCount>0){
changeDIconChild(_ab.id);
}else{
_ab.Dimg.src=currentTraceLevel;
_ab.trace=_aa.trace;
}
}
}
function moveMenu(){
eY="";
if(browser==4){
document.getElementById("progress").style.top=menuTop;
document.getElementById("progress").style.left=menuLeft;
document.getElementById("progress").style.visibility="visible";
}else{
if(browser==(1||3)){
document.layers["progress"].visibility="show";
document.layers["progress"].top=menuTop;
document.layers["progress"].left=menuLeft;
}else{
document.all["progress"].style.pixelTop=menuTop;
document.all["progress"].style.pixelLeft=menuLeft;
document.all["progress"].style.visibility="visible";
}
}
}
function stateArrayPush(){
this[this.length]=arguments[i];
return this.length;
}
function stateArraySplice(_ac,len,_ae){
var _af=new Array();
var _b0=new Array();
_af=_ae.slice(_ac,_ac+len);
_b0=_ae.slice(_ac+len);
_ae.length=_ac;
for(var i=0;i<_b0.length;i++){
_ae[_ae.length]=_b0[i];
}
return _af;
}
function hideMenu(){
if(browser==4){
document.getElementById("progress").style.visibility="hidden";
}else{
if(browser==1||browser==3){
document.layers["progress"].visibility="hide";
}else{
document.all["progress"].style.visibility="hidden";
}
}
}
function wheresTheClick(e){
var _b3="";
if(browser==4){
menuLeft=e.clientX;
menuTop=e.clientY;
whatpar=e.target.parentNode;
_b3=whatpar.name;
if(_b3=="treeitem"){
moveMenu(selected);
}else{
hideMenu();
}
}
if((browser==1)||(browser==3)){
menuLeft=e.pageX;
menuTop=e.pageY;
_b3=e.target.href;
if(e.target.href){
if(_b3.indexOf("changeDIcon")>-1){
moveMenu();
}else{
document.layers["progress"].visibility="hide";
}
}else{
document.layers["progress"].visibility="hide";
}
routeEvent(e);
}
if(browser==2){
e=event;
menuLeft=e.clientX;
menuTop=e.srcElement.offsetTop;
_b3=e.srcElement.name;
if(_b3=="treeitem"){
moveMenu(selected);
}else{
hideMenu();
}
}
}
