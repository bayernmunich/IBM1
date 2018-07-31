<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi"
  xmlns:com.ibm.etools.webservice.wssecurity="http://www.ibm.com/websphere/appserver/schemas/5.0.2/wssecurity.xmi"
  xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI">
  
  <xsl:import href="WebServicesFeaturePack/copy.xsl"/>
  <xsl:template match="security:Security/wsCertificateExpirationMonitor/@certImplClassToReplaceCert"/>
  <xsl:template match="security:Security/wsNotifications/@emailFormat"/>
  <xsl:template match="security:Security/wsNotifications/@sendSecure"/>
  <xsl:template match="security:Security/wsNotifications/@sslConfig"/>
  <xsl:template match="security:Security/keyStores/@description"/>
  <xsl:template match="security:Security/keyStores/@usage"/>
  
  <xsl:template match="security:Security/@allowBasicAuth"/>

  <xsl:variable name="isKRB5" select="security:Security/@activeAuthMechanism"/>
  
  <xsl:template match="security:Security/@activeAuthMechanism">
    <xsl:attribute name="activeAuthMechanism">
       <xsl:choose>
          <xsl:when test="substring-before($isKRB5, '_')='KRB5'">
             <xsl:value-of select="//security:Security/authMechanisms[@xmi:type='security:LTPA']/@xmi:id"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:value-of select="."/>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="security:Security/authMechanisms[@xmi:type='security:KRB5']"/>
  <xsl:template match="security:Security/authMechanisms[@xmi:type='security:RSAToken']"/>
  <xsl:template match="security:Security/@adminPreferredAuthMech"/>
  <xsl:template match="security:Security/adminPreferredAuthMech"/>
  <xsl:template match="security:Security/authMechanisms[@xmi:type='security:SPNEGO']"/>
  <xsl:template match="security:Security/authMechanisms/digestAuthentication"/>
  
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='KRB5']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries/loginModules[@moduleClassName='com.ibm.ws.security.auth.kerberos.Krb5LoginModuleWrapper']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries/loginModules[@moduleClassName='com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule']"/>

  <xsl:template match="security:Security/userRegistries/searchFilter/@krbUserFilter"/>
  <xsl:template match="security:Security/userRegistries/searchFilter/krbUserFilter"/>
  <xsl:template match="security:Security/userRegistries/@useRegistryRealm"/>
  
  <xsl:template match="security:Security/@caClients"/>
  <xsl:template match="security:Security/caClients"/>

  <xsl:template match="security:Security/@certficates"/>
  <xsl:template match="security:Security/certificates"/>

  <xsl:template match="security:Security/@wsSecurityScannerMonitor"/>
  <xsl:template match="security:Security/wsSecurityScannerMonitor"/>
  
  <xsl:template match="security:Security/CSI/claims/layers/@supportedAuthMechList"/>
  <xsl:template match="security:Security/CSI/performs/layers/@supportedAuthMechList"/>
  
  <xsl:template match="security:Security/outboundTrustedAuthenticationRealm"/>
  <xsl:template match="security:Security/@outboundTrustedAuthenticationRealm"/>
  
  <xsl:template match="security:Security/inboundTrustedAuthenticationRealm"/>
  <xsl:template match="security:Security/@inboundTrustedAuthenticationRealm"/>
  
  <xsl:template match="security:Security/dynamicReload"/>
  <xsl:template match="security:Security/@dynamicReload"/>
  
  <!-- The following entries are removed for both 6.1.x/pre-6.1 and WSFEP -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wssecurity.KRB5BST']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.KRB5BST']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.KRB5BST']"/>

  <!-- The following entries are removed for WSFEP -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.sct']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.wssapi.token.impl.DKTGenerateLoginModule']"/>

  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.sct']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.wssapi.token.impl.DKTConsumeLoginModule']"/>
  
  <!-- The following loginModule is removed for WSFEP. The containing "entries" element is removed for 6.1/pre-6.1. -->
  <xsl:template match="security:Security/systemLoginConfig/entries/loginModules[@moduleClassName='com.ibm.ws.wssecurity.impl.auth.module.KRBCallerLoginModule']"/>
</xsl:stylesheet>
