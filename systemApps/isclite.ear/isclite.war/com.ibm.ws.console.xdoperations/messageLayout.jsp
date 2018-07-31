<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon"%>

<tiles:useAttribute name="messageLegend" classname="java.lang.String" />
<tiles:useAttribute name="loading" classname="java.lang.String" />
<tiles:useAttribute name="retrieverFrameId" classname="java.lang.String" />
<tiles:useAttribute name="statusCellId" classname="java.lang.String" />
<tiles:useAttribute name="alertDivId" classname="java.lang.String" />

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
<!--  -->
<%
	String cType = (String) request.getAttribute("contextType");
	if (cType==null){
		cType = "xdoverall";	
	}else if (cType.equals("XDOperations")){
		cType = "all";
	}
%>

<script type="text/javascript">
<!-- Needed finalizeMessageContainer_<retrieverframeid> method for IE - otherwise recieved errors when trying to invoke it on the variable object -->
function finalizeMessageContainer_<%=retrieverFrameId%>(){
	<%=retrieverFrameId%>.finalizeMessageContainer('<%=request.getContextPath()%>','<%=retrieverFrameId%>','<%=statusCellId%>');
}

var <%=retrieverFrameId%> = function(){
	return {
		loading : true,
	        state : "inline",
		loadingMsg : '<bean:message key="<%=loading%>" />',
		divId : "<%=alertDivId%>",
		updateContainerHTML : function(frameId){
			try{
				frame = document.getElementById(frameId);
				innerDoc = (frame.contentDocument) ? frame.contentDocument : frame.contentWindow.document;
				objToResize = (frame.style) ? frame.style : frame;
				//alert(frameId+" "+innerDoc.body.scrollHeight);
				//objToResize.height = innerDoc.body.scrollHeight;
				div = document.getElementById(this.divId);
				div.innerHTML = innerDoc.body.innerHTML;
			}catch(err){
				window.status = err.message;
			}
		},

		clearStatusMessage : function(statusCellId){
			if (!this.loading){
				obj = document.getElementById(statusCellId);
				obj.innerHTML="";
			}
		},

		refreshMessages : function(frameId, statusCellId){
			frame = document.getElementById(frameId);
			frame.src="com.ibm.ws.console.xdoperations/messageRetriever.jsp?retrieverFrameId="+frameId+"&contextType=<%=cType%>";
			obj = document.getElementById(statusCellId);
			obj.innerHTML="<i>"+this.loadingMsg+"</i>";
			this.loading=true;
		},

		showHideMessages : function(objectId, context, retrieverFrameId, statusCellId){
		    if (document.getElementById(objectId) != null) {
		        if (document.getElementById(objectId).style.display == "none") {
		            document.getElementById(objectId).style.display = "inline";
		            if (document.getElementById(objectId+"Img")) {
		                document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_expanded.gif";
		            }
			    this.state = "inline";
			    this.updateContainerHTML(retrieverFrameId);
		        } else {
		            document.getElementById(objectId).style.display = "none";
		            if (document.getElementById(objectId+"Img")) {
		                document.getElementById(objectId+"Img").src = "/ibm/console/images/arrow_collapsed.gif";
		            }
			    this.state = "none";
		        }
			this.setMessageStatus(context, retrieverFrameId, statusCellId);
		    }
		},

		setMessageSummary : function(numE, numW, numI,context,statusCellId){
		    if(!this.loading){
			summary="";
		    	if (numE > 0){
				summary += "<img src=\""+context+"/images/Error.gif\" border=\"0\" align=\"absmiddle\" alt=\"Error messages\" >: "+numE+"</br>";
		    	}	   
		   	if (numW > 0){
				summary += "<img src=\""+context+"/images/Warning.gif\" border=\"0\" align=\"absmiddle\" alt=\"Warning messages\" >: "+numW+"</br>";
		   	}
		    	if (numI > 0){
				summary += "<img src=\""+context+"/images/Information.gif\" border=\"0\" align=\"absmiddle\" alt=\"Information messages\" >: "+numI+"</br>";
		    	}
		    	obj = document.getElementById(statusCellId);
		    	obj.innerHTML=summary;
		    }
		},

		setMessageStatus : function(context, retrieverFrameId, statusCellId){
					   
			frame = document.getElementById(retrieverFrameId);
			innerDoc = (frame.contentDocument) ? frame.contentDocument : frame.contentWindow.document;
		        theMess = innerDoc.body.innerHTML;
		        numE = 0;
		        numW = 0;
		        numI = 0;
		        Es = theMess.match(/Error.gif/g);
		        if (Es != null) {
		            numE = Es.length;
		        }
		        Ws = theMess.match(/Warning.gif/g);
		        if (Ws != null) {
		            numW = Ws.length;
		        }
		        Is = theMess.match(/Information.gif/g);
		        if (Is != null) {
		            numI = Is.length;
		        }
			// if there are no messages, then hide the div layer alltogether
			if (this.loading == false){
			    if ((numE == 0) && (numW ==0) && (numI==0)){
			        tblId = retrieverFrameId+"_table";
			    	document.getElementById(tblId).style.display = "none";
		    	    }	    
			}
		        if (this.state == "none") {
			   this.setMessageSummary(numE, numW, numI, context, statusCellId);			    
		        } else {
		            this.clearStatusMessage(statusCellId);
		        }
		},
		
		setLoading : function(b_load){
			this.loading = b_load;
		},
		
	        finalizeMessageContainer : function(context, retrieverFrameId, statusCellId){
			this.setLoading(false);
			this.setMessageStatus(context, retrieverFrameId, statusCellId);
			this.updateContainerHTML(retrieverFrameId);
		}				   
			 
	};
}();

