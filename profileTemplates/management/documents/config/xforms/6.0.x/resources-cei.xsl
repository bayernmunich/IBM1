<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:cei="http://www.ibm.com/websphere/appserver/schemas/5.1/cei.xmi">
  
  	<xsl:import href="copy.xsl"/>

	<!-- Remove the persitsEvents attribute in the event group profiles element. -->
	<xsl:template match="cei:EventInfrastructureProvider/factories/eventGroupProfiles/@persistEvents"/>

</xsl:stylesheet>