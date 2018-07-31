<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="com.ibm.ws.console.core.item.PropertyItem" %>
<%@ page import="com.ibm.ws.console.xdoperations.util.Constants" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute name="messageLegend" classname="java.lang.String" />

<!--  -->
<% List messageList = (List)request.getSession().getAttribute(com.ibm.ws.console.xdoperations.util.Constants.MESSAGELIST_SESSION_KEY); %>

<% if (messageList.size() > 0) { %>
<center>
  <table valign="top" width="60%">
    <tr>
      <td class="complex-property">
		<fieldset id="<bean:message key="<%=messageLegend%>" />">
			<legend for ='<bean:message key="<%=messageLegend%>" />' title='<bean:message key="<%=messageLegend%>" />'>
				<bean:message key="<%=messageLegend%>" />
			</legend>
			 <% for (Iterator i = messageList.iterator(); i.hasNext();) {
					PropertyItem propertyItem = (PropertyItem)i.next(); %>
					&nbsp;
					<span class='<%=propertyItem.getUnits() %>'>
						<img align="baseline" height="16" width="16" 
							src="<%=request.getContextPath()%><%=propertyItem.getLegend()%>" />
						<!-- Message format: "resourceType resourceName: message" -->
						<bean:message key="<%=propertyItem.getLabel()%>" /> 
						<b><%=propertyItem.getAttribute()%></b>: <%=propertyItem.getDescription()%>
					</span>
				<%	if (i.hasNext()) { %>
					<br />
				<%  }
			   } //end for loop %>
		</fieldset>
	  </td>
    </tr>
  </table>
</center>
<% } %>