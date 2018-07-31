<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<SCRIPT type="text/javascript">

</SCRIPT>

<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="java.util.*,com.ibm.ws.security.core.SecurityContext,com.ibm.websphere.product.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>


<tiles:useAttribute name="attributeList" classname="java.util.List"/>
<tiles:useAttribute name="actionForm" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />
<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="descImage" classname="java.lang.String" />

<%  // defect 126608
  String image = ""; 
  String pluginId = "";
  String pluginRoot = "";

  if (descImage != "")
  {
     int index = descImage.indexOf ("pluginId=");
     if (index >= 0)
     {
        pluginId = descImage.substring (index + 9);
        if (index != 0)
           descImage = descImage.substring (0, index);
        else
           descImage = "";
     }
     else 
     {
        index = descImage.indexOf ("pluginContextRoot=");
        if (index >= 0)
        {
           pluginRoot = descImage.substring (index + 18);
           if (index != 0)
              descImage = descImage.substring (0, index);
           else
              descImage = "";
        }
     }
  }
%>
<ibmcommon:setPluginInformation pluginIdentifier="<%=pluginId%>" pluginContextRoot="<%=pluginRoot%>"/>
<ibmcommon:detectLocale/>

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

<% if (renderReadOnlyView.equalsIgnoreCase("yes")) { %>
	<table border="0" cellpadding="3" cellspacing="1" width="100%" 	summary="property table">
        
        <tbody>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
  
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
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
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
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="size" value="30" />
                    </tiles:insert>

            <% } else if (item.getType().equalsIgnoreCase("jsp")) { %>
                    <tiles:insert page="<%=item.getUnits()%>" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="size" value="30" />
                    </tiles:insert>

                <% } else if (item.getType().equalsIgnoreCase("Select")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    
                    if (item.getAttribute().equals("type"))
                    { %>
                        <label for="Predefined" title="<bean:message key="healthclass.customCondition.predefined.text"/>">
 		      				<html:radio property="conditionType" styleId="Predefined" value="Predefined"/>
			              	<bean:message key="healthclass.customCondition.predefined.text"/>
 		    			</label>
				<%	}                    
                    
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
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                    </tiles:insert>
                    
                    <%
                       if (item.getAttribute().equals("type"))
                       { %>
                        <label for="Custom" title="<bean:message key="healthclass.customCondition.text"/>">
 		      				<html:radio property="conditionType" styleId="Custom" value="Custom"/>
			              	<bean:message key="healthclass.customCondition.text"/>
 		    			</label>
				<%	   }                    
                     } else if (item.getType().equalsIgnoreCase("DynamicSelect")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                    Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

                    session.setAttribute("descVector", descriptVector);
                    session.setAttribute("valueVector", valVector);
                    %>

                    <tiles:insert page="/secure/layouts/dynamicSelectionLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="true" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="multiSelect" value="<%=item.isMultiSelect()%>" />
        		    </tiles:insert>
                <% } else if (item.getType().equalsIgnoreCase("Password")) { %>
                
          <td class="table-text" scope="row" nowrap>
          <label  for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
          	<bean:message key="<%= item.getLabel() %>"/>
          </label>
      	  <br>
      	  ******</td>
          
                <% } else { %>

          <td class="table-text" scope="row" nowrap>
          <label  for="{attributeName}" title='<bean:message key="<%=item.getDescription()%>"/>'>
          	<bean:message key="<%= item.getLabel() %>"/>
          </label><br><bean:write property="<%= item.getAttribute() %>" name="<%=actionForm%>"/></td>
          
          <% } %>
          
              
        </tr>
        
        <% }%>  
        
        </logic:iterate>
        
        <tr>
          <th class="button-section">
            <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.back"/>" class="buttons" id="navigation">
          </th>
        </tr>
        
        </tbody>
     </table>
 <% } %>

