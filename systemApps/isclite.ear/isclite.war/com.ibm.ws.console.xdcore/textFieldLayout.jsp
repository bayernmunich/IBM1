<%-- IBM Confidential OCO Source Material --%>
<%--  5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp. 1997, 2011 --%>
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

<tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
<tiles:useAttribute id="isReadOnly" name="isReadOnly" classname="java.lang.String"/>
<tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
<tiles:useAttribute id="size" name="size" classname="java.lang.String"/>
<tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
<tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
<tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
<tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
<tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="hideLabel" name="hideLabel" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="forceLength" name="forceLength" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="noKeys" name="noKeys" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="onKeyUp" name="onKeyUp" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="onMouseOut" name="onMouseOut" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="complexType" name="complexType" ignore="true" classname="java.lang.String"/>
<tiles:useAttribute id="propId" name="propId" ignore="true" classname="java.lang.String" />

<bean:define id="bean" name="<%=formBean%>"/>
<%
	org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources) pageContext
			.getServletContext().getAttribute(
					org.apache.struts.action.Action.MESSAGES_KEY);
%>

<%
	if (desc.equals("")) {
		desc = label;
	}
	if (hideLabel == null) {
		hideLabel = "false";
	}
	
	boolean useNoKeys = false;
	if ("true".equalsIgnoreCase(noKeys)
			|| "yes".equalsIgnoreCase(noKeys)) {
		useNoKeys = true;
	}
	if (onKeyUp == null) {
		onKeyUp = "";
	}
	if (onMouseOut == null) {
		onMouseOut = "";
	}
	if (complexType == null) {
		complexType = "";
	} else {
		complexType = complexType.toUpperCase();
		if (complexType.equals("FILEPATH")) {
			complexType = "FILE_PATH";
		}
	}
	
	if(propId == null || propId.equals("")) {
		propId = property;
	}
%>

<% if ((includeTD == null) || (includeTD.equals("true"))) { %>
    <td class="table-text" valign="top">
<% } %>

<% if (isRequired.equalsIgnoreCase("yes")) { %>
	<span class="requiredField">
		<label  for="<%=propId%>" title="<%=useNoKeys ? desc : messages.getMessage(request.getLocale(), desc)%>">
        
        <% if (hideLabel.equalsIgnoreCase("true")) { %>
			<div style="display: none">
				<%=useNoKeys ? label : messages.getMessage(request.getLocale(), label)%>
			</div>
        <% } else { %>
             <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
             <%=useNoKeys ? label : messages.getMessage(request.getLocale(), label)%>
        <% } %>
        
        </label>
       </span>
<% } else {  %>
	<label  for="<%=propId%>" title="<%=useNoKeys ? desc : messages.getMessage(request.getLocale(), desc)%>">
		<% if (hideLabel.equalsIgnoreCase("true")) { %>
			<div style="display: none">
				<%=useNoKeys ? label : messages.getMessage(request.getLocale(), label)%>
			</div>
        <% } else { %>
             <%=useNoKeys ? label : messages.getMessage(request.getLocale(), label)%>
        <% } %>
       </label>
<% } %>

<% if (!hideLabel.equalsIgnoreCase("true")) { %>
        	<BR/>
   <% } %>

<% if ((isReadOnly.equalsIgnoreCase("yes") || (isReadOnly.equalsIgnoreCase("true")))) {
	if (forceLength != null && forceLength.equalsIgnoreCase("true")) { %>
        <%-- Need to include some element/style to respect whitespaces in names
        <input TYPE="text" id="<%=property%>" class="textEntryReadOnly" value='<bean:write property="<%=property %>" name="<%=formBean%>"/>' DISABLED/> --%>
        <%--<html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryReadOnly" styleId="<%=property%>" onkeydown="captureRO(this)" onkeyup="returnRO(this)"/>--%>
          	     			            
           <html:text readonly="true" property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryReadOnly" styleId="<%=propId%>" 
           	title="<%=useNoKeys ? desc : messages.getMessage(request.getLocale(),desc)%>"/>
           
           <%if (units != null && !units.equals(" ")&& !units.equals("")) { %>
           	&nbsp;<bean:message key="<%=units%>"/> 
          	<% } %>
		<% } else { %>
			<table border="0" cellpadding="0" cellspacing="0" width="60%" role="presentation">
			<tr>
               	<td class="table-text" valign="top">
                       <% if (complexType.length() == 0) { %>
                			<DIV CLASS="readOnlyElement" id="<%=property + "readOnlyElement"%>">
              			<% } else { %>
                			<DIV CLASS="readOnlyElementComplex" id="<%=property + "readOnlyElement"%>">
              			<% } %>
                  				<bean:write property="<%=property%>" name="<%=formBean%>"/>&nbsp;
                  				<input TYPE="hidden" name="<%=property%>" id="<%=propId%>" value="<bean:write property="<%=property%>" name="<%=formBean%>"/>" DISABLED/><%-- Added to prevent formFocus javascript errors --%>			            
                			</DIV>
              		</td>
			<% if (units != null && !units.equals(" ") && !units.equals("")) { %>
				<td class="table-text">
				   &nbsp;<bean:message key="<%=units%>"/>
				</td>
			<% } %>
       		</tr>
        </table>
           
      <% }
} else {
	String styleClass = "textEntry";
  		if (isRequired.equalsIgnoreCase("yes")) {
  			styleClass = "textEntryRequired";
  		} %>

	<html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="<%=styleClass%>" styleId="<%=propId%>" onkeyup="<%=onKeyUp%>" onmouseout="<%=onMouseOut%>" title="<%=useNoKeys ? desc : messages.getMessage(request.getLocale(),desc)%>"/>
       <% if (units != null && !units.equals(" ") && !units.equals("")) { %>
     	        &nbsp;<bean:message key="<%=units%>"/> 
    	<% }
} %>
