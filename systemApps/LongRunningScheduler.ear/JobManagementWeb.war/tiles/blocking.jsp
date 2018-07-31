<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="collectionName" classname="java.lang.String"/>
<tiles:useAttribute name="numOfColumns"   classname="java.lang.String"/>

<bean:define id="collectionForm" name="<%=collectionName%>" type="com.ibm.ws.batch.jobmanagement.web.forms.AbstractCollectionForm"/>
<bean:define id="currentPage"    name="<%=collectionName%>" property="currentPage"  type="java.lang.String"/>
<bean:define id="maxPages"       name="<%=collectionName%>" property="maxPages"     type="java.lang.String"/>
<bean:define id="totalRows"      name="<%=collectionName%>" property="totalRows"    type="java.lang.String"/>
<bean:define id="refIdsSize"     name="<%=collectionName%>" property="refIdsSize"   type="java.lang.String"/>

    <!--  Block Section -->
    <TR >
      <TD CLASS="paging-button-section" VALIGN="baseline" WIDTH="1%" NOWRAP COLSPAN="<%=numOfColumns%>">
<%
  if (collectionForm.getRefIdsSizeInt() > collectionForm.getMaxRowsInt()) {
%>
      <SCRIPT language="javascript">
        document.write("<label for=\"paging-first\" title=\"<bean:message key="firstPage"/>\"><INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"firstPage\"  title=\"<bean:message key="firstPage"/>\" CLASS=\"buttons\" ID=\"paging-first\" style='display:inline'></label>");
      </SCRIPT>
      <NOSCRIPT>
        <label for="paging-first" title="<bean:message key="firstPage"/>">
        <INPUT  TYPE="submit" NAME="action" VALUE="firstPage" CLASS="buttons" ID="paging-first">
        </label>
      </NOSCRIPT> 
      <SCRIPT language="javascript">
        document.write("<label for=\"paging-previous\" title=\"<bean:message key="previousPage"/>\"><INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"previousPage\"  title=\"<bean:message key="previousPage"/>\" CLASS=\"buttons\" ID=\"paging-previous\" style='display:inline;margin-left: -0.5em'></label>");
      </SCRIPT>
      <NOSCRIPT>		    
        <label for="paging-previous" title="<bean:message key="previousPage"/>">
        <INPUT  TYPE="submit" NAME="action" VALUE="previousPage" CLASS="buttons" ID="paging-previous">
        </label>
      </NOSCRIPT>  
      <bean:message key="pageOf" arg0="<%=currentPage%>" arg1="<%=maxPages%>"/>
      <SCRIPT language="javascript">
        document.write("<label for=\"paging-next\" title=\"<bean:message key="nextPage"/>\"><INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"nextPage\"  title=\"<bean:message key="nextPage"/>\" CLASS=\"buttons\" ID=\"paging-next\" style='display:inline'></label>");
      </SCRIPT>
      <NOSCRIPT>	
        <label for="paging-next" title="<bean:message key="nextPage"/>">	    
        <INPUT  TYPE="submit" NAME="action" VALUE="nextPage" CLASS="buttons" ID="paging-next">
        </label>
      </NOSCRIPT> 
      <SCRIPT language="javascript">
        document.write("<label for=\"paging-last\" title=\"<bean:message key="lastPage"/>\"><INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"lastPage\"  title=\"<bean:message key="lastPage"/>\" CLASS=\"buttons\" ID=\"paging-last\" style='display:inline;margin-left: -0.5em'></label>");
      </SCRIPT>
      <NOSCRIPT>		    
        <label for="paging-last" title="<bean:message key="lastPage"/>">
        <INPUT  TYPE="submit" NAME="action" VALUE="lastPage" CLASS="buttons" ID="paging-last">
        </label>
      </NOSCRIPT>   
      &nbsp;&nbsp;&nbsp; <label for="jumpto" title="<bean:message key="jumpTo"/>"><bean:message key="jumpToPage"/>
      <INPUT TYPE="text" NAME="jumpto" size="3" class="noIndentTextEntry"/></label>
      <SCRIPT language="javascript">
        document.write("<label for=\"paging-jump-to\" title=\"<bean:message key="jumpToPage"/>\"><INPUT  TYPE=\"submit\" NAME=\"action\" VALUE=\"jumpToPage\"  title=\"<bean:message key="jumpTo"/>\" CLASS=\"buttons\" ID=\"paging-jump-to\" style='display:inline;margin-left: -0.5em'></label>");
      </SCRIPT>
      <NOSCRIPT>		    
        <label for="paging-jump-to" title="<bean:message key="jumpToPage"/>">
        <INPUT  TYPE="submit" NAME="action" VALUE="jumpToPage" CLASS="buttons" ID="paging-jump-to">
        </label>
      </NOSCRIPT>
<%
  }
%>
        &nbsp;&nbsp;&nbsp;
	    <bean:message key="filtered"/>&nbsp;<%=refIdsSize%>&nbsp;&nbsp;&nbsp;               
        <bean:message key="total"/>&nbsp;<%=totalRows%>&nbsp;&nbsp;&nbsp;               
      </TD>
    </TR>
    <!--  End of Block Section -->