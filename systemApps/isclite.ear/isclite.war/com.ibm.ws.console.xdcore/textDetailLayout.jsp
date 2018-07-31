<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.item.PropertyItem" %>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>
<% List attributeList = (List)request.getSession().getAttribute("attributeList"); %>
   
    <%if (includeTD == null || includeTD.equals("true")) {%>
        <td class="table-text" valign="top">
    <%}%>
    
	<div style="display:table;">
	<logic:iterate id="propertyItem" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
	  <div style="display:table-row;">
	    <div style="display:table-cell; padding-right:10px;" class="table-text">
		  <% if (propertyItem.getType().equalsIgnoreCase("html")){ %>
	      	<label title="<bean:message key="<%=propertyItem.getDescription()%>"/>">
		  <% } else if (propertyItem.getType().equalsIgnoreCase("icon")) { %>
		  	<label title="<bean:message key="<%=propertyItem.getDescription()%>"/>">
		  <% } else {%>
	      	<label title="<bean:message key="<%=propertyItem.getDescription()%>"/>">
         <% } %>
		    <bean:message key="<%=propertyItem.getLabel()%>" />
	      </label>
 	    </div>
	    <div style="display:table-cell;" class="table-text">
	      <% //System.out.println("textDetailLayout.jsp:attribute: "+propertyItem.getAttribute()); %>
	      <% if (propertyItem.getType().equalsIgnoreCase("label")) { %>
			<i><span style="color:gray"><bean:message key="<%=propertyItem.getAttribute()%>" /></span></i>
	      <% } else if (propertyItem.getType().equalsIgnoreCase("icon")) { %>
							<img id="<bean:message key='<%=propertyItem.getAttribute()%>'/>Img" 
								src="<%=request.getContextPath()+propertyItem.getRequired()%>"
								title="<bean:message key='<%=propertyItem.getAttribute()%>'/>" 
								alt="<bean:message key='<%=propertyItem.getAttribute()%>'/>" 
								border="0" 
								align="texttop">
	      <% }else if (propertyItem.getType().equalsIgnoreCase("html")) { %>
			<%=propertyItem.getAttribute()%>
	      <% } else { %>
			<i><span style="color:gray"><%=propertyItem.getAttribute()%></span></i>
	      <% } %>
	    </div>
	  </div>
	</logic:iterate>
	</div>
	
    <%if (includeTD == null || includeTD.equals("true")){%>
        </td>
    <%}%>
