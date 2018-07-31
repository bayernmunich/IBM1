<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:coregroupbridgeservice="http://www.ibm.com/websphere/appserver/schemas/6.0/coregroupbridgeservice.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove the elements related to Tunnel Templates configuration -->
<xsl:template match="coregroupbridgeservice:CoreGroupBridgeSettings/tunnelAccessPointGroups"/>
<xsl:template match="coregroupbridgeservice:CoreGroupBridgeSettings/tunnelPeerAccessPoints"/>
<xsl:template match="coregroupbridgeservice:CoreGroupBridgeSettings/tunnelTemplates"/>

<!-- Remove the attribute cellAccessPermission from PeerAccessPoints -->
<xsl:template match="coregroupbridgeservice:CoreGroupBridgeSettings/peerAccessPoints/@cellAccessPermission"/>

<!-- Remove the attribute memberCommunicationKey from AccessPointGroups -->
<xsl:template match="coregroupbridgeservice:CoreGroupBridgeSettings/accessPointGroups/@memberCommunicationKey"/>

</xsl:stylesheet>
