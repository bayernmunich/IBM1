 // 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp. 1997, 2005
 // The source code for this program is not published or otherwise divested
 // of its trade secrets, irrespective of what has been deposited with the
 // U.S. Copyright Office
/*
 * @(#) 1.1.1.1 WEBUI/ws/code/webui.classloader/src/classloader/com.ibm.ws.console.classloader/scripts/js_functions.js, WAS.webui.classloader, WAS855.WEBUI, cf131750.06 9/1/05 14:35:55  [12/17/17 19:52:18]
 */
      	var win;
      	var url;
      	var currentPosition;
      	var href;
      	
      	function set_href() {
      	  //alert(location.protocol);
      	  href=location.protocol+"//"+location.host+"/ibm/console/classLoaderViewClasses.do"
      	  //alert(href);
      	
      	}
      
		function set_array(length) { 
			//alert("In set_array.  Array Length =" + length);
  			win = new Array (length);
  			url = new Array(length);
  			//alert(length);
		}

		function set_url (num) {
		
		   var pos=num-1;
		  // alert("In set_url");
  			url[pos]=href+"?action=viewClasses&position="+pos
  			//alert("In set_url.  URL = "	+url[pos]);
  			currentPosition=pos;
  			//alert(currentPosition);
		}	 
		   
