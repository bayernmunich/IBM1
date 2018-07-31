<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute  name="property" classname="java.lang.String"/>
<tiles:useAttribute  name="bean" classname="java.lang.String"/>

<tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<script type="text/javascript" language="JavaScript">
   var initCurrentOnLoadDone = false;
</script>

<%
    String showNoneText = "none.text";

    boolean val = false;
    if (readOnly != null && readOnly.equals("true"))
        val = true;
    else if (SecurityContext.isSecurityEnabled()) {
        if ((request.isUserInRole("administrator")) || (request.isUserInRole("configurator"))) {
            val = false;
        }
        else {
            val = true;
        }
    }
%>

          	<td class="table-text" nowrap>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                  <tbody>
                    <tr valign="top">
                    </tr>
          </td>
     </tr>

     <tr>
       <td>
         <tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
	       <tiles:put name="actionForm" value="<%=formBean%>" />
	       <tiles:put name="label" value="dynamiccluster.membershipPolicy.textarea" />
	       <tiles:put name="desc" value="dynamiccluster.membershipPolicy.description" />
	       <tiles:put name="hideValidate" value="true" />
       	   <tiles:put name="hideRuleAction" value="true" />
       	   <tiles:put name="rule" value="membershipPolicy" />
       	   <tiles:put name="rowindex" value="" />
       	   <tiles:put name="refId" value="" />
       	   <tiles:put name="ruleActionContext" value="service" />
       	   <tiles:put name="template" value="service" />
       	   <tiles:put name="actionItem0" value="notUsed" />
       	   <tiles:put name="actionListItem0" value="notUsed" />
       	   <tiles:put name="actionItem1" value="notUsed" />
       	   <tiles:put name="actionListItem1" value="notUsed" />
       	   <tiles:put name="quickHelpTopic" value="dc_membership.html" />
       	   <tiles:put name="quickPluginId" value="com.ibm.ws.console.dynamiccluster" />
       	 </tiles:insert>
       </td>
      </tr>
                               <tr valign="top">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                                     <tbody>
                                        <tr valign="top">
                                           <td class="table-text" nowrap TITLE="<bean:message key="dynamiccluster.membershipPolicy.preview.description"/>">
                                              &nbsp; [ <a for="membershipPolicyPreviewButton" id="membershipPolicyPreviewButton" href="javascript:showHideMembershipPolicy();"> <bean:message key="dynamiccluster.button.preview"/></a> ]
                                           </td>
                                        </tr>
                                        <tr valign="top">
                                           <td class="table-text" nowrap>
                                              <DIV id="com_ibm_ws_dynamiccluster_membershipPolicyPreviewTable"
                                                    style="display:none; position:absolute; top:335; left:220; width:300; border-top:1px solid #E2E2E2; border-left:1px solid #E2E2E2; border-right:3px outset #CCCCCC; border-bottom:3px outset #CCCCCC; z-index:101; background-color:#eeeeee">
                                                 <iframe id="com_ibm_ws_dynamiccluster_membershipPolicyPreviewIFrame"
                                                 	title="<bean:message key="dynamiccluster.button.preview"/>"
                                                 	name="com_ibm_ws_dynamiccluster_membershipPolicyPreviewIFrame"
                                                 	width="300" height="200"
                                                 	src="<%=request.getContextPath()%>/com.ibm.ws.console.dynamiccluster/DynamicClusterMembershipPreview.jsp"></iframe>
                                                 <table class="messagePortlet" border="0" cellpadding="5" cellspacing="0" valign="top" width="100%">
                                                    <tr>
                                                      <td valign="baseline" class="table-text">
                                                         &nbsp; [ <a for="membershipPolicyPreviewCloseButton" id="membershipPolicyPreviewCloseButton" href="javascript:showHideMembershipPolicy();"> <bean:message key="dynamiccluster.button.close"/></a> ] &nbsp;
                                                      </td>
                                                    </tr>
                                                 </table>
                                              </DIV>
                                           </td>
                                        </tr>
                                     </tbody>
                                  </table>
                               </tr>

<script type="text/javascript" language="JavaScript">

var oldMembershipPolicy = "";

function doXmlHttpRequest(sUri) {
    isMoz = false;
    mozLoaded = false;
    xmlhttp = null;
    xmlDoc = null;
    if (window.ActiveXObject) {
        xmlhttp = new ActiveXObject('MSXML2.XMLHTTP');
    } else {
        xmlhttp = new XMLHttpRequest();
    }

    if (xmlhttp) {
        xmlhttp.open('GET',sUri,false);
        //PI12xxx
        form = document.getElementsByName("csrfid")[0];
        if (form != null) {
        	value = form.value;
        	xmlhttp.setRequestHeader("csrfid", value);
        }
        xmlhttp.setRequestHeader('Content-Type', 'charset=UTF-8');
        xmlhttp.send(null);
        xmlDoc = xmlhttp.responseText;
        mozLoaded = true;
    }

    return xmlDoc;

}

