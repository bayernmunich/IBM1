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
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.MiddlewareVersionDescriptorDetailForm"%>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm"%>
<%@ page import="com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm"%>



<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<% MiddlewareVersionDescriptorDetailForm form = (MiddlewareVersionDescriptorDetailForm) session.getAttribute("com.ibm.ws.console.middlewaredescriptors.form.MiddlewareVersionDescriptorDetailForm"); %>

<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<% 	boolean val = false;
	if (readOnly != null && readOnly.equals("true"))
		val = true;
    
%>

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
        //String nonefound = messages.getMessage(request.getLocale(),"DRSSettings.noDomains.error");
		//String noneset = messages.getMessage(request.getLocale(),"EJBContainer.sfsb.noDrsSettings");
        //if (drDomainNames.size() > 0){
        //     val2 = false;
        //} else if (mbDomainNames.size() > 0)  {
         	//String contextId = form.getContextId();
	        //WorkSpace workSpace = (WorkSpace)session.getAttribute(Constants.WORKSPACE_KEY);
	        //String contextUri = ConfigFileHelper.decodeContextUri(contextId); 
	        //RepositoryContext repositoryContext = null;
	        //if (contextUri != null) {
	          //  try {
	              //  repositoryContext = workSpace.findContext(contextUri);
	            //}
	            //catch (Exception we) {
	              //  repositoryContext = null;   
	            //}
	        //}
	
	        //if (repositoryContext != null)
	        //{
	          //  String type = repositoryContext.getType().getName();
	            //if (type.equalsIgnoreCase("servers"))
	            //{
	              //  repositoryContext = repositoryContext.getParent().getParent();
	            //}
	            //else if (type.equalsIgnoreCase("applications"))
	            //{
	              //  repositoryContext = repositoryContext.getParent();
	            //}
	        //}
	        	
            //for (Iterator i = mbDomainNames.iterator(); i.hasNext(); )
            //{
            //    String d = (String) i.next();
             //   List l = util.getMultiBrokerEntries(repositoryContext, d);
             //   if (l.size() > 0)
             //       val2 = false;
            //}

           // if (val2) 
            //{
            //    nonefound = messages.getMessage(request.getLocale(),"error.replicators.dont.exist");
            //}
			
			//if(session.getAttribute("messageBrokerDomainName") == null){
		//		noneset = messages.getMessage(request.getLocale(),"EJBContainer.sfsb.noDrsSettings");
		//	}

		//}

        // Want to loop through list of properties and property groups and insert a jsp page for each.
        // properties.jsp   propgroup.jsp
        // Setting up a dummy page for now.

        //com.ibm.ws.console.core.item.PropertyItem propItem = new com.ibm.ws.console.core.item.PropertyItem();
        //propItem.setValue("");
        // value is list of label,attribute name,isrequired,type,description,isReadonly,showdescription,enumValues(optional), enumDesc(optional), units
        //propItem.setValue("middlewaredescriptor.properties.displayPort" 
        //                  +":" +"port"
        //                  +":" +"yes"
        //                  +":" +"Text" 
        //                  +":" +"middlewaredescriptor.properties.displayPortDescription" 
        //                  +":" +"false"
        //                  +":" +"yes" 
        //                  +": "
        //                  +": "
        //                  +": "
        //                  +":");

        //propItem.setLabel("middlewaredescriptor.properties.displayPort");
        //propItem.setDescription("middlewaredescriptor.properties.displayPortDescription");
        //propItem.setAttribute("port");
        //propItem.setRequired("no");
        //propItem.setType("Text");
        //propItem.setCategoryId("general");
        //propItem.setReadOnly("false");
        // value is list of label,attribute name,isrequired,type,description,isReadonly,showdescription,enumValues(optional), enumDesc(optional), units
        //propItem.setValue(propItem.getLabel() 
        //                  +":" +propItem.getAttribute()
        //                  +":" +propItem.getIsRequired()
        //                  +":" +propItem.getType() 
        //                  +":" +propItem.getDescription() 
        //                  +":" +propItem.getIsReadOnly()
        //                  +":" +propItem.getShowDescription() 
        //                  +": "
        //                  +": "
        //                  +": "
        //                  +":");
                          
        ArrayList propItems = new ArrayList();
        //propItems.add(propItem);
        //PropertiesDetailForm propDetailForm = new PropertiesDetailForm();
        //propDetailForm.setContextId("");
        //propDetailForm.setPerspective("");
        for (Iterator i = props.iterator(); i.hasNext(); ) {
            PropertiesDetailForm propDetailForm = (PropertiesDetailForm) i.next();
            // Only display the property if not hidden.  Ex: discoverymode is usually hidden.
            if (propDetailForm.getHidden()) {
                continue;
            }
            propItems = propDetailForm.getPropertyItems();
            session.setAttribute("com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm", propDetailForm);
        %>
        <tiles:insert page="/com.ibm.ws.console.middlewaredescriptors/properties.jsp" flush="false">
        <tiles:put name="formName" value"com.ibm.ws.console.middlewaredescriptors.form.PropertiesDetailForm" />
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
        <tiles:insert page="/com.ibm.ws.console.middlewaredescriptors/propgroup.jsp" flush="false">
        <tiles:put name="formName" value"com.ibm.ws.console.middlewaredescriptors.form.PropGroupDetailForm" />
        </tiles:insert>
        <%
        }%>

