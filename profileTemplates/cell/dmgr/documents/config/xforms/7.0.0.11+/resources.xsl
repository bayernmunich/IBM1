<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:resources="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.xmi"
  xmlns:resources.env="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.env.xmi"
  xmlns:resources.j2c="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.j2c.xmi"
  xmlns:resources.jdbc="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jdbc.xmi"
  xmlns:resources.jms="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jms.xmi"
  xmlns:resources.mail="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.mail.xmi"
  xmlns:resources.url="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.url.xmi"
  xmlns:scheduler="http://www.ibm.com/websphere/appserver/schemas/5.0/scheduler.xmi"
  xmlns:workmanager="http://www.ibm.com/websphere/appserver/schemas/5.0/workmanager.xmi">

  <xsl:import href="copy.xsl"/>

<!-- F001031-18474 Remove new J2EEResourceProperties (added for JCA 1.6) -->
<xsl:template match="properties/@ignore"/>
<xsl:template match="properties/@confidential"/>
<xsl:template match="properties/@supportsDynamicUpdates"/>
<xsl:template match="resourceProperties/@ignore"/>
<xsl:template match="resourceProperties/@confidential"/>
<xsl:template match="resourceProperties/@supportsDynamicUpdates"/>

<!-- F1146-19602 Remove jConnect JDBC 4.0 driver -->
<xsl:template match="resources.jdbc:JDBCProvider[starts-with(@providerType, 'Sybase JDBC 4 Driver')]"/>
<xsl:template match="resources.j2c:J2CResourceAdapter/factories[@xmi:type='resources.jdbc:CMPConnectorFactory']">
  <xsl:variable name="idToMatch" select="@cmpDatasource"/>
  <xsl:choose>
    <!-- Remove this CMP connection factory when the cmpDatasource attribute matches a removed DataSource -->
    <xsl:when test="//resources.jdbc:JDBCProvider/factories[@xmi:id=$idToMatch and starts-with(@providerType, 'Sybase JDBC 4 Driver')]"/>
    <xsl:otherwise>
      <xsl:call-template name="copy"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

