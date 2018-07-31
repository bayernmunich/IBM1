<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2007 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*, com.ibm.ws.console.core.item.*"%>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="stepsList" classname="java.util.List" />
<tiles:useAttribute name="stepArraySessionKey" classname="java.lang.String" />
<tiles:useAttribute name="reqdTaskSessionKey" classname="java.lang.String" />

<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String" />
<% request.setAttribute("contextType",contextType);%>
<%

java.util.ArrayList stepsList_ext =  new java.util.ArrayList();
for(int i=0;i<stepsList.size(); i++)
     stepsList_ext.add(stepsList.get(i));

AppInstallItem summary = (AppInstallItem)stepsList_ext.remove(stepsList_ext.size()-1);

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.ws.console.core.wizardStep";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions= registry.getExtensions(extensionId,ic);

%>

<%  if(extensions !=null ){
        for (int i = 0; i < extensions.length; i++) {
                    IConfigurationElement[] elements = extensions[i].getConfigurationElements();
                    for (int j=0; j < elements.length; j++) {
                        if(elements[j].getAttributeValue("jspName")!=null && elements[j].getAttributeValue("name")!=null){
                        AppInstallItem sm = new AppInstallItem();
                                    sm.setLink(elements[j].getAttributeValue("jspName"));
                                    sm.setValue(elements[j].getAttributeValue("name"));
                                    stepsList_ext.add(sm);
                        }

                       }
                    }
         }
    stepsList_ext.add(summary);

    pageContext.setAttribute("stepsList_ext",stepsList_ext);

 %>



<%
// stepArray keeps the ordering of the valid steps as ordered by the "stepsList" iterator in the definition
// this is needed to jump to desired steps.
// if not in session, create it.
ArrayList stepArray;
// begin LIDB3726, zoght, wizard  substep code
ArrayList subStepArray = (ArrayList) session.getAttribute(stepArraySessionKey+"SUBSTEP_ARRAY");
// The IsSubStep Attribute associated with the current step's link
String subStepAttribute = "";
Boolean TRUE = new Boolean(true);
Boolean FALSE = new Boolean(false);
// end LIDB3726
%>
<%
if ((stepArray = (ArrayList) session.getAttribute(stepArraySessionKey)) == null) {
    stepArray = new ArrayList();
    stepArray.add(0, null);
	// zoght
	if (subStepArray == null) {
		subStepArray = new ArrayList();
	    subStepArray.add(0, null);
	}
    Iterator j = stepsList_ext.iterator();
    while( j.hasNext() ) {
        AppInstallItem step= (AppInstallItem)j.next();
        String strTok = step.getLink();
        int index = strTok.lastIndexOf("/");
        strTok = strTok.substring(index+1);

        //Force Configure Member step add
        if (session.getAttribute(strTok + "Form") != null || (strTok + "Form").equals("CreateHealthClassConfigureMembersForm")) {
            stepArray.add(step.getValue());
			// zoght
			subStepAttribute = (String) session.getAttribute(strTok + "IsSubStep");
			if (subStepAttribute != null && subStepAttribute.equals("true")) {
				subStepArray.add(TRUE);
			} else {
				subStepArray.add(FALSE);
			}
		}
    }
    session.setAttribute(stepArraySessionKey, stepArray);
	// zoght
	session.setAttribute(stepArraySessionKey+"SUBSTEP_ARRAY", subStepArray);
}
int totalSteps = stepArray.size() - 1;

%>
<tiles:useAttribute name="titleKey" classname="java.lang.String" />
<tiles:useAttribute name="descKey" classname="java.lang.String" />
<tiles:useAttribute name="actionHandler" classname="java.lang.String" />
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="disableStepsLink" classname="java.lang.String" />
<tiles:useAttribute name="helpTopic" classname="java.lang.String"  ignore="true"/>
<tiles:useAttribute name="pluginId" classname="java.lang.String" ignore="true" />

