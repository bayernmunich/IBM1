<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp. 1997, 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="com.ibm.ws.console.middlewarenodes.topology.*,com.ibm.ws.sm.workspace.*,com.ibm.ws.console.core.*,com.ibm.ws.console.core.mbean.*,javax.management.*"%>
<%@ page import="com.ibm.ws.security.core.SecurityContext"%>

<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<ibmcommon:detectLocale/>

<tiles:useAttribute name="confirmDescription" classname="java.lang.String"/>
<tiles:useAttribute name="contextType" classname="java.lang.String"/>

<html:html locale="true">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">


<body CLASS="content" >

<html:form action="removeMiddlewareNode.do" name="com.ibm.ws.console.middlewarenodes.MiddlewareNodeCollectionForm" type="com.ibm.ws.console.middlewarenodes.topology.MiddlewareNodeCollectionForm">

<p class="description-text">
<bean:message key="<%=confirmDescription%>"/>
<ul>
<%
	MiddlewareNodeCollectionForm collectionForm = (MiddlewareNodeCollectionForm) session.getAttribute("com.ibm.ws.console.middlewarenodes.MiddlewareNodeCollectionForm");		
	String selectedObjectIds[]= collectionForm.getSelectedObjectIds();
	for (int i = 0; ((selectedObjectIds != null) && (i < selectedObjectIds.length)); i++) {
		    	String nodeName =  selectedObjectIds[i];
 %>
<li CLASS="black-bullet"><%=nodeName%></li>
<% } %>
</ul>
<BR>
<%    if (SecurityContext.isSecurityEnabled() &&
          contextType.equals("remove.middlewarenode.confirmation")) { %>
<table class="framing-table" border="0" cellpadding="3" cellspacing="1" width="100%" summary="Properties Table" >
<TBODY>
     <tr valign="top">
          <td class="table-text"  nowrap valign="top" scope="row">
	      <label  for="user" TITLE="<bean:message key="add.node.user.description"/>">
          <bean:message key="add.node.user.displayName"/>
          </label>
	
            <BR>
              <html:text property="user" styleId="user" styleClass="textEntry" size="30" />

		  </td>
     </tr>

     <tr valign="top">
          <td class="table-text"  scope="row"><label  for="{attributeName}">
	  <label for="password" TITLE="<bean:message key="add.node.password.description" />">
      <bean:message key="add.node.password.displayName"/></label>
        <label>
        <BR>
              <input type="password" class="textEntry" id="password" name="password" size="30"/>	
		  </td>
     </tr>
	 </TBODY>
	 </TABLE>
	
<% } %>

</p>
          <input type="submit" name=<%=contextType%> value="<bean:message key="button.ok"/>" class="buttons_navigation">
          <input type="submit" name="org.apache.struts.taglib.html.CANCEL" value="<bean:message key="button.cancel"/>" class="buttons_navigation">
	
</html:form>
</BODY>
</html:html>
