
//Licensed Materials - Property of IBM
//
//5724-I63, 5724-H88, 5724-H89, 5655-N02, 5724-J08
// 
//Copyright IBM Corp. 2005, 2007 All Rights Reserved.
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with
//IBM Corp.
  
function ariaOnLoadDetail(){
dojo.query(".textEntryRequired, .textEntryRequiredLong",dojo.byId("wasUniPortlet")).forEach(function(node){
node.setAttribute("aria-required","true");
});
dojo.query("input, textarea",dojo.byId("wasUniPortlet")).forEach(function(node){
var _2e9=dojo.byId("invalidFields").value;
if(node.id&&(node.type=="text"||node.type=="textarea"||node.type=="select"||node.type=="file")&&_2e9){
var _2ea=_2e9.split(",");
for(var i=0;i<_2ea.length;i++){
if(node.id==_2ea[i]){
node.setAttribute("aria-invalid","true");
break;
}
}
}
});
}
function ariaOnLoadTop(){
dojo.query("table").forEach(function(_2ec){
var _2ed="className";
if(isDom){
_2ed="class";
}
if(_2ec.getAttribute(_2ed)=="button-section"){
fixTable(_2ec);
}else{
if(_2ec.getAttribute(_2ed)=="framing-table"){
if(_2ec.getAttribute("role")&&_2ec.getAttribute("role")=="presentation"){
fixTable(_2ec);
}
}else{
if(_2ec.getAttribute(_2ed)=="paging-table"){
fixTable(_2ec);
}else{
if(!_2ec.getAttribute("role")){
fixTable(_2ec);
}
}
}
}
});
dojo.query("html").forEach(function(_2ee){
if(_2ee.getAttribute("lang")){
_2ee.setAttribute("lang",_2ee.getAttribute("lang").replace("_","-"));
}
});
}
function fixTable(_2ef){
dojo.query("td",_2ef).forEach(function(_2f0){
_2f0.removeAttribute("scope");
_2f0.removeAttribute("headers");
});
_2ef.setAttribute("role","presentation");
_2ef.removeAttribute("summary");
}
