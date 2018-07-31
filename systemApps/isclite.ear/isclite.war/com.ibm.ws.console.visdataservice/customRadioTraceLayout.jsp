<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

   <tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>
   <% 	boolean val = false;
	if (readOnly != null && readOnly.equals("true"))
		val = true;
	%>

   <tiles:useAttribute  name="label" classname="java.lang.String"/>
   <tiles:useAttribute  name="isRequired" classname="java.lang.String"/>
   <tiles:useAttribute  name="units" classname="java.lang.String"/>
   <tiles:useAttribute  name="desc" classname="java.lang.String"/>
   <tiles:useAttribute  name="property" classname="java.lang.String"/>
   <tiles:useAttribute  name="bean" classname="java.lang.String"/>
   <tiles:useAttribute  name="formAction" classname="java.lang.String"/>
   <tiles:useAttribute  name="formType" classname="java.lang.String"/>
   
   <bean:define id="timestampFormat" name="<%=bean%>" property="timestampFormat" type="java.lang.String"/>
   <bean:define id="fileLocation" name="<%=bean%>" property="fileLocation" type="java.lang.String"/>
   <bean:define id="rolloverSize" name="<%=bean%>" property="rolloverSize" type="java.lang.String"/>
   <bean:define id="maxNumberOfHistoricLogs" name="<%=bean%>" property="maxNumberOfHistoricLogs" type="java.lang.String"/>
   <bean:define id="writeInterval" name="<%=bean%>" property="writeInterval" type="java.lang.String"/>
   <bean:define id="writeInterval" name="<%=bean%>" property="writeIntervalUnits" type="java.lang.String"/>

                                          
        <td class="table-text" nowrap valign="top">
        <FIELDSET id="<%=label%>">
        <LEGEND TITLE="<bean:message key="<%=desc%>"/>">
            <% if (isRequired.equalsIgnoreCase("yes")) { %>
                        <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
            <% } %>         
       <bean:message key="<%=label%>"/>
        </LEGEND>
          <table  border="0" cellspacing="0" cellpadding="3" role="presentation">
               
                 <tr valign="top"> 
                  <td class="complex-property" nowrap>                    
                  <span class="requiredField">

                    <label for="timestampFormat" title='<bean:message key="timestamp.format.description"/>'>
                    	<bean:message key="timestamp.format.label"/>
					</label>
                    
                    </SPAN>
                    <BR>
                    <html:text property="timestampFormat" styleId="timestampFormat" name="<%=bean%>" size="30" styleClass="textEntryRequired" disabled="<%=val%>" />
                  </td>
                </tr>
               <tr valign="top"> 
                  <td class="complex-property" nowrap>                    
                  <span class="requiredField">

                    <label for="rolloverSize">
		                <img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
		                <bean:message key="trace.max.file.size"/>
					</label>
                    
                    </SPAN>
                    <BR>
                    <html:text property="rolloverSize" styleId="rolloverSize" name="<%=bean%>" size="15" styleClass="textEntryRequired" disabled="<%=val%>" />
                    <bean:message key="JVMLogs.maxSize.MB"/>
                  </td>
                </tr>
                <tr valign="top"> 
                  <td class="complex-property" nowrap> 
                    <span class="requiredField">
                    <label for="maxNumberOfHistoricLogs">                    
                    	<img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                    	<bean:message key="trace.max.historical.files"/>
					</label>
                    
                    </SPAN>
                    <BR>
                    <html:text property="maxNumberOfHistoricLogs" styleId="maxNumberOfHistoricLogs" name="<%=bean%>" styleClass="textEntryRequired"size="15" disabled="<%=val%>" />
                  </td>
                </tr>
                <tr valign="top"> 
                  <td class="complex-property" nowrap> 
                    <span class="requiredField">
                    <label for="fileLocation">
                    	<img src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
                    	<bean:message key="trace.file.name"/>
					</label>
                    </SPAN>
                    <BR>
                    
                    <html:text property="fileLocation" styleId="fileLocation" name="<%=bean%>" size="40" styleClass="textEntryRequiredLong" disabled="<%=val%>"/>
                    <script>bidiComplexField("fileLocation", "FILEPATH");</script>
                  </td>
                </tr>
             
            	<tr valign="top">  
      			  <td class="complex-property" valign="top" nowrap>                
		            <span class="requiredField">
		              <label for="writeInterval" title='<bean:message key="write.interval.description"/>'> 
		                <img id="requiredImage_writeInterval" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
		            	<bean:message key="write.interval.label" />
		              </label> 
		            </span>
		            <BR>
		       
		            <html:text property="writeInterval" name="<%=bean%>" size="25" styleId="writeInterval" styleClass="textEntryRequired"/>
		            
					<label class="hidden" for="writeIntervalUnits" title="<bean:message key="write.interval.description"/>">
		             	<bean:message key="write.interval.label" />
		      		</label>
		            <html:select property="writeIntervalUnits" name="<%=bean%>" styleId="writeIntervalUnits">
		                <% Vector valueVector = new Vector(3);
    					Vector descVector = new Vector(3);
    					valueVector.add("UNITS_SECONDS");
    					valueVector.add("UNITS_MINUTES");
    					valueVector.add("UNITS_HOURS");
    					valueVector.add("UNITS_DAYS");
    					descVector.addAll(valueVector);
		                session.setAttribute("descVector", descVector);
		                session.setAttribute("valueVector", valueVector); 
		                
		                for (int i=0; i < valueVector.size(); i++) { 
							 String value = (String) valueVector.elementAt(i);
							 String descript = (String) descVector.elementAt(i); %>
							 <html:option value="<%=value%>"><bean:message key="<%=descript%>"/></html:option>
		             	<%}%>
		            	</html:select>              
        			</td>                 	
         		</tr>     
               
               <tr valign="top">  
      			  <td class="complex-property" valign="top" nowrap>                
		            <span class="requiredField">
		              <label for="transformAction" title='<bean:message key="transform.action.description"/>'> 
		                <img id="requiredImage_transformAction" src="images/attend.gif" width="8" height="8" align="absmiddle" alt="<bean:message key="information.required"/>">
		            	<bean:message key="transform.action.label" />
		              </label> 
		            </span>
		            <BR>
		       
		           <html:select property="transformAction" name="<%=bean%>" styleId="transformAction">
		                <% Vector valueVector = new Vector(3);
    					Vector descVector = new Vector(3);
    					valueVector.add("TRANSFORMACTION_AVERAGE");
    					valueVector.add("TRANSFORMACTION_SKIP");
    					descVector.addAll(valueVector);
		                session.setAttribute("descVector", descVector);
		                session.setAttribute("valueVector", valueVector); 
		                
		                for (int i=0; i < valueVector.size(); i++) { 
							 String value = (String) valueVector.elementAt(i);
							 String descript = (String) descVector.elementAt(i); %>
							 <html:option value="<%=value%>"><bean:message key="<%=descript%>"/></html:option>
		             	<%}%>
		            	</html:select>              
        			</td>                 	
         		</tr>     
             
              </table>

         </FIELDSET>
        </td>
        

    

   
   
 

