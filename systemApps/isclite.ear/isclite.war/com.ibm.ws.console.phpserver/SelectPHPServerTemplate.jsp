<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
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
<%@ page language="java" import="com.ibm.ws.console.phpserver.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.appmanagement.*"%>
<%@ page language="java" import="com.ibm.ws.console.appmanagement.form.*"%>
<%@ page language="java" import="com.ibm.ws.console.servermanagement.wizard.*"%>
<%@ page language="java" import="javax.management.ObjectName"%> 
 
<tiles:useAttribute name="actionForm" classname="java.lang.String" />

            <FIELDSET class="table-text" id="selectTemplate">
               <legend for ="selectTemplate" TITLE="<bean:message key="phpserver.template.description"/>">
                 <bean:message key="select.phpserver.template"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
				<logic:equal name="<%=actionForm%>" property="showDefault" value="true">
					<tr>
						<td valign="top" class="table-text">
							<LABEL for="defaultTemplate" title="<bean:message key="chosen.phpserver.template" /> "> 
								<html:radio property="radioButton" styleId="defaultTemplate" value="default" /> 
						   		<bean:message key="chosen.phpserver.template" /> 
							</LABEL>
						</TD>
					</TR>
					<TR>
						<TD CLASS="complex-property">
							<label for="selectedTemplateName"> 
								<bean:message key="default.appserver.choose.template" /> 
							</label>
							<BR>
							<html:select property="selectedTemplateName" size="1" styleId="selectedTemplateName">
								<logic:iterate id="selectedTemplateDetailForm" name="<%=actionForm%>" property="templatesList">			
								<%
									TemplateDetailForm templateDetailForm = (TemplateDetailForm) selectedTemplateDetailForm;
							      	String value = templateDetailForm.getName(); 
							      	value=value.trim();
							   		if (!value.equals("")) {  %>
					    				<html:option value="<%=value%>"><%=value%></html:option>
			  	 		  		<%	} else { %>
			  	        				<html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
			   	 				<%  } %>
								</logic:iterate>
							</html:select>
						</TD>
					</TR>
				</logic:equal>
				<logic:equal name="<%=actionForm%>" property="showDefault" value="true">
					<tr>
						<td valign="top" class="table-text">
							<LABEL for="existingTemplate"> 
								<html:radio property="radioButton" styleId="existingTemplate" value="existing" /> 
						   		<bean:message key="existing.phpserver" /> 
						   	</LABEL>
						</TD>
					</TR>
					<TR>
						<TD CLASS="complex-property">
							<label for="selectedExistingServer"> 
								<bean:message key="choose.existing.phpserver" /> 
							</label>
							<BR>
							<html:select property="selectedExistingServer" size="1" styleId="selectedExistingServer">
								<logic:iterate id="selectedExistingServer" name="<%=actionForm%>" property="existingServerList">			
								<%     							     
							   	  	String value = (String) selectedExistingServer;
							      	value=value.trim();
							   		if (!value.equals("")) {  %>
					    			 	<html:option value="<%=value%>"><%=value%></html:option>
			  	 		 		<% 	} else { %>
			  	        				<html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
			   	 				<%	} %>
								</logic:iterate>
							</html:select>
						</TD>
					</TR>
				</logic:equal>
			</table>
			</FIELDSET>
