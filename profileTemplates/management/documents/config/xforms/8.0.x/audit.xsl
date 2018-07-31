<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmi:version="2.0" 
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:security="http://www.ibm.com/websphere/appserver/schemas/5.0/security.xmi">

  <xsl:import href="copy.xsl"/>

  <xsl:template match="security:Audit/auditSpecifications/event">
	<xsl:if test="not(contains(., 'ADMIN_REPOSITORY_SAVE'))">  
		<xsl:call-template name="copy"/>
        </xsl:if>
  </xsl:template>
</xsl:stylesheet>
