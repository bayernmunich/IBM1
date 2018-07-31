<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.xd.config.intellmgmt.utils.IntellMgmtConstants" %>
<%@ page import="com.ibm.ws.console.intellmgmt.form.TraceSpecDetailForm"%>
<%@ page import="com.ibm.ws.console.intellmgmt.utils.TraceSpecTree"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<style type="text/css">
  A { text-decoration: none; }
  IMG { text-align: left; vertical-align: bottom; border: 0px; }
</style>

<script src="<%=request.getContextPath()%>/com.ibm.ws.console.intellmgmt/scripts/tree_functions.js"></script>

<%
TraceSpecDetailForm detailForm = (TraceSpecDetailForm) session.getAttribute("com.ibm.ws.console.intellmgmt.form.TraceSpecDetailForm");
Boolean disabled = !detailForm.getEnabled();
List traceSpecs = detailForm.getTraceSpecs();
%>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
	  	<td class="instruction-text">
			<label for="traceStr" style="margin-left: 0em; cursor: help;" title="<bean:message key="intellmgmt.tracespec.tracespec"/>">
				<bean:message key="intellmgmt.tracespec.trace.instr"/>
			</label>
		</td>
	</tr>
	
	<tr>
		<td class="table-text" nowrap>
    		<html:textarea property="traceStr" styleId="traceStr" styleClass="textEntry" style="width:90%;" disabled="<%=disabled %>"/>
		</td>
	</tr>
	
  <% for (int i = 0; i < traceSpecs.size(); i++) { %>
  <% TraceSpecTree currTree = (TraceSpecTree) traceSpecs.get(i); %>
  <% String countStr = "" + i; %>
	<tr> 
	  	<td class="table-text" nowrap>
			<tiles:insert page="/com.ibm.ws.console.intellmgmt/traceNode.jsp" flush="false">
				<tiles:put name="type" value="<%=IntellMgmtConstants.TRACE_DEFAULT_RULE_NAME %>" />
				<tiles:put name="countStr" value="<%=countStr %>" />
				<tiles:put name="disabled" value="<%=disabled %>" />
				<tiles:put name="tree" value="<%=currTree %>" />
			</tiles:insert>
		</td>
	</tr>
  <% } %>
</table>

<tiles:insert page="/com.ibm.ws.console.intellmgmt/levelMenu.jsp" flush="false">
	<tiles:put name="scope" value="<%=IntellMgmtConstants.TRACE_DEFAULT_RULE_NAME %>" />
	<tiles:put name="currTraceText" value="traceStr" />
</tiles:insert>
