<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>
<%@ page import="com.ibm.ws.console.intellmgmt.utils.TraceSpecTree"%>
<%@ page import="com.ibm.ws.xd.config.intellmgmt.utils.IntellMgmtConstants" %>


<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>

<tiles:useAttribute id="scope" name="scope" classname="java.lang.String"/>
<tiles:useAttribute id="currTraceText" name="currTraceText" classname="java.lang.String"/>

<%
String[] levelTypes = new String[IntellMgmtConstants.LEVEL_TYPES.length + 1];
for (int i = 0; i < IntellMgmtConstants.LEVEL_TYPES.length; i++) {
	levelTypes[i] = IntellMgmtConstants.LEVEL_TYPES[i];
}
levelTypes[levelTypes.length - 1] = IntellMgmtConstants.ALL_LEVEL;

pageContext.setAttribute("levelTypes", levelTypes);
%>

<style type="text/css">
  .contextMenu { position:absolute; display:none; width:150; top:0; left:0; }
  .treebranch { padding-left:32px; }
  .levelitem { cursor: pointer; cursor: hand; font-family: Verdana, sans-serif;  white-space:nowrap; background-color: #FFFFFF; }
  .levelitem:hover { background-color: #BDBDBD }
  .levelitemoff { color: #666666; font-family: Verdana, sans-serif; white-space:nowrap; background-color: #FFFFFF; }
</style>

<div id="<%=scope + "Context" %>" class="contextMenu">
	<table width="150" border="0" cellpadding="2" cellspacing="1" style="background-color:#708EB7;" role="presentation">
		<logic:iterate id="level" name="levelTypes" type="java.lang.String">
			<tr>
				<td role="button" id="<%=scope + "_" + level.toLowerCase() + "_level"%>" class="levelitem table-text" onclick="setTraceSpec('<%=level %>', '<%=currTraceText %>');" >
					<%=level %>
				</td>
			</tr>
		</logic:iterate>
	</table>
</div>

<div>&nbsp;
    <div><%-- Finish loading --%> 
        <script defer type="text/javascript">
            document.onclick = wheresTheClick;
        </script>
    </div>
</div>
