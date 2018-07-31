<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:topology.cell="http://www.ibm.com/websphere/appserver/schemas/5.0/topology.cell.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove the cellRegistered attribute in the Cell element -->
<xsl:template match="topology.cell:Cell/@cellRegistered"/>

<!-- Remove any adminAgentRegistration element in the Cell element -->
<xsl:template match="topology.cell:Cell/adminAgentRegistration"/>

<!-- F001031.2-29722:  Remove any monitoredDeploymentDirectory element in the Cell element -->
<xsl:template match="topology.cell:Cell/monitoredDirectoryDeployment"/>

<!-- Remove any sessionSecurity element in the Cell element -->
<xsl:template match="topology.cell:Cell/sessionSecurity"/>

<!-- Remove the enableBiDi & biDiTextDirection attributes in the Cell element -->
<xsl:template match="topology.cell:Cell/@enableBiDi"/>
<xsl:template match="topology.cell:Cell/@biDiTextDirection"/>

</xsl:stylesheet>
