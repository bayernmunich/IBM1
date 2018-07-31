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

<!-- "yes" if you want this drop down item to be required. -->
<tiles:useAttribute id="isRequired" name="isRequired" ignore="true" classname="java.lang.String"/>

<!-- give units if applicable -->
<tiles:useAttribute id="units" name="units" ignore="true" classname="java.lang.String"/>

<!-- Name of form attribute to get and set the selected value. -->
<tiles:useAttribute id="property" name="property" classname="java.lang.String"/>

<!-- Name of form attribute to get the list of drop down options.  -->
<tiles:useAttribute id="listProperty" name="listProperty" classname="java.lang.String"/>

<!-- action form  -->
<tiles:useAttribute id="formBean" name="formBean" classname="java.lang.String"/>

<!-- "true" if drop down should be read only -->
<tiles:useAttribute id="readOnly" name="readOnly" ignore="true" classname="java.lang.String"/>

<!-- "true" if you wish to allow multiple selections. -->
<tiles:useAttribute id="multiSelect" name="multiSelect" ignore="true" classname="java.lang.String"/>

<!-- "true" if you wish to have TD tag. -->
<tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>

<!-- "true" if the listProperty contains only NLS keys -->
<tiles:useAttribute id="translateList" name="translateList" ignore="true" classname="java.lang.String"/>

<!-- "true" if the listProperty contains only NLS keys -->
<tiles:useAttribute id="refId" name="refId" ignore="true" classname="java.lang.String"/>

<% if (includeTD == null) { includeTD = "true"; } %>

<% if (refId == null) { refId = ""; } %>

<% String selectId = property + "_" + refId; %>

<% if (!includeTD.equalsIgnoreCase("false")) { %>
<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
<% } %>
           <label for="<%=selectId%>" title="<bean:message key="<%=desc%>"/>">
             <bean:message key="<%=label%>"/>
           </label>
           <br />
           <% if (readOnly != null && readOnly.equals("true")) { %>
       		    <bean:write property="<%=property%>" name="<%=formBean%>"/>
           <% } else {
                if (isRequired != null && isRequired.equalsIgnoreCase("yes")) { %>
            	  <img src="images/attend.gif" width="6" height="15" align="absmiddle" alt="<bean:message key="information.required"/>" title="<bean:message key="information.required"/>">
           <%   } %>
             <% if (multiSelect != null && multiSelect.equalsIgnoreCase("true")) { %>
				<bean:define id="listItem" name="<%=formBean%>" property="<%=listProperty%>" type="ArrayList" />
				<% String size = listItem.size()+""; %>
				
                <html:select property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleId="<%=selectId%>" multiple="true">
                  <logic:iterate id="dropDownItem" name="<%=formBean%>" property="<%=listProperty%>">
                  <% String value = (String) dropDownItem;
				     value=value.trim();
                     if (!value.equals("")) {  
                        if (translateList != null && translateList.equalsIgnoreCase("true")) { %>
    	                    <html:option value="<%=value%>"><bean:message key="<%=value%>"/></html:option>
                     <% } else {%>
	            	        <html:option value="<%=value%>"><%=value%></html:option>
	            	 <% } %>
			      <% } else { %>
                  	    <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
                  <%  } %>
                  </logic:iterate>
                </html:select>
             <% } else { %>
                <html:select property="<%=property%>" name="<%=formBean%>" size="1" styleId="<%=selectId%>">
                  <logic:iterate id="dropDownItem" name="<%=formBean%>" property="<%=listProperty%>">
                  <% String value = (String) dropDownItem;
				     value=value.trim();
                     if (!value.equals("")) {  %>
            	        <html:option value="<%=value%>"><%=value%></html:option>
			      <% } else { %>
                   	  <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
                  <% } %>
                  </logic:iterate>
                </html:select>
            <% } %>
           
            <% if (units != null && !units.equals("") && !units.equals(" ")) { %> 
                  <bean:message key="<%=units%>"/> 
            <% } %>
         <% } %>
         
<% if (!includeTD.equalsIgnoreCase("false")) { %>
         </td>
	  </tr>		
	</tbody>
</table>
<% } %>