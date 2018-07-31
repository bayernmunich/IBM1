<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34 (C) COPYRIGHT International Business Machines Corp. 2004 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/ibmcommon.tld" prefix="ibmcommon" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>


<ibmcommon:detectLocale />
<html:html locale="true">
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="Expires" CONTENT="0">


<jsp:include page = "/secure/layouts/browser_detection.jsp" flush="true"/>

<script language="JavaScript" src="<%=request.getContextPath()%>/scripts/menu_functions.js"></script>

</HEAD>

          
<FORM id="quickSearchForm" name="quickSearchForm" action="http://publib.boulder.ibm.com/infocenter/wasinfo/v6r1/index.jsp" target="Infocenter"> <!-- EEB update the action link!!! -->

<TABLE WIDTH="100%" CELLPADDING="2" CELLSPACING="1" BORDER="0">

<TR>   
<TD CLASS="table-text" COLSPAN="2">
<span class="graytext"><bean:message key="xd.infocenter.desc.qs"/></span>
</TD>
</TR>
  
<SCRIPT>  
//  This section is being written out with javascript in order to make it available to all scripted users, but the
//  NOSCRIPT user would just see the search box and launch a search against the XD infocenter
 document.write("<TR>");
 document.write('<TD CLASS="table-text" ALIGN="right" NOWRAP><span class="graytext">');
 document.write('<LABEL TITLE="<bean:message key="xd.infocenter.doc.source"/>"><bean:message key="xd.infocenter.doc.label"/></LABEL>');
 document.write('</span></TD>');
 document.write('<TD CLASS="table-text" ALIGN="left"><span class="graytext">');
 document.write(' <bean:message key="xd.infocenter.doc.source.was"/>');
 document.write('</span></TD>');
 document.write('</TR>');
</SCRIPT>

<TR>
<TD CLASS="table-text" ALIGN="right" NOWRAP>
<span class="graytext"><LABEL TITLE="<bean:message key="xd.infocenter.doc.search"/>"><bean:message key="xd.infocenter.doc.search.label"/></LABEL></SPAN>
</TD>
<TD CLASS="table-text" ALIGN="left" NOWRAP><span class="graytext">
<label for="searchWord"><input type="text" id="searchWord" name="searchWord" value='' size="20" class="textEntry"/></label>
<label for="functions"><input type="submit"  value='<bean:message key="xd.infocenter.doc.search.go"/>' name="submit" class="buttons" id="functions" alt='<bean:message key="xd.infocenter.doc.search.go"/>'/></label>
<input type="hidden" name="tab" value="search"/></SPAN>
</TD>
</TR>
  
</TABLE>
  
  
</FORM>


</html:html>
