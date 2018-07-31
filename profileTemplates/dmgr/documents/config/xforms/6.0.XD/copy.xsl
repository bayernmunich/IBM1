<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI">

<xsl:output indent="yes"/>

<!--
    Copy all Elements & Attributes to the Output Document.
    This document should be imported by all other tranform documents.
-->
<xsl:template name="copy" match="node() | @*">
    <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
