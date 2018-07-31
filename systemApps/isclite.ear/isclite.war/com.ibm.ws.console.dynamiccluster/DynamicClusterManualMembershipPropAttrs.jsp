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
<%@ page language="java" import="com.ibm.ws.console.distmanagement.wizard.*"%>
<%@ page language="java" import="com.ibm.websphere.management.metadata.*"%>
<%@ page language="java" import="com.ibm.ws.sm.workspace.RepositoryContext"%>
<%@ page language="java" import="com.ibm.ws.console.core.Constants"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.form.CreateDynamicClusterForm"%>
<%@ page language="java" import="com.ibm.ws.console.dynamiccluster.utils.DynamicClusterConstants"%>
<%@ page language="java" import="com.ibm.ws.console.core.utils.VersionHelper"%>
<%@ page language="java" import="com.ibm.ws.console.distmanagement.DistHelper"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<bean:define id="nodes" name="<%=actionForm%>" property="nodePath"/>
<%
    // Get the cell name
    String cellName = ((RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY)).getName();

    // Get localized (none) message to place in the pulldowns
    ServletContext servletContext = (ServletContext) pageContext.getServletContext();
    MessageResources messages = (MessageResources) servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
    String noneText = messages.getMessage(request.getLocale(),"none.text");

    // Get node version helper
    VersionHelper versionHelper = new VersionHelper(cellName, messages, request.getLocale());

    // Determine which wizard is running (cluster wizard or cluster member wizard)
    //String wizardType = (String)session.getAttribute("com.ibm.ws.console.distmanagement.wizard.type");

    // Determine if there is at least one ZOS node in the list of nodes
    boolean nodeListContainsZOSNode = DistHelper.containsZosNode((ArrayList)nodes, cellName);
%>

<script language="JavaScript">
function manualMemberTypeChanged() {
  //When the server type is changed show/hide name.
  // var manualMemberType = document.forms[0].manualMemberType.value

  var templateDiv="templatesDiv";
  var serverDiv="serversDiv";
  var commonDiv="commonDiv";
  var multiServerDiv="multiServersDiv";


  // if (manualMemberType == "<%=DynamicClusterConstants.MEMBER_SERVER_TEMPLATE%>") {
  //     //document.getElementById(templateDiv).style.display = "block";
  //     //document.getElementById(serverDiv).style.display = "none";
  //     //document.getElementById(commonDiv).style.display = "block";
  //     //document.getElementById(multiServerDiv).style.display = "none";
  // } else if (manualMemberType == "<%=DynamicClusterConstants.MEMBER_EXISTING_SERVER%>") {
  //     //document.getElementById(templateDiv).style.display = "none";
  //     //document.getElementById(serverDiv).style.display = "none";
  //     //document.getElementById(commonDiv).style.display = "none";
  //     //document.getElementById(multiServerDiv).style.display = "block";
  // }  else if (manualMemberType == "<%=DynamicClusterConstants.MEMBER_EXISTING_SERVER_TEMPLATE%>") {
  //     //document.getElementById(templateDiv).style.display = "none";
  //     //document.getElementById(serverDiv).style.display = "block";
  //     //document.getElementById(commonDiv).style.display = "block";
  //     //document.getElementById(multiServerDiv).style.display = "none";
  // }

  document.getElementById(multiServerDiv).style.display = "block";
}
</script>

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

CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterManagementForm");
boolean isForeignServer = cdcf.isForeignServer();
String membershipType = cdcf.getMembershipType();
String manualType = cdcf.getManualType();
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<script type="text/javascript" language="JavaScript">

    /* nodesAndTypeValues contains a HashMap of the available nodes and associated with each node
       is the node type.  The Node Name is the key and the Node Type is the value in the HashMap
       entry.  The possible node types are:
               "distributed"
               "os390"
               "all"
     */
	<%HashMap nodesAndTypeValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.available.nodes.and.type");%>
        var distributedNodeType = "distributed";
        var zosNodeType = "os390";
        var allNodeType = "all";

    /* Set up the Nodes and their associated Types on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */
	var nodesAndTypeMapKey = new Array(<%=nodesAndTypeValues.size()%>);
	var nodesAndTypeMapValue = new Array(<%=nodesAndTypeValues.size()%>);

    <%
        Iterator keyIterator = nodesAndTypeValues.keySet().iterator();
        for (int i = 0; i < nodesAndTypeValues.size(); i++) {
            String nodeName1 = (String) keyIterator.next();
            String nodeType1 = (String) nodesAndTypeValues.get(nodeName1);
    %>
            nodesAndTypeMapKey[<%=i%>] = "<%=nodeName1%>";
            nodesAndTypeMapValue[<%=i%>] = "<%=nodeType1%>";
    <%
        }
    %>

    /* nodesAndVersionValues contains a HashMap of the available nodes and associated with each node
       is the node's version.  The Node Name is the key and the Node Version is the value in the HashMap
       entry.
     */
	<%HashMap nodesAndVersionValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.available.nodes.and.version");%>

    /* Set up the Nodes and their associated Versions on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */
	var nodesAndVersionMapKey = new Array(<%=nodesAndVersionValues.size()%>);
	var nodesAndVersionMapValue = new Array(<%=nodesAndVersionValues.size()%>);

    <%
        Iterator keyIterator2 = nodesAndVersionValues.keySet().iterator();
        for (int i = 0; i < nodesAndVersionValues.size(); i++) {
            String nodeName3 = (String) keyIterator2.next();
            String version3 = (String) nodesAndVersionValues.get(nodeName3);
    %>
            nodesAndVersionMapKey[<%=i%>] = "<%=nodeName3%>";
            nodesAndVersionMapValue[<%=i%>] = "<%=version3%>";
    <%
        }
    %>

    /* nodeTypesAndTemplates contains a HashMap of the node types and associated with each node
       type is an ArrayList of the templates associated with the node type.  The Node Type is the key
       and an ArrayList of Template Names is the value for entries in the HashMap.
     */
	<%HashMap nodeTypesAndTemplatesValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.nodetypes.and.templates");%>

    /* Set up the node types and associated ArrayList of the templates on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */
	var nodeTypesAndTemplatesMapKey = new Array(<%=nodeTypesAndTemplatesValues.size()%>);
	var nodeTypesAndTemplatesMapValue = new Array(<%=nodeTypesAndTemplatesValues.size()%>);

    <%
        Iterator keyIter = nodeTypesAndTemplatesValues.keySet().iterator();
        for (int i = 0; i < nodeTypesAndTemplatesValues.size(); i++) {
            String nodeType2 = (String) keyIter.next();
            ArrayList templateArray = (ArrayList) nodeTypesAndTemplatesValues.get(nodeType2);
    %>
            var listOfTemplates = new Array(<%=templateArray.size()%>);
    <%
            int j=0;
            Iterator templatesIterator = templateArray.iterator();
            while (templatesIterator.hasNext()){
                String templName = (String)templatesIterator.next();
     %>
                listOfTemplates[<%=j%>] = "<%=templName%>";
     <%
                j++;
           }
    %>
            nodeTypesAndTemplatesMapKey[<%=i%>] = "<%=nodeType2%>";
            nodeTypesAndTemplatesMapValue[<%=i%>] = listOfTemplates;
    <%
        }
    %>

    /* versionsAndTemplates contains a HashMap of the versions and associated with each
       version is an ArrayList of the templates associated with the version.  The Version is the key
       and an ArrayList of Template Names is the value for entries in the HashMap.
     */
	<%HashMap versionsAndTemplatesValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.versions.and.templates");%>

    /* Set up the versions and associated ArrayList of the templates on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */
	var versionsAndTemplatesMapKey = new Array(<%=versionsAndTemplatesValues.size()%>);
	var versionsAndTemplatesMapValue = new Array(<%=versionsAndTemplatesValues.size()%>);

    <%
        Iterator keyIter2 = versionsAndTemplatesValues.keySet().iterator();
        for (int i = 0; i < versionsAndTemplatesValues.size(); i++) {
            String version4 = (String) keyIter2.next();
            ArrayList templateArray2 = (ArrayList) versionsAndTemplatesValues.get(version4);
    %>
            var listOfTemplates2 = new Array(<%=templateArray2.size()%>);
    <%
            int l=0;
            Iterator templatesIterator2 = templateArray2.iterator();
            while (templatesIterator2.hasNext()){
                String templName2 = (String)templatesIterator2.next();
     %>
                listOfTemplates2[<%=l%>] = "<%=templName2%>";
     <%
                l++;
           }
    %>
            versionsAndTemplatesMapKey[<%=i%>] = "<%=version4%>";
            versionsAndTemplatesMapValue[<%=i%>] = listOfTemplates2;
    <%
        }
    %>


    /* versionsAndServers contains a HashMap of the versions and associated with each
       version is an ArrayList of the servers associated with the version.  The Version is the key
       and an ArrayList of Server Names is the value for entries in the HashMap.
     */
	<%HashMap versionsAndServersValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.versions.and.servers");%>

    /* Set up the versions and associated ArrayList of the servers on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */

	var versionsAndServersMapKey = new Array(<%=versionsAndServersValues.size()%>);
	var versionsAndServersMapValue = new Array(<%=versionsAndServersValues.size()%>);

    <%
        Iterator keyIter3 = versionsAndServersValues.keySet().iterator();
        for (int i = 0; i < versionsAndServersValues.size(); i++) {
            String version5 = (String) keyIter3.next();
            ArrayList serverArray = (ArrayList) versionsAndServersValues.get(version5);
    %>
            var listOfServers = new Array(<%=serverArray.size()%>);
    <%
            int m=0;
            Iterator serversIterator = serverArray.iterator();
            while (serversIterator.hasNext()){
                String serverName2 = (String)serversIterator.next();
     %>
                listOfServers[<%=m%>] = "<%=serverName2%>";
     <%
                m++;
           }
    %>
            versionsAndServersMapKey[<%=i%>] = "<%=version5%>";
            versionsAndServersMapValue[<%=i%>] = listOfServers;
    <%
        }
    %>


    /* defaultTemplateNameValues contains an Arraylist of the default template names.
     */
	<%ArrayList defaultTemplateNameValues = new ArrayList();//(ArrayList) session.getAttribute("com.ibm.ws.console.distmanagement.default.template.names");%>

    /* Set up the Array of default template names on the client side.
     */
	var defaultTemplateNames = new Array(<%=defaultTemplateNameValues.size()%>);
    <%
	int k=0;
        Iterator tIter = defaultTemplateNameValues.iterator();
        while (tIter.hasNext()){
            String templateName1 = (String)tIter.next();
    %>
            defaultTemplateNames[<%=k%>] = "<%=templateName1%>";
    <%
            k++;
        }
    %>


    /* standaloneServersAndCoreGroupValues contains a HashMap of the available standalone servers
       and associated with each standalone server is the server's core group.  The standalone server
       is the key and the Core group is the value in the HashMap entry. Note that the server name
       is the fully qualified server name.
     */
	<%HashMap standaloneServersAndCoreGroupValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.servers.and.coregroup");%>

    /* Set up the standalone servers and their associated Core groups on the client side.
       Since a HashMap is not a available in javascript, two arrays are used.
       The first array contains the key, and the second array contains the value.
       The arrays are constructed so that the key and its associated value are at the
       same index.
     */
	var standaloneServersAndCoreGroupMapKey = new Array(<%=standaloneServersAndCoreGroupValues.size()%>);
	var standaloneServersAndCoreGroupMapValue = new Array(<%=standaloneServersAndCoreGroupValues.size()%>);

    <%
        Iterator keyIterator3 = standaloneServersAndCoreGroupValues.keySet().iterator();
        for (int i = 0; i < standaloneServersAndCoreGroupValues.size(); i++) {
            String standaloneServerName = (String) keyIterator3.next();
            String coreGroup = (String) standaloneServersAndCoreGroupValues.get(standaloneServerName);
    %>
            standaloneServersAndCoreGroupMapKey[<%=i%>] = "<%=standaloneServerName%>";
            standaloneServersAndCoreGroupMapValue[<%=i%>] = "<%=coreGroup%>";
    <%
        }
    %>

    /**
     * This method returns the core group of the standalone server given the standalone server name.
     */
    function findCoreGroup(standAloneServerName){
      // Look in the standaloneServersAndCoreGroupMapKey Array for the standalone server name specified.
      // If a match is found, return the value from the standaloneServersAndCoreGroupMapValue Array
      // at the same Array index
      for(i=0;i<standaloneServersAndCoreGroupMapKey.length;i++){
          if (standAloneServerName == standaloneServersAndCoreGroupMapKey[i]) {
              return (standaloneServersAndCoreGroupMapValue[i]);
          }
      }
    }

    /**
     * This method determines the index of the core group
     * with the specified value. -1 is returned if the index
     * is not found.
     */
    function findCoreGroupIndex(theCoreGroups, coreGroupName) {
        var coreGroupIndex = -1;

        if (theCoreGroups != null && coreGroupName != null) {
            for (i=0;i<theCoreGroups.length;i++) {
                if (theCoreGroups[i].value == coreGroupName) {
		            coreGroupIndex = i;
                }
            }
        }

        return coreGroupIndex;
    }

    /**
     * This method sets the selected core group in the core group
     * pulldown based on the standalone server that is being
     * converted to a cluster member.
     */
    function setCoreGroupSelection(theCoreGroups, theServerToConvertPath) {

       if (theCoreGroups != null && theServerToConvertPath != null) {
           var coreGroup = findCoreGroup(theServerToConvertPath.value);
           var coreGroupIndex = findCoreGroupIndex(theCoreGroups, coreGroup);

           if (coreGroupIndex != -1) {
               theCoreGroups.selectedIndex = coreGroupIndex;
           }
       }
    }


    /**
     * This method returns the type of the node given the node name.
     */
    function findNodeType(nodeName){
      // Look in the nodesAndTypeMapKey Array for the node name specified.
      // If a match is found, return the value from the nodesAndTypeMapValue Array
      // at the same Array index
      for(i=0;i<nodesAndTypeMapKey.length;i++){
          if (nodeName == nodesAndTypeMapKey[i]) {
              return (nodesAndTypeMapValue[i]);
          }
      }
    }

    /**
     * This method returns the version of the node given the node name.
     */
    function findNodeVersion(nodeName){
      // Look in the nodesAndVersionMapKey Array for the node name specified.
      // If a match is found, return the value from the nodesAndVersionMapValue Array
      // at the same Array index
      for(i=0;i<nodesAndVersionMapKey.length;i++){
          if (nodeName == nodesAndVersionMapKey[i]) {
              return (nodesAndVersionMapValue[i]);
          }
      }
    }

    /**
     * This method determines if the given node is a zos node.
     */
    function isZosNode(nodeName){
        var nodeType = findNodeType(nodeName);
        if (nodeType != null && nodeType == zosNodeType) {
            return true;
        }
        return false;
     }

    /**
     * This method returns an Array of templates for a particular node type.
     */
    function findTypeSpecificTemplates(nodeType){

      // Look in the nodeTypesAndTemplatesMapKey Array for the node type specified.
      // If a match is found, return the value from the nodeTypesAndTemplatesMapValue Array
      // at the same Array index (which is the Array of templates)
      for(i=0;i<nodeTypesAndTemplatesMapKey.length;i++){
          if (nodeType == nodeTypesAndTemplatesMapKey[i]) {
              return (nodeTypesAndTemplatesMapValue[i]);
          }
      }
    }

    /**
     * This method returns an Array of templates for a particular version.
     */
    function findVersionSpecificTemplates(version){

      // Look in the versionsAndTemplatesMapKey Array for the version specified.
      // If a match is found, return the value from the versionsAndTemplatesMapValue Array
      // at the same Array index (which is the Array of templates)
      for(i=0;i<versionsAndTemplatesMapKey.length;i++){
          if (version == versionsAndTemplatesMapKey[i]) {
              return (versionsAndTemplatesMapValue[i]);
          }
      }
    }

    /**
     * This method returns an Array of servers for a particular version.
     */
    function findVersionSpecificServers(version){

      // Look in the versionsAndServersMapKey Array for the version specified.
      // If a match is found, return the value from the versionsAndServersMapValue Array
      // at the same Array index (which is the Array of servers)
      for(i=0;i<versionsAndServersMapKey.length;i++){
          if (version == versionsAndServersMapKey[i]) {
              return (versionsAndServersMapValue[i]);
          }
      }
    }


    /**
     * This function returns the number of members that are common
     * between the two input arrays.
     */
    function numberOfCommonMembers(firstArray, secondArray){
        // Determine the number of common members
        var numberOfCommonMembers = 0;
        for (var k=0; k < firstArray.length; k++){
            for (var l=0; l < secondArray.length; l++){
                if (firstArray[k] == secondArray[l]) {
                    numberOfCommonMembers++;
                }
            }
        }

        return (numberOfCommonMembers);
    }

    /**
     * This function returns an Array of members that are common
     * between the two input arrays.
     */
    function findCommonMembers(firstArray, secondArray){

        // Create an Array of the appropriate size
        var commonMembers = new Array(numberOfCommonMembers(firstArray, secondArray));

        // Determine common members
        var h=0;
        for (var i=0; i < firstArray.length; i++){
            for (var j=0; j < secondArray.length; j++){
                if (firstArray[i] == secondArray[j]) {
                    commonMembers[h] = firstArray[i];
                    h++;
                }
            }
        }

        return (commonMembers);
    }


    /**
     * <p>This method is called when the "Select node" dropdown box is changed.  The
     * "Default application server template" dropdown box list will be modified based on the
     *  the node (and the node's node type and version) that was selected.   Only those templates
     *  that are valid for the selected node (based on the node type and version) will appear in the
     *  "Default application server template" dropdown box list.</p>
     */
    function setTemplates(theForm){
       var nodeList = theForm.selectedNodeFirst;
       var templateList = null;

       if ((nodeList != null) && (nodeList.length > 0)) {
           templateList = theForm.template;
           var selectedNodeName = nodeList[nodeList.selectedIndex].value;
           // Determine the node type based on the node selected by the user
           var nodeType = findNodeType(selectedNodeName);
           // Determine the node version based on the node selected by the user
           var version = findNodeVersion(selectedNodeName);

           if (nodeType != null && version != null) {
               // Get the list of templates based on the nodeType
               var nodeTypeSpecificTemplates = findTypeSpecificTemplates(nodeType);
               // Get the list of templates based on the version
               var versionSpecificTemplates = findVersionSpecificTemplates(version);
               // Determine the templates that are common between the nodeType templates
               // and the version Templates
               var commonTemplates = findCommonMembers(nodeTypeSpecificTemplates, versionSpecificTemplates);

               var radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "default");

               if ((commonTemplates != null) && (commonTemplates.length > 0)) {
                   // Found list of templates
                   // Make sure that the template dropdown is available before we start changing the options
                   if (templateList != null) {
                       // First, clear out the current template dropdown box options
                       templateList.length = 0;
                       // Now set up the template options for the template dropdown box
                       for(i=0;i<commonTemplates.length;i++){
                            var optionVar = document.createElement("OPTION");
                            optionVar.text = commonTemplates[i];
                            templateList.options.add(optionVar);
                       }

                       // Select the default template
                       setDefaultTemplate(templateList);

                       // Now make sure the "default" radio button is enabled
                       if (radioButtonIndex > -1) {
                           // Enable the radio button
                           theForm.radioButton[radioButtonIndex].disabled=false;
                       }
                   }
               } else {
                   // List of templates is empty
                   // Make sure that the template dropdown is available
                   if (templateList != null) {
                       // First, clear out the current template dropdown box options
                       templateList.length = 0;
                       // Now set up the template options for the template dropdown box
                       // to be "*NONE"
                       var optionVar = document.createElement("OPTION");
                       optionVar.text = "<%=noneText%>";
                       optionVar.value = "*NONE";
                       templateList.options.add(optionVar);

                       // Now disable the "default" radio button
                       if (radioButtonIndex > -1) {
                           // Disable the radio button
                           theForm.radioButton[radioButtonIndex].disabled=true;
                       }
                   }
               }
           }
       }
       return templateList;
    }


    /**
     * <p>This method is called to select a default template (if one exists). </p>
     */
    function setDefaultTemplate(templateList){
        // Determine if there is a default template in the current template options list
        for(i=0;i<templateList.length;i++){
            var optionName = templateList[i].text;
            for(j=0;j<defaultTemplateNames.length;j++){
                var defaultName = defaultTemplateNames[j];
                if (optionName == defaultName) {
                    templateList.selectedIndex = i;
                    return;
                }
            }
        }
    }

    /**
     * <p>This method is called when the "Select node" dropdown box is changed.  The
     * "Existing application server " dropdown box list will be modified based on the
     *  the node (and the node's version) that was selected.   Only those servers
     *  that are valid for the selected node (based on the node version) will appear
     *  in the "Existing application server " dropdown box list.</p>
     */
    function setServers(theForm){
       var nodeList = theForm.selectedNodeFirst;
       var serverList = null;


       if ((nodeList != null) && (nodeList.length > 0)) {
           serverList = theForm.selectedItem;
           var selectedNodeName = nodeList[nodeList.selectedIndex].value;
           // Determine the node version based on the node selected by the user
           var nodeVersion = findNodeVersion(selectedNodeName);

           if (nodeVersion != null) {
               // Get the list of servers based on the nodeVersion
               var nodeVersionSpecificServers = findVersionSpecificServers(nodeVersion);
               var radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "existing");
               if ((nodeVersionSpecificServers != null) && (nodeVersionSpecificServers.length > 0)) {
                   // Found list of servers
                   // Make sure that the server dropdown is available before we start changing the options
                   if (serverList != null) {
                       // First, clear out the current server dropdown box options
                       serverList.length = 0;
                       // Now set up the server options for the server dropdown box
                       for(i=0;i<nodeVersionSpecificServers.length;i++){
                            var optionVar = document.createElement("OPTION");
                            optionVar.value = nodeVersionSpecificServers[i];

                            // Find the appropriate display text
                            optionVar.text = "";
                            for(k=0;k < serverListValueArray.length; k++){
                                if (serverListValueArray[k] == nodeVersionSpecificServers[i]) {
                                    optionVar.text = serverListTextArray[k];
                                }
                            }
                            if (optionVar.text == "") {
                                // Didn't seem to find the server text, therefore, just use the value for
                                // the text.
                                optionVar.text = optionVar.value;
                            }

                            serverList.options.add(optionVar);
                       }

                       // Now make sure the "existing" radio button is enabled
                       if (radioButtonIndex > -1) {
                           // Enable the radio button
                           theForm.radioButton[radioButtonIndex].disabled=false;
                       }
                   }
               } else {
                   // List of servers is empty
                   // Make sure that the server dropdown is available
                   if (serverList != null) {
                       // First, clear out the current server dropdown box options
                       serverList.length = 0;
                       // Now set up the template options for the template dropdown box
                       // to be "*NONE"
                       var optionVar = document.createElement("OPTION");
                       optionVar.text = "<%=noneText%>";
                       optionVar.value = "*NONE";
                       serverList.options.add(optionVar);

                       // Now disable the "existing" radio button
                       if (radioButtonIndex > -1) {
                           // Disable the radio button
                           theForm.radioButton[radioButtonIndex].disabled=true;
                       }

                   }
               }
           }
       }

       return serverList;
    }

    /**
     * This method determines the index of the radio button
     * with the specified value. -1 is returned if the index
     * is not found.
     */
    function findRadioButtonIndex(theRadioButtons, radioButtonValue) {
        var radioButtonIndex = -1;

        if (theRadioButtons != null) {
            for (i=0;i<theRadioButtons.length;i++) {
                if (theRadioButtons[i].value == radioButtonValue) {
		            radioButtonIndex = i;
                }
            }
        }

        return radioButtonIndex;
    }


    /**
     * This method determines which radio button is checked (i.e., selected)
     * and returns the value of the checked radio button.
     */
    function findCheckedRadioButton(theRadioButtons) {
        var radioButtonValue = "";

        if (theRadioButtons != null) {
            for (i=0;i<theRadioButtons.length;i++) {
                if (theRadioButtons[i].checked) {
		            radioButtonValue = theRadioButtons[i].value;
                }
            }
        }

        return radioButtonValue;
    }


    /**

     * This method will set a radio button based on the existence of
     * radio button content.  For example, if no templates are available,
     * this method will set the next radio button.
     */
    function setRadioButton(theForm, templates, servers){
        var radioButtonIndex = -1;
        var standAloneServers = theForm.convertServerName;

        // First try to determine if a radio button is already selected
        var checkedRadioButtonValue = findCheckedRadioButton(theForm.radioButton);
        if (checkedRadioButtonValue == "") {
            // Radio button has not been selected ... so select one
            // Check to see if there are templates
            if ((templates == null) || (templates.length < 1) || (templates[0].value == "*NONE")) {
                // No templates are available
                // Check to see if there are servers available so that
                // we can set the servers radio button
                if ((servers != null) && (servers.length > 0) && (servers[0].value != "*NONE")) {
                    // There are servers available
                    // Find the "servers as templates" radio button array index
                    radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "existing");
                } else if (standAloneServers != null && standAloneServers.length > 0) {
                    // There are stand alone servers available
                    // Find the "convert server" radio button array index
                    radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "enable");
                } else {
                    // Find the "empty cluster" radio button array index
                    radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "none");
                }
            } else {
                // Templates are available
                // Find the templates radio button array index
                radioButtonIndex = findRadioButtonIndex(theForm.radioButton, "default");
            }

            if (radioButtonIndex > -1) {
                // Select the radio button
                theForm.radioButton[radioButtonIndex].checked = true;
            }
        }
    }


    /**
     * This method sets the template dropdown lists
     */
    function setTemplateDropDownLists(theForm){
        var templates = setTemplates(theForm);
        var servers = setServers(theForm);
        setRadioButton(theForm, templates, servers);
    }


    /**
     * <p>This method is called when the radio buttons are clicked.
	 * The fields that define the cluster member are disabled when the
     * "Create an empty cluster" radio button is selected.  Also,
     * when the "Convert an existing server" radio button is selected,
     * all the cluster member fields are disabled except for the weight
     * field. Otherwise, the cluster member fields are enabled.</p>
     */
    function adjustMemberSpecificFields(theForm){
       var theRadioButtons =  theForm.radioButton;
       var thePreviousRadioButton = theForm.previousRadioButton;
       var theMemberName = theForm.serverNameFirst;
       var theMemberSpecificShortName = theForm.serverSpecificShortNameFirst;
       var theSelectedNode = theForm.selectedNodeFirst;
       var theWeight = theForm.firstWeight;
       var theCoreGroups = theForm.coreGroup;
       var theGeneratePort = theForm.generatePortFirst;

       if (theRadioButtons != null) {
          var checkedRadioButton = findCheckedRadioButton(theRadioButtons);

          if (checkedRadioButton == "none" || theSelectedNode == null || theSelectedNode.length < 1) {
              // Create an empty cluster
              // Disable the cluster member specific fields
              // Disable and blank out the member name field
              theMemberName.disabled=true;
              theMemberName.value = "";
              // Disable and blank out the member specific short name field
              if (theMemberSpecificShortName != null) {
                  theMemberSpecificShortName.disabled=true;
                  theMemberSpecificShortName.value = "";
              }
              // Disable the selected node
              theSelectedNode.disabled=true;
              // Disable the weight field
              theWeight.disabled=true;
              // Disable the coregroup list
              if (theCoreGroups != null) {
                  theCoreGroups.disabled=true;
              }
              // Disable the generate port checkbox
              theGeneratePort.disabled=true;

              // Remember this radio button as the previous
              // radio button selected
              thePreviousRadioButton.value = "none";

          } else if (checkedRadioButton == "enable") {
              // Convert an existing standalone server
              // Disable the cluster member specific fields
              // Disable and blank out the member name field
              theMemberName.disabled=true;
              // Disable and blank out the member specific short name field
              if (theMemberSpecificShortName != null) {
                  theMemberSpecificShortName.disabled=true;
                  theMemberSpecificShortName.value = "";
              }
              // Disable the selected node
              theSelectedNode.disabled=true;
              // Enable the weight field
              theWeight.disabled=false;
              // Disable the coregroup list
              if (theCoreGroups != null) {
                  theCoreGroups.disabled=true;
              }
              // Disable the generate port checkbox
              theGeneratePort.disabled=true;

              // Set the member specific fields based on server
              // that is being converted
              setMemberFieldsBasedOnConvertingServer(theForm);

              // Remember this radio button as the previous
              // radio button selected
              thePreviousRadioButton.value = "enable";

          } else {
              // Enable the cluster member specific fields
              // Enable the member name field
              theMemberName.disabled=false;
              // Enable the member specific short name field
              if (theMemberSpecificShortName != null && isZosNode(theSelectedNode.value)) {
                  theMemberSpecificShortName.disabled=false;
              }

              // Enable the selected node
              theSelectedNode.disabled=false;
              // Enable the weight field
              theWeight.disabled=false;
              // Enable the coregroup list
              if (theCoreGroups != null) {
                  theCoreGroups.disabled=false;
              }
              // Enable the generate port checkbox
              theGeneratePort.disabled=false;

              // If the previous selected radio button was the
              // "convert existing server" radion button, we need
              // to set the cluster name field to blank so that the
              // existing server name is not used again (which would
              // result in a duplicate name message if the user tried
              // to use it).
              if ((thePreviousRadioButton.value == "enable")) {
                  theMemberName.value = "";
                  if (theMemberSpecificShortName != null) {
                      theMemberSpecificShortName.value = "";
                  }

                  // Do not reset the weight since each option (except "none")
                  // allows the weight to be changed
                  //   theWeight.value = "2";
                  theGeneratePort.value = "true";
                  theGeneratePort.checked = true;

                  // Set the selected core group to DefaultCoreGroup
                  if (theCoreGroups != null) {
                      var defaultCoreGroup = "DefaultCoreGroup";
                      var coreGroupIndex = findCoreGroupIndex(theCoreGroups, defaultCoreGroup);
                      if (coreGroupIndex != -1) {
                          theCoreGroups.selectedIndex = coreGroupIndex;
                      } else {
                          // Cannot seem to find the DefaultCoreGroup, just set the selected core group to
                          // the first entry in the core group list
                          theCoreGroups.selectedIndex = 0;
                      }
                  }

              }

              // Remember radio button as the previous
              // radio button selected
              if (checkedRadioButton == "existing") {
                  thePreviousRadioButton.value = "existing";
              } else {
                  thePreviousRadioButton.value = "default";
              }
          }
       }

    }


    /**
     * <p>This method sets the member specific fields by
     * using the information from the server that is being
     * converted.</p>
     */
    function setMemberFieldsBasedOnConvertingServer(theForm){

       var theServerToConvertPath = theForm.convertServerName;
       var theMemberName = theForm.serverNameFirst;
       var theMemberSpecificShortName = theForm.serverSpecificShortNameFirst;
       var theSelectedNode = theForm.selectedNodeFirst;
       var theCoreGroups = theForm.coreGroup;
       var theGeneratePort = theForm.generatePortFirst;

       // Determine the server and node name of the server to convert
       var nodeNameOfServerToConvert = theServerToConvertPath.value.substring(theServerToConvertPath.value.indexOf("/")+1, theServerToConvertPath.value.lastIndexOf("/"));
       var serverNameOfServerToConvert = theServerToConvertPath.value.substring(theServerToConvertPath.value.lastIndexOf("/") + 1);

       // Set the first cluster member name to the server name of the server that is being converted
       theMemberName.value = serverNameOfServerToConvert;

       // Set the first cluster member specific short name.  A this time, we don't retrieve the existing
       // cluster member short name ... therefore, we will set the name to ""
       if (theMemberSpecificShortName != null) {
           theMemberSpecificShortName.value = "";
       }

       // Set the node for the cluster member to the node of the server that is being converted
       theSelectedNode.value = nodeNameOfServerToConvert;

       // Set the coreGroup name
       setCoreGroupSelection(theCoreGroups, theServerToConvertPath);

        // Now that the selected node has been modified, we need to set the template
        // dropdown lists based on the current selected node.
        setTemplateDropDownLists(theForm);

       // Turn off the checkbox to create new port numbers, since the existing server already
       // has the port numbers
       theGeneratePort.value = "false";
       theGeneratePort.checked = false;
    }

    /**
     * <p>This method is called to adjust the cluster member fields
     * when a node is selected.</p>
     */
    function adjustMemberFieldsBasedOnNode(theForm){
       var theSelectedNode = theForm.selectedNodeFirst;
       var theMemberSpecificShortName = theForm.serverSpecificShortNameFirst;

       // Adjust the member specific short name field ... if it is available.
       if (theMemberSpecificShortName != null) {
           // The cluster member specific short name is available.
           // Check to determine the type of node selected
           if (theSelectedNode!= null && isZosNode(theSelectedNode.value)) {
               // A zos node was selected.  Therefore, the cluster member
               // specific short name should be available.
               theMemberSpecificShortName.disabled=false;
           } else {
               // The selected node is NOT a zos node.  Therefore, the
               // cluster member specific short name should NOT be available.
               theMemberSpecificShortName.disabled=true;
               theMemberSpecificShortName.value = "";
           }
       }
    }
</script>

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
       <tbody id="multiServersDiv" style="display:block">
       	 <tr><td class="table-text" nowrap>
         <tiles:insert page="/com.ibm.ws.console.dynamiccluster/DynamicClusterExistingServerPropAttrs.jsp" flush="false">
	       <tiles:put name="actionForm" value="<%=actionForm%>" />
       	   <tiles:put name="multiSelect" value="true" />
       	 </tiles:insert>
       	 </td></tr>		
	   </tbody>
	
       <tbody id="memberCollectionDiv" style="display:block">
       	 <tr><td class="table-text" nowrap>
         <tiles:insert page="/com.ibm.ws.console.dynamiccluster/wizardMemberCollectionTable.jsp" flush="false">
	       <tiles:put name="actionForm" value="<%=actionForm%>" />
       	 </tiles:insert>
       	 </td></tr>		
	   </tbody>
</table>

<script language="JavaScript">
  manualMemberTypeChanged();
</script>
