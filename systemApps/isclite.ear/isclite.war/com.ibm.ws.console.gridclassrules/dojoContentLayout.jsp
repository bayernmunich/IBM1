<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.error.*,com.ibm.ws.console.core.bean.*"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="com.ibm.ws.console.core.utils.StatusUtils" %>
<%!
  private boolean isDmgr = StatusUtils.isND();
%>
<tiles:useAttribute name="descTitle" classname="java.lang.String" />
<tiles:useAttribute name="descImage" classname="java.lang.String" />
<tiles:useAttribute name="descText" classname="java.lang.String" />
<tiles:useAttribute name="contentList" classname="java.util.List" />
<tiles:useAttribute name="bcHandler" classname="java.lang.String" ignore="true" />
<tiles:useAttribute name="helpTopic" classname="java.lang.String" ignore="true" />
<tiles:useAttribute name="bcRenderer" classname="java.lang.String" ignore="true" />


<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String" />
<% request.setAttribute("contextType",contextType);%>


<%  // defect 126608
  String image = ""; 
  String pluginId = "";
  String pluginRoot = "";

  if (descImage != "")
  {
     int index = descImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = descImage.substring (index + 9);
        if (index != 0)
           descImage = descImage.substring (0, index);
        else
           descImage = "";
     }
     else 
     {
        index = descImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = descImage.substring (index + 18);
           if (index != 0)
              descImage = descImage.substring (0, index);
           else
              descImage = "";
        }
     }
  }
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<% 
%>

<ibmcommon:detectLocale/>


<%
	WorkSpace workSpace = (WorkSpace)session.getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
    UserPreferenceBean userBean = (UserPreferenceBean)session.getAttribute(com.ibm.ws.console.core.Constants.USER_PREFS);

	if (workSpace != null) {
		if (workSpace.getModifiedList().size() > 0) {
            String uri = (String)request.getAttribute("javax.servlet.forward.request_uri");
			if (uri.indexOf("syncworkspace.do") == -1 && uri.indexOf("logoff.do") == -1) {
		        java.util.Locale locale = (java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
	    	    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
                    boolean noOverwrite = (request.getSession().getAttribute (Constants.NO_OVERWRITE_KEY) != null);
				if((!com.ibm.ws.security.core.SecurityContext.isSecurityEnabled() || 
					(request.isUserInRole("administrator") || request.isUserInRole ("adminsecuritymanager") || request.isUserInRole("configurator"))) && !noOverwrite){
					IBMErrorMessage errorMessage1 = IBMErrorMessages.createWarningMessage(locale, messages, "warning.config.changes.made", null);
	                //LIDB3795-28 Added direct "Save" link and "Preferences" link under messages
	                IBMErrorMessage errorMessage2 = null;
	                if(userBean.getProperty("System/workspace", "syncWithNodes", "false").equalsIgnoreCase("true"))
	                   errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.disabled", null);
	                else
	                    errorMessage2 = IBMErrorMessages.createMessage(locale, messages, "warning.preferences.nodesync.enabled", null);
					IBMErrorMessage errorMessage3 = null;
					if(com.ibm.ws.console.core.utils.ConsoleUtils.requiresServerRestart(workSpace.getModifiedList())){
						errorMessage3 = IBMErrorMessages.createWarningMessage(locale, messages, "info.restart.server", null);
					}
		        	Object obj = request.getAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY);
		        	if (obj == null || !(obj instanceof IBMErrorMessage[])) {
						obj = new IBMErrorMessage[0];
					}
		        	IBMErrorMessage[] errorArray = (IBMErrorMessage[])obj;
	        		List newErrorArray = new Vector();
		       		newErrorArray.add(errorMessage1);
                                if (this.isDmgr) {
          	        		newErrorArray.add(errorMessage2);
                                }
					if(errorMessage3!=null){
	                	newErrorArray.add(errorMessage3);
					}
					newErrorArray.addAll(Arrays.asList(errorArray));
			        request.setAttribute(com.ibm.ws.console.core.Constants.IBM_ERROR_MESG_KEY, (IBMErrorMessage[]) newErrorArray.toArray(new IBMErrorMessage[newErrorArray.size()]));
				}
		    }
		}
	}
%>

<html:html locale="true">
<HEAD>
  
 
<style type="text/css">
<!--
body, html { font-size: 1.0em; }
-->
body .dijitMenuItem {
	color:black;
	list-style-type:none		
}
</style>     

 
<script src="dojo/dojo/dojo.js" type="text/javascript" djConfig="parseOnLoad:true,isDebug:true"></script>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/> 

    <script type="text/javascript">

            // Load Dojo's code relating to the ComboBox widget

            dojo.require("dijit.form.ComboBox");
   
    </script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/dojo/dijit/themes/soria/soria.css"/>
<title>Classification Rules</title>    
</HEAD>

<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>

<body class="content" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

  		

<jsp:include page="/secure/layouts/content_accessibility.jsp" flush="true"/>


                        
    <tiles:insert page="/secure/layouts/descLayout.jsp">
        <tiles:put name="descTitle" value="<%=descTitle%>"/>
        <tiles:put name="descImage" value="<%=descImage%>"/>
        <tiles:put name="descText" value="<%=descText%>"/>
        <tiles:put name="bcHandler" value="<%=bcHandler%>"/>
        <tiles:put name="bcRenderer" value="<%=bcRenderer%>"/>
        <tiles:put name="helpTopic" value="<%=helpTopic%>"/>
    </tiles:insert>

<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" SUMMARY="List layout table">

	<TBODY>
		<TR>
			<TD CLASS="layout-manager" id="notabs">

    <tiles:insert page="/secure/layouts/vboxLayout.jsp" flush="true">
        <tiles:put name="list" beanName="contentList" beanScope="page"/>
    </tiles:insert>
    
                        </TD>
               </TR>
        </TBODY>
</TABLE>

           
<%-- finishes off table started in the breadcrumb layouts --%>
            
  </td>
 </tr>
  </TBODY>
 </table>
 </TD>
 
        <%@ include file="helpPortlet.jspf" %>

</TR>
</TABLE>




  
  
 


</body>
</html:html>

