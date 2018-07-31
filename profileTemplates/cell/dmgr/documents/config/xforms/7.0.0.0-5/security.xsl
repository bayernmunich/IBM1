<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmi:version="2.0" 
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi">
  
  <xsl:import href="copy.xsl"/>

  <xsl:template match="security:Security/jaspiConfiguration"/>
<!-- remove the JASPI element in domain-security.xml -->
  <xsl:template match="security:AppSecurity/jaspiConfiguration"/>

 <!-- Remove WS-Security token propagation login module entries and related custom property --> 
 <xsl:variable name="isCopy" select="security:Security/properties[@name='com.ibm.ws.wssecurity.transform.copy']/@value"/>

 <xsl:template match="security:Security/systemLoginConfig/entries[@alias='RMI_INBOUND']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']">
    <xsl:choose>
     <xsl:when test="not($isCopy='true')"/>
      <xsl:otherwise>
        <xsl:call-template name="copy"/>
      </xsl:otherwise>
    </xsl:choose>
 </xsl:template> 
 
 <xsl:template match="security:Security/systemLoginConfig/entries[@alias='DEFAULT']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']">
    <xsl:choose>
     <xsl:when test="not($isCopy='true')"/>
      <xsl:otherwise>
        <xsl:call-template name="copy"/>
      </xsl:otherwise>
    </xsl:choose>
 </xsl:template> 
 
 <xsl:template match="security:Security/systemLoginConfig/entries[@alias='DESERIALIZE_ASYNCH_CONTEXT']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']">
    <xsl:choose>
     <xsl:when test="not($isCopy='true')"/>
      <xsl:otherwise>
        <xsl:call-template name="copy"/>
      </xsl:otherwise>
    </xsl:choose>
 </xsl:template> 
 
 <xsl:template match="security:Security/properties[@name='com.ibm.ws.wssecurity.transform.copy']"/>
 
<!-- Remove WS-Security SAML and Issued Token entries -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.issuedToken']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.issuedToken']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.caller']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.impl.auth.module.SAMLCallerLoginModule']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.caller']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.impl.auth.module.GenericIssuedTokenCallerLoginModule']"/>


</xsl:stylesheet>
