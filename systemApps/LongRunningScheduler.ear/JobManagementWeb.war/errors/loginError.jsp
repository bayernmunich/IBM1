
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<% 
    String lang = response.getLocale().toString();
    String masterCSS = "Master.css";
    if (lang.equals("ko") || lang.equals("zh") || lang.equals("zh_TW") || lang.equals("ja_JP"))
        masterCSS = lang + "/" + masterCSS;
%>
<html:html>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../theme/<%= masterCSS %>" rel="stylesheet" type="text/css">
<TITLE><bean:message key="jmc"/></TITLE>
</HEAD>

<BODY bgColor="#e8e8e8">

<table border="0" cellspacing="0" cellpadding="0" width="100%"  class="wpsBannerEnclosure">
  <tbody>
  <tr>
    <td align="left" nowrap width="20%" style="padding-left:10px;" class="wpsTitleText">Job Management Console</td>
    <td align="right" CLASS="wpsToolBar" ><img alt='IBM' title='IBM' src='../images/iscbanner-mosaic.gif'/></td>
  </tr>
  </tbody>
</table>

<table>
<tr><td width="100%" align="left" valign="top">
<form name="logonForm" method="post" action="/jmc/index.jsp">
<table border="0" cellpadding="5" cellspacing="0" width="100%" height="100%" bgColor="#e8e8e8">
  <tr> 
    <td VALIGN="top" WIDTH="100%"> 
      <table border="0" cellpadding="0" cellspacing="0" width="65%"  bgColor="#e8e8e8">
        <tr>
          <td align="left" valign="top" width="33%" class="wpsLoginText" nowrap >
            <span class='validation-error'>
              <img title='<bean:message key="loginFailed"/>' align="baseline" height="16" width="16" src="../images/error.gif"/>
                <bean:message key="loginFailed"/>
            </span>
          </td>
        </tr>
        <tr>
          <td><input type="submit" name="action" value="<bean:message key="button.ok"/>" class="buttons"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</td>
    <td VALIGN="top"><img alt='IBM' title='IBM' src='../images/bgrid.gif'/></td>
</tr></table>
</BODY>
</html:html>
