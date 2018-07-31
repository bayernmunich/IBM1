<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page language="java" import="java.util.*"%>

<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page language="java" import="org.apache.struts.action.Action"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>

<%@ page language="java" import="com.ibm.ws.console.core.item.PropertyItem"%>

<!-- [REQUIRED] description description porlet content -->
<tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>

<!--  -->
<% List attributeList = (List)request.getSession().getAttribute(com.ibm.ws.console.xdoperations.util.Constants.KEY_REQUEST_MANAGEMENT); %>

<table role="presentation">
  <tr>
  	<td class="table-text">
  		<label for="<%=desc%>"><bean:message key="<%=desc%>" /></label>
  	</td>
  </tr>
  <tr>
    <td class="table-text">
	  <select name="<%=desc%>" size="4" id="<%=desc%>">
	    <logic:iterate id="attributeItem" name="<%=com.ibm.ws.console.xdoperations.util.Constants.KEY_REQUEST_MANAGEMENT%>" type="java.lang.String">
  		  <option value="<%=attributeItem%>"><%=attributeItem%></option>
	    </logic:iterate>
	  
	    <% if (attributeList.size() == 0 ) { 
	      ServletContext servletContext = (ServletContext)pageContext.getServletContext();
	      MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
	      String nonefound = messages.getMessage(request.getLocale(),"Persistence.none"); %>
	      <option value="<%=nonefound%>"><%=nonefound%></option>
	    <% } %>
	  </select>
    </td>
  </tr>
</table>