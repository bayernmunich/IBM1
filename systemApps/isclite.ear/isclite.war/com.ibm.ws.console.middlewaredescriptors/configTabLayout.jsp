<%-- IBM Confidential OCO Source Material --%>
<%-- 5724-J34, 5655-P28 (C) COPYRIGHT International Business Machines Corp. 2006 --%>
<%-- The source code for this program is not published or otherwise divested --%>
<%-- of its trade secrets, irrespective of what has been deposited with the --%>
<%-- U.S. Copyright Office. --%>

<%@ page import="java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%-- Layout component 
  Render a list of tiles in a vertical column
  @param : list List of names to insert 
  
--%>

<tiles:useAttribute id="list" name="list" classname="java.util.List" />

<%-- Iterate over names.
  We don't use <iterate> tag because it doesn't allow insert (in JSP1.1)
 --%>  
          
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="5" cellspacing="10" role="presentation">
    
        

<%
boolean itsother = false;
Iterator i=list.iterator();
while( i.hasNext() )
  {
  String name= (String)i.next();
  if ((name.indexOf("buttons.panel") > -1) 
	  || (name.indexOf("context.scope") > -1)) {
%>
   <TR><TD VALIGN="top" COLSPAN="2">
    <tiles:insert name="<%=name%>" flush="true" />
   </TD></TR>
<%
  } else if ((name.indexOf("general.properties") > -1) 
            || (name.indexOf("generic.properties") > -1) 
            || (name.indexOf("collection.table.extends") > -1)) {
%>
      <TR><TD VALIGN="top">
        <tiles:insert name="<%=name%>" flush="true" />
      </TD><TD VALIGN="top">

<%
  } else {
%>
      <tiles:insert name="<%=name%>" flush="true" />
      
    
<%
       itsother = true;
  }

  } // end loop
  if (itsother) {
%>
       </TD>        
<%
  }
%> 
</TR>   
</TABLE> 
