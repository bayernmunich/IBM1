<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004-2006 --%>
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
<%@ page language="java" import="com.ibm.ws.console.distmanagement.wizard.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.form.CreateDynamicClusterForm"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.utils.DynamicClusterConstants"%>


<tiles:useAttribute name="actionForm" classname="java.lang.String" />

<%// defect 126608

String descImage = "pluginId=com.ibm.ws.console.dynamiccluster";
String image = "";
String pluginId = "";
String pluginRoot = "";

if (descImage != "") {
	int index = descImage.indexOf("pluginId=");
	if (index >= 0) {
		pluginId = descImage.substring(index + 9);
		if (index != 0)
			descImage = descImage.substring(0, index);
		else
			descImage = "";
	} else {
		index = descImage.indexOf("pluginContextRoot=");
		if (index >= 0) {
			pluginRoot = descImage.substring(index + 18);
			if (index != 0)
				descImage = descImage.substring(0, index);
			else
				descImage = "";
		}
	}
}
%>

<style type="text/css">
a.tree { color: #000000; text-decoration: none; }
</style>

<script type="text/javascript" language="JavaScript">

function autofillIsolationGroup(isolationGroup) {
    objectId = "selectedIsolationGroup"

    if (document.getElementById(objectId) != null) {
    	document.getElementById(objectId).value = isolationGroup
    }
}

function showHideSection(sectionId) {
    if (document.getElementById(sectionId) != null) {
        if (document.getElementById(sectionId).style.display == "none") {
            document.getElementById(sectionId).style.display = "block";
            state = "display:block";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.dynamiccluster/images/minus_sign.gif";
            }
        } else {
            document.getElementById(sectionId).style.display = "none";
            state = "display:none";
            if (document.getElementById(sectionId+"Img")) {
                document.getElementById(sectionId+"Img").src = "/ibm/console/com.ibm.ws.console.dynamiccluster/images/plus_sign.gif";
            }
        }

		//uriState = "secure/javascriptToSession.jsp?req=set&sessionVariable=com_ibm_ws_"+sectionId+"&variableValue="+state;
		//setState = doXmlHttpRequest(uriState);
		//setState = setState.substring(0,setState.indexOf("+endTransmission"));
    }
}

function showSectionParent(isBrowseButton) {

    objectId = "isolationDCMemberDiv";
    objectIdStatic = "isolationBrowseDiv";

    //alert(window.name);

    if (document.getElementById(objectId) != null) {
		if (isBrowseButton == "1") {
   	        document.getElementById(objectId).style.display = "block";
		} else {
            document.getElementById(objectId).style.display = "none";
        }			
    }

    //getISize();
    //parent.adjustISize(window.name);

}

