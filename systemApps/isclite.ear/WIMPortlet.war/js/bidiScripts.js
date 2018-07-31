var LRM = '\u200E'; 
var RLM = '\u200F';
var VK_BACK = 0x8;
var VK_SHIFT = 0x10;
var VK_END = 0x23;
var VK_HOME = 0x24;
var VK_LEFT = 0x25;
var VK_RIGHT = 0x27;
var VK_DELETE = 0x2e;
var VK_PAGEUP = 0x21;
var VK_PAGEDOWN = 0x22;
var VK_UP   = 0x26;
var VK_DOWN = 0x28;
var VK_ENTER     = 0xD;
var VK_ESC       = 0x1B;
var VK_INSERT    = 0x2D;
var segmentsPointers = new Array();

function isBidiChar(c){
	if (c>1424 && c<1791 ) 
		return true; 
	else 
		return false;
};

function isLatinChar(c){
	if((c > 64 && c < 91)||(c > 96 && c < 123)) 
		return true; 
	else 
		return false;
};

function setDirection(obj){
	var text = obj.value; 
	var ce = obj.getAttribute("cetype");
	if (ce && ce == "ESEARCH") {
	    if (obj.className.indexOf('-rtl') >=0) 
		    obj.className = obj.className.substring(0,obj.className.indexOf('-rtl'));
	    return;
	}
	for (var i=0; i<text.length; i++) {
		if (isBidiChar(text.charCodeAt(i))) { 
		    if (obj.className.indexOf('-rtl') < 0)  
		        obj.className += '-rtl'; 
		    return;
		 }
		 else if(isLatinChar(text.charCodeAt(i))) {
			if (obj.className.indexOf('-rtl') >=0) 
				obj.className = obj.className.substring(0,obj.className.indexOf('-rtl'));			 
			return;
		 } 
	}
	if (!obj.getAttribute("defdir"))
		return;
	else if(obj.getAttribute("defdir").toLowerCase() == "ltr") {
	    if (obj.className.indexOf('-rtl') >=0) {
		    obj.className = obj.className.substring(0,obj.className.indexOf('-rtl'));
	    }
	}
	else {
	    if (obj.className.indexOf('-rtl') < 0)  
	        obj.className += '-rtl'; 		
	}
};

function processCE(event,object,ce_type) {
	var event1 = (event) ? event : ((window.event) ? window.event : "")
    keyTyped(event1,object,ce_type);			
};

function keyTyped(event,obj,ce_type){	
    var str1 = obj.value;
    var ieKey = event.keyCode;
    var ce = ce_type;
    var attrCe = obj.getAttribute("cetype");    
    if (attrCe)
    	ce = attrCe;
    
    if ((ieKey == VK_HOME) || (ieKey == VK_END) || (ieKey == VK_SHIFT) || 
        (ieKey == VK_ENTER) || (ieKey == VK_INSERT) || (ieKey == VK_ESC)) {
        return;
    }
    else if ((ieKey == VK_UP) || (ieKey == VK_DOWN)  || 
        (ieKey == VK_PAGEDOWN) || (ieKey == VK_PAGEUP)) {
        adjustCaret(event,obj);
        return;
    } 

    var cursorStart, cursorEnd;    
    var selection = getCaretPos(event,obj);
    if (selection) {
        cursorStart = selection[0];
        cursorEnd = selection[1];
    }

    if(ieKey == VK_LEFT){
		if (checkMarkers(str1.charAt(cursorStart - 1)) && cursorStart == cursorEnd) 
			setSelectedRange(obj, cursorStart - 1, cursorEnd - 1);
        return;
    }
    else if(ieKey == VK_RIGHT){
		if (checkMarkers(str1.charAt(cursorEnd - 1)) && cursorStart == cursorEnd) 
			setSelectedRange(obj, cursorStart + 1, cursorEnd + 1);
        return;
    }
   
    str2 = removeMarkers(str1);
    str2 = insertMarkers(obj,str2,ce);

    if(str1 != str2)
    {
        obj.value = str2;

		if (ieKey != VK_DELETE && ieKey != VK_BACK) {
			if (!checkMarkers(obj.value.charAt(cursorEnd))) 
				setSelectedRange(obj, cursorStart + 1, cursorEnd + 1);
		}	
    }
	else {
			setSelectedRange(obj, cursorEnd, cursorEnd);
	}
	
};

  
function parse(str,ce_type){    
    var i,i1;
    var delimiters;
    var previous = -1;
    if(segmentsPointers != null){
        for(i=0; i<segmentsPointers.length; i++)
            segmentsPointers[i] = null;
    }
	else
		segmentsPointers = new Array();
    var sp_len = 0;    
  
    if(ce_type == "EMAIL" || ce_type == "ESEARCH"){     
        delimiters = ce_type=="EMAIL"? "<>@.,;" : "<>@.,;*";         
        var inQuotes = false;    
        
        for(i = 0; i < str.length; i++){            
            if (str.charAt(i) == '\"') {
                if (isCharBeforeBiDiChar(str,i,previous)){
                    previous = i;    
                    segmentsPointers[sp_len] = i;
                    sp_len++;
                }                    
                i++;
                i1 = str.indexOf('\"', i);
                if(i1 >= i)
                    i = i1;
                if (isCharBeforeBiDiChar(str,i,previous)){
                    previous = i;    
                    segmentsPointers[sp_len] = i;
                    sp_len++;
                }                                   
            }
            
            if ((delimiters.indexOf(str.charAt(i)) >= 0) &&
                    isCharBeforeBiDiChar(str,i,previous)){
                        previous = i;    
                        segmentsPointers[sp_len] = i;
                        sp_len++;
            }                                            
        }                    
    }
/*    
    else if(ce_type == "SEARCH") {
    	for (i = 0; i < str.length; i++){
    		if (str.charAt(i) == "*" && isCharBeforeBiDiChar(str,i,previous)){
                previous = i;    
                segmentsPointers[sp_len] = i;
                sp_len++;    			
    		}	
    	}
    }
*/    
    else if(ce_type == "DN") {
        delimiters = "=, ";             	
    	for (i = 0; i < str.length; i++){
            if ((delimiters.indexOf(str.charAt(i)) >= 0) &&
                isCharBeforeBiDiChar(str,i,previous)){
                previous = i;    
                segmentsPointers[sp_len] = i;
                sp_len++;
            }                                            
    	}
    }    
    return segmentsPointers;
};   

