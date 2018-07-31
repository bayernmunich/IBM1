<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

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
<TITLE><bean:message key="jmc"/></TITLE>
</HEAD>

<BODY onLoad="document.logonForm.j_username.focus()"  bgColor="#e8e8e8">

<div role="banner>
<table border="0" cellspacing="0" cellpadding="0" width="100%"  class="wpsBannerEnclosure" role="presentation">
  <tbody>
  <tr>
    <td align="left" nowrap width="20%" style="padding-left:10px;" class="wpsTitleText"><bean:message key="jmc"/></td>
    <td align="right" CLASS="wpsToolBar" ><img alt='IBM' title='IBM' src='images/iscbanner-mosaic.gif'/></td>
  </tr>
  </tbody>
</table>
</div>

<div role="main">
<table>
<tr><td width="100%" align="left" valign="top">
<form name="logonForm" method="post" action="/jmc/j_security_check">
<table border="0" cellpadding="5" cellspacing="0" width="100%" height="100%" bgColor="#e8e8e8" role="presentation">
  <tr> 
    <td VALIGN="top" WIDTH="100%"> 
      <table border="0" cellpadding="0" cellspacing="0"  bgColor="#e8e8e8">
        <tr>
          <td align="left" CLASS="wpsLoginHeadText" nowrap><bean:message key="indexWelcome"/></td>
        </tr>
		<tr>
          <td align="left" valign=top width="33%" class="wpsLoginText" nowrap >
		  <label for="j_username"><bean:message key="userId"/></label>
                  </td>
                  </tr>
                  <tr>
                  <td align="left">
				  <input TYPE="text" class="noIndentTextEntry" name="j_username" id="j_username"/> 
        </td>
              </tr>
			  
			  <tr>
          <td align="left" valign=top width="33%" class="wpsLoginText" nowrap >
		  <label for="j_password"><bean:message key="password"/></label>
                  </td>
                  </tr>
                  <tr>
                  <td align="left">
				  <input TYPE="password" class="noIndentTextEntry" name="j_password" id="j_password"/>
        </td>
              </tr>
			  
        <tr>
           <td align="left" valign=top class="wpsLoginText" nowrap ><input type="submit" name="action" value="<bean:message key="logIn"/>" class="buttons"></td>
        </tr>
        <tr>
          <td align="left" CLASS="wpsLoginText"><br><bean:message key="logInNote"/></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</div>
</td>
    <td VALIGN="top"><img alt='IBM' title='IBM' src='images/bgrid.gif'/></td>
</tr></table>
</BODY>
</html:html>
