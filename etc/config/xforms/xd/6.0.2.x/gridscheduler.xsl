<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gridscheduler="http://www.ibm.com/websphere/appserver/schemas/6.0/gridscheduler.xmi"
  xmlns:xmi="http://www.omg.org/XMI">

<xsl:import href="wxdcg/copy.xsl"/>

<!-- Remove endpointJobLogLocation attribute from gridscheduler.xml -->
<xsl:template match="gridscheduler:GridScheduler/@endpointJobLogLocation"/>

<!-- Remove databaseSchemaName attribute from gridscheduler.xml -->
<xsl:template match="gridscheduler:GridScheduler/@databaseSchemaName"/>

<!-- Remove deploymentTarget attribute from gridscheduler.xml -->
<xsl:template match="gridscheduler:GridScheduler/@deploymentTarget"/>

<!-- Remove enableUsageRecording attribute from gridscheduler.xml -->
<xsl:template match="gridscheduler:GridScheduler/@enableUsageRecording"/>

<!-- Remove enableUsageRecordingZOS attribute from gridscheduler.xml -->
<xsl:template match="gridscheduler:GridScheduler/@enableUsageRecordingZOS"/>

</xsl:stylesheet>
