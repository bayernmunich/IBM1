<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page  errorPage="error.jsp" %>
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

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>

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

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="htmlFilter" classname="java.lang.String"/>


<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>
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

<%--  
        <% session.removeAttribute("preferences"); %>
        <jsp:useBean id="preferences" class="java.util.ArrayList" scope="session"/>

        <% for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();) {
            preferences.add(i.next());
           }%>

        <tiles:insert page="/secure/layouts/PreferencesLayout.jsp" controllerClass="com.ibm.ws.console.core.controller.PreferenceController">
            <tiles:put name="parent" value="<%=parent%>"/>
            <tiles:put name="preferences" beanName="preferences" beanScope="session" />
        </tiles:insert>

--%>

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

                        <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
                    <%
                        if (sortIconLocation.equalsIgnoreCase ("right"))
                        {
                    %>
                            <%=columnName%>
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
                            <A HREF="<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0"  align="texttop"  ALT="<bean:message key="not.sorted"/>"></A>
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
                    <%
                        }

                        if (!filterDisplay.equals("none")) {
                           if (columnField.equals(searchFilter)) {
                    %>
                                <HR SIZE="1"><bean:message key="quick.search.label"/>: <bean:write name="<%=formName%>" property="searchPattern" scope="session"/>
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
                <bean:define id="name" name="listcheckbox" property="name" /> 
		    

            <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
            <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>



                    <TR CLASS="table-row">

                    <%
                        if (showCheckBoxes.equals("true"))
                        {
                            if ( ConfigFileHelper.isDeleteable(refId) == true)
                            {
                                String delId = (String)resourceUri + "#" + (String) refId ;
                    %>
                        <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            <%  if ( !idColumn.equals("") ) {%>
                            <bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
                            <LABEL class="collectionLabel" for="<%=selectId%>" TITLE='<bean:message key="select.text"/>: <%=selectId%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectId%>"/>
                            <%} else { %>
                            <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=refId%>"/>
                            <%}%>
                            </LABEL>
                         </TD>

                        <%
                            } else {
                        %>
                        <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            &nbsp;
                         </TD>
                        <%
                            }
                        }
                        %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
                    <%
                        columnField = (String)cellItem.getColumnField();
                    %>

                        <TD VALIGN="top"  class="collection-table-text" headers="<%=columnField%>">

                       <%
                        if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0)
                        {
                        %>
                            <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop"></IMG>&nbsp;
                        <%
                        }
                        if (cellItem.getLink().length() > 0)
                        {
                            String hRef = cellItem.getLink() + "&refId="+refId + "&contextId=" + contextId + "&resourceUri=" + URLEncoder.encode(resourceUri) + "&perspective=" + URLEncoder.encode(perspective);
                        %>
                            <A HREF="<%=hRef%>">
                        <% }
                        if (columnField.equalsIgnoreCase("status")) {
                            if ( statusType.equals("unknown") ) {%>
                            <bean:define id="status" name="listcheckbox" property="status"/>
                            <A target="statuswindow" href="/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>">
                            <IMG role="img" name="statusIcon" onfocus='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' onmouseover='getObjectStatus("/ibm/console/status?text=true&type=<%=statusType%>&status=<%=status%>",this)' border="0" SRC="/ibm/console/status?type=<%=statusType%>&status=<%=status%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                            <%
                            } else {
                            %>
                            <tiles:useAttribute name="statusCols" classname="java.util.List"/>
                            <%  String queryString = "";
                                Iterator cols = statusCols.iterator();
                                while (cols.hasNext()) {
                                String col = (String) cols.next();%>
                                <bean:define id="colvar" name="listcheckbox" property="<%=col%>"/>
                                <%
                                queryString += "&" + col + "=" + URLEncoder.encode((String)colvar , "UTF-8");
                                }
                                String encodedStatusLink = "/ibm/console/status?text=true&type=" + statusType + queryString;
                                String imageSrcLink = "/ibm/console/status?type=" + statusType + queryString;
                                %>
                            <A target="statuswindow" href="<%=encodedStatusLink%>">
                            <IMG role="img" name="statusIcon" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' border="0" SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                           <% } %>


<%                       } else if (cellItem.getTranslate()) { %>

                            <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                            <bean:message key="<%=prop %>"/>
<%                       } else {

                          	if (htmlFilter.equalsIgnoreCase("false")) {  %>
                            	<bean:write filter="false" name="listcheckbox" property="<%=columnField%>"/>
                            	
                     	<%  } else if (columnField.equalsIgnoreCase("name")) { %>
                       			<bean:write name="listcheckbox" property="<%=columnField%>"/>&nbsp;
                       	<%  } else if (columnField.equalsIgnoreCase("protocol")) { %>
                       			<bean:write name="listcheckbox" property="<%=columnField%>"/>&nbsp;
                       	<%  } else {%>
                       			<iframe class="table-text" title="<%=columnField%>" frameborder="0" scrolling="auto" width="100%" height="30" marginwidth="0" marginheight="0" src="/ibm/console/odr?&name=<%=name%>&requestData=<%=columnField%>"></iframe>						
                       	<%  }
                     	
                       	} %>


                            <% if (cellItem.getLink().length() > 0) { %>
                            </A>
                            <% }else{ %>
                               <% if (!columnField.equalsIgnoreCase("status")) { %>
                                 &nbsp;
                               <%  } %>
                          <%  } %>

                        </TD>

                        </logic:iterate>
                    </TR>
                    <% chkcounter = chkcounter + 1; %>
                    </logic:iterate>



                </TABLE>





</html:form>


<% } catch (Exception e) {e.printStackTrace();
} %>

    <%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) {
           out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
           out.println("<tr class='table-row'><td>"+nonefound+"</td></tr></table>");
        }
    %>
