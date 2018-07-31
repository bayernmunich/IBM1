<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator,com.ibm.ws.console.core.item.ActionSetItem,com.ibm.ws.security.core.SecurityContext"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


<tiles:useAttribute name="definitionName" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" ignore="true"/>

<%

String contextType = (String)request.getAttribute("contextType");
String contextId   = (String)request.getAttribute("contextId");
String perspective = (String)request.getAttribute("perspective");
String formAction  = (String)request.getAttribute("formAction");

%>
       
<%-- set this to true will show the button to save on the endpoint panel
boolean showButtons = true;
--%>
<%-- Disable the showButton in feature pack because we don't allow option to change --%>
<%
boolean showButtons = false;
if (SecurityContext.isSecurityEnabled() && !(request.isUserInRole("administrator") || request.isUserInRole("configurator"))) {
    showButtons = false;
}

if (showButtons) {
%>

    <table border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Framing Table" CLASS="button-section">
      <tr valign="top">
        <td class="table-button-section" colspan=8> 
          <input type="submit" name="button.execute" value="<bean:message key="gridscheduler.gee.setjndiname"/>" class="buttons" id="functions"/>
          <input type="hidden" name="definitionName" value="<%=definitionName%>"/>
          <input type="hidden" name="buttoncontextType" value="<%=contextType%>"/>
          <input type="hidden" name="buttoncontextId" value="<%=contextId%>"/>
          <input type="hidden" name="buttonperspective" value="<%=perspective%>"/> 
          <input type="hidden" name="formAction" value="<%=formAction%>"/>  
        </td>
      </tr>
      
    </table>
<%
    }
%>