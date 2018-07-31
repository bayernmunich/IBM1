<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:pmirm="http://www.ibm.com/websphere/appserver/schemas/5.0/pmirm.xmi">

<xsl:import href="copy.xsl"/>


<!-- Remove dynamicEnable attribute from PMIRequestMatrics
-->
<xsl:template match="pmirm:PMIRequestMetrics/@dynamicEnable"/>


<!-- Remove all <instrumentedComponents> from pmirm.xml
     Defect: 220616
-->
<xsl:template match="pmirm:PMIRequestMetrics/instrumentedComponents"/>

</xsl:stylesheet>
