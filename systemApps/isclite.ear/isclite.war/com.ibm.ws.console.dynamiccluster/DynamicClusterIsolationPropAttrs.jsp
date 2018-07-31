<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page import="java.util.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute  name="property" classname="java.lang.String"/>
<tiles:useAttribute  name="bean" classname="java.lang.String"/>

<tiles:useAttribute id="formBean" name="bean" classname="java.lang.String"/>
<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

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

<%
    String contextId = (String)request.getAttribute("contextId");
    AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
    String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

    String showNoneText = "none.text";

    boolean val = false;
    if (readOnly != null && readOnly.equals("true"))
        val = true;
    else if (SecurityContext.isSecurityEnabled()) {
		contextUri = contextUri.replaceFirst("dynamicclusters", "clusters");
        if ((adminAuthorizer.checkAccess(contextUri, "administrator")) || (adminAuthorizer.checkAccess(contextUri, "configurator"))) {
            val = false;
        }
        else {
            val = true;
        }
    }
%>

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
						<td class="table-text" nowrap>						
							<table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">						
								<tbody>
                               <tr valign="top">
                                   <td class="table-text" nowrap>
                                       <label for="NO_ISOLATION" TITLE="<bean:message key="dynamiccluster.isolation.no.isolation.required.desc"/>">
                                           <html:radio property="selectedStrictIsolationEnabled"
                                                       styleId="NO_ISOLATION"
                                                       value="none"
                                                       disabled="<%=val%>"
                                                       onclick="enableDisable('GROUP_ISOLATION:selectedIsolationGroup');clearIsolationGroupField();"
                                                       onkeypress="enableDisable('GROUP_ISOLATION:selectedIsolationGroup');clearIsolationGroupField();"/>
                                           <bean:message key="dynamiccluster.isolation.no.isolation.required"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                              </tr>
                              <tr valign="top">
                                   <td class="table-text" nowrap >
                                       <label for="STRICT_ISOLATION" TITLE="<bean:message key="dynamiccluster.isolation.strict.isolation.required.desc"/>">
                                           <html:radio property="selectedStrictIsolationEnabled"
                                                       styleId="STRICT_ISOLATION"
                                                       value="true"
                                                       disabled="<%=val%>"
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
                                                       disabled="<%=val%>"
                                                       onclick="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"
                                                       onkeypress="enableDisable('GROUP_ISOLATION:selectedIsolationGroup')"/>
                                           <bean:message key="dynamiccluster.isolation.group.isolation.required"/>&nbsp;&nbsp;
                                       </label>
                                   </td>
                              </tr>
						      <tr valign="top">
									<td class="complex-property" nowrap >												
										<div id="isolationBrowseDiv" style="display:block">
											<label for="selectedIsolationGroup" TITLE="<bean:message key="dynamiccluster.isolation.isolationGroup"/>">
												<bean:message key="dynamiccluster.isolation.isolationGroup"/>
											</label>
											<br>
											<html:text property="selectedIsolationGroup" size="15" styleId="selectedIsolationGroup" disabled="<%=val%>" styleClass="textEntry" />										
											[ <a for="ISOLATION_GROUP_LIST" id="selectedIsolationGroupLink" href="javascript:showSectionParent('1')">
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
									<legend class="cellSelectorLabel" title="<bean:message key="dynamiccluster.isolation.isolationGroups.description"/>">
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
															 align="top" alt="<bean:message key="dynamiccluster.isolation.isolationGroups.autofill" arg0="<%=isolationGroups[i]%>" />"
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


<script type="text/javascript" language="JavaScript">
function clearIsolationGroupField()
{
	document.getElementById("selectedIsolationGroup").value = "";
}

 enableDisable('GROUP_ISOLATION:selectedIsolationGroup');
</script>

