<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:servicepolicy="http://www.ibm.com/websphere/appserver/schemas/6.0/servicepolicy.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove Service Policy Violation Attributes -->
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@violationEnabled"/>
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@goalDeltaValue"/>
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@goalDeltaValueUnits"/>
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@goalDeltaPercent"/>
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@timePeriodValue"/>
<xsl:template match="servicepolicy:ServiceClass/ServiceClassGoal/@timePeriodValueUnits"/>

</xsl:stylesheet>
