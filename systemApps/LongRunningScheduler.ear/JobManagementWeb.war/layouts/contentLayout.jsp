<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="java.util.ArrayList,com.ibm.ws.batch.jobmanagement.web.forms.AbstractDetailForm,com.ibm.ws.batch.jobmanagement.web.util.JMCUtils,com.ibm.ws.batch.jobmanagement.web.util.JMCErrorMessage"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<%@ include file="/tiles/tilesDefs.jsp" %>

<tiles:useAttribute name="formName"     classname="java.lang.String"/>
<tiles:useAttribute name="refProp"      classname="java.lang.String"/>
<tiles:useAttribute name="title"        classname="java.lang.String"/>
<tiles:useAttribute name="portletTitle" classname="java.lang.String"/>
<tiles:useAttribute name="description"  classname="java.lang.String"/>
<tiles:useAttribute name="script"       classname="java.lang.String"/>
<tiles:useAttribute name="helpLink"     classname="java.lang.String"/>
<tiles:useAttribute name="content"      classname="java.lang.String"/>

<%@ include file="/tiles/collectionScript.jspf" %>

<% if (script != null && script.length() > 0) { %>
<tiles:insert component="<%=script%>" beanScope="request" />
<% } 

   String lang = response.getLocale().toString();
   String masterCSS = "Master.css";
   if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
       masterCSS = lang + "/" + masterCSS;
%>

<html:html locale="true">
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/<%= masterCSS %>" rel="stylesheet" type="text/css">
</HEAD>
<TITLE><bean:message key="<%= title %>"/></TITLE>

<BODY>
<div role="main">
  <br>
  <TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="0" BORDER="0" CLASS="wasPortlet">
    <TR>
      <TH class="wpsPortletTitle"><bean:message key="<%= portletTitle %>"/></TH>
      <TH class="wpsPortletTitleControls" nowrap>            
      <a href="<%=helpLink%>" tabindex="100" target='WAS_help'><img src="images/title_help.gif" width="10" height="12" border="0" title="<bean:message key="viewInfo"/>" alt="<bean:message key="viewInfo"/>" align="texttop"></a>
      <A href="javascript:showHidePortlet('jmc_portlet')">
      <img id="img_jmc_portlet" SRC="images/title_minimize.gif" title="<bean:message key="minimize"/>" alt="<bean:message key="minimize"/>" border="0" align="texttop" tabindex="1"/>
      </A>    
      </TH>
    </TR>
    <TR  id="jmc_portlet">
      <TD colspan=2>
      <TABLE BORDER="0" CELLPADDING="10" CELLSPACING="10" WIDTH="100%" role="presentation">
        <%@ include file="/tiles/errorMessages.jspf" %>
        <tr>
          <td>
          <p class="instruction-text">
<% if (formName != null && formName.length() > 0 && refProp != null && refProp.length() > 0) { %>
          <bean:define id="detailForm" name="<%=formName%>" type="com.ibm.ws.batch.jobmanagement.web.forms.AbstractDetailForm"/>
          <bean:define id="refId" name="<%=formName%>" property="<%=refProp%>" type="java.lang.String"/>
<%        if (detailForm.isPropertyNeedConvertToCharset(refProp))
              refId = JMCUtils.convertToCharset(refId, response.getCharacterEncoding());
%>
          <bean:message key="<%= description %>" arg0="<%=refId%>"/>
<% } else { %>
          <bean:message key="<%= description %>"/>
<% } %>
          </p>
          </td>
        </tr>
        <tiles:insert beanName="<%= content %>"/>
      </TABLE>
      </TD>
    </TR>
  </TABLE>
</div>
</BODY>
</html:html>
