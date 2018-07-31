<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:namebindings="http://www.ibm.com/websphere/appserver/schemas/5.0/namebindings.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove the initialContextFactory attribute in the IndirectLookupNameSpaceBinding element
     and all otherCtxProperties elements within IndirectLookupNameSpaceBinding elements.
-->
<xsl:template match="namebindings:IndirectLookupNameSpaceBinding/@initialContextFactory"/>
<xsl:template match="namebindings:IndirectLookupNameSpaceBinding/otherCtxProperties"/>

</xsl:stylesheet>
