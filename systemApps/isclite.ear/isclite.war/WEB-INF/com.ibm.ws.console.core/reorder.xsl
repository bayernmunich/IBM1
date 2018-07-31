<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd"
            xmlns:navigation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd ibm-portal-navigation.xsd http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd ibm-portal-base.xsd">
    <xsl:output method="xml" indent="yes" />
    <xsl:template match="/">
        <navigation:navigation-tree>
            <xsl:apply-templates select="/navigation:navigation-tree"/>
        </navigation:navigation-tree>
    </xsl:template>

    <xsl:template match="/navigation:navigation-tree">
        <xsl:apply-templates select="navigation:nav-element">
            <xsl:sort select="navigation:parentTree/@ordinal" data-type="number"/>
            <xsl:sort select="@uniqueName"/>
        </xsl:apply-templates>
    </xsl:template>
 
    <xsl:template match="navigation:nav-element">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
