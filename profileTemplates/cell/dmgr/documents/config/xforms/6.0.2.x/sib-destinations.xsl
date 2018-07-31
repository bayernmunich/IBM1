<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibresources="http://www.ibm.com/websphere/appserver/schemas/6.0/sibresources.xmi">

  <xsl:import href="copy.xsl"/>

  <!-- Remove maintainStrictMessageOrder -->
  <xsl:template match="sibresources:SIBQueue/@maintainStrictMessageOrder"/>
  <xsl:template match="sibresources:SIBTopicSpace/@maintainStrictMessageOrder"/>
  <xsl:template match="sibresources:SIBPort/@maintainStrictMessageOrder"/>
  <xsl:template match="sibresources:SIBWebService/@maintainStrictMessageOrder"/>

  <!-- Remove destinations that are localized and mediated on MQ -->
  <xsl:template match="sibresources:SIBQueue[localizationPointRefs/@mqServer and destinationMediationRef/localizationPointRefs/@mqServer]"/>
  <xsl:template match="sibresources:SIBTopicSpace[localizationPointRefs/@mqServer and destinationMediationRef/localizationPointRefs/@mqServer]"/>
  <xsl:template match="sibresources:SIBPort[localizationPointRefs/@mqServer and destinationMediationRef/localizationPointRefs/@mqServer]"/>
  <xsl:template match="sibresources:SIBWebService[localizationPointRefs/@mqServer and destinationMediationRef/localizationPointRefs/@mqServer]"/>

  <!-- Remove destinations that are localized on MQ and not mediated -->
  <xsl:template match="sibresources:SIBQueue[localizationPointRefs/@mqServer and not(destinationMediationRef)]"/>
  <xsl:template match="sibresources:SIBTopicSpace[localizationPointRefs/@mqServer and not(destinationMediationRef)]"/>
  <xsl:template match="sibresources:SIBPort[localizationPointRefs/@mqServer and not(destinationMediationRef)]"/>
  <xsl:template match="sibresources:SIBWebService[localizationPointRefs/@mqServer and not(destinationMediationRef)]"/>

  <!-- Remove localization point refs that are on MQ -->
  <xsl:template match="sibresources:SIBQueue/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBTopicSpace/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBPort/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBWebService/localizationPointRefs[@mqServer]"/>

  <!-- Remove mediation localization point refs that are on MQ -->
  <xsl:template match="sibresources:SIBQueue/destinationMediationRef/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBTopicSpace/destinationMediationRef/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBPort/destinationMediationRef/localizationPointRefs[@mqServer]"/>
  <xsl:template match="sibresources:SIBWebService/destinationMediationRef/localizationPointRefs[@mqServer]"/>

  <!-- Remove execution point refs -->
  <xsl:template match="sibresources:SIBQueue/destinationMediationRef/executionPointRefs"/>

  <!-- Remove isExternal flag -->
  <xsl:template match="sibresources:SIBQueue/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBTopicSpace/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBPort/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBWebService/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBQueue/destinationMediationRef/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBTopicSpace/destinationMediationRef/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBPort/destinationMediationRef/localizationPointRefs/@isExternal"/>
  <xsl:template match="sibresources:SIBWebService/destinationMediationRef/localizationPointRefs/@isExternal"/>

  <!-- Remove exceptionDiscardReliability -->
  <xsl:template match="sibresources:SIBQueue/@exceptionDiscardReliability"/>
  <xsl:template match="sibresources:SIBTopicSpace/@exceptionDiscardReliability"/>
  <xsl:template match="sibresources:SIBPort/@exceptionDiscardReliability"/>
  <xsl:template match="sibresources:SIBWebService/@exceptionDiscardReliability"/>

  <!-- Remove v7 aliases attributes-->
  <xsl:template match="sibresources:SIBDestinationAlias/@allTargetQueuePointsSelected"/>
  <xsl:template match="sibresources:SIBDestinationAlias/@targetQueuePointIdentifiers"/>
  <xsl:template match="sibresources:SIBDestinationAlias/@allTargetMediationPointsSelected"/>
  <xsl:template match="sibresources:SIBDestinationAlias/@targetMediationPointIdentifiers"/>

  <!-- Remove v7 blockedRetryTimeout attribute -->
  <xsl:template match="sibresources:SIBQueue/@blockedRetryTimeout"/>
  <xsl:template match="sibresources:SIBTopicSpace/@blockedRetryTimeout"/>

</xsl:stylesheet>
