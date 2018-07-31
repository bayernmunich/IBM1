<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xalan xsi" xmlns:target="http://www.ibm.com/xmlns/prod/websphere/200608/securitytokenservice/targets" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="WebServicesFeaturePack/copy.xsl"/>
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  
  <xsl:template match="/target:STSTargetMap">
    <xsl:element name="target:STSTargetMap">
      
      <xsl:choose>
        <xsl:when test="count(@DefaultTokenTypeURI)=0 or @DefaultTokenTypeURI='http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/sct'">
          <xsl:attribute name="DefaultTokenTypeURI">http://schemas.xmlsoap.org/ws/2005/02/sc/sct</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="DefaultTokenTypeURI">
            <xsl:value-of select="@DefaultTokenTypeURI"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:for-each select="@*">
        <xsl:choose>
          <xsl:when test="name()='DefaultTokenTypeURI'"/>
          <xsl:otherwise>
            <xsl:call-template name="copy"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      
      <xsl:for-each select="target:Target">
        <xsl:call-template name="copy"/>
      </xsl:for-each>
      
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
