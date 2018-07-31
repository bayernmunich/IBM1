<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.console.intellmgmt.utils.TraceSpecTree"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="type" name="type" classname="java.lang.String"/>
<tiles:useAttribute id="countStr" name="countStr" classname="java.lang.String"/>
<tiles:useAttribute id="disabled" name="disabled" classname="java.lang.Boolean"/>
<tiles:useAttribute id="tree" name="tree" classname="com.ibm.ws.console.intellmgmt.utils.TraceSpecTree"/>

<div id="<%="item_" + type + "_" + countStr %>" class="table-text">
 <% if (tree.getChildren() != null && tree.getChildren().size() > 0) { %>
	<a onclick="openClose('<%=type + "_" + countStr %>'); return false;" href="#">
		<img id="<%="pm_" + type + "_" + countStr %>" width="16" height="16" name="<%="pm_" + type + "_" + countStr %>" 
			 src="/ibm/console/images/lplus.gif" alt="<bean:message key="intellmgmt.tracespec.expandcollapse"/>">
	</a>
  <% } else { %>
  	<img width="16" height="1" src="/ibm/console/images/onepix.gif" alt="">
  <% } %>
	
	<% if (disabled) { %>
		<%=tree.getPartialSpec() %>
	<% } else { %>
	<a id="<%=type + "_" + tree.getFullSpec() %>" name="treeitem" href="#" onclick="openLevels(event, '<%=tree.getFullSpec()%>', '<%=type %>', '<%=tree.getLevel() %>', '<%=tree.getDefaultLevel() %>'); return false; ">
		<%=tree.getPartialSpec() %>
	</a>
	<% } %>
	
	<% if (tree.getChildren() != null && tree.getChildren().size() > 0) { %>
		<div id="<%="branch_" + type + "_" + countStr %>" class="treebranch" style="display:none;">
    <% } %>
    
    <% for(int i = 0; i < tree.getChildren().size(); i++) { %>
		<% 
		TraceSpecTree child = (TraceSpecTree)tree.getChildren().get(i); 
		String updatedCountStr = countStr + "." + i;
		%>
		<tiles:insert page="/com.ibm.ws.console.intellmgmt/traceNode.jsp" flush="false">
			<tiles:put name="type" value="<%=type %>" />
			<tiles:put name="countStr" value="<%=updatedCountStr %>" />
			<tiles:put name="disabled" value="<%=disabled %>" />
			<tiles:put name="tree" value="<%=child %>" />
		</tiles:insert>
	<% } %>
    
    <% if (tree.getChildren() != null && tree.getChildren().size() > 0) { %>
		</div>
  	<% } %>
</div>
