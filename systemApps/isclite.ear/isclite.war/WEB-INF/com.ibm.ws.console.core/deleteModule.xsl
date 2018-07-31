<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd"
            xmlns:navigation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd ibm-portal-navigation.xsd http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd ibm-portal-base.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="moduleID"/>

    <xsl:template match="/">
        <navigation:navigation-tree>
            <xsl:apply-templates select="/navigation:navigation-tree"/>
        </navigation:navigation-tree>
    </xsl:template>
    

    <xsl:template match="/navigation:navigation-tree">
        <xsl:apply-templates select="//navigation:nav-element"/>
    </xsl:template>

    <xsl:template match="//navigation:nav-element">
        <xsl:if test="@moduleID != $moduleID">
            <navigation:nav-element>
                <xsl:if test="@nodeType = 'url'">
                    <xsl:attribute name="url">
                        <xsl:value-of select="@url"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="uniqueName">
                    <xsl:value-of select="@uniqueName"/>
                </xsl:attribute>
                <xsl:attribute name="moduleID">
                    <xsl:value-of select="@moduleID"/>
                </xsl:attribute>
                <xsl:attribute name="nodeType">
                    <xsl:value-of select="@nodeType"/>
                </xsl:attribute>
                <xsl:attribute name="wscRole">
                        <xsl:value-of select="@wscRole"/>
                </xsl:attribute>
                <xsl:attribute name="external">
                    <xsl:value-of select="@external"/>
                </xsl:attribute>
                <xsl:copy-of select="navigation:title"/>
                <xsl:copy-of select="navigation:parentTree"/>
            </navigation:nav-element>
        </xsl:if>
 </xsl:template>
</xsl:stylesheet>

