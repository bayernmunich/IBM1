<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<% try{ %>

   <tiles:useAttribute name="label" classname="java.lang.String"/>
   <tiles:useAttribute name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute name="readOnly" classname="java.lang.String"/>
   <tiles:useAttribute name="property" classname="java.lang.String"/>
   <tiles:useAttribute name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="size" name="size" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
    
   <bean:define id="bean" name="<%=formBean%>"/>
   
    <% 	
    Vector valueVector = new Vector(3);
    Vector descVector = new Vector(3);
    valueVector.add("UNITS_MINUTES");
    valueVector.add("UNITS_HOURS");
    valueVector.add("UNITS_DAYS");
    descVector.addAll(valueVector);
    
    String legendId = property + ".legend";
    %>
  <td class="table-text" valign="top" nowrap>
	<fieldset id="<%=legendId%>" title="<bean:message key="<%=desc%>"/>">
	<legend  for="<%=legendId%>" title="<bean:message key="<%=desc%>"/>"> <bean:message key="<%=label%>" /></legend>
            <% if (isRequired.equalsIgnoreCase("yes")) { %>
                   <img src="images/attend.gif" width="6" height="15" align="absmiddle" alt="<bean:message key="information.required"/>">
            <% } %>    
                    
            <% if (readOnly.equalsIgnoreCase("yes")) { %>
                   <bean:write property="<%=property %>" name="<%=formBean%>"/>
            <% } else { %>
				   <label class="hidden" for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
		             	<bean:message key="<%=label%>" />
		      	   </label>
                   <html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleId="<%=property%>" styleClass="textEntry"/>
            <% } %>

		    <label class="hidden" for="timeInterval" title="<bean:message key="<%=desc%>"/>">
             	 <bean:message key="<%=label%>" />
      	    </label>
            <html:select property="timeInterval" name="<%=formBean%>" styleId="timeInterval" >
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
	</fieldset>
  </td>
       
<% } catch (Exception e) {e.printStackTrace();} %>