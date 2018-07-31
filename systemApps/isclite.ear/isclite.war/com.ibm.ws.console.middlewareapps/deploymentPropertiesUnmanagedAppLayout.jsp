<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006, 2008 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.console.middlewareapps.form.InstallMiddlewareAppForm" %>

<%@ page language="java" import="com.ibm.ws.console.middlewareapps.*" %>

<tiles:useAttribute name="actionForm" classname="java.lang.String"/>

<!-- Action Form = <%=actionForm%> -->

<%--
<%
    String descImage = "pluginId=com.ibm.ws.console.middlewareapps";
    String image = "";
    String pluginId = "";
    String pluginRoot = "";

    if (descImage != "") {
        int index = descImage.indexOf("pluginId=");
        if (index >= 0) {
            pluginId = descImage.substring(index + 9);
            if (index != 0) {
                descImage = descImage.substring(0, index);
            } else {
                descImage = "";
            }
        } else {
            index = descImage.indexOf("pluginContextRoot=");
            if (index >= 0) {
                pluginRoot = descImage.substring(index + 18);
                if (index != 0) {
                    descImage = descImage.substring(0, index);
                } else {
                    descImage = "";
                }
            }
        }
    }
%>

<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>
--%>

<script language="JavaScript">
var changing = false;
var selectedAvailableTargets; // Array of Currently Selected Available Targets
var selectedCurrentTargets; // Array of Currently Selected Deployment Targets
var selectedModuleGroups;
var selectedVirtualGroups;
var selectedContextRootGroups;
var selectedDeploymentTargetGroups;
var availTargets;
var currentTargets;
var inited = false;
var filterValue;
var originalTargets;  // Array of All Targets Available Initially

function initVars() {
    if (inited) {
        return;
    }

    changing = false;
    selectedAvailableTargets = new Array(); // Currently Selected Available Targets
    selectedCurrentTargets = new Array(); // Currently Selected Deployment Targets
    selectedModuleGroups = new Array();
    selectedVirtualGroups = new Array();
    selectedContextRootGroups = new Array();
    selectedDeploymentTargetGroups = new Array();
    
    originalTargets = new Array();
    availTargets = document.forms[0].availableTargets;
    currentTargets = document.forms[0].currentTargets;
    filterValue = document.forms[0].filter;
    inited = true;
}

function addClicked(optionsToAdd) {
    if (optionsToAdd.length > 0) {
        var optionsToAddString = "";

        for (var x = 0; x < optionsToAdd.length; x++) {
            if (optionsToAdd[x].value != "----------------------------------------") {
                optionsToAddString = optionsToAddString + ";;" + optionsToAdd[x].value;
            }
        }

        if (optionsToAddString.length != 0) {
            var moduleName = document.forms[0].moduleName.value;
            var contextRoot = document.forms[0].contextRoot.value;
            var selectedVirtualHost = document.forms[0].selectedVirtualHost.value;

            optionsToAddString = optionsToAddString.substring(2); // Remove the 1st 2 ";;"
            window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddClicked=true" + "&moduleName=" + encodeURI(moduleName) + "&contextRoot=" + encodeURI(contextRoot) + "&selectedVirtualHost" + encodeURI(selectedVirtualHost) + "&TargetsToAdd=" + encodeURI(optionsToAddString)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
		}
	}
}

function removeClicked(optionsToRemove) {
    if (optionsToRemove.length > 0) {
        var optionsToRemoveString = "";

        for (var x = 0; x < optionsToRemove.length; x++) {
            if (optionsToRemove[x].value != "----------------------------------------") {
                optionsToRemoveString = optionsToRemoveString + ";;" + optionsToRemove[x].value;
            }
        }

        if (optionsToRemoveString.length != 0) {
            var moduleName = document.forms[0].moduleName.value;
            var contextRoot = document.forms[0].contextRoot.value;
            var selectedVirtualHost = document.forms[0].selectedVirtualHost.value;

            optionsToRemoveString = optionsToRemoveString.substring(2); // Remove the 1st 2 ";;"
            window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?RemoveClicked=true" + "&moduleName=" + encodeURI(moduleName) + "&contextRoot=" + encodeURI(contextRoot) + "&selectedVirtualHost" + encodeURI(selectedVirtualHost) + "&TargetsToRemove=" + encodeURI(optionsToRemoveString)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
        }
    }
}

