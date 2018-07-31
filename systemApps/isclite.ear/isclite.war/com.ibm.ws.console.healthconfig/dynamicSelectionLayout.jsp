<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>



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
   <tiles:useAttribute id="multiSelect" name="multiSelect" classname="java.lang.String"/>
   <tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>
   <tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>
   
   
   <bean:define id="bean" name="<%=formBean%>"/>
   <%
   org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.action.Action.MESSAGES_KEY);
   %>
   
   <% if (desc.equals("")) { desc = label; } %>

   <% Vector valueVector = (Vector)session.getAttribute("valueVector");
      Vector descVector = (Vector)session.getAttribute("descVector"); 
      String multiAttribute = "";
      String showNoneText = "none.text";

	  if (multiSelect.equalsIgnoreCase("true")) {
		 multiAttribute = "multiple=\"true\"";
	  }
	  
   %>


    <%if(includeTD == null || includeTD.equals("true")){%>
        <td class="table-text" valign="top">
    <%}%>
        
            <% if (isRequired.equalsIgnoreCase("yes")) { 
				  showNoneText = "appinstall.select";
			   %>
              <span class="requiredField">
                <label title="<bean:message key="<%=desc%>"/>" for="<%=property%>">
                <img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                <bean:message key="<%=label%>" />
              <% } else {%>             
                <label title="<bean:message key="<%=desc%>"/>" for="<%=property%>">
                <bean:message key="<%=label%>" />
            <% } %>
            
            
            <BR/>                    

               <%
				  if (readOnly.equalsIgnoreCase("yes") || readOnly.equalsIgnoreCase("true")) {
			   %>

                <bean:define id="thevalue" name="<%=formBean %>" property="<%=property %>" />
                <% String currentValue = "" + thevalue + ""; %>

               <SELECT ID="<%=property%>" name="<%=formBean%>" <%=multiAttribute%> DISABLED title="<bean:message key="<%=desc%>"/>"> 
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     { 
			 String val = (String) valueVector.elementAt(i);
             String sel = "";
             if (currentValue.equalsIgnoreCase(val)) {
                sel = "SELECTED";
			 }
			 String descript = (String) descVector.elementAt(i);
			 descript=descript.trim();
				                         if (!descript.equals("")) {
					         %>
					                        <option value="<%=val%>" <%=sel%>><bean:message key="<%=descript%>"/></option>
					         <%
				                         } else {
                 				         %>
					                        <option value="<%=val%>" <%=sel%>><bean:message key="<%=showNoneText%>"/></option>

                 				         <%     
                         				         }
                     }
                %>
               </SELECT>
               
               <% } else { %>

                                               
	            <% if (multiSelect.equalsIgnoreCase("true")) { %>
                <bean:define id="thevalues" name="<%=formBean %>" property="<%=property %>" />
	            <html:select property="<%=property%>" name="<%=formBean%>" styleId="<%=property%>" multiple="true" title="<%=messages.getMessage(request.getLocale(),desc)%>">
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     {
					     String val = (String) valueVector.elementAt(i);
                         String sel = "";
                         %>
                         <logic:iterate name="thevalues" id="currentValue">
                         <%
                         //for (int j=0; j < currentValues.length; j++) {
                            if (((String)currentValue).equalsIgnoreCase(val)) {
                                sel = "SELECTED";
                            }
                         //}
                         %>
                         </logic:iterate>
                      <%
					  String descript = (String) descVector.elementAt(i);
					  descript = descript.trim();
                         if (!descript.equals("")) {
                 %>
                        <option value="<%=val%>"  <%=sel%>><bean:message key="<%=descript%>"/></option>
                 <%
                         } else {
                 %>
                        <option  value="<%=val%>" <%=sel%>><bean:message key="<%=showNoneText%>"/></option>
                 <%        
                         }
                     }
                %>
	            </html:select>
                
                
                <% } else { %>
                <bean:define id="selectedvalue" name="<%=formBean %>" property="<%=property %>"/>
                <% String currentValue = "" + selectedvalue + ""; %>

	            <html:select property="<%=property%>" name="<%=formBean%>" styleId="<%=property%>" title="<%=messages.getMessage(request.getLocale(),desc)%>">
                
                <%
                     for (int i=0; i < valueVector.size(); i++)
                     { 
					  String val = (String) valueVector.elementAt(i);
                      String sel = "";
                      if (currentValue.equalsIgnoreCase(val)) {
                        sel = "SELECTED";
                      }
					  String descript = (String) descVector.elementAt(i);
					  descript = descript.trim();
                         if (!descript.equals("")) {
                 %>
                        <option value="<%=val%>" <%=sel%>><bean:message key="<%=descript%>"/></option>
                 <%
                         } else {
                 %>
                        <option  value="<%=val%>" <%=sel%>><bean:message key="<%=showNoneText%>"/></option>
                 <%        
                         }
                     }
                %>
	            </html:select>
                
				  <% } %>
                  
               <% } %>
               
                <% if (isRequired.equalsIgnoreCase("yes")) {%>
                
               </LABEL>
               </span>
                <%} else {%>
                     </LABEL>

                <%} %>
                
                <% if (units != null && !units.equals("") && !units.equals(" ")) { %> <bean:message key="<%=units%>"/> <% } %>
        

    <%if(includeTD == null || includeTD.equals("true")){%>
        </td>
    <%}%>

   
   
 
