<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi"
  xmlns:com.ibm.etools.webservice.wssecurity="http://www.ibm.com/websphere/appserver/schemas/5.0.2/wssecurity.xmi"
  xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI">
  
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
  
  <xsl:template name="copy" match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
