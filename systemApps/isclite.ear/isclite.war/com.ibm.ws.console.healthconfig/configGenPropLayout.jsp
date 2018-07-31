<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006, 2013 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>  <%-- LIDB2303A --%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizer"%>
<%@ page import="com.ibm.websphere.management.authorizer.AdminAuthorizerFactory"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessor"%>
<%@ page import="com.ibm.websphere.management.metadata.ManagedObjectMetadataAccessorFactory"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
                                                                                      
<tiles:useAttribute  name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute  name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="formFocus" classname="java.lang.String" />
<tiles:useAttribute name="showButtons" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showOkButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showApplyButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showCancelButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showResetButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showBackButton" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="showGenPropsHeading" classname="java.lang.String" ignore="true"/>
<tiles:useAttribute name="requiredRole" classname="java.lang.String" ignore="true" />
<tiles:useAttribute name="onReset" classname="java.lang.String" ignore="true" />

<%String contextId = null;%>
<logic:notEmpty name="<%=formName%>" property="contextId">
<bean:define id="contextId_new" name="<%=formName%>" property="contextId" type="java.lang.String"/>
<%contextId = contextId_new;%>
</logic:notEmpty>

<bean:define id="perspective"    name="<%=formName%>" property="perspective"/>


<%
AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);

String contextType=(String)request.getAttribute("contextType");
String cellname = null;
String nodename = null;
String token = null;
java.util.Properties props= null;

java.util.ArrayList attributeList_ext =  new java.util.ArrayList();
for(int i=0;i<attributeList.size(); i++)
     attributeList_ext.add(attributeList.get(i));

IPluginRegistry registry= IPluginRegistryFactory.getPluginRegistry();

String extensionId = "com.ibm.websphere.wsc.form";
IConfigurationElementSelector ic = new ConfigurationElementSelector(contextType,extensionId);

IExtension[] extensions= registry.getExtensions(extensionId,ic);

if(extensions!=null && extensions.length>0){
    if(contextId!=null && contextId!="nocontext"){
        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId); //213515
    }

    props = ConfigFileHelper.getAdditionalAdaptiveProperties(request, props, formName); // LIDB2303A

    attributeList_ext = FieldSelector.getFields(extensions,attributeList_ext,props,(String)perspective);
    }
attributeList_ext = FieldSelector.getCategories(extensions,attributeList_ext,(String)perspective);

pageContext.setAttribute("attributeList_ext",attributeList_ext);


%>


<%  String renderReadOnlyView = "no";
if( (readOnlyView != null) && (readOnlyView.equalsIgnoreCase("yes")) ) {
  renderReadOnlyView = "yes";
} else if (SecurityContext.isSecurityEnabled()) {
    renderReadOnlyView = "yes";
    if (requiredRole != null) {
         if (adminAuthorizer.checkAccess(contextUri, requiredRole)) {
              renderReadOnlyView = "no";
         }
    }

    else {
         if (adminAuthorizer.checkAccess(contextUri, "administrator")) {
             renderReadOnlyView = "no";
         }
         else if (adminAuthorizer.checkAccess(contextUri, "configurator")) {
             renderReadOnlyView = "no";
         }
    }
}
%>

<%  
        //Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
        //String numberOfColumns = "3";
        //if (descriptionsOn.booleanValue() == false)
        //  numberOfColumns = "2";  
        WASDirectory directory = new WASDirectory();
%>

<%
   String fieldLevelHelpTopic = "";
   String fieldLevelHelpAttribute = "";
   String DETAILFORM = "DetailForm";
   String objectType = "";
   int index = formType.lastIndexOf ('.');
   if (index > 0)
   {
      String fType = formType.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
   }
   fieldLevelHelpTopic = objectType+".detail.";
   String topicKey = fieldLevelHelpTopic;
%>


