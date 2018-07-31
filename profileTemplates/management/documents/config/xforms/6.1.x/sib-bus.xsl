<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibresources="http://www.ibm.com/websphere/appserver/schemas/6.0/sibresources.xmi">

  <xsl:import href="copy.xsl"/>

  <!-- Remove any Bus Member messaging engine policy assistance attributes -->
  <xsl:template match="sibresources:SIBus/busMembers/@policyName"/>
  <xsl:template match="sibresources:SIBus/busMembers/@assistanceEnabled"/>

  <!-- Remove securityGroupCacheTimeout attribute -->
  <xsl:template match="sibresources:SIBus/@securityGroupCacheTimeout"/>

  <!-- Remove engineName from any Bus Member targets -->
  <xsl:template match="sibresources:SIBus/busMembers/target/@engineName"/>

  <!-- Remove exceptionDestination attribute from SIBLinkRef -->
  <xsl:template match="sibresources:SIBus/foreignBus/virtualLink/linkRef/@exceptionDestination"/>

  <!-- Remove exceptionDiscardReliability attribute from SIBLinkRef -->
  <xsl:template match="sibresources:SIBus/foreignBus/virtualLink/linkRef/@exceptionDiscardReliability"/>

  <!-- Remove preferLocalQueuePoints attribute from SIBLinkRef -->
  <xsl:template match="sibresources:SIBus/foreignBus/virtualLink/linkRef/@preferLocalQueuePoints"/>

  <!-- Remove useServerIdForMediations, bootstrapMemberPolicy, nominatedBootstrapMembers -->
  <xsl:template match="sibresources:SIBus/@useServerIdForMediations"/>
  <xsl:template match="sibresources:SIBus/@bootstrapMemberPolicy"/>
  <xsl:template match="sibresources:SIBus/nominatedBootstrapMembers"/>

</xsl:stylesheet>