</script>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<%
CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterManagementForm");
boolean isODRServer = cdcf.isODRServer();
boolean disableMinInst = false;
if (isODRServer) {
	disableMinInst = true;
}
String membershipType = cdcf.getMembershipType();
%>
<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	<tbody>
    	<tr valign="top">
          	<td class="table-text" nowrap>
               <FIELDSET id="minimumInstances">
               <legend for ="minimumInstances" TITLE="<bean:message key="dynamiccluster.minimumInstances.description"/>">
                 <bean:message key="dynamiccluster.minimum.instances"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                           <tbody>
                               <tr valign="top">
                                   <td class="table-text">
                                       <label for="MINIMUM_INSTANCES_ZERO">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_ZERO"
                                                       value="MINIMUM_INSTANCES_ZERO"
                                                       disabled="<%=disableMinInst%>"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                       </label>
                                   </td>
                                   <td class="table-text" >
                                           <bean:message key="dynamiccluster.minimum.instances.zero"/>&nbsp;&nbsp;
			            		   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap colspan="2">
                                   <label for="selectedServerInactivityTime">
                                       <bean:message key="dynamiccluster.minimum.instances.waittime"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedServerInactivityTime"
                                              size="15"
                                              styleId="selectedServerInactivityTime"
                                              styleClass="textEntry" /> <bean:message key="dynamiccluster.minimum.instances.minutes"/>&nbsp;&nbsp;
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="table-text" nowrap colspan="2">
                                       <label for="MINIMUM_INSTANCES_ONE">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_ONE"
                                                       value="MINIMUM_INSTANCES_ONE"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                           <bean:message key="dynamiccluster.minimum.instances.one"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="table-text" nowrap colspan="2">
                                       <label for="MINIMUM_INSTANCES_MULTIPLE">
                                           <html:radio property="selectedMinInstances"
                                                       styleId="MINIMUM_INSTANCES_MULTIPLE"
                                                       value="MINIMUM_INSTANCES_MULTIPLE"
                                                       onclick="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"
                                                       onkeypress="enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances')"/>
                                           <bean:message key="dynamiccluster.minimum.instances.multiple"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap colspan="2">
                                   <label for="selectedMinimumNumberInstances">
                                       <bean:message key="dynamiccluster.number.instances"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedMinimumNumberInstances"
                                              size="15"
                                              styleId="selectedMinimumNumberInstances"
                                              styleClass="textEntry" />
                                   </td>
                               </tr>
			</table>
		</FIELDSET>
          </td>
     </tr>
    	<tr valign="top">
          	<td class="table-text" nowrap>
               <FIELDSET id="maximumInstances">
               <legend for ="maximumInstances" TITLE="<bean:message key="dynamiccluster.maximumInstances.description"/>">
                 <bean:message key="dynamiccluster.maximum.instances"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                           <tbody>
                               <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="MAXIMUM_INSTANCES_LIMIT">
                                           <html:radio property="selectedMaxInstances"
                                                       styleId="MAXIMUM_INSTANCES_LIMIT"
                                                       value="MAXIMUM_INSTANCES_LIMIT"
                                                       onclick="enableDisable('MAXIMUM_INSTANCES_LIMIT:selectedMaximumNumberInstances,MAXIMUM_INSTANCES_NOLIMIT')"
                                                       onkeypress="enableDisable('MAXIMUM_INSTANCES_LIMIT:selectedMaximumNumberInstances,MAXIMUM_INSTANCES_NOLIMIT')"/>
                                           <bean:message key="dynamiccluster.maximum.instances.limit"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap>
                                   <label for="selectedMaximumNumberInstances">
                                       <bean:message key="dynamiccluster.number.instances"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedMaximumNumberInstances"
                                              size="15"
                                              styleId="selectedMaximumNumberInstances"
                                              styleClass="textEntry" />
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="MAXIMUM_INSTANCES_NOLIMIT">
                                           <html:radio property="selectedMaxInstances"
                                                       styleId="MAXIMUM_INSTANCES_NOLIMIT"
                                                       value="MAXIMUM_INSTANCES_NOLIMIT"
                                                       onclick="enableDisable('MAXIMUM_INSTANCES_LIMIT:selectedMaximumNumberInstances,MAXIMUM_INSTANCES_NOLIMIT')"
                                                       onkeypress="enableDisable('MAXIMUM_INSTANCES_LIMIT:selectedMaximumNumberInstances,MAXIMUM_INSTANCES_NOLIMIT')"/>
                                           <bean:message key="dynamiccluster.maximum.instances.nolimit"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
			</table>
		</FIELDSET>
          </td>
     </tr>
     <% if (membershipType.equals(DynamicClusterConstants.OPMODE_AUTOMATIC)) { %>
    	<tr valign="top">
          	<td class="table-text" nowrap>
               <FIELDSET id="verticalStacking">
               <legend for ="verticalStacking" TITLE="<bean:message key="dynamiccluster.verticalStacking.description"/>">
                 <bean:message key="dynamiccluster.verticalStacking.instances"/>
               </legend>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
                           <tbody>
                               <tr valign="top">
                                   <td class="table-text" nowrap >
                                       <label for="VERTICALSTACKING_INSTANCES_ALLOW">
                                           <html:checkbox property="selectedVerticalStackingInstances"
                                                       styleId="VERTICALSTACKING_INSTANCES_ALLOW"
                                                       value="true"
                                                       onclick="enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances')"
                                                       onkeypress="enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances')"/>
                                           <bean:message key="dynamiccluster.verticalStacking.allow"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                               </tr>
                               <tr valign="top">
                                   <td class="complex-property" nowrap>
                                   <label for="selectedVerticalStackingNumberInstances">
                                       <bean:message key="dynamiccluster.number.instances"/>
                                   </label>
                                   <br>
                                   <html:text property="selectedVerticalStackingNumberInstances"
                                              size="15"
                                              styleId="selectedVerticalStackingNumberInstances"
                                              styleClass="textEntry"/>
                                   </td>
                               </tr>
				</table>
			</FIELDSET>
		</td>
    </tr>
    <% } %>

	<tr valign="top">
		<td class="table-text" nowrap>
			<FIELDSET id="isolation">
				<legend for ="isolation" TITLE="<bean:message key="dynamiccluster.isolation.description"/>">
					<bean:message key="dynamiccluster.isolation"/>
				</legend>

				<%
					String  handShow = "none";
					String  quickEdit = "block";
				%>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
					<tbody>
					<tr valign="top">
						<td class="table-text" nowrap >						
							<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">						
								<tbody>
                               <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="NO_ISOLATION" TITLE="<bean:message key="dynamiccluster.isolation.no.isolation.required.desc"/>">
                                           <html:radio property="selectedStrictIsolationEnabled"
                                                       styleId="NO_ISOLATION"
                                                       value="none"
                                                       onclick="enableDisable('GROUP_ISOLATION:selectedIsolationGroup');clearIsolationGroupField();"
                                                       onkeypress="enableDisable('GROUP_ISOLATION:selectedIsolationGroup');clearIsolationGroupField();"/>
                                           <bean:message key="dynamiccluster.isolation.no.isolation.required"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                              </tr>
                              <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="STRICT_ISOLATION" TITLE="<bean:message key="dynamiccluster.isolation.strict.isolation.required.desc"/>">
                                           <html:radio property="selectedStrictIsolationEnabled"
                                                       styleId="STRICT_ISOLATION"
                                                       value="true"
                                                       onclick="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"
                                                       onkeypress="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"/>
                                           <bean:message key="dynamiccluster.isolation.strict.isolation.required"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                              </tr>
                              <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="GROUP_ISOLATION" TITLE="<bean:message key="dynamiccluster.isolation.group.isolation.required.desc"/>">
                                           <html:radio property="selectedStrictIsolationEnabled"
                                                       styleId="GROUP_ISOLATION"
                                                       value="false"
                                                       onclick="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"
                                                       onkeypress="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"/>
                                           <bean:message key="dynamiccluster.isolation.group.isolation.required"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                              </tr>								
							  <tr valign="top">
									<td class="complex-property" nowrap>												
										<div id="isolationBrowseDiv" style="display:block">
											<label for="selectedIsolationGroup" TITLE="<bean:message key="dynamiccluster.isolation.isolationGroup"/>">
												<bean:message key="dynamiccluster.isolation.isolationGroup"/>
											</label>
											<br>
											<html:text property="selectedIsolationGroup" size="15" styleId="selectedIsolationGroup" styleClass="textEntry" />										
											[ <a id="selectedIsolationGroupLink" href="javascript:showSectionParent('1')">
												<bean:message key="button.browse"/></a> ]											
										</div>										
									</td>
								</tr>
								</tbody>
							</table>
						</td>
						<td class="table-text" nowrap>
							<div id="isolationDCMemberDiv" style="display:<%=handShow%>;z-index:101;background-color:white" >
								<fieldset>
									<legend title="<bean:message key="dynamiccluster.isolation.isolationGroups.description"/>" class="cellSelectorLabel">
										<bean:message key="dynamiccluster.isolation.isolationGroups"/>
									</legend>
									<table cellpadding="5" cellspacing="0" role="presentation">
										<tr>
											<td class="table-text" VALIGN="top">
												<bean:message key="dynamiccluster.isolation.isolationGroups.label"/><br /><br />
												<%
													com.ibm.ws.sm.workspace.WorkSpace wksp = (com.ibm.ws.sm.workspace.WorkSpace)session.getAttribute(Constants.WORKSPACE_KEY);
													String[] isolationGroups = com.ibm.ws.xd.config.dc.util.DynamicClusterConfigUtil.getIsolationGroups(wksp);
													if (isolationGroups.length != 0) {														
													for (int i = 0; i<isolationGroups.length; i++) {
												%>	
												<a href="javascript:showHideSection('<%=isolationGroups[i]%>')" class="tree">
					    						    <img id="<%=isolationGroups[i]%>Img" border="0" align="top" src="/ibm/console/com.ibm.ws.console.dynamiccluster/images/plus_sign.gif" />
												    <%=isolationGroups[i]%>
													<a id="<%=isolationGroups[i]%>Link" href="javascript:autofillIsolationGroup('<%=isolationGroups[i]%>')">
														<img id="<%=isolationGroups[i]%>UpdateImg" border="0"
															 align="top" alt="<bean:message key="dynamiccluster.isolation.isolationGroups.autofill" arg0="<%=isolationGroups[i]%>"/>"
															 src="/ibm/console/com.ibm.ws.console.dynamiccluster/images/autofillArrow.gif" /></a>
												    <br />
												</a>
		
												<div id="<%=isolationGroups[i]%>" style="display:none">
												<%
													String[] dcNames = com.ibm.ws.xd.config.dc.util.DynamicClusterConfigUtil.getDynamicClusterNames(wksp, isolationGroups[i]);
													for (int j = 0; j<dcNames.length; j++) {														
												%>
													&nbsp;&nbsp;&nbsp;&nbsp;
													<img id="<%=dcNames[j]%>Img" border="0" align="middle" src="/ibm/console/com.ibm.ws.console.dynamiccluster/images/dcIcon.gif" />
													<%=dcNames[j]%><br/>
												<%										
													}
												%>
												</div>
												<%
													} //for isolationGroups
													} else { //if isolationGroups.length == 0
												%>		<bean:message key="dynamiccluster.isolation.isolationGroups.none"/><br />
												<%
													}
												%>
												
												[ <a id="quickEditLink" href="javascript:showSectionParent('0')">
													<bean:message key="dynamiccluster.button.close"/></a> ]
											<td>
										</tr>
									</table>
								</fieldset>
							</div>
						</td>																		
					</tr>
					</tbody>
				</table>								
			</FIELDSET>
		</td>
	</tr>
	</tbody>
</table>

<script type="text/javascript" language="JavaScript">

function clearIsolationGroupField()
{
	document.getElementById("selectedIsolationGroup").value = "";
}

    /**
     * Enable and disable the fields associated with the minimum, maximum and vertical stacking instances type when
     * the page is initially loaded.
     */
     enableDisable('MINIMUM_INSTANCES_ZERO:selectedServerInactivityTime,MINIMUM_INSTANCES_ONE,MINIMUM_INSTANCES_MULTIPLE:selectedMinimumNumberInstances');
     enableDisable('MAXIMUM_INSTANCES_LIMIT:selectedMaximumNumberInstances,MAXIMUM_INSTANCES_NOLIMIT');
     enableDisable('VERTICALSTACKING_INSTANCES_ALLOW:selectedVerticalStackingNumberInstances');
     enableDisable('GROUP_ISOLATION:selectedIsolationGroup');

</script>