function findYPosition(elementId)
{
   var YPos = 0;
   if (elementId.y) {
      YPos = elementId.y;
   } else if (elementId.offsetParent) {
      while (elementId.offsetParent) {
         YPos = YPos + elementId.offsetTop
         elementId = elementId.offsetParent;
      }
   }
   return YPos;
}
function findXPosition(elementId)
{
   var XPos = 0;
   if (elementId.x) {
      XPos = elementId.x;
   } else if (elementId.offsetParent) {
      while (elementId.offsetParent) {
         XPos = XPos + elementId.offsetLeft
         elementId = elementId.offsetParent;
      }
   }
   return XPos;
}

function showHideMembershipPolicy() {

    var sectionId = "com_ibm_ws_dynamiccluster_membershipPolicyPreviewTable";
    var iframeId = "com_ibm_ws_dynamiccluster_membershipPolicyPreviewIFrame";
    var previewButtonId = "membershipPolicyPreviewButton";
    var closeButtonId = "membershipPolicyPreviewCloseButton";
    var ruleBuilderId = "ruleBuilder";

    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {

            // handle the ruleBuilder popup window, if it is opened then close it first.
            if (document.getElementById(ruleBuilderId) != null) {
                if (document.getElementById(ruleBuilderId).style.display == "block") {
                   // hide the ruleBuilder window
                   document.getElementById(ruleBuilderId).style.display = "none";
                }
            }

            // line up the 'Preview' and 'Close' button
            var previewPosY = findYPosition(document.getElementById(previewButtonId));
            var previewPosX = findXPosition(document.getElementById(previewButtonId));

            // if > 100 probably means we are in the create wizard
            if (previewPosX > 100)
              document.getElementById(sectionId).style.left = 100;

            // set the top to 0 so we can calc the height of the preview box
            document.getElementById(sectionId).style.top = 0;

            var membershipPolicy = "";
            if (document.getElementById('membershipPolicy') != null) {
               membershipPolicy = document.getElementById('membershipPolicy').value;
               //Need to filter out carriage returns.
               membershipPolicy = membershipPolicy.replace(/\r|\n|\r\n/g, "");
            }

            if (oldMembershipPolicy != membershipPolicy) {
               oldMembershipPolicy = membershipPolicy;

               // membership policy has changed. Clear the iframe page first so that users
               // don't see the old data while the page refresh

               // set the attribute for the membershipPolicy value to blank
               var blankPolicy = "";
               var sessionVariable = "com_ibm_ws_dynamiccluster_membershipPolicy";
               uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable="+sessionVariable+"&variableValue="+encodeURIComponent(blankPolicy);
               setState = doXmlHttpRequest(uriState);

               // reload the iframe, so that it has a blank page
               window.frames[iframeId].location.reload(1); // perfect for both browsers; make sure the name is defined in iframe


               // set the attribute for the membershipPolicy value
               sessionVariable = "com_ibm_ws_dynamiccluster_membershipPolicy";
               uriState = "<%=request.getContextPath()%>/secure/javascriptToSession.jsp?req=set&sessionVariable="+sessionVariable+"&variableValue="+encodeURIComponent(membershipPolicy);
               setState = doXmlHttpRequest(uriState);

               // reload the iframe
               // document.frames(iframeId).location.reload(); // this only works in IE and not Firefox
               // document.getElementById(iframeId).src = document.getElementById(iframeId).src; // this one works on both browsers but caused busy status bar and see old data before the refresh

               window.frames[iframeId].location.reload(1); // perfect for both browsers; make sure the name is defined in iframe
            }

            // set the iframe to visible
            document.getElementById(sectionId).style.display = "block";

            var closePosY = findYPosition(document.getElementById(closeButtonId));

            // re-position the top so that the 'Preview' and 'Close' button line up
            document.getElementById(sectionId).style.top = previewPosY-closePosY;

        } else {
            // set the iframe to hidden
            document.getElementById(sectionId).style.display = "none";

            // handle the ruleBuilder popup window, if it is opened then close and re-open it.
            if (document.getElementById(ruleBuilderId) != null) {
                if (document.getElementById(ruleBuilderId).style.display == "block") {
                   // hide the ruleBuilder window
                   document.getElementById(ruleBuilderId).style.display = "none";
                   // show the ruleBuilder window
                   document.getElementById(ruleBuilderId).style.display = "block";
                }
            }
        }
    }
}
</script>
