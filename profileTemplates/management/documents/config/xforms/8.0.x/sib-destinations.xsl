<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibresources="http://www.ibm.com/websphere/appserver/schemas/6.0/sibresources.xmi">

  <xsl:import href="copy.xsl"/>

  <!-- Remove persistRedeliveryCount -->
  <xsl:template match="sibresources:SIBQueue/@persistRedeliveryCount"/>
  <xsl:template match="sibresources:SIBTopicSpace/@persistRedeliveryCount"/>
  <xsl:template match="sibresources:SIBPort/@persistRedeliveryCount"/>
  <xsl:template match="sibresources:SIBWebService/@persistRedeliveryCount"/>

</xsl:stylesheet>
