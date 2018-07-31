<?xml version="1.0"?>

<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://www.ibm.com/merge" exclude-result-prefixes="m">
	
	<!-- Normalize the contents of text, comment, and processing-instruction
		nodes before comparing?
		Default: yes -->
	<xsl:param name="normalize" select="'yes'" />


	<xsl:template match="m:merge">
		<xsl:variable name="file1" select="string(m:file1)" />
		<xsl:variable name="file2" select="string(m:file2)" />
		<xsl:message>
			<xsl:text />
			Merging '
			<xsl:value-of select="$file1" />
			<xsl:text />
			' and '
			<xsl:value-of select="$file2" />
			'
			<xsl:text />
		</xsl:message>
		<xsl:if test="$file1='' or $file2=''">
			<xsl:message terminate="yes">
				<xsl:text>No files to merge specified</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:call-template name="m:merge">
			<xsl:with-param name="nodes1" select="document($file1,/*)/node()" />
			<xsl:with-param name="nodes2" select="document($file2,/*)/node()" />
		</xsl:call-template>
	</xsl:template>


	<!-- Variant 2:
		The transformation sheet merges the source document with the
		document provided by the parameter "with".
	-->
	<xsl:param name="with" />

	<xsl:template match="*">
		<xsl:message>
			<xsl:text />
			Merging input with '
			<xsl:value-of select="$with" />
			<xsl:text>'</xsl:text>
		</xsl:message>
		<xsl:if test="string($with)=''">
			<xsl:message terminate="yes">
				<xsl:text>No input file specified (parameter 'with')</xsl:text>
			</xsl:message>
		</xsl:if>

		<xsl:call-template name="m:merge">
			<xsl:with-param name="nodes1" select="/node()" />
			<xsl:with-param name="nodes2" select="document($with,/*)/node()" />
		</xsl:call-template>
	</xsl:template>


	<!-- ============================================================== -->

	<!--
		Merge 2 WebXML (assume onw is web.xml and one is the sip.xml transofmation into webTemp.xml)
		======================================================================================
		
		assumption - we will take the web.xml and integrae into it the contents of the webTemp.xml
		
		
		
		1.  filter,filter-mapping,mime-mapping,welcome-file-list suppose to exist only in web.xml (take it from it)
		2.  display-name,description (should be the same ), only one is taking (take web.xml)
		3.  login-config (should be the same), only one is taking (take web.xml)
		4.  listener (union), make shure there is no repeat 
		5.  servlet,servlet-mapping (union)
		8.  resource-env-ref,resource-ref,env-entry,ejb-ref,ejb-local-ref (union), make shure there is no repeat 
		9.  security-constraint (union), make shure there is no repeat
		10. context-param (union), make shure there is no repeat   
		11. security-role (union), make shure there is no repeat
		12. distributable, icon if exist in one of them, should be the same and added once (take web.xml)
		
	-->

	<!-- The "merge" template -->
	<xsl:template name="m:merge">
		<xsl:param name="nodes1" />
		<xsl:param name="nodes2" />
		
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE web-app PUBLIC	"-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN" "http://java.sun.com/dtd/web-app_2_3.dtd"&gt;
		</xsl:text>
		<web-app id="WebApp">
		
		
		<!-- handle icon -->
		<xsl:copy-of select="$nodes1/icon" />
		<xsl:apply-templates select="$nodes2/icon">
			<xsl:with-param name="nodes1spr" select="$nodes1//icon" />
		</xsl:apply-templates>

		<!-- handle display-name -->
		<xsl:apply-templates select="$nodes2/display-name">
			<xsl:with-param name="nodes1spr" select="$nodes1//display-name" />
		</xsl:apply-templates>
		

		<!-- handle discription -->
		<xsl:copy-of select="$nodes1/discription" />
		<xsl:apply-templates select="$nodes2/discription">
			<xsl:with-param name="nodes1spr" select="$nodes1//discription" />
		</xsl:apply-templates>

		<!-- handle distributable -->
		<xsl:copy-of select="$nodes1/distributable" />
		<xsl:apply-templates select="$nodes2/distributable">
			<xsl:with-param name="nodes1spr" select="$nodes1//distributable" />
		</xsl:apply-templates>

		<!-- handle context-param -->
		<xsl:copy-of select="$nodes1/context-param" />
		<xsl:apply-templates select="$nodes2/context-param">
			<xsl:with-param name="nodes1spr" select="$nodes1//context-param" />
		</xsl:apply-templates>
		
		<!-- handle filter -->
		<xsl:copy-of select="$nodes1/filter" />

		<!-- handle filter-mapping -->
		<xsl:copy-of select="$nodes1/filter-mapping" />

		<!-- handle listener -->
		<xsl:copy-of select="$nodes1/listener" />
		<xsl:apply-templates select="$nodes2/listener">
			<xsl:with-param name="nodes1spr" select="$nodes1//listener" />
		</xsl:apply-templates>

		<!-- handle servlet -->
		<xsl:copy-of select="$nodes1/servlet" />
		<xsl:apply-templates select="$nodes2/servlet">
			<xsl:with-param name="nodes1spr" select="$nodes1//servlet" />
		</xsl:apply-templates>

		<!-- handle servlet-mapping -->
		<xsl:copy-of select="$nodes1/servlet-mapping" />
		<xsl:apply-templates select="$nodes2/servlet-mapping">
			<xsl:with-param name="nodes1spr" select="$nodes1//servlet-mapping" />
		</xsl:apply-templates>

		<!-- handle session-config -->
		<xsl:copy-of select="$nodes1/session-config" />

		<!-- handle mime-mapping -->
		<xsl:copy-of select="$nodes1/mime-mapping" />

		<!-- handle welcome-file-list -->
		<xsl:copy-of select="$nodes1/welcome-file-list" />
		
		<!-- handle error-page -->
		<xsl:copy-of select="$nodes1/error-page" />

		<!-- handle taglib -->
		<xsl:copy-of select="$nodes1/taglib" />
		
		<!-- handle  resource-env-ref -->
		<xsl:copy-of select="$nodes1/resource-env-ref" />
		<xsl:apply-templates select="$nodes2/resource-env-ref">
			<xsl:with-param name="nodes1spr" select="$nodes1//resource-env-ref" />
		</xsl:apply-templates>

		<!-- handle  resource-ref -->
		<xsl:copy-of select="$nodes1/resource-ref" />
		<xsl:apply-templates select="$nodes2/resource-ref">
			<xsl:with-param name="nodes1spr" select="$nodes1//resource-ref" />
		</xsl:apply-templates>

		<!-- handle  security-constraint -->
		<xsl:copy-of select="$nodes1/security-constraint" />
		<xsl:apply-templates select="$nodes2/security-constraint">
			<xsl:with-param name="nodes1spr" select="$nodes1//security-constraint" />
		</xsl:apply-templates>

		<!-- handle login-config -->
		<xsl:copy-of select="$nodes1/login-config" />
		<xsl:apply-templates select="$nodes2/login-config">
			<xsl:with-param name="nodes1spr" select="$nodes1//login-config" />
		</xsl:apply-templates>

		<!-- handle  security-role-->
		<xsl:copy-of select="$nodes1/security-role" />
		<xsl:apply-templates select="$nodes2/security-role">
			<xsl:with-param name="nodes1spr" select="$nodes1//security-role" />
		</xsl:apply-templates>		

		<!-- handle  env-entry-->
		<xsl:copy-of select="$nodes1/env-entry" />
		<xsl:apply-templates select="$nodes2/env-entry">
			<xsl:with-param name="nodes1spr" select="$nodes1//env-entry" />
		</xsl:apply-templates>

		<!-- handle  ejb-ref-->
		<xsl:copy-of select="$nodes1/ejb-ref" />
		<xsl:apply-templates select="$nodes2/ejb-ref">
			<xsl:with-param name="nodes1spr" select="$nodes1//ejb-ref" />
		</xsl:apply-templates>

		<!-- handle  ejb-local-ref-->
		<xsl:copy-of select="$nodes1/ejb-local-ref" />
		<xsl:apply-templates select="$nodes2/ejb-local-ref">
			<xsl:with-param name="nodes1spr" select="$nodes1//ejb-local-ref" />
		</xsl:apply-templates>

		</web-app>
	</xsl:template>

	<!-- The matching templates -->
	<xsl:template match="icon">
		<xsl:param name="nodes1spr" />
		<xsl:if test="not($nodes1spr)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="display-name">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="current()" />
		<xsl:choose>
		   <xsl:when test="$nodes1spr=$myName">
			<xsl:copy-of select="current()" />
		   </xsl:when>
		   <xsl:otherwise>
		   
		      *****  DISPLAY NAME OF SIP.XML AND ORIGINAL WEB.XML ARE NOT THE SAME *****
		   </xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:template match="discription">
		<xsl:param name="nodes1spr" />
		<xsl:if test="not($nodes1spr)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="distributable">
		<xsl:param name="nodes1spr" />
		<xsl:if test="not($nodes1spr)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="context-param">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="param-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[param-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="listener">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="listener-class" />
		<xsl:variable name="isInnode" select="$nodes1spr[listener-class=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="servlet">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="servlet-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[servlet-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="servlet-mapping">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="servlet-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[servlet-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="login-config">
		<xsl:param name="nodes1spr"/>
		<xsl:if test="not($nodes1spr)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="resource-env-ref">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="res-ref-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[res-env-ref-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="resource-ref">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="res-ref-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[res-ref-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="env-entry">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="env-entry-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[env-entry-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ejb-ref">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="ejb-ref-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[ejb-ref-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ejb-local-ref">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="ejb-ref-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[ejb--ref-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="security-constraint">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="web-resource-collection/web-resource-name" />
		<xsl:variable name="isInnode" select="$nodes1spr/web-resource-collection[web-resource-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="security-role">
		<xsl:param name="nodes1spr" />
		<xsl:variable name="myName" select="role-name" />
		<xsl:variable name="isInnode" select="$nodes1spr[role-name=$myName]" />
		<xsl:if test="not($isInnode)">
			<xsl:copy-of select="current()" />
		</xsl:if>
	</xsl:template>
</xsl:transform>
