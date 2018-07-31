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
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>"
	pluginContextRoot="<%=pluginRoot%>" />
<ibmcommon:detectLocale />

<%!
     String cellName = null;
     private String getNodeVersion(String nodeName, String cellName) throws Exception
     {
             String value = null;
             Properties props = null;
             if(nodeName !=null && cellName!=null)
             {
                props = new Properties();
                props.setProperty(ManagedObjectMetadataAccessor.CELL_NAME, cellName);
                ManagedObjectMetadataHelper mh = new ManagedObjectMetadataHelper(ManagedObjectMetadataAccessorFactory.createAccessor(props));
                value = mh.getNodeBaseProductVersion(nodeName);
             }
             return value;
    }
%>

<%
    cellName = ((RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY)).getName();
%>

<script type="text/javascript" language="JavaScript">

    /* nodesAndTypeValues contains a HashMap of the available nodes and associated with each node
       is the node type.  The Node Name is the key and the Node Type is the value in the HashMap
       entry.  The possible node types are:
               "distributed"
               "os390"
               "all"
     */
	<% HashMap nodesAndTypeValues = new HashMap();//(HashMap) session.getAttribute("com.ibm.ws.console.distmanagement.available.nodes.and.type");%>

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
     * <p>This method is called when the "Select node" dropdown box is changed.  The
     * "Application server templates" dropdown box list will be modified based on the
     *  the node (and the node's node type) that was selected.   Only those templates
     *  that are valid for the selected node (based on the node type) will appear in the
     *  "Application server templates" dropdown box list.</p>
     */
    function setTemplates(theForm){
       var nodeList = theForm.selectedNode;

       if ((nodeList != null)  && (nodeList.length > 0)) {
           var templateList = theForm.defaultServer;
           var selectedNodeName = nodeList[nodeList.selectedIndex].value;

           // Determine the node type based on the node selected by the user
           var nodeType = findNodeType(selectedNodeName);

           if (nodeType != null) {
               // Get the list of templates based on the nodeType
               var nodeTypeSpecificTemplates = findTypeSpecificTemplates(nodeType);

               if ((nodeTypeSpecificTemplates != null) && (nodeTypeSpecificTemplates.length > 0)) {
                   // Found list of templates

                   // Make sure that the template dropdown is available before we start changing the options
                   if (templateList != null) {
                       // First, clear out the current template dropdown box options
                       templateList.length = 0;
                       // Now set up the template options for the template dropdown box
                       for(i=0;i<nodeTypeSpecificTemplates.length;i++){
                           var optionVar = document.createElement("OPTION");
                           optionVar.text = nodeTypeSpecificTemplates[i];
                           templateList.options.add(optionVar);
                       }

                       // Select the default template
                       setDefaultTemplate(theForm);
                   }
               }
           }
       }
    }


    /**
     * <p>This method is called to select a default template (if one exists). </p>
     */
    function setDefaultTemplate(theForm){
        var templateList = theForm.defaultServer;

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
</script>

<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">
	<tbody>
    	<tr valign="top">
          	<td class="table-text" nowrap>          	
              <fieldset id="selectTemplate">
                <legend for ="selectTemplate" TITLE="<bean:message key="dynamiccluster.template.description"/>">
                  <bean:message key="dynamiccluster.select.template"/>
                </legend>

  			    <table width="100%" border="0" cellspacing="0" cellpadding="0" role="presentation">
				  <logic:equal name="<%=actionForm%>" property="showDefault" value="true">
					<tr>
						<td valign="top" class="table-text">
						  <label for="defaultTemplate">
						    <html:radio property="radioButton" value="default" styleId="defaultTemplate" /> 
						    <bean:message key="dynamiccluster.default.server.template" />&nbsp;&nbsp;
						  </label>
						</td>
					</tr>
					<tr>
						<td class="complex-property">						
 		                  <tiles:insert page="/com.ibm.ws.console.dynamiccluster/DynamicClusterTemplatePropAttrs.jsp" flush="false">
	                        <tiles:put name="actionForm" value="<%=actionForm%>" />
        			      </tiles:insert>
						</td>
					</tr>
				  </logic:equal>

				  <logic:equal name="<%=actionForm%>" property="showExisting" value="true">
					<tr>
						<td valign="top" class="table-text">
						  <label for="existingTemplate">						    <html:radio property="radioButton" value="existing" styleId="existingTemplate" />
						    <bean:message key="dynamiccluster.existing.server" />&nbsp;&nbsp;
						  </label>
						</td>
					</tr>
					<tr>
						<td class="complex-property">
 		                  <tiles:insert page="/com.ibm.ws.console.dynamiccluster/DynamicClusterExistingServerPropAttrs.jsp" flush="false">
	                        <tiles:put name="actionForm" value="<%=actionForm%>" />
       	                    <tiles:put name="multiSelect" value="false" />
       			          </tiles:insert>						
						</td>
					</tr>
				  </logic:equal> 
				  <%
				  CreateDynamicClusterForm cdcf = (CreateDynamicClusterForm)session.getAttribute("CreateDynamicClusterForm");
				  boolean isForeignServer = cdcf.isForeignServer();
				 
				  if (!isForeignServer) {
					  
				  %>
				  
					 
				  <tr>
				    
				  </tr>
				<tr>
					  
				  		<td valign="top" class="table-text">
				  		 <br />
	
					  		<label for="coreGroup" title='<bean:message key="appserver.selectAppServer.selectCoreGroup"/>'>
						     <bean:message key="new.cluster.member.coreGroup.description"/>
						   </label>           
						   <br />
				
					   		<html:select property="selectedCoreGroup" styleId="coreGroup" size="1" >
						     <logic:iterate id="selectedCoreGroup" name="<%=actionForm%>" property="coreGroupList">
								<% 	String value = (String) selectedCoreGroup;
								   	value=value.trim();
									if (!value.equals("")) {
				                                %>
									    <html:option value="<%=value%>"><%=value%></html:option>
							  	 <% } else { %>
							  	 	     <html:option value="<%=value%>"><bean:message key="none.text"/></html:option>
							   	 <%  } %>
						     </logic:iterate>
						   </html:select>	
						   </td>
			   </tr>
						
				  <% } %>   
			    </table>
			  </fieldset>
            </td>
    	</tr>
	</tbody>
</table>
