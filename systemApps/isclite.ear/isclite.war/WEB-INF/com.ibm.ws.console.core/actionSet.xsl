<?xml version="1.0"?>

<!--THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
5724-i63, 5724-H88(C) COPYRIGHT International Business Machines Corp., 1997, 2004
All Rights Reserved * Licensed Materials - Property of IBM
US Government Users Restricted Rights - Use, duplication or disclosure
restricted by GSA ADP Schedule Contract with IBM Corp.-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xml:space="default">
  <xsl:param name="contextRoot" select="default"/>
  <xsl:param name="pluginId" select="default"/>
  <xsl:param name="embedded" select="false"/>

  <xsl:output method="xml" 
              indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="actionSet"/>
  </xsl:template>

  <xsl:template match="actionSet">
    <xsl:apply-templates select="action"/>
  </xsl:template>

  <xsl:template match="action">
		<xsl:choose>
			<xsl:when test="@role">
        		<item value="{@label}:{@actionUrl}" link="" icon="" tooltip="{@role}" classtype="com.ibm.ws.console.core.item.ActionSetItem"/>
			</xsl:when>
			<xsl:otherwise>
        		<item value="{@label}:{@actionUrl}" link="" icon="" classtype="com.ibm.ws.console.core.item.ActionSetItem"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>
</xsl:stylesheet>
