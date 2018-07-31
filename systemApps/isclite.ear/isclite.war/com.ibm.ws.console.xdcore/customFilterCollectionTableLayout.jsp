<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
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

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper" %>

<tiles:useAttribute name="iterationName" classname="java.lang.String" />
<tiles:useAttribute name="iterationProperty" classname="java.lang.String"/>
<tiles:useAttribute name="showCheckBoxes" classname="java.lang.String"/>
<tiles:useAttribute name="sortIconLocation" classname="java.lang.String"/>
<tiles:useAttribute name="columnWidth" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<tiles:useAttribute name="collectionList" classname="java.util.List" />
<tiles:useAttribute name="collectionPreferenceList" classname="java.util.List" />
<tiles:useAttribute name="parent" classname="java.lang.String"/>
<tiles:useAttribute name="tableControls" classname="java.lang.String"/>
<tiles:useAttribute name="filter" classname="java.lang.String"/>

<tiles:useAttribute name="preferenceAction" classname="java.lang.String" scope="request"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" scope="request"/>
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="idColumn" classname="java.lang.String" />
<tiles:useAttribute name="statusType" classname="java.lang.String"/>
<tiles:useAttribute name="htmlFilter" classname="java.lang.String"/>
<tiles:useAttribute name="isSubTab" ignore="true" classname="java.lang.String" />

<!-- [OPTIONAL, Default value: false] Include a row and column html tag around the paging layout -->
<tiles:useAttribute name="includeTR" classname="java.lang.String" />

<bean:define id="order" name="<%=iterationName%>" property="order" type="java.lang.String"/>
<bean:define id="sortedColumn" name="<%=iterationName%>" property="column"/>
<bean:define id="contextId" name="<%=iterationName%>" property="contextId" type="java.lang.String" toScope="request"/>
<bean:define id="perspective" name="<%=iterationName%>" property="perspective" type="java.lang.String"/>
<bean:define id="wrapColumnNames" name="<%=iterationName%>" property="wrapColumnNames" type="java.lang.String" />

<!-- gets all the collection items which matches with the contextType and
     compatibilty criteria using plugin registry API -->

<%
//Setup filter tile insert name
if (filter == null || filter.equals("")) { filter = com.ibm.ws.console.xdcore.util.XDCoreConstants.DEFAULT_FILTER_TILE_NAME; }

if (isSubTab == null) { isSubTab = "false"; }
if (includeTR == null) { includeTR = "false"; }

        int chkcounter = 0;
        try {
			ServletContext servletContext1 = (ServletContext)pageContext.getServletContext();
			MessageResources messages = (MessageResources)servletContext1.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
			String cellLabel = messages.getMessage(request.getLocale(),"label.cell");
			String nodeLabel = messages.getMessage(request.getLocale(),"label.node");
			String clusterLabel = messages.getMessage(request.getLocale(),"label.cluster");
			String serverLabel = messages.getMessage(request.getLocale(),"label.server");
			
			String encoding = response.getCharacterEncoding();
			if(encoding==null)	encoding = "UTF-8";
			
			
			String contextType=(String)request.getAttribute("contextType");
			String cellname = null;
			String nodename = null;
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
			
			    collectionList_ext = CollectionItemSelector.getCollectionItems(extensions,collectionList_ext,props,request,formName); // 299949C
			}
			
			pageContext.setAttribute("collectionList_ext",collectionList_ext);
			
			if(columnWidth==null){
				columnWidth=new Double(99.0/collectionList_ext.size()).toString()+"%";	
			}
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

        <% for (Iterator i = collectionPreferenceList_ext.iterator(); i.hasNext();) {
            preferences.add(i.next());
           }
           
           if (includeTR.equals("true")) { %>
			<tr><td>
		<% } %>
        <tiles:insert page="/com.ibm.ws.console.xdcore/customPreferencesLayout.jsp" controllerClass="com.ibm.ws.console.xdcore.controller.XDPreferenceController">
            <tiles:put name="parent" value="<%=parent%>"/>
            <tiles:put name="formAction" value="<%=preferenceAction%>"/>
            <tiles:put name="preferences" beanName="preferences" beanScope="session" />
        </tiles:insert>
