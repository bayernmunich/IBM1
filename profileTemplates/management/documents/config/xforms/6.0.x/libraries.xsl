<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:libraries="http://www.ibm.com/websphere/appserver/schemas/5.0/libraries.xmi">
<xsl:import href="copy.xsl"/>

<!-- Remove the isolatedClassLoader attribute in the Library element -->
<xsl:template match="libraries:Library/@isolatedClassLoader"/>

</xsl:stylesheet>
