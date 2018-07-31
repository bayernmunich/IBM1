<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*,org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="propName" name="propName" classname="java.lang.String"/>
   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isReadOnly" name="isReadOnly" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="onClick" name="onClick" ignore="true" classname="java.lang.String"/>
   <tiles:useAttribute id="onKeyPress" name="onKeyPress" ignore="true" classname="java.lang.String"/>
   <tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>
   
   <bean:define id="bean" name="<%=formBean%>"/>
   
   
   <bean:define id="state" name="<%= formBean %>" property="<%=property%>"/>
   
   <% 
     String checked = "";
     String tmpchecked = "" + state + ""; 
     if (tmpchecked.equalsIgnoreCase("true")) {
       checked = "CHECKED";
     }
   %>

   <%-- // defect 126608
   <tr valign="top">
   --%>

  
    <% 
	  ServletContext servletContext = (ServletContext)pageContext.getServletContext();
	  MessageResources messages = (MessageResources)servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
      String newunits = messages.getMessage(request.getLocale(),units);
	  String newlabel = messages.getMessage(request.getLocale(),label);

	  if (desc.equals("")) { desc = label; } 
	  if (label != null && !label.trim().equals("")) {
         newunits = newlabel;
	  }
    %>
    
    <%
    if(onClick==null){
    	onClick="";
    }
    
    if(onKeyPress==null){
    	onKeyPress="";
    }
    %>
    
    <%if(includeTD == null || includeTD.equals("true")){%>
        <td class="table-text" >
    <%}%>
        
            <div class="chkbox-div" title="<bean:message key="<%=desc%>" />">
            <label  for="<%=propName%>" title="<bean:message key="<%=desc%>"/>">
            <% if (isReadOnly.equalsIgnoreCase("yes")) { %>
                <input type="checkbox" <%=checked%> value="true" name="<%=propName%>" id="<%=propName%>" styleClass="chkbox" DISABLED onclick="<%=onClick%>" onkeypress="<%=onKeyPress%>" />
            <% } else { %>
               <input type="checkbox" <%=checked%> value="true" name="<%=propName%>" id="<%=propName%>" styleClass="chkbox" onclick="<%=onClick%>" onkeypress="<%=onKeyPress%>" />
            <% } %>
            	<%=newunits%>	<%--Hidden label for accessability --%>
            </label>
            </div>
    <%if(includeTD == null || includeTD.equals("true")){%>
        </td>
    <%}%>

   <%-- // defect 126608    
        <td class="table-text" valign="top"><a href="transformer.jsp?xml=was_page_help&xsl=was_page_help" target="WAS_Help">
            <img src="<%=request.getContextPath()%>/images/more.gif" border="0" alt="View more information about this field" align="texttop"></a>
            <bean:message key="<%=desc%>"/>
       </td>
   </tr>
   --%>
    

   
   
 
