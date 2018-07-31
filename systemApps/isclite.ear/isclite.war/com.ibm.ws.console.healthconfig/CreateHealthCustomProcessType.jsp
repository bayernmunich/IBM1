<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.healthconfig.*, com.ibm.ws.console.healthconfig.util.*"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
  <tr valign="baseline" >
      <td class="wizard-step" id="current" width="99%" align="left"> 
          <bean:message key="healthclass.customAction.wizard.steps.actionType"/>
          <br>
      </td>
  </tr>
</table>

<table border="1" cellpadding="3" cellspacing="1" width="100%" summary="List table">
        <tr>
          <td class="wizard-step-text"> 
            <label for="healthCustomActionTypeList">
	         <bean:message key="healthclass.customAction.wizard.steps.actionType.description"/></label>

			<%-- Selecting the Health Custom Action Type ----%>
			<BR>
			<html:select property="selectedHealthCustomActionType" size="1" styleId="healthCustomActionTypeList">
	                  <logic:iterate id="healthCustomActionType" name="<%=actionForm%>" property="healthCustomActionTypeList">
				<% 	String value = (String) healthCustomActionType;
				   	value=value.trim();
					if (!value.equals("")) {  
						if (value.equals(HealthUtils.JAVA_SERVER_OP)) { %>
						 	<html:option value="<%=value%>"><bean:message key="healthclass.customAction.java"/></html:option>
						<% }
						else if (value.equals(HealthUtils.NON_JAVA_SERVER_OP)) { %>
							<html:option value="<%=value%>"><bean:message key="healthclass.customAction.nonjava"/></html:option>
						<%} 
					    	
				  	} else { %>
			  	        <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
			   	 <%  } %>

			      </logic:iterate>
                	</html:select>

			<%-- End of Select Health Custom Action Type --%>

          </td>
        </tr>

</table>
