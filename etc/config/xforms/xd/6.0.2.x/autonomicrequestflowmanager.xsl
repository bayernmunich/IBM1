<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:autonomicrequestflowmanager="http://www.ibm.com/websphere/appserver/schemas/6.0/autonomicrequestflowmanager.xmi"
  xmlns:xmi="http://www.omg.org/XMI">

<xsl:import href="copy.xsl"/>

<!-- Remove maximumPercentServerMaxHeap attribute from autonomicrequestflowmanager.xml -->
<xsl:template match="autonomicrequestflowmanager:AutonomicRequestFlowManager/@maximumPercentServerMaxHeap"/>

<!-- Remove rejectionThreshold attribute from autonomicrequestflowmanager.xml -->
<xsl:template match="autonomicrequestflowmanager:AutonomicRequestFlowManager/@rejectionThreshold"/>

</xsl:stylesheet>
