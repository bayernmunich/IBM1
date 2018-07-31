<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 2010 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator,com.ibm.ws.console.core.item.ActionSetItem,com.ibm.ws.security.core.SecurityContext"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="com.ibm.ws.xd.admin.utils.ConfigUtils"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="buttonCount" classname="java.lang.String" />
<tiles:useAttribute name="definitionName" classname="java.lang.String" />
<tiles:useAttribute name="includeForm" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="rolemap" classname="java.util.Map" ignore="true"/>

<%
int count = 0;

try {
        count = Integer.parseInt(buttonCount);
    }
    catch( java.lang.NumberFormatException ex){
        count = 8;
        }
%>

<%-- Layout component
  Render a list of tiles in a vertical column
  @param : list List of names to insert

--%>
<tiles:useAttribute id="list" name="actionList" classname="java.util.List" />

<!-- gets all the action list items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%  String renderReadOnlyView = "no";
    if (SecurityContext.isSecurityEnabled()) {
	  renderReadOnlyView = "yes";
	  if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
	  }
	  else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
	  }
    }
%>
<%
int wasVersion = ConfigUtils.getWASVersionInts()[0];

String contextType=(String)request.getAttribute("contextType");
String contextId = (String)request.getAttribute("contextId");

String perspective = (String)request.getAttribute("perspective");

java.util.Properties props= null;

java.util.ArrayList actionList_ext =  new java.util.ArrayList();
for(int i=0;i<list.size(); i++)
     actionList_ext.add(list.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.actionSet";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions= registry.getExtensions(extensionId,ic);

if(extensions!=null && extensions.length>0){
    if(contextId!=null && contextId!="nocontext"){
        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }
    if(formName!=null)
    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName); // LIDB2303A
    else
       props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props);

    actionList_ext = ActionSetSelector.getButtons(extensions,actionList_ext,props,perspective, definitionName);
}
pageContext.setAttribute("actionList_ext",actionList_ext);

%>

<%
Iterator i=actionList_ext.iterator();
int listsize = actionList_ext.size();
String buttonName = "";
if (listsize <= (count+1) ) {
   count = listsize;
}

%>

<% if (listsize > 0) { %>

        <table border="0" cellpadding="3" cellspacing="0" valign="top" width="100%" summary="Framing Table" CLASS="button-section">
        <tr valign="top">
        <td class="table-button-section"  nowrap>


    <%  if (includeForm.equals("yes")){  %>
        <form method="POST" action="toolbar.do" class="nopad">
    <% } %>

    <%
    for (int ctr=0; ctr < listsize ; ++ctr) {
        ActionSetItem item = (ActionSetItem)i.next();
        String action = item.getAction();
        buttonName = action; 
        boolean showItem = true;
        if (SecurityContext.isSecurityEnabled()) {
            String[] roles = item.getRoles();
            showItem = false;
	        if (request.isUserInRole("administrator")) {
               showItem = true;
	        }
	        else if (request.isUserInRole("configurator")) {
               showItem = true;
	        }
        }
        %>

    <%-- Iterate over names.
      We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
     --%>

    <%  if (showItem == true) { %>
			<input type="submit" name="<%=action%>" value="<bean:message key="<%=buttonName %>"/>" class="buttons_functions"/>
	<%  }    %>

    <%
      } // end loop
    %>

    <input type="hidden" name="definitionName" value="<%=definitionName%>"/>
    <input type="hidden" name="buttoncontextType" value="<%=contextType%>"/>
    <input type="hidden" name="buttoncontextId" value="<%=contextId%>"/>
    <input type="hidden" name="buttonperspective" value="<%=perspective%>"/>

    <% if (includeForm.equals("yes")) {%>
      </form>
    <% } %>

        </td>
        </tr>
        </table>


<% } %>



