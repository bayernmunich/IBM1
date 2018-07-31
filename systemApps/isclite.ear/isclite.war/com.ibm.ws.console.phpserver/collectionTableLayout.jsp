<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>



<%@ page  errorPage="/error.jsp"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*,org.apache.struts.util.MessageResources,org.apache.struts.action.Action" %>
<%@ page import="java.net.*" %>

<%
MessageResources statusMessages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
String statusAlt = statusMessages.getMessage(request.getLocale(),"accessibility.needs");
%>

<% 
   int chkcounter = 0;
   try {
%>

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes" classname="java.lang.String"/>
<tiles:useAttribute name="sortIconLocation" classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth" classname="java.lang.String"/>
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<tiles:useAttribute name="collectionList" classname="java.util.List" />
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List" />
<tiles:useAttribute name="parent" classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String" scope="request"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<!-- d226010 -->
<tiles:useAttribute name="serverType" classname="java.lang.String" ignore="true"/>
<!-- d226010 -->

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/> 
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/> 

<!-- gets all the Collection items which matches with the contextType and 
     compatibilty criteria using plugin registry API -->

<%
String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

String encoding = response.getCharacterEncoding();
if(encoding==null)	encoding = "UTF-8";


java.util.ArrayList collectionList_ext =  new java.util.ArrayList();
            for(int i=0;i<collectionList.size(); i++)
                collectionList_ext.add(collectionList.get(i));

java.util.ArrayList collectionPreferenceList_ext =  new java.util.ArrayList();
for(int i=0;i<collectionPreferenceList.size(); i++)
    collectionPreferenceList_ext.add(collectionPreferenceList.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.collectionItem";
    IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

    IExtension[] extensions = registry.getExtensions(extensionId, ic);

String extensionId_preferences = "com.ibm.websphere.wsc.preferences";
IConfigurationElementSelector ic_preferences = new ConfigurationElementSelector(contextType, extensionId_preferences);

IExtension[] extensions_preferences = registry.getExtensions(extensionId_preferences, ic);

    if((extensions!=null && extensions.length>0) || (extensions_preferences!=null && extensions_preferences.length>0)){
    if(contextId!=null && contextId!="nocontext"){
      props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }
    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);    // 299949.2A
    }

    if(extensions!=null && extensions.length>0){
    
    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props,request,formName); // 299949.2C
}

pageContext.setAttribute("collectionList_ext",collectionList_ext);


 %>
 
 
 <%


if(extensions_preferences!=null && extensions_preferences.length>0){

collectionPreferenceList_ext = PreferenceSelector.getPreferences(extensions_preferences,collectionPreferenceList_ext,props);

}


%>

<%--
	NOTES:
			The sorting icons are specified in defaultIconList.  The icons are assumed to be located in the images folder.
			Checkboxes are NOT displayed for all objects whose refIds start with "builtin_"
--%>

            <%@ include file="/secure/layouts/filterSetup.jspf" %>  

   

            
            
        <% session.removeAttribute("preferences"); %>                   
        <jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>
           
        <% for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();)
        {
            preferences.add(i.next());
        }%>
        
        <tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
            <tiles:put name="parent" value="<%=parent%>"/>
            <tiles:put name="preferences" beanName="preferences" beanScope="session" />
        </tiles:insert>



