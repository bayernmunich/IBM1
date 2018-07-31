<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="com.ibm.ws.console.xdoperations.util.Message" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute name="messageLegend" classname="java.lang.String" />

<style type="text/css">
.validation-error {
    color: #CC0000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-warn-info {
    color: #000000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-header { 
    color: #FFFFFF; background-color:#6B7A92; font-family: Verdana, sans-serif;
    font-weight:bold; 
    font-size: 65.0% 
}
.msg-text {   font-family: Verdana, sans-serif; font-size:65.0%;  
    background-image: none; 
}
.opsMessagePortlet {
    background-color: #F7F7F7; border: 1px solid #88a4d7;
}
.opsMessageTitle {
    FONT-SIZE: 65.0%;
    /*background-color:#DCDFEF;*/
}
.opsComplex-property { 
    font-family: Verdana,Helvetica, sans-serif; 
    font-size:65.0%; 
    padding-left: 2.5em;  
}



</style>
<!--  -->
<%
	com.ibm.ws.console.xdoperations.detail.summary.CoreComponentSummaryDetailForm detailForm = (com.ibm.ws.console.xdoperations.detail.summary.CoreComponentSummaryDetailForm)session.getAttribute("com.ibm.ws.console.xdoperations.detail.summary.CoreComponentSummaryDetailForm");
	List messages = null;
	if (detailForm!=null){
	    messages = detailForm.getMessageList();
	}
%>
<table role="presentation">
<tr>
<td >
<FIELDSET id="compMessages">
	<LEGEND for="compMessages" class="msg-text" TITLE="<bean:message key="<%=messageLegend%>"/>">
                 <bean:message key="<%=messageLegend%>"/>
	</LEGEND>
  <table id="comp_message_table" style="min-width:90%;max-width:90%" border="0" cellpadding="0" cellspacing="0" valign="top" width="90%" summary="Operations Messages">
	<tr>
	<td>
	<div class="msg-text">
	<% 
		if (messages!=null){
			for (Iterator i = messages.iterator(); i.hasNext();) { 
				Message msg = (Message)i.next();
	%>
		<span class="<%=msg.getSpanClass()%>">
		<img align="baseline" height="16" width="16" src="<%=request.getContextPath()+msg.getIcon()%>" />
		<%=msg.getMessage()%>
		</span>
		<% if (i.hasNext()){ %>
		</br>
	<% 		} 
		}%>
	<% } %>
	</div>
	</td>
	</tr>
	</table>
</FIELDSET>
</td>
</tr>
</table>




