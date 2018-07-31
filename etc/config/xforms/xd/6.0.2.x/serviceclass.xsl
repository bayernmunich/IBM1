<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:servicepolicy="http://www.ibm.com/websphere/appserver/schemas/6.0/servicepolicy.xmi"
  xmlns:xmi="http://www.omg.org/XMI">

<xsl:import href="copy.xsl"/>

<!-- remove CompletionTimeGoal -->
<xsl:template match="servicepolicy:ServiceClass">
  <xsl:if test="not(ServiceClassGoal/@xmi:type='servicepolicy:CompletionTimeGoal')">
    <xsl:call-template name="copy"/>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