<% 
//  If there's no properties, don't show this section
if (attributeList_ext.size() > 0) {
%>

    <% if (showGenPropsHeading != null)
      {
          if  ((showGenPropsHeading.equalsIgnoreCase("")) || (showGenPropsHeading.equalsIgnoreCase("yes"))) 
          { 
   %>
   <a name="general"></a>
   
      <%  }           
      }     %>
   
   <% if (showGenPropsHeading != null)
      {
          if  ((showGenPropsHeading.equalsIgnoreCase("")) || (showGenPropsHeading.equalsIgnoreCase("yes"))) 
          { 
   %>
              <h2><bean:message key="config.general.properties"/></H2>  
   <%      }           
      } else { %>    
              <h2><bean:message key="config.general.properties"/></H2>  
   <% }  %>         
   
	<%
	if(onReset == null)	onReset="";
	%>
    <% if (renderReadOnlyView.equalsIgnoreCase("yes")) { %>
    

<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" onreset="<%=onReset%>">
<%--html:hidden property="action"/--%>

<table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >

    <tbody>
    
    <%
        int propCounterReadOnly = 0;
        String activeSubhead = "";

   %>

    <logic:iterate id="item" name="attributeList_ext" type="com.ibm.ws.console.core.item.PropertyItem">

    <%if (item.getCategoryId()!=null) {
	%>
    
        <%
          if ((!activeSubhead.equals(item.getCategoryId()) && (!activeSubhead.equals(""))) || ((item.getCategoryId().equalsIgnoreCase("general") && propCounterReadOnly!=0))) {
    	%>
           
	        </TABLE>
	        </FIELDSET>
	        </TD>
	        </TR>
        
        <%
    	  }
          if(!item.getCategoryId().equalsIgnoreCase("general")){
              activeSubhead = item.getCategoryId();
    	%>

        <TR>
        <TD CLASS="table-text">
        
        <FIELDSET>
        <LEGEND>
          <bean:message key="<%=item.getCategoryId()%>"/>
        </LEGEND>                        
                                
        <table class="categorizedField" id="<%=item.getCategoryId()%>" border="0" cellpadding="5" cellspacing="0" width="100%" summary="Properties Category Table" >

        
        

    <%}else
         activeSubhead="";
        } else { %>
    




    <%        fieldLevelHelpAttribute = item.getAttribute();
            if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
                fieldLevelHelpTopic = item.getLabel();
            else
                fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
            //this code gets productId from icon attribute of PropertyItem 
            //and checks if product is installed 
            // If product  is installed , then make row visible
            String productId = item.getIcon();
            boolean productEnabled = true;
            if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
                productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(com.ibm.ws.console.core.Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }

            if (productEnabled) { 
    %>
    

    <tr valign="top">

                <% if (item.getType().equalsIgnoreCase("Custom")) { %>
                        
        <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="legend" value="<%=item.getLegend()%>" />
        </tiles:insert>

                <% } else if (item.getType().equalsIgnoreCase("jsp")) { %>
                        
        <tiles:insert page="<%=item.getUnits()%>" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="size" value="30" />
        </tiles:insert>

                    <% } else if (item.getType().equalsIgnoreCase("select")) { 
                        
                        try {
                            session.removeAttribute("valueVector");
                            session.removeAttribute("descVector");
                        }
                        catch (Exception e) {
                        }
                        
                        StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
                        Vector descVector = new Vector();
                        while(st1.hasMoreTokens()) 
                        {
                            String enumDesc = st1.nextToken();
                            descVector.addElement(enumDesc);
                        }
                        StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
                        Vector valueVector = new Vector();
                        while(st.hasMoreTokens()) 
                        {
                            String str = st.nextToken();
                            valueVector.addElement(str);
                        }
            
                        session.setAttribute("descVector", descVector);
                        session.setAttribute("valueVector", valueVector);
                        %>
                        
        <tiles:insert page="/secure/layouts/submitLayout.jsp"  flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="valueVector" value="<%=valueVector%>" />
        <tiles:put name="descVector" value="<%=descVector%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>

                        <% } else if (item.getType().equalsIgnoreCase("Dynamicselect")) { 
                        try {
                            session.removeAttribute("valueVector");
                            session.removeAttribute("descVector");
                        }
                        catch (Exception e) {
                        }
                        //Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                        //Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());
                        StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
                        Vector descVector = new Vector();
                        while(st1.hasMoreTokens()) 
                        {
                            String enumDesc = st1.nextToken();
                            descVector.addElement(enumDesc);
                        }
                        StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
                        Vector valueVector = new Vector();
                        while(st.hasMoreTokens()) 
                        {
                            String str = st.nextToken();
                            valueVector.addElement(str);
                        }
            
                        session.setAttribute("descVector", descVector);
                        session.setAttribute("valueVector", valueVector);
                        %>
    
        <tiles:insert page="/com.ibm.ws.console.healthconfig/dynamicSelectionLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
        </tiles:insert>

                    <% } else if (item.getType().equalsIgnoreCase("Password")) { %>
                                  
        <td class="table-text" nowrap>
            <label  for="<%=item.getAttribute() %>">
            <bean:message key="<%= item.getLabel() %>"/>
            </label>
            <BR>
            <DIV CLASS="readOnlyElement" ID="<%= item.getAttribute() %>">
                **********
            </DIV>
        </td>

        <% } else if (item.getType().equalsIgnoreCase("FilePath")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="true"/>
              <tiles:put name="isRequired" value="<%=item.getRequired()%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="FILEPATH" />
              </tiles:insert>
         
         <% } else if (item.getType().equalsIgnoreCase("URL")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="true"/>
              <tiles:put name="isRequired" value="<%=item.getRequired()%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90"  />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="URL" />
              </tiles:insert>
         
         <% } else if (item.getType().equalsIgnoreCase("EMAIL")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="true"/>
              <tiles:put name="isRequired" value="<%=item.getRequired()%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="EMAIL" />
              </tiles:insert>

         <% } else if (item.getType().equalsIgnoreCase("XPATH")) { %>
              <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
              <tiles:put name="property" value="<%=item.getAttribute()%>" />
              <tiles:put name="isReadOnly" value="true"/>
              <tiles:put name="isRequired" value="<%=item.getRequired()%>"/>
              <tiles:put name="label" value="<%=item.getLabel()%>" />
              <tiles:put name="size" value="90" />
              <tiles:put name="units" value="<%=item.getUnits()%>"/>
              <tiles:put name="desc" value="<%=item.getDescription()%>"/>
              <tiles:put name="bean" value="<%=formName%>" />
              <tiles:put name="complexType" value="XPATH" />
              </tiles:insert>

        <% } else { %>
    
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="true" />
        <tiles:put name="isRequired" value="false" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
        

                    <% } %>
                    
                    <% propCounterReadOnly += 1;%>

              


    </tr>

            <% }%> 
            
    <%}%>

    </logic:iterate>
    
    <%
      if (!activeSubhead.equals("")) {
	%>
       
    </TABLE>
    </FIELDSET>
    </TD>
    </TR>
    
    <%
	  }
	%>

    <%if (showBackButton!=null && showBackButton.equals("yes")){ %>
    <tr>
        <td class="navigation-button-section" VALIGN="top">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons_navigation" >
        </td>
    </tr>
    <%}%>

    </tbody>

</table>

</html:form>

    <% } %>
    
    
    
    
    
    
    
    
    
    <% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>
    
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" onreset="<%=onReset%>">
<html:hidden property="action"/>
<table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
    <tbody>
             <%
               int propSet = attributeList_ext.size();
               int propEven = propSet%2;
               int propCounter = 0;
               String activeSubhead = "";

    
             %>
            
    <logic:iterate id="item" name="attributeList_ext" type="com.ibm.ws.console.core.item.PropertyItem">

    <%if (item.getCategoryId()!=null) {
	%>
    
        <%
          if ((!activeSubhead.equals(item.getCategoryId()) && (!activeSubhead.equals(""))) || ((item.getCategoryId().equalsIgnoreCase("general") && propCounter!=0))) {
    	%>
           
        </TABLE>
        </FIELDSET>
        </TD>
        </TR>
        
        <%
    	  }
          if(!item.getCategoryId().equalsIgnoreCase("general")){
              activeSubhead = item.getCategoryId();
    	%>

        <TR>
        <TD CLASS="table-text">
        
        <FIELDSET>
        <LEGEND>
          <bean:message key="<%=item.getCategoryId()%>"/>
        </LEGEND>                        
                                
        <table class="categorizedField" id="<%=item.getCategoryId()%>" border="0" cellpadding="5" cellspacing="0" width="100%" summary="Properties Category Table" >

        
        

    <%}else
         activeSubhead="";
       } else { %>
    
    <%  
            fieldLevelHelpAttribute = item.getAttribute();
            if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
                fieldLevelHelpTopic = item.getLabel();
            else
                fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;
            //this code gets productId from icon attribute of PropertyItem 
            //and checks if product is installed 
            // If product  is installed , then make row visible
            String productId = item.getIcon();
            boolean productEnabled = true;
            if ( (productId == null)  || (productId !=null && productId.equals("")) ) {
            productId = "BASE";
        } else if (productId.equals("ND") && directory.isThisProductInstalled(productId)) {
            WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(com.ibm.ws.console.core.Constants.CURRENTCELLCTXT_KEY);
            try {
                if (util.isStandAloneCell(cellContext)) {
                    productEnabled = false;
                }
                else {
                    productEnabled = true;
                } 
            }
            catch (Exception e) {
                System.out.println("exception in util.isStandAloneCell " + e.toString());
                productEnabled = false;
            }
        } else if (productId.equals("PME") && directory.isThisProductInstalled(productId)) {
                productEnabled = true;
        } else {
            productEnabled = false;
        }
    
            if (productEnabled) {
    %>
    
           

           
            <tr valign="top">
           
           
                    <% 
                    String isRequired = item.getRequired(); 
                    String strType = item.getType();
                    String isReadOnly = item.getReadOnly();
                    %>
     
                    <% if (strType.equalsIgnoreCase("FilePath")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="90" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="complexType" value="FILEPATH" />
        </tiles:insert>
                    <% } %>
     
                    <% if (strType.equalsIgnoreCase("URL")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="90"  />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="complexType" value="URL" />
        </tiles:insert>
                    <% } %>
     
                    <% if (strType.equalsIgnoreCase("EMAIL")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="90" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="complexType" value="EMAIL" />
        </tiles:insert>
                    <% } %>
     
                    <% if (strType.equalsIgnoreCase("XPATH")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="90" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="complexType" value="XPATH" />
        </tiles:insert>
                    <% } %>
     
                    <% if (strType.equalsIgnoreCase("Text")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
                    
                    <% if (strType.equalsIgnoreCase("TextMedium")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="60" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
                    
                    <% if (strType.equalsIgnoreCase("TextLong")) { %>
                        
        <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="90" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
       
                    <% if (strType.equalsIgnoreCase("TextArea")) { %>
                        
        <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="5" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
            
                    <% if (strType.equalsIgnoreCase("checkbox")) { %>
                        
        <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
            
                    <% if (strType.equalsIgnoreCase("Password")) { %>
                        
        <tiles:insert page="/secure/layouts/passwordLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
                    
                    <% if (strType.equalsIgnoreCase("Custom")) { %>
                        
        <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="legend" value="<%=item.getLegend()%>" />
        </tiles:insert>
                    <% } %>
                    
                    <% if (strType.equalsIgnoreCase("jsp")) { %>
                        
        <tiles:insert page="<%=item.getUnits()%>" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        </tiles:insert>
                    <% } %>
            
                    <% if (strType.equalsIgnoreCase("select")) { 
                        
                        try {
                            session.removeAttribute("valueVector");
                            session.removeAttribute("descVector");
                        }
                        catch (Exception e) {
                        }
                        
                        StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
                        Vector descVector = new Vector();
                        while(st1.hasMoreTokens()) 
                        {
                            String enumDesc = st1.nextToken();
                            descVector.addElement(enumDesc);
                        }
                        StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
                        Vector valueVector = new Vector();
                        while(st.hasMoreTokens()) 
                        {
                            String str = st.nextToken();
                            valueVector.addElement(str);
                        }
            
                        session.setAttribute("descVector", descVector);
                        session.setAttribute("valueVector", valueVector);
                        %>
                        
        <tiles:insert page="/secure/layouts/submitLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>
                    <% } %>
                    
                    <% if (strType.equalsIgnoreCase("Dynamicselect")) { 
                        try {
                            session.removeAttribute("valueVector");
                            session.removeAttribute("descVector");
                        }
                        catch (Exception e) {
                        }
                        //Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                        //Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());
                        StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ";,");
                        Vector descVector = new Vector();
                        while(st1.hasMoreTokens()) 
                        {
                            String enumDesc = st1.nextToken();
                            descVector.addElement(enumDesc);
                        }
                        StringTokenizer st = new StringTokenizer(item.getEnumValues(), ";,");
                        Vector valueVector = new Vector();
                        while(st.hasMoreTokens()) 
                        {
                            String str = st.nextToken();
                            valueVector.addElement(str);
                        }
    
                        session.setAttribute("descVector", descVector);
                        session.setAttribute("valueVector", valueVector);
                        %>
    
        <tiles:insert page="/com.ibm.ws.console.healthconfig/dynamicSelectionLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
        </tiles:insert>
                    <% } %>
                    

                    <% if (strType.equalsIgnoreCase("Radio")) { 
                        
                        try {
                            session.removeAttribute("valueVector");
                            session.removeAttribute("descVector");
                        }
                        catch (Exception e) {
                        }
                        
                        StringTokenizer st1 = new StringTokenizer(item.getEnumDesc(), ",");
                        Vector descVector = new Vector();
                        while(st1.hasMoreTokens()) 
                        {
                            String enumDesc = st1.nextToken();
                            descVector.addElement(enumDesc);
                        }
                        StringTokenizer st = new StringTokenizer(item.getEnumValues(), ",");
                        Vector valueVector = new Vector();
                        while(st.hasMoreTokens()) 
                        {
                            String str = st.nextToken();
                            valueVector.addElement(str);
                        }
            
                        session.setAttribute("descVector", descVector);
                        session.setAttribute("valueVector", valueVector);
                        %>
                        
        <tiles:insert page="/secure/layouts/radioButtonLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value=""/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        </tiles:insert>
                    <% } %>
    
        <% } %>    
    

             <% propCounter += 1;%>
             
             </TR>
             

    <%}%>

    </logic:iterate>
    
    <%
      if (!activeSubhead.equals("")) {
	%>
       
    </TABLE>
    </FIELDSET>
    </TD>
    </TR>
    
    <%
	  }
	%>
    
    <%
    
      if (showButtons!=null && showButtons.equalsIgnoreCase("yes"))
        { %>
    

    <tr>
        <td class="navigation-button-section" nowrap VALIGN="top">
        
            <%if (showApplyButton!=null && showApplyButton.equals("yes")){ %>

            <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation">
            <%}%>
            
            <%if (showOkButton!=null && showOkButton.equals("yes")){ %> 
            
            <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons_navigation">
            
            <%}%>
            
            <%if (showResetButton!=null && showResetButton.equals("yes")){ %>
            
            <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation">
            
            
            <%}%>
            
            <%if (showCancelButton!=null && showCancelButton.equals("yes")){ %>
            
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
            <%}%>
            
        </td>
    </tr>
    
    <%}%>

    </tbody>
</table>

</html:form>
    <% } %>
    
<br>

<%
}
%>
