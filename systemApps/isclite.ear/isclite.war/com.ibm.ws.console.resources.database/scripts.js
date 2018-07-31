/***********************************************************************
* Licensed Materials - Property of IBM
* "Restricted Materials of IBM"
*
* 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 
* (C) Copyright IBM Corp. 2008 All Rights Reserved.
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with
* IBM Corp.
***********************************************************************/

/////////////////////////////////////////////////////////////
// reload(requestString)
//   Used to reload a jsp
//
// Inputs:
//   The forward location to reload. Usually an action.
// Output:
//   All form fields are put into the request and the page is forwarded to requestString
/////////////////////////////////////////////////////////////
function reload(requestString, theForm){  


  // Get form properties and values by looping over all elements on the form
  var i = 0;
  var j = 0;
  var value;
  var numOfFormFields = theForm.elements.length;

  // properties is an array in which the even values are the properties and the
  // odd values are the values for the previous entry.  For ex, properties[0]=JNDI Name
  // and properties[1]=datasource/myJNDI
  var properties = new Array(numOfFormFields*2);

  while(i<numOfFormFields*2) {
    j=parseInt(i/2);
    properties[i]=theForm.elements[j].name;
    i++;

    if(theForm.elements[j].type=="checkbox") {
      value=theForm.elements[j].checked;
    } else if (theForm.elements[j].type=="radio") {
      if(theForm.elements[j].checked) {
         value=theForm.elements[j].value;
      }
    } else {
      value=theForm.elements[j].value;
    }
            
    properties[i]=value;
    i++;
  }
     
  // Add form properties and values to the request -->
  i=0;
  while(i<numOfFormFields*2) {
    // do not add any buttons, hidden objects or undefined values to the request. -->
    if(properties[i]!=undefined&&properties[i+1]!=undefined&&properties[i]!="apply"&&properties[i]!="save"&&
       properties[i]!="reset"&&properties[i]!="action"&&properties[i+1]!="Cancel"&&properties[i]!="installAction") {
         requestString=requestString+"&"+properties[i]+"="+encodeURIComponent(properties[i+1]);
    }
    i=i+2;
  }

  window.location = requestString;
}