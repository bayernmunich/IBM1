<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action,java.net.URLEncoder"%>
<%@ page import="java.util.*" %>
<%@ page  errorPage="/error.jsp" %>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.item.CollectionItem"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%
int chkcounter = 0;
%>


<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String" />
<tiles:useAttribute name="selectionType" classname="java.lang.String"/>
<tiles:useAttribute name="columnList" classname="java.util.List"/>
<tiles:useAttribute name="createButtons" classname="java.lang.String"/>
<tiles:useAttribute name="selectName" classname="java.lang.String"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="includeButtonTile" classname="java.lang.String"/>

<%String contextId_new=null;%>

<logic:notEmpty name="<%=iterationName%>" property="contextId">
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>
  <%contextId_new = contextId;%>
</logic:notEmpty>


<!-- gets all the Collection items which matches with the contextType and 
     compatibilty criteria using plugin registry API -->

<%
String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.List collectionList_ext = null;
java.util.Properties props= null;

java.util.ArrayList columnList_ext =  new java.util.ArrayList();
            for(int i=0;i<columnList.size(); i++)
                columnList_ext.add(columnList.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.collectionItem";
    IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType, extensionId);

    IExtension[] extensions = registry.getExtensions(extensionId, ic);

    if(extensions!=null && extensions.length>0){
    if(contextId_new!=null && contextId_new!="nocontext"){
      props = ConfigFileHelper.getNodeMetadataProperties((String)contextId_new); //213515
      }
    
    columnList_ext = CollectionItemSelector.getCollectionItems(extensions,columnList_ext,props);
}

pageContext.setAttribute("columnList_ext",columnList_ext);


 %>


<%  
    if ((includeButtonTile != null) && (includeButtonTile.equalsIgnoreCase("true"))) {
%>
<tiles:useAttribute name="buttonCount" classname="java.lang.String"/>
<tiles:useAttribute name="definitionName" classname="java.lang.String"/>
<tiles:useAttribute name="includeForm" classname="java.lang.String"/>
<tiles:useAttribute name="actionList" classname="java.util.List"/>
<%
    }
    String showCheckBoxes = "true";
    if (!selectionType.equals("multiple")) {
	   showCheckBoxes = "false";
	}
%>


    <%@ include file="/secure/layouts/filterSetup.jspf" %>  
        

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>

<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
<%  
    if ((includeButtonTile != null) && (includeButtonTile.equalsIgnoreCase("true"))) {
%>
    <tiles:insert page="/secure/layouts/buttonLayout.jsp">
        <tiles:put name="buttonCount" beanName="buttonCount" beanScope="page"/>
        <tiles:put name="definitionName" beanName="definitionName" beanScope="page"/>
        <tiles:put name="includeForm" beanName="includeForm" beanScope="page"/>
        <tiles:put name="actionList" beanName="actionList" beanScope="page"/>
    </tiles:insert>
<%
    }
%>
            
            <%@ include file="/secure/layouts/tableControlsLayout.jspf" %>
        

