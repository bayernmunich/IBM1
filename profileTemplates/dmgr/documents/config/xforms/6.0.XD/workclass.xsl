<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:workClass="http:///workClass.ecore">

<xsl:import href="copy.xsl"/>

<!-- Remove WorkClass of Type JMSWORKCLASS -->
<xsl:template match="workClass:WorkClass[@type='JMSWORKCLASS']">
</xsl:template>

</xsl:stylesheet>