<html:form action="collectionButton.do" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">

				<tiles:insert definition="<%=buttons%>" flush="true"/>
				
				<%
				String hideCheckBoxes = (String) request.getAttribute("hide.check.boxes");
				if(hideCheckBoxes!= null && hideCheckBoxes.equals("true")){
					showCheckBoxes = "false";
				}
				
				%>

            <%@ include file="/secure/layouts/tableControlsLayout.jspf" %>  
               
                                
				<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="1" WIDTH="100%" SUMMARY="List table" CLASS="framing-table">
                   
					<TR>
                    <%  
                        if (showCheckBoxes.equals ("true"))
                        {
                    %>
						<TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                        <bean:message key="select.text"/>
                        </TH>
                    <%
                        }
                    %>                    

                    
						<logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
					<%
						sortable = (String)cellItem.getIsSortable();
						columnField = (String)cellItem.getColumnField();
                        String tmpName = cellItem.getTooltip();
                        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
                        
						if (chkcounter == 0) {
						   if (searchFilter.equals("")) {
							  searchFilter = columnField;
						   }
						}
                    %>                    
						<TH VALIGN="MIDDLE" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>">
					<%
						if (sortIconLocation.equalsIgnoreCase ("right"))
						{
					%>
							<bean:message key="<%=cellItem.getTooltip()%>"/>
					<%
						}
						if (sortable.equals ("false"))
						{
					%>
							<IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13"> 
					<%
						}
                        if ((sortable.equals ("true")) && (!columnField.equals("status")))
						{
							if (columnField.equals (sortedColumn))
							{
								String nextOrder;
								if (order.equalsIgnoreCase ("ASC"))
								{
									nextOrder = "DSC";
								}
								else
								{
									nextOrder = "ASC";
								}
					%>
							<A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
					<%
								if (order.equalsIgnoreCase ("ASC"))
								{
					%>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" align="texttop" BORDER="0"  ALT="<bean:message key="sorted.ascending"/>"></A>
					<%
								}
								else if (order.equalsIgnoreCase ("DSC"))
								{
					%>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" align="texttop" BORDER="0" ALT="<bean:message key="sorted.descending"/>"></A>
					<%
								}
								else{
					%>
                            </A>
					<%
								}
							}
							else
							{
					%>
							<A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC">
                            <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" align="texttop" BORDER="0"  ALT="<bean:message key="not.sorted"/>"></A>
					<%
							}
							if (sortIconLocation.equalsIgnoreCase ("left"))
							{
					%>
							<bean:message key="<%=cellItem.getTooltip()%>"/>
					<%
							}
							if (sortable.equals ("false"))
							{
					%>
							<IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13"> 
					<%
							}
						}
                        
					%>
                    <% //add refresh.gif after status column to refresh page
                        if (columnField.equals("status")) { %>
                        <A HREF="<%=parent%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  ALT="<bean:message key="refresh.view"/>" align="texttop" border="0"/></A>    
                    <%  } 

                        if (!filterDisplay.equals("none")) {
                           if (columnField.equals(searchFilter)) {
                    %>
                                <HR SIZE="1"><bean:message key="quick.search.label"/>: <%=searchPattern%>
                    <%
                           }
                        }


                    %>
						</TH>
                        
                        <% chkcounter = chkcounter + 1; %>  
                                       
						</logic:iterate>
                        
					</TR>
                    
                    
            
            <%@ include file="/secure/layouts/filterControlsLayout.jspf" %>  

            
            
            <% chkcounter = 0; %>
               
                                      
					<logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">
                    <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
					<bean:define id="contextId" name="listcheckbox" property="contextId" type="java.lang.String"/>
                  
					<TR CLASS="table-row">
					<%
						if (showCheckBoxes.equals("true"))
						{
                            //if ( !refId.startsWith ("builtin_"))
                            //{
                            //    String delId = (String)contextId; 
					%>
						<TD VALIGN="top"  WIDTH="1%" HEADERS="header1" class="collection-table-text">
                        <label class="collectionLabel" for="selectedObjectIds" TITLE="<bean:message key="select.row.text"/> <%=chkcounter+1%>">
                        <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=contextId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)"/>
                        </LABEL>
						</TD>
					<%
						  //  } else {
					%>
                    
                    
					<%
						  //  } 
                        }
                    %>
						<logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
					<%
						columnField = (String)cellItem.getColumnField();
					%>
						<TD VALIGN="top"  HEADERS="header2" class="collection-table-text">
					<%
						if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0)
						{
					%>    		   
							<IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="BASELINE"></IMG>&nbsp;
					<%
						}		
						if (cellItem.getLink().length() > 0)
						{
							String hRef = cellItem.getLink()+ "&contextId=" + URLEncoder.encode(contextId,encoding) + "&resourceUri="+URLEncoder.encode(resourceUri,encoding) + "&perspective=" + URLEncoder.encode(perspective,encoding);
					%>
							<A HREF="<%=hRef%>"><bean:write name="listcheckbox" property="<%=columnField%>"/></A>
					<%
						}
                        else if (columnField.equalsIgnoreCase("status")) { 

                            String statusservlet = "/ibm/console/status";
                            if(cellItem.getStatusServlet()!=null)
                                statusservlet = cellItem.getStatusServlet();

                     %>
                    <bean:define id="node" name="listcheckbox" property="node"/>
                    <bean:define id="name" name="listcheckbox" property="name"/>
                    <% // added to pass different type to statusServlet d226010
                      if ((serverType != null) && (serverType.equals("genericserver"))) { 
                         String encodedStatusLink = statusservlet + "?text=true&type=genericserver&node=" + URLEncoder.encode((String)node,encoding) + "&name=" + URLEncoder.encode((String)name,encoding);
                         String imageSrcLink = statusservlet + "?type=genericserver&node=" + URLEncoder.encode((String)node,encoding) + "&name=" + URLEncoder.encode((String)name,encoding);
                         %>
                     <A target="statuswindow" href="<%=encodedStatusLink%>">
                    <IMG name="statusIcon" border="0" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' SRC="<%=imageSrcLink%>" ALT="<%=statusAlt%>" TITLE="<%=statusAlt%>">
                    </A>
                     <% } else { 
                         String encodedStatusLink = statusservlet + "?text=true&type=server&node=" + URLEncoder.encode((String)node, encoding) + "&name=" + URLEncoder.encode((String)name, encoding);
                         String imageSrcLink = statusservlet + "?type=server&node=" + URLEncoder.encode((String)node,encoding) + "&name=" + URLEncoder.encode((String)name,encoding);
                     %>
                    <A target="statuswindow" href="<%=encodedStatusLink%>">
                    <IMG name="statusIcon" border="0" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' SRC="<%=imageSrcLink%>" ALT="<%=statusAlt%>" TITLE="<%=statusAlt%>">
                    </A>
                    <% } %>    

                     <%  } else  { %>
                          <bean:write name="listcheckbox" property="<%=columnField%>" filter="false"/>&nbsp;
					<% } %>
						</TD>
						</logic:iterate>
					</TR>
                    <% chkcounter = chkcounter + 1; %>
					</logic:iterate>
                    
                    
				</TABLE>
                
                <input type="hidden" name="collectionFormAction" value="<%=formAction%>"/>

                  
</html:form>


<% } catch (Exception e) {e.printStackTrace();} %>


<%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages1 = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages1.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) {
           out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
           out.println("<tr class='table-row'><td>"+nonefound+"</td></tr></table>");
        }
    %>

