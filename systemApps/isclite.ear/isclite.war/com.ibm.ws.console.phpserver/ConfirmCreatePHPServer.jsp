<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.phpserver.*"%>
<%@ page errorPage="/error.jsp" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
									 											   
<% CreateNewPHPServerForm confirmForm = (CreateNewPHPServerForm) session.getAttribute("ConfirmCreatePHPServerForm"); %>
	
<%  String radioButton = confirmForm.getRadioButton();
	String serverName = confirmForm.getServerName();
    String nodeName = confirmForm.getSelectedNode(); 
    String selectedApacheVersion = confirmForm.getSelectedApache();
    String selectedPHPVersion = confirmForm.getSelectedPHP();
    String selectedExistingServer = confirmForm.getSelectedExistingServer();
    
    
    String confirmMessage = "phpserver.confirmPHPServer.msg4";
    if(request.getAttribute("confirmMessage")!=null){
    	confirmMessage = (String) request.getAttribute("confirmMessage");
    }
    
    String confirmMessageExisting = "phpserver.confirmPHPServer.msg5";
  %>        

<tiles:useAttribute name="actionForm" classname="java.lang.String" />


<table border="0" cellpadding="3" cellspacing="1" width="100%" role="presentation">

  <tr valign="baseline" >
      <td class="wizard-step-text" width="100%" align="left"> 
          <bean:message key="phpserver.confirmPHPServer.msg1"/>
          <bean:message key="phpserver.confirmPHPServer.msg2"/>  
	  </td>
  </tr>
</table>
   <br/>
<table border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation">
     <tr valign="top"> 
          <td class="table-text" valign="top">
           <label title='<bean:message key="wizard.summary.label.alt"/>'>
               <bean:message key="wizard.summary.label"/>:
           </label>
           <br>
           <% if (radioButton.equals("default")) {  %>
              <p class="textEntryReadOnlyLong" name="summary" style="min-height:5em">
                <bean:message key="<%=confirmMessage%>" arg0="<%=serverName%>" arg1="<%=nodeName%>" arg2="<%=selectedApacheVersion%>" arg3="<%=selectedPHPVersion%>"/>
              </p>
           <% } else {  %>
     	      <p class="textEntryReadOnlyLong" name="summary" style="min-height:5em">
     	          <bean:message key="<%=confirmMessageExisting%>" arg0="<%=serverName%>" arg1="<%=nodeName%>" arg2="<%=selectedExistingServer%>" />
     	      </p>
     	  <% }  %>
         </td>
     </tr>
     <tr valign="top"> 
          <td class="table-text" valign="top">
            <%-- <img src="<%=request.getContextPath()%>/images/Information.gif" align="absmiddle" ALT="<bean:message key="error.msg.information"/>"/>   --%>
                <%--    <bean:message key="appserver.confirmAppServer.msg8" arg0="<%=nodeName%>"/> --%>
         </TD>
     </tr>     
</table> 
  
