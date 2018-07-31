<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.ws.console.core.item.*" %>
<%@ page import="com.ibm.ws.console.core.bean.*" %>
<%@ page import="com.ibm.ws.console.core.*" %>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action" %>

<tiles:useAttribute id="formAction" name="formAction" classname="java.lang.String" />

<% 

   
    MessageResources messages = (MessageResources) application.getAttribute(Action.MESSAGES_KEY);
    String showPrefs = messages.getMessage(request.getLocale(),"show.preferences");

    String prefsState = (String)session.getAttribute("com_ibm_ws_prefsTable");
    String prefsStateImg = "arrow_collapsed.gif";
    if (prefsState == null) {
	   prefsState = "none";
	} else {
       if (prefsState.equals("inline")) {
		  prefsStateImg = "arrow_expanded.gif";
	   }
	}
             
%>


<html:form action="<%=formAction%>" method="get" styleClass="nopad">


        <table border="0" cellpadding="2" cellspacing="0" valign="top" width="100%" role="presentation" >
        <tbody>
          <tr valign="top"> 
            <td class="table-text-white" id="prefs" nowrap> 
              <a href="javascript:showHideSection('com_ibm_ws_prefsTable')" CLASS="expand-task">
              <img id="com_ibm_ws_prefsTableImg" SRC="<%=request.getContextPath()%>/images/<%=prefsStateImg%>" alt="<%=showPrefs%>" title="<%=showPrefs%>" border="0" align="texttop"/>
              <bean:message key="statustray.preferences.label" /></A>
              <html:hidden property="show" value="collapsed" />
            </td>
          </tr>
          </tbody>
        </table>
        
        
      


        <table id="com_ibm_ws_prefsTable" style="display:<%=prefsState%>" border="0" cellpadding="2" cellspacing="0" valign="top" width="100%" role="presentation" >
          <tbody>
                    
              <tr> 
                <td class="complex-property"> 
                  <table border="0" cellpadding="4" cellspacing="1" width="90%" role="presentation">
                  <% 
                   int i = 0;  
                   List prefsList = (List)request.getAttribute("preferences");
                   UserPreferenceBean uBean = (UserPreferenceBean)session.getAttribute(Constants.USER_PREFS);
                   String dataType="";
                   String node="";
                   String defaultValue="";
                   String units = "";
                   String HTMLFormElementName=""; 
                   String HTMLDataTypeName=""; 
                   String HTMLNodeName=""; 
                   String HTMLDefaultValueName="";
                   int prefsSize = prefsList.size();
                   for (Iterator iter = prefsList.iterator(); iter.hasNext();) {
                   i++;
                   PreferenceItem item = (PreferenceItem) iter.next();
                                                  
                   %>
                      <tr>
                      
                            <td class="find-filter"  valign="top" nowrap>
                      <%
                        if (item.getPrefType().equals("text")) {
                            dataType = item.getDataType();          
                            node = item.getPrefEntry(); 
                            defaultValue = item.getDefaultValue();
                            units = item.getUnits(); 
                            HTMLFormElementName = "text"+i;
                            HTMLDataTypeName = "dataType"+i; 
                            HTMLNodeName = "node"+i;
                            HTMLDefaultValueName = "defaultValue"+i;
                  
                       %>
                               <label FOR="<%=HTMLFormElementName%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>">
                               <bean:message key="<%=item.getLabel()%>"/>
                               </label>                                
                                <BR> 
                        
                        
                        <% if (node != null) { 
                            String invalidTextValue = (String) request.getAttribute(node + "_InvalidValue");
                            request.removeAttribute(node + "_InvalidValue");
                            %>
                        
                             <% if (defaultValue != null) {
                                     if (invalidTextValue != null) { %>
                                        <INPUT type="text" id="<%=HTMLFormElementName%>" class="textEntry" name="<%=HTMLFormElementName%>" size="<%=item.getSize()%>" value="<%=invalidTextValue%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>"/>
                                     <% } else {    %>
                                        <INPUT type="text" id="<%=HTMLFormElementName%>" class="textEntry" name="<%=HTMLFormElementName%>" size="<%=item.getSize()%>" value="<%=uBean.getProperty(node, defaultValue)%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>"/>
                                     <% } %>   
                                    <% if (units != null && !units.equals(" ") && !units.equals("")) { %> <bean:message key="<%=units%>"/> <% } %>
                                 
                             <%} else {
                                 if (invalidTextValue != null) { %>
                                       <INPUT type="text" id="<%=HTMLFormElementName%>" class="textEntry" name="<%=HTMLFormElementName%>" size="<%=item.getSize()%>" value="<%=invalidTextValue%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>"/>
                                 <% } else {    %>      
                                       <INPUT type="text" id="<%=HTMLFormElementName%>" class="textEntry" name="<%=HTMLFormElementName%>" size="<%=item.getSize()%>" value="<%=uBean.getProperty(node, "")%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>"/>
                                 <% } %>   
                                    <% if (units != null && !units.equals(" ") && !units.equals("")) { %> <bean:message key="<%=units%>"/> <% } %>

                             <%}%>
                             
                        <%} else { %>
                                 <INPUT type="text" id="<%=HTMLFormElementName%>" class="textEntry" name="<%=HTMLFormElementName%>" size="<%=item.getSize()%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>"/>
                                 <% if (units != null && !units.equals(" ") && !units.equals("")) { %> <bean:message key="<%=units%>"/> <% } %>
 
                        <%}%>
                        
                          
                        <INPUT type="hidden"  name="<%=HTMLDataTypeName%>"     value="<%=dataType%>" />
                        <INPUT type="hidden"  name="<%=HTMLNodeName%>"         value="<%=node%>" />
                        <INPUT type="hidden"  name="<%=HTMLDefaultValueName%>" value="<%=defaultValue%>" /> 
                        
                        
                        
                     <% 
                       } else if (item.getPrefType().equals("checkbox")) {
                           node = item.getPrefEntry(); 
                           defaultValue = item.getDefaultValue(); 
                           units = item.getUnits(); 
                           HTMLFormElementName = "checkbox"+i;
                           HTMLNodeName = "node"+i; 
                           HTMLDefaultValueName = "defaultValue"+i; 
                      %>
                      

                       
                  <%if (node != null) { %> 
                        
                           <%if (defaultValue == null) {
                               defaultValue = "false";
                             }
                           String val = uBean.getProperty(node, defaultValue); 
						   %>
                           
                        <% 
                          String newunits = messages.getMessage(request.getLocale(),units);
                    	  String newlabel = messages.getMessage(request.getLocale(),item.getLabel());
                    
                    	  if (units == null || units.equals("") || units.equals(" ") || (newunits.length() < newlabel.length())) {
                             newunits = newlabel;
                    	  }
                        %>                           
                           
                          <label FOR="<%=HTMLFormElementName%>" TITLE="<bean:message key="<%=item.getDesc()%>"/>">                          
                               <INPUT class="chkbox" id="<%=HTMLFormElementName%>" type="checkbox" name="<%=HTMLFormElementName%>"  <%=((val.equals("true")) ? "CHECKED" : "")%> /> 
                               <%=newunits%>
                          </label>

                       <%}%>
                       
                       
                        <INPUT type="hidden"   name="<%=HTMLNodeName%>"         value="<%=node%>" />
                        <INPUT type="hidden"   name="<%=HTMLDefaultValueName%>" value="<%=defaultValue%>" />
                        
                    
                   <%}
                   }
                    %>
            
                     </td>
                    </tr>
                
               
  
          <INPUT type="hidden" name="counter" VALUE="<%=i%>" />
          
                   <tr> 
                  <td valign="top" class="navigation-button-section"> 
                    <html:submit property="submit2" styleClass="buttons_section-button">
                    	<bean:message key="button.apply"/>
                    </html:submit>
                    <% // CMVC defect 224729 %>
                    <INPUT type="hidden" name="submit2" value="Enter" />
                    <html:reset styleClass="buttons_section-button">
                    	<bean:message key="button.reset"/>
                    </html:reset>
                  </td>
                </tr>

              </table>
            </td>
          </tr>
          </tbody>
        </table>

</html:form>