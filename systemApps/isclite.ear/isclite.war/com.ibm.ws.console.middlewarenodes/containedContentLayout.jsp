<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.error.*"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>


<tiles:useAttribute name="contentList" classname="java.util.List" />

<tiles:useAttribute id="contextType" name="contextType" classname="java.lang.String" />
<% request.setAttribute("contextType",contextType);%>

<TR>
<TD>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="10" WIDTH="100%" SUMMARY="List layout table">

	<TBODY>
		<TR>
			<TD >

    <tiles:insert page="/secure/layouts/vboxLayout.jsp" flush="true">
        <tiles:put name="list" beanName="contentList" beanScope="page"/>
    </tiles:insert>
    
                        </TD>
               </TR>
        </TBODY>
</TABLE>


 
