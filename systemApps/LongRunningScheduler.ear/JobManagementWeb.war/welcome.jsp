<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="com.ibm.websphere.product.WASDirectory,java.util.Locale,org.apache.struts.util.MessageResources"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<% 
    String lang = response.getLocale().toString();
    String masterCSS = "Master.css";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
        masterCSS = lang + "/" + masterCSS;
%>
<html:html locale="true">
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/<%= masterCSS %>" rel="stylesheet"
	type="text/css">
<TITLE><bean:message key="jmc"/></TITLE>
</HEAD>

<%
    WASDirectory wd = new WASDirectory();
    String productId = null;
	String prod = null;
	String info = null;
	
    if (wd.isThisProductInstalled(WASDirectory.ID_EMBEDDED_EXPRESS))
	    productId = WASDirectory.ID_EMBEDDED_EXPRESS;
    else if (wd.isThisProductInstalled(WASDirectory.ID_EXPRESS))
	    productId = WASDirectory.ID_EXPRESS;
    else if (wd.isThisProductInstalled(WASDirectory.ID_ND)) {
        productId = WASDirectory.ID_ND;
	} else
	    productId = WASDirectory.ID_BASE;
	String sep = "---------------------------------------";
	
	String prodVer = new String(wd.getVersion(productId));
	if (prodVer.startsWith("6"))
		info = "pix";
	else
		info = "compass";

	String prodNameVer = new String(wd.getName(productId) + ", " + 	wd.getVersion(productId));
    Locale locale = (Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);

    String[] messageargs = {"5724-J34","2004, 2007"};
    String copyright = messages.getMessage(locale,"welcome.copyright",messageargs);

	String aboutText = prodNameVer + "\n" +
	                   messages.getMessage(locale, "about.build.num") + " " + wd.getBuildLevel(productId) + "\n" +
	                   messages.getMessage(locale, "about.build.date") + " " + wd.getBuildDate(productId) + "\n" + 
	                   sep + "\n";
	                   
	if (wd.isThisProductInstalled("WXDOP")) {
	    prod = wd.getName("WXDOP");
		prodNameVer = new String(wd.getName("WXDOP") + ", " + 	wd.getVersion("WXDOP"));
		aboutText += prodNameVer + "\n" +
		             messages.getMessage(locale, "about.build.num") + " " + wd.getBuildLevel("WXDOP") + "\n" +
	                   messages.getMessage(locale, "about.build.date") + " " + wd.getBuildDate("WXDOP") + "\n" +
	                sep + "\n";
	}

	if (wd.isThisProductInstalled("WXDCG")) {
	    prod = wd.getName("WXDCG");
		prodNameVer = new String(wd.getName("WXDCG") + ", " + 	wd.getVersion("WXDCG"));
		aboutText += prodNameVer + "\n" +
		             messages.getMessage(locale, "about.build.num") + " " + wd.getBuildLevel("WXDCG") + "\n" +
	                   messages.getMessage(locale, "about.build.date") + " " + wd.getBuildDate("WXDCG") + "\n" + 
	                sep + "\n";
	}

	if (wd.isThisProductInstalled("WXDDG")) {
	    prod = wd.getName("WXDDG");
		prodNameVer = new String(wd.getName("WXDDG") + ", " + 	wd.getVersion("WXDDG"));
		aboutText += prodNameVer + "\n" +
		             messages.getMessage(locale, "about.build.num") + " " + wd.getBuildLevel("WXDDG") + "\n" +
	                   messages.getMessage(locale, "about.build.date") + " " + wd.getBuildDate("WXDDG") + "\n" +
	                sep + "\n";
	}
			    
	aboutText += copyright;
%>

