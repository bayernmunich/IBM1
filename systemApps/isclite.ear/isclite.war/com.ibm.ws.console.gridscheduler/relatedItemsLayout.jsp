<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="org.apache.struts.tiles.beans.SimpleMenuItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.item.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="list" name="list" classname="java.util.List"/>
<tiles:useAttribute name="formName" classname="java.lang.String"/>

<bean:define id="resourceUri" name="<%=formName%>" property="resourceUri"/>
<bean:define id="refId"    name="<%=formName%>" property="refId"/>
<bean:define id="action"    name="<%=formName%>" property="action"/>
<bean:define id="contextId"    name="<%=formName%>" property="contextId"/>
<bean:define id="perspective"    name="<%=formName%>" property="perspective"/>
<bean:define id="isCGUTE" name="<%=formName%>" property="isCGUTE" type="java.lang.Boolean"/>
<bean:define id="isOO" name="<%=formName%>" property="isOO" type="java.lang.Boolean"/>

<!-- gets all the link items which matches with the contextType and 
     compatibilty criteria using plugin registry API -->

<%

String contextType=(String)request.getAttribute("contextType");
String categoryId = null;
String perspective_ext = null;
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;
String[] allRoles = { "administrator", "operator", "configurator", "monitor" };
String[] roles = allRoles;

String encoding = response.getCharacterEncoding();
if(encoding==null)	encoding = "UTF-8";

java.util.ArrayList list_ext =  new java.util.ArrayList();
for(int i=0;i<list.size(); i++)
     list_ext.add(list.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.link";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions= registry.getExtensions(extensionId,ic);

if(extensions!=null && extensions.length>0){
    if(contextId!=null && contextId!="nocontext"){
      props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
      }
      
    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName); // LIDB2303A

    // LI 3969
	// Add user roles to props
    String[] userRoles = (String[]) session.getAttribute("userRoles");
    if (userRoles != null) {
        props.put("userRoles", userRoles);
    }

    list_ext = LinkSelector.getLinks(extensions,list_ext,props,(String)perspective,"related.items", request, formName); // LIDB3509C
}
pageContext.setAttribute("list_ext",list_ext); 


                            %>




<BR>
<% if (list_ext.size() > 0) { %>


      
    <DIV class="main-category" style="margin-left:.30em">
    <bean:message key="related.items"/>
    </DIV>
    
    <DIV class="main-category-container" style="margin-left:.30em">
    
    <UL CLASS="main-child">

      
   <logic:iterate id="item" name="list_ext" type="org.apache.struts.tiles.beans.SimpleMenuItem">
      
      <%
            if(item.getIcon()!=null){
            if(item.getIcon().equals("")==false){
                StringTokenizer stoken = new StringTokenizer(item.getIcon(),",");
                ArrayList al = new ArrayList();
                while(stoken.hasMoreTokens()){
                    al.add(stoken.nextToken());
                }
                roles = new String[al.size()];
                roles = (String[])al.toArray(roles);
            }
            }

            boolean showItem = true;
            if (SecurityContext.isSecurityEnabled()) {
            String[] roles_given = roles;
            showItem = false;
            for (int idx = 0; idx < roles_given.length; idx++) {
                if (request.isUserInRole(roles_given[idx])) {
                    showItem = true;
                    break;
                }
            }
        }
        if (showItem == true) {
    %>

      <LI CLASS="nav-bullet" title="<bean:message key="<%= item.getTooltip() %>"/>">
<%            
		String link="";
			if(item.getLink().indexOf("resourceUri=")!=-1){
				if(item.getLink().indexOf("contextId=")!=-1){
					//has resourceUri and contextId
					link = item.getLink() +  "&parentRefId=" + URLEncoder.encode((String) refId,encoding) +  "&perspective=" + URLEncoder.encode((String) perspective,encoding) ;
        		}
        		else if(item.getLink().indexOf("contextId")!=-1){ 
					//has resourceUri and contextId without equals
					link = item.getLink() +  "&parentRefId=" + URLEncoder.encode((String) refId,encoding) +  "&perspective=" + URLEncoder.encode((String) perspective,encoding) ; 
        		}
				else{
					//has resourceUri
					link = item.getLink() + "&parentRefId=" + URLEncoder.encode((String) refId,encoding) + "&contextId=" + URLEncoder.encode((String) contextId,encoding) + "&perspective=" + URLEncoder.encode((String) perspective,encoding) ;
				}
			}
			else if(item.getLink().indexOf("contextId=")!=-1){ 
        		//has contextId
				link = item.getLink() + "&resourceUri=" + URLEncoder.encode((String) resourceUri,encoding) + "&parentRefId=" + URLEncoder.encode((String) refId,encoding) + "&perspective=" + URLEncoder.encode((String) perspective,encoding) ;
			}
			else if(item.getLink().indexOf("contextId")!=-1){ 
        		//has contextId without equals
				link = item.getLink() + "&resourceUri=" + URLEncoder.encode((String) resourceUri,encoding) + "&parentRefId=" + URLEncoder.encode((String) refId,encoding) + "&perspective=" + URLEncoder.encode((String) perspective,encoding) ; 
			}
			else{
				//has neither contextId nor resourceUri
				link = item.getLink() + "&resourceUri=" + URLEncoder.encode((String) resourceUri,encoding) + "&parentRefId=" + URLEncoder.encode((String) refId,encoding) + "&contextId=" + URLEncoder.encode((String) contextId,encoding) + "&perspective=" + URLEncoder.encode((String) perspective,encoding) ;
			}
			if((isCGUTE.booleanValue() || !isOO.booleanValue()) && !item.getValue().equals("JDBCProvider.displayName")){
%>
     <bean:message key="<%= item.getValue() %>"/>
<%
			} else {
%>
     <A HREF= "<%= link %>" title="<bean:message key="<%= item.getTooltip() %>"/>" ><bean:message key="<%= item.getValue() %>"/></A>
     </LI>
     
<%
     		}
     	}
%> 
     
   </logic:iterate>
</UL></DIV> 
<% }%>         