</script>	

<p align="center">
  <table id="<%=retrieverFrameId+"_table"%>" class="messagePortlet" border="0" cellpadding="0" cellspacing="0" valign="top" width="75%" role="presentation">
	<tr valign="top">
		<td class="messageTitle">
			<A href="javascript:<%=retrieverFrameId%>.showHideMessages('<%=alertDivId%>','<%=request.getContextPath()%>','<%=retrieverFrameId%>','<%=statusCellId%>')" CLASS="expand-task">
			<img id="<%=alertDivId+"Img"%>" src="/ibm/console/images/arrow_expanded.gif" alt="<bean:message key="wsc.expand.collapse.alt" />" title="<bean:message key="wsc.expand.collapse.alt" />" border="0" align="absmiddle"/> 
			<bean:message key="<%=messageLegend%>" />
			</A>
		</TD>
		<td id="<%=statusCellId%>" class="messageTitle">
		<i><bean:message key="<%=loading%>" /></i>
		</td>
		<td align="right" class="messageTitle">
			<a href="javascript:<%=retrieverFrameId%>.refreshMessages('<%=retrieverFrameId%>','<%=statusCellId%>')"> 
			<img id="refresh" name="refresh" src='<%=request.getContextPath()+"/images/refresh.gif"%>' alt="<bean:message key="refresh" />" title="<bean:message key="refresh" />" border="0" align="absmiddle"/>
			</A>
		</TD>
	</TR>
	<TBODY ID="<%=retrieverFrameId+"_com_ibm_ws_inlineMessages" %>">
	<TR>
  		<iframe id="<%=retrieverFrameId%>"
  				title="<bean:message key="<%=messageLegend%>" />"
  				name="<%=retrieverFrameId%>" 
  				style="display:none;" 
  				src="<%="com.ibm.ws.console.xdoperations/messageRetriever.jsp?retrieverFrameId="+retrieverFrameId+"&contextType="+cType%>" 
  				frameborder=0 
  				width="75%" 
  				onload="finalizeMessageContainer_<%=retrieverFrameId%>()">
		       	<bean:message key="iframes.not.supported"/>
  		</iframe>	
		<TD class="complex-property" COLSPAN=3>
			<div style="max-width:75%;overflow:hidden" id="<%=alertDivId%>">
			</div>
		</td>
	</tr>
	</TBODY>
</table>
</p>

<script type="text/javascript">
	//<%=retrieverFrameId%>.showHideMessages('<%=alertDivId%>','<%=request.getContextPath()%>','<%=retrieverFrameId%>','<%=statusCellId%>');
</script>