<% if (renderReadOnlyView.equalsIgnoreCase("no")) { %>

<html:hidden property="action"/>
	<table border="0" cellpadding="3" cellspacing="1" width="100%" 	summary="property table">

        <tbody>
        
        <logic:iterate id="item" name="attributeList" type="com.ibm.ws.console.core.item.PropertyItem">
        
        
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
            RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
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
 
                 <% if (strType.equalsIgnoreCase("Text")) {
                 
                 		if (item.getAttribute().equalsIgnoreCase("goalValue")) { 
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
			                    <tiles:insert page="/com.ibm.ws.console.policyconfiguration/goalValueTextFieldLayout.jsp" flush="false">
			                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
			                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
			                        <tiles:put name="isRequired" value="<%=isRequired%>" />
			                        <tiles:put name="label" value="<%=item.getLabel()%>" />
			                        <tiles:put name="size" value="15" />
			                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
			                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
			                        <tiles:put name="bean" value="<%=actionForm%>" />
			                        <tiles:put name="valueVector" value="<%=valueVector%>" />
		                        	<tiles:put name="descVector" value="<%=descVector%>" />
			                    </tiles:insert>             		
		               	<% }
		               	
		               	else if (item.getAttribute().equalsIgnoreCase("goalPercent")) { %>
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="3" />
		                        <tiles:put name="units" value="percent.sign"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=actionForm%>" />
		                    </tiles:insert>
		                <% 
		                } 
		                else  { %>
						   <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
		                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
		                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
		                        <tiles:put name="isRequired" value="<%=isRequired%>" />
		                        <tiles:put name="label" value="<%=item.getLabel()%>" />
		                        <tiles:put name="size" value="30" />
		                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
		                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
		                        <tiles:put name="bean" value="<%=actionForm%>" />
		                    </tiles:insert>
		                <% 
		                }
		           } %>
		                
    
                <% if (strType.equalsIgnoreCase("TextArea")) { %>
                    <tiles:insert page="/secure/layouts/textAreaLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isReadOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value="<%=item.getUnits()%>"/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                    </tiles:insert>
                <% } %>        

                <% if (strType.equalsIgnoreCase("FilePath")) { %>
                     <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                     <tiles:put name="property" value="<%=item.getAttribute()%>" />
                     <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
                     <tiles:put name="isRequired" value="<%=isRequired%>"/>
                     <tiles:put name="label" value="<%=item.getLabel()%>" />
                     <tiles:put name="size" value="90" />
                     <tiles:put name="units" value="<%=item.getUnits()%>"/>
                     <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                     <tiles:put name="bean" value="<%=actionForm%>" />
                     <tiles:put name="complexType" value="FILEPATH" />
                     </tiles:insert>
                <% } %>
                
                <% if (strType.equalsIgnoreCase("URL")) { %>
                     <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                     <tiles:put name="property" value="<%=item.getAttribute()%>" />
                     <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
                     <tiles:put name="isRequired" value="<%=isRequired%>"/>
                     <tiles:put name="label" value="<%=item.getLabel()%>" />
                     <tiles:put name="size" value="90"  />
                     <tiles:put name="units" value="<%=item.getUnits()%>"/>
                     <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                     <tiles:put name="bean" value="<%=actionForm%>" />
                     <tiles:put name="complexType" value="URL" />
                     </tiles:insert>
                <% } %>
                
                <% if (strType.equalsIgnoreCase("EMAIL")) { %>
                     <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                     <tiles:put name="property" value="<%=item.getAttribute()%>" />
                     <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
                     <tiles:put name="isRequired" value="<%=isRequired%>"/>
                     <tiles:put name="label" value="<%=item.getLabel()%>" />
                     <tiles:put name="size" value="90" />
                     <tiles:put name="units" value="<%=item.getUnits()%>"/>
                     <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                     <tiles:put name="bean" value="<%=actionForm%>" />
                     <tiles:put name="complexType" value="EMAIL" />
                     </tiles:insert>
                <% } %>
                
                <% if (strType.equalsIgnoreCase("XPATH")) { %>
                     <tiles:insert page="/secure/layouts/textFieldLayout.jsp" flush="false">
                     <tiles:put name="property" value="<%=item.getAttribute()%>" />
                     <tiles:put name="isReadOnly" value="<%=isReadOnly%>"/>
                     <tiles:put name="isRequired" value="<%=isRequired%>"/>
                     <tiles:put name="label" value="<%=item.getLabel()%>" />
                     <tiles:put name="size" value="90" />
                     <tiles:put name="units" value="<%=item.getUnits()%>"/>
                     <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                     <tiles:put name="bean" value="<%=actionForm%>" />
                     <tiles:put name="complexType" value="XPATH" />
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
                        <tiles:put name="bean" value="<%=actionForm%>" />
                    </tiles:insert>
                <% } %>
                
                <% if (strType.equalsIgnoreCase("Custom")) { %>
                    <tiles:insert page="/secure/layouts/customLayout.jsp" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="readOnly" value="false" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                    </tiles:insert>
                <% } %>
                
                <% if (strType.equalsIgnoreCase("jsp")) { %>
                    <tiles:insert page="<%=item.getUnits()%>" flush="false">
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
                        <tiles:put name="readOnly" value="false" />
                        <tiles:put name="jspPage" value="<%=item.getUnits()%>"/>
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="isRequired" value="<%=item.getRequired()%>" />
                    </tiles:insert>
                <% } %>
        
                <% if (strType.equalsIgnoreCase("Select")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }

                   if (item.getAttribute().equals("type"))
                    { %>
                        <label for="Predefined" title="<bean:message key="healthclass.customCondition.predefined.text"/>">
 		      				<html:radio property="conditionType" styleId="Predefined" value="Predefined"/>
			              	<bean:message key="healthclass.customCondition.predefined.text"/>
 		    			</label>
				<%	}                    
                    
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
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
        		    </tiles:insert>

                <% 
                       if (item.getAttribute().equals("type"))
                       { %>
                        <label for="Custom" title="<bean:message key="healthclass.customCondition.text"/>">
 		      				<html:radio property="conditionType" styleId="Custom" value="Custom"/>
			              	<bean:message key="healthclass.customCondition.text"/>
 		    			</label>
				<%	   }                    
                } 
                
                  if (strType.equalsIgnoreCase("DynamicSelect")) { 
                    try {
                        session.removeAttribute("valueVector");
                        session.removeAttribute("descVector");
                    }
                    catch (Exception e) {
                    }
                    Vector valVector = (Vector) session.getAttribute(item.getEnumValues());
                    Vector descriptVector = (Vector) session.getAttribute(item.getEnumDesc());

                    session.setAttribute("descVector", descriptVector);
                    session.setAttribute("valueVector", valVector);
                    %>

                    <tiles:insert page="/secure/layouts/dynamicSelectionLayout.jsp" flush="false">
                        <tiles:put name="property" value="<%=item.getAttribute()%>" />
                        <tiles:put name="readOnly" value="<%=isReadOnly%>" />
                        <tiles:put name="isRequired" value="<%=isRequired%>" />
                        <tiles:put name="label" value="<%=item.getLabel()%>" />
                        <tiles:put name="size" value="30" />
                        <tiles:put name="units" value=""/>
                        <tiles:put name="desc" value="<%=item.getDescription()%>"/>
                        <tiles:put name="bean" value="<%=actionForm%>" />
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
                        <tiles:put name="bean" value="<%=actionForm%>" />
		              </tiles:insert>
                <% } %>

<% } %>    

        </tr>

        </logic:iterate>
        
        </tbody>
</table> 

<% } %>

<br>


