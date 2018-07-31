<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi"
  xmlns:com.ibm.etools.webservice.wssecurity="http://www.ibm.com/websphere/appserver/schemas/5.0.2/wssecurity.xmi"
  xmlns:AdminHelper="com.ibm.ws.management.AdminHelper"
  xmlns:PlatformHelper="com.ibm.ws.util.PlatformHelper"
  xmlns:LTPAKeyHelper="com.ibm.ws.security.ltpa.LTPAKeyHelper"
  xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI">
  
  <xsl:import href="copy.xsl"/>

  <!-- Remove appEnabled from security.xml
        LI: 2634
  -->
  <xsl:template match="security:Security/@appEnabled"/>

  <!-- Remove WebAuthAttrs from security.xml
        LI: 1898
  -->
  <xsl:template match="security:Security/webAuthAttrs"/>
  <xsl:template match="security:Security/additionalSecAttrs"/>

  <!-- Remove WIMUserRegistry from security.xml
        LI: 3734
  -->
  <xsl:template match="security:Security/userRegistries">
        <xsl:if test="not(@registryClassName='com.ibm.ws.wim.registry.WIMUserRegistry')">
                <xsl:call-template name="copy"/>
        </xsl:if>
  </xsl:template>

 <!-- Remove the following from ws-security.xml. These are new elements that are added in LIDB3919-23
       Defect: 310071
  -->
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/UseHardwareAcceleration"/>
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/@UseHardwareAcceleration"/>
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/HardwareConfigRef"/>
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/@HardwareConfigRef"/>
  
 <!-- Remove the following from ws-security.xml. These are new elements that are added in LIDB3919-23
       Defect: 310071
  -->

  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/defaultbindings/generator/tokenGenerator/callbackHandler/keyStore/@KeyStoreRef"/>
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/trustAnchors/keyStore/@KeyStoreRef"/>
  <xsl:template match="com.ibm.etools.webservice.wssecurity:WSSecurity/keyLocators/keyStore/@KeyStoreRef"/>

 <!-- Remove from security.xml the "entries" in "systemLoginConfig" when the "alias" is
        WSS_INBOUND or WSS_OUTBOUND
        These are added as part of LIDB3251.26
        Defect: 310071
  -->

   <xsl:template match="security:Security/systemLoginConfig/entries">
        <xsl:if test="not(@alias='WSS_INBOUND' or
                         @alias='WSS_OUTBOUND')">
                <xsl:call-template name="copy"/>
        </xsl:if>
   </xsl:template>

  <!-- Remove Simplified WAS Key/Certificate classes and attrs - LI# 3557  
     Begin
  -->
  <xsl:template match="security:Security/@dynamicallyUpdateSSLConfig"/>
  <xsl:template match="security:Security/@internalServerId"/>
  
  <xsl:template match="security:Security/userRegistries/@useRegistryServerId"/>
  <xsl:template match="security:Security/userRegistries/@useRegistryRealm"/>
  <xsl:template match="security:Security/userRegistries/searchFilter/@krbUserFilter"/>
  
  <!-- Defect 327548.1 -->
  <xsl:template match="security:Security/userRegistries/@primaryAdminId"/>
  
  <xsl:template match="security:Security/CSI/claims/layers/supportedQOP/@trustedId"/>
  <xsl:template match="security:Security/CSI/claims/layers/supportedQOP/@trustedPassword"/>
  <xsl:template match="security:Security/CSI/claims/layers/requiredQOP/@trustedId"/>
  <xsl:template match="security:Security/CSI/claims/layers/requiredQOP/@trustedPassword"/>
  
  <xsl:template match="security:Security/CSI/performs/layers/supportedQOP/@trustedId"/>
  <xsl:template match="security:Security/CSI/performs/layers/supportedQOP/@trustedPassword"/>
  <xsl:template match="security:Security/CSI/performs/layers/requiredQOP/@trustedId"/>
  <xsl:template match="security:Security/CSI/performs/layers/requiredQOP/@trustedPassword"/>

  <xsl:template match="security:Security/managementScopes"/>
  <xsl:template match="security:Security/trustManagers"/>
  <xsl:template match="security:Security/keyManagers"/>
  <xsl:template match="security:Security/dynamicSSLConfigSelections"/>
  <xsl:template match="security:Security/wsSchedules"/>
  <xsl:template match="security:Security/wsNotifications"/>
  <xsl:template match="security:Security/wsCertificateExpirationMonitor"/>
  <xsl:template match="security:Security/sslConfigGroups"/>
  
  <xsl:template match="security:Security/wsPasswords"/>
  <xsl:template match="security:Security/wsPasswordLocators"/>
  <xsl:template match="security:Security/wsPasswordEncryptions"/>
  
  <xsl:template match="security:Security/repertoire/@managementScope"/>
  
  <xsl:template match="security:Security/repertoire/setting/@keyManager"/>
  <xsl:template match="security:Security/repertoire/setting/@trustManager"/>
  <xsl:template match="security:Security/repertoire/setting/@enableCiphers"/>
  <xsl:template match="security:Security/repertoire/setting/@jsseProvider"/>
  <xsl:template match="security:Security/repertoire/setting/@clientAuthenticationSupported"/>
  <xsl:template match="security:Security/repertoire/setting/@sslProtocol"/>
  <xsl:template match="security:Security/repertoire/setting/@sslProtocol"/>

  <!-- Transform the SSLConfig WAS V7 format to the older format -->
  <xsl:template match="security:Security/repertoire">
    <xsl:choose>
      <xsl:when test="current()/setting/@keyStore or current()/setting/@trustStore">
        <!-- Process the repertoire --> 
        <xsl:element name="{name()}">
           <xsl:for-each select="@*[name() != 'managementScope']">
              <xsl:choose>
                 <!-- zOS specific transformation - CMVC 375249.1 
                     1. Transform the following SSL alias from JSSE type back to SSSL
                        <...alias="xxx/DefaultHTTPS" type="SSSL">
                        <...alias="xxx/DefaultIIOPSSL" type="SSSL">
                     2. Also make sure the SSL alias for these two properties are SSSL type 
                        <..name="was.com.ibm.websphere.security.zos.csiv2.inbound.transport.sslconfig" 
                                                value="x6nodeb/DefaultIIOPSSL"/>
                        <..name="was.com.ibm.websphere.security.zos.csiv2.outbound.transport.sslconfig" 
                                                value="x6nodeb/DefaultIIOPSSL"/>
                     3. When keyFileName is "safkeyring:///WASx6Keyring" convert to WASx6Keyring
                 -->     
                 <xsl:when test="name() = 'alias'"> 
                     <xsl:choose>
                        <xsl:when test=" substring-after(../@alias, '/')='DefaultHTTPS' or 
                               substring-after(../@alias, '/')='DefaultIIOPSSL' or 
                               /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.inbound.transport.sslconfig']/@value = . or
                               /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.outbound.transport.sslconfig']/@value = ."> 
                           
                           <xsl:attribute name="{name()}">
                              <xsl:value-of select="."/>
                           </xsl:attribute>
                           
                           <xsl:attribute name="type">SSSL</xsl:attribute>
                        </xsl:when>
                        
                        <xsl:otherwise>
                           <xsl:attribute name="{name()}">
                               <xsl:value-of select="."/>
                           </xsl:attribute>
                        </xsl:otherwise>
                     </xsl:choose>
                 </xsl:when>
                 
                 <xsl:when test="name() = 'type'">
                     <xsl:if test="substring-after(../@alias, '/')!='DefaultHTTPS' and 
                          substring-after(../@alias, '/')!='DefaultIIOPSSL' and 
                          /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.inbound.transport.sslconfig']/@value != . and
                          /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.outbound.transport.sslconfig']/@value != ."> 
                      
                        <xsl:attribute name="{name()}">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                     </xsl:if>
                 </xsl:when>
                 
                 <xsl:otherwise>
                    <xsl:attribute name="{name()}">
                       <xsl:value-of select="."/>
                    </xsl:attribute>
                 </xsl:otherwise>
                 
              </xsl:choose>   
              <!-- End Process the repertoire --> 
              <!-- Process the setting and others -->
           </xsl:for-each>
           <!-- Create setting -->
           <xsl:element name="setting">
             <xsl:attribute name="xmi:id">
               <xsl:value-of select="current()/setting/@xmi:id"/>
             </xsl:attribute>
                
             <xsl:if test="current()/setting/@keyStore">
                <xsl:attribute name="keyFileName">
                  <xsl:choose>
		    <xsl:when test="contains(../keyStores[@xmi:id = current()/setting/@keyStore]/@location,'CONFIG_ROOT')">
                        <xsl:value-of select="concat('${USER_INSTALL_ROOT}/config/cells', substring-after(../keyStores[@xmi:id = current()/setting/@keyStore]/@location, '/cells'))"/>
         	    </xsl:when>
                    
                    <!-- When keyFileName is "safkeyring:///WASx6Keyring" convert to WASx6Keyring -->     
		    <xsl:when test="contains(../keyStores[@xmi:id = current()/setting/@keyStore]/@location,'safkeyring:///') and
                          (substring-after(current()/@alias, '/')='DefaultHTTPS' or 
                           substring-after(current()/@alias, '/')='DefaultIIOPSSL' or 
                           /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.inbound.transport.sslconfig']/@value = current()/@alias or
                           /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.outbound.transport.sslconfig']/@value = current()/@alias) ">
                      <xsl:value-of select="substring-after(../keyStores[@xmi:id = current()/setting/@keyStore]/@location, 'safkeyring:///')"/>
                    </xsl:when>
                    
                    <xsl:otherwise>
                      <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@location"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                        
                <xsl:attribute name="keyFilePassword">
                  <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@password"/>
                </xsl:attribute>
                        
                <xsl:attribute name="keyFileFormat">
                  <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@type"/>
                </xsl:attribute>
             </xsl:if>                
                
             <xsl:if test="current()/setting/@trustStore"> 
               <xsl:attribute name="trustFileName">
                 <xsl:choose>
		   <xsl:when test="contains(../keyStores[@xmi:id = current()/setting/@trustStore]/@location,'CONFIG_ROOT')">
                     <xsl:value-of select="concat('${USER_INSTALL_ROOT}/config/cells', substring-after(../keyStores[@xmi:id = current()/setting/@trustStore]/@location, '/cells'))"/>
                   </xsl:when>
                   <!-- When keyFileName is "safkeyring:///WASx6Keyring" convert to WASx6Keyring -->     
                   
                   <xsl:when test="contains(../keyStores[@xmi:id = current()/setting/@trustStore]/@location,'safkeyring:///') and
                          (substring-after(current()/@alias, '/')='DefaultHTTPS' or 
                           substring-after(current()/@alias, '/')='DefaultIIOPSSL' or 
                           /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.inbound.transport.sslconfig']/@value = current()/@alias or
                           /security:Security/properties[@name='was.com.ibm.websphere.security.zos.csiv2.outbound.transport.sslconfig']/@value = current()/@alias) ">
                     <xsl:value-of select="substring-after(../keyStores[@xmi:id = current()/setting/@trustStore]/@location,'safkeyring:///')"/>
                   </xsl:when>
                   <xsl:otherwise>
                     <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@trustStore]/@location"/>
                   </xsl:otherwise>
                 </xsl:choose>
               </xsl:attribute>
                        
               <xsl:attribute name="trustFilePassword">
                 <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@trustStore]/@password"/>
               </xsl:attribute>
                        
               <xsl:attribute name="trustFileFormat">
                 <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@trustStore]/@type"/>
               </xsl:attribute>
             </xsl:if>                
                
             <xsl:if test="current()/setting/@clientAuthentication"> 
               <xsl:attribute name="clientAuthentication">
                 <xsl:value-of select="current()/setting/@clientAuthentication"/>
               </xsl:attribute>
             </xsl:if>                
                
             <xsl:if test="current()/setting/@securityLevel"> 
               <xsl:attribute name="securityLevel">
                 <xsl:value-of select="current()/setting/@securityLevel"/>
               </xsl:attribute>
             </xsl:if>                
                
             <xsl:if test="current()/setting/@enableCryptoHardwareSupport"> 
               <xsl:attribute name="enableCryptoHardwareSupport">
                 <xsl:value-of select="current()/setting/@enableCryptoHardwareSupport"/>
               </xsl:attribute>
             </xsl:if>                
                
             <!-- Create cryptoHardware if keyStore type is either PKCS11 or JCE4577KS for Z -->
             <xsl:if test="current()/setting/@keyStore"> 
               <xsl:if test="../keyStores[@xmi:id = current()/setting/@keyStore]/@type='PKCS11' or ../keyStores[@xmi:id = current()/setting/@keyStore]/@type='JCE4578KS'"> 
                 <xsl:element name="cryptoHardware">
                   <xsl:attribute name="xmi:id">CryptoHardwareToken_1</xsl:attribute>
                   
                   <xsl:attribute name="tokenType">
                     <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@type"/>
                   </xsl:attribute>
                   
                   <xsl:attribute name="libraryFile">
                     <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@location"/>
                   </xsl:attribute>
                   
                   <xsl:attribute name="password">
                     <xsl:value-of select="../keyStores[@xmi:id = current()/setting/@keyStore]/@password"/>
                   </xsl:attribute>
                 </xsl:element>
               </xsl:if>                
             </xsl:if>                
                
             <!-- Create properties element as needed -->
             <xsl:if test="current()/setting/@sslProtocol"> 
               <xsl:element name="properties">
                 <xsl:attribute name="xmi:id">Property_1</xsl:attribute>
                        
                 <xsl:attribute name="name">com.ibm.ssl.protocol</xsl:attribute>
                   <xsl:attribute name="value">
                     <xsl:value-of select="current()/setting/@sslProtocol"/>
                   </xsl:attribute>
               </xsl:element>
             </xsl:if>                
            
             <xsl:if test="current()/setting/@jsseProvider"> 
               <xsl:element name="properties">
                 <xsl:attribute name="xmi:id">Property_2</xsl:attribute>
                    
                 <xsl:attribute name="name">com.ibm.ssl.contextProvider</xsl:attribute>
                 <xsl:attribute name="value">
                   <xsl:value-of select="current()/setting/@jsseProvider"/>
                 </xsl:attribute>
               </xsl:element>
             </xsl:if> 
                           
             <xsl:if test="current()/setting/@clientKeyAlias"> 
               <xsl:element name="properties">
                  <xsl:attribute name="xmi:id">Property_3</xsl:attribute>
              
                  <xsl:attribute name="name">com.ibm.ssl.keyStoreClientAlias</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="current()/setting/@clientKeyAlias"/>
                  </xsl:attribute>
               </xsl:element>
             </xsl:if>                
            
             <xsl:if test="current()/setting/@serverKeyAlias"> 
               <xsl:element name="properties">
                 <xsl:attribute name="xmi:id">Property_4</xsl:attribute>
              
                 <xsl:attribute name="name">com.ibm.ssl.keyStoreServerAlias</xsl:attribute>
                 <xsl:attribute name="value">
                   <xsl:value-of select="current()/setting/@serverKeyAlias"/>
                 </xsl:attribute>
               </xsl:element>
             </xsl:if>                
           <!-- End create setting -->
           </xsl:element>
        
        <!-- End Process/Create the repertoire --> 
        </xsl:element>
      
      <!-- End when test="current()/setting/@keyStore or current()/setting/@trustStore" -->
      </xsl:when>
        
      <xsl:otherwise>
         <xsl:call-template name="copy"/>
      </xsl:otherwise>
    
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="security:Security/keyStores"/>

  <!-- Java code methods -->
  <xsl:variable name="getLTPAPublicKey"         select="LTPAKeyHelper:getLTPAPublicKey()"/>
  <xsl:variable name="getLTPAPrivateKey"        select="LTPAKeyHelper:getLTPAPrivateKey()"/>
  <xsl:variable name="getSharedKey"             select="LTPAKeyHelper:getSharedKey()"/>
  <xsl:variable name="getKeyStorePassword"      select="LTPAKeyHelper:getKeyStorePassword()"/>
     
  <!-- CMVC 377276 no LTPA keys for SWAM -->
  <xsl:variable name="isSWAM" select="security:Security/@activeAuthMechanism"/>
  
  <!-- It is LTPA authMechanism:
       1. If SPNEGO or SIP TAI exist, then remove it.
       2. If keySetGroup exist, then transform the LTPA keys to the old format.
  -->
  <xsl:template match="security:Security/authMechanisms[@xmi:type='security:LTPA']">
     <xsl:choose>
        <xsl:when test="@keySetGroup or ./trustAssociation/interceptors[@interceptorClassName = 'com.ibm.ws.security.spnego.TrustAssociationInterceptorImpl'] or ./trustAssociation/interceptors[@interceptorClassName = 'com.ibm.ws.sip.security.digest.DigestTAI']"> 
             <xsl:variable name="keySetGroupName" select="../keySetGroups[@xmi:id=current()/@keySetGroup]/@name"/>
             
             <xsl:element name="authMechanisms">
                <!-- Create authMechanism attributes, except the keySetGroup -->
                
                <xsl:for-each select="@*[name() != 'keySetGroup']">
                        <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                        </xsl:attribute>
                </xsl:for-each>
                
                <!-- if security is enabled and keySetGroup existed, then reset the LTPA password
                     to the key store password
                  -->
                <!-- CMVC 377276 no LTPA keys for SWAM -->
                <xsl:if test="//security:Security/@enabled='true' and 
                              not(substring-before($isSWAM, '_')='SWAMAuthentication') and
                              @keySetGroup">
                        <xsl:variable name="ltpaKeyHelper"   select="LTPAKeyHelper:new($keySetGroupName)"/>
                        <xsl:attribute name="password">
                                <xsl:value-of select="LTPAKeyHelper:getKeyStorePassword($ltpaKeyHelper)"/>
                        </xsl:attribute>
                </xsl:if>
                
                <!-- Create trustAssociation, interceptors, singleSignOn elements and its attrs -->
                <xsl:for-each select="*">
                        <!-- Create trustAssociation and singleSignOn elements -->
                        <xsl:element name="{name()}">
                                <!-- Create trustAssocation and signgleSignOn Attributes -->
                                <xsl:for-each select="./@*">
                                        <xsl:attribute name="{name()}">
                                                <xsl:value-of select="."/>
                                        </xsl:attribute>
                                </xsl:for-each>
                                
                                <!-- Create interceptors and its attrs, except the SPNEGO and SIP TAI - LI 3557 and D317347 --> 
                                <xsl:for-each select="./*[@interceptorClassName != 'com.ibm.ws.security.spnego.TrustAssociationInterceptorImpl' and @interceptorClassName != 'com.ibm.ws.sip.security.digest.DigestTAI']">
                                        <xsl:element name="{name()}">
                                                <!-- Create interceptors attrs --> 
                                                <xsl:for-each select="./@*">
                                                        <xsl:attribute name="{name()}">
                                                                <xsl:value-of select="."/>
                                                        </xsl:attribute>
                                                </xsl:for-each>
                                                <xsl:copy-of select="*"/>
                                        </xsl:element>   
                                </xsl:for-each>
                        </xsl:element>   
                </xsl:for-each>

                <!-- If security is enabled and keySetGroup existed, then create private, public and shared elements 
                     for LTPA from the KeySetGroup reference. Calling Java code to retrieve the public, private and 
                     shared keys. 
                -->
                <!-- CMVC 377276 no LTPA keys for SWAM -->
                <xsl:if test="//security:Security/@enabled='true' and 
                              not(substring-before($isSWAM, '_')='SWAMAuthentication') and
                              @keySetGroup">
                   <xsl:variable name="ltpaKeyHelper"   select="LTPAKeyHelper:new($keySetGroupName)"/>
                   <xsl:element name="private">
                        <xsl:attribute name="xmi:id">Key_1</xsl:attribute>
                        
                        <xsl:attribute name="byteArray">
                                <xsl:value-of select="LTPAKeyHelper:getLTPAPrivateKey($ltpaKeyHelper)"/>
                        </xsl:attribute>
                   </xsl:element>
                   
                   <xsl:element name="public">
                        <xsl:attribute name="xmi:id">Key_2</xsl:attribute>
                        
                        <xsl:attribute name="byteArray">
                                <xsl:value-of select="LTPAKeyHelper:getLTPAPublicKey($ltpaKeyHelper)"/>
                        </xsl:attribute>
                   </xsl:element>

                   <xsl:element name="shared">
                        <xsl:attribute name="xmi:id">Key_3</xsl:attribute>
                        
                        <xsl:attribute name="byteArray">
                                <xsl:value-of select="LTPAKeyHelper:getSharedKey($ltpaKeyHelper)"/>
                        </xsl:attribute>
                   </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:when>
        <xsl:otherwise>
                <xsl:call-template name="copy"/>
        </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  
  <!-- remove the keySetGroups and keySets -->
  <xsl:template match="security:Security/keySetGroups"/>
  <xsl:template match="security:Security/keySets"/>
  
  <!-- Remove Simplified WAS Key/Certificate - LI 3557 
     End
  -->
