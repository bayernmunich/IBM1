<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.MiddlewareAppsDetailForm" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>
<%@ page language="java" import="com.ibm.ws.console.middlewareapps.util.*" %>

<tiles:useAttribute id="list" name="list" classname="java.util.List" />
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
<!-- configTabLayout.jsp -->
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" CELLSPACING="10" role="presentation">

<%
	MiddlewareAppsDetailForm theForm = (MiddlewareAppsDetailForm) session.getAttribute(formName);
	String typekey = theForm.getTypeKey();
	//String typekey = "middlewareapps.type.wasce";
%>

<%
    boolean itsother = false;
    Iterator i = list.iterator();

    while (i.hasNext()) {
        String name = (String) i.next();
        if ((name.indexOf("buttons.panel") > -1) || (name.indexOf("context.scope") > -1)) {
%>
    <TR>
        <TD VALIGN="top" COLSPAN="2">
            <tiles:insert name="<%=name%>" flush="true" />
        </TD>
    </TR>

<%
        } else if (name.indexOf("deployment.properties") > -1) {
%>
	<TR>
        <TD VALIGN="top" COLSPAN="2">
            <tiles:insert name="<%=name%>" flush="true" />
        </TD>
    </TR>

<%
        } else if ((name.indexOf("general.properties") > -1) || (name.indexOf("generic.properties") > -1) || (name.indexOf("collection.table.extends") > -1)) {
%>

    <TR>
        <TD VALIGN="top">
            <tiles:insert name="<%=name%>" flush="true" />
        </TD>

        <TD VALIGN="top">
<%
        } else {
        	if(!typekey.equals("middlewareapps.type.wasce")){
%>
	           <tiles:insert name="<%=name%>" flush="true" />
<%
        	}
            itsother = true;
        }
    } // End While

    if (itsother) {
%>
        </TD>
<%
    }
%>
    </TR>

</TABLE>

</html:form>
