<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page  errorPage="/error.jsp" %>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="showCheckBoxes" name="showCheckBoxes" classname="java.lang.String" />
<tiles:useAttribute id="formName" name="formName" classname="java.lang.String" />

<% String contextType = (String)request.getAttribute("contextType"); %>
<table class="button-section" border="0" cellpadding="3" cellspacing="0" valign="top" width="100%">
  <tr valign="top">
    <td class="function-button-section"  nowrap>
      <table border="0" cellpadding="0" cellspacing="0" valign="top" role="presentation">
        <tr>
        <% if (showCheckBoxes.equals ("true")) { %>
          <td>
            <A id="selectAllButton" HREF="javascript:iscSelectAll('<%=formName%>')" CLASS="expand-task">
              <IMG id="selectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_select_all.gif" ALT='<bean:message key="select.all.items"/>' title='<bean:message key="select.all.items"/>' BORDER="0" ALIGN="texttop"> 
            </A>
          </td>
          <td>
            <A id="deselectAllButton" HREF="javascript:iscDeselectAll('<%=formName%>')" CLASS="expand-task">
              <IMG id="deselectAllImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_deselect_all.gif" ALT='<bean:message key="deselect.all.items"/>' title='<bean:message key="deselect.all.items"/>' BORDER="0" ALIGN="texttop"> 
            </A>  
          </td>
        <% } %>
		  <td>
            <A HREF="javascript:showHideFilter<%=contextType%>()" CLASS="expand-task">
              <IMG id="filterTableImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_filter_row_show.gif" ALT='<bean:message key="show.filter"/>' title='<bean:message key="show.filter"/>' BORDER="0" ALIGN="texttop"> 
            </A>
          </td>
          <td>
            <A HREF="javascript:clearFilter<%=contextType%>('<%=formName%>')" CLASS="expand-task">
              <IMG  id="clearFilterImg" align="top" SRC="<%=request.getContextPath()%>/images/wtable_clear_filters.gif" ALT='<bean:message key="clear.filter.value"/>' title='<bean:message key="clear.filter.value"/>' BORDER="0" ALIGN="texttop"/> 
            </A>
          </td>
        </tr>
      </table>
    </td>        
  </tr>
</table>