<!-- zOS specific transformation - CMVC 375249.1 
     Move the SAF properties from the top level to an userRegistry level.   
-->
<xsl:variable name="isSAFUnauthenticated" select="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']"/>
<xsl:variable name="isSAFAuthorization" select="/security:Security/properties[@name='com.ibm.security.SAF.authorization']"/>
<xsl:variable name="isSAFDelegation" select="/security:Security/properties[@name='com.ibm.security.SAF.delegation']"/>
<xsl:variable name="isSAFEJBRole" select="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']"/>
  
<!-- Get all userRegistries except WIM -->
<xsl:template match="security:Security/userRegistries[@xmi:type!='security:WIMUserRegistry']">
  <xsl:choose>
    <!-- This method does not work for a mix platforms env.
    <xsl:when test="$isZOS">  
    -->
    <xsl:when test="$isSAFUnauthenticated or $isSAFAuthorization or $isSAFDelegation or $isSAFEJBRole"> 
      <xsl:element name="{name()}">
        <!-- Write back all elementries of this entry-->   
        <xsl:for-each select="@*[name() !='primaryAdminId' and name()!='useRegistryServerId' and name()!='useRegistryRealm']">
          <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:for-each>
        <xsl:for-each select="*">
          <xsl:element name="{name()}">
            <xsl:for-each select="@*[name() !='krbUserFilter']">
              <xsl:attribute name="{name()}">
                <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:for-each>
          </xsl:element>   
        </xsl:for-each>
      
        <!-- Insert four SAF custom properties if they existed --> 
        <xsl:if test="$isSAFUnauthenticated">
          <xsl:element name="properties">
            <xsl:attribute name="xmi:id">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']/@xmi:id"/>
            </xsl:attribute>
            <xsl:attribute name="name">com.ibm.security.SAF.unauthenticated</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']/@value"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']/@required !=''">
                  <xsl:attribute name="required">
                     <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']/@required"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="required">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
        
        <xsl:if test="$isSAFAuthorization">
          <xsl:element name="properties">
            <xsl:attribute name="xmi:id">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.authorization']/@xmi:id"/>
            </xsl:attribute>
            <xsl:attribute name="name">com.ibm.security.SAF.authorization</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.authorization']/@value"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.authorization']/@required !=''">
                  <xsl:attribute name="required">
                     <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.authorization']/@required"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="required">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
       
        <xsl:if test="$isSAFDelegation">
          <xsl:element name="properties">
             <xsl:attribute name="xmi:id">
               <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.delegation']/@xmi:id"/>
             </xsl:attribute>
             <xsl:attribute name="name">com.ibm.security.SAF.delegation</xsl:attribute>
             <xsl:attribute name="value">
               <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.delegation']/@value"/>
             </xsl:attribute>
            <xsl:choose>
                <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.delegation']/@required !=''">
                  <xsl:attribute name="required">
                     <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.delegation']/@required"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="required">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
       
        <xsl:if test="$isSAFEJBRole">
          <xsl:element name="properties">
            <xsl:attribute name="xmi:id">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']/@xmi:id"/>
            </xsl:attribute>
            <xsl:attribute name="name">com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']/@value"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']/@required !=''">
                  <xsl:attribute name="required">
                     <xsl:value-of select="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']/@required"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="required">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:if>
      </xsl:element>   
    </xsl:when>
    
    <xsl:otherwise>
       <xsl:call-template name="copy"/>
    </xsl:otherwise>
  </xsl:choose>   
