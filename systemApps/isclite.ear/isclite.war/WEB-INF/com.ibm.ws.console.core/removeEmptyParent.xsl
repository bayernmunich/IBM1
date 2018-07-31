<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd"
            xmlns:navigation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd ibm-portal-navigation.xsd http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd ibm-portal-base.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <navigation:navigation-tree>
            <xsl:apply-templates select="/navigation:navigation-tree"/>
        </navigation:navigation-tree>
    </xsl:template>
    <xsl:template match="/navigation:navigation-tree">
        <xsl:for-each select="navigation:nav-element">
            <xsl:choose>
                <xsl:when test="@nodeType = 'label'">
                    <xsl:variable name="categoryName" select="@uniqueName"/>
                    <xsl:variable name="children" select="count(/navigation:navigation-tree/navigation:nav-element/navigation:parentTree[@parentTreeRef=$categoryName])"/>
                    <xsl:choose>
                        <xsl:when test="$children > 1">
                            <xsl:copy-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
