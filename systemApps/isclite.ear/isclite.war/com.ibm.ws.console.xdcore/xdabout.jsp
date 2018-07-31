<%-- 
THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-i63, 5724-H88,5655-N01(C) COPYRIGHT International Business Machines Corp., 1997, 2011
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp. 
--%>

<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.websphere.product.*,java.util.Locale,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.net.*,java.io.*,java.util.*,java.lang.*,java.lang.reflect.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<!-- WSC Console Federation-->
<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="com.ibm.ws.console.core.WSCDefines" %>


<% //WSC Console Federation
Boolean federation = (Boolean)request.getSession().getAttribute(WSCDefines.WSC_ISC_LAUNCHED_TASK);

if ( federation == null) {
    federation = new Boolean(false);
}

if ( federation.booleanValue() ) {
//WSC Console Federation - only if we are federated we need the locale info
        Locale locale = request.getLocale();
        String currentLocale = "en";
        String[] availableLocales = com.ibm.ws.console.core.Constants.LOCALES;
        if (locale.toString().startsWith("en") || locale.toString().equals("C")) {
            currentLocale = availableLocales [0];
        } else
        {
            for (int i = 1; i < availableLocales.length; i++)
            {
                if (locale.toString().equals(availableLocales[i]))
                {
                    currentLocale = availableLocales [i];
                    break;
                }
                else
                {
                    if (locale.toString().startsWith(availableLocales[i]))
                    {
                        currentLocale = availableLocales [i];
                        break;
                    }
                }
            }
        }

    String localeStr = currentLocale;
}
%>

<!-- WSC Console Federation -->
<ibmcommon:detectLocale/>

<html:html locale="true">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">
</head>
<body>


<%
	String aboutText = "";
	Locale locale = (Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
	Class product = Class.forName("com.ibm.isc.api.platform.ProductInfo");
    Class productInfo = Class.forName("com.ibm.isclite.platform.ProductInfoImpl");
	Method getVersion = productInfo.getMethod("getVersion", (Class[])null);
	Object productInfoObject = productInfo.newInstance();
	String[] messageargs = {"5724-i63, 5724-H88, 5655-N01, 5733-W61","1996, 2006"};
    String wasVersion = (String)getVersion.invoke(productInfoObject, new Object[0]);
	    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
	    String copyright = messages.getMessage(locale,"welcome.copyright",messageargs);
    
	   WASDirectory directory = new WASDirectory();
	   WASProductInfo prod = null;
	   if (directory.isThisProductInstalled("XD")) {
		   prod = directory.getWASProductInfo("XD");
	   } else if (directory.isThisProductInstalled("WXDOP")) {
		   prod = directory.getWASProductInfo("WXDOP");
	   } else if (directory.isThisProductInstalled("IXD")) {
		   prod = directory.getWASProductInfo("IXD");
	   }
	   if (prod != null) {
		  String prodNameVer = new String(prod.getName() + ", " + prod.getVersion());
		  aboutText += prodNameVer + "\n" +
		  messages.getMessage(locale, "about.build.num") + " " + prod.getBuildLevel() + "\n" +
		  messages.getMessage(locale, "about.build.date") + " " + prod.getBuildDate() + "\n" +
		  "---------------------------------------" + "\n";
	   }
    	
    aboutText += "\n" + copyright;
%>
<STYLE>
TEXTAREA { width:95%; border-style: none; scrollbar-face-color:#CCCCCC; scrollbar-shadow-color:#FFFFFF; scrollbar-highlight-color:#FFFFFF; scrollbar-3dlight-color:#6B7A92; scrollbar-darkshadow-color:#6B7A92; scrollbar-track-color:#E2E2E2; scrollbar-arrow-color:#6B7A92  }
</STYLE>
<form>
<textarea name="abouttext" rows='6' cols='40' CLASS="desctext" READONLY>
<%=aboutText%>
</textarea>
</form> 

<!-- WSC Console Federation -->
</body>
</html:html>
