<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.core.form.AbstractDetailForm,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.console.core.breadcrumbs.Breadcrumb" %>
<%@ page import="com.ibm.ws.console.core.utils.RegExpHelper,java.net.*"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<% try { %>

<tiles:useAttribute name="objectTypeImage" classname="java.lang.String" />
<tiles:useAttribute name="collectionLink" classname="java.lang.String" />
<tiles:useAttribute name="includeLink" classname="java.lang.String" />
<tiles:useAttribute name="titleKey" classname="java.lang.String" />
<tiles:useAttribute name="instanceDetails" classname="java.lang.String"/>
<tiles:useAttribute name="instanceDescription" classname="java.lang.String"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="displayName" classname="java.lang.String" />
<bean:define id="perspective" name="<%= formName %>" property="perspective"/>



<bean:define id="newapply" name="<%= formName %>" property="action"/>
<% String theaction = "" + newapply + ""; %>

<bean:define id="cntxt" name="<%= formName %>"/>
<%
String thecontext = "";
String theref = "";
String saveref = "";
String theresource = "";
String saveres = "";
String savePerspective = "";
String thePerspective = "";

try
{
        AbstractDetailForm bean = (AbstractDetailForm) cntxt;
        thecontext = bean.getContextId();
        saveref = bean.getRefId();
        theref = (String)session.getAttribute("theref");
        saveres = bean.getResourceUri();
        theresource = (String)session.getAttribute("theresource");
        savePerspective = bean.getPerspective();
        thePerspective = (String)session.getAttribute("thePerspective");

} catch (Exception e) { }

if (thecontext != null) {
   session.setAttribute("thecontext",thecontext);
} else {
   thecontext = (String)session.getAttribute("thecontext");
}
if (saveref != null) {
   session.setAttribute("theref",saveref);
} else {
   theref = (String)session.getAttribute("theref");
}
if (saveres != null) {
   session.setAttribute("theresource",saveres);
} else {
   theresource = (String)session.getAttribute("theresource");
}
if (savePerspective != null) {
   session.setAttribute("thePerspective",savePerspective);
} else {
   thePerspective = (String)session.getAttribute("thePerspective");
}
%>

<%

// defect 126608

  String image = "";
  String pluginId = "";
  String pluginRoot = "";

  boolean addTag = false;
  if (objectTypeImage != "")
  {
     int index = objectTypeImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = objectTypeImage.substring (index + 9);
        addTag = true;
        if (index != 0)
           objectTypeImage = objectTypeImage.substring (0, index);
        else
           objectTypeImage = "";
     }
     else
     {
        index = objectTypeImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = objectTypeImage.substring (index + 18);
           addTag = true;
           if (index != 0)
              objectTypeImage = objectTypeImage.substring (0, index);
           else
              objectTypeImage = "";
        }
     }
  }
  if (addTag)
  {


%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:getBreadcrumbs name="bc"/>
<%
	//Bug 3606: setting last breadcrumb to the current tab.
	if (bc != null) {
   		Breadcrumb crumb = (Breadcrumb) bc.get(bc.size() - 1);
		if (crumb != null)
			crumb.setURL(request.getContextPath()+"/com.ibm.ws.console.visdataservice.forwardCmd.do?forwardName=visdataservice.config.view");
	}
%>


<%
  }
%>

<%
   String fieldLevelHelpTopic = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formName.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formName.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
      fieldLevelHelpTopic = objectType+".detail";
   }
   else if (formName.endsWith (DETAILFORM)) {
           objectType = formName.substring(0, formName.length()-DETAILFORM.length());
           fieldLevelHelpTopic = objectType + ".detail";
   }
   else
       fieldLevelHelpTopic = formName;

	ServletContext servletContext = (ServletContext)pageContext.getServletContext();
	MessageResources messages = (MessageResources)servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
	String newbutton = messages.getMessage(request.getLocale(),"button.new");
	String addbutton = messages.getMessage(request.getLocale(),"button.add");
        String theName = messages.getMessage(request.getLocale(),"visdataservice.desc.title");

        %>


        <% String patternString; %>

        <bean:define id="description" name="<%= formName %>" property="<%=instanceDetails%>"/>

        <% patternString="" + description + ""; %>

        <% if (patternString.equals("")) { %>

        <%
               patternString = theName;
        }

       String portletTitle = patternString;
%>

                           
  <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" class="portalPage" role="banner">
    <TR>
        <TD CLASS="pageTitle"><%=portletTitle%>
        </TD>
        <TD CLASS="pageClose"><A HREF="<%=request.getContextPath()%>/secure/content.jsp"><bean:message key="portal.close.page"/></A>
        </TD>        
    </TR>
  </TABLE>


    
  <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" role="presentation">
  <TR>
  
  
  
  <TD valign="top">
  
  <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" CLASS="wasPortlet" role="main">
  <TR>
    <td class="wpsPortletTitle"><b><%=portletTitle%></b></td>
    <td class="wpsPortletTitleControls">
		<%
		  request.setAttribute("fieldHelp",fieldLevelHelpTopic);
		%>
		<ibmcommon:info image="help.additional.information.image" topic="<%=fieldLevelHelpTopic%>"/>
		<a href="javascript:showHidePortlet('wasUniPortlet')">
			<img id="wasUniPortletImg" SRC="<%=request.getContextPath()%>/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt"/>" border="0" align="texttop" />
		</a>
    </td>
  </TR>
  
  <TBODY ID="wasUniPortlet">
  <TR>   
  <TD CLASS="wpsPortletArea" COLSPAN="2" >
    
         <a name="important"></a> 
        <ibmcommon:errors/>
      
	<H1 id="title-bread-crumb">
	<bean:message key="visdataservice.desc.title"/>
 	</H1>

   <p class="instruction-text">
      <bean:message key='<%=instanceDescription%>'/>
   </p>




<%

        if (session.getAttribute("traceOptionValuesMap") != null) {
                session.removeAttribute("traceOptionValuesMap");
                session.removeAttribute("traceGroupsMap");
        }

%>



<a name="main"></a>

<% } catch (Exception e){e.printStackTrace(); } %>