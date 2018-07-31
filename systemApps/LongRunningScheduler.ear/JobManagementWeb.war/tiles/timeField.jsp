<%@ page import="java.util.Calendar,java.util.StringTokenizer" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<tiles:useAttribute name="startTime"  classname="java.lang.String"/>
<tiles:useAttribute name="disabled"   classname="java.lang.String"/>
<tiles:useAttribute name="required"   classname="java.lang.String"/>
<tiles:useAttribute name="labelStyle" classname="java.lang.String"/>
<%
    Calendar currentTime = Calendar.getInstance();
    currentTime.add(Calendar.MINUTE, 15);
    int hour = currentTime.get(Calendar.HOUR_OF_DAY);
    int min  = currentTime.get(Calendar.MINUTE);
    int sec  = currentTime.get(Calendar.SECOND);
    String hourStr = ((hour < 10) ? "0" : "") + Integer.toString(hour);
    String minStr  = ((min < 10)  ? "0" : "") + Integer.toString(min);
    String secStr  = ((sec < 10)  ? "0" : "") + Integer.toString(sec);
    StringTokenizer startTimeTokens = new StringTokenizer(startTime, ":" );
    if (startTimeTokens.countTokens() == 3) {
        hourStr = startTimeTokens.nextToken();
        minStr  = startTimeTokens.nextToken();
        secStr  = startTimeTokens.nextToken();
    }
    String upbuttonImg   = disabled.length() > 0 ? "upbuttondisabled.gif"   : "upbutton.gif";
    String downbuttonImg = disabled.length() > 0 ? "downbuttondisabled.gif" : "downbutton.gif";
%>

            <table border="0" cellspacing="0" role="presentation">
              <tr>
                <td colspan=8 class="table-text">
<% if (required.equals("true")) { %>
                <img id="requiredImage-timefield" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<% } %>
                <bean:message key="startTime"/>
                </td>
              </tr>
              <tr>
                <td  class="table-text">
                  <label for="startTimeHour" title="<bean:message key="hour"/>">
                  <input type="text" name="startTimeHour" size=2" maxlength="2" value="<%=hourStr%>" class="noIndentTextEntry" style="margin-left: 0.6em;" id="startTimeHour" <%=disabled%>>
                  </label>
                </td>
                <td>
                <table border="0" cellspacing="0" CELLPADDING="0" role="presentation">
                  <tr><td><img role="button" src="images/<%=upbuttonImg%>"   onmouseup="incDigit('startTimeHour', 24)" onmousedown="document.images['startTimeHourUp'].src='images/upbuttondown.gif'" id="startTimeHourUp" <%=disabled%> alt="<bean:message key="incHour"/>"/></td></tr>
                  <tr><td><img role="button" src="images/<%=downbuttonImg%>" onmouseup="decDigit('startTimeHour', 24)" onmousedown="document.images['startTimeHourDown'].src='images/downbuttondown.gif'" id="startTimeHourDown" <%=disabled%> alt="<bean:message key="decHour"/>"/></td></tr>
                </table>
                </td>
                <td class="table-text">:</td>
                <td  class="table-text">
                  <label for="startTimeMinute" title="<bean:message key="minute"/>">
                  <input type="text" name="startTimeMinute" size=2" maxlength="2" value="<%=minStr%>" class="noIndentTextEntry" id="startTimeMinute" <%=disabled%>>
                  </label>
                </td>
                <td>
                <table border="0" cellspacing="0" CELLPADDING="0" role="presentation">
                  <tr><td><img role="button" src="images/<%=upbuttonImg%>"   onmouseup="incDigit('startTimeMinute', 60)" onmousedown="document.images['startTimeMinuteUp'].src='images/upbuttondown.gif'" id="startTimeMinuteUp" <%=disabled%> alt="<bean:message key="incMin"/>"/></td></tr>
                  <tr><td><img role="button" src="images/<%=downbuttonImg%>" onmouseup="decDigit('startTimeMinute', 60)" onmousedown="document.images['startTimeMinuteDown'].src='images/downbuttondown.gif'" id="startTimeMinuteDown" <%=disabled%> alt="<bean:message key="decMin"/>"/></td></tr>
                </table>
                </td>
                <td class="table-text">:</td>
                <td  class="table-text">
                  <label for="startTimeSecond" title="<bean:message key="second"/>">
                  <input type="text" name="startTimeSecond" size=2" maxlength="2" value="<%=secStr%>" class="noIndentTextEntry" id="startTimeSecond" <%=disabled%>>
                  </label>
                </td>
                <td>
                <table border="0" cellspacing="0" CELLPADDING="0" role="presentation">
                  <tr><td><img role="button" src="images/<%=upbuttonImg%>"   onmouseup="incDigit('startTimeSecond', 60)" onmousedown="document.images['startTimeSecondUp'].src='images/upbuttondown.gif'" id="startTimeSecondUp" <%=disabled%> alt="<bean:message key="incSec"/>"/></td></tr>
                  <tr><td><img role="button" src="images/<%=downbuttonImg%>" onmouseup="decDigit('startTimeSecond', 60)" onmousedown="document.images['startTimeSecondDown'].src='images/downbuttondown.gif'" id="startTimeSecondDown" <%=disabled%> alt="<bean:message key="decSec"/>"/></td></tr>
                </table>
                </td>
              </tr>
            </table>