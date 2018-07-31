<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*,java.util.regex.*,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>

<!--F034370-34760 Console Bidi support bidi.jsp is in webui.core  -->
<jsp:include page = "/secure/layouts/bidi.jsp" flush="true"/>

<% 
    //Insert the override CSS
    if (session.getAttribute("isFederated") != null) {
        %><LINK href="<%=session.getAttribute("federationCSSRef")%>" rel="stylesheet" type="text/css"/><%
    }
%>
<!--F034370-34760 Console Bidi support bidi.jsp is in webui.core  -->
<jsp:include page = "/secure/layouts/bidi.jsp" flush="true"/>

<!--F46988-48239 Console wai-aria support wai_aria.js is in webui.core  -->
<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/wai_aria.js"></script>
<script>
dojo.addOnLoad( ariaOnLoadTop );
</script>

<!-- WSC Console Federation -->
<%@ page import="com.ibm.ws.console.core.WSCDefines" %>

<% //WSC Console Federation
    Boolean federated = (Boolean)request.getSession().getAttribute(WSCDefines.WSC_ISC_LAUNCHED_TASK);
    if ( federated == null) {
    	federated = new Boolean(false);
    }
    Boolean isPortletCompatible = (Boolean)request.getSession().getAttribute(WSCDefines.PORTLET_COMPATIBLE);
    if(isPortletCompatible == null){
        isPortletCompatible = new Boolean(false);
    }

%>

<%
   
String[] langarray = { "de","en","es","fr","it","ja","ko","pt","zh-cn", "zh-tw" }; 

boolean isDBCS = false;
  
double multiplierWildCard = 1.0;
double multiplier = 0.7;
double spacer = 1.0;
String browserPlatform = "";
double browserPlatformM = 1.0;
String browserJava = "";
double browserJavaM = 1.0;
String browserLocale = "";
double browserLocaleM = 1.0;
String theagent = request.getHeader("USER-AGENT");
if(theagent!=null)
theagent = theagent.toLowerCase();
String thelocale = "";
if (request.getHeader("ACCEPT-LANGUAGE")==null) {
        thelocale = "en";
} else {
        thelocale = request.getHeader("ACCEPT-LANGUAGE").toLowerCase();
}

//session.setAttribute("multiplier", new Double(multiplier));


// New jdk 1.4 Regular Expressions
Pattern pattern = Pattern.compile(",");	
String[] theirlangs = pattern.split(thelocale); // split

//Matcher mat = pattern.matcher(input);
//String jdkMatchResult = mat.find();	// match
//String mat.replaceAll("-"); // substitute all occurrences

//RE splitter = new RE(",");
//String[] theirlangs = splitter.split(thelocale);

int theirlen = theirlangs.length;
int ourlangs = langarray.length;
String currlang = "";

for (int y=0; y<theirlen;y++) {

        currlang = theirlangs[y];
        
        int weight = currlang.indexOf(";q=");
        if (weight > -1) {
                currlang = currlang.substring(0,weight).trim();
        }

        int country = currlang.indexOf("-");
        if ((country > -1) && (currlang.indexOf("zh") < 0)) {
                currlang = currlang.substring(0,country).trim();
        }                

        for (int z=0; z<ourlangs;z++) {
                String tempourlang = langarray[z];
                if (currlang.equals(tempourlang)) {
                        browserLocale = tempourlang;
                        break;
                                                        
                        
                }
        }
        if (!browserLocale.equals("")) {
                break;
        }

               
}

%>


<%

if (null != theagent && -1 != theagent.indexOf("windows")) {
        browserPlatform = "NT";
        browserPlatformM = 1.0;

}
else if (null != theagent && -1 != theagent.indexOf("aix")) {
        browserPlatform = "AIX";        
        browserPlatformM = 1.2;
}
else if (null != theagent && -1 != theagent.indexOf("sunos")) {
        browserPlatform = "SOLARIS";        
        browserPlatformM = 1.3;
}
else if (null != theagent && -1 != theagent.indexOf("linux")) {
        browserPlatform = "LINUX";        
        browserPlatformM = 1.2;
}
else if (null != theagent && -1 != theagent.indexOf("hp_ux")) {
        browserPlatform = "HP_UX";        
        browserPlatformM = 1.2;
}
else {
        browserPlatform = "NT";        
        browserPlatformM = 1.0;
}
%>

<%

if (null != theagent && -1 != theagent.indexOf("msie")) {
        browserJava = "IE";        
        browserJavaM = 1.0;
}
else if (null != theagent && -1 != theagent.indexOf("gecko")) {
        browserJava = "GECKO";        
        browserJavaM = 1.0;
}
else if (null != theagent && -1 != theagent.indexOf("opera")) {
        browserJava = "OPERA";        
        browserJavaM = 1.0;
}
else {
        browserJava = "NETSCAPE";        
        browserJavaM = 1.0;
}


%>




<%

if (browserLocale.equals("zh-cn")) {
        browserLocale = "zh";        
        browserLocaleM = 1.2;
        isDBCS = true;
}
else if (browserLocale.equals("zh-tw")) {
        browserLocale = "zh_TW";        
        browserLocaleM = 1.2;
        isDBCS = true;
}
else if (browserLocale.equals("fr")) {
        browserLocale = "fr";        
        browserLocaleM = 1.0;
}
else if (browserLocale.equals("de")) {
        browserLocale = "de";
        browserLocaleM = 1.0;
}
else if (browserLocale.equals("en")) {
        browserLocale = "en";
        browserLocaleM = 1.0;
}
else if (browserLocale.equals("it")) {
        browserLocale = "it";
        browserLocaleM = 1.0;
}
else if (browserLocale.equals("ja")) {
        browserLocale = "ja";
        browserLocaleM = 1.1;
        isDBCS = true;
}
else if (browserLocale.equals("ko")) {
        browserLocale = "ko";
        browserLocaleM = 1.1;
        isDBCS = true;
}
else if (browserLocale.equals("pt")) {
        browserLocale = "pt";
        browserLocaleM = 1.0;
}
else if (browserLocale.equals("es")) {
        browserLocale = "es";
        browserLocaleM = 1.0;
}
else {
        browserLocale = "en";
        browserLocaleM = 1.0;
}


%>


<%
        multiplier = browserLocaleM * browserJavaM * browserPlatformM;
        session.setAttribute("multiplier", new Double(multiplier));
        if (isDBCS) {
           spacer = 0.5;
		}
%>


<style type="text/css">

<%
        out.println("/* The browser agent is "+browserJava+" */");
        out.println("/* The agent locale is "+browserLocale+" */");
        out.println("/* The agent OS is "+browserPlatform+" */");
        
        out.println("/* The font size multiplier is "+multiplier+" */");
        

%>