<BODY  class="content">
<div role="main">
<table border="0" cellpadding="20" cellspacing="0" width="94%" role="presentation">
  <tr>
    <td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%" >
	  <tr> 
    	<td class="nolines" align="top">
 		  <span class="purplebold"><bean:message key="welcome"/></span>
		</td>
  	  </tr>
    </table>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
	  <tr>                   
    	<td class="linesmost" align="top" >
        <span CLASS="desctext">
        <bean:message key="welcomeDesc"/>
        </span>
        </td>
      </tr>
    </table>
    </td>
	<td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%" role="presentation">
	  <tr> 
    	<td class="nolines" align="top">
    	<img src="images/infocenter.gif" align="left" alt="">
        <span class="purplebold">Extended Deployment Library</span>
		</td>
  	  </tr>
    </table>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
	  <tr>                   
    	<td class="linesmost" align="top">
   		<span class="desctext"><bean:message key="xdLib" arg0="<a href=\"http://www-306.ibm.com/software/webservers/appserv/extend/library/\" target=\"Library\">WebSphere Extended Deployment Library</a>"/></span>
     	</td>
	  </tr>
    </table>
	</td>
  </tr>
  <tr>
    <td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%"role="presentation" >
	  <tr> 
    	<td class="nolines" align="top">
    	<img src="images/ibm_com_link.gif" align="left" alt="">
        <a href="http://www.ibm.com/software/webservers/appserv/" target="_blank">
		<span class="bluebold"><bean:message key="wasOnIBM"/></span>
        </a>
		</td>
  	  </tr>
    </table>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
	  <tr>                   
    	<td class="linesmost" align="top">
		<span class="desctext"><bean:message key="wasOnIBMDesc"/></span>
     	</td>
	  </tr>
    </table>
	</td>
	<td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%" role="presentation">
	  <tr> 
    	<td class="nolines" align="top">
    	<img src="images/about.gif" align="left" alt="">
        <bean:message key="aboutYourXDCG"/>
		</td>
  	  </tr>
    </table>

     <table border="0" cellpadding="5" cellspacing="0" width="100%" >
	  <tr>                   
    	<td class="linesmost" align="top">
          <html lang="en">
          <head>
          <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
          <META HTTP-EQUIV="Expires" CONTENT="0">
          </head>
          <body>
            <STYLE>
            TEXTAREA { width:95%; border-style: none; scrollbar-face-color:#CCCCCC; scrollbar-shadow-color:#FFFFFF; scrollbar-highlight-color:#FFFFFF; scrollbar-3dlight-color:#6B7A92; scrollbar-darkshadow-color:#6B7A92; scrollbar-track-color:#E2E2E2; scrollbar-arrow-color:#6B7A92  }
            </STYLE>
            <form>
            <!--<label for="abouttextarea" title="<bean:message key="productName"/>">-->
            <textarea name="abouttextarea" rows='6' cols='40' CLASS="desctext" title="<bean:message key="productName"/>" id="abouttextarea" READONLY>
<%=aboutText%>
            </textarea>
            <!--</label>-->
            </form> 

          </body>
          </html>
     	</td>
	  </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%" role="presentation">
	  <tr> 
    	<td class="nolines" align="top">
    	<img src="images/dev_domain.gif" align="left" alt="">
        <a href="http://www7b.software.ibm.com/wsdd/" target="_blank">
		<span class="bluebold">developerWorks WebSphere</span>
        </a>
	    </td>
  	  </tr>
    </table>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
	  <tr>                   
    	<td class="linesmost" align="top">
   		<span class="desctext"><bean:message key="developmentWorks"/></span>
     	</td>
	  </tr>
    </table>
	</td>
    <td  width="50%" valign="top"> 
    <table  border="0" cellpadding="7" cellspacing="0" width="100%" role="presentation">
	  <tr> 
    	<td class="nolines" align="top">
    	<img src="images/infocenter.gif" align="left" alt="">
        <a href="http://www.ibm.com/software/webservers/appserv/library.html" target="_blank">
		<span class="bluebold"><bean:message key="documentation"/></span>
		</a>
		</td>
  	  </tr>
    </table>

    <table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
	  <tr>                   
    	<td class="linesmost" align="top">
   		<span class="desctext"><bean:message key="document" arg0="<%=info%>"/></span>
     	</td>
	  </tr>
    </table>
	</td>
  </tr>
</table>
</div>
</BODY>
</html:html>
