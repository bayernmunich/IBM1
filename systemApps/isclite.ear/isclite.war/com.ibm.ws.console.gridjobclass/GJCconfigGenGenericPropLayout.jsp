<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2011 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>
<%-- @(#) 1.30 WEBUI/ws/code/webui.core/src/adminconsole/secure/layouts/configGenGenericPropLayout.jsp, WAS.webui.core, WASX.WEBUI 5/19/04 08:57:13 [5/24/04 08:09:06] --%>

<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext"%>  <%-- F904.6_20487.14 Removed product --%>
<%@ page import="com.ibm.websphere.management.metadata.*"%>
<%@ page import="com.ibm.websphere.management.authorizer.*"%>
<%@ page import="com.ibm.websphere.management.AdminService"%>
<%@ page import="com.ibm.websphere.management.AdminServiceFactory"%>
<%@ page import="com.ibm.ws.console.core.selector.*"%>
<%@ page import="com.ibm.ws.*"%>
<%@ page import="com.ibm.wsspi.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>

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
<tiles:useAttribute name="propertyLabel" classname="java.lang.String" />
<tiles:useAttribute name="customJspName" classname="java.lang.String" />
<tiles:useAttribute name="showButtons" classname="java.lang.String" />

<script>
function enableDisableTextField(checkBoxId, textFieldId) {
	checkBox = document.getElementById(checkBoxId);
    textField = document.getElementById(textFieldId);
   

    if (checkBox.checked) {
	    textField.style.backgroundColor = "#FFFFFF";
        textField.disabled = false;
    } else {
	    textField.style.backgroundColor = "#E0E0E0";
        textField.disabled = true;
        textField.value="";               
    }
}

function resetTextFields() {
enableDisableTextField('maxExecutionTimeChecked', 'maxExecutionTime');
enableDisableTextField('maxConcurrentJobChecked', 'maxConcurrentJob');
enableDisableTextField('maxClassSpaceChecked', 'maxClassSpace');
enableDisableTextField('maxFileAgeChecked', 'maxFileAge');
enableDisableTextField('maxJobChecked', 'maxJob');
enableDisableTextField('maxJobAgeChecked', 'maxJobAge');
}
</script>

<bean:define id="contextId"    name="<%=formName%>" property="contextId"/>
<bean:define id="perspective"    name="<%=formName%>" property="perspective"/>
<bean:define id="cntxt" name="<%= formName %>"/>

<%
   String invalidFields = "";
   Method methodList[] = cntxt.getClass().getMethods();
   for (int i = 0; i < methodList.length; i++) {
      Method m = methodList[i];
      if(m.getName().equals("getInvalidFields")) { %>
<logic:notEmpty name="<%=formName%>" property="invalidFields">
   <bean:define id="newInvalidFields" name="<%=formName%>" property="invalidFields" type="java.lang.String"/>
<%       invalidFields = newInvalidFields;%>
</logic:notEmpty>
<%
         break;
      }
   }
AdminAuthorizer adminAuthorizer = AdminAuthorizerFactory.getAdminAuthorizer();
String contextUri = ConfigFileHelper.decodeContextUri((String)contextId);
if (contextUri==null) {
    AdminService adminService = AdminServiceFactory.getAdminService();
    contextUri =  "cells/"+adminService.getCellName();
}
%>

<%
String customTextFieldJspName="/com.ibm.ws.console.gridjobclass/GJCTextFieldLayout.jsp";
String customCheckBoxJspName="/com.ibm.ws.console.gridjobclass/GJCCheckBoxLayout.jsp";

%>

<%

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
        props = ConfigFileHelper.getNodeMetadataProperties((String)contextId, request); //213515 //LIDB4138-39
    }

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
    if (request.isUserInRole("administrator")) {
        renderReadOnlyView = "no";
    }
    else if (request.isUserInRole("configurator")) {
        renderReadOnlyView = "no";
    }
}
%>

<%  
        //Boolean descriptionsOn = (Boolean) session.getAttribute("descriptionsOn");
        //String numberOfColumns = "3";
        //if (descriptionsOn.booleanValue() == false)
        //  numberOfColumns = "2";  
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
         
<a name="general"></a>
    <h2>
<% if (propertyLabel.equals("") || propertyLabel==null ) { %>    	
    		<bean:message key="config.general.properties"/>
<% } else { %>    	
    		<bean:message key="<%=propertyLabel %>"/>  
<% } %>    			
	</h2>

