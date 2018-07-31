<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:serverindex="http://www.ibm.com/websphere/appserver/schemas/5.0/serverindex.xmi">

<xsl:import href="copy.xsl"/>

<!-- F00743.27708 - remove ExtendedApplicationData elements -->
<xsl:template match="serverindex:ServerIndex/serverEntries/extendedApplicationDataElements"/>

</xsl:stylesheet>
