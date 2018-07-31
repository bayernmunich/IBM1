<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 1997, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page import="com.ibm.ws.console.dynamiccluster.form.DynamicClusterDetailForm"%>
<%@ page import="com.ibm.ws.xd.util.MiddlewareServerConstants"%>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


   <tiles:useAttribute id="label" name="label" classname="java.lang.String"/>
   <tiles:useAttribute id="isRequired" name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute id="size" name="size" classname="java.lang.String"/>
   <tiles:useAttribute id="units" name="units" classname="java.lang.String"/>
   <tiles:useAttribute id="desc" name="desc" classname="java.lang.String"/>
   <tiles:useAttribute id="property" name="property" classname="java.lang.String"/>
   <tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
   <tiles:useAttribute id="includeTD" name="includeTD" ignore="true" classname="java.lang.String"/>
   <tiles:useAttribute id="hideLabel" name="hideLabel" ignore="true" classname="java.lang.String"/>
   <tiles:useAttribute id="forceLength" name="forceLength" ignore="true" classname="java.lang.String"/>

   <bean:define id="bean" name="<%=formBean%>"/>
   <%
   org.apache.struts.util.MessageResources messages = (org.apache.struts.util.MessageResources)pageContext.getServletContext().getAttribute(org.apache.struts.action.Action.MESSAGES_KEY);
   %>
   <%
      String contextId = (String)request.getAttribute("contextId");
      AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
      String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

      String isReadOnly = "true";

      // will allow user to update the uniqueId field if the server type = WASAPP_SERVER (External WebSphere application server)
      DynamicClusterDetailForm dynamicClusterDetailForm = (DynamicClusterDetailForm)session.getAttribute("DynamicClusterDetailForm");
      if (dynamicClusterDetailForm != null) {
         if (dynamicClusterDetailForm.getServerType().equals(MiddlewareServerConstants.WASAPP_SERVER)) {
            if (SecurityContext.isSecurityEnabled()) {
               contextUri = contextUri.replaceFirst("dynamicclusters", "clusters");
               if ((adminAuthorizer.checkAccess(contextUri, "administrator")) || (adminAuthorizer.checkAccess(contextUri, "configurator"))) {
                  isReadOnly = "false";
               }
            } else {
               isReadOnly = "false";
            }
         }
      }
   %>

   <% if (desc.equals("")) { desc = label; }
   	  if (hideLabel==null) { hideLabel = "false"; }
	%>

    <%if(includeTD == null || includeTD.equals("true")){%>
        <td class="table-text" valign="top">
    <%}%>


            <% if (isRequired.equalsIgnoreCase("yes")) { %>
              <span class="requiredField">
                
                <% if (hideLabel.equalsIgnoreCase("true")){%>
                	<div class="hidden">
                		<label  for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
  		              		<bean:message key="<%=label%>" />
  		              	</label>
  		            </div>
  		        <% } else if ((isReadOnly.equalsIgnoreCase("yes") || (isReadOnly.equalsIgnoreCase("true")))) { %>
  		        	<label title="<bean:message key="<%=desc%>"/>">
  		        		<img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
  		        		<bean:message key="<%=label%>" />
  		        	</label>
                <% } else { %>
                	<label  for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
	                	<img id="requiredImage" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
	               		<bean:message key="<%=label%>" />
               		</label>
                <% } %>
              </span>
            <% } else {%>
                <% if (hideLabel.equalsIgnoreCase("true")){%>
                 	<div class="hidden">
                 		<label for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
  		              		<bean:message key="<%=label%>" />
  		        		</label>
  		        	</div>
  		        <% } else if ((isReadOnly.equalsIgnoreCase("yes") || (isReadOnly.equalsIgnoreCase("true")))) { %>
  		        	<label title="<bean:message key="<%=desc%>"/>">
  		        		<bean:message key="<%=label%>" />
  		        	</label>
                <% }else{ %>
                 	<label for="<%=property%>" title="<bean:message key="<%=desc%>"/>">
                		<bean:message key="<%=label%>" />
                	</label>
                <% } %>
            <% } %>

            <% if (!hideLabel.equalsIgnoreCase("true")){%>
            	<BR/>
            <% } %>

            <% if ((isReadOnly.equalsIgnoreCase("yes") || (isReadOnly.equalsIgnoreCase("true")))) {
            		if(forceLength != null && forceLength.equalsIgnoreCase("true")){%>
		                <%-- Need to include some element/style to respect whitespaces in names
		               	<input TYPE="text" id="<%=property%>" class="textEntryReadOnly" value='<bean:write property="<%=property %>" name="<%=formBean%>"/>' DISABLED/> --%>
		                <%--<html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryReadOnly" styleId="<%=property%>" onkeydown="captureRO(this)" onkeyup="returnRO(this)"/>--%>
		                <html:text readonly="true" property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryReadOnly" styleId="<%=property%>" title="<%=messages.getMessage(request.getLocale(),desc)%>"/><%

        				if (units != null && !units.equals(" ") && !units.equals("")) { %> &nbsp;<bean:message key="<%=units%>"/> <% }
        			} else { %>
		                <%-- Need to include some element/style to respect whitespaces in names
		               	<input TYPE="text" id="<%=property%>" class="textEntryReadOnly" value='<bean:write property="<%=property %>" name="<%=formBean%>"/>' DISABLED/> --%>
		                <%--<html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryReadOnly" styleId="<%=property%>" onkeydown="captureRO(this)" onkeyup="returnRO(this)"/>--%>
			            <table border="0" cellpadding="0" cellspacing="0" width="100%" role="presentation">
			            <tr><td class="table-text" valign="top">
			            <DIV CLASS="readOnlyElement" ID="<%=property%>">
			            <bean:write property="<%=property%>" name="<%=formBean%>"/>
			            &nbsp;
			            </DIV>
			            </td><td class="table-text">
			        	<%	if (units != null && !units.equals(" ") && !units.equals("")) { %>&nbsp;<bean:message key="<%=units%>"/> <% } %>
			        	</td></tr></table>

          <% 		}
          	} else {
                if (isRequired.equalsIgnoreCase("yes")) {
            %>
                <html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntryRequired" styleId="<%=property%>" title="<%=messages.getMessage(request.getLocale(),desc)%>"/><%
                }  else {
                %><html:text property="<%=property%>" name="<%=formBean%>" size="<%=size%>" styleClass="textEntry" styleId="<%=property%>" title="<%=messages.getMessage(request.getLocale(),desc)%>"/><%
              	}
         		if (units != null && !units.equals(" ") && !units.equals("")) { %>&nbsp;<bean:message key="<%=units%>"/> <% }

            } %>

    <%if(includeTD == null || includeTD.equals("true")){%>
        </td>
    <%}%>







