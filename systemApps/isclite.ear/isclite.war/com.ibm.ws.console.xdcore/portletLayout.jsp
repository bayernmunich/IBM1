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

<%@ page import="java.util.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>

<!-- label for drop down menu -->
<tiles:useAttribute id="label" name="label" classname="java.lang.String"/>

<!-- label description for drop down menu -->
<tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>

<!-- label description for drop down menu -->
<tiles:useAttribute id="tiledefinition" name="tiledefinition" classname="java.lang.String"/>

<!-- [OPTIONAL] Type of tile defintion { "name", "page" } -->
<tiles:useAttribute id="tileDefinitionType" name="tileDefinitionType" ignore="true" classname="java.lang.String"/>

<!-- [OPTIONAL] Is the label attribute a nls key or not { "true", "false" } -->
<tiles:useAttribute id="isLabelNLSKey" name="isLabelNLSKey" ignore="true" classname="java.lang.String"/>

<!-- [OPTIONAL] Fieldset around rule text and description -->
<tiles:useAttribute id="refreshLink" name="refreshLink" ignore="true" classname="java.lang.String"/>

<!-- [OPTIONAL] Fieldset around rule text and description -->
<tiles:useAttribute id="isSubTab" name="isSubTab" ignore="true" classname="java.lang.String"/>

<%
   if (isSubTab == null) { isSubTab = "false"; } 
   if (isLabelNLSKey == null) { isLabelNLSKey = "true"; } 
   if (tileDefinitionType == null) { tileDefinitionType = "name"; } 
%>

<table width="40%" cellpadding="0" cellspacing="0" border="0" class="wasPortlet" role="presentation">
  		<tr>
    		<td class="wpsPortletTitle">
    			<% if (isLabelNLSKey.equals("true")) { %>
      				<label title="<bean:message key="<%=desc%>"/>">
	        			<b><bean:message key="<%=label%>"/></b>
      				</label>
    			<% } else { %>
      				<label title="<%=label%>">
      					<b><%=label%></b>
      				</label>
    			<% } %>
			</td>
    		<td class="wpsPortletTitleControls">
          		<% if (refreshLink != null && !refreshLink.equals("") && !refreshLink.equals(" ")) { %>
          			<% if (isSubTab.equals("true")) { %>
		          		<a href="javascript:switchTab()">
		              		<img src="/ibm/console/images/refresh.gif" alt="<bean:message key="refresh" />" title="<bean:message key="refresh" />" align="texttop" border="0"/></a>
		          		</a>
		        	<% } else { %>
		          		<a href="/ibm/console/<%=refreshLink%>">
		              		<img src="/ibm/console/images/refresh.gif" alt="<bean:message key="refresh" />" title="<bean:message key="refresh" />" align="texttop" border="0"/></a>
		          		</a>		        
		       		 <% } %>
          		<% } %>
          		<a href="javascript:showHidePortlet('<%=label%><%=tiledefinition%>')">
              		<img id="<%=label%><%=tiledefinition%>Img" SRC="/ibm/console/images/title_minimize.gif" alt="<bean:message key="wsc.expand.collapse.alt" />" title="<bean:message key="wsc.expand.collapse.alt" />" border="0" align="texttop"/>
          		</a>
    		</td>
  		</tr>
  
  	<tbody id="<%=label%><%=tiledefinition%>">
  		<tr>
    		<td class="wpsPortletArea" colspan="2">
    			<% if (tileDefinitionType.equals("page")) { %>
      				<tiles:insert page="<%=tiledefinition%>" flush="false" />    
    			<% } else { %>
       				<tiles:insert name="<%=tiledefinition%>" flush="true" />
    			<% } %>
			</td>
  		</tr>
	</tbody>
</table>  
<br/>