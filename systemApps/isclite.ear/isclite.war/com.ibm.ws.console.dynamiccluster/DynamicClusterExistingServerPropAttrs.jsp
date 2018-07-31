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
<%@ page language="java" import="com.ibm.ws.console.core.utils.VersionHelper"%>
<%@ page language="java" import="com.ibm.ws.console.distmanagement.DistHelper"%>
<%@ page language="java" import="org.apache.struts.util.MessageResources"%>

<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="multiSelect" classname="java.lang.String" />
<bean:define id="nodes" name="<%=actionForm%>" property="nodePath"/>
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
                // begin - bug 10850
                String xdaProdVersion = mh.getNodeProductsAndVersions(nodeName).getProperty("xda");
                if (xdaProdVersion != null) {
                  // this must be the standalone xdagent node
                  value = xdaProdVersion;
                }
                // end - bug 10850
             }
             return value;
    }
%>

<%
    // Get the cell name
    cellName = ((RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY)).getName();
%>

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table">
	<tbody>
	  <tr valign="top">
		 <td class="table-text" nowrap valign="top">
           <label for="existingServer" title="<bean:message key="dynamiccluster.existing.server.description"/>">
            <bean:message key="choose.server" />
           </label>
           <br />

          <% if (multiSelect.equals("true")) {
                // refresh the existing server list if necessary
                com.ibm.ws.console.dynamiccluster.utils.Utils.refreshExisitngServerList(session);
          %>
		   <html:select property="existingServers" styleId="existingServer" multiple="true" size="8" >
		     <logic:iterate id="server" name="<%=actionForm%>" property="existingServerPath">
			 <%
               String serverPath = (String)server;
               StringBuffer buff = new StringBuffer();
               buff.append(serverPath.substring(0, serverPath.indexOf("/")));
               buff.append("/");
               String nodeNm = serverPath.substring(serverPath.indexOf("/")+1, serverPath.lastIndexOf("/"));
               buff.append(nodeNm);
               if(nodeNm != null)
               {
                  buff.append("("+getNodeVersion(nodeNm, cellName)+")");
               }
               buff.append("/");
               buff.append(serverPath.substring(serverPath.lastIndexOf("/") + 1));
               String re = buff.toString();
             %>

			 <html:option value="<%=serverPath%>">
				<%=re%>
			 </html:option>
			 </logic:iterate>
		   </html:select>
		 <% } else { %>	
		   <html:select property="existingServer" styleId="existingServer" >
		     <logic:iterate id="server" name="<%=actionForm%>" property="existingServerPath">
			 <%
               String serverPath = (String)server;
               StringBuffer buff = new StringBuffer();
               buff.append(serverPath.substring(0, serverPath.indexOf("/")));
               buff.append("/");
               String nodeNm = serverPath.substring(serverPath.indexOf("/")+1, serverPath.lastIndexOf("/"));
               buff.append(nodeNm);
               if(nodeNm != null)
               {
                  buff.append("("+getNodeVersion(nodeNm, cellName)+")");
               }
               buff.append("/");
               buff.append(serverPath.substring(serverPath.lastIndexOf("/") + 1));
               String re = buff.toString();
             %>

			 <html:option value="<%=serverPath%>">
				<%=re%>
			 </html:option>
			 </logic:iterate>
		   </html:select>
		   <% } %>
         </td>
	  </tr>		
	</tbody>
</table>