<% if (renderReadOnlyView.equalsIgnoreCase("yes")) { %>
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
<html:hidden property="action"/>


<table class="framing-table" role="presentation" border="0" cellpadding="5" cellspacing="0" width="100%" >

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

        
        

    <% 
          }else
         activeSubhead="";
            } else { %>
        
          <%  String showDescription = item.getShowDescription();

              fieldLevelHelpAttribute = item.getAttribute();
              if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
                  fieldLevelHelpTopic = item.getLabel();
              else
                  fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;

          %>
 
    <tr valign="top">
            <% if (item.getType().equalsIgnoreCase("jsp")) { %>
                    
        <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        </tiles:insert>
                <% } else if (item.getType().equalsIgnoreCase("Password")) { %>
               
        <tiles:insert page="/secure/layouts/passwordLayout.jsp" flush="false">
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="isReadOnly" value="yes" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>

                <% } else if (item.getType().equalsIgnoreCase("Custom")){%>
                    
        <tiles:insert name="<%=customJspName%>" flush="false" >

        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="formAction" value="<%=formAction%>" />
        <tiles:put name="formType" value="<%=formType%>" />
        <tiles:put name="size" value="5" />
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
        <tiles:put name="isRequired" value="item.getRequired()" />
        <tiles:put name="readOnly" value="true" />
        <tiles:put name="valueVector" value="<%=valueVector%>" />
        <tiles:put name="descVector" value="<%=descVector%>" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>

                <% } else   if (item.getType().equalsIgnoreCase("Label")) { %>
                        
      <tiles:insert page="/secure/layouts/headingLayout.jsp" flush="false">
    	        <tiles:put name="label" value="<%=item.getLabel() %>" />
    	        <tiles:put name="includeTD" value="true" />
                </tiles:insert>
            
                   
                 <% 
                } else {%>

                      
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

    
    <tr>
        <td class="navigation-button-section" VALIGN="top">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons" id="navigation">
        </td>
    </tr>
</table>

</html:form>
<% } %>

<% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
<html:hidden property="action"/>
<script>
dojo.addOnLoad( ariaOnLoadDetail );
</script>
<input type="hidden" id="invalidFields" value="<%=invalidFields%>"/>
<table class="framing-table" role="presentation" border="0" cellpadding="5" cellspacing="0" width="100%">

    <%
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

        
        

    <%    }else
         activeSubhead="";
            } else { %>
          
    <tr valign="top">

                <% String isRequired = item.getRequired(); 
                String strType = item.getType();
                String isReadOnly = item.getReadOnly();
                String showDescription = item.getShowDescription();

        fieldLevelHelpAttribute = item.getAttribute();
        if (fieldLevelHelpAttribute.equals(" ") || fieldLevelHelpAttribute.equals(""))
            fieldLevelHelpTopic = item.getLabel();
        else
            fieldLevelHelpTopic = topicKey + fieldLevelHelpAttribute;

                %>
                

                <% if (strType.equalsIgnoreCase("Label")) { %>
                        
        <tiles:insert page="/secure/layouts/headingLayout.jsp" flush="false">
    	        <tiles:put name="label" value="<%=item.getLabel() %>" />
    	        <tiles:put name="includeTD" value="true" />
                </tiles:insert>
                <% } %>
 
                <% if (strType.equalsIgnoreCase("Link")) { %>
                        
        <tiles:insert page="/com.ibm.ws.console.probdetermination/linkBoxLayout.jsp" flush="true">
        <tiles:put name="list" beanName="attributeList_ext" beanScope="page"/>
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
        
                <% if (strType.equalsIgnoreCase("Checkbox")) { %>
                    
        <tiles:insert page="/secure/layouts/checkBoxLayout.jsp" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>"/>
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="size" value="30" />
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
                
                <% if (strType.equalsIgnoreCase("jsp")) { %>
                    
        <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>"/>
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="readOnly" value="<%=isReadOnly%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="jspPage" value="<%=item.getRequired()%>"/>
        <tiles:put name="size" value="30" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        
        </tiles:insert>
                <% } %>
                

                <% if (strType.equalsIgnoreCase("Custom")) { %>
                    
        <tiles:insert name="<%=customJspName%>" flush="false" >

        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="formAction" value="<%=formAction%>" />
        <tiles:put name="formType" value="<%=formType%>" />
        <tiles:put name="size" value="30" />
        </tiles:insert>
                <% } %>
        
	 <% if (strType.equalsIgnoreCase("CustomCheckBox")) { %>
                    
        <tiles:insert name="<%=customCheckBoxJspName%>" flush="false" >

        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="formAction" value="<%=formAction%>" />
        <tiles:put name="formType" value="<%=formType%>" />
        <tiles:put name="size" value="30" />
        </tiles:insert>
                <% } %>
                
	 <% if (strType.equalsIgnoreCase("CustomTextField")) { %>
                    
        <tiles:insert name="<%=customTextFieldJspName%>" flush="false" >

        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="units" value="<%=item.getUnits()%>"/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="formAction" value="<%=formAction%>" />
        <tiles:put name="formType" value="<%=formType%>" />
        <tiles:put name="size" value="30" />
        </tiles:insert>
                <% } %>                
                <% if (strType.equalsIgnoreCase("select")) { 
                    
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
                    
        <tiles:insert page="/com.ibm.ws.console.probdetermination/submitLayout.jsp"  flush="false">
        <tiles:put name="label" value="<%=item.getLabel()%>" />
        <tiles:put name="isRequired" value="<%=isRequired%>" />
        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
        <tiles:put name="valueVector" value="<%=valueVector%>" />
        <tiles:put name="descVector" value="<%=descVector%>" />
        <tiles:put name="units" value=""/>
        <tiles:put name="property" value="<%=item.getAttribute()%>" />
        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
        <tiles:put name="bean" value="<%=formName%>" />
        </tiles:insert>

                <% } %>
                
                <% propCounter += 1;%>


            
    </tr>
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


    <%if (showButtons.equalsIgnoreCase("true"));
        { %>

    <tr>
        <td class="navigation-button-section" nowrap VALIGN="top">
            <input type="submit" name="apply" value="<bean:message key="button.apply"/>" class="buttons_navigation">
            <input type="submit" name="save" value="<bean:message key="button.ok"/>" class="buttons_navigation">
            <input type="reset" name="reset" value="<bean:message key="button.reset"/>" class="buttons_navigation" onclick="resetTextFields()">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
        </td>
    </tr>
    <%}%>
</table>

</html:form>
<% } %>

<%
}
%>

