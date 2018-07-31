<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="java.util.*,java.lang.reflect.*,com.ibm.ws.console.policyconfiguration.form.ServiceClassDetailForm"%>
<%@ page import="java.beans.*"%>
<%@ page errorPage="/error.jsp"%>
<%@ page import="com.ibm.ws.console.core.*"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>

<tiles:useAttribute name="readOnlyView" classname="java.lang.String"/>
<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />

<script language="JavaScript">
var scField;

function initVars(formElem){
	var theform = formElem.form;
	scField = theform.servclassField;
	return true;
}


function submitIt() {
	var selectedApp = scField.value;
		window.location = encodeURI("/ibm/console/ServiceClassDetail.do?SCSelected=true" + "&scName=" + encodeURI(selectedApp)   
           + "&csrfid=" + "<%=session.getAttribute("com.ibm.ws.console.CSRFToken")%>");
}


</script>

<%
try {

String fieldLevelHelpTopic = "";
String fieldLevelHelpAttribute = "";
String DETAILFORM = "DetailForm";
String objectType = "";
int index = formType.lastIndexOf ('.');
if (index > 0) {
      String fType = formType.substring (index+1);
      if (fType.endsWith (DETAILFORM))
         objectType = fType.substring (0, fType.length()-DETAILFORM.length());
      else
         objectType = fType;
}
fieldLevelHelpTopic = objectType+".move.";
String topicKey = fieldLevelHelpTopic;
	
ServiceClassDetailForm testForm = (ServiceClassDetailForm)session.getAttribute("ServiceClassDetailForm");
Collection scNames = testForm.getSCNamesToShow();
pageContext.setAttribute("appNamesBean", scNames);

String initVars = "initVars(this);";
String applyClick = initVars + " submitIt()";
%>
        
<html:form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>">
   <table>
        <TR>
        <TD CLASS="table-text">
        
        <FIELDSET>
        <LEGEND>
			<bean:message key="serviceclass.move.title"/>
	    </LEGEND>                        
                                
        <table class="categorizedField" id="transactionclass.move.table" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
  			<tbody>
            <tr valign="top">
       			<td class="table-text" valign="top">
              		<span class="requiredField">
		                <label for="servclassField" title="<bean:message key="serviceclass.move.description1"/>">
		                	<bean:message key="serviceclass.detail.title" /> 
        		        </label>
              		</span>
            	</td>
	            <td class="table-text" valign="top" width="25%">
					<html:select size="1" value="SC test 4" property="notUsed" styleId="servclassField">
						<html:options name="appNamesBean"/>
					</html:select>
				</td>                
             </TR>        
        </FIELDSET>
        <tr>
	      <td>
            <input type="button" name="selectSC" value="<bean:message key="button.ok"/>" class="buttons_navigation" onclick="<%=applyClick%>">
            <input type="submit" name="cancelSelectSC" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
          </td>
        </tr>
      </tbody>
    </table>
     </TD>
    </TR>
   </table>
</html:form>
<%
 
}
catch (Exception e) {
	e.printStackTrace();
}%>			
