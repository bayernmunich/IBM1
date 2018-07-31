<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibresources="http://www.ibm.com/websphere/appserver/schemas/6.0/sibresources.xmi">

  <xsl:import href="copy.xsl"/>

  <!-- Remove messageStoreType and fileStore -->
  <xsl:template match="sibresources:SIBMessagingEngine/@messageStoreType"/>
  <xsl:template match="sibresources:SIBMessagingEngine/fileStore"/>

  <!-- Remove dataStore permanent/temporaryTables -->
  <xsl:template match="sibresources:SIBMessagingEngine/dataStore/@permanentTables"/>
  <xsl:template match="sibresources:SIBMessagingEngine/dataStore/@temporaryTables"/>

  <!-- Remove execution points -->
  <xsl:template match="sibresources:SIBMessagingEngine/executionPoints"/>
   <!-- Remove mqLink/senderChannel connameList -->
  <xsl:template match="sibresources:SIBMessagingEngine/mqLink/senderChannel/@connameList"/>

</xsl:stylesheet>
