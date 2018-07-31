<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004, 2005 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.Collection,java.lang.reflect.*,com.ibm.ws.util.XDConstants,com.ibm.ws.console.healthconfig.form.HealthClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="org.apache.struts.action.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>


<% try { %>
<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="numberOfColumns" classname="java.lang.String" />
<tiles:useAttribute name="topicKey" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="formFocus" classname="java.lang.String" />
<tiles:useAttribute name="testForm" classname="com.ibm.ws.console.healthconfig.form.HealthClassDetailForm"/>
<tiles:useAttribute name="fieldLevelHelpTopic" classname="java.lang.String"/>

<a name="general"></a><h2><bean:message key="config.general.properties"/></h2>

	<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
	      <table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation" >	
	        <tbody>
		
		        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">

<%
	    int fields = 0;	
        String fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
        boolean productEnabled = true;


        if (productEnabled) {
%>

        <tr valign="top">

                <%
                String isRequired = item.getRequired();
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
                %>

                 <% if (strType.equalsIgnoreCase("Text")) {
						if ((item.getAttribute().equalsIgnoreCase("totalMemory")) ||
		               	         (item.getAttribute().equalsIgnoreCase("percentile")) ||
		               	         (item.getAttribute().equalsIgnoreCase("garbageCollectionPercent"))) { %>
		               	      <td class="table-text" nowrap>
		               	      <label for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
		               	      	<bean:message key="<%= item.getLabel() %>"/>
		               	      </label>
		               	      <br>
					          &nbsp;&nbsp;<bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/>
					          <bean:message key="percent.sign"/>
					          </td>  <%
		                fields++;
		                }
		                else  { %>
		                	  <td class="table-text" nowrap>
		                	  <label  for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
		               	      	<bean:message key="<%= item.getLabel() %>"/>
		               	      </label>
		               	      <br>
					       	   &nbsp;&nbsp;<bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/> </td>
		                <%
		                		                }
		           } %>
		
                <% if (strType.equalsIgnoreCase("checkbox")) { %>
                    <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="yes" />
                        <tiles:put name="isRequired" value="no" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>
                <% } %>

                <% if (strType.equalsIgnoreCase("TextArea")) { %>
		                	  <td class="table-text" nowrap>
		                	  <label  for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
		               	      	<bean:message key="<%= item.getLabel() %>"/>
		               	      </label>
		               	      <br>
					           &nbsp;&nbsp;<bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/> </td>
                <%   } %>

                <% if (strType.equalsIgnoreCase("Select")) {
		                    Vector descVector = new Vector();
		                    Vector valueVector = new Vector();
		                    session.setAttribute("descVector", descVector);
		                    session.setAttribute("valueVector", valueVector);

                    %>

                   <% if (item.getAttribute().equalsIgnoreCase("type")) {
                   		 %>
                    <tiles:insert page="/com.ibm.ws.console.healthconfig/submitLayoutWithOnChange.jsp"  flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="valueVector" value="<%=valueVector%>" />
                        <tiles:put name="descVector" value="<%=descVector%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>    <%
                    }
                    else if (item.getAttribute().equalsIgnoreCase("reactionMode")) { %>
                    <tiles:insert page="/com.ibm.ws.console.healthconfig/submitLayoutWithOnChange.jsp"  flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="valueVector" value="<%=valueVector%>" />
                        <tiles:put name="descVector" value="<%=descVector%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=formName%>" />
                    </tiles:insert>

    					<%} else { %>
		                	  <td class="table-text" nowrap>
		                	  <label  for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
		               	      	<bean:message key="<%= item.getLabel() %>"/>
		               	      </label>
		               	      <br>
					           &nbsp;&nbsp;<bean:write property="<%= item.getAttribute() %>" name="<%=formName%>"/> </td>
                 <% }
                 } %>

<% } %>

        </tr>
        </logic:iterate>

        <tr valign="top">
           <td class="table-text"  valign="top" nowrap>
              <label title="<bean:message key="healthclass.healthcondition.description"/>">
                <bean:message key="healthclass.type"/>
              </label>
              <br>
              <P CLASS="readOnlyElement">
	              <bean:message key="<%=testForm.getType()%>"/>
	              &nbsp;
              </P>
           </td>
        </tr>
        <%
//The last thing was the health condition, so here we wil put in the Health Condition attributes
		if (testForm.getType().equalsIgnoreCase("AGE")) { %>
                 <tr valign="top">
                    <td class="table-text">
                        <bean:message key="healthclass.age.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="age">
                          <legend for ="age" TITLE="<bean:message key="healthclass.age.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="age" TITLE="<bean:message key="healthclass.wizard.age.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.age"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="age"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="age"
                                         disabled="true"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="ageUnits"><bean:message key="healthclass.wizard.age.units"/></label>
                         	       <html:select property="ageUnits" name="<%=formName%>" disabled="true" styleId="ageUnits">
                                        <html:option value="UNITS_DAYS"><bean:message key="UNITS_DAYS"/></html:option>
                                        <html:option value="UNITS_HOURS"><bean:message key="UNITS_HOURS"/></html:option>
                         	       </html:select>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							       <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>

<%
		
		} else if (testForm.getType().equalsIgnoreCase("WORKLOAD")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.workload.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="workload">
                          <legend for ="workload" TITLE="<bean:message key="healthclass.workload.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="totalRequests" TITLE="<bean:message key="healthclass.wizard.requests.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.requests"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="totalRequests"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="totalRequests"
                                         disabled="true"
                                         styleClass="textEntryRequired" />
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>

<%
		
		} else if (testForm.getType().equalsIgnoreCase("MEMORY")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.memory.healthcondition.description"/>
                        <br><br>
                        <img src="<%=request.getContextPath()%>/images/Information.gif" border="0" alt="<bean:message key="error.msg.information"/>"/>
                        <bean:message key="healthclass.memory.memoryleak.recommended.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="memory">
                          <legend for ="memory" TITLE="<bean:message key="healthclass.memory.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="totalMemory" TITLE="<bean:message key="healthclass.wizard.memory.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.memory"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="totalMemory"
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="totalMemory"
                                         disabled="true"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="timeOverThreshold" TITLE="<bean:message key="healthclass.wizard.timeoverthreshold.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.timeoverthreshold"/>
                                   <br>
                                   <html:text property="timeOverThreshold"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="timeOverThreshold"
                                         disabled="true"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="timeUnits">Time Units</label>
                                   <html:select property="timeUnits" name="<%=formName%>" disabled="true" styleId="timeUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_SECONDS"><bean:message key="UNITS_SECONDS"/></html:option>
                         	       </html:select>
                                   <br>

                                    </label>
                                   </span>

                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
			
		} else if (testForm.getType().equalsIgnoreCase("RESPONSE")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.response.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="response">
                          <legend for ="response" TITLE="<bean:message key="healthclass.response.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="responseTime" TITLE="<bean:message key="healthclass.wizard.responsetime.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.responsetime"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="responseTime"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="responseTime"
                                         disabled="true"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="responseTimeUnits">Response Time Units</label>
                                   <html:select property="responseTimeUnits" name="<%=formName%>" disabled="true" styleId="responseTimeUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_SECONDS"><bean:message key="UNITS_SECONDS"/></html:option>
                                        <html:option value="UNITS_MILLISECONDS"><bean:message key="UNITS_MILLISECONDS"/></html:option>
                         	       </html:select>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("STUCKREQUEST")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.stuckrequest.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="stuckRequest">
                          <legend for ="stuckRequest" TITLE="<bean:message key="healthclass.stuckrequest.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="timeoutPercent" TITLE="<bean:message key="healthclass.wizard.timeoutpercent.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.timeoutpercent"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="timeoutPercent"
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="timeoutPercent"
                                         disabled="true"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("STORMDRAIN")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.stormdrain.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="stormDrain">
                          <legend for ="stormDrain" TITLE="<bean:message key="healthclass.stormdrain.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                      <label TITLE="<bean:message key="healthclass.stormdrain.detection.description"/>">
                                         <bean:message key="healthclass.detectionlevel"/>
                                      </label>
                                   <br>
                                   <html:radio property="stormDrainConditionLevel"
                                               name="<%=formName%>"
                                               styleId="stormDrainConditionLevelNormal"
                                               disabled="true"
                                               value="CONDITION_LEVEL_NORMAL"/>
                                   <label for="stormDrainConditionLevelNormal">
                                      <bean:message key="healthclass.stormdrain.normallevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="stormDrainConditionLevel"
                                               name="<%=formName%>"
                                               styleId="stormDrainConditionLevelConservative"
                                               disabled="true"
                                               value="CONDITION_LEVEL_CONSERVATIVE"/>
                                   <label for="stormDrainConditionLevelConservative">
                                      <bean:message key="healthclass.stormdrain.conservativelevel"/>
                                   </label>
                                   <br>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("MEMORYLEAK")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.memoryleak.healthcondition.description"/>
                        <br><br>
                        <img src="<%=request.getContextPath()%>/images/Information.gif" border="0" alt="<bean:message key="error.msg.information"/>"/>
                        <bean:message key="healthclass.memory.memoryleak.recommended.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="memoryLeak">
                          <legend for ="memoryLeak" TITLE="<bean:message key="healthclass.memoryleak.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                      <label TITLE="<bean:message key="healthclass.memoryleak.detection.description"/>">
                                         <bean:message key="healthclass.detectionlevel"/>
                                      </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionLevelAgressive"
                                               disabled="true"
                                               value="CONDITION_LEVEL_AGGRESSIVE"/>
                                   <label for="memoryLeakConditionLevelAgressive">
                                      <bean:message key="healthclass.memoryleak.aggressivelevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionLevelNormal"
                                               disabled="true"
                                               value="CONDITION_LEVEL_NORMAL"/>
                                   <label for="memoryLeakConditionLevelNormal">
                                      <bean:message key="healthclass.memoryleak.normallevel"/>
                                   </label>
                                   <br>
                                   <html:radio property="memoryLeakConditionLevel"
                                               name="<%=formName%>"
                                               styleId="memoryLeakConditionLevelConservative"
                                               disabled="true"
                                               value="CONDITION_LEVEL_CONSERVATIVE"/>
                                   <label for="memoryLeakConditionLevelConservative">
                                      <bean:message key="healthclass.memoryleak.conservativelevel"/>
                                   </label>
                                   <br>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true"  styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							       <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
		
		} else if (testForm.getType().equalsIgnoreCase("GCPERCENTAGE")) {%>
                 <tr valign="top">
                    <td class="instruction-text"  >
                        <bean:message key="healthclass.gcpercentage.healthcondition.description"/>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="gcpercentage">
                          <legend for ="gcpercetage" TITLE="<bean:message key="healthclass.gcpercentage.healthcondition.description"/>">
                             <bean:message key="healthclass.conditionproperties"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                      <label for="garbageCollectionPercent" TITLE="<bean:message key="healthclass.wizard.gcpercentage.description"/>">
                                         <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                         <bean:message key="healthclass.gcpercentage"/>
                                      </label>
                                   </span>
                                   <br>
                                   <html:text property="garbageCollectionPercent"
                                         name="<%=formName%>"
                                         size="15"
                                         styleId="garbageCollectionPercent"
                                         disabled="true"
                                         styleClass="textEntryRequired" /> <bean:message key="percent.sign"/>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <span class="requiredField">
                                   <br>
                                   <label for="samplingPeriod" TITLE="<bean:message key="healthclass.wizard.samplingperiod.description"/>">
                                      <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                      <bean:message key="healthclass.samplingperiod"/>
                                   </label>
                                   <br>
                                   <html:text property="samplingPeriod"
                                         name="<%=formName%>"
                                         size="25"
                                         styleId="samplingPeriod"
                                         disabled="true"
                                         styleClass="textEntryRequired" />
                                   <label class="hidden" for="samplingUnits"><bean:message key="healthclass.wizard.sampling.units"/></label>
                                   <html:select property="samplingUnits" name="<%=formName%>" disabled="true" styleId="samplingUnits">
                                        <html:option value="UNITS_MINUTES"><bean:message key="UNITS_MINUTES"/></html:option>
                                        <html:option value="UNITS_HOURS"><bean:message key="UNITS_HOURS"/></html:option>
                         	       </html:select>
                                   <br>
                                   </span>
                                </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true" styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
							      <td class="table-text"nowrap>
							            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
							                <tiles:put name="actionForm" value="<%=formAction%>"/>
							                <tiles:put name="callerType" value="detail"/>
							            </tiles:insert>
							      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%

		} else if (testForm.getType().equalsIgnoreCase("CUSTOM")) {%>
                 <tr valign="top">
                    <td class="table-text"  >
                        <bean:message key="healthclass.customCondition.desc"/>
                    </td>
                 </tr>
                <tr>
                  <td>
                    <tiles:insert page="/com.ibm.ws.console.xdcore/ruleEditLayout.jsp" flush="false">
           	       <tiles:put name="actionForm" value="<%=formName%>" />
           	       <tiles:put name="label" value="healthclass.customCondition.run.reaction.label" />
           	       <tiles:put name="desc" value="healthclass.customCondition.desc" />
           	       <tiles:put name="hideValidate" value="true" />
                  	   <tiles:put name="hideRuleAction" value="true" />
                  	   <tiles:put name="rule" value="customExpression" />
                  	   <tiles:put name="rowindex" value="" />
                  	   <tiles:put name="refId" value="" />
                  	   <tiles:put name="ruleActionContext" value="service" />
                  	   <tiles:put name="template" value="service" />
                  	   <tiles:put name="actionItem0" value="notUsed" />
                  	   <tiles:put name="actionListItem0" value="notUsed" />
                  	   <tiles:put name="actionItem1" value="notUsed" />
                  	   <tiles:put name="actionListItem1" value="notUsed" />
               	   <tiles:put name="quickHelpTopic" value="hc_condition_subex.html" />
               	   <tiles:put name="quickPluginId" value="com.ibm.ws.console.healthconfig" />
               	   <tiles:put name="customRuleBuilderLayout" value="/com.ibm.ws.console.xdcore/ruleBuilderLayoutForHealthPolicy.jsp" />
                  	 </tiles:insert>
                  </td>
                 </tr>
                 <tr valign="top">
                    <td class="table-text"  nowrap>
                       <FIELDSET id="monitorReaction">
                          <legend for ="monitorReaction" TITLE="<bean:message key="healthclass.monitorreaction.description"/>">
                             <bean:message key="healthclass.monitorreaction"/>
                          </legend>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                            <tbody>
                              <tr valign="top">
                                <td class="complex-property" nowrap>
                                   <br>
                                   <label for="reactionMode" title='<bean:message key="healthclass.wizard.reactionMode.description"/>'>
                                       <bean:message key="healthclass.reactionMode" />
                                   </label>
                                   <br>
                                   <html:select property="reactionMode" name="<%=formName%>" disabled="true"  styleId="reactionMode">
                                      <html:option value="REACTION_MODE_SUPERVISED">
                                        <bean:message key="REACTION_MODE_SUPERVISED"/>
                                      </html:option>
                                      <html:option value="REACTION_MODE_AUTOMATIC">
                                        <bean:message key="REACTION_MODE_AUTOMATIC"/>
                                      </html:option>
                                   </html:select>
                                   <br>
                                </td>
                              </tr>
                              <tr valign="top">
      <td class="table-text"nowrap>
            <tiles:insert page="/com.ibm.ws.console.healthconfig/HealthActionPlanCollectionTableManualDetailLayout.jsp" flush="true">
                <tiles:put name="actionForm" value="<%=formAction%>"/>
                <tiles:put name="callerType" value="detail"/>
            </tiles:insert>
      </td>
                              </tr>
                          </table>
                       </FIELDSET>
                    </td>
                 </tr>
<%
}

MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
java.util.Locale locale = request.getLocale();
ArrayList selectedNodesBean = (ArrayList)testForm.getCurrentMembership(messages,locale);
//To make the boxes stay at a specific minimum size, we are going to add one at the bottom to provide a minimum size
if (!selectedNodesBean.contains("-------------------------------------------"))
	selectedNodesBean.add(selectedNodesBean.size(),"-------------------------------------------");

String hcName = testForm.getRefId();
pageContext.setAttribute("selectedNodesBean", selectedNodesBean);
%>


          <!-- INSERT THE MEMBERSHIP ROW HERE -->
		<% int numMembershipColumns = Integer.parseInt(numberOfColumns);
           if (numMembershipColumns > 0)
           		numMembershipColumns--;
	    	fieldLevelHelpTopic = topicKey + "membership"; 		
		%>

<tr>
   	<td class="table-text"  valign="top" nowrap>
      	<FIELDSET id="selectTemplate">
               	<legend for ="membership" TITLE="<bean:message key="healthclass.detail.membershipdescription"/>">
                 	<bean:message key="healthclass.details.membership"/>
               	</legend>
		

		<table class="framing-table" border="0" cellpadding="0" cellspacing="0" width="100%">										
			<tr>
				<td class="table-text">
					<table role="presentation">
						<tr>
							<td valign="top"> <span class="table-text"><center>
								<bean:message key="healthclass.details.membersOf" arg0="<%=hcName%>" />
								</center></span>
							</td>
						</tr>
						<tr>
							<td rowspan="2" valign="top"  class="table-text">
								<html:select multiple="true" size="7" property="notUsed">
									<html:options name="selectedNodesBean" />
								</html:select>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</fieldset>
	</td>
</tr>
      	<tr>
      	<td class="button-section">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons" id="navigation">
      	</td>
    	</tr>

		
        	</tbody>
    	</table>
	</html:form>

<%}
catch (Exception e) {
System.out.println("exception is " + e.toString());
e.printStackTrace();
}
%>