<table border="0" cellpadding="3" cellspacing="1" width="100%" summary="List table" class="framing-table">
    <tr>
        <%--
        <th class="column-head-name" scope="col" width="1%">
          <bean:message key="select.text"/>
         </th>
        <logic:iterate id="column" name="columnList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
            <%{%>
            <% 
            	String nextOrder = "ASC";
               	String imageName = "Sort_ascend2.gif";
            	if (order.equals("ASC")) {
            		nextOrder = "DSC";
               		imageName = "Sort_desc2.gif";
            	}
           	%>
            <%
                sortable = (String)column.getIsSortable();
                columnField = (String)column.getColumnField();
                String tmpName = column.getTooltip();
                String columnName = translatedText.getMessage(request.getLocale(),tmpName);
                
               if (chkcounter == 0) {
                  if (searchFilter.equals("")) {
                     searchFilter = columnField;
                  }
               }
            %>            
            <th class="column-head-name" scope="col" nowrap>
                <bean:message key="<%=column.getTooltip()%>"/>
                <%
                	String theAction = formAction;
                	if (theAction.indexOf("?") != -1) {
                		theAction += "&";
                	}
                	else {
                		theAction += "?";
                	}
                %>	
                <a href="<%=theAction%>SortAction=sort&col=<%=column.getColumnField()%>&order=<%=nextOrder%>"> 
                    <logic:equal name="column" property="isSortable" value="true">
                        <img src="<%=request.getContextPath()%>/images/<%=imageName%>" border=0 align="texttop" alt="" width="8" height="12"> 
                    </logic:equal>
                    <logic:equal name="column" property="isSortable" value="false">
                        <img src="<%=request.getContextPath()%>/images/blank20.gif" BORDER="0" WIDTH="9" HEIGHT="13" ALT=""> 
                    </logic:equal>
                </a> 
            </th>
            <%}%>
            
                <% chkcounter = chkcounter + 1; %> 
                 
        </logic:iterate>
        
        --%>
        
                        <TH NOWRAP VALIGN="TOP" CLASS="column-head-name" SCOPE="col" id="selectCell" WIDTH="1%">
                            <bean:message key="select.text"/>
                        </TH>
                   

                            <logic:iterate id="column" name="columnList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
                    <%
						sortable = (String)column.getIsSortable();
						columnField = (String)column.getColumnField();
                        String tmpName = column.getTooltip();
                        String columnName = translatedText.getMessage(request.getLocale(),tmpName);
                        
                       if (chkcounter == 0) {
                          if (searchFilter.equals("")) {
                             searchFilter = columnField;
                          }
                       }
                    %>
                    
                        <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  ID="<%=columnField%>">                    
						    
                                <%=columnName%>

                                      <%
                                            String theAction = formAction;
                                            if (theAction.indexOf("?") != -1) {
                                                    theAction += "&";
                                            }
                                            else {
                                                    theAction += "?";
                                            }
                                      %>                                                          

                                
					<%
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
							<A HREF="<%=theAction%>SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
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
							<A HREF="<%=theAction%>SortAction=true&col=<%=columnField%>&order=ASC">
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0" align="texttop"  ALT="<bean:message key="not.sorted"/>">
                            </A>
					<%
							}
						}
					%>
                    <%  

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
        
        
    </tr>
    
    
    
            <%@ include file="/secure/layouts/filterControlsLayout.jspf" %>  
            
            
            <% chkcounter = 0; %>
             
    
    
    <logic:iterate id="collectionItem" name="<%=iterationName%>" property="<%=iterationProperty%>">
    
        <TR CLASS="table-row">
        
            <% int collectionCount = 0; %>
            <logic:iterate id="column" name="columnList_ext" type="com.ibm.ws.console.core.item.CollectionItem">
                <bean:define id="value" name="collectionItem" property="<%=column.getColumnField()%>" type="java.lang.String"/>
                <!-- CMVC 273297 -->
                <bean:define id="nodevalue" name="collectionItem" property="node" type="java.lang.String"/>
                <bean:define id="servervalue" name="collectionItem" property="server" type="java.lang.String"/>
                <%  if (collectionCount++ < 1) { %>
                    <td class="collection-table-text"  width="1%">
                    <%if(!selectionType.equals("none")){%>
                   
                        <LABEL class="collectionLabel" for="<%=selectName%>" TITLE="<bean:message key="select.text"/>: <%=value%>">
                        <logic:equal name="selectionType" value="single">
 							<% String serverNode=servervalue+"@"+nodevalue; %>
	                       
                            <html:radio property="<%=selectName%>" value="<%=serverNode%>" styleId="<%=value%>"/>
                        </logic:equal>
                        <logic:equal name="selectionType" value="multiple">
                            <html:multibox property="<%=selectName%>" 
                                           value="<%=value%>" 
                                           onclick="checkChecks(this)" 
                                           onkeypress="checkChecks(this)"
                                           styleId="<%=value%>"/>
                        </logic:equal>
                        </LABEL>
                        <%}%>
                        <logic:equal name="selectionType" value="none">
                            &nbsp;
                        </logic:equal>
                    </td>
                <% } %>
                <td class="collection-table-text" >
                    <logic:notEqual name="column" property="link" value="">
                        <%
                            String link = column.getLink();
                            if (link.indexOf('?') != -1)
                                link = link+"&"+column.getColumnField()+"="+URLEncoder.encode(value);
                            else
                                link = link+"?"+column.getColumnField()+"="+URLEncoder.encode(value);
                        %>
                        <a href="<%=link%>">
                    </logic:notEqual>
                    <%=value%>
                    <logic:notEqual name="column" property="link" value="">
                        </a>
                    </logic:notEqual>
                </td>
            </logic:iterate>
            
        </tr>
        
    <% chkcounter = chkcounter + 1; %>

    </logic:iterate>
    

        <logic:equal name="createButtons" value="true">
        <tr>
            <td class="button-section" colspan="4"> 
                <html:submit property="action" styleClass="buttons" styleId="navigation">
                    <bean:message key="button.ok"/>
                </html:submit>
                <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons" id="navigation">
            </td>
        </tr>
    </logic:equal>
</table>
</html:form>

    <%  
        MessageResources messages = (MessageResources)servletContext.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) { 
        out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'><tr><td class='table-text'>"+nonefound+"</td></tr></table>"); 
        }  
    %>

