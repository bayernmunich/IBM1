<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:topology.cell="http://www.ibm.com/websphere/appserver/schemas/5.0/topology.cell.xmi"
  xmlns:AdminHelper="com.ibm.ws.management.AdminHelper"
  xmlns:PlatformHelper="com.ibm.ws.util.PlatformHelper">

<xsl:import href="copy.xsl"/>

<xsl:variable name="platformHelper" select="AdminHelper:getPlatformHelper()"/>
<xsl:variable name="isZOS" select="PlatformHelper:isZOS($platformHelper)"/>

<!-- LI 3436
     Remove boostrapAddresses from foreignCells in the Cell element.  Also, if
     bootstrapAddress (note singular vs. plural) is not set, set bootstrapAddress
     to the first bootstrapAddresses element.
-->

<xsl:template match="topology.cell:Cell/foreignCells/bootstrapAddresses">
    <!-- If bootstrapAddress is not set, invoke the createBootstrapAddress
         template.  Pass in the position of this bootstrapAddresses element to
         the template, along with the host and port.  The template will create
         a bootstrapAddress element only if this slement is the first bootstrapAddresses
         element.  It will use the host and port passed to it.  Note that position()
         is not used to determine the position of this bootstrapAddresses element in
         the node.  This is because position includes all element types to determine 
         the position.  The "number" XSLT element is used because it returns the position
         relative to other elements of the same type.
    -->
    <xsl:if test="not(../bootstrapAddress)">
       <xsl:call-template name="createBootstrapAddress">
          <xsl:with-param name="addrNum"> <xsl:number /> </xsl:with-param>
          <xsl:with-param name="host">    <xsl:value-of select="./@host"/> </xsl:with-param>
          <xsl:with-param name="port">    <xsl:value-of select="./@port"/> </xsl:with-param>
       </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- This template creates a bootstrapAddress element if the position (addrNum) of the calling
     bootstrapAddresses element is the first in the list of bootstrapAddresses.
-->
<xsl:template name="createBootstrapAddress">
  <xsl:param name="addrNum"/>
  <xsl:param name="host"/>
  <xsl:param name="port"/>
  <xsl:if test="$addrNum=1">
     <xsl:text>&#xa;    </xsl:text>
     <xsl:element name="bootstrapAddress">
        <xsl:attribute name="xmi:id"> <xsl:text>EndPoint_0</xsl:text>   </xsl:attribute>
        <xsl:attribute name="host"><xsl:value-of select="$host"/></xsl:attribute>
        <xsl:attribute name="port"><xsl:value-of select="$port"/></xsl:attribute>
     </xsl:element>
  </xsl:if>
</xsl:template>

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
