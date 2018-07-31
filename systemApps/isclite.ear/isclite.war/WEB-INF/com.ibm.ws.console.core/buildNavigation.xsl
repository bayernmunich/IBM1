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
            <xsl:if test="navigation:parentTree/@parentTreeRef = 'root'">
                <navigation:nav-element>
                    <xsl:if test="@url != ''">
                        <xsl:if test="@nodeType = 'url'">
                            <xsl:attribute name="url">
                                <xsl:value-of select="@url"/>
                            </xsl:attribute>
                        </xsl:if>
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
                    <xsl:attribute name="isWscNode">
                        <xsl:choose>
                            <xsl:when test="navigation:title/base:nls-ref/@locationName = 'com/ibm/ws/console/core/resources/ConsoleAppResources'">
                                <xsl:choose>
                                    <xsl:when test="@moduleID = 'com.ibm.isclite.ISCAdminPortlet'">
                                        <xsl:text>false</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                <xsl:text>true</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>false</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="string-length(normalize-space(@wscRole))>0">
                        <xsl:attribute name="wscRole">
                            <xsl:value-of select="@wscRole"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@resourceType">
                        <xsl:attribute name="resourceType"><xsl:value-of select="@resourceType"/></xsl:attribute>
                    </xsl:if>
                    <!--<xsl:choose>
                        <xsl:when test="@external = ''">
                            <xsl:attribute name="external">
                                <xsl:text>false</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="external">
                                <xsl:value-of select="@external"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose> -->
                    <xsl:copy-of select="navigation:title"/>
                    <xsl:copy-of select="navigation:parentTree"/>
                    <navigation:parameter name="ProductFilter">
                        <base:value>
                            <base:string>com.ibm.websphere.product</base:string>
                        </base:value>
                    </navigation:parameter>
                    <xsl:apply-templates select="//navigation:nav-element">
                        <xsl:with-param name="categoryName" select="@uniqueName"/>
                    </xsl:apply-templates>
                </navigation:nav-element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//navigation:nav-element">
        <xsl:param name="categoryName"/>
        <xsl:if test="navigation:parentTree/@parentTreeRef != 'root'">
            <xsl:if test="navigation:parentTree/@parentTreeRef = $categoryName">
                <navigation:nav-element>
                    <xsl:if test="@url != ''">
                        <xsl:if test="@nodeType = 'url'">
                            <xsl:attribute name="url">
                                <xsl:value-of select="@url"/>
                            </xsl:attribute>
                        </xsl:if>
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
                    <xsl:attribute name="isWscNode">
                        <xsl:choose>
                            <xsl:when test="navigation:title/base:nls-ref/@locationName = 'com/ibm/ws/console/core/resources/ConsoleAppResources'">
                                <xsl:choose>
                                    <xsl:when test="@moduleID = 'com.ibm.isclite.ISCAdminPortlet'">
                                        <xsl:text>false</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                <xsl:text>true</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>false</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="string-length(normalize-space(@wscRole))>0">
                        <xsl:attribute name="wscRole">
                            <xsl:value-of select="@wscRole"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@resourceType">
                        <xsl:attribute name="resourceType"><xsl:value-of select="@resourceType"/></xsl:attribute>
                    </xsl:if>
                    <!--<xsl:choose>
                        <xsl:when test="@external = ''">
                            <xsl:attribute name="external">
                                <xsl:text>false</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="external">
                                <xsl:value-of select="@external"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose> -->
                    <xsl:copy-of select="navigation:title"/>
                    <xsl:copy-of select="navigation:parentTree"/>
                    <navigation:parameter name="ProductFilter">
                        <base:value>
                            <base:string>com.ibm.websphere.product</base:string>
                        </base:value>
                    </navigation:parameter>
                    <xsl:if test="@nodeType = 'label'">
                        <xsl:apply-templates select="//navigation:nav-element">
                            <xsl:with-param name="categoryName" select="@uniqueName"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </navigation:nav-element>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
