<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:applicationclientext="applicationclientext.xmi"
  xmlns:ejbext="ejbext.xmi"
  xmlns:webappext="webappext.xmi"
  xmlns:appdeployment="http://www.ibm.com/websphere/appserver/schemas/5.0/appdeployment.xmi"
  xmlns:com.ibm.ejs.models.base.bindings.ejbbnd="ejbbnd.xmi">

<xsl:import href="copy.xsl"/>

<!-- Remove standaloneModule attribute from deployment.xml
     DR: F000743.515
-->
<xsl:template match="appdeployment:Deployment/deployedObject/@standaloneModule"/>

<!-- Remove name attribute from deployment.xml
     DR: F743-19792.3
-->
<xsl:template match="appdeployment:Deployment/deployedObject/@name"/>

<!-- Remove enableClientModule and ClientModuleDeployment attributes from deployment.xml
     DR: F000743.28799
-->
<xsl:template match="appdeployment:Deployment/deployedObject/@enableClientModule"/>
<xsl:template match="appdeployment:Deployment/deployedObject/modules[@xmi:type='appdeployment:ClientModuleDeployment']"/>

<!-- Remove containsEJBContent attribute from deployment.xml
     DR: F00743.24339
-->
<xsl:template match="appdeployment:Deployment/deployedObject/modules/@containsEJBContent"/>

<!-- Remove EJBModuleConfiguration in WebModuleConfig from deployment.xml
     DR: F000743.22282
-->
<xsl:template match="appdeployment:Deployment/deployedObject/modules/configs[@xmi:type='appcfg:WebModuleConfig']/ejbModuleConfiguration"/>

<!-- Remove any Property from a module.  Module level Property elements were not support pre V8.
     F743-26091
-->
<xsl:template match="appdeployment:Deployment/deployedObject/modules/properties"/>

<!-- Remove any 'name' attribute from a module.  Module level 'name' elements were not supported pre-V8.
     F00743.25395
-->
<xsl:template match="appdeployment:Deployment/deployedObject/modules/@name"/>

<!-- Remove any 'useContextRootAsPath' attribute from the cookie configuration.  This was not supported pre-V8.
     F743-32259
-->
<xsl:template match="appdeployment:Deployment/deployedObject/configs/sessionManagement/defaultCookieSettings/@useContextRootAsPath"/>

<!-- Convert the binary install location of the CEA system application commsvc.ear from V8 to V7.
     667439.1
-->
<xsl:template match="appdeployment:Deployment/deployedObject/@binariesURL[.='${WAS_INSTALL_ROOT}/systemApps/commsvc.ear']" >
    <xsl:attribute name="binariesURL">
        <xsl:text>${WAS_INSTALL_ROOT}/feature_packs/cea/systemApps/commsvc.ear</xsl:text>
    </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
