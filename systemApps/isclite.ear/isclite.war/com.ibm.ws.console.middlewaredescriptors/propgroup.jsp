<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.servermanagement.webcontainer.*"%>
<%@ page import="com.ibm.ws.sm.workspace.*"%>
<%@ page import="com.ibm.ws.workspace.query.*"%>
<%@ page import="com.ibm.ws.console.core.*"%>
<%@ page import="com.ibm.websphere.product.*"%>
<%@ page import="org.apache.struts.util.MessageResources,org.apache.struts.action.Action"%>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.MiddlewareDescriptorForm"%>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm"%>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm"%>



<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<% PropGroupDetailForm form = (PropGroupDetailForm) session.getAttribute("com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm"); %>

<% 
    WorkSpaceQueryUtil util = WorkSpaceQueryUtilFactory.getUtil();
    RepositoryContext cellContext = (RepositoryContext)session.getAttribute(Constants.CURRENTCELLCTXT_KEY);
        try { 
        }
        catch (Exception e) {
            System.out.println("exception " + e.toString());
        }

        // Get list of properties and Property groups for this foreign server.
        Collection propGroups = form.getPropGroups();
        Collection props = form.getProperties();  // Make this a  list of PropItem

        boolean val2 = true;
        ServletContext servletContext = (ServletContext)pageContext.getServletContext();
        MessageResources messages = (MessageResources)servletContext.getAttribute(Action.MESSAGES_KEY);

        // Display PropGroup display descriptor.
        %>
    <tr valign="top">
        <td class="table-text"  scope="row" valign="top">
           <FIELDSET>
           <LEGEND>
               <bean:message key="<%=form.getDisplayNameKey()%>"/>
           </LEGEND> 
           <table class="framing-table" border="0" cellpadding="5" cellspacing="0" width="100%" role="presentation" >
           <tbody>

        <%
        ArrayList propItems = new ArrayList();
        for (Iterator i = props.iterator(); i.hasNext(); ) {
            PropertiesDetailForm propDetailForm = (PropertiesDetailForm) i.next();
            // Only display the property if not hidden.  Ex: discoverymode is usually hidden.
            if (propDetailForm.getHidden()) {
                continue;
            }
            propItems = propDetailForm.getPropertyItems();
            session.setAttribute("com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm", propDetailForm);
        %>
        <tiles:insert page="/com.ibm.ws.console.middlewaredescriptors/properties.jsp" flush="true">
	        <tiles:put name="formName" value="com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm" />
	        <tiles:put name="attributeList" value="<%=propItems%>" />
	        <tiles:put name="readOnly" value="false" />
	        <tiles:put name="readOnlyView" value="no" />
	        <tiles:put name="formAction" value="" />
	        <tiles:put name="formType" value="" />
	        <tiles:put name="formFocus" value="" />
        </tiles:insert>
        <%
        }%>
    <%
        for (Iterator i = propGroups.iterator(); i.hasNext(); ) {
            PropGroupDetailForm propGroupDetailForm = (PropGroupDetailForm) i.next();
            // Only display the property if not hidden.  Ex: discoverymode is usually hidden.
            if (propGroupDetailForm.getHidden()) {
                continue;
            }
            session.setAttribute("com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm", propGroupDetailForm);
        %>
	        <tiles:insert page="/com.ibm.ws.console.middlewaredescriptors/propgroup.jsp" flush="true">
	        	<tiles:put name="formName" value"com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm" />
	        </tiles:insert>
        <%
        }%>
           </tbody>
           </table>
           </FIELDSET>
        </td>
    </tr>
