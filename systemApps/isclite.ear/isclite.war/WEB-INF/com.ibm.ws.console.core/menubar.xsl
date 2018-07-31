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
    <xsl:apply-templates select="menuBarItems"/>
  </xsl:template>

  <xsl:template match="menuBarItems">
    <xsl:apply-templates select="menuBarItemDefinition"/>
  </xsl:template>

  <xsl:template match="menuBarItemDefinition">
    <xsl:if test="@url">
        <xsl:if test="$embedded='false'">
            	<xsl:choose>
			    <xsl:when test="@role">
		            <item value="{@label}:{@role}" link="//{$contextRoot}{@url}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
	            </xsl:when>
			    <xsl:otherwise>
		            <item value="{@label}" link="//{$contextRoot}{@url}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
        </xsl:if>
        <xsl:if test="$embedded='true'">
            	<xsl:choose>
			    <xsl:when test="@role">
		            <item value="{@label}:{@role}" link="/{$pluginId}{@url}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
	            </xsl:when>
			    <xsl:otherwise>
		            <item value="{@label}" link="/{$pluginId}{@url}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
        </xsl:if>
    </xsl:if>
    <xsl:if test="@view">
            <xsl:choose>
			<xsl:when test="$role">
				<item value="{@label}:{@role}" link="/menuBarCmd.do?forwardName={@view}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
            </xsl:when>
		    <xsl:otherwise>
				<item value="{@label}" link="/menuBarCmd.do?forwardName={@view}" classtype="com.ibm.ws.console.core.item.MenuBarItem"/>
            </xsl:otherwise>
           	</xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
