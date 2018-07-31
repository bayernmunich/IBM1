<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:sibservice="http://www.ibm.com/websphere/appserver/schemas/6.0/sibservice.xmi">

  <xsl:import href="copy.xsl"/>

  <!-- Remove startCRA attribute -->
  <xsl:template match="sibservice:SIBService/@startCRA"/>

</xsl:stylesheet>
