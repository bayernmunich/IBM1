<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rolebasedauthz="http://www.ibm.com/websphere/appserver/schemas/5.0/rolebasedauthz.xmi"
  xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI">
  
  <xsl:import href="copy.xsl"/>

  <!-- LI4157 -->
  <xsl:template match="rolebasedauthz:AuthorizationTableExt/authorizations/specialSubjects[@xmi:type='rolebasedauthz:AllAuthenticatedUsersExt']"/>
  <xsl:template match="rolebasedauthz:AuthorizationTableExt/authorizations/specialSubjects[@xmi:type='rolebasedauthz:AllAuthenticatedUsersInTrustedRealmsExt']"/>
  
  </xsl:stylesheet>
