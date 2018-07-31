<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi"
  xmlns:com.ibm.etools.webservice.wssecurity="http://www.ibm.com/websphere/appserver/schemas/5.0.2/wssecurity.xmi"
  xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI">
  
  <xsl:import href="copy.xsl"/>
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
  
  <xsl:template match="security:Security/applicationLoginConfig/entries[@alias='WSKRB5Login']"/>
  
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='KRB5']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries/loginModules[@moduleClassName='com.ibm.ws.security.auth.kerberos.Krb5LoginModuleWrapper']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries/loginModules[@moduleClassName='com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule']"/>

  <xsl:template match="security:Security/userRegistries/@useRegistryRealm"/>
  <xsl:template match="security:Security/userRegistries/searchFilter/@krbUserFilter"/>
  
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

  <!-- Remove WS-Security SAML and Issued Token entries -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.issuedToken']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.issuedToken']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.caller']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.impl.auth.module.SAMLCallerLoginModule']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.caller']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.impl.auth.module.GenericIssuedTokenCallerLoginModule']"/>

  <!-- Transform new property com.ibm.security.SAF.profilePrefix to old properties 
       security.zOS.domainName and security.zOS.domainType --> 
  <xsl:template match="security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']">
      <xsl:choose>
      <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']/@value !=''">
        <xsl:element name="properties">
          <xsl:attribute name="xmi:id">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']/@xmi:id"/>
          </xsl:attribute>
          <xsl:attribute name="name">security.zOS.domainName</xsl:attribute>
          <xsl:attribute name="value">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']/@value"/>
          </xsl:attribute>
          <xsl:choose>
              <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']/@required !=''">
                  <xsl:attribute name="required">
                      <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.profilePrefix']/@required"/>
                  </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:attribute name="required">false</xsl:attribute>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="properties">
          <xsl:attribute name="xmi:id">Property_1010101010101</xsl:attribute>              
          <!-- <xsl:value-of select="concat('Property_',generate-id(.))"> -->
          <xsl:attribute name="name">security.zOS.domainType</xsl:attribute>
          <xsl:attribute name="value">cellQualified</xsl:attribute>
          <xsl:attribute name="required">false</xsl:attribute>
        </xsl:element>
      </xsl:when>
    
    <xsl:otherwise>
       <xsl:call-template name="copy"/>
    </xsl:otherwise>
  </xsl:choose> 
  </xsl:template>
  <xsl:template match="security:Security/jaspiConfiguration"/>
  
  <!-- Remove WS-Security token propagation login module entries and related custom property -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='RMI_INBOUND']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='DEFAULT']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='DESERIALIZE_ASYNCH_CONTEXT']/loginModules[@moduleClassName='com.ibm.ws.wssecurity.platform.websphere.wssapi.token.impl.wssTokenPropagationInboundLoginModule']"/>
  
  <xsl:template match="security:Security/properties[@name='com.ibm.ws.wssecurity.transform.copy']"/>
  
  <!-- Transform clientKeyAlias and serverKeyAlias to lowercases for 
       keyStore type JCERACFKS or JCECCARACFKS -->
  <xsl:template match="security:Security/repertoire">
     <xsl:choose>
        <xsl:when test="contains(../keyStores[@xmi:id = current()/setting/@keyStore]/@type,'JCERACFKS') or
                        contains(../keyStores[@xmi:id = current()/setting/@keyStore]/@type,'JCECCARACFKS')">
           <!-- process the repertoire -->
           <xsl:element name="{name()}">
              <xsl:for-each select="@*">
                 <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                 </xsl:attribute>
              </xsl:for-each>
              <!-- process the setting -->
              <xsl:element name="setting">
                 <xsl:attribute name="xmi:id">
                 <xsl:attribute name="required">false</xsl:attribute>
                     <xsl:value-of select="current()/setting/@xmi:id"/>
                 </xsl:attribute>
                 <xsl:for-each select="current()/setting/@*">
                    <xsl:choose> 
                       <xsl:when test="name() = 'clientKeyAlias'"> 
                          <xsl:variable name="cKeyAlias" select="."/>
                          <xsl:variable name="cKeyAliasLowerCases" select="translate($cKeyAlias, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                          <xsl:attribute name="{name()}">
                             <xsl:value-of select="$cKeyAliasLowerCases"/>
                          </xsl:attribute>
                       </xsl:when>
                       <xsl:when test="name() = 'serverKeyAlias'"> 
                          <xsl:variable name="sKeyAlias" select="."/>
                          <xsl:variable name="sKeyAliasLowerCases" select="translate($sKeyAlias, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                          <xsl:attribute name="{name()}">
                             <xsl:value-of select="$sKeyAliasLowerCases"/>
                          </xsl:attribute>
                       </xsl:when>
                       <xsl:otherwise>
                          <xsl:attribute name="{name()}">
                             <xsl:value-of select="."/>
                          </xsl:attribute>
                       </xsl:otherwise>
                       </xsl:choose>               
                 </xsl:for-each>
                <!-- process custom properties -->
                <xsl:variable name="isCustomProp" select="current()/setting/properties"/>
                <xsl:for-each select="current()/setting/properties">
                   <xsl:if test="$isCustomProp">
                      <xsl:element name="{name()}">
                         <xsl:for-each select="@*">
                            <xsl:attribute name="{name()}">
                               <xsl:value-of select="."/>
                            </xsl:attribute>
                         </xsl:for-each>
                      </xsl:element>   
                   </xsl:if>
                </xsl:for-each>
              </xsl:element> <!-- setting -->
           </xsl:element>  <!-- repertoise --> 
        </xsl:when>
        <xsl:otherwise>
           <xsl:call-template name="copy"/>
        </xsl:otherwise> 
     </xsl:choose>
  </xsl:template>
      
</xsl:stylesheet>
