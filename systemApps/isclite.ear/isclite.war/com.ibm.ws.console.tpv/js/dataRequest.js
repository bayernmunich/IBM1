// THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
// 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997, 2005
// All Rights Reserved * Licensed Materials - Property of IBMUS 
// Government Users Restricted Rights - Use, duplication or disclosure
// restricted by GSA ADP Schedule Contract with IBM Corp.

// Variable that holds our XML request object
var xmlHttpObj = null;

// Initializes the XML requrest object
function getXmlHttpObj() {
  if (xmlHttpObj != null) return xmlHttpObj;

  // See if browser supports ActiveXObjects (IE on Win)
  if (window.ActiveXObject) {
    try {
      xmlHttpObj = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch (e) {
      // Didn't work... try the old XMLHTTP ActiveXObject
      try {
        xmlHttpObj = new ActiveXObject("Microsoft.XMLHTTP");
      }
      catch (e) {
        // Didn't work either, browser must not support this
      }
    }
  }
  // Try to get the Mozilla XML HTTP request object
  else if (typeof XMLHttpRequest != 'undefined') {
    xmlHttpObj = new XMLHttpRequest();
  }
  
  return xmlHttpObj;
}

// Gets an XML document and then invokes the callback
// function with the xmlDoc as the single argument.
function getXmlDoc(requestURL, callBack) {
  // If xmlHttpObj is null try initializing it
  if (xmlHttpObj == null) getXmlHttpObj();
  
  // If it's still null then this browser doesn't support it
  if (xmlHttpObj == null) {
    callBack(null);
    return;
  }
  
  // Create the request
  xmlHttpObj.open("GET", requestURL, true);

  // Invoke the callback when the request is finished loading
  xmlHttpObj.onreadystatechange = function() {
    if (xmlHttpObj.readyState == 4) {
      callBack(xmlHttpObj.responseXML);
    }
  }
  
  // Send the request
  xmlHttpObj.send(null)
}