</xsl:template>

<xsl:template match="/security:Security/properties[@name='com.ibm.security.SAF.unauthenticated']"/>
<xsl:template match="/security:Security/properties[@name='com.ibm.security.SAF.authorization']"/>
<xsl:template match="/security:Security/properties[@name='com.ibm.security.SAF.delegation']"/>
<xsl:template match="/security:Security/properties[@name='com.ibm.security.SAF.EJBROLE.Audit.Messages.Suppress']"/>
<!-- End zOS specific transformation - CMVC 375249.1 -->

<!-- Begin check activeUserRegistry is WIMUserRegistry  -->
<!-- If it is WIM, get LDAP info to previous nodes -->

<xsl:variable name="isSecEnabled" select="security:Security/@enabled"/>
<xsl:variable name="isWIM" select="security:Security/@activeUserRegistry"/>

<xsl:template match="security:Security/userRegistries[@xmi:type='security:LDAPUserRegistry']/@serverId">
    <xsl:attribute name="serverId">
      <xsl:choose>
        <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and $isSecEnabled='true'">
          <xsl:value-of select="//security:Security/userRegistries[@xmi:type='security:WIMUserRegistry']/@serverId"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
</xsl:template>


<xsl:template match="security:Security/userRegistries[@xmi:type='security:LDAPUserRegistry']/@serverPassword">
    <xsl:attribute name="serverPassword">
     <xsl:choose>
       <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and $isSecEnabled='true'">
         <xsl:value-of select="//security:Security/userRegistries[@xmi:type='security:WIMUserRegistry']/@serverPassword"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="."/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
