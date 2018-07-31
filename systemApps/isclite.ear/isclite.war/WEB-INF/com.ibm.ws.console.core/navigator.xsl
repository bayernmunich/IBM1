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
    <xsl:apply-templates select="tasks"/>
  </xsl:template>

  <xsl:template match="tasks">
    <xsl:apply-templates select="categoryDefinition"/>
    <xsl:apply-templates select="task"/>
  </xsl:template>

  <xsl:template match="categoryDefinition">
    <xsl:if test="$embedded='false'">
		<xsl:choose>
		<xsl:when test="@role">
        	<item value="{@id}:{@parent}" link="" icon="{@icon}:{@weight}" tooltip="{@label}:{@role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
        </xsl:when>
	    <xsl:otherwise>
        	<item value="{@id}:{@parent}" link="" icon="{@icon}:{@weight}" tooltip="{@label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
        </xsl:otherwise>
		</xsl:choose>
    </xsl:if>
    <xsl:if test="$embedded='true'">
		<xsl:choose>
		<xsl:when test="@role">
	        <item value="{@id}:{@parent}" link="" icon="{@icon}:{@weight}" tooltip="{@label}:{@role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
       </xsl:when>
	    <xsl:otherwise>
	        <item value="{@id}:{@parent}" link="" icon="{@icon}:{@weight}" tooltip="{@label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
        </xsl:otherwise>
		</xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="task">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="link" select="@link"/>
    <xsl:variable name="view" select="@view"/>
    <xsl:variable name="external" select="@external"/>
    <xsl:variable name="icon" select="@icon"/>
    <xsl:variable name="label" select="@label"/>
    <xsl:variable name="role" select="@role"/>
    <xsl:variable name="weight" select="@weight"/>

    <xsl:if test="@view">
        <xsl:for-each select="category">
            <xsl:if test="$embedded='false'">
            	<xsl:choose>
			    <xsl:when test="$role">
            	    <item value="{$id}:{@id}" link="{$view}" icon="{$icon}:{$weight}" tooltip="{$label}:{$role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:when>
			    <xsl:otherwise>
            	    <item value="{$id}:{@id}" link="{$view}" icon="{$icon}:{$weight}" tooltip="{$label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
            </xsl:if>
            <xsl:if test="$embedded='true'">
            	<xsl:choose>
			    <xsl:when test="$role">
	                <item value="{$id}:{@id}" link="{$view}" icon="{$icon}:{$weight}" tooltip="{$label}:{$role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:when>
			    <xsl:otherwise>
	                <item value="{$id}:{@id}" link="{$view}" icon="{$icon}:{$weight}" tooltip="{$label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:if>
    <xsl:if test="@link">
        <xsl:for-each select="category">
            <xsl:if test="$embedded='false'">
            	<xsl:choose>
			    <xsl:when test="$role">
	                <item value="{$id}:{@id}" link="{$link}" icon="{$icon}:{$weight}" tooltip="{$label}:{$role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:when>
			    <xsl:otherwise>
	                <item value="{$id}:{@id}" link="{$link}" icon="{$icon}:{$weight}" tooltip="{$label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
            </xsl:if>
            <xsl:if test="$embedded='true'">
            	<xsl:choose>
			    <xsl:when test="$role">
	                <item value="{$id}:{@id}" link="{$link}" icon="{$icon}:{$weight}" tooltip="{$label}:{$role}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:when>
			    <xsl:otherwise>
	                <item value="{$id}:{@id}" link="{$link}" icon="{$icon}:{$weight}" tooltip="{$label}" classtype="com.ibm.ws.console.core.item.NavigatorItem"/>
	            </xsl:otherwise>
            	</xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
