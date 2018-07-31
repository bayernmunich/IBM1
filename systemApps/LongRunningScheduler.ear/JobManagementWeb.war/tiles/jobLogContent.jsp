<%@ page import="com.ibm.ws.batch.jobmanagement.web.util.JMCUtils" errorPage="/errors/error.jsp" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<bean:define id="id"                 name="JobDetailForm" property="refId"              type="java.lang.String"/>
<bean:define id="currentPage"        name="JobDetailForm" property="currentPage"        type="java.lang.String"/>
<bean:define id="currentPageContent" name="JobDetailForm" property="currentPageContent" type="java.lang.String"/>
<bean:define id="numOfPages"         name="JobDetailForm" property="numOfPages"         type="java.lang.Integer"/>
<bean:define id="jobCurrentState"    name="JobDetailForm" property="jobCurrentState"    type="java.lang.String"/>
<bean:define id="canRefresh"         name="JobDetailForm" property="canRefresh"         type="java.lang.String"/>

<%
    id = JMCUtils.convertToCharset(id, response.getCharacterEncoding());
%>

  <form name="JobDetailForm" method="post" action="/jmc/viewJobLog.do" ENCTYPE="multipart/form-data">
  <tr>
    <td>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" width="50%" CLASS="framing-table" role="presentation">
      <tr> 
        <td class="table-text">
        
        <textarea wrap="off"  title="<bean:message key="jobLogViewTitle"/>" readonly="readonly" rows="40" cols="100" class="log-text" id="joblogcontent">
<%=currentPageContent%>
        </textarea>
        
        </td>
      </tr>
	  
<% if (numOfPages.intValue() > 1) { %>
	  
      <!--  Block Section -->
      <TR>
			
		
        <TD CLASS="paging-button-section" VALIGN="baseline" WIDTH="1%" NOWRAP colspan="1">
		
		<button type="submit" name="action" value="firstPage" id="first" title="<bean:message key="firstPage"/>" class="first"><img src="images/wtable_first.gif" alt="<bean:message key="firstPage"/>"><SPAN style="offscreen">firstPage</SPAN></button>
		
		
       <!-- <SCRIPT language="javascript">
          document.write("<INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"firstPage\"  title=\"<bean:message key="firstPage"/>\" CLASS=\"toolbar1\" ID=\"prnt\" style='display:inline'></label>");
        </SCRIPT>
        <NOSCRIPT>
          
          <INPUT  TYPE="submit" title="<bean:message key="firstPage"/>" NAME="action" VALUE="firstPage" CLASS="toolbar" ID="paging-first">
          
        </NOSCRIPT> -->
		
		<button type="submit" name="action" value="previousPage" id="previous" "title="<bean:message key="previousPage"/>" class="previous"><img src="images/wtable_previous.gif" alt="<bean:message key="previousPage"/>"> <SPAN style="offscreen">previousPage</SPAN></button>
        <!--<SCRIPT language="javascript">
          document.write("<INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"previousPage\"  title=\"<bean:message key="previousPage"/>\" CLASS=\"buttons\" ID=\"paging-previous\" style='display:inline;margin-left: -0.5em'></label>");
        </SCRIPT>
        <NOSCRIPT>		    
          
          <INPUT  TYPE="submit" title="<bean:message key="previousPage"/>" NAME="action" VALUE="previousPage" CLASS="buttons" ID="paging-previous">
          
        </NOSCRIPT> -->
        <bean:message key="pageOf" arg0="<%=currentPage%>" arg1="<%=numOfPages.toString()%>"/>
		
		
        <button type="submit" name="action" value="nextPage" id="next" title="<bean:message key="nextPage"/>" class="next"><img src="images/wtable_next.gif" alt="<bean:message key="nextPage"/>"> <SPAN style="offscreen">nextPage</SPAN></button>
		
		
		
        <!--<SCRIPT language="javascript">
          document.write("<INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"nextPage\"  title=\"<bean:message key="nextPage"/>\" CLASS=\"buttons\" ID=\"paging-next\" style='display:inline'></label>");
        </SCRIPT>
        <NOSCRIPT>		    
          
          <INPUT  TYPE="submit" title="<bean:message key="nextPage"/>" NAME="action" VALUE="nextPage" CLASS="buttons" ID="paging-next">
          
        </NOSCRIPT> -->
		
		<button type="submit" name="action" id="last" title="<bean:message key="lastPage"/>" value="lastPage" class="last"><img src="images/wtable_last.gif" alt="<bean:message key="lastPage"/>"> <SPAN style="offscreen">lastPage</SPAN> </button>
        <!--<SCRIPT language="javascript">
          document.write("<INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"lastPage\"  title=\"<bean:message key="lastPage"/>\" CLASS=\"buttons\" ID=\"paging-last\" style='display:inline;margin-left: -0.5em'></label>");
        </SCRIPT>
        <NOSCRIPT>		    
          
          <INPUT  TYPE="submit" title="<bean:message key="lastPage"/>" NAME="action" VALUE="lastPage" CLASS="buttons" ID="paging-last">
          
        </NOSCRIPT>  -->
        &nbsp;&nbsp;&nbsp; <bean:message key="jumpToPage"/>
        <INPUT TYPE="text" NAME="jumpto" size="3" title="<bean:message key="jumpTo"/>" class="noIndentTextEntry" id="jumpto"/>
		
		<button type="submit" name="action" id="jump"  title="<bean:message key="jumpTo"/>" value="jumpToPage" class="jump"><img src="images/wtable_jump_to.gif" alt="<bean:message key="jumpTo"/>"><SPAN style="offscreen">jumpToPage</SPAN></button>
        <!--<SCRIPT language="javascript">
          document.write("<INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"jumpToPage\"  title=\"<bean:message key="jumpTo"/>\" CLASS=\"buttons\" ID=\"paging-jump-to\" style='display:inline;margin-left: -0.5em'></label>");
        </SCRIPT>
        <NOSCRIPT>		    
          
          <INPUT  TYPE="submit" title="<bean:message key="jumpToPage"/>" NAME="action" VALUE="jumpToPage" CLASS="buttons" ID="paging-jump-to">
          
        </NOSCRIPT>            -->
        </TD>
      </TR>
      <!--  End of Block Section -->
<% } %>
    </TABLE>
    </td>
  </tr>
  <tr>
    <td class="navigation-button-section" VALIGN="top">
      <input type="hidden" name="refId" value="<%= id %>"/>
      <input type="hidden" name="jobCurrentState" value="<%= jobCurrentState %>"/>
      <input type="submit" name="button.refresh"  value="<bean:message key="button.refresh"/>"  class="buttons" id="button.refresh" style="margin-left: -0.5em;" <%=canRefresh.equals("true") ? "" : "disabled"%>>
      <input type="submit" name="button.download" value="<bean:message key="button.download"/>" class="buttons" id="button.download">
      <input type="submit" name="button.back"     value="<bean:message key="viewJobs"/>"            class="buttons" id="button.back">
    </td>
  </tr>
  </form>

<script>
	document.getElementById("joblogcontent").focus();
</script>
	
