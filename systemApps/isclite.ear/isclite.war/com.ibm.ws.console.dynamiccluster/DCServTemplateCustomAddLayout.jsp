<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*,java.util.regex.*,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.console.core.utils.RegExpHelper"%>

<%@ page import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page import="com.ibm.ws.console.core.Constants"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<ibmcommon:detectLocale/>

<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<% 	
    boolean val = false;
	if (readOnly != null && readOnly.equals("true"))
		val = true;
%>

   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="formAction" name="formAction" classname="java.lang.String"/>
   <tiles:useAttribute id="formType" name="formType" classname="java.lang.String"/>

   <bean:define id="bean" name="<%=formBean%>"/>
   <bean:define id="traceOptionValuesMap" name="<%=formBean%>" property="traceOptionValuesMap" type="java.util.List"/>
   <bean:define id="traceGroupsMap" name="<%=formBean%>" property="traceGroupsMap" type="java.util.HashMap"/>
   <bean:define id="selectedComponents" name="<%=formBean%>" property="selectedComponents" type="java.lang.String"/>
   <bean:define id="selectedComponentsRuntime" name="<%=formBean%>" property="selectedComponentsRuntime" type="java.lang.String"/>
   <bean:define id="perspective" name="<%=formBean%>" property="perspective" type="java.lang.String"/>

<%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);

        /////////////  Begin strings to be translated ////////////////////
        String groupsTabLabel = messages.getMessage(request.getLocale(),"trace.tree.groupsTabLabel");
        String componentsTabLabel = messages.getMessage(request.getLocale(),"trace.tree.componentsTabLabel");
        String message = messages.getMessage(request.getLocale(),"trace.tree.message");
%>

<td class="table-text"  scope="row" valign="top" nowrap>

    <% if (isRequired.equalsIgnoreCase("yes")) { %>
        <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
    <% } %>
    <FIELDSET>
    <LEGEND DESC="<bean:message key="<%=desc%>"/>">
    <bean:message key="<%=label%>"/>
    </LEGEND>

<STYLE>
TEXTAREA { font-size: 70%;width: 90% }
.wizard-tabs-off A { text-decoration: none; color: white }
.wizard-tabs-off A:hover { text-decoration: underline; }
.wizard-tabs-on { padding-left: 1em; border-right: 1px solid #708eb7; }
.wizard-tabs-off { padding-left: 1em; border-right: 1px solid #708eb7; }
IFRAME { margin-left:1em; margin-top: 1em; }
</STYLE>

<SCRIPT>
function changeTabs(view) {
    if (isDom) {
        showString = "table-row-group";
    } else {
        showString = "inline";
    }
    if (view == 1) {
        document.getElementById("loggingSettingsFrame").src = "com.ibm.ws.console.probdetermination/loggingSettingsComponents.jsp";
        document.getElementById("componentView").style.display = showString;
        document.getElementById("groupView").style.display = "none";
    } else {
        document.getElementById("loggingSettingsFrame").src = "com.ibm.ws.console.probdetermination/loggingSettingsGroups.jsp";
        document.getElementById("componentView").style.display = "none";
        document.getElementById("groupView").style.display = showString;
    }
}

document.write('<TABLE width="95%" cellpadding="0" cellspacing="0" class="wizard-table" ID="outterMostTable" STYLE="margin-top:.25em;margin-left:1.5em">');
document.write('  <TR>');
document.write('    <TD WIDTH="15%" VALIGN="top">');

document.write('        <TABLE width="100%" height="100%" cellpadding="8" cellspacing="0">');

document.write('            <TBODY ID="componentView" STYLE="display:inline">');

document.write('            <TR>');
document.write('            <TD CLASS="wizard-tabs-on" VALIGN="top" NOWRAP>');
document.write('              &nbsp;<%=componentsTabLabel%>');
document.write('            </TD>');
document.write('            </TR>');

document.write('            <TR>');
document.write('            <TD CLASS="wizard-tabs-off" VALIGN="top" NOWRAP>');
document.write('              &nbsp;<A HREF="javascript:changeTabs(2)"><%=groupsTabLabel%></A>');
document.write('            </TD>');
document.write('            </TR> ');

document.write('            </TBODY>');

document.write('            <TBODY ID="groupView" STYLE="display:none">');

document.write('            <TR>');
document.write('            <TD CLASS="wizard-tabs-off" VALIGN="top" NOWRAP>');
document.write('              &nbsp;<A HREF="javascript:changeTabs(1)"><%=componentsTabLabel%></A>');
document.write('            </TD>');
document.write('            </TR>');
document.write('            <TR>');
document.write('            <TD CLASS="wizard-tabs-on" VALIGN="top" NOWRAP>');
document.write('              &nbsp;<%=groupsTabLabel%>');
document.write('            </TD>');
document.write('            </TR> ');

document.write('            </TBODY>');

document.write('            </TABLE>');

document.write('         </TD>');

document.write('        <td CLASS="not-highlighted">');

</SCRIPT>

<BR>
<LABEL FOR="selectedComponents" TITLE=<bean:message key="logging.spec.textArea"/>>

<%
    if (perspective.equalsIgnoreCase("tab.runtime")){
    session.setAttribute("selectedComponentsRuntime", selectedComponentsRuntime);
    session.removeAttribute("selectedComponents");
%>
    <html:textarea styleId="selectedComponents" property="selectedComponentsRuntime" name="<%=formBean%>" value="<%=selectedComponentsRuntime.replaceAll(\":\", \": \")%>" rows="5" disabled="<%=val%>"/>
<%
    } else {
    session.setAttribute("selectedComponents", selectedComponents);
    session.removeAttribute("selectedComponentsRuntime");
%>
    <html:textarea styleId="selectedComponents" property="selectedComponents" name="<%=formBean%>" value="<%=selectedComponents.replaceAll(\":\", \": \")%>" rows="5" cols="20" disabled="<%=val%>"/>
<%
    }
%>

</LABEL>

<BR>

<%
  session.setAttribute("traceOptionValuesMap", traceOptionValuesMap);
  session.setAttribute("traceGroupsMap", traceGroupsMap);
%>

<SCRIPT>

document.write('        <IFRAME SRC="com.ibm.ws.console.probdetermination/loggingSettingsComponents.jsp" WIDTH="95%" HEIGHT="500" ID="loggingSettingsFrame" frameborder="0" ></IFRAME>');

document.write('        </TD>');
document.write('    </TR>');

document.write('</TABLE>');
</SCRIPT>

    </FIELDSET>

</td>