</xsl:template>

<xsl:template match="security:Security/userRegistries[@xmi:type='security:LDAPUserRegistry']/@realm">
    <xsl:attribute name="realm">
     <xsl:choose>
       <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and $isSecEnabled='true'">
      <xsl:value-of select="//security:Security/userRegistries[@xmi:type='security:WIMUserRegistry']/@realm"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="."/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
</xsl:template>

<xsl:template match="security:Security/userRegistries[@xmi:type='security:LDAPUserRegistry']/@ignoreCase">
    <xsl:attribute name="ignoreCase">
     <xsl:choose>
       <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and $isSecEnabled='true'">
   	<xsl:choose>
   	  <xsl:when test="//security:Security/userRegistries[@xmi:type='security:WIMUserRegistry']/@ignoreCase='true'">
   	     	<xsl:value-of select="true()"/>
   	  </xsl:when>
   	  <xsl:otherwise>
   		<xsl:value-of select="false()"/>
   	  </xsl:otherwise>
   	</xsl:choose>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="."/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
</xsl:template>

<xsl:template match="security:Security/@activeUserRegistry">
     <xsl:attribute name="activeUserRegistry">
      <xsl:choose>
       <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and $isSecEnabled='true'">
   	<xsl:value-of select="//security:Security/userRegistries[@xmi:type='security:LDAPUserRegistry']/@xmi:id"/>
       </xsl:when>
       <xsl:when test="substring-before($isWIM, '_')='WIMUserRegistry' and not($isSecEnabled='true')">
   	<xsl:value-of select="//security:Security/userRegistries[@xmi:type='security:LocalOSUserRegistry']/@xmi:id"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="."/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
