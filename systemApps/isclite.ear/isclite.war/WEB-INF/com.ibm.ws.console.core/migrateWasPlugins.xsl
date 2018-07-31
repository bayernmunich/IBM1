<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd"
            xmlns:navigation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd ibm-portal-navigation.xsd http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd ibm-portal-base.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="needMaster"/>

    <xsl:template match="/plugin">
        <xsl:param name="pluginId" select="@id"/>
        <navigation:navigation-tree>
            <xsl:for-each select="extension">
                <xsl:if test="@point = 'com.ibm.ws.console.core.navigatorTask'">
                    <xsl:apply-templates select="/plugin/extension/tasks">
                         <xsl:with-param name="pluginId" select="/plugin/@id"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="$needMaster = 'true'">
                <xsl:copy-of select="document('master.xml')/navigation:navigation-tree/navigation:nav-element"/>
            </xsl:if>
        </navigation:navigation-tree>
    </xsl:template>

    <xsl:template match="/plugin/extension/tasks">
        <xsl:param name="pluginId"/>
        <xsl:for-each select="categoryDefinition">
            <navigation:nav-element>
                <xsl:attribute name="uniqueName">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:attribute name="nodeType">label</xsl:attribute>
                <xsl:attribute name="moduleID"><xsl:value-of select="$pluginId"/></xsl:attribute>
                <xsl:attribute name="wscRole"><xsl:value-of select="@role"/></xsl:attribute>
                <navigation:title>
                    <base:nls-ref>
                        <xsl:attribute name="key">
                            <xsl:value-of select="@label"/>
                        </xsl:attribute>
                        <xsl:attribute name="locationName">
                            <xsl:text>com/ibm/ws/console/core/resources/ConsoleAppResources</xsl:text>
                        </xsl:attribute>
                    </base:nls-ref>
                </navigation:title>
                <navigation:parentTree>
                    <xsl:attribute name="parentTreeRef">
                        <xsl:value-of select="@parent" />
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@weight!=''">
                            <xsl:attribute name="ordinal">
                                <xsl:value-of select="@weight"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="ordinal">
                                <xsl:text>210</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </navigation:parentTree>
            </navigation:nav-element>
            <!--</xsl:if>-->
        </xsl:for-each>
        <xsl:variable name="empty_string"/>

        <xsl:for-each select="/plugin/extension/tasks/task">
            <xsl:variable name="taskCategory" select="category/@id"/>
            <navigation:nav-element>
                <!--This is a hack because the appmanagement.war plugin.xml has an attribute called "link", when it 
                should be called "view".  So I am just adding some checking...hopefully we can get this changed on the WEBUI side -->
                <xsl:if test="@view != $empty_string">
                    <xsl:attribute name="url">
                        <xsl:if test="@external != 'true'">
                            <xsl:text>/ibm/console</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="@view"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="@link != $empty_string">
                    <xsl:attribute name="url">
                        <xsl:text>/ibm/console</xsl:text>
                        <xsl:value-of select="@link"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="uniqueName">
                    <xsl:value-of select="$pluginId"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="@label"/>
                </xsl:attribute>
                <xsl:attribute name="nodeType">url</xsl:attribute>
                <xsl:attribute name="moduleID"><xsl:value-of select="$pluginId"/></xsl:attribute>
                <xsl:attribute name="wscRole"><xsl:value-of select="@role"/></xsl:attribute>
                <xsl:attribute name="external"><xsl:value-of select="@external"/></xsl:attribute>
                <xsl:if test="@resourceType">
                    <xsl:attribute name="resourceType"><xsl:value-of select="@resourceType"/></xsl:attribute>
                </xsl:if>
                <navigation:title>
                    <base:nls-ref>
                        <xsl:attribute name="key">
                            <xsl:value-of select="@label"/>
                        </xsl:attribute>
                        <xsl:attribute name="locationName">
                            <xsl:text>com/ibm/ws/console/core/resources/ConsoleAppResources</xsl:text>
                        </xsl:attribute>
                    </base:nls-ref>
                </navigation:title>
                <navigation:parentTree>
                    <xsl:attribute name="parentTreeRef">
                        <xsl:value-of select="category/@id" />
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@weight!=''">
                            <xsl:attribute name="ordinal">
                                <xsl:value-of select="@weight"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="ordinal">
                                <xsl:text>210</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </navigation:parentTree>
            </navigation:nav-element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
