<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>                    
   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="size" name="size" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>   
   
   <bean:define id="propertyValue"    name="<%=formBean%>" property="<%=property%>" type="java.lang.String"/>

	<%   String checkboxID = property + "Checked";  %>
   <bean:define id="checkboxValue"    name="<%=formBean%>" property="<%=checkboxID%>" type="java.lang.Boolean"/>
<td class="table-text"  scope="row" valign="top" nowrap >       	                                
      
        <% if ((!checkboxValue.booleanValue()) && propertyValue.equals("0")) { %>
        	<label  for="<%= property%>" title="<%= property%>">
        	<html:text property="<%=property%>" name="<%=formBean%>" size="30" style="background-color: #E0E0E0;" styleClass="textEntry" styleId="<%=property%>" value="" disabled="true"/>
        	</label>
         	
    	<% } else { %>
    		<label  for="<%= property%>" title="<%= property%>">
   		<html:text property="<%=property%>" name="<%=formBean%>" size="30" style="background-color: #FFFFFF;" styleClass="textEntry" styleId="<%=property%>" />
    		</label>
    	<% }  %>
    	<% if (units != null && !units.equals(" ") && !units.equals("")) { %> 	
    	&nbsp;
		<bean:message key="<%=units%>"/> 
    	<% } %>
   </td>
