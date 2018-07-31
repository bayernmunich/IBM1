<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<tiles:useAttribute name="navid"      classname="java.lang.String"/>
<tiles:useAttribute name="subCmdList" classname="java.util.List"/>


<DIV NOWRAP id="<%=navid%>" class="main-task" style='margin-left:0.3em;'>
  <a href="javascript:showHideNavigation('<%=navid%>')" style="color:#000000;text-decoration:none">
  <IMG id="img_<%=navid%>" SRC="images/arrow_expanded.gif" BORDER="0" ALIGN="absmiddle" title="<bean:message key="collapse"/>" alt="<bean:message key="collapse"/>"/>
  <bean:message key="<%=navid%>"/>
  </a>
</DIV>
<DIV id="child_<%=navid%>" class="nav-child-container" style='margin-left:0.3em;display:none'>
	<UL CLASS="nav-child">
<%
    for (int i = 0; i < subCmdList.size(); i++) {
      String subCmd    = (String) subCmdList.get(i);
      String cmdInfo[] = subCmd.split(";");
%>
		<LI ID=<%=cmdInfo[0]%> CLASS="navigation-bullet"><A style="text-decoration:none" href="/jmc/<%=cmdInfo[1]%>" target="detail" ><bean:message key="<%=cmdInfo[0]%>"/></A></LI>
<%
   }
%>
	</UL>
</DIV>

<script>
if (isDom) {
<%
    for (int i = 0; i < subCmdList.size(); i++) {
      String subCmd    = (String) subCmdList.get(i);
      String cmdInfo[] = subCmd.split(";");
%>
	document.getElementById("<%=cmdInfo[0]%>").style.marginLeft = "2.5em";
<%
   }
%>
}
</script>