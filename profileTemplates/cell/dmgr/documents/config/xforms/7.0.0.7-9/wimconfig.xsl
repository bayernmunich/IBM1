<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmi:version="2.0" 
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:config="http://www.ibm.com/websphere/wim/config"
  xmlns:sdo="commonj.sdo">

  <xsl:import href="copy.xsl"/>
  
  <xsl:template match="sdo:datagraph/config:configurationProvider/config:dynamicModel/@useGlobalSchema"/>
  <xsl:template match="sdo:datagraph/config:configurationProvider/config:staticModel/@useGlobalSchema"/>

</xsl:stylesheet>
