<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.io.IOException"%>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ page import="com.ibm.wsspi.xd.operations.OperationsHelper" %>
<%@ page import="com.ibm.ws.xd.operations.util.OperationsQueryUtil" %>
<%@ page import="com.ibm.ws.console.xdoperations.util.Message" %>
<%@ page import="com.ibm.ws.console.xdoperations.util.OperationsDetailUtils" %>
<%@ page import="com.ibm.ws.console.xdoperations.util.Utils" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>


 



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">
<html:html locale="true">
<head>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

<!-- <link href='/ibm/console/css/ISCTheme/ja/Styles.css' rel="styleSheet" type="text/css"> -->
<title><bean:message key="messages.operation.alerts"/></title>


</head>
 <isc:detectLocale/>


<!--  -->
<%!

  	void printMessage(javax.servlet.jsp.JspWriter out2, javax.servlet.http.HttpServletRequest req, Message msg, boolean br, boolean flush) throws IOException{
    		out2.println("<span class=\'"+msg.getSpanClass()+"\'>");
		out2.println("<img align=\"baseline\" height=\"16\" width=\"16\" src=\""+ req.getContextPath()+msg.getIcon()+"\" alt=\""+msg.getDisplayType()+"\""+"\" title=\""+msg.getDisplayType()+"\" />");
		out2.println(msg.getDisplayType());
		out2.println("<b>"+msg.getDisplayName()+"</b>: "+msg.getMessage());
		out2.println("</span>");
		if (br)
			out2.println("<br/>");
		if (flush){
		   String rfi = req.getParameter("retrieverFrameId");
		   if (rfi.equals("ops_message_frame") || rfi.equals("ops_message_frame;") ||
               rfi.equals("ops_message_frame_chart") || rfi.equals("ops_message_frame_chart;")) {

			   out2.println("<script type=\"text/javascript\">");
			   out2.println("window.parent."+rfi+".updateContainerHTML('"+rfi+"')");
			   out2.println("</script>");
           }
		   out2.flush();
		}
  	}	

	void printMessages(javax.servlet.jsp.JspWriter out2, javax.servlet.http.HttpServletRequest req, List messageList) throws IOException{
			for (Iterator i = messageList.iterator(); i.hasNext();) {
					Message msg = (Message)i.next();
					printMessage(out2, req, msg, i.hasNext(), !i.hasNext());
			}
	}

	void printXDSummaryMessages(javax.servlet.jsp.JspWriter out2, javax.servlet.http.HttpServletRequest request, javax.servlet.ServletContext application) throws IOException{

		//Retrieve all messages specific to XD health - order DOES matter here, fast -> slow

		// odr messages
		List messageList = OperationsDetailUtils.getODROperationalMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), request.getLocale());
		printMessages(out2, request, messageList);
		boolean br = !messageList.isEmpty();

		// node messages
		messageList = OperationsDetailUtils.getNodeOperationalMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), request.getLocale());
		if (!messageList.isEmpty()){
			if (br)
				out2.println("<br/>");
			printMessages(out2, request, messageList);
			br = true;
		}

		// core component messages - jmx calls will occur for retrieval of these
		messageList = OperationsDetailUtils.getCoreComponentOperationalMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), request.getLocale());
		if (!messageList.isEmpty()){
			if (br)
				out2.println("<br/>");
			printMessages(out2, request, messageList);
			br = true;
		}

		// core group messages - jmx calls will occur for retrieval of these
		messageList = OperationsDetailUtils.getCoreGroupOperationalMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), request.getLocale());
		if (!messageList.isEmpty()){
			if (br)
				out2.println("<br/>");
			printMessages(out2, request, messageList);
			br = true;
		}
	}
%>

<style type="text/css">
.validation-error {
    color: #CC0000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-warn-info {
    color: #000000; font-family: Verdana,Helvetica, sans-serif; 
}
.validation-header { 
    color: #FFFFFF; background-color:#6B7A92; font-family: Verdana, sans-serif;
    font-weight:bold; 
    font-size: 65.0% 
}
.msg-text {   font-family: Verdana, sans-serif; font-size:65.0%;  
    background-image: none; 
    background-color: #F7F7F7;  
}

</style>
<body class="msg-text" role="main">

<% 
	try{
		
	String rtype = (String) request.getParameter("contextType");
	//System.out.println("rtype="+rtype);

	if (rtype!=null && (rtype.equals("all")||rtype.equals(OperationsHelper.TYPE_XDOVERALL))){
		rtype = null;
	}
	String rid = null;
	if (rtype != null) {
		String temp = Utils.getResourceName(session, rtype);
		//turn rid into node:server because that is what the messages expect. Can't change the 
		//original method because it is also used for getting the proper report
		//Condition is added to check StringIndexOutOfBoundsException
		if(temp.indexOf(' ')>=0 && (temp.lastIndexOf('/')+1)>=0 && temp.lastIndexOf(')')>=0){
		rid = temp.substring(0, temp.indexOf(' ')) + ":" + temp.substring(temp.lastIndexOf('/')+1, temp.lastIndexOf(')'));
		}
	}
	String[] id = null;
	if (rid!=null && rid.length()>0){
		rid = OperationsDetailUtils.getCellName()+":"+rid;
		id = OperationsQueryUtil.breakCollapsedId(rid);
	}

	//out2 = out;
	//Begin to get the messages
	if (rtype!=null){
		if (rtype.equals(OperationsHelper.TYPE_XDOVERALL)){
			printXDSummaryMessages(out, request, application);
		}else{
			if (rtype.equals("ApplicationDeployment") || rtype.equals("MiddlewareApps")) {
				rtype = OperationsHelper.TYPE_APPEDITION;
			} else if (rtype.equals("ServerCluster") || rtype.equals("DynamicCluster")) {
				rtype = OperationsHelper.TYPE_CLUSTER;
			} else if (rtype.equals("MiddlewareServer") || rtype.equals("ApplicationServer")) {
				rtype = OperationsHelper.TYPE_SERVER;
			} 
			//Checking Null id should not be passed
			if(id!=null){
			List messageList = OperationsDetailUtils.getStatusMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), rtype, id, request.getLocale());
			printMessages(out, request, messageList);
			}
		}

	}else{ 
	   //Pull all messages
	   
	   // need to get all resource ids
		Map ridMap = OperationsDetailUtils.getAllResourceIds();
		Set types = ridMap.keySet();
		boolean br = false;
		//iterate over each type of resource - printing messages in bursts
		for (Iterator t = types.iterator(); t.hasNext();) {
			List messageList = new ArrayList();
			if (br)
				out.println("<br/>");
			String type = (String) t.next();
			List ids = (List) ridMap.get(type);
			if (ids!=null){
				for (Iterator i = ids.iterator(); i.hasNext();) {
					id = (String[]) i.next();
					//System.out.println("id: ="+OperationsQueryUtil.collapseId(id));
					
					//Checking Null id should not be passed
					if(id!=null){
					List msgs = OperationsDetailUtils.getStatusMessages((MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY), type, id, request.getLocale());
					
					//System.out.println("id: msg size="+msgs.size());
					messageList.addAll(msgs);
					}
				}
			}
			printMessages(out, request, messageList);
			br = !messageList.isEmpty();
	    }
	   out.println("<br/>");
	   // now output xd health messages
	   printXDSummaryMessages(out, request, application);
	}
	}catch(Exception e){
		e.printStackTrace();
		try{
			out.println(e.getStackTrace()[0]);
		}catch(Exception e2){
			e2.printStackTrace();
		}
	}

%>
</body>
</html:html>
