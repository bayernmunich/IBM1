<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2005, 2012 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>


<%@ page language="java" import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.dynamiccluster.utils.DynamicClusterConstants"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>
<ibmcommon:detectLocale/>

<%
   MessageResources messages = (MessageResources)application.getAttribute(Action.MESSAGES_KEY);
   java.util.Locale locale = request.getLocale();
   String membershipPolicy = (String) request.getSession().getAttribute("com_ibm_ws_dynamiccluster_membershipPolicy");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">

<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<title><%= messages.getMessage(locale,"dynamiccluster.membershipPolicy.preview") %></title>

</head>
<body role="main">
   <table class="messagePortlet" border="0" cellpadding="0" cellspacing="0" valign="top" width="100%" role="presentation">
      <tr valign="top">
         <td class="table-text" nowrap>
            <FIELDSET id="membershipPolicyPreview">
               <legend for ="membershipPolicyPreview" TITLE="<%= messages.getMessage(locale,"dynamiccluster.membershipPolicy.preview.description") %>">
                 <%= messages.getMessage(locale,"dynamiccluster.membershipPolicy.preview") %>
               </legend>
               <table class="messagePortlet" border="0" cellpadding="0" cellspacing="0" valign="top" width="100%" role="presentation">
                  <tbody>
                     <tr valign="top">
                        <td class="table-text" wrap>
                        <%
                           if (membershipPolicy != null && membershipPolicy.length() > 0) {
                              com.ibm.ws.sm.workspace.WorkSpace workSpace = (com.ibm.ws.sm.workspace.WorkSpace)request.getSession().getAttribute(com.ibm.ws.console.core.Constants.WORKSPACE_KEY);
                              try {
								 membershipPolicy += DynamicClusterConstants.DEFAULT_MEMBERSHIP_POLICY_WAS_PART2;
                                 String[] nodes = com.ibm.ws.xd.config.dc.util.DynamicClusterConfigUtil.getDynamicClusterNodes(membershipPolicy, workSpace);  // this will throw exception if there is a syntax error
                                 if (nodes.length != 0) {
                         %>
                                 <table border="0" cellpadding="5" cellspacing="0" valign="top" width="100%">
                                 <tr valign="top">
                                    <td class="table-text" wrap>
                                       <%= messages.getMessage(locale,"dynamiccluster.membershipPolicy.preview.detail.description") %>
                                    </td>
                                 </tr>
                                 </table>
                         <%
                                 }
                         %>
                                 <table border="0" cellpadding="5" cellspacing="0" valign="top" width="100%">
                                 <tr valign="top">
                                    <td class="table-text" wrap>
                                       <%= messages.getMessage(locale,"dynamiccluster.total.found", new String[] {Integer.toString(nodes.length)}) %>
                                    </td>
                                 </tr>
                                 </table>
                         <%
                                 if (nodes.length != 0) {
                                    for (int i = 0; i<nodes.length; i++) {
                                       %>
                                          &nbsp;&nbsp;&nbsp;&nbsp;
                                          <img id="<%=nodes[i]%>Img" border="0" align="middle" alt="-" src="<%=request.getContextPath()%>/images/Node.gif" />
                                          <%=nodes[i]%><br/>
                                       <%
                                    }
                                    %>
                                    <br/>
                                    <%
                                 } else { // no node found
                                       %>
                                          &nbsp;&nbsp;&nbsp;&nbsp;
                                          <!-- No node found that matches this membership policy. -->
                                          <br>
                                       <%
                                 }
                              } catch (Exception e) {

                                 String errMsg = e.getMessage();
                                 if (errMsg==null) errMsg = "";

                                 String errorMessage = messages.getMessage(locale,"dynamiccluster.membershipPolicy.error.invalid", new String[] {errMsg});
                                       %>
                                          <p align="center">
                                           <table class="messagePortlet" border="0" cellpadding="0" cellspacing="0" valign="top" width="100%" role="presentation">
                                             <TBODY ID="com_ibm_ws_inlineMessages">
                                             <TR>
                                                <TD class="complex-property">
                                                   <br>
                                                   <span class='validation-error'>
                                                      <img align="baseline" height="16" width="16" src="<%=request.getContextPath()%>/images/Error.gif"/>
                                                         <%= errorMessage %>
                                                   </span>
                                                   <br><br>
                                                </td>
                                             </tr>
                                             </TBODY>
                                           </table>
                                          </p>
                                       <%
                              }
                           }
                        %>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </FIELDSET>
         </td>
      </tr>
   </table>
   </body>
</html:html>