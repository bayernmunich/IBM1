<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.xd.operations.impl.*"%>
<%@ page language="java" import="com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>


   <bean:define id="bean" name="<%=formBean%>"/>
   <bean:define id="isImpDisabled" property="impDisabled" name="<%=formBean%>"/>

   <% Vector valueVector = (Vector)session.getAttribute("valueVector");
      Vector descVector = (Vector)session.getAttribute("descVector"); %>

        <td class="table-text" valign="top" nowrap>
            <% if (isRequired.equalsIgnoreCase("yes")) { %>
             	<span class="requiredField">
            		<label  for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
            			<img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
            			<bean:message key="<%=label%>" />
            		</label>
           		</span>
           	<% } else { %>
            	<label  for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
            		<bean:message key="<%=label%>"/>
            	</label>
           	<% } %>
        <br>

        <% boolean temp = false;
        String enableResponseTimeGoals = XDOperationsViewConfigHelper.getConfigProperty(XDOperationsViewConfigHelper.RESPONSE_TIME_GOALS_DISABLE);
  		enableResponseTimeGoals = enableResponseTimeGoals.trim();
  		if (enableResponseTimeGoals.equalsIgnoreCase("true")) 
  			temp = true;
        
        if (readOnly.equals("true")) { %>
            <bean:define id="key" property="<%=property%>" name="<%=formBean%>" type="java.lang.String"/>
             &nbsp;&nbsp;<bean:message key="<%=key%>"/>

        <%} else {%>
            <tiles:useAttribute id="onChange" name="onChange" classname="java.lang.String"/>
            <% if (readOnly.equalsIgnoreCase("yes")) { %>
                  <bean:write property="<%=property%>" name="<%=formBean%>"/>
            <% } else {
                    if (property.equals("importance")) {
                                        //calculate if the goalvalue should be disabled or not
                                         		if (isImpDisabled.toString().equals("true"))
                                                	temp = true;
                                                if (enableResponseTimeGoals.equalsIgnoreCase("true")) //alway show the importance field, even if the isImpDisabled
                                          			temp = false;
                                }
           %>

            <html:select property="<%=property%>" name="<%=formBean%>" styleId="<%=property%>" onchange="<%=onChange%>" disabled="<%=temp%>">
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     {
                         String val = (String) valueVector.elementAt(i);
                         String descript = (String) descVector.elementAt(i);
                         descript=descript.trim();
                                                         if (!descript.equals("")) {
                                                 %>
                                                                <html:option value="<%=val%>"><bean:message key="<%=descript%>"/></html:option>
                                                 <%
                                                         } else {
                                                         %>
                                                                <html:option value="<%=val%>"><bean:message key="none.text"/></html:option>

                                                         <%
                                                                 }
                     }
                %>
            </html:select>
            <% } %>
            <% if (units != null && !units.equals("") && !units.equals(" ")) { %> <bean:message key="<%=units%>"/> <% } %>
        </td>
        <% } %>