function checkMarkers(str,pos) {
	if (pos >= str.length)
	    return false;
	var c = str.charAt(pos);
	if (c == LRM || c == RLM)
		return true;
	return false;	
};

function insertMarkers(obj,str,ce_type) {
    segmentsPointers = parse(str,ce_type); 
    var buf = str;
    shift = 0;                                                
    var n;
    var isRTL = obj.className.indexOf('-rtl') >= 0;
	var marker = isRTL? RLM : LRM;
    for (var i = 0; i< segmentsPointers.length; i++) {
        n = segmentsPointers[i];
        if(n != null){
            preStr = buf.substring(0, n + shift);
            postStr = buf.substring(n + shift, buf.length);
            buf = preStr + marker + postStr;
            shift++;
        }                                  
    }
    return buf;        
};

function removeMarkers(str){
	var result = str.replace(/\u200E/g,"");
	result = result.replace(/\u200F/g,"");
	result = result.replace(/\u202A/g,"");
	result = result.replace(/\u202B/g,"");	
	return result.replace(/\u202C/g,""); 
};    


function getCaretPos(event,obj){
    if(navigator.appName.indexOf("Internet Explorer") < 0) 
        return new Array(obj.selectionStart, obj.selectionEnd);    
    else {
        var position = 0;
        var range = document.selection.createRange().duplicate();
        var range2 = range.duplicate();
        var rangeLength = range.text.length;
        
        if (obj.type == "textarea")
            range2.moveToElementText(obj);
        else
            range2.expand('textedit');

        while (range.compareEndPoints('StartToStart', range2) > 0) {
            range.moveStart('character', -1);
            ++position;
        }
        
        return new Array(position, position + rangeLength);
    }
};

function setSelectedRange(obj,selectionStart,selectionEnd){
    if(navigator.appName.indexOf("Internet Explorer") > 0) {
        var range = obj.createTextRange();
        if (range) {
            if (obj.type == "textarea")
                range.moveToElementText(obj);
            else
                range.expand('textedit');

            range.collapse();            
            range.moveEnd('character', selectionEnd);
            range.moveStart('character', selectionStart);
            range.select();
        }
    } else {        
        obj.selectionStart=selectionStart;
        obj.selectionEnd=selectionEnd;
    }
};


function adjustCaret(event,obj) {
    var selection = getCaretPos(event,obj);
    if (selection) {
	   cursorStart = selection[0];
	   cursorEnd = selection[1];
	   if ((cursorStart == cursorEnd) && checkMarkers(obj.value.charAt(cursorEnd - 1))) 
			setSelectedRange(obj, cursorEnd + 1, cursorEnd + 1);
    }
};


function isCharBeforeBiDiChar(buffer, i, previous) {
    while (i > 0){    
        if(i == previous)
            return false;
                                
        if(isBidiChar(buffer.charCodeAt(i-1)))
            return true; 
        else if(isLatinChar(buffer.charCodeAt(i-1)))
            return false;
            
		i--;
       }
   return false;       
};

function setCE(obj, fid) {
   var tf = document.getElementById(fid);	
   var ce = obj.selectedIndex == 3? "ESEARCH" : "SEARCH";
   if (tf.getAttribute("cetype") && tf.getAttribute("cetype").toLowerCase() == ce)
	   return;
   tf.setAttribute("cetype", ce);
   setDirection(tf);   
   tf.value = insertMarkers(tf,removeMarkers(tf.value),ce);
}

function log(str) {
   if (!str)
	   console.log("String is " + str);
   var result = "";
   for (var i=0; i<str.length; i++) {
	   if (str.charAt(i) == LRM)
		   result += "<LRM>";
	   else if(str.charAt(i) == RLM)
		   result += "<RLM>";
	   else
		   result += str.charAt(i);
   }
   return result;
}

function handleBidi(form,fid) {
   var tf = document.getElementById(fid);	
   tf.value = removeMarkers(tf.value);
   return true;	
}