<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xalan xsi" xmlns:plugin="http://www.ibm.com/xmlns/prod/websphere/200608/securitytokenservice/plugins" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="WebServicesFeaturePack/copy.xsl" />
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  
  <xsl:template match="/plugin:STSExtensionMap">
    <xsl:element name="plugin:STSExtensionMap">
      <xsl:for-each select="plugin:Extension">
        <xsl:element name="plugin:Extension">
          <xsl:choose>
            <xsl:when test="@LocalName='Security Context Token'">
              <xsl:attribute name="LocalName">Security Context Token</xsl:attribute>
              <xsl:attribute name="URI">http://schemas.xmlsoap.org/ws/2005/02/sc/sct</xsl:attribute>
              <xsl:attribute name="HandlerFactory">com.ibm.ws.wssecurity.trust.server.sts.ext.sct.SCTHandlerFactory</xsl:attribute>
              <xsl:for-each select="plugin:Configuration">
                <xsl:element name="plugin:Configuration">
                  
                  <xsl:variable name="distributedCache" select="count(plugin:Property[@Name='distributedCache'])"/>
                  <xsl:variable name="com.ibm.wsspi.wssecurity.trust.distributedCache" select="count(plugin:Property[@Name='com.ibm.wsspi.wssecurity.trust.distributedCache'])"/>
                  <xsl:variable name="tokenCacheFactory" select="count(plugin:Property[@Name='tokenCacheFactory'])"/>
                  <xsl:variable name="com.ibm.wsspi.wssecurity.trust.tokenCacheFactory" select="count(plugin:Property[@Name='com.ibm.wsspi.wssecurity.trust.tokenCacheFactory'])"/>
                  
                  <xsl:for-each select="plugin:Property">
                    <xsl:choose>
                      <xsl:when test="@Name='com.ibm.wsspi.wssecurity.trust.supportWSTrust10Draft'"/>
                      <xsl:when test="starts-with(@Name, 'com.ibm.wsspi.wssecurity.trust.')">
                        <xsl:element name="plugin:Property">
                          <xsl:attribute name="Name">
                            <xsl:value-of select="substring-after(@Name, 'com.ibm.wsspi.wssecurity.trust.')"/>
                          </xsl:attribute>
                          <xsl:attribute name="Value">
                            <xsl:value-of select="@Value"/>
                          </xsl:attribute>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="copy"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                  
                  <xsl:if test="$distributedCache=0 and $com.ibm.wsspi.wssecurity.trust.distributedCache=0">
                    <xsl:element name="plugin:Property">
                      <xsl:attribute name="Name">distributedCache</xsl:attribute>
                      <xsl:attribute name="Value">false</xsl:attribute>
                    </xsl:element>
                  </xsl:if>
                  
                  <xsl:if test="$tokenCacheFactory=0 and $com.ibm.wsspi.wssecurity.trust.tokenCacheFactory=0">
                    <xsl:element name="plugin:Property">
                      <xsl:attribute name="Name">tokenCacheFactory</xsl:attribute>
                      <xsl:attribute name="Value">com.ibm.ws.wssecurity.platform.websphere.trust.server.sts.ext.cache.STSTokenCacheFactoryImpl</xsl:attribute>
                    </xsl:element>
                  </xsl:if>
                  
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="copy"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
