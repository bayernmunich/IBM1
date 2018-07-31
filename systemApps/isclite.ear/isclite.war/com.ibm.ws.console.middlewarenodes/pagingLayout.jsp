<%-- IBM Confidential OCO Source Material --%>
<%-- 5630-A36 (C) COPYRIGHT International Business Machines Corp. 1997, 2003 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

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
<tiles:useAttribute name="buttons" classname="java.lang.String"/>
<%-- <jsp:useBean id="user" scope="session" class="com.ibm.ws.console.core.User"/>
<bean:define id="numberPerPage" name="user" property="range" type="java.lang.String"/>
--%>
<% String  numberPerPage = (String)session.getAttribute("paging.visibleRows");  %>

<bean:define id="searchPattern" name="<%=collectionForm%>" property="searchPattern"/>
<bean:define id="totalRows"     name="<%=collectionForm%>" property="totalRows" type="java.lang.String"/>
<bean:define id="filteredRows"  name="<%=collectionForm%>" property="filteredRows" type="java.lang.String"/>
<bean:define id="currentPage"   name="<%=collectionForm%>" property="pageNumber" type="java.lang.String"/>

<!--Number Per Page: <%=numberPerPage%><BR>Total rows: <%=totalRows%><BR>Filtered rows: <%=filteredRows%><BR>Current page: <%=currentPage%><BR>-->

<%
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

<form action="<%=formAction%>" name="<%=formName%>" type="<%=formType%>" class="nopad">
       		<input type="hidden" name="csrfid" value="<%=request.getSession().getId()%>"/>

<TABLE class="paging-table" BORDER="0" CELLPADDING="5" CELLSPACING="0" WIDTH="100%" SUMMARY="Table for displaying paging function">
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
%>
                  <SCRIPT language="javascript">
                    document.write("<INPUT TYPE=\"submit\" NAME=\"previousAction\" value=\"<bean:message key='statustray.prev.button'/>\" title=\"<bean:message key='statustray.prev.button'/>\" CLASS=\"buttons\" ID=\"<%=prevDisabled%>\" <%=pD%>>");
                  </SCRIPT>
                  <NOSCRIPT>		    
                  <INPUT TYPE="submit" NAME="previousAction" value="<bean:message key='statustray.prev.button'/>" CLASS="buttons" ID="paging" <%=prevDisabled%>>
                  </NOSCRIPT>		    
                         
                    <bean:message key="<%=pagingPageLabelKey%>"/>: <%=currentPageCount%> of <%=totalPages%>
                             
                  <SCRIPT language="javascript">
                    document.write("<INPUT  TYPE=\"submit\" NAME=\"nextAction\" VALUE=\"<bean:message key='statustray.next.button'/>\"  title=\"<bean:message key='statustray.next.button'/>\" CLASS=\"buttons\" ID=\"<%=nextDisabled%>\" <%=nD%>>");
                  </SCRIPT>
                  <NOSCRIPT>		    
                  <INPUT  TYPE="submit" NAME="nextAction" VALUE="<bean:message key='statustray.next.button'/>" CLASS="buttons" ID="paging" <%=nextDisabled%>>
                  </NOSCRIPT>  
                  
            
                    

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
<tiles:insert definition="<%=buttons%>" flush="true"/> 
</form>
