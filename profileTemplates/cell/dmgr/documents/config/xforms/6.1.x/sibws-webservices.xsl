<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibws="http://www.ibm.com/websphere/appserver/schemas/6.0/sibws.xmi">

  <xsl:import href="copy.xsl"/> 

  <!-- Remove JAXWSHandler and JAXWSHandlerList objects -->  
 <xsl:template match="sibws:JAXWSHandler" />
 <xsl:template match="sibws:JAXWSHandlerList" />

</xsl:stylesheet>