<ibmcommon:detectLocale/>
<ibmcommon:setPluginInformation pluginIdentifier="com.ibm.ws.console.healthconfig" pluginContextRoot=""/>
<%
   String fieldLevelHelpTopic = null;
   String DETAILFORM = "DetailForm";
   String COLLECTIONFORM = "CollectionForm";
   String APPINSTALLFORM = "AppInstallForm";
   String FORM = "Form";
   String objectType = "";
   String helpPluginId = "";

   if (helpTopic !=null && helpTopic.length()>0 && pluginId !=null && pluginId.length()>0)
   {
	   fieldLevelHelpTopic = helpTopic;
	   helpPluginId = pluginId;
   }
   else {
   if (formType != null && formType.length() > 0)
   {
		int index = formType.lastIndexOf ('.');
		if (index > 0)
		{
			String fType = formType.substring (index+1);
			if (fType.endsWith (DETAILFORM))
			{
				objectType = fType.substring (0, fType.length()-DETAILFORM.length());
				fieldLevelHelpTopic = objectType + ".detail";
			}
			else if (fType.endsWith (COLLECTIONFORM))
			{
				objectType = fType.substring (0, fType.length()-COLLECTIONFORM.length());
				fieldLevelHelpTopic = objectType + ".collection";
			}
			else if (fType.equals (APPINSTALLFORM)) {
				objectType = actionForm.substring(0, actionForm.length()-FORM.length());
				fieldLevelHelpTopic = "appmanagement." + objectType;
				request.setAttribute("fieldHelp",fieldLevelHelpTopic);
				helpPluginId = "com.ibm.ws.console.appmanagement";
			}
			else if (fType.endsWith(FORM))
			{
				objectType = fType.substring (0, fType.length() - FORM.length());
				fieldLevelHelpTopic = objectType;
			}
			else
			{
				fieldLevelHelpTopic = fType;
			}
		}
      else
      {
         fieldLevelHelpTopic = formType;
      }
   }
	else
		//fieldLevelHelpTopic = null;
        fieldLevelHelpTopic = "";
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<HEAD>

<title><bean:message key="<%=titleKey%>"/></title>

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true">
  <jsp:param name="noFixDBCSTableText" value="true" />
</jsp:include>

<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

</HEAD>


<BODY CLASS="content"  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" role="main">
<%
  // .do of the action handler in definition was omitted for easier comparison.
  // Appending the .do now.
  String actionPath = actionHandler + ".do";
%>

<%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String pageTitle = messages.getMessage(request.getLocale(),titleKey);
        if (session.getAttribute("bcnames") != null)  {
                String[] bcnamesT = (String[])session.getAttribute("bcnames");
                pageTitle = bcnamesT[0];
                String[] bclinksT = (String[])session.getAttribute("bclinks");
				int oldlen = 0;
				for (int counter1=0; counter1<bclinksT.length; counter1++) {
                  if (bclinksT[counter1].equals("")) {
                          oldlen = counter1;
                          break;
                  }
				}
                String priorpage = request.getHeader("Referer");
                if (priorpage == null)
                    priorpage = "";
                if (oldlen == 0) {
					 oldlen = 1;
				}

				if (priorpage.indexOf("forwardName=") > 0) {
				   if ((bclinksT[oldlen-1].indexOf("forwardName=") < 0) &&
					   (bclinksT[oldlen-1].indexOf("EditAction=true") < 0)) {
                        bclinksT[oldlen-1] = priorpage;
						session.setAttribute("bclinks", bclinksT);
				   }
                }

        }
%>
<html:form action="<%=actionPath%>" name="<%=actionForm%>" styleId="<%=actionForm%>" type="<%=formType%>">


    <TABLE WIDTH="97%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage" role="banner">
    <TR>
        <TD CLASS="pageTitle"><%=pageTitle%>
        </TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"><bean:message key="portal.close.page"/></A>
        </TD>
    </TR>
    </TABLE>


  <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" role="presentation">
  <TR><TD valign="top">

  <TABLE WIDTH="97%" CELLPADDING="2" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="presentation">
  <TR>
    <td class="wpsPortletTitle" width="100%"><bean:message key="<%=titleKey%>"/></td>
	<% if (!fieldLevelHelpTopic.equals("") && !helpPluginId.equals("")) {%>
    <td class="wpsPortletTitleControls">
        <% request.setAttribute("fieldHelp",fieldLevelHelpTopic);  %>
		<ibmcommon:setPluginInformation pluginIdentifier="<%=helpPluginId%>" pluginContextRoot=""/>
		<ibmcommon:info image="help.additional.information.image" topic="<%=fieldLevelHelpTopic%>"/>
    </td>
	<%}%>	
    <td class="wpsPortletTitleControls">
    <A href="javascript:showHidePortlet('wasUniPortlet')">
    <img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt"/>" border="0" align="texttop" />
    </A>
    </td>
  </TR>


  <TBODY ID="wasUniPortlet">
  <TR>
  <TD CLASS="wpsPortletArea" COLSPAN="3" >



    <a name="important"></a>
    <ibmcommon:errors/>


<p class="instruction-text">
<bean:message key="<%=descKey%>"/>
</p>


<%-- Iterate over names.
  We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
 --%>
<%
HashMap reqdTaskMap = (HashMap) session.getAttribute(reqdTaskSessionKey);

int stepNumber = 1;
// begin zoght
int totalCount = 1;

int subStepNumber = 1;
// end zoght
Iterator i = stepsList_ext.iterator();
int currStep = 1;
String jspPath = "";

String stepTitle = "";
%>

<TABLE width="100%" cellpadding="0" cellspacing="0" class="wizard-table" ID="outterMostTable" role="presentation">
  <TR>
    <TD WIDTH="25%" VALIGN="top">
        <TABLE width="150" height="100%" cellpadding="8" cellspacing="0" role="presentation">

<%
while( i.hasNext() ) {
    // Iterate thro' the item list in the main definition
    AppInstallItem step= (AppInstallItem)i.next();

    if (!stepArray.contains(step.getValue()))
        continue;

    // Strip out the path from the item[i].getLink(), get the jsp filename at the end of the path
    String strTok = step.getLink();
    int index = strTok.lastIndexOf("/");
    strTok = strTok.substring(index+1);

    // now compare the jsp filename with the actionHandler coming from definition.
    // If equal, insert jsp into this step - current step
    if (actionHandler.equalsIgnoreCase(strTok)) {

        // .jsp of the jsp filename in item[i].link was omitted for easier comparison.
        // Appending the .jsp now.
        jspPath = step.getLink() + ".jsp";
 %>

            <html:hidden property="currentStep" value="<%=step.getValue()%>" />
            <input TYPE="hidden" id="currentStepText" name="currentStepText" value='<bean:message key="<%=step.getValue()%>"/>' />
            <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="<%=request.getContextPath()%>/images/wwizard_step_current.gif" width="15" height="15" align="left" alt='<bean:message key="current.step"/>'>
            </TD>
<% if (totalCount<subStepArray.size()&&((Boolean)subStepArray.get(totalCount)).equals(TRUE) ) { /*zoght*/
%>
            <TD CLASS="wizard-tabs-on" VALIGN="top" >
              &nbsp;&nbsp;<bean:message key="step.string"/>&nbsp;<%=Integer.toString(stepNumber)%>.<%=subStepNumber++%><bean:message key="healthclass.showmestepslayout.token"/>&nbsp;<bean:message key="<%=step.getValue()%>"/>
            </TD>
<% } else {  /*zoght*/ %>
            <TD CLASS="wizard-tabs-on" VALIGN="top" >
              <bean:message key="step.string"/>&nbsp;<%=Integer.toString(stepNumber)%><bean:message key="healthclass.showmestepslayout.token"/>&nbsp;<bean:message key="<%=step.getValue()%>"/>
            </TD>
            </TR>
<% } %>


<%
        // currStep = stepNumber;
		currStep = totalCount;
        stepTitle = step.getValue();
	} // end if (actionHandler.equalsIgnoreCase(strTok)) {
	else {
            boolean disable = (new Boolean(disableStepsLink)).booleanValue();
	 // comparison of the jsp name with that of actionHandler failed.
	 // display step button, step title and step description.
            String taskImage = request.getContextPath()+"/images/onepix.gif";
            String taskImageAlt = "";
            if (reqdTaskMap != null) {
               if (!((Boolean)reqdTaskMap.get(strTok)).booleanValue()) {
                  taskImage = request.getContextPath()+"/images/attend.gif";
                  taskImageAlt = messages.getMessage(request.getLocale(),"information.required");
               }
            }

%>
            <TR>
            <TD CLASS="wizard-tabs-image" VALIGN="top" WIDTH="1%">
              <img src="<%=taskImage%>" width="15" height="15" align="left" alt="<%=taskImageAlt%>">
            </TD>
            <TD CLASS="wizard-tabs-off" VALIGN="top">

              <a name="<%=Integer.toString(stepNumber)%>"></a>
            <% if (disable) {  %>

               <% if (totalCount<subStepArray.size()&&((Boolean)subStepArray.get(totalCount)).equals(TRUE)) { /*zoght*/
	                %>
                   &nbsp;&nbsp;<bean:message key="step.string"/> <%=Integer.toString(stepNumber)%>.<%=subStepNumber++%><bean:message key="healthclass.showmestepslayout.token"/>
               <% } else {  /*zoght*/ %>
                       <bean:message key="step.string"/> <%=Integer.toString(stepNumber)%><bean:message key="healthclass.showmestepslayout.token"/>
               <% } %>

           <% } else { %>

               <% if (totalCount<subStepArray.size()&&((Boolean)subStepArray.get(totalCount)).equals(TRUE)) { /*zoght*/
                     %>
                       <html:submit property="stepSubmit" styleId="steps" styleClass="buttons">
                         &nbsp;&nbsp;<bean:message key="step.string"/> <%=Integer.toString(stepNumber)%>.<%=subStepNumber++%>
                       </html:submit>
               <% } else {  /*zoght*/ %>
                      <html:submit property="stepSubmit" styleId="steps" styleClass="buttons">
                         <bean:message key="step.string"/> <%=Integer.toString(stepNumber)%>
                       </html:submit>
              <% } %>
          <% } %>
            	   <bean:message key="<%=step.getValue()%>"/>
            </TD>
            </TR>

<%
        } // end of else
        // begin zoght
        if (totalCount + 1 < subStepArray.size()) {
            Boolean nextStep = (Boolean) subStepArray.get(totalCount + 1);
			// zoght , if next step is a substep, do not increment stepNumber.
            if (nextStep != null &&  nextStep.equals(TRUE)) {
				// zoght, if we jumped into the first substep, initialaize
				// the sunbStep Alphabet index to 1
				if (totalCount<subStepArray.size()&&((Boolean)subStepArray.get(totalCount)).equals(FALSE)) {
			    	subStepNumber = 1;
				}
		   } else {
		      stepNumber++;
		   }
		} else {
           stepNumber++;
        }

		totalCount++;
		// end zoght
		// old code
		// stepNumber++;

} // end while loop


%>
            </TABLE>
         <TD VALIGN="top" CLASS="not-highlighted">

         <SCRIPT>
         function changeHeight() {
             thisvisibleWin = document.body.clientHeight;
             thistotalWin = document.body.scrollHeight + thisvisibleWin;
             thisoffset = document.all["thestep"].offsetTop;
             //document.all["thestep"].style.pixelHeight = thisvisibleWin - thisoffset - 50;
             //if (thistotalWin > thisvisibleWin) {
             //    document.all["thestep"].style.overflow = "scroll";
             //}
             //alert("thistotal is "+thistotalWin+" and thisvisibleWin is "+thisvisibleWin);
         }

         </SCRIPT>

         <DIV style="position:relative; margin-left:0px;margin-right:0px" id="thestep">
            <TABLE width="100%" height="100%" cellpadding="6" cellspacing="0" role="presentation">
            <TR>
            <TD CLASS="wizard-step-title">
                    <!-- This includes the step title in the top of the inserted step content -->
                    <!--<H2>-->
                    <bean:message key="<%=stepTitle%>"/>
                    <!--</H2>-->
            </TD>
            </TR>
              <tr>
                <td class="wizard-step-expanded" valign="top">

                  <tiles:insert page="<%=jspPath%>" flush="true" >
                     <tiles:put name="actionForm" beanName="actionForm" beanScope="page"/>
                  </tiles:insert>
                </td>
              </tr>
            </TABLE>
            </DIV>
          </TD>
        </TR>


          <TR>
          <TD COLSPAN="3">

            <TABLE width="100%" cellpadding="6" cellspacing="0">
              <tr>
                <td class="wizard-button-section"  ALIGN="center">
                  <% if (currStep > 1) { %>
                      <html:submit property="installAction" styleClass="buttons_navigation">
                        <bean:message key="button.previous"/>
                      </html:submit>
                  <% } %>
                  <% if (currStep < (stepArray.size() -1)) { %>
                  	  <html:submit property="installAction" styleClass="buttons_navigation">
                      	<bean:message key="button.next"/>
                      </html:submit>
                  <% } else { %>
                  	  <html:submit property="installAction" styleClass="buttons_navigation">
                      	<bean:message key="button.finish"/>
                      </html:submit>
                  <% } %>
                  
                  <html:cancel property="installAction" styleClass="buttons_navigation">
                    <bean:message key="button.cancel"/>
                  </html:cancel>
                </td>
              </tr>
            </TABLE>
        </TD>
        </TR>

</TABLE>


        </TD>
    </TR>
   </TBODY>
</TABLE>


</TD>




        <%@ include file="/com.ibm.ws.console.healthconfig/helpPortlet.jspf" %>






</TR>
</TABLE>


</html:form>
<SCRIPT>
//changeHeight();
</SCRIPT>
</body>
</html:html>
