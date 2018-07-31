<%@ page import="java.util.*"%>
<%@ page import="com.ibm.ws.console.proxy.proxysettings.ProxySettingsDetailForm"%>
<%@ page import="com.ibm.ws.console.core.ConfigFileHelper"%>

<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tiles.tld" prefix="tiles" %>


<tiles:useAttribute id="readOnly" name="readOnly" classname="java.lang.String"/>

<%    
    String showNoneText = "Proxy.none.text";
    boolean val = false;
	if (readOnly != null && readOnly.equals("true"))
		val = true;
		
	Vector valueVector = (Vector) session.getAttribute("outboundSSLAliasVal");
	Vector descVector = (Vector) session.getAttribute("outboundSSLAliasDesc");	
%>

<table width="100%" border="0" cellspacing="0" cellpadding="2" role="presentation">
<% 
ProxySettingsDetailForm form = (ProxySettingsDetailForm) session.getAttribute("com.ibm.ws.console.proxy.proxysettings.ProxySettingsDetailForm");

java.util.Properties props = null;
String contextId = (String)request.getAttribute("contextId");
props = ConfigFileHelper.getNodeMetadataProperties((String)contextId, request); 
Integer version = Integer.valueOf(props.getProperty("com.ibm.websphere.baseProductMajorVersion"));

/*
 * If we are at cluster scope or in a non-clustered proxy, display the fields
 */
if (form.getContextId().contains(":dynamicclusters") || form.getClusterName().length() <= 0 ) {
%>
<tr> 
  <td class="table-text" nowrap>
    <label FOR="outboundRequestTimeout"
    	title="<bean:message key="ProxySettings.outboundRequestTimeout.description"/>">    
    	<bean:message key="ProxySettings.outboundRequestTimeout.displayName"/>
    </LABEL><BR>   
    <html:text property="outboundRequestTimeout" styleId="outboundRequestTimeout" 
    	styleClass="textEntry" disabled="<%=val%>"/>
    <bean:message 
    	key="ProxySettings.seconds.unit"/>
  </td>
</tr>

<%
	//Filter this attribute on pre v7 nodes
	if (version.intValue() >= 7){
%>

<tr> 
  <td class="table-text" nowrap>
    <label FOR="outboundRequestWriteTimeout"
    	title="<bean:message key="ProxySettings.outboundRequestWriteTimeout.description"/>">    
    	<bean:message key="ProxySettings.outboundRequestWriteTimeout.displayName"/>
    </LABEL><BR>   
    <html:text property="outboundRequestWriteTimeout" styleId="outboundRequestWriteTimeout" 
    	styleClass="textEntry" disabled="<%=val%>"/>
    <bean:message 
    	key="ProxySettings.seconds.unit"/>
  </td>
</tr>

<% } %>

<tr> 
  <td class="table-text" nowrap>
    <label FOR="outboundConnectTimeout"
    	title="<bean:message key="ProxySettings.outboundConnectTimeout.description"/>">    
    	<bean:message key="ProxySettings.outboundConnectTimeout.displayName"/>
    </LABEL><BR>   
    <html:text property="outboundConnectTimeout" styleId="outboundConnectTimeout" 
    	styleClass="textEntry" disabled="<%=val%>"/>
    <bean:message 
    	key="ProxySettings.milliseconds.unit"/>
  </td>
</tr>


<tr> 
  <td class="table-text"> 
    <label FOR="connectionPoolEnable"
    	title="<bean:message key="ProxySettings.connectionPoolEnable.description"/>">        
    <html:checkbox property="connectionPoolEnable" styleId="connectionPoolEnable" 
    value="on" disabled="<%=val%>" 
    	onclick="enableDisable('connectionPoolEnable:maxConnectionsPerServer')" 
    	onkeypress="enableDisable('connectionPoolEnable:maxConnectionsPerServer')"/>
    <bean:message key="ProxySettings.connectionPoolEnable.displayName"/>
    </LABEL>  
  </td>
</tr>
<tr> 
  <td class="complex-property" nowrap>
    <label FOR="maxConnectionsPerServer"
    	title="<bean:message key="ProxySettings.maxConnectionsPerServer.description"/>">        
    	<bean:message 
    		key="ProxySettings.maxConnectionsPerServer.displayName"/></LABEL><BR>   
    <html:text property="maxConnectionsPerServer" styleId="maxConnectionsPerServer" 
    	styleClass="textEntry" disabled="<%=val%>"/>
  </td>
</tr>

<% 
}

/*
 * If we are not in the cluster scope, display the outbound TCP address field.
 * Filter this node on pre v7 nodes
 */
if (!form.getContextId().contains(":dynamicclusters") && (version.intValue() >= 7)) {
%>
<tr> 
  <td class="table-text" nowrap>
    <LABEL FOR="localOutboundTCPAddress"
    	title="<bean:message key="ProxySettings.localOutboundTCPAddress.description"/>">            	
    <bean:message key="ProxySettings.localOutboundTCPAddress.displayName"/>
    <BR/>   
    <html:text property="localOutboundTCPAddress" styleId="localOutboundTCPAddress" size="40"
    	styleClass="textEntry" disabled="<%=val%>"/>
    <script>bidiComplexField("localOutboundTCPAddress", "URL");</script>
    </LABEL>    	
  </td>
</tr>
<%
}
%>

</table>
       
      <SCRIPT>
        enableDisable('connectionPoolEnable:maxConnectionsPerServer');
      </SCRIPT>
