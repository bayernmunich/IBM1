<%-- 
THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-i63, 5724-H88,5655-N01(C) COPYRIGHT International Business Machines Corp., 1997, 2004
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp. 
--%>

<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.websphere.product.*,java.util.Locale,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
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
    WASDirectory directory = new WASDirectory();
    WASProductInfo prod = null;
    if (directory.isThisProductInstalled(WASProduct.PRODUCTID_EMBEDDED_EXPRESS))
	    prod = directory.getWASProductInfo(WASProduct.PRODUCTID_EMBEDDED_EXPRESS);
    else if (directory.isThisProductInstalled(WASProduct.PRODUCTID_EXPRESS))
	    prod = directory.getWASProductInfo(WASProduct.PRODUCTID_EXPRESS);
    else if (directory.isThisProductInstalled(WASProduct.PRODUCTID_ND)) {
        prod = directory.getWASProductInfo(WASProduct.PRODUCTID_ND);
	} else
	    prod = directory.getWASProductInfo(WASProduct.PRODUCTID_BASE);
	String sep = "---------------------------------------";
// Begin LIDB2775 zOS changes

 /**   String copyright = "Licensed Material - Property of IBM\n" +                              
        "5724-i63, 5724-H88 (C) Copyright IBM Corp. 1996, 2004\n" + "\n" +                 
        "All Rights Reserved.\n" + "\n" +                                       
        "U.S. Government users - RESTRICTED RIGHTS - Use, Duplication, or\n" +  
        "Disclosure restricted by GSA-ADP schedule contract with IBM Corp.\n" +
        "IBM is a registered trademark of the IBM Corp.\n" + "\n" +                                                                   
        "Status = H28W600";  */
// End LIDB2775 zOS changes
	String prodNameVer = new String(prod.getName() + ", " + 	prod.getVersion());
    Locale locale = (Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
    MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);

    String[] messageargs = {"5724-i63, 5724-H88, 5655-N01, 5733-W61","1996, 2006"};
    String copyright = messages.getMessage(locale,"welcome.copyright",messageargs);

	String aboutText = prodNameVer + "\n" +
	                   messages.getMessage(locale, "about.build.num") + " " + prod.getBuildLevel() + "\n" +
	                   messages.getMessage(locale, "about.build.date") + " " + prod.getBuildDate() + "\n" + 
	                   sep + "\n"; 
	if (directory.isThisProductInstalled(WASProduct.PRODUCTID_XD)) {
	    prod = directory.getWASProductInfo(WASProduct.PRODUCTID_XD);
		prodNameVer = new String(prod.getName() + ", " + 	prod.getVersion());
		aboutText += prodNameVer + "\n" +
		             messages.getMessage(locale, "about.build.num") + " " + prod.getBuildLevel() + "\n" +
	                 messages.getMessage(locale, "about.build.date") + " " + prod.getBuildDate() + "\n" + 
	                sep + "\n";
	}
			    
	if (directory.isThisProductInstalled(WASProduct.PRODUCTID_PME)) {
	    prod = directory.getWASProductInfo(WASProduct.PRODUCTID_PME);
		prodNameVer = new String(prod.getName() + ", " + 	prod.getVersion());
		aboutText += prodNameVer + "\n" +
		             messages.getMessage(locale, "about.build.num") + " " + prod.getBuildLevel() + "\n" +
	                 messages.getMessage(locale, "about.build.date") + " " + prod.getBuildDate() + "\n" + 
	                 sep + "\n";
	}
	aboutText += copyright;
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
