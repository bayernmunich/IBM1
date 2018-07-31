<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.intellmgmt.form.ConnectorDetailForm"%>
<%@ page import="com.ibm.ws.console.intellmgmt.form.IntellMgmtPluginForm"%>
<%@ page import="com.ibm.ws.console.intellmgmt.form.RemoteCellDetailForm"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.console.core.item.ActionSetItem"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<%
IntellMgmtPluginForm form = (IntellMgmtPluginForm) session.getAttribute("com.ibm.ws.console.intellmgmt.form.IntellMgmtPluginForm");
%>

<body class="content" class="table-row">

<table border="0" cellpadding="1" cellspacing="1" summary="List table" class="framing-table">
	<TR>
		<td valign="LEFT" class="table-text" colspan="5" nowrap> 

    <tiles:insert page="/com.ibm.ws.console.intellmgmt/remoteCellsButtonLayout.jsp">
        <tiles:put name="buttonCount" value="4"/>
        <tiles:put name="includeForm" value="no"/>
        <tiles:put name="definitionName" value="intellmgmt.remotecells.buttons.panel"/>
    </tiles:insert>

		</td>
	</TR>
	<TR>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="nn">
			<bean:message key="remotecell.col.select"/>
		</TH>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="nn">
			<bean:message key="remotecell.col.host"/>
		</TH>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="cid">
			<bean:message key="remotecell.col.cellid"/>
		</TH>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="wsn">
			<bean:message key="remotecell.col.enabled"/>
		</TH>
	    <th valign="top" class="column-head-name" scope="col" nowrap  id="wsn">
			<bean:message key="remotecell.col.connectors"/>
		</TH>
    </tr>
    <logic:iterate id="listCheckbox" name="com.ibm.ws.console.intellmgmt.form.IntellMgmtPluginForm" indexId="rowCount" property="remoteCells">
       <bean:define id="refId" name="listCheckbox" property="refId" type="java.lang.String"/>
<%
      if (listCheckbox instanceof RemoteCellDetailForm) {
         RemoteCellDetailForm rcdf = (RemoteCellDetailForm) listCheckbox;
		 System.out.println("rcdf="+rcdf);
         String hostPort = rcdf.getHost();
         if (!rcdf.getPort().equals("")) {
            hostPort += ":" + rcdf.getPort();
         }

         // get connector info
		 String connectorInfo = "";
         Iterator iter = rcdf.getConnectors().iterator();
		 while (iter.hasNext()) {
			ConnectorDetailForm cdf = (ConnectorDetailForm) iter.next();
			connectorInfo += cdf.getHost() + ":" + cdf.getPort() +"<BR>";
         }
%>
    <tr class="table-row">
			<input type="hidden" name="formAction" value="RemoteCellDetail"/>
			<html:hidden name="listCheckbox" property="refId"/>
            <td valign="middle"  width="1%" class="collection-table-text" headers="selectCell">
               <label class="collectionLabel" for="<%=refId%>" TITLE='<bean:message key="select.text"/>: <%=refId%>'>
                  <html:multibox name="listCheckbox" property="selectedObjectIds" value="<%=refId%>"  onclick="checkChecks(this.form)" onkeypress="checkChecks(this.form)" styleId="<%=refId%>"/>
               </label>
            </td>
            <TD VALIGN="top" class="collection-table-text" width="" headers="columnField"><%=hostPort%></TD>
            <TD VALIGN="top" class="collection-table-text" width="" headers="columnField"><%=rcdf.getCellID()%></TD>
            <TD VALIGN="top" class="collection-table-text" width="" headers="columnField"><%=rcdf.getEnabled()%></TD>
            <TD VALIGN="top" class="collection-table-text" width="" headers="columnField"><%=connectorInfo%></TD>
	</tr>
<%
      }
%>
	</logic:iterate>

</table>

</body>
       
