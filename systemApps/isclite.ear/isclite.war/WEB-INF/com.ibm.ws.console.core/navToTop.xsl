<!-- This stylsheet is used to generate an ibm-portal-topology.xml for the WAS module by using the navigation.xml -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd"
            xmlns:navigation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-navigation.xsd ibm-portal-navigation.xsd http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd ibm-portal-base.xsd">
<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<xsl:apply-templates select="/navigation:navigation-tree"/>
	</xsl:template>

	<xsl:template match="/navigation:navigation-tree">
		<ibm-portal-topology xmlns="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-topology.xsd" 
			xmlns:base="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-base.xsd" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			xsi:schemaLocation="http://www.ibm.com/websphere/appserver/schemas/6.0/ibm-portal-topology ibm-portal-topology.xsd">

			<application-definition appID="com.ibm.websphere.product" version="6.1.0.0">
				<title>
					<base:nls-string lang="en">WebSphere Application Server</base:nls-string>
				</title>

				<component-tree uniqueName="com.ibm.ws.product">
				</component-tree>

				<layout-tree>
				</layout-tree>

			</application-definition>  

			<about-page>/ibm/console/secure/content.jsp</about-page>
		</ibm-portal-topology>
	</xsl:template>

</xsl:stylesheet>
