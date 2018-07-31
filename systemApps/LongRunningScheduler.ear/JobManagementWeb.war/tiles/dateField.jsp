<%@ page import="java.util.Calendar,java.util.StringTokenizer" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>

<tiles:useAttribute name="startDate"  classname="java.lang.String"/>
<tiles:useAttribute name="disabled"   classname="java.lang.String"/>
<tiles:useAttribute name="required"   classname="java.lang.String"/>
<tiles:useAttribute name="labelStyle" classname="java.lang.String"/>
<%
    Calendar currentTime = Calendar.getInstance();
    currentTime.add(Calendar.MINUTE, 15);
    int year = currentTime.get(Calendar.YEAR);
    int mon  = currentTime.get(Calendar.MONTH) + 1;
    int day  = currentTime.get(Calendar.DATE);
    String yearStr = ((year < 10) ? "0" : "") + Integer.toString(year);
    String monStr  = ((mon < 10)  ? "0" : "") + Integer.toString(mon);
    String dayStr  = ((day < 10)  ? "0" : "") + Integer.toString(day);
    if (startDate.length() == 10) {
        StringTokenizer startDateTokens = new StringTokenizer(startDate, "-" );
        if (startDateTokens.countTokens() == 3) {
            yearStr = startDateTokens.nextToken();
            monStr  = startDateTokens.nextToken();
            dayStr  = startDateTokens.nextToken();
        }
    }
    String upbuttonImg   = disabled.length() > 0 ? "upbuttondisabled.gif"   : "upbutton.gif";
    String downbuttonImg = disabled.length() > 0 ? "downbuttondisabled.gif" : "downbutton.gif";
%>

            <table border="0" cellspacing="0" role="presentation">
              <tr>
                <td colspan=6 class="table-text">
<% if (required.equals("true")) { %>
                <img id="requiredImage-datefield" src="images/attend.gif" width="8" height="8" align="absmiddle" title="<bean:message key="informationRequired"/>" alt="<bean:message key="informationRequired"/>">
<% } %>
                <bean:message key="startDate"/>
                </td>
              </tr>
              <tr>
                <td class="table-text">
                  <label for="startDateYear" title="<bean:message key="year"/>">
                  <input type="text" name="startDateYear" size=4" maxlength="4" value="<%=yearStr%>" class="noIndentTextEntry" style="margin-left: 0.6em;" id="startDateYear" <%=disabled%>>
                  </label>
                </td>
                <td>
                <table border="0" cellspacing="0" CELLPADDING="0" role="presentation">
                  <tr><td><img role="button" src="images/<%=upbuttonImg%>"   onmouseup="incYear()" onmousedown="document.images['startDateYearUp'].src='images/upbuttondown.gif'" id="startDateYearUp" <%=disabled%> alt="<bean:message key="incYear"/>"/></td></tr>
                  <tr><td><img role="button" src="images/<%=downbuttonImg%>" onmouseup="decYear(<%=yearStr%>)" onmousedown="document.images['startDateYearDown'].src='images/downbuttondown.gif'" id="startDateYearDown" <%=disabled%> alt="<bean:message key="decYear"/>"/></td></tr>
                </table>
                </td>
                <td class="table-text">-</td>
                <td  class="table-text">
                  <!--<label for="startDateMonth" title="<bean:message key="month"/>">-->
                  <SELECT NAME="startDateMonth" title="<bean:message key="month"/>" id ="startDateMonth" onchange="resetDay()" <%=disabled%>>
                    <OPTION VALUE="01">01</OPTION>
                    <OPTION VALUE="02">02</OPTION>
                    <OPTION VALUE="03">03</OPTION>
                    <OPTION VALUE="04">04</OPTION>
                    <OPTION VALUE="05">05</OPTION>
                    <OPTION VALUE="06">06</OPTION>
                    <OPTION VALUE="07">07</OPTION>
                    <OPTION VALUE="08">08</OPTION>
                    <OPTION VALUE="09">09</OPTION>
                    <OPTION VALUE="10">10</OPTION>
                    <OPTION VALUE="11">11</OPTION>
                    <OPTION VALUE="12">12</OPTION>
                  </SELECT>
                  </label>
                </td>
                <td class="table-text">-</td>
                <td  class="table-text">
                  <!--<label for="startDateDay" title="<bean:message key="day"/>">-->
                  <SELECT NAME="startDateDay" title="<bean:message key="day"/>" id ="startDateDay" <%=disabled%>>
                    <OPTION VALUE="01">01</OPTION>
                    <OPTION VALUE="02">02</OPTION>
                    <OPTION VALUE="03">03</OPTION>
                    <OPTION VALUE="04">04</OPTION>
                    <OPTION VALUE="05">05</OPTION>
                    <OPTION VALUE="06">06</OPTION>
                    <OPTION VALUE="07">07</OPTION>
                    <OPTION VALUE="08">08</OPTION>
                    <OPTION VALUE="09">09</OPTION>
                    <OPTION VALUE="10">10</OPTION>
                    <OPTION VALUE="11">11</OPTION>
                    <OPTION VALUE="12">12</OPTION>
                    <OPTION VALUE="13">13</OPTION>
                    <OPTION VALUE="14">14</OPTION>
                    <OPTION VALUE="15">15</OPTION>
                    <OPTION VALUE="16">16</OPTION>
                    <OPTION VALUE="17">17</OPTION>
                    <OPTION VALUE="18">18</OPTION>
                    <OPTION VALUE="19">19</OPTION>
                    <OPTION VALUE="20">20</OPTION>
                    <OPTION VALUE="21">21</OPTION>
                    <OPTION VALUE="22">22</OPTION>
                    <OPTION VALUE="23">23</OPTION>
                    <OPTION VALUE="24">24</OPTION>
                    <OPTION VALUE="25">25</OPTION>
                    <OPTION VALUE="26">26</OPTION>
                    <OPTION VALUE="27">27</OPTION>
                    <OPTION VALUE="28">28</OPTION>
                    <OPTION VALUE="29">29</OPTION>
                    <OPTION VALUE="30">30</OPTION>
                    <OPTION VALUE="31">31</OPTION>
                  </SELECT>
                  </label>
                </td>
              </tr>
            </table>

<script>
document.getElementById("startDateYear").value  = "<%=yearStr%>";
document.getElementById("startDateMonth").value = "<%=monStr%>";
document.getElementById("startDateDay").value   = "<%=dayStr%>";
resetDay();
</script>