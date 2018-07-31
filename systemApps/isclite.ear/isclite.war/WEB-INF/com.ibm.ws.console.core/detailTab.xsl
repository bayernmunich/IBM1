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
    <xsl:apply-templates select="tab"/>
  </xsl:template>

  <xsl:template match="tab">
    <xsl:if test="$embedded='true'">
		<xsl:choose>
			<xsl:when test="@role">
		        <item value="{@label}" link="{@contentView}"  tooltip="{@role}" classtype="org.apache.struts.tiles.beans.SimpleMenuItem"/>
			</xsl:when>
			<xsl:otherwise>
		        <item value="{@label}" link="{@contentView}" classtype="org.apache.struts.tiles.beans.SimpleMenuItem"/>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:if>
    <xsl:if test="$embedded='false'">
		<xsl:choose>
			<xsl:when test="@role">
		        <item value="{@label}" link="{@contentUrl}" tooltip="{@role}" classtype="org.apache.struts.tiles.beans.SimpleMenuItem"/>
			</xsl:when>
			<xsl:otherwise>
		        <item value="{@label}" link="{@contentUrl}" classtype="org.apache.struts.tiles.beans.SimpleMenuItem"/>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:if>
    
  </xsl:template>
</xsl:stylesheet>