</xsl:template>

<!-- End check activeUserRegistry is WIMUserRegistry  -->
  
  <!-- Start LI3486-45.1 -->
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
  <xsl:template match="security:Security/keyStores/@description"/>
  
  <xsl:template match="security:Security/dynamicReload"/>
  <xsl:template match="security:Security/@dynamicReload"/>

  <!-- Start LI3486-45.1 -->
  
  <!-- The following entries are removed for 6.1.x/pre-6.1 but kept for WSFEP -->  
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='DESERIALIZE_ASYNCH_CONTEXT']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.x509']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.x509']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.unt']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.unt']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.sct']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.sct']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.caller']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.pkcs7']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.pkcs7']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.pkiPath']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.pkiPath']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.ltpa']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.ltpa']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.ltpaProp']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.ltpaProp']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.inbound.propagation']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.inbound.deserialize']"/>  
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.auth.sts']"/>

  <!-- The following entries are removed for both 6.1.x/pre-6.1 and WSFEP -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wssecurity.KRB5BST']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.KRB5BST']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.KRB5BST']"/>

  <!-- Remove WS-Security SAML and Issued Token entries -->
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.saml']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.generate.issuedToken']"/>
  <xsl:template match="security:Security/systemLoginConfig/entries[@alias='wss.consume.issuedToken']"/>

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

</xsl:stylesheet>