function filterTargets() {
    var filterValueString = trimString(document.forms[0].filter.value);

	if (filterValueString.length > 0) {
	    if (filterValueString == "Name") {
            var nameFilterCell = document.getElementById("NameFilterCell");
            nameFilterCell.style.display = "block";
        } else {
            window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddFilter=true" + "&NewFilterValue=" + encodeURI(filterValueString)
               + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
        }
	}
}

function nameFilterClicked() {
    window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddNameFilter=true"
        + "&NewNameFilterValue=" + encodeURI(document.forms[0].nameFilter.value)
        + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
        // + "&moduleToAdd=" + encodeURI(moduleName)
        // + "&contextRootToAdd=" + encodeURI(contextRoot)
        // + "&virtualHostToAdd=" + encodeURI(selectedVirtualHost));
}

/**
    Set the Global selectedTargets Arrays to correspond with the
    Selected Objects in the Box represented by 'targetList' (either currentTargets or availTargets)
**/
function setSelectedTargets(targetsList, selectedTargets) {
    changing = true;
    empty(targetsList);

    var numSelected = 0;	
    var itemSelected;

    if (selectedTargets.selectedIndex != -1) {
        var index = 0;
        var str;

        for (var x = 0; x < selectedTargets.options.length; x++) {
            if (selectedTargets.options[x].selected) {
                targetsList[index++] = selectedTargets.options[x]; // Copy a Reference to this Field into List of Selected Targets
                itemSelected = selectedTargets.options[x].value;
                numSelected = numSelected + 1;
            }
        }
    }

    var tempString = "";
    first = true;
    for (var y = 0; y < targetsList.length; y++) {
        if (!first) {
            tempString += "!";
        }

        tempString += targetsList[y].value;
        first = false;
    }

    changing = false;
}

/**
    Removes all Elements from the 'targetsList' Array
**/
function empty(targetsList) {
    for (x = 0; x < targetsList.length; x++) {
        targetsList.pop();
    }
}

/**
    Removes Leading and Trailing Whitespace from a String
**/
function trimString(string) {
    var s = string.replace(/^\s + /g, ""); // Remove Leading Whitespace
    return s.replace(/\s + $/g, ""); // Remove Leading Whitespace
}

/**
   Add the modules to the list of modules 
**/
function addModuleClicked() {
	var moduleName = document.forms[0].moduleName.value;
    var contextRoot = document.forms[0].contextRoot.value;
    var selectedVirtualHost = document.forms[0].selectedVirtualHost.value;
    var currentTargets = document.forms[0].currentTargets;
    var targets ="";
    
    var defaultName = "";
    var defaultcontextRoot = "/";
    var defaultVirtualHost = "default_host";
            
    for (var x = 0; x < currentTargets.length; x++) {
        if (currentTargets[x].value != "----------------------------------------") {
            targets = targets + ";;" + currentTargets[x].value;
        }
    }

	if ((moduleName != "") && (availTargets.length !=0)) {
    	window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddModuleClicked=true" 
    	+ "&moduleToAdd=" + encodeURI(moduleName) 
    	+ "&contextRootToAdd=" + encodeURI(contextRoot) 
    	+ "&virtualHostToAdd=" + encodeURI(selectedVirtualHost)
    	+ "&deploymentTargetsToAdd=" + encodeURI(targets)
        + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
	}
}

function removeModuleClicked() {
}

