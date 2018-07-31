<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:coregroup="http://www.ibm.com/websphere/appserver/schemas/6.0/coregroup.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove the transportMemorySize attribute from the coregroup.xml -->
<xsl:template match="coregroup:CoreGroup/@transportMemorySize"/>

<!-- Remove the liveness element from the coregroup.xml -->
<xsl:template match="coregroup:CoreGroup/liveness"/>

</xsl:stylesheet>
