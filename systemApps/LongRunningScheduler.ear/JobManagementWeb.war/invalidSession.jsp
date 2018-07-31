<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
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
<LINK href="theme/<%= masterCSS %>" rel="stylesheet" type="text/css">
<SCRIPT>
    function redirectToTop() {
        if (top.header != null) {
            top.location = document.location.href;
        }
    }
</SCRIPT>
</HEAD>
<TITLE><bean:message key="jmc"/></TITLE>

<BODY ONLOAD="javascript:redirectToTop();">
<table border="0" cellspacing="0" cellpadding="0" width="100%"  class="wpsBannerEnclosure">
  <tbody>
  <tr>
    <td align="left" nowrap width="20%" style="padding-left:10px;" class="wpsTitleText"><bean:message key="jmc"/></td>
    <td align="right" CLASS="wpsToolBar" ><img alt='IBM' title='IBM' src='images/iscbanner-mosaic.gif'/></td>
  </tr>
  </tbody>
</table>

<br><br>
<TABLE align="CENTER" border="0" cellpadding="0" cellspacing="0" width="80%">
  <TR>
    <TD>
    <TABLE border="0" width="100%" cellpadding="0" cellspacing="0" class="wpsPortletTitle">
      <TR ALIGN="left">
        <TH >&nbsp;<bean:message key="invalidSessionTitle"/>&nbsp;</TH>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD  CLASS="wpsPortletBorder"><BR>
    <form method="GET" action="/jmc/index.jsp" target="_top">
       <TABLE border="0" cellpadding="2" cellspacing="1" width="100%" summary="Login Table" >
         <TR>
           <TD valign="top" class="table-text" header="header1" >
           <bean:message key="invalidSessionMsg"/>
           </TD>
         </TR>
         <TR>
           <TD  valign="top" header="header1" bgcolor="#FFFFFF" ><BR>
           <input type="submit" name="ok" value="<bean:message key="button.ok"/>" class="buttons"/>
           </TD>
         </TR>
       </TABLE>
     </form>
     </TD>
  </TR>
</TABLE>
</BODY>
</html:html>
