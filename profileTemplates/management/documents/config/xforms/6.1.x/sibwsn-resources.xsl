<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:wsnresources="http://www.ibm.com/websphere/appserver/schemas/6.0/wsnresources.xmi">

  <xsl:import href="copy.xsl"/> 

  <!-- Remove the following attributes from WSNService objects -->  
  <xsl:template match="wsnresources:WSNService/@type"/>
  <xsl:template match="wsnresources:WSNService/@jaxwsHandlerList"/>
  <xsl:template match="wsnresources:WSNService/@queryWSDL"/>

  <!-- Remove the following attributes from WSNServicePoint objects -->  
  <xsl:template match="wsnresources:WSNService/servicePoint/@jaxwsHandlerListNB"/>
  <xsl:template match="wsnresources:WSNService/servicePoint/@jaxwsHandlerListPRM"/>
  <xsl:template match="wsnresources:WSNService/servicePoint/@jaxwsHandlerListSM"/>
  <xsl:template match="wsnresources:WSNService/servicePoint/@servicePointApplicationReference"/>
  <xsl:template match="wsnresources:WSNService/servicePoint/@soapVersion"/> 
  <xsl:template match="wsnresources:WSNService/servicePoint/@installedWebSphereTargetID"/> 
  <xsl:template match="wsnresources:WSNService/servicePoint/@transportURLRoot"/>

  <!-- Remove the following attributes from WSNInstanceDocument objects -->  
  <xsl:template match="wsnresources:WSNService/topicNamespace/instanceDocument/@doc"/>

</xsl:stylesheet>
