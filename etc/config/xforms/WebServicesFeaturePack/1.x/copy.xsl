<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmi="http://www.omg.org/XMI">

<xsl:output indent="yes"/>

<!-- Copy all elements and attributes to the output document. This document
     should be imported by the other XSL transform documents.
-->
<xsl:template name="copy" match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
