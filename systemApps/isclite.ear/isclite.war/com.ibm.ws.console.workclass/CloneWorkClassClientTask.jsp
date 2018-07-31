<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.console.appmanagement.form.AppInstallForm"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%
AppInstallForm detailForm = (AppInstallForm)request.getSession().getAttribute("CloneWorkClassClientTaskForm");

String selectedAppEdition = detailForm.getSelectedItem();
Collection appEditionNames = Arrays.asList(detailForm.getSelectedList());

pageContext.setAttribute("appEditionNames", appEditionNames);
%>

	<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="table-text">
				<table>
					<tr>
						<td class="table-text" colspan=3>	
                        	<label for="description" title='<bean:message key="workclass.installwizard.description" />'>
								<bean:message key="workclass.installwizard.description" />
                            </label>
                            <br><br>
						</td>
					</tr>		
					<tr>
						<td class="table-text">
							<bean:message key="workclass.installwizard.label" /> <br />
							<html:select size="1" value="<%=selectedAppEdition%>" property="selectedItem" styleId="selectedAppEdition">
								<html:options name="appEditionNames" />
							</html:select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