/************  LOGIN PAGE ***************/
/*  Check to see if these are still used  */
.login-button-section {  padding-left: 0px; font-family: Verdana,Helvetica, sans-serif;  font-weight:normal; color: #000000; background-color:#CCCCCC; background-image: none;  } 
.login-background { 
    background-repeat: no-repeat; 
    background-position: right top;
    background-color: transparent; 
}

  
  
/* BANNER PAGE */

.top-navigation { color: #000000; font-size:<%=(70*multiplier)%>%; background-color:#ADB0EC; font-family: Verdana,Helvetica, sans-serif; padding-left: 10px; padding-right: 5px;}  
.top-nav-item  { color: #000000; font-family: Verdana,Helvetica,sans-serif; font-weight:bold; text-decoration: none  } 
a.top-nav-item  { color: #000000; font-family: Verdana,Helvetica,sans-serif; font-weight:bold;  } 
a:active.top-nav-item  { color: #000000; font-family: sans-serif; }  
a:hover.top-nav-item {  text-decoration: underline}
<% if (browserJava.equals("GECKO")) {  %>
.header {  margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px ; font-family: Verdana, Helvetica, sans-serif; border-bottom: 0px solid black; }
.bannerImages {
        border-top: #000000 1px solid;  border-bottom: 1px solid #000000;
}
<% } else { %>
.header {  margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px ; font-family: Verdana, Helvetica, sans-serif;  }
.bannerImages {
        border-top: #CCCCCC 1px solid;  border-bottom: 1px solid #CCCCCC;
}
<% } %>



/************* ACCESSIBILITY *************/
/*  Need to determine final form of these */
.accessibility-jumps-bottom { font-size:50%; color: #FFFFFF; margin-top: 20px; margin-bottom: 0px; }
.accessibility-jumps-top { font-size:50%; color: #FFFFFF; margin-top: -20px; margin-bottom: 0px; }
.accessibility-jumps-bottom a  { color: #FFFFFF;}
.accessibility-jumps-top a  { color: #FFFFFF;}


/*************** WIZARDS *****************/
/*  Need to determine if these are still used */
th.wizard-step  { border-top: 1px solid #FFFFFF; border-left: 1px solid #88a4d7; border-bottom: 1px solid #88a4d7; border-right: 1px solid #88a4d7; color: #006699; font-size:<%=(72*multiplier)%>%; background-color:#d1d9ec; font-family: Verdana,Helvetica, sans-serif;   padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px; text-align: left }
.wizard-step  {  background-color:#FFFFFF; font-family: Verdana,Helvetica, sans-serif;  font-size: <%=(65*multiplier)%>%; text-align: left;  color: #000000;}
.wizard-step-text { background-color:#FFFFFF; font-family: Verdana,Helvetica, sans-serif;  font-size: <%=(65*multiplier)%>%; text-align: left;  color: #000000;  }
.wizard-button-section {  font-family: Verdana,Helvetica, sans-serif;  text-align: left; font-weight:normal; color: #000000; background-color:#B5C5DD; border-top: 1px solid #FFFFFF; border-left: 1px solid #FFFFFF; } 
.wizard-step-expanded { 
        color: #000000;  background-color:#FFFFFF; font-family: Verdana,Helvetica, sans-serif; font-weight:normal; 
        /*border-bottom: 1px solid #88a4d7; */
        border-right: 1px solid white; padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px; text-align: left 
}        
.wizard-table {  background-color:#708eb7; border: 1px solid #708eb7; }
.wizard-step-title {
    background-color:#b5c5dd;
    font-size:<%=(70*multiplier)%>%;
    font-weight: bold;    
}

/*************** TABS *****************/


.tabs-on { 
    color: #000000; 
    font-size:<%=(65*multiplier)%>%; 
    background-color:#FFFFFF; 
    font-family: Verdana, sans-serif; 
    font-weight:normal; 
    border-bottom: 0px solid #FFFFFF; 
    border-right: 1px solid #88a4d7;
    border-top: 1px solid #88a4d7; 
    border-left: 1px solid #88a4d7; 
    padding-left: 8px; 
    padding-right: 8px; 
    padding-top: 5px; 
    padding-bottom: 5px; 
    text-align: left 
}
.tabs-off { 
    border-top: 1px solid #88a4d7;   
    border-bottom: 1px solid #88a4d7; 
    border-right: 1px solid #88a4d7; 
    border-left: 1px solid #88a4d7; 
    color: #006699; 
    font-size:<%=(65*multiplier)%>%; 
    background-color:#d1d9ec; 
    font-family: Verdana, sans-serif;   
    padding-left: 8px; 
    padding-right: 8px; 
    padding-top: 5px; 
    padding-bottom: 5px; 
    text-align: left 
} 

.blank-tab { 
    background-color:#FFFFFF;  
    border-bottom: 1px solid #88a4d7;  
}

.wizard-tabs-on { 
    border-right: 1px solid #88a4d7; 
    color: #FBEC97; 
    font-size:<%=(65*multiplier)%>%; 
    background-color:#708eb7 
    font-family: Verdana,Helvetica, sans-serif; 
    font-weight:bold;
    padding-left: 0px; 
    padding-top: 6px; 
    text-align: left 
}
.wizard-tabs-off { 
    border-right: 1px solid #88a4d7; 
    color: #FFFFFF; 
    font-size:<%=(65*multiplier)%>%; 
    background-color:#708eb7; 
    font-family: Verdana,Helvetica, sans-serif;   
    padding-left: 0px; 
    padding-top: 5px; 
    text-align: left    
}
.wizard-tabs-image { 
    background-color:#708eb7; 
    padding-left: 0px; 
    padding-top: 5px; 
    text-align: right    
} 

.tabs-item { color: #006699; 
    font-family: Verdana, sans-serif;
    text-decoration: none;   
}
a:active.tabs-item  { color: #000000 }
.tabsColumn { background-color:#b5c5dd; border-left: 1px solid #88a4d7; border-right: 0px solid #88a4d7; border-top: 1px solid #88a4d7; border-bottom: 1px solid #88a4d7; }

.navtabs-on { color: #000000; font-size:<%=(65*multiplier)%>%; background-color:#FFFFFF; font-family: Verdana, sans-serif;  border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; border-right: 1px solid #CCCCCC;  padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px; text-align: center }
.navtabs-off { color: #000000; font-size:<%=(65*multiplier)%>%; background-color:#E2E2E2; font-family: Verdana, sans-serif;  border-left: 1px solid #C0C0C0; border-top: 1px solid #C0C0C0; border-right: 1px solid #C0C0C0; border-bottom: 1px solid #CCCCCC; padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px; text-align: center    } 
.navtabs-item { color: #000000;  background-color:#E2E2E2; font-family: Verdana, sans-serif; text-decoration:none }
.navblank-tab { background-color:#FFFFFF;  border-bottom: 1px solid #CCCCCC;  }

.nav-perspectives {
    color: #000000; 
    font-size:<%=(65*multiplier)%>%; 
    background-color:#FFFFFF; 
    font-family: Verdana, sans-serif;  
    padding-left: 0px; padding-right: 5px; 
    padding-top: 5px; padding-bottom: 5px; 
    text-align: left; 
}


/*************** FORMS and CONTENT *************/


<% if (browserJava.equals("GECKO")) {  %>
LI {  
   padding-top: 4px; padding-bottom: 4px;font-family: Verdana, sans-serif;  
    <% if (isDBCS) {%>
    line-break: strict; word-break: break-all;
    <% } %>
}
UL { 
   font-size:<%=(65*multiplier)%>%; padding-left: 1em; margin-left: <%=(1.0*spacer)%>em; margin-bottom: 2px; margin-top:0em;  list-style-position: outside; list-style-type: square; color: #BCBCBC
}
.nav-bullet {
   font-size:<%=(130*multiplier)%>%; padding-top: 5px; padding-bottom: 1px; margin-left:<%=(0.75*spacer)%>em;
   min-width:100px;
}

.navigation-bullet {
   font-size:<%=(130*multiplier)%>%; padding-top: 1px; padding-bottom: 1px; margin-left: <%=(0.25*spacer)%>em;
}

LABEL {
    margin-left: <%=(0.5*spacer)%>em; padding-bottom: 0.5em; overflow: visible; margin-right: 0em;
    
    <% if (isDBCS) {%>
    line-break: strict; word-break: break-all;
    <% } %>
}
.requiredField {
    margin-left: <%=(-0.75*spacer)%>em;
}
.chkbox {  
    margin-left: 0em; 
}    
 
FIELDSET { 
    border: 1px solid #E7E7E7; 
    padding-bottom: 1em;
    margin-top: .5em;
    margin-left: <%=(0.25*spacer)%>em;
    /*background-color: #F7F7F7;*/
}

FIELDSET TABLE { 
    margin-left: 0em;
}



LEGEND  {   
    color: #336699;  
    font-weight: bold; 
<% if (isDBCS) { multiplierWildCard = 1.1; }  %>
    font-size:<%=(84*multiplier*multiplierWildCard)%>%;
    /*border-bottom: 1px solid #C0C0C0;*/
    /*background-color: #F7F7F7;    */
    white-space: nowrap;    
}

.readOnlyElement {  
    /*overflow:auto;*/
    margin-left: <%=(0.5*spacer)%>em;color: #666666; border:1px #666666 solid;background-color:#FFFFFF;margin-top:4px;padding: 2px;/*height:1.5em;*/
}
.readOnlyAreaElement { height:5em;overflow:auto;margin-left: <%=(0.5*spacer)%>em;color: #666666; border:1px #666666 solid;background-color:#FFFFFF;margin-top:4px;padding: 1px; }

PRE {
    font-size: 135%;
}
         

<% } else {%>
LI { 
    margin-left: <%=(0.75*spacer)%>em;padding-top: 1px; padding-bottom: 1px;font-family: Verdana, sans-serif; 
    <% if (isDBCS) {%>
    line-break: strict; word-break: break-all;
    <% } %>
}
UL { 
    margin-left: <%=(0.75*spacer)%>em;margin-bottom: 0px; margin-top: 0px; font-size:<%=(65*multiplier)%>%; list-style-position: outside; list-style-type: square; color: #BCBCBC
}
.nav-bullet {
    font-size:<%=(130*multiplier)%>%; 
    margin-left: <%=(1.0*spacer)%>em;    
}

.navigation-bullet {
    font-size:<%=(130*multiplier)%>%; 
    margin-left: <%=(0.75*spacer)%>em;
}

LABEL {
    margin-left: <%=(0.5*spacer)%>em; margin-bottom: .5em; overflow: visible; margin-right: 0em;
    
    <% if (isDBCS) {%>
    line-break: strict; word-break: break-all;
    <% } %>
}
.requiredField {
    margin-left: <%=(-0.75*spacer)%>em;
} 

.chkbox {  
    margin-left: 0em; 
} 

 
FIELDSET { 
    border: 1px solid #E7E7E7; 
    padding-bottom: 1em;
    margin-top: 0em;
    margin-left: 0em;
    /*background-color: #F7F7F7;*/
}

FIELDSET TABLE { 
    margin-left: 0em;
}



LEGEND  {   color: #336699;  
            font-weight: bold; 
            
<% if (isDBCS) { multiplierWildCard = 1.1; }  %>
            font-size:<%=(85*multiplier*multiplierWildCard)%>%;
            /*border-bottom: 1px solid #C0C0C0;*/
            margin-top: .25em;
            /*background-color: #F7F7F7;*/
            white-space: nowrap;    
            
}
.readOnlyElement { 
    /*overflow:scroll;*/
    margin-left: <%=(0.5*spacer)%>em;
    color: #666666; 
    border:1px #666666 solid;
    background-color:#FFFFFF;
    margin-top:0em;
    padding: 1px;     
}
.readOnlyAreaElement { height:5em;overflow:auto;margin-left: 2.25em;color: #666666; border:1px #666666 solid;background-color:#FFFFFF;margin-top:0em;padding: 2px; }

PRE {
    font-size: 105%;
}
    
  
<% } %>


FIELDSET .categorizedField { 
    margin-left: 0em;
    padding-left: 0em;
}
.black-bullet {
    color: #000000;
}

.addprop-heading {
    color:#336699; 
    margin-left: -.5em; margin-right: 0em;
    font-weight: bold;
    font-size:<%=(100*multiplier)%>%;  
    margin-top: .75em;
}


.addprop-bullet {
    margin-left: 1.25em; margin-right: 0em;
}



.collectionLabel {
    margin-left: 0em;
    margin-right: -1em;
}

OL {
    color: #000000;
}

.fieldset-noborder { border: 0px }

HR {
    color:#88a4d7; margin-left: -.35em; margin-right: 0em;
}

    
SELECT {  font-family: Verdana,sans-serif; font-size:<%=(95*multiplier)%>%; 
          border:1px #000000 solid; 
          margin-top: 0em;
          padding: 2px; 
          margin-left: <%=(0.4*spacer)%>em;
}
TEXTAREA {  font-size:<%=(95*multiplier)%>%; 
            font-family: Verdana,sans-serif; 
            border:1px solid; 
            margin-top: 0em;
            padding: 2px;
            margin-left: <%=(0.4*spacer)%>em;
            /*width: 80%;*/
            border-color:#336699 #8CB1D1 #8CB1D1 #336699;
}
FORM { 
    margin-bottom:0px; margin-top: 0px; padding-top: 0px; padding-bottom: 0px;
}


.textEntryReadOnly {
    color:#666666;
    font-family: Verdana,sans-serif; 
    background-color:#FFFFFF;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%; 
    margin-top: 0em;    
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#CCCCCC #CCCCCC #CCCCCC #CCCCCC;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    
    
}
.textEntryRequired {
    BACKGROUND-COLOR: #fff7de;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%; 
    margin-top: 0em;    
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;

}
.textEntryRequiredLong {
    BORDER-RIGHT: #cccccc 1px solid; 
    BORDER-TOP: #a5a684 1px solid; 
    BORDER-LEFT: #a5a684 2px solid; 
    BORDER-BOTTOM: #cccccc 1px solid; 
    BACKGROUND-COLOR: #fff7de;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%; 
}
  
.textEntryReadOnlyRequired {
    color:#666666;
    font-family: Verdana,sans-serif; 
    background-color:#ECECEC;
	BORDER-RIGHT: #cccccc 1px solid; 
    BORDER-TOP: #a5a684 1px solid; 
    BORDER-LEFT: #a5a684 2px solid; 
    BORDER-BOTTOM: #cccccc 1px solid;
    padding: 2px;
    /*width: 12em; */
    margin-top: 0em;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%;
}
.textEntry {
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    background-color:#FFFFFF;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%;
}

.fileUpload {
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    background-color:#FFFFFF;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%;
    /*width: 30em;*/
}

.noIndentTextEntry {
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    background-color:#FFFFFF;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    margin-left: 0.15em;
    font-size:<%=(95*multiplier)%>%;
    /*width: 12em; */
}
.noIndentTextEntryLong {
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    background-color:#FFFFFF;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    margin-left: 0.15em;
    font-size:<%=(95*multiplier)%>%;
    width: 24em;
}


.textEntryLong {
    font-family: Verdana,sans-serif; 
    margin-top: 0em;
    border-bottom-width:1px;
    background-color:#FFFFFF;
    border-style:solid;
    padding-right:1px;
    border-right-width:1px;
    border-left-width:1px;
    padding-top:1px;
    border-color:#336699 #8CB1D1 #8CB1D1 #336699;
    padding-bottom:1px;
    border-top-width:1px;
    padding-left:1px;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%;
    width: 23em;
}

.textEntryReadOnlyLong {
    color:#666666;
    font-family: Verdana,sans-serif; 
    background-color:#FFFFFF;
    border: 1px #CCCCCC solid;
    margin-top: 0em;
    border-bottom-width:1px;
    padding-right:1px;
    padding-top:1px;
    padding-bottom:1px;
    padding-left:1px;
    margin-left: <%=(0.5*spacer)%>em;
    font-size:<%=(95*multiplier)%>%;
    width: 23em;
}

.noIndentLabel {
    margin-left: 0.25em; padding-bottom: 1em;  
} 

.perspectiveImg {
    margin-bottom: 0em;
    margin-left: 0.25em;
}
.nav-perspectives {
    width: 100%;
    border-bottom: 1px solid #CCCCCC;
    margin-bottom: 0.5em;
    margin-left: 0em;
    margin-top: 0em;
}
           
/******* BUTTONS ********/
<% if (isDBCS) { multiplierWildCard = 0.85; }  %>
.buttons  {  font-family: Verdana,Helvetica, sans-serif; 
    font-size:<%=(70*multiplier*multiplierWildCard)%>%; 
    margin: 1px 2px 1px 2px; border-top: 1px outset #B1B1B1; 
    border-right: 1px outset #000000; border-bottom: 1px outset #000000; 
    border-left: 1px outset #B1B1B1; 
    <% if (isDBCS) { %> padding-top: 2px; <% } %>
}

.buttons-filter  {  
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(95*multiplier)%>%; margin: 1px 2px 1px 2px; border-top: 1px outset #B1B1B1; border-right: 1px outset #000000; border-bottom: 1px outset #000000; border-left: 1px outset #B1B1B1; 
}
.buttons#functions  {   font-size:<%=(95*multiplier)%>%;
    font-weight:normal; font-family: Verdana, sans-serif; 
    BORDER-RIGHT: #336699 1px solid; BORDER-TOP: #8cb1d1 1px solid; 
    BORDER-LEFT: #8cb1d1 1px solid; BORDER-BOTTOM: #336699 1px solid; 
    BACKGROUND-COLOR: #EAF1FF   
}
 

.function-button-section { 
    font-size:<%=(70*multiplier)%>%; 
    padding-left: 8px; font-family: 
    Verdana,Helvetica, sans-serif;  
    text-align: left;  
    color: #000000;  
    font-weight: normal; 
    background-color: #d1d9e8;  
    border-left: 1px solid #FFFFFF; 
    border-top: 1px solid #FFFFFF; 
    padding-top: 0.25em; 
}

                                     
.table-button-section { 
    font-size:<%=(65*multiplier)%>%; 
    padding-left: 8px; font-family: 
    Verdana,Helvetica, sans-serif;  
    text-align: left;  
    color: #000000;  
    font-weight: normal; 
    background-color: #d1d9e8; 
    border-left: 1px solid #FFFFFF; 
    border-top: 1px solid #FFFFFF; 
    padding-top: 0.25em; 
} 


.paging-button-section { 
    font-size:<%=(65*multiplier)%>%; 
    padding-left: 8px; 
    font-family: Verdana,Helvetica, sans-serif;  
    text-align: left;  
    color: #000000; 
    background-color: #d1d9e8; 
    font-weight: normal; 
    border-top: 1px solid #FFFFFF;
} 

.file-button-section { 
    font-size:<%=(95*multiplier)%>%; 
    padding-left: 8px; font-family: 
    Verdana,Helvetica, sans-serif;  
    text-align: left;  
    color: #000000;  
    font-weight: normal; 
    background-color: #d1d9e8; 
    border-left: 1px solid #FFFFFF; 
    border-top: 1px solid #FFFFFF; 
    padding-top: 0.25em; 
} 

.paging-table { 
    background-color: #d1d9e8; 
    border-left: 1px solid #88a4d7; 
    border-right: 1px solid #88a4d7; 
    border-bottom: 1px solid #88a4d7;   
}
.table-totals {
    font-size:<%=(65*multiplier)%>%; border-top: 1px solid #ffffff; padding-left: 1em; font-family: Verdana,Helvetica, sans-serif;  text-align: left;  color: #000000; background-color: #d1d9e8; font-weight: normal;   
}

.wizard-button-section .buttons#navigation   {  font-family: Verdana, sans-serif; font-size: <%=(70*multiplier)%>%;  border-top: 1px outset #B1B1B1; border-right: 1px outset #000000; border-bottom: 1px outset #000000; border-left: 1px outset #B1B1B1;  margin-top:2px;}

.navigation-button-section   {  
    background-color:#FFFFFF; 
    margin-top:1em;
    font-size:<%=(90*multiplier)%>%;
    text-align: left;
    padding-left: 0.25em;
}

.buttons#preview {
    margin-top: 0em;
    margin-bottom: 1em;
    BORDER-RIGHT: #336699 1px solid; 
    BORDER-TOP: #8cb1d1 1px solid;
    BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; 
    BACKGROUND-COLOR: #EAF1FF;
    font-size:<%=(65*multiplier)%>%;
}

.buttons#section-button {
    margin-top: 0em;
    margin-bottom: 1em;
    BORDER-RIGHT: #336699 1px solid; 
    BORDER-TOP: #8cb1d1 1px solid;
    BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; 
    BACKGROUND-COLOR: #EAF1FF;
    font-size:<%=(70*multiplier)%>%; 
}
.buttons#navigation {
    margin-top: 1em;
    BORDER-RIGHT: #336699 1px solid; 
    BORDER-TOP: #8cb1d1 1px solid;
    BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; 
    BACKGROUND-COLOR: #EAF1FF;
    font-size:<%=(70*multiplier)%>%; 
}
.buttons#other {  
    font-family: Verdana,Helvetica, sans-serif; 
    font-size:<%=(95*multiplier)%>%; 
    BORDER-RIGHT: #336699 1px solid; BORDER-TOP: #8cb1d1 1px solid; BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; BACKGROUND-COLOR: #EAF1FF 
}
.special {
    font-family: Verdana,Helvetica, sans-serif; 
    font-size:<%=(95*multiplier)%>%; 
    BORDER-RIGHT: #336699 1px solid; BORDER-TOP: #8cb1d1 1px solid; BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; BACKGROUND-COLOR: #EAF1FF 
}
.buttons#steps {  
    font-family: Verdana, sans-serif; 
    font-size:<%=(95*multiplier)%>%;  
    margin: 0px;
    padding: 0px; 
    border: 0px solid black; 
    text-decoration:underline; 
    color:#FFFFFF; 
    background-color: #708eb7 
}
.buttons#paging-next {  
    background-image: url(images/wtable_next.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;
    text-align: right;
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(0*multiplier)%>%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}
.buttons#paging-prev {  
    background-image: url(images/wtable_previous.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;
    text-align: right;
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(0*multiplier)%>%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}

.buttons#paging-prev-disabled { 
    background-image: url(images/blank20.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;
    text-align: right;
    text-decoration:none;
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(0*multiplier)%>%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}
.buttons#paging-next-disabled {   
    background-image: url(images/blank20.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;    
    text-align: right;
    text-decoration:none;
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(0*multiplier)%>%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}

.button-section {  
    padding-top: 0em; 
    margin-top: 0em; 
    margin-left: 0em; 
    font-family: Verdana, sans-serif;  
    text-align: left; 
    font-weight:normal; 
    color: #000000; 
    /*background-color:#FFFFFF; 
    border-top: 1px solid #336699*/
    background-color: #d1d9e8; 
    border-left: 1px solid #88a4d7; 
    border-right: 1px solid #88a4d7; 
    border-top: 1px solid #88a4d7;
    border-bottom: 1px solid #88a4d7;     
} 

.linkButton {
    BORDER-RIGHT: #336699 1px solid; 
    BORDER-TOP: #8cb1d1 1px solid;
    BORDER-LEFT: #8cb1d1 1px solid; 
    BORDER-BOTTOM: #336699 1px solid; 
    BACKGROUND-COLOR: #EAF1FF;
    padding: 2px;
    padding-left:3px;
    margin-top: 5px;
    font-size: <%=(65*multiplier)%>%;
    text-decoration: none;    
    color:black;
    white-space: nowrap; 
    text-align: center;   
}


	

/*  SYSTEM STATUS AREA  */

.tray-text {   font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color:#FFFFFF; color: #000000;  }
.was-message-item  { color: #000000; font-family: Verdana,Helvetica,sans-serif; font-weight:bold; font-size:<%=(70*multiplier)%>%;  } 
.was-message-item a { font-weight: normal }





/* TABLES */
.table-text-white {   font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; background-color: #ffffff; background-image: none; }
.table-text {   font-family: Verdana, sans-serif; font-size:<%=(65*multiplier)%>%;  
    background-image: none; 
    background-color: #ffffff;
    overflow: auto;
    white-space: preserve;
}

.table-text-gray {   
    font-family: Verdana, sans-serif; font-size:<%=(65*multiplier)%>%;  background-image: none; color: #336699 
}
.table-text#running { color: green; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #F7F7F7; background-image: none; }
.table-text#stopped { color: black; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #F7F7F7; background-image: none; }
.table-text#problems { color: red; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #F7F7F7; background-image: none; }
.table-text#unknown { color: orange; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #F7F7F7; background-image: none; }
.column-head {  padding-left: .35em; font-family: Verdana,Helvetica, sans-serif; font-size: <%=(70*multiplier)%>%; font-weight:bold; text-align: left; color: #FFFFFF; background-color: #8691C7; background-image: none; }  
.column-head-name { 
    border-top: 1px solid #FFFFFF; border-left: 1px solid #FFFFFF; 
    padding-left: .35em; font-family: Verdana,Helvetica, sans-serif; 
    font-size: <%=(65*multiplier)%>%;font-weight:normal; text-align: left; 
    color: #000000; background-color: #d1d9e8; 
    background-image: none; 
    <% if (isDBCS) {%>
    white-space: nowrap;
    <% } %>
    
}   

.column-head-name-showFilter {  
    border-top: 1px solid #FFFFFF; border-left: 1px solid #FFFFFF; padding-left: .35em; font-family: Verdana,Helvetica, sans-serif; font-size: <%=(65*multiplier)%>%;font-weight:normal; text-align: left; color: #000000; background-image: none; 
}   
.column-head-filter {  
    border-top: 1px solid #FFFFFF; border-left: 1px solid #FFFFFF; padding-left: .35em; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%;font-weight:normal; text-align: left; color: #000000; background-color: #d1d9e8; background-image: none; 
}   
.column-head-prefs {  padding-left: .35em; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; font-weight:bold; text-align: left; color: #FFFFFF; background-color:#6B7A92; background-image: none; }  





.table-row-SELECTED {   
    font-family: Verdana,sans-serif; 
    font-size:<%=(65*multiplier)%>%; 
    background-color: #E7E7E7; 
}
.table-row {   
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; background-color: #f7f7f7; 
}
.collection-table-text {
    border-top: 1px solid #FFFFFF; 
    border-left: 1px solid #FFFFFF; 
    padding-left: .35em; font-family: 
    Verdana,Helvetica, sans-serif;
    font-weight:normal; 
    text-align: left;
    overflow: visible; 
}

.collection-table-property-text {
    margin-top: -0.5em;font-family: Verdana,Helvetica, sans-serif;font-weight:normal; text-align: left; font-size:<%=(65*multiplier)%>%;
}


.framing-table { background-color: #88a4d7; background-image: none; }
.noframe-framing-table  { background-color: #767776; background-image: none; border-right: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC;  border-left: 1px solid #CCCCCC; }

.layout-manager {  
    background-color:#FFFFFF; 
    border-right: 1px solid #88a4d7; 
    border-bottom: 1px solid #88a4d7;
    border-left: 1px solid #88a4d7; 
    min-width:600px;
    width:expression(document.body.clientWidth < 600? "600px": "auto" );
}
.layout-manager#notabs {  
    background-color:#FFFFFF; 
    /*border-top: 1px solid #88a4d7; 
    border-bottom: 1px solid #88a4d7;
    border-right: 1px solid #88a4d7;*/
    border: 0px;
    
}
 
.highlighted { background-color: #FFFFCC  }
.not-highlighted { background-color: #FFFFFF  }
.description-text { padding-left: 5px; font-family: Verdana,Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #FFFFFF}
.instruction-text { 
    font-weight:normal;padding-left: 5px; 
    margin-top: 8px; margin-bottom: 6px; 
    font-family: Verdana, Helvetica, sans-serif; 
    font-size:<%=(65*multiplier)%>%; 
    background-color: #FFFFFF;
}
.information {  font-family: Verdana, Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; color:#993300;}
.paging-text { font-size: <%=(71*multiplier)%>%}
.runtime-checkbox { font-size:<%=(70*multiplier)%>%; font-family: Verdana,Helvetica, sans-serif;  text-align: left; font-weight:normal; color: #000000; background-color:#CCCCCC; }

.find-filter {  
    font-family: Verdana, sans-serif; 
    font-size: <%=(65*multiplier)%>%; 
    color: #000000;  
    margin-left: 3px;  
}

.find-filter-expanded {   font-family: Verdana,Helvetica, sans-serif; font-size: <%=(71*multiplier)%>%; color: #000000; background-color: #AABFDF;  padding-left: 20px; padding-top: 5px; padding-bottom: 5px; border-bottom: 1px solid #88a4d7; border-top: 1px solid #88a4d7;  }
.find-filter-text {   font-family: Verdana,Helvetica, sans-serif; font-size: <%=(71*multiplier)%>%; color: #000000; background-color: #AABFDF; }
.collection-total {   font-family: Verdana,Helvetica, sans-serif; font-size: <%=(71*multiplier)%>%; color: #000000; background-color: #FFFFFF;  }
.collection-total-expanded {   padding-left: 40px; font-family: Verdana,Helvetica, sans-serif; font-size: <%=(71*multiplier)%>%; color: #000000; background-color: #FFFFFF;  }

.complex-property { 
    font-family: Verdana,Helvetica, sans-serif; 
    font-size:<%=(65*multiplier)%>%; 
    padding-left: 2.5em;  
}

.expand-task {
    margin-top: 2px; margin-bottom: 2px; text-decoration: none; color: #000000;    
}


.column-filter-expanded {   
    font-family: Verdana,Helvetica, sans-serif; 
    font-size: <%=(65*multiplier)%>%; 
    color: #000000; 
    background-color: #88a4d7;  
    padding-left:1em; padding-top: 0px; 
    padding-bottom: 0px; 
    /**border-bottom: 1px solid #AABFDF; 
    border-top: 1px solid #AABFDF;**/
}



/*  BODY STYLES */

a {color:#0000FF }
a:active { color:#666666 }
#plusminus {text-decoration: none; color: #000000; }
.content {  background-color: #FFFFFF ; font-family: Verdana, Helvetica, sans-serif; scrollbar-face-color:#CCCCCC; scrollbar-shadow-color:#FFFFFF; scrollbar-highlight-color:#FFFFFF; scrollbar-3dlight-color:#6B7A92; scrollbar-darkshadow-color:#6B7A92; scrollbar-track-color:#E2E2E2; scrollbar-arrow-color:#6B7A92 }
.topology-view {  padding-top: 5px;  font-family: Verdana, Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; background-color: #FFFFFF}
.topology-view H1#bread-crumb{  font-family: Verdana, Helvetica, sans-serif; font-size: 130%; background-color: #FFFFFF ; letter-spacing: -.03em;  margin-top: .75em; margin-bottom: -.25em;}
.topology-view p.instruction-text{  padding-left:.5em; font-family: Verdana, Helvetica, sans-serif; font-size: 100%; background-color: #FFFFFF}

<% if (browserJava.equals("GECKO")) {  %>
.navtree { 
    margin-left: 4px;
    margin-right:5px;
    font-size:<%=(70*multiplier)%>%;
    background-color: #FFFFFF; 
    font-family: Verdana, sans-serif; 
    /*border-right: 1px solid #CCCCCC; */
    margin-top: 0px; 
    scrollbar-face-color:#CCCCCC; 
    scrollbar-shadow-color:#FFFFFF; 
    scrollbar-highlight-color:#FFFFFF; 
    scrollbar-3dlight-color:#6B7A92; 
    scrollbar-darkshadow-color:#6B7A92; 
    scrollbar-track-color:#E2E2E2; 
    scrollbar-arrow-color:#6B7A92;
    min-width: 200px;
}
<% } else { %>
.navtree {  
    margin-left: 4px;
    margin-right:0px;
    font-size:<%=(70*multiplier)%>%;
    background-color: #FFFFFF; 
    font-family: Verdana, sans-serif; 
    border-right: 1px solid #CCCCCC; 
    margin-top: 0px; 
    scrollbar-face-color:#CCCCCC; 
    scrollbar-shadow-color:#FFFFFF; 
    scrollbar-highlight-color:#FFFFFF; 
    scrollbar-3dlight-color:#6B7A92; 
    scrollbar-darkshadow-color:#6B7A92; 
    scrollbar-track-color:#E2E2E2; 
    scrollbar-arrow-color:#6B7A92;
    width:expression(document.body.clientWidth < 200? "200px": "auto" );
}
<% } %>


.navigation-table { background-color: #FFFFFF; font-family: Verdana, Helvetica, sans-serif; }
.navigation-table-entry {  font-family: Verdana, Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; }

.main-task {
    font-size:<%=(90*multiplier)%>%; 
    padding: 0em;
    margin-top: .5em; 
    margin-bottom:0em; 
    text-decoration: none; 
    color: #000000; 
    background-color:#DCDFEF; 
    border:1px solid #CCCCCC;    
    width:expression(document.body.clientWidth < 200? "200px": "auto" );
}
.sub-task {
    font-size:<%=(90*multiplier)%>%; 
    padding: .0em;
    margin-top: .25em; 
    margin-bottom:0em; 
    text-decoration: none; 
    color: #000000; 
}

.nav-child {
    padding-top: 1px;
    padding-bottom:1px;
    padding-left:1em;
}
.nav-child-container {
    display:none;
    background-color:#F7F7F7;
    border-left:1px solid #CCCCCC;
    border-bottom:1px solid #CCCCCC;
    border-right:1px solid #CCCCCC;
    padding-top:.25em;
    padding-right:.5em;
    padding-bottom:.25em;
    padding-left: 1.25em;
    margin-bottom:.5em;
    width:expression(document.body.clientWidth < 200? "200px": "auto" );
}
.sub-child-container {
    display:none;
    background-color:#F7F7F7;
    /*border-left:1px solid #CCCCCC;
    border-bottom:1px solid #CCCCCC;
    border-right:1px solid #CCCCCC;*/
    padding-top:0em;
    padding-right:.5em;
    padding-bottom:.25em;
    padding-left: 1.5em;
}




/*  TITLES  */

H1 { font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; ; margin-left: 5px }
H1#title-bread-crumb { font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; margin-top:.5em; margin-bottom: 0em; }
H1#bread-crumb { font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%;   margin-top: .5em; margin-bottom: 0em; }
H3#bread-crumb { 
    font-family: Verdana,Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; margin-top: 0em;  margin-bottom: 0em;
}

H2 { 
    margin-left:0em; 
    margin-right: 3px; 
    margin-top: 0px; background-color:#FFFFFF; font-size:<%=(65*multiplier)%>%; 
    border-bottom: 2px solid #336699; 
    margin-bottom: 3px; FONT-FAMILY: Verdana, Helvetica, sans-serif; COLOR: #336699; 
    wrap: off;
}
H3 {
    border-bottom: 1px solid #336699;
    margin-top: 1em;
    margin-bottom: 0em;
    margin-left: 1em;
    width: 100%;
    font-size:<%=(60*multiplier)%>%;
    color: #336699;
}
.property-section-title {
    font-family: Verdana,sans-serif; 
    text-align: left; 
    background-color: #FFFFFF;
}

/******* Additional Properties Categories ************/
.main-category {
    font-size:<%=(65*multiplier)%>%; 
    padding: 0em;
    margin-top: .5em; 
    margin-bottom:0em; 
    text-decoration: none; 
    color: #336699; 
    font-weight:bold;
    border-bottom: 2px solid #336699; 
    width: 100%;
    margin-left:0em;
    white-space: nowrap; 
    <% if (isDBCS) {%>
    width:150px;    
    <% } %>   
}
.sub-category {
    font-size:<%=(60*multiplier)%>%; 
    padding-top: 0.5em;
    margin-top: .25em; 
    margin-bottom:0em; 
    text-decoration: none; 
    color: #336699;
    width: 100%;
    margin-left:0em;
}

.main-child {
    padding-top: 1px;
    padding-bottom:1px;
    /*margin-left:1em;*/
    padding-left:0.8em;
    font-size:<%=(50*multiplier)%>%; 
    min-width:100px;
}
.main-category-container {
    padding-top:.25em;
    padding-right:.5em;
    padding-bottom:.25em;
    padding-left: .5em;
    margin-bottom:.5em;
    min-width:100px;
    width:expression(document.body.clientWidth< 100? "100px": "auto" );    
}
.sub-category-container {
    padding-top:0em;
    padding-right:.5em;
    padding-bottom:.25em;
    padding-left: 1em;
}
                                                                                                              




/* HELP PAGES */

.help {  font-size:<%=(70*multiplier)%>%; margin: 0px; background-color: #FFFFFF ; font-family: Verdana, Helvetica, sans-serif }
.index-link { font-family: Verdana, Helvetica, sans-serif; font-size: <%=(75*multiplier)%>%; text-align: right; padding-top: 10px; padding-right: 10px; }


/* TREES */

#Item0 { font-weight: bold; padding-top: 5px}

.indent1 {   padding-left:0px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px  } 
.indent2 {   padding-left:19px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px  }
.indent3 {   padding-left:38px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent4 {   padding-left:57px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px  }
.indent5 {   padding-left:76px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent6 {   padding-left:95px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent7 {   padding-left:114px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent8 {   padding-left:133px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent9 {   padding-left:152px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent10 {   padding-left:171px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent1kids {   padding-left:-19px; font-family: Verdana,Helvetica, sans-serif; margin-top: 10px; margin-bottom: 4px; font-weight: bold; margin-left: 5px  } 
.indent2kids {   padding-left:0px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px  }
.indent3kids {   padding-left:19px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent4kids {   padding-left:38px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px  }
.indent5kids {   padding-left:57px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent6kids {   padding-left:76px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent7kids {   padding-left:95px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent8kids {   padding-left:114px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent9kids {   padding-left:133px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }
.indent10kids {   padding-left:152px; font-family: Verdana,Helvetica, sans-serif; margin-top: 1px; margin-bottom: 1px; margin-left: 5px   }






/* VALIDATION ERRORS */

.validation-error {
    color: #CC0000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-warn-info {
    color: #000000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-header { 
    color: #FFFFFF; background-color:#6B7A92; font-family: Verdana, sans-serif;
    font-weight:bold; 
    font-size: <%=(65*multiplier)%>% 
}



/* HOMEPAGE STYLES */

<% if (isDBCS) { multiplierWildCard = 0.95; }  %>

.nolines {  font-size: <%=(75*multiplier*multiplierWildCard)%>%; borders: 0px solid #CCCCFF;  }
.linesmost { font-size: <%=(75*multiplier*multiplierWildCard)%>%;   border-left: 0px; border-bottom: 0px; border-top: 1px solid #CCCCFF; border-right: 1px solid #CCCCFF;  background-color: #FFFFFF; padding-bottom: 12px}
.purpletext { font-family: sans-serif; color: #9933CC; font-size: <%=(104*multiplier*multiplierWildCard)%>%;}
.purplebold { font-weight: bold; color: #9933CC; font-size: <%=(107*multiplier*multiplierWildCard)%>%; font-family: Helvetica,sans-serif;}
.graytext { font-family: sans-serif; color: #666666; font-size: <%=(104*multiplier*multiplierWildCard)%>%;}
.graybold { font-weight: bold; color: #363636; font-size: <%=(107*multiplier*multiplierWildCard)%>%; font-family: Helvetica,sans-serif;}
.desctextabout { font-family: sans-serif; color: #363636; font-size: 101%; padding-bottom: 5px; line-height: 160%}
.desctexthead { font-weight: 600; font-family: sans-serif; color: #333333; font-size: <%=(104*multiplier*multiplierWildCard)%>%; padding-bottom: 5px; line-height: 155%}
.desctext { font-family: sans-serif; color: #666666; font-size: <%=(90*multiplier*multiplierWildCard)%>%; line-height: 130%}
.bluebold { font-weight: bold; color: #330066; font-size: <%=(107*multiplier*multiplierWildCard)%>%; font-family: Helvetica,sans-serif;}
a .purpletext { text-decoration: underline #000000}
a .purplebold { text-decoration: underline  #000000}
a .bluebold  {  text-decoration: underline; color: blue  }
a .graybold  {  text-decoration: underline  #000000}


 
/***********  NEW STYLES ***********/ 
.portalPage { margin-top: 10px; margin-left: 8px; background-color:#FFFFFF; border-bottom: 1px solid #CCCCCC; margin-bottom: 10px; FONT-FAMILY: Verdana, Helvetica, sans-serif; COLOR: #CCCCCC; }
.portalPage a { text-decoration: none; font-weight: normal; text-align: right; FONT-FAMILY: Verdana, Helvetica, sans-serif; }
.pageTitle { color: #999999; FONT-FAMILY: Verdana, Helvetica, sans-serif; font-size:<%=(70*multiplier)%>%; text-align: left }
.pageClose { FONT-FAMILY: Verdana, Helvetica, sans-serif; font-size:<%=(65*multiplier)%>%; text-align: right }    

.wpsToolBar {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; BACKGROUND-COLOR: #F7F7F7
}
.wpsToolBarIcon {
	BORDER-RIGHT: #ffffff 0px; PADDING-RIGHT: 0px; BORDER-TOP: #ffffff 1px solid; PADDING-LEFT: 0px; FONT-SIZE: <%=(60*multiplier)%>%; PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: #ffffff 1px solid; COLOR: #ffffff; PADDING-TOP: 0px; BORDER-BOTTOM: #ffffff 1px solid; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; BACKGROUND-COLOR: #5495d5
}
.wpsToolBarIconOn {
	BORDER-RIGHT: #ffffff 0px; PADDING-RIGHT: 0px; BORDER-TOP: #ffffff 1px solid; PADDING-LEFT: 0px; FONT-SIZE: <%=(60*multiplier)%>%; PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: #ffffff 1px solid; COLOR: #666666; PADDING-TOP: 0px; BORDER-BOTTOM: #ffffff 1px solid; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; BACKGROUND-COLOR: #3d67bb
}
.wpsToolBarLink {
    FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: none
}
.wpsToolBarLink:visited {
	FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: none
}
.wpsToolBarLink:hover {
	COLOR: #336699; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: none
}
.wpsToolBarSeparator {
	BACKGROUND-COLOR: #F7F7F7
}
.wpsToolbarBannerBackground {
	BORDER-RIGHT: #ffffff 0px; PADDING-RIGHT: 0px; BACKGROUND-POSITION: left bottom; BORDER-TOP: #ffffff 1px solid; PADDING-LEFT: 0px; BACKGROUND-IMAGE: url(../../banner.jpg); PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: #ffffff 1px solid; PADDING-TOP: 0px; BORDER-BOTTOM: #ffffff 1px solid; BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #cfd9e5
}
.wpsLinkBar {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #ffffff; BACKGROUND-REPEAT: no-repeat; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; BACKGROUND-COLOR: #ffffff
}
.wpsLinkBarLink {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #817279; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: underline
}
.wpsLinkBarLink:visited {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #817279; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: underline
}
.wpsLinkBarLink:hover {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #817279; FONT-FAMILY: Verdana, Verdana, Helvetica, sans-serif; TEXT-DECORATION: underline
}

.wpsGpFilter {
	BACKGROUND-COLOR: #d4d4d4; font-family: Verdana,Helvetica, sans-serif; font-size: <%=(70*multiplier)%>%; 
}
.wpsGpFilterLabel {
	FONT-WEIGHT: bold; BACKGROUND-COLOR: #d4d4d4; font-family: Verdana,Helvetica, sans-serif; font-size: <%=(70*multiplier)%>%; 
}
.wpsPortletTitle {
	text-align: left;border-left: #000000 1px solid;  border-top: #000000 1px solid; border-bottom: #000000 1px solid; FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #ffffff; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #5495d5;
}
.wpsPortletTitleControls {
	text-align: right;border-top: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid; FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #ffffff; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #5495d5;
}

<% //WSC: needed for Federation
if ( federated.booleanValue() && isPortletCompatible.booleanValue()) { %>

.wpsPortletArea {
        BACKGROUND-COLOR: #FFFFFF;
        padding: 0.75em;
}
<%} else { %>
.wpsPortletArea {
        border-left: #CCCCCC 1px solid; 
        border-right: #CCCCCC 1px solid; 
        border-bottom: #CCCCCC 1px solid; 
        BACKGROUND-COLOR: #FFFFFF;
        padding: 0.75em;
}
<%}%>

<% //WSC: needed for Federation special css for federation
if ( federated.booleanValue() && isPortletCompatible.booleanValue()) { %>

.wpsPortletFederationHelpTitle {
	text-align: left;border-left: #D1D9E8 2px solid;  
	border-top: #D1D9E8 2px solid; border-bottom: #D1D9E8 2px solid; 
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; 
	BACKGROUND-COLOR: #D1D9E8;
}

.wpsPortletTitleControlsFederation {
	text-align: right; border-top: #D1D9E8 2px solid; 
	border-right: #D1D9E8 2px solid; border-bottom: #D1D9E8 2px solid; 
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; 
	BACKGROUND-COLOR: D1D9E8;
}

.wpsPortletAreaHelpFederation {
        border-left: #D1D9E8 2px solid; 
        border-right: #D1D9E8 2px solid; 
        border-bottom: #D1D9E8 2px solid; 
        BACKGROUND-COLOR: #F7f7F7;
        padding: 0.75em;
}

.table-textHelpFederation {   
	font-family: Verdana, sans-serif; font-size:<%=(65*multiplier)%>%;  
    background-image: none; 
    background-color: #F7f7F7;
    overflow: visible; 
}

<%}%>


.wpsTaskBarTable {
	COLOR: #000000; BACKGROUND-COLOR: #d4d4d4;  border-bottom: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; margin: 3px;
}
.wpsTaskBar {
	COLOR: #000000; BACKGROUND-COLOR: #d4d4d4; border-top: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC;
}
.wpsTaskBarText {
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none
}



.wpsLoginHeadText {
	FONT-WEIGHT: bold; FONT-SIZE: small; MARGIN: 0px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #e8e8e8
}
.wpsLoginText {
	FONT-SIZE: <%=(60*multiplier)%>%; MARGIN: 0px; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #e8e8e8
}



 
.taskHead { 
    background-color: #CCCCCC
}
.taskHead a { 
	FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; TEXT-DECORATION: none
}

.wasMessagePortlet {
    margin-left: 10px; margin-top: 0px;
}
.messagePortlet {
    background-color: #F7F7F7; border: 1px solid #88a4d7;
}
.messageTitle {
    FONT-SIZE: <%=(65*multiplier)%>%;
    /*background-color:#DCDFEF;*/
}
#inlineMessage .buttons {
    FONT-SIZE: <%=(70*multiplier)%>%; background-color:#E2E2E2
}
.wasMessageArea {
        border-left: #CCCCCC 1px solid; border-right: #CCCCCC 1px solid; BACKGROUND-COLOR: #FFFFFF
}
.wpsTaskBarTableFrame {
    margin-bottom: 12px; margin-right: 0px;padding-top: 8px;width:100%;background-color:#CCCCCC
}
.validationMessages {
    margin-left: 10px; 
}
.wasPortlet {
    margin-left: 10px; margin-top: 0px;
}
.wasUniPortlet {
    margin-top: 10px;
}
  
   
<% if (browserJava.equals("GECKO")) {  %>
.navPortlet {
    margin-left: 5px; margin-top: .5em;
}
.navPortletTasks {
    margin-left: 5px; margin-bottom: 0em; margin-top: 0em;
}
<% } else { %>
.navPortlet {
    margin-left: 5px; margin-top: 8px;
}
.navPortletTasks {
    margin-left: 5px; margin-bottom: 5px;
}
<% } %>


.navPortletTitle {
	font-weight:normal;text-align: left;border-left: #CCCCCC 1px solid;  border-top: #CCCCCC 1px solid; border-bottom: #CCCCCC 1px solid; FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; BACKGROUND-COLOR: #E7E7E7;
}

.navPortletTitleControls {
	text-align: right;border-top: #CCCCCC 1px solid; border-right: #CCCCCC 1px solid; border-bottom: #CCCCCC 1px solid; FONT-SIZE: <%=(60*multiplier)%>%; COLOR: #000000; FONT-FAMILY: Verdana, sans-serif; BACKGROUND-COLOR: #E7E7E7;
}
.navPortletArea {
        border-left: #E2E2E2 1px solid; border-right: #E2E2E2 1px solid; border-bottom: #E2E2E2 1px solid; BACKGROUND-COLOR: #FFFFFF;
}

.contentFrame {
    border-top: 1px solid #88a4d7; border-bottom: 1px solid #88a4d7;
}
.collection-form {
    border-top: 1px solid #88a4d7;
}
.nav-select-element {
    font-family: Verdana,sans-serif; 
    font-size:<%=(95*multiplier)%>%; 
    border:1px #000000 solid; 
    margin-top: 0em;
    padding: 2px; 
    margin-left: 0em;    
}   

.helpTextDIV {
   /* border-bottom:1px #336699 solid;
    border-left:1px #336699 solid;  */
    font-family: Verdana,sans-serif; 
    font-size:<%=(95*multiplier)%>%;
    margin-left: 2.5em;
    padding:0em;
    color: #C0C0C0;
    margin-bottom: -1em; 
    margin-top: 0.15em;
    margin-right:2em; 
    width:90%;
}

.checkboxhelpTextDIV {
   /* border-bottom:1px #336699 solid;
    border-left:1px #336699 solid;  */
    font-family: Verdana,sans-serif; 
    font-size:<%=(95*multiplier)%>%;
    margin-left: 2.5em;
    padding:0em;
    color: #C0C0C0;
    margin-top: 0.15em;
    margin-right:2em; 
    width:90%;
}

.helpSectionTitles {
    font-weight:bold;
<% if (isDBCS) { multiplierWildCard = 1.1; }  %>
    font-size:<%=(65*multiplier*multiplierWildCard)%>%;
    margin-bottom:.25em;
}

#fieldHelpPortlet {
    max-height:200px;
    min-width: 150px;
    width: 150px;
    overflow: auto;
}



</style>

<%
//  BEGIN Javascript Translated Text Variables
String pleaseWait = "null";

String statusStarted = "null";
String statusStopped = "null";
String statusUnavailable = "null";
String statusUnknown = "null";
String statusPartialStart = "null";
String statusPartialStop = "null";
String statusSynchronized = "null";
String statusNotSynchronized = "null";

String moveInListError = "null";
String noInfoAvailable = "null";

String lookInPageHelp = "null";

String selectText = "null";
			
MessageResources statusMessages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
try { pleaseWait = statusMessages.getMessage(request.getLocale(),"trace.tree.pleaseWaitLabel"); } catch (Exception e) { } 

try { statusStarted = statusMessages.getMessage(request.getLocale(),"ExecutionState.STARTED"); } catch (Exception e) { } 
try { statusStopped = statusMessages.getMessage(request.getLocale(),"ExecutionState.STOPPED"); } catch (Exception e) { } 
try { statusUnavailable = statusMessages.getMessage(request.getLocale(),"ExecutionState.UNAVAILABLE"); } catch (Exception e) { }
try { statusUnknown = statusMessages.getMessage(request.getLocale(),"ExecutionState.UNKNOWN"); } catch (Exception e) { } 
try { statusPartialStart = statusMessages.getMessage(request.getLocale(),"ExecutionState.PARTIAL_START"); } catch (Exception e) { } 
try { statusPartialStop = statusMessages.getMessage(request.getLocale(),"ExecutionState.PARTIAL_STOP"); } catch (Exception e) { } 
try { statusSynchronized = statusMessages.getMessage(request.getLocale(),"Node.synchronized"); } catch (Exception e) { } 
try { statusNotSynchronized = statusMessages.getMessage(request.getLocale(),"Node.not.synchronized"); } catch (Exception e) { } 

try { moveInListError = statusMessages.getMessage(request.getLocale(),"move.in.list.error"); } catch (Exception e) { } 

try { noInfoAvailable = statusMessages.getMessage(request.getLocale(),"wsc.field.help.noinfo"); } catch (Exception e) { } 

try { lookInPageHelp = statusMessages.getMessage(request.getLocale(),"wsc.field.help.lookin.page"); } catch (Exception e) { } 

try { selectText = statusMessages.getMessage(request.getLocale(),"select.text"); } catch (Exception e) { } 

%>
<script LANGUAGE="JavaScript">
var pleaseWait = "<%=pleaseWait%>";

var statusStarted = "<%=statusStarted%>";
var statusStopped = "<%=statusStopped%>";
var statusUnavailable = "<%=statusUnavailable%>";
var statusUnknown = "<%=statusUnknown%>";
var statusPartialStart = "<%=statusPartialStart%>";
var statusPartialStop = "<%=statusPartialStop%>";
var statusSynchronized = "<%=statusSynchronized%>";
var statusNotSynchronized = "<%=statusNotSynchronized%>";


if (statusStarted == "null") { statusStarted = "Started" }
if (statusStopped == "null") { statusStopped = "Stopped" }
if (statusUnavailable == "null") { statusUnavailable = "Unavailable" }
if (statusUnknown == "null") { statusUnknown = "Unknown" }
if (statusPartialStart == "null") { statusPartialStart = "Partial Start" }
if (statusPartialStop == "null") { statusPartialStop = "Partial Stop" }
if (statusSynchronized == "null") { statusSynchronized = "Synchronized" }
if (statusNotSynchronized == "null") { statusStarted = "Not Synchronized" }
statusArray = new Array(statusStarted,statusStopped,statusUnavailable,statusUnknown,statusPartialStart,statusPartialStop,statusSynchronized,statusNotSynchronized);
var statusIconStarted = '/ibm/console/images/running.gif';        
var statusIconStopped = '/ibm/console/images/stop.gif';
var statusIconUnavailable = '/ibm/console/images/unavail.gif';
var statusIconUnknown = '/ibm/console/images/unknown.gif';
var statusIconPartialStart = '/ibm/console/images/part_start.gif';
var statusIconPartialStop = '/ibm/console/images/part_stop.gif';
var statusIconSynchronized = '/ibm/console/images/synch.gif';
var statusIconNotSynchronized = '/ibm/console/images/not_synch.gif';                
statusIconArray = new Array(statusIconStarted,statusIconStopped,statusIconUnavailable,statusIconUnknown,statusIconPartialStart,statusIconPartialStop,statusIconSynchronized,statusIconNotSynchronized);

var moveInListError = "<%=moveInListError%>";
var noInfoAvailable = "<%=noInfoAvailable%>";

var lookInPageHelp = "<%=lookInPageHelp%>";

var selectText = "<%=selectText%>";
</script>

