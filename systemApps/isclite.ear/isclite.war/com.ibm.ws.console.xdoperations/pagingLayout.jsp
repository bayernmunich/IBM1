<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page language="java" import="org.apache.struts.util.MessageResources"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute name="pagingTotalLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="displayLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="pagingFilteredTotalLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="pagingPreviousLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="pagingNextLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="pagingPageLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="pagingOfLabelKey" classname="java.lang.String" />
<tiles:useAttribute name="collectionForm" classname="java.lang.String"/>

<tiles:useAttribute name="formAction" classname="java.lang.String" />
<tiles:useAttribute name="formName" classname="java.lang.String" />
<tiles:useAttribute name="formType" classname="java.lang.String" />

<!-- [OPTIONAL, Default value: false] Include a row and column html tag around the paging layout -->
<tiles:useAttribute name="includeTR" classname="java.lang.String" />

<%-- <jsp:useBean id="user" scope="session" class="com.ibm.ws.console.core.User"/>
<bean:define id="numberPerPage" name="user" property="range" type="java.lang.String"/>
--%>
<% String contextType = (String)request.getAttribute("contextType");
   if (contextType == null)
   	   contextType = (String)request.getSession().getAttribute("contextType");
   String  numberPerPage = (String)session.getAttribute(contextType+"paging.visibleRows");  %>

<bean:define id="searchPattern" name="<%=collectionForm%>" property="searchPattern"/>
<bean:define id="totalRows"     name="<%=collectionForm%>" property="totalRows" type="java.lang.String"/>
<bean:define id="filteredRows"  name="<%=collectionForm%>" property="filteredRows" type="java.lang.String"/>
<bean:define id="currentPage"   name="<%=collectionForm%>" property="pageNumber" type="java.lang.String"/>

<style type="text/css">
.buttons#paging-next {  
    background-image: url(<%=request.getContextPath()%>/images/wtable_next.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;
    text-align: right;
    font-family: Verdana,Helvetica, sans-serif; font-size:0.0%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}
.buttons#paging-prev {  
    background-image: url(<%=request.getContextPath()%>/images/wtable_previous.gif);
    background-repeat:no-repeat;
    background-position:bottom left;
    height: 27;
    width: 27;
    text-align: right;
    font-family: Verdana,Helvetica, sans-serif; font-size:0.0%; margin: 2px 2px -2px 2px; BORDER-RIGHT: #336699 0px solid; BORDER-TOP: #8cb1d1 0px solid; BORDER-LEFT: #8cb1d1 0px solid; BORDER-BOTTOM: #336699 0px solid; BACKGROUND-COLOR: #d1d9e8;color:#d1d9e8
}
</style>

<%
//Setup optional use attributes
if (includeTR == null) { includeTR = "false"; }
	int totalCount;
   try
   {
		totalCount = Integer.parseInt (totalRows);
      if (totalCount < 0)
      {
			totalCount = 0;
      }
	}
   catch (NumberFormatException nfe)
   {
		totalCount = 0;
   }
	int filteredCount;
   try
   {
		filteredCount = Integer.parseInt (filteredRows);
      if (filteredCount < 0)
      {
			filteredCount = 0;
      }
	}
   catch (NumberFormatException nfe)
   {
		filteredCount = 0;
   }
	int numPerPageCount;
   try
   {
		numPerPageCount = Integer.parseInt (numberPerPage);
      if (numPerPageCount < 0)
      {
			numPerPageCount = 20;
      }
	}
   catch (NumberFormatException nfe)
   {
		numPerPageCount = 20;
   }
	int currentPageCount;
   try
   {
		currentPageCount = Integer.parseInt (currentPage);
      if (currentPageCount < 0)
      {
			currentPageCount = 0;
      }
	}
   catch (NumberFormatException nfe)
   {
		currentPageCount = 0;
   }
	int totalPages = 0;
	if (numPerPageCount > 0)
		totalPages = (int)(Math.ceil ((float)filteredCount/(float)numPerPageCount));
%>

<% if (includeTR.equals("true")) { %>
<tr><td>
<% } %>
<form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" class="nopad">
<input type="hidden" name="csrfid" value="<%=request.getSession().getId()%>"/>

<TABLE class="paging-table" BORDER="0" CELLPADDING="5" CELLSPACING="0" WIDTH="100%" role="presentation">
	<TR>
			
<%
	if (filteredCount > numPerPageCount && numPerPageCount > 0)
	{
%>

		<TD CLASS="paging-button-section" VALIGN="baseline" WIDTH="1%" NOWRAP>
                
<%
                String prevDisabled = "paging-prev-disabled";
                String pD = "style='display:hide'";
                String nextDisabled = "paging-next-disabled";
                String nD = "style='display:hide'";
		if (currentPageCount > 1)
		{
                  prevDisabled = "paging-prev";
                  pD = "style='display:inline'";
		}
		if (currentPageCount < totalPages)
		{
                  nextDisabled = "paging-next";
                  nD = "style='display:inline'";
                 
		}

        String[] messageargs = {Integer.toString(currentPageCount),Integer.toString(totalPages)};


        MessageResources messages = (MessageResources)application.getAttribute(org.apache.struts.Globals.MESSAGES_KEY);
        String messageString = messages.getMessage(request.getLocale(), "currentPagetotal", messageargs);

%>



                  <%
                  if(currentPageCount>1){%>	    
                  <INPUT TYPE="submit" NAME="previousAction" value="<bean:message key='statustray.prev.button'/>" CLASS="buttons" ID="<%=prevDisabled%>" <%=prevDisabled%>>
                  
                  <%}%>  	    
                         
                 <!--   <bean:message key="<%=pagingPageLabelKey%>"/>: <%=currentPageCount%> of <%=totalPages%> -->
                    
                    <bean:message key="<%=pagingPageLabelKey%>"/><bean:message key="xdoperations.paging.token"/> <%=messageString%>
                    
                    <%if(currentPageCount<totalPages){%>
		    
                  <INPUT  TYPE="submit" NAME="nextAction" VALUE="<bean:message key='statustray.next.button'/>" CLASS="buttons" ID="<%=nextDisabled%>" <%=nextDisabled%>>
                  
                  <%}%>
            
                    

             </TD>
                   
<%
	} 
%>
            <TD CLASS="table-totals" VALIGN="baseline">               
            <bean:message key="<%=pagingTotalLabelKey%>"/> <%=totalRows%>
             &nbsp;&nbsp;&nbsp;               

<%
			if(!searchPattern.equals("*")){
%>
			   <bean:message key="<%=pagingFilteredTotalLabelKey%>"/>: <%=filteredRows%>  
               &nbsp;&nbsp;&nbsp;
<%
			}
%>
		</TD>
	</TR>
</TABLE>
</form>
<% if (includeTR.equals("true")) { %>
</td></tr>
<% } %>

<script type="text/javascript">
if (typeof ariaOnLoadTop == "function") {
	ariaOnLoadTop();
}
bidiOnLoad();
</script>
