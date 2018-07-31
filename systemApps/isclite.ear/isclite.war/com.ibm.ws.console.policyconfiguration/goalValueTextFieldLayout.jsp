<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.policyconfiguration.util.Constants"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="org.apache.struts.action.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isReadOnly" name="isReadOnly" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="size" name="size" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>

   <bean:define id="bean" name="<%=formBean%>"/>
   <bean:define id="isTimeDisabled" property="disabled" name="<%=formBean%>"/>
   <bean:define id="isValueDisabled" property="valueDisabled" name="<%=formBean%>"/>

    <% 	
       MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
       java.util.Locale locale = request.getLocale();
       Vector valueVector = (Vector)session.getAttribute("valueVector");
       Vector descVector = (Vector)session.getAttribute("descVector");
       boolean temp = false;
       boolean temp1 = false;
       //calculate if the goalvalue should be disabled or not
       if (isValueDisabled.toString().equals("true"))
          temp = true;
       if (isTimeDisabled.toString().equals("true"))
          temp1 = true;
       	
       //Get unit type for description field.
       String unitType = messages.getMessage(locale,"UNITS_SECONDS");	
       if (valueVector.contains(Constants.TIME_INTERVAL_MINUTES_STRING))
          unitType = messages.getMessage(locale,"UNITS_MINUTES");	
    %>

        <td class="table-text" valign="top" nowrap>
	 	<span class="requiredField">
	             <label for="<%=property%>" title="<bean:message key="<%=desc%>" arg0="<%=unitType%>" />">
	             <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
	             <bean:message key="<%=label%>" />
	             </LABEL>
	     	</SPAN>
            <br>


            <% if (isReadOnly.equalsIgnoreCase("yes")) { %>
                   <bean:write property="<%=property %>" name="<%=formBean%>"/>
            <% } else { %>
                   <html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleId="<%=property%>" disabled="<%=temp%>" styleClass="textEntryRequired"/>
            <% } %>
            
           	<label class="hidden" for="timeInterval" title="<bean:message key="serviceclass.detail.timeinterval.description"/>">
	       		<bean:message key="serviceclass.detail.timeinterval" />
       		</label>          		
            <html:select property="timeInterval" name="<%=formBean%>" styleId="timeInterval" disabled="<%=temp1%>" onchange="" >
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     {
						 String val = (String) valueVector.elementAt(i);
						 String descript = (String) descVector.elementAt(i);
						 descript=descript.trim();
				         if (!descript.equals("")) {     %>
					         <html:option value="<%=val%>"><bean:message key="<%=descript%>"/></html:option>
					<%   } else {      %>
					         <html:option value="<%=val%>"><bean:message key="none.text"/></html:option>

                 	<%   }
                     }        %>
            </html:select>
        </td>







