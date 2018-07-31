<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
<tr> 
  <td class="table-text" nowrap>
    <label FOR="retryInterval" title="<bean:message key="intellmgmt.plugin.retryInterval.description"/>">    
    	<bean:message key="intellmgmt.plugin.retryInterval"/>
    </LABEL><BR>   
    <html:text property="retryInterval" styleId="retryInterval" styleClass="textEntry" disabled="false"/>
    <bean:message key="intellmgmt.seconds.unit"/>
  </td>
</tr>

<tr> 
  <td class="table-text" nowrap>
    <label FOR="maxRetries" title="<bean:message key="intellmgmt.plugin.maxRetries.description"/>">    
    	<bean:message key="intellmgmt.plugin.maxRetries"/>
    </LABEL><BR>   
    <html:text property="maxRetries" styleId="maxRetries" styleClass="textEntry" disabled="false"/>
  </td>
</tr>

</table>
       
