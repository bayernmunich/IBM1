<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:healthpolicy="http://www.ibm.com/websphere/appserver/schemas/6.0/healthpolicy.xmi"
  xmlns:xmi="http://www.omg.org/XMI">

<xsl:import href="copy.xsl"/>

<!-- Remove stepNum attribute from healthclass.xml -->
<xsl:template match="healthpolicy:HealthClass/healthActions/@stepNum"/>

<!-- Remove healthActions element if actionType is 6.1 -->
<xsl:template match="healthpolicy:HealthClass/healthActions">
  <xsl:if test="not(@actionType='CUSTOM' or
                    @actionType='SETMAINTENANCEMODE' or
                    @actionType='UNSETMAINTENANCEMODE' or
                    @actionType='SETMAINTENANCEMODE_BREAK' or
                    @actionType='SETMAINTENANCEMODE_STOP')">
          <xsl:call-template name="copy" />
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
