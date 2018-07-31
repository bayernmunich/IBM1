<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>

<%@ page  errorPage="error.jsp" %>
<%@ page import="com.ibm.ws.console.core.selector.CollectionItemSelector"%>
<%@ page import="com.ibm.ws.console.core.selector.ConfigurationElementSelector"%>
<%@ page import="com.ibm.ws.console.core.selector.PreferenceSelector"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>

<% 

MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
java.util.Locale locale = request.getLocale();
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
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String"/> 
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/> 


<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

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
        props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName);
    }

    if(extensions!=null && extensions.length>0){

    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props);
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
            
<%-- Preferences at the top --%>            
<% session.removeAttribute("preferences"); %>                   
<jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>
<% for (Iterator i = collectionPreferenceList.iterator(); i.hasNext();)
{
    preferences.add(i.next());
}%>

<tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
    <tiles:put name="parent" value="<%=parent%>"/>
    <tiles:put name="preferences" beanName="preferences" beanScope="session" />
</tiles:insert>



<html:form action="<%=formAction%>" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">

       <tiles:insert definition="<%=buttons%>" flush="true"/>
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


                     <logic:iterate id="cellItem" name="collectionList" type="com.ibm.ws.console.core.item.CollectionItem">
                     <%
                     sortable = (String)cellItem.getIsSortable();
                     columnField = (String)cellItem.getColumnField();
                     columnWidth = "25%";
                     
                     %>

                     <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>">
                     <%
                     if (sortIconLocation.equalsIgnoreCase ("right")) {  %>
                            <bean:message key="<%=cellItem.getTooltip()%>"/>
                     <%
                     }
                     if (sortable.equals ("false"))
                     {
                     %>
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13">       
                     <%
                     }
                     if (sortable.equals ("true"))
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
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.ascending"/>">
              <%
                                   }
                                   else if (order.equalsIgnoreCase ("DSC"))
                                   {
              %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.descending"/>">
              <%
                                   }
              %>
                            </A>
              <%
                            }
                            else
                            {
              %>
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC">
                             <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0"  align="texttop"  ALT="<bean:message key="not.sorted"/>">
                            </A>
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
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" BORDER="0" WIDTH="9" HEIGHT="13"> 
              <%
                            }
                     }
              %>
              <% //add refresh.gif after status column to refresh page
                  if (columnField.equals("status")) { %>
                  <A HREF="<%=parent%>"><IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  ALT="<bean:message key="refresh.view"/>" align="texttop" border="0"/></A>
              <%
                  }

                  if (!filterDisplay.equals("none")) {
                     if (columnField.equals(searchFilter)) {
              %>
                          <HR SIZE="1"><bean:message key="quick.search.label"/>: <%=searchPattern%>
              <%
                     }
                  }
              %>
              </TH>
              </logic:iterate>
              </TR>
              <%@ include file="/secure/layouts/filterControlsLayout.jspf" %>
                    
               
                  <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">
      
                  <bean:define id="resourceUri" name="<%=iterationName%>" property="resourceUri" type="java.lang.String"/>
                  <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
                  <bean:define id="dsJndiName" name="listcheckbox" property="dsJndiName" type="java.lang.String"/>
                  <% 	System.out.println("dsJndiName= " + dsJndiName); 	%>
                  <bean:define id="hrefLink" name="listcheckbox" property="hrefLink" type="java.lang.String"/>
                  <bean:define id="name" name="listcheckbox" property="name" type="java.lang.String"/>
                     
                                   <TR CLASS="table-row">                                        
                                   <!-- <TR BGCOLOR="#FFFFFF">-->
                                   <%
                                          if (showCheckBoxes.equals("true"))
                                          {
                            if ( ConfigFileHelper.isDeleteable(refId) == true)
                            {
                                String delId = (String)resourceUri + "#" + (String) refId ;
                                   %>
                                         
                             <%
                             } else {
                             %>
                   
                                          <!-- TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell"> &nbsp;</TD> -->                    
                                          <!-- <TD VALIGN="top" CLASS="table-text" WIDTH="1%" HEADERS="header1"> &nbsp;</TD>-->
                                   <%
                                              } 
                        }
                    %>
                                          <logic:iterate id="cellItem" name="collectionList" type="com.ibm.ws.console.core.item.CollectionItem" >
                                   <%
                                          columnField = (String)cellItem.getColumnField();
                                   %>
                                
                                          <TD VALIGN="top"  class="collection-table-text" headers="<%=columnField%>">
                                          <!-- <TD VALIGN="top" CLASS="table-text" HEADERS="header2">-->
                                   <%
                                          if (cellItem.getIcon().length() > 0)
                                          {
                                   %>                     
                                                 <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="BASELINE"></IMG>&nbsp;
                                   <%
                                          }              
                                          if (columnField.equalsIgnoreCase("name"))
                                          {
                                                 //String hRef = hrefAction + "&refId="+refId + "&contextId=" + contextId + "&resourceUri=" + URLEncoder.encode(resourceUri,"UTF-8") + "&perspective=" + URLEncoder.encode(perspective,"UTF-8");
                                   %>
                                                 <A HREF="<%=hrefLink%>">
                                    <% } 
                                          if(columnField.equalsIgnoreCase("dsJndiName")) {
                                    %>
                                          
                                          <bean:define id="dsJndiList" name="listcheckbox" property="dsJndiList" type="java.util.List"/>
                					<%    
                        					Iterator i_dsJndiList = dsJndiList.iterator();
                					%> 
                        					<!--select name="dsJndiName_<%=name%>" id="dsJndiName_<%=name%>"-->
                        					    
                					<%
                        					while (i_dsJndiList.hasNext()) {
                            					
                            					String jndiName = (String) i_dsJndiList.next();
                            					System.out.println("jndiName= " + jndiName);
                            					
                            					//if(jndiName.equals(dsJndiName)){  
                					%>
                                         <%=jndiName%>
                						<!--option value="<%=jndiName%>" selected><%=jndiName%></option-->
                					<%	
                						//continue; } 
                					%>	
                                				<!--option value="<%=jndiName%>"><%=jndiName%></option-->
                                    				
                					<%
					                            
					                        } // end while
					                %>
					                        <!--/select-->
					                    
					        
					                <%
					                    }else if (cellItem.getTranslate()) { %>
                                              <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                                              <bean:message key="<%=prop %>"/>
                                     <%}
                                             else { %>
                                     <bean:write name="listcheckbox" property="<%=columnField%>"/>&nbsp;
                                   <%       }
                                          %>
                                     
                                                 
                                                 <% if (cellItem.getLink().length() > 0) { %>
                                                 </A>
       <%}%>
                                          </TD>
                                          
                                         
                                          </logic:iterate>
                                   </TR>
                                        <% chkcounter = chkcounter + 1; %>
                                   </logic:iterate>
 

                            </TABLE> 
                  
</html:form>
                                                                

<% } 
catch (Exception e) {System.out.println("error found : " + e.toString());e.printStackTrace();} %>

<%  
ServletContext servletContext = (ServletContext)pageContext.getServletContext();
//MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
if (chkcounter == 0) { 
out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'><tr><td class='table-text'>"+nonefound+"</td></tr></table>"); 
}  
%>

