<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp. 1997, 2004, 2005  --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>   

<%@ page language="java" import="com.ibm.ws.console.appmanagement.*, com.ibm.ws.console.appmanagement.form.* , com.ibm.ws.console.servermanagement.wizard.*,com.ibm.ws.console.phpserver.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<SCRIPT>
// Added because Mozilla wants to use the TBODY and table-row-group to show/hide table rows
if (isDom) {
    showString = "table-row-group";
} else {
    showString = "inline";
}
function showHideFilter() {
// alert("In showhide");
 if (document.getElementById("filterTableImg").src.indexOf("wtable_filter_row_show") > 0) {
        disFilter = showString;
        document.getElementById("filterTableImg").src = "<%=request.getContextPath()%>/images/wtable_filter_row_hide.gif";
    } else {
        document.getElementById("filterTableImg").src = "<%=request.getContextPath()%>/images/wtable_filter_row_show.gif";
        disFilter = "none";
    }
    document.getElementById("filterControls").style.display = disFilter;
}
function clearFilter() {
 //alert("In clear filter");
    document.getElementById("searchFilter").value = "";
    document.getElementById("searchPattern").value = "*";
    document.getElementById("searchAction").click();
 
}
</SCRIPT>

<DIV style="overflow:auto"/>

<tiles:useAttribute name="actionForm" classname="java.lang.String" /> 
<%-- Comment out filter control
<table CLASS="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Generic funtions for the table, such as content filtering">
<tr valign="top">
<td class="function-button-section"  nowrap>
<A HREF="javascript:showHideFilter()" CLASS="expand-task">
    <IMG id="filterTableImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_filter_row_show.gif" ALT="Show/hide filter" BORDER="0" ALIGN="texttop"> 
</A>
<A HREF="javascript:clearFilter()" CLASS="expand-task">
    <IMG id="clearFilterImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_clear_filters.gif" ALT="Clear filter value" BORDER="0" ALIGN="texttop"> 
</A>       
</td>        
</tr>


<TBODY ID="filterControls" STYLE="display:none">
            <TR  width="100%">
            <TD CLASS="column-filter-expanded" COLSPAN=4>
            <BR><bean:message key="quick.search.search.in.label"/><BR>
            <html:select name="<%=actionForm%>" property="searchFilter" styleId="searchFilter">
            				
            				<html:option value="name"><bean:message key="phpserver.selectphpservertemplate.name"/></html:option>
            
            				<html:option value="version"><bean:message key="phpserver.selectphpservertemplate.version"/></html:option>
            
            				<html:option value="path"><bean:message key="phpserver.selectphpservertemplate.path"/></html:option>
            		
			</html:select>            
            <html:text name="<%=actionForm%>" styleClass="noIndentTextEntry" property="searchPattern" styleId="searchPattern"/>
            <INPUT TYPE="submit" NAME="searchAction" ID="searchAction" VALUE="<bean:message key="button.go"/>" CLASS="buttons-filter">
            <br><BR>
            </TD> 
            </TR>
</TBODY>
</table>
--%>
<fieldset style="border:0px; padding:0pt; margin: 0pt;">
	<legend class="hidden"><bean:message key="phpserver.new.step2"/></legend>
<table border="0" cellpadding="3" cellspacing="1" width="100%" class="framing-table">
	<logic:equal name="<%=actionForm%>" property="showDefault" value="true">
<tr>
<TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
	<bean:message key="select.text"/>
</TH>
<TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  ID="name">
<bean:message key="phpserver.selectphpservertemplate.name"/>
</TH>
<TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  ID="type">
<bean:message key="phpserver.selectphpservertemplate.version"/>
</TH>
<TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  ID="description">
<bean:message key="phpserver.selectphpservertemplate.path"/>
</TH>
</tr>

<logic:iterate id="temp1" name="<%=actionForm%>" property="listServerRuntime" indexId="idx">
<% 
SelectPHPServerRuntimeForm serverRuntimeForm = (SelectPHPServerRuntimeForm) temp1; 
String namePHPServer     = serverRuntimeForm.getNamePHPServer();   
String phpServerVersion  = serverRuntimeForm.getPHPServerVersion();
String phpServerLocation = serverRuntimeForm.getPHPServerLocation(); 
String displayName = serverRuntimeForm.getDisplayName();
String displayVersion = serverRuntimeForm.getDisplayVersion();
String radioId = "select" + idx.intValue();
%>

<TR CLASS="table-row">
<td class="collection-table-text"  width="1%">
<label class="collectionLabel" for="<%=radioId%>" title="<bean:message key="select.text"/> <%=displayName%>">
	<html:radio name="<%=actionForm%>" property="namePHPServer" value="<%=displayName%>" styleId="<%=radioId %>"/>
</label>
</td>
<td>
<%=displayName%>
</td>
<td>
<%= displayVersion %>
</td>
<td>
<%= phpServerLocation %>
</td>
</TR>
</logic:iterate>
</logic:equal>
</table>
</fieldset>                    
                        