<% if (includeTR.equals("true")) { %>
</td></tr>
<% } 

   if (includeTR.equals("true")) { %>
	<tr><td>
<% } %>
 <html:form action="collectionButton.do" name="<%=formName%>" styleId="<%=formName%>" type="<%=formType%>">

        <tiles:insert definition="<%=buttons%>" flush="true"/>
		<tiles:insert definition="<%=tableControls%>" flush="true"/>

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
                    <% if (wrapColumnNames.equalsIgnoreCase ("false")) { %>
                        <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" NOWRAP  WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
                    <% } else { %>
                         <TH VALIGN="TOP" CLASS="column-head-name" SCOPE="col" WIDTH="<%=columnWidth%>" ID="<%=columnField%>">
                    <% } %>
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
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13" ALT="" title="">
                    <%
                        }
                        if ((sortable.equals ("true")) && (!columnField.equals("status")) && (!columnField.equals("stability")) && (!columnField.equals("state")))
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
                            <A HREF="<%=request.getContextPath()%>/<%=formAction%>?SortAction=true&col=<%=columnField%>&order=<%=nextOrder%>">
                    <%
                                if (order.equalsIgnoreCase ("ASC"))
                                {
                    %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[0]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.ascending"/>" title="<bean:message key="sorted.ascending"/>"></A>
                    <%
                                }
                                else if (order.equalsIgnoreCase ("DSC"))
                                {
                    %>
                                <IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[1]%>" BORDER="0" align="texttop" ALT="<bean:message key="sorted.descending"/>" title="<bean:message key="sorted.descending"/>"></A>
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
                            <A HREF="<%=request.getContextPath()%>/<%=formAction%>?SortAction=true&col=<%=columnField%>&order=ASC"><IMG SRC="<%=request.getContextPath()%>/images/<%=defaultIconList[2]%>" BORDER="0" align="texttop" ALT="<bean:message key="not.sorted"/>" title="<bean:message key="not.sorted"/>"></A>
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
                            <IMG SRC="<%=request.getContextPath()%>/images/blank20.gif" align="texttop" BORDER="0" WIDTH="9" HEIGHT="13" ALT="" title="">
                    <%
                            }
                        }
                    %>
                    <% //add refresh.gif after status column to refresh page
                        if (columnField.equals("status") 
                        		|| columnField.equals("stability")
                        		|| columnField.equals("cpuUtil")
                        		|| columnField.equals("state")) { %>
                        		
                        		<% if (isSubTab.equals("true")) { %>
                        			<A HREF="javascript:switchTab()">
                        				<IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
                        					 title="<bean:message key="refresh.view"/>"
                        					 ALT="<bean:message key="refresh.view"/>" 
                        					 align="texttop" 
                        					 border="0"/>
                        			</A>
                        		<% } else {%>
							        <A HREF="<%=request.getContextPath()%>/<%=parent%>">
								        <IMG SRC="<%=request.getContextPath()%>/images/refresh.gif"  
								        	 title="<bean:message key="refresh.view"/>"
								        	 ALT="<bean:message key="refresh.view"/>" 
								        	 align="texttop" 
								        	 border="0"/>
								    </A>
							    <% }
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

                        <% chkcounter = chkcounter + 1; %>

                        </logic:iterate>
                    </TR>


	        <%@ include file="filterControlsLayout.jspf" %>

            <% chkcounter = 0; %>


            <logic:iterate id="listcheckbox" name="<%=iterationName%>" property="<%=iterationProperty%>">

            <bean:define id="resourceUri" name="listcheckbox" property="resourceUri" type="java.lang.String"/>
            <bean:define id="refId" name="listcheckbox" property="refId" type="java.lang.String"/>
            <%String contextId_detail = null;%>
            <logic:notEmpty name="listcheckbox" property="contextId">
            <bean:define id="contextId_new" name="listcheckbox" property="contextId" type="java.lang.String" toScope="request"/>
            <%contextId_detail = contextId_new;%>
            </logic:notEmpty>
            <%String builtIn = null;%>
            <logic:notEmpty name="listcheckbox" property="builtIn">
            <bean:define id="builtIn_new" name="listcheckbox" property="builtIn" type="java.lang.String" toScope="request"/>
            <%builtIn = builtIn_new;%>
            </logic:notEmpty>

            <%
            contextId_detail = ConfigFileHelper.encodeContextUri(contextId_detail);
            if(contextId_detail==null)
                contextId_detail=contextId;
            %>


                     <input type="hidden" name="<%=refId%>" value="<%=contextId_detail%>"/>




                    <TR CLASS="table-row">

                    <%
                        if (showCheckBoxes.equals("true"))
                        {
                            //Do not display checkbox if it is a builtin resource
                            if(ConfigFileHelper.isDeleteable(refId) == false || (builtIn!=null && builtIn.equalsIgnoreCase("true"))){
                         %>
                         <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            &nbsp;
                         </TD>

                         <%} else {

                            String delId = (String)resourceUri + "#" + (String) refId ;
                    %>
                        <TD VALIGN="top"  width="1%" class="collection-table-text" headers="selectCell">
                            <%  if ( !idColumn.equals("") ) {%>
                            <bean:define id="selectId" name="listcheckbox" property="<%=idColumn%>" type="java.lang.String"/>
                            <LABEL class="collectionLabel" for="<%=selectId%>" TITLE='<bean:message key="select.row.text"/> <%=chkcounter+1%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=selectId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=selectId%>"/>
                            <%} else { %>
                            <LABEL class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.row.text"/> <%=chkcounter+1%>'>
                            <html:multibox name="listcheckbox" property="selectedObjectIds" value="<%=refId%>" onclick="checkChecks(this)" onkeypress="checkChecks(this)" styleId="<%=refId%>"/>
                            <%}%>
                            </LABEL>
                         </TD>

                        <%
                            }
                         %>

                        <%
                           }
                        %>

                        <logic:iterate id="cellItem" name="collectionList_ext" type="com.ibm.ws.console.core.item.CollectionItem" >
                    <%
                        columnField = (String)cellItem.getColumnField();
                    %>

                        <TD VALIGN="top" nowrap class="collection-table-text" headers="<%=columnField%>">

                       <%
                        if (cellItem.getIcon()!=null && cellItem.getIcon().length() > 0)
                        {
                        %>
                            <IMG SRC="<%=request.getContextPath()%>/<%=cellItem.getIcon()%>" ALIGN="texttop" alt="" title=""></IMG>&nbsp;
                        <%
                        }
                        Boolean isLink = new Boolean(true);
                        %>
           				<logic:present name="listcheckbox" property="link">
                        	<bean:define id="tempIsLink" name="listcheckbox" property="link" type="java.lang.Boolean"/>
                        <%
                        	isLink = tempIsLink;
                        %>
                        </logic:present>

                        <%
                        if (cellItem.getLink().length() > 0 && isLink.booleanValue() == true)
                        {
                            String hRef = cellItem.getLink() + "&refId="+URLEncoder.encode(refId,encoding) + "&contextId=" + URLEncoder.encode(contextId_detail,encoding) + "&resourceUri=" + URLEncoder.encode(resourceUri,encoding) + "&perspective=" + URLEncoder.encode(perspective,encoding);
                        %>
                            <A HREF="<%=hRef%>">
                        <% }
                        if (columnField.equalsIgnoreCase("status")) {

                            String statusservlet = "/ibm/console/status";
                            if(cellItem.getStatusServlet()!=null)
                                statusservlet = cellItem.getStatusServlet();

                            if ( statusType.equals("unknown") ) {%>
                            <bean:define id="status" name="listcheckbox" property="status"/>
                            <A target="statuswindow" href="<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>">
                            <IMG name="statusIcon" onfocus='getObjectStatus("<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>",this)' onmouseover='getObjectStatus("<%=statusservlet%>?text=true&type=<%=statusType%>&status=<%=status%>",this)' border="0" SRC="<%=statusservlet%>?type=<%=statusType%>&status=<%=status%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
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
                                queryString += "&" + col + "=" + URLEncoder.encode((String)colvar , encoding);
                                }
                                String encodedStatusLink = statusservlet + "?text=true&type=" + statusType + queryString;
                                String imageSrcLink = statusservlet + "?type=" + statusType + queryString;
                                %>
                            <A target="statuswindow" href="<%=encodedStatusLink%>">
                            <IMG name="statusIcon" onfocus='getObjectStatus("<%=encodedStatusLink%>",this)' onmouseover='getObjectStatus("<%=encodedStatusLink%>",this)' border="0" SRC="<%=imageSrcLink%>" ALT="<bean:message key="click.for.status"/>" TITLE="<bean:message key="click.for.status"/>">
                            </A>
                           <% } %>
						
<%                      } else if(columnField.equalsIgnoreCase("state")) { 
							String iconPath = "";%>
							<bean:define id="state" name="listcheckbox" property="state" type="java.lang.String"/>
							<% if (state.equals("ops.started")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_STARTED;
							   } else if (state.equals("ops.starting")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_PARTIALSTART;
							   } else if (state.equals("ops.stopping")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_STOPPING;
							   } else if (state.equals("ops.stopped")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_STOPPED;
							   } else if (state.equals("ops.partialstart")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_PARTIALSTART;
							   } else {
									// ops.unknown
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STATUS_LEVEL_UNKNOWN;
							   }

							%>

							<img title="<bean:message key='<%=state%>'/>"
								 src="<%=request.getContextPath()+iconPath%>"
								 alt="<bean:message key='<%=state%>'/>" 
								 border="0" 
								 align="texttop">

<%                      } else if(columnField.equalsIgnoreCase("stability")) { 
							String iconPath = "";%>
							<bean:define id="stability" name="listcheckbox" property="stability" type="java.lang.String"/>
							<% if (stability.equals("resource.stability.stable")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STABILITY_LEVEL_STABLE;
							   } else if (stability.equals("resource.stability.questionable")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STABILITY_LEVEL_QUESTIONABLE;
							   } else if (stability.equals("resource.stability.unstable")) {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STABILITY_LEVEL_UNSTABLE;
							   } else {
									iconPath = com.ibm.ws.console.xdcore.util.XDCoreConstants.STABILITY_LEVEL_UNKOWN;
							   }
							%>

							<img title="<bean:message key='<%=stability%>'/>" 
								src="<%=request.getContextPath()+iconPath%>"
								alt="<bean:message key='<%=stability%>'/>" 
								border="0" 
								align="texttop">

<% 						} else if(columnField.equalsIgnoreCase("contextId")){ %>
                                  <% String token = null;
                                   String theCell = null;
                                   String theNode = null;
                                   String theCluster = null;
                                   String theServer = null;
                                   String scope_display = null;

                               StringTokenizer st = new StringTokenizer(contextId_detail,":");
                                 while(st.hasMoreElements()){
                                     token = st.nextToken();
                                     if(token.equals("cells"))
                                         theCell = st.nextToken();
                                     else
                                         if(token.equals("nodes"))
                                             theNode = st.nextToken();
                                         else
                                             if(token.equals("clusters"))
                                                 theCluster = st.nextToken();
                                             else
                                                 if(token.equals("servers"))
                                                     theServer = st.nextToken();
                                 }
                                 if(theServer!=null)
                                     scope_display = nodeLabel+"="+theNode+","+serverLabel+"="+theServer;
                                 else if(theNode!=null)
                                     scope_display= nodeLabel+"="+theNode;
                                 else if(theCluster!=null)
                                     scope_display = clusterLabel+"="+theCluster;
                                 else
                                     scope_display = cellLabel+"="+theCell;%>

                                    <%=scope_display%>


                           <% } else if (cellItem.getTranslate()) { %>

                            <bean:define id="prop" name="listcheckbox" property="<%=columnField%>" type="java.lang.String"/>
                            <bean:message key="<%=prop %>"/>
<%                       } else {
                          if (htmlFilter.equalsIgnoreCase("false")) {  %>
                            <bean:write filter="false" name="listcheckbox" property="<%=columnField%>"/>
                          <% } else {  %>
                            <bean:write name="listcheckbox" property="<%=columnField%>"/>
                     <%       }
                                 } %>


                            <% if (cellItem.getLink().length() > 0  && isLink.booleanValue() == true) { %>
                            </A>
                            <% }else{ %>
                               <% if (!columnField.equalsIgnoreCase("status") && (!columnField.equals("stability"))) { %>
                                 &nbsp;
                               <%  } %>
                          <%  } %>

                        </TD>

                        </logic:iterate>
                    </TR>
                    <% chkcounter = chkcounter + 1; %>
                    </logic:iterate>


                </TABLE>

               <input type="hidden" name="collectionFormAction" value="<%=formAction%>"/>

</html:form>
<% if (includeTR.equals("true")) { %>
</td></tr>
<% } %>

<% } catch (Exception e) {e.printStackTrace();
} %>

    <%
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages1 = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);
        String nonefound = messages1.getMessage(request.getLocale(),"Persistence.none");
        if (chkcounter == 0) {
			if (includeTR.equals("true")) {
				out.println("<tr><td>");
			}

           out.println("<table class='framing-table' cellpadding='3' cellspacing='1' width='100%'>");
           out.println("<tr class='table-row'><td>"+nonefound+"</td></tr></table>");

			if (includeTR.equals("true")) {
				out.println("</td></tr>");
			}
        }
    %>
