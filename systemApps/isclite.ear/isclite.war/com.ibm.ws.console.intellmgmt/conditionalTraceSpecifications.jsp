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
  .treebranch { padding-left:32px; }
</style>

<script src="<%=request.getContextPath()%>/com.ibm.ws.console.intellmgmt/scripts/tree_functions.js"></script>

<%
TraceSpecDetailForm detailForm = (TraceSpecDetailForm) session.getAttribute("com.ibm.ws.console.intellmgmt.form.TraceSpecDetailForm");
Boolean disabled = !detailForm.getEnabled();
List traceSpecs = detailForm.getTraceSpecs();
TraceSpecTree condTree = null;
for (int i = 0; i < traceSpecs.size(); i++) {
	TraceSpecTree curr = (TraceSpecTree)traceSpecs.get(i);
	if (curr.getFullSpec().equalsIgnoreCase("http")) {
		condTree = curr;
	}
}
%>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr valign="top"> 
	  	<td class="table-text" nowrap valign="top">	        
			<tiles:insert page="/com.ibm.ws.console.intellmgmt/requestEditLayout.jsp" flush="false">
				<tiles:put name="actionForm" value="com.ibm.ws.console.intellmgmt.form.TraceSpecDetailForm" />
				<tiles:put name="label" value="intellmgmt.tracespec.condition.textarea" />
				<tiles:put name="desc" value="intellmgmt.tracespec.condition.desc" />
				<tiles:put name="hideValidate" value="true" />
				<tiles:put name="hideRuleAction" value="true" />
				<tiles:put name="rule" value="requestFilter" />
				<tiles:put name="rowindex" value="" />
				<tiles:put name="refId" value="" />
				<tiles:put name="ruleActionContext" value="service" />
				<tiles:put name="template" value="service" />
				<tiles:put name="quickHelpTopic" value="uwve_tracerulebuilder.html" />
				<tiles:put name="quickPluginId" value="com.ibm.ws.console.intellmgmt" />
			</tiles:insert>
		</td>
	</tr>
	
	<tr>
		<td class="instruction-text">
			<label for="conditionalTraceStr" style="margin-left: 0em; cursor: help;" title="<bean:message key="intellmgmt.tracespec.tracespec"/>">
				<bean:message key="intellmgmt.tracespec.condtrace.instr"/>
			</label>
		</td>
	</tr>
	<tr>
		<td class="table-text" nowrap>
    		<html:textarea property="conditionalTraceStr" styleId="conditionalTraceStr" styleClass="textEntry" style="width:90%;" disabled="<%=disabled %>"/>
		</td>
	</tr>
	
  <% if (condTree != null) { %> 
	<tr>
	  	<td class="table-text" nowrap>
			<tiles:insert page="/com.ibm.ws.console.intellmgmt/traceNode.jsp" flush="false">
				<tiles:put name="type" value="cond" />
				<tiles:put name="countStr" value="1" />
				<tiles:put name="disabled" value="<%=disabled %>" />
				<tiles:put name="tree" value="<%=condTree%>" />
			</tiles:insert>
		</td>
	</tr>
  <% } %>
</table>

<tiles:insert page="/com.ibm.ws.console.intellmgmt/levelMenu.jsp" flush="false">
	<tiles:put name="scope" value="cond" />
	<tiles:put name="currTraceText" value="conditionalTraceStr" />
</tiles:insert>