function catchEnter(e) {
    if (window.event) {
    // IE
        keycode = e.keyCode;
    } else if (e.which) {
    // Firefox
        keycode = e.which;
    }

    // if (!e) var e = window.event;
    // if (e.keyCode) code = e.keyCode;
    // else if (e.which) code = e.which.keyCode;

    if (keycode == 13) {
        // window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddNameFilter=true" + "&NewNameFilterValue=" + encodeURI(document.forms[0].nameFilter.value));
        window.location = encodeURI("/ibm/console/InstallUnmanagedWizDeploy.do?AddNameFilter=true"
            + "&NewNameFilterValue=" + encodeURI(document.forms[0].nameFilter.value)
            + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
            // + "&moduleToAdd=" + encodeURI(moduleName)
            // + "&contextRootToAdd=" + encodeURI(contextRoot)
            // + "&virtualHostToAdd=" + encodeURI(selectedVirtualHost));

        return false;
    } else {
        return true;
    }
}
</script>

<%
    String availTargetsChange = "initVars(this);setSelectedTargets(selectedAvailableTargets,availTargets)";
    String currTargetsChange = "initVars(this);setSelectedTargets(selectedCurrentTargets,currentTargets)";
    String removeButtonClicked = "initVars(this);removeClicked(selectedCurrentTargets)";
    String addButtonClicked = "initVars(this);addClicked(selectedAvailableTargets)";
    String filterClicked = "initVars(this);filterTargets()";

    String addTargetClicked = "initVars(this);addModuleClicked()";
    String nameFilterClicked = "nameFilterClicked()";

    InstallMiddlewareAppForm theForm = (InstallMiddlewareAppForm) session.getAttribute("InstallUnmanagedWizDeployForm");
    ArrayList currentTargets = theForm.getCurrentTargets();
    ArrayList availableTargets = theForm.getAvailableTargets();

    // To make Boxes to stay at a Minimum Size (= 40 Chars) ..
    if (!currentTargets.contains("----------------------------------------")) {
        currentTargets.add(currentTargets.size(), "----------------------------------------");
    }
 
    if (!availableTargets.contains("----------------------------------------")) {
        availableTargets.add(availableTargets.size(), "----------------------------------------");
    }

    pageContext.setAttribute("availableTargets", availableTargets);
    pageContext.setAttribute("currentTargets", currentTargets);

    String nameFilter = theForm.getNameFilter();
    String nameFilterDisplay = "display:none";
    String nameFilterValue = "";

	String filterType;
	if (theForm.getFilterType() != null) {
	    filterType = theForm.getFilterType();
    } else {
        filterType = "";
    }

    if ((nameFilter != null) && filterType.equals("Name")) {
        nameFilterDisplay = "display:block";
        nameFilterValue = nameFilter;
    }
%>

<table border="0" cellpadding="3" cellspacing="3" width="100%" role="presentation">
    <tr valign="top">
        <td class="table-text">
            <span class="requiredField">
                <label for="moduleName" title='<bean:message key="middlewareapps.deploy.moduleName.description"/>'>
                    <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                    <bean:message key="middlewareapps.deploy.moduleName"/>
                </label>
            </span>
            <br/>
            <html:text property="moduleName" size="25" styleClass="textEntryRequired" styleId="moduleName"/>
        </td>
    </tr>

    <tr valign="top">
        <td class="table-text">
            <span class="requiredField">
                <label for="contextRoot" title='<bean:message key="middlewareapps.deploy.contextRoot.description"/>'>
                    <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                    <bean:message key="middlewareapps.deploy.contextRoot"/>
                </label>
            </span>
            <br/>
            <html:text property="contextRoot" size="25" styleClass="textEntryRequired" styleId="contextRoot"/>
        </td>
    </tr>

    <tr valign="top">
        <td class="table-text">
            <span class="requiredField">
                <label for="virtualHost" title='<bean:message key="middlewareapps.deploy.virtualHost.description"/>'>
                    <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                    <bean:message key="middlewareapps.deploy.virtualHost"/>
                </label>
            </span>
            <br/>

            <html:select property="selectedVirtualHost" styleId="virtualHost">
            <logic:iterate id="virtualHost" name="<%=actionForm%>" property="virtualHostList">
                <html:option value="<%=(String) virtualHost%>">
                    <%=(String) virtualHost%>
                </html:option>
            </logic:iterate>
            </html:select>
        </td>
    </tr>

    <tr valign="top">
        <td class="table-text" nowrap>
           
            <table border="0" cellspacing="0" role="presentation">
                <tr valign="top">
                    <td class="table-text">
                        <span class="requiredField">
                            <label title='<bean:message key="middlewareapps.deploy.deploymentTargets.description"/>'>
                                <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt='<bean:message key="information.required"/>'>
                                <bean:message key="middlewareapps.deploy.deploymentTargets"/>
                            </label>
                        </span>
                    </td>
                </tr>

                <tr valign="top">
                    <td class="table-text">
                        <label for="filter" title='<bean:message key="middlewareapps.deploy.filter.description"/>'>
                            <bean:message key="middlewareapps.deploy.filter"/>:
                        </label>
                    </td>
                </tr>

                <tr valign="top">
                    <td class="table-text">
                        <select name="filter" id="filter" onchange="<%=filterClicked%>">
                            <% if (filterType.equals("") || filterType.equals("None")) { %>
                                <option selected value="None"><bean:message key="middlewareapps.deploy.filter.none"/></option>
                            <% } else { %>
                                <option value="None"><bean:message key="middlewareapps.deploy.filter.none"/></option>
                            <% } %>

                            <% if (filterType.equals("Clusters")) { %>
                                <option selected value="Clusters"><bean:message key="middlewareapps.deploy.filter.clusters"/></option>
                            <% } else { %>
                                <option value="Clusters"><bean:message key="middlewareapps.deploy.filter.clusters"/></option>
                            <% } %>

                            <% if (filterType.equals("Servers")) { %>
                                <option selected value="Servers"><bean:message key="middlewareapps.deploy.filter.servers"/></option>
                            <% } else { %>
                                <option value="Servers"><bean:message key="middlewareapps.deploy.filter.servers"/></option>
                            <% } %>

                            <% if (filterType.equals("Name")) { %>
                                <option selected value="Name"><bean:message key="middlewareapps.deploy.filter.name"/></option>
                            <% } else { %>
                                <option value="Name"><bean:message key="middlewareapps.deploy.filter.name"/></option>
                            <% } %>
                        </select>
                    </td>
                    <%-- 
                    <td class="table-text" id="NameFilterCell" style="<%=nameFilterDisplay%>">
                        <html:text property="nameFilter" size="10" styleClass="textEntry" styleId="nameFilter" onchange="<%=nameFilterClicked%>" value="<%=nameFilterValue%>"/>
                    </td>
                    --%>
                    <td class="table-text" id="NameFilterCell" style="<%=nameFilterDisplay%>">
						<label for="nameFilter" title="<bean:message key="middlewareapps.deploy.filter.name.description"/>">
							<html:text property="nameFilter" size="10" styleClass="textEntry" styleId="nameFilter" value="<%=nameFilterValue%>" onkeydown="return catchEnter(event)"/>
							<html:button property="notUsed" styleClass="buttons_other" onclick="<%=nameFilterClicked%>">
								<bean:message key="middlewareapps.button.go"/>
							</html:button>
						</label>
					</td>
                </tr>
			</table>
            <table width="100%" border="0" cellspacing="0" cellpadding="3" role="presentation">
                <tr valign="top">
                    <td class="table-text" valign="top">
                    	<label for="availableTargets" class="hidden">
                    		<bean:message key="middlewareapps.deploy.deploymentTargets.available"/>
                        </label>
                        <label class="collectionLabel" title="<bean:message key="middlewareapps.deploy.deploymentTargets.available"/>">
	                        <html:select multiple="true" size="8" property="notUsed" styleId="availableTargets" onchange="<%=availTargetsChange%>">
	                            <html:options name="availableTargets"/>
	                        </html:select>
                        </label>
                    </td>
                    <td class="table-text" align="center" valign="middle" cellpadding="10" width="30%">
                        <html:button styleClass="buttons_other" property="notUsed" onclick="<%=addButtonClicked%>">
                            <bean:message key="workclass.button.add"/>
                        </html:button>
                        <br/><br/>
                        <html:button styleClass="buttons_other" property="notUsed" onclick="<%=removeButtonClicked%>">
                            <bean:message key="workclass.button.remove"/>
                        </html:button>
                    </td>
                    <td class="table-text" valign="top">
                    	<label for="currentTargets" class="hidden">
                    		<bean:message key="middlewareapps.deploy.deploymentTargets.current"/>
                        </label>
                        <label class="collectionLabel" title="<bean:message key="middlewareapps.deploy.deploymentTargets.current"/>">
	                        <html:select multiple="true" size="8" property="notUsed" styleId="currentTargets" onchange="<%=currTargetsChange%>">
	                            <html:options name="currentTargets"/>
	                        </html:select>
	                    </label>
                    </td>
                </tr>
                
		   		<tr valign="top">
   					<td class="table-text" valign="top">
   						<html:button styleClass="buttons_other" property="notUsed" onclick="<%=addTargetClicked%>">
                        	<bean:message key="button.apply"/>
                      	</html:button>
   					</td>
		   		</tr>
            </table>

        </td>
    </tr>
</table>
