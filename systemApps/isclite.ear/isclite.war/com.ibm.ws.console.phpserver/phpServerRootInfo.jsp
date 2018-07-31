<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.phpserver.PHPServerDetailForm"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<% PHPServerDetailForm form = (PHPServerDetailForm) session.getAttribute("com.ibm.ws.console.phpserver.PHPServerDetailForm"); %>   

  //  boolean val = false;
	//if (readOnly != null && readOnly.equals("true"))
	//	val = true;


//    String clusterName = form.getClusterName();
<%
	  String rootApache = form.getRootApache();
	  String rootPHP = form.getRootPHP();	  
%>

<table width="100%" border="0" cellspacing="0" cellpadding="2">


<tr> 
  <td class="table-text" nowrap>
    <LABEL FOR="rootApache"
    	title="<bean:message key="PHPServer.detail.rootPHP.description"/>">        
    	<bean:message 
    		key="PHPServer.detail.rootPHP.description"/>
    </LABEL><BR>   
    <html:text property="rootApache" styleId="rootApache" 
    	styleClass="textEntryLong" disabled="true"/>
  </td>
</tr>
<tr> 
  <td class="table-text"> 
    <label FOR="rootApache" title="<bean:message key="PHPServer.detail.rootPHP.description"/>">
        <bean:message key="PHPServer.detail.rootPHP.description"/>
    </LABEL>  
  </td>
</tr>
</table>



<table width="100%" border="0" cellspacing="0" cellpadding="2">

<tr> 
  <td class="table-text"> 
    <label FOR="rootApache" title="<bean:message key="PHPServer.detail.rootPHP.description"/>">
        <bean:message key="PHPServer.detail.rootPHP.displayName"/>
    </LABEL>  
  </td>
</tr>
</table>


