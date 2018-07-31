<%@ page import="com.ibm.ws.security.core.SecurityContext" errorPage="/errors/error.jsp" %>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="numOfColumns" classname="java.lang.String"/>

<%
  boolean isAdmin = true;
  if (SecurityContext.isSecurityEnabled() && !request.isUserInRole("lradmin"))
     isAdmin = false;
%>

<% if (isAdmin) { %>
    <!-- Action section -->
    <tr valign="top">
      <td class="function-button-section"  nowrap COLSPAN="<%=numOfColumns%>">
      <table BORDER="0" CELLPADDING="0" CELLSPACING="0" role="presentation">
        <tr>
          <td class="action-button-section"  nowrap >
            <input type="submit" name="button.delete"     value="<bean:message key="button.delete"/>"   class="filter-buttons" id="button.delete"/>
          </td>
        </tr>
      </table>
      </td>        
    </tr>
    <!-- End of Action section -->
<% } %>
