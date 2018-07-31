<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="propName" name="propName" classname="java.lang.String"/>
   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="isReadOnly" name="isReadOnly" classname="java.lang.String"/>

   <bean:define id="bean" name="<%=formBean%>"/>
   
   <% if (desc.equals("")) { desc = label; } %>

   <bean:define id="state" name="<%= formBean %>" property="<%=property%>"/>

   <% 
     String checked = "";
     String tmpchecked = "" + state + ""; 

     Vector valueVector = (Vector)session.getAttribute("valueVector");
      Vector descVector = (Vector)session.getAttribute("descVector"); 
      
      boolean isDisabled=false;
      if(isReadOnly.equalsIgnoreCase("true") || isReadOnly.equalsIgnoreCase("yes")) {isDisabled=true;}

%>


        <td class="table-text"  valign="top" nowrap>
            <FIELDSET>
            <LEGEND ID="<%=property%>" title="<bean:message key="<%=desc%>"/>">
            <% if (isRequired.equalsIgnoreCase("yes")) { %>
                <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                <bean:message key="<%=label%>" />
            <% } else {%>             
                <bean:message key="<%=label%>" />
            <% } %>
            </LEGEND>
             
                <%
                     for (int i=0; i < valueVector.size()-1; i++)
                     { 
            			 String val = (String) valueVector.elementAt(i);
            			 String descript = (String) descVector.elementAt(i);

                         if (tmpchecked.equalsIgnoreCase(val)) {
                            checked = "CHECKED";
                         } else {
                            checked = "";
                         }
                %>
                       <label title="<bean:message key="<%=descript%>"/>" for="<%=propName%>">
                       <input type="radio" <%=checked%> name="<%=propName%>" value="<%=val%>" styleId="<%=propName%>" disabled="<%=isDisabled%>"/>
                       </label><BR>

                     <%
                     }
                %>
            <% if (units != null && !units.equals("") && !units.equals(" ")) { %> <bean:message key="<%=units%>"/> <% } %>
            </FIELDSET>
        </td>
       
    

   
   
 

