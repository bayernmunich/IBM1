<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.*" %>
<%@ page import="com.ibm.wsspi.*" %>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.*" %>
<%@ page import="com.ibm.websphere.management.metadata.*" %>
<%@ page import="com.ibm.ws.sm.workspace.RepositoryContext" %>
<%@ page import="com.ibm.ws.console.core.Constants" %>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.*" %>
<%@ page import="com.ibm.ws.console.core.utils.VersionHelper" %>
<%@ page import="org.apache.struts.util.MessageResources" %>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<%
    // XXX: Should code to Interface!
    MiddlewareDescriptorDetailForm theForm = (MiddlewareDescriptorDetailForm)session.getAttribute("MiddlewareDescriptorDetailForm");
    String contextType=(String)request.getAttribute("contextType");
	String contextId = (String)request.getAttribute("contextId");
	String perspective = (String)request.getAttribute("perspective");
    System.out.println("MiddlewareDescriptor Name:" + theForm.getName());
    System.out.println("MiddlewareDescriptor actionForm:" + actionForm);
%>

<table border="0" cellpadding="5" cellspacing="0" width="100%" summary="List Table">
    <tr>
        <td>
	      <table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
	        <tr> 
	          <th class="column-head-name" scope="col" >
	            <bean:message key="Node.version.displayName"/>
	          </th>

	        </tr>

<%
    String target = "";

	
	List column0 = theForm.getVersionDescriptors();

	for (int i=0; i < column0.size(); i++) {
        target ="";
        System.out.println("Value: "+column0.get(i));      
        
%>

<tr class="table-row"> 
    <% 
    String hRef = theForm.getLink() + "&refId="+ column0.get(i) +"&contextId=" + contextId + "&platform=" + theForm.getName() + "&perspective=" + perspective;
    System.out.println("jsp refId =" + column0.get(i));
    %>
   <td class="collection-table-text"><A HREF="<%=hRef%>"><%=column0.get(i)%> </A>
      
   </td>
</tr>

<%
    }

    // Column Size is Null.
    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
    MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
    if (column0.size() == 0) {
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        // out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
        out.println("<tr class='table-row'><td colspan='5'>"+nonefound+"</td></tr>");
	}
%>

      </table>
    </td>
  </tr>
</table>

