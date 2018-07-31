<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:resources="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.xmi"
  xmlns:resources.env="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.env.xmi"
  xmlns:resources.j2c="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.j2c.xmi"
  xmlns:resources.jdbc="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jdbc.xmi"
  xmlns:resources.jms="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jms.xmi"
  xmlns:resources.mail="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.mail.xmi"
  xmlns:resources.url="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.url.xmi"
  xmlns:scheduler="http://www.ibm.com/websphere/appserver/schemas/5.0/scheduler.xmi"
  xmlns:workmanager="http://www.ibm.com/websphere/appserver/schemas/5.0/workmanager.xmi">

  <xsl:import href="copy.xsl"/>

<!-- 593883 Remove metadataComplete and requiredWorkContext features (added for JCA 1.6) from RA deploymentDescriptor -->
<xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/@metadataComplete"/>
<xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/@requiredWorkContext"/>

<!-- 593883 Remove new configProperty features (added for JCA 1.6) from all resource adapter objects -->
<xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/resourceAdapter//configProperties/@ignore"/>
<xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/resourceAdapter//configProperties/@confidential"/>
<xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/resourceAdapter//configProperties/@supportsDynamicUpdates"/>

<!-- F001031-18474 Remove new J2EEResourceProperties (added for JCA 1.6) -->
<xsl:template match="properties/@ignore"/>
<xsl:template match="properties/@confidential"/>
<xsl:template match="properties/@supportsDynamicUpdates"/>
<xsl:template match="resourceProperties/@ignore"/>
<xsl:template match="resourceProperties/@confidential"/>
<xsl:template match="resourceProperties/@supportsDynamicUpdates"/>

<!-- LI: 4435.21 - Delete the singleton attribute from J2CResourceAdapter -->
<xsl:template match="resources.j2c:J2CResourceAdapter/@singleton"/>

<!-- LI: 4190-32.1 - Removes the custom property 'optimizeForGetUseClose' from DB2Universal Providers -->
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='optimizeForGetUseClose']"/>

<!-- LI: 4396.16 - Removal of isEnableHASupport and hACapability from J2CResourceAdapter -->
<xsl:template match="resources.j2c:J2CResourceAdapter/@isEnableHASupport"/>
<xsl:template match="resources.j2c:J2CResourceAdapter/@hACapability"/>

<!-- LI: 4245.13 - Remove SSL mail protocol providers -->
<xsl:template match="resources.mail:MailProvider/protocolProviders">
  <xsl:if test="not(@xmi:id='builtin_imaps' or
                    @xmi:id='builtin_pop3s' or
                    @xmi:id='builtin_smtps')">
    <xsl:call-template name="copy"/>
  </xsl:if>
</xsl:template>

<!-- LI: 4500-17.5 - Remove isolatedClassLoader attribute from all elements -->
<xsl:template match="*/@isolatedClassLoader"/>

<!-- 509503 -->
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='beginTranForResultSetScrollingAPIs']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='beginTranForVendorAPIs']"/>

<!-- LIDB3293-24 start
    Remove the new custom properties for LIDB3293, LIDB3483, LIDB4187 -->
<!-- LIDB3293 new properties -->
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='errorDetectionModel']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='withholdPoolabilityHintFromJDBCDriver']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='validateNewConnectionTimeout']"/>

<!-- LIDB3493 new properties -->
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='clientRerouteServerListJNDIName']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='unbindClientRerouteListFromJndi']"/>
<!-- 503220 CRAltServerName and CRAltPortNum are not removed.  They can also be used as actual DB2 DS props. -->

<!-- LIDB4187 new properties -->
<!-- Since "nonTransactionalDataSource is going into the feature pack (which is based on 6.1 code), leave the nonTransactionalDataSource custom property
     in, and just let the warning through for now.-->
<!-- LIDB3293-24 end -->

<!-- 503220 review of RRA properties not in WAS610 -->
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='freeResourcesOnClose']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='supplementalTrace']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='useTrustedContextWithAuthentication']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='displaySQLWarningsOnConnectionCleanup']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='clearSQLWarningsOnConnectionCleanup']"/>
<xsl:template match="resources.jdbc:JDBCProvider/factories/propertySet/resourceProperties[@name='userDefinedErrorMap']"/>

<!-- 503220 Remove DB2 JDBC 4.0 driver -->
<xsl:template match="resources.jdbc:JDBCProvider[starts-with(@providerType, 'DB2 Using IBM JCC Driver')]"/>
<!-- F1146-19602 Remove jConnect JDBC 4.0 driver -->
<xsl:template match="resources.jdbc:JDBCProvider[starts-with(@providerType, 'Sybase JDBC 4 Driver')]"/>

<xsl:template match="resources.j2c:J2CResourceAdapter/factories[@xmi:type='resources.jdbc:CMPConnectorFactory']">
  <xsl:variable name="idToMatch" select="@cmpDatasource"/>
  <xsl:choose>
    <!-- Remove this CMP connection factory when the cmpDatasource attribute matches a removed DataSource -->
    <xsl:when test="//resources.jdbc:JDBCProvider/factories[@xmi:id=$idToMatch and starts-with(@providerType, 'DB2 Using IBM JCC Driver')]"/>
    <!-- F1146-19602 -->
    <xsl:when test="//resources.jdbc:JDBCProvider/factories[@xmi:id=$idToMatch and starts-with(@providerType, 'Sybase JDBC 4 Driver')]"/>
    <xsl:otherwise>
      <xsl:call-template name="copy"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- LIDB4602-30 start -->
<!-- This will remove a JDBCProvider's (NOT a factory's) propertySet which contains a MIGRATED_PROVIDER property -->
<xsl:template match="resources.jdbc:JDBCProvider/propertySet[resourceProperties/@name='MIGRATED_PROVIDER']"/>
<!-- Something to note: the practice of calling <apply:templates select="."/> will run the current
     element/attribute through any templates that match, so if it matches a template that is defined
     to remove or change the element, then it will apply that template.  If it does not match any
     template defined, then it will match the copy template which will recursively/deep copy the
     element/attribute  (and once again, on each sub-element/attribute, apply any templates) -->
<xsl:template match="resources.jdbc:JDBCProvider">
  <!-- Only copy the JDBCProvider if: it is not specified as using isolatedClassLoader, or
    it is a migrated provider (custom property MIGRATED_PROVIDER='true') -->
  <!-- 490078 on following line, change from @isolatedClassLoader='false' to not(@isolatedClassLoader='true'),
    this is because (@isolatedClassLoader='true') will return false if the isolatedClassLoader attribute either is false,
    or does not exist on the jdbc provider. -->
  <xsl:if test="not(@isolatedClassLoader='true') or boolean(propertySet/resourceProperties[@name='MIGRATED_PROVIDER' and @value='true'])">
  <xsl:choose>
    <xsl:when test="factories/propertySet/resourceProperties/@name='MIGROLD_datasourceHelperClassname'">
      <!-- If there is even one property with name='MIGROLD_datasourceHelperClassname', then this is a migrated JDBCProvider -->
      <xsl:element name="resources.jdbc:JDBCProvider">
        <!-- This will copy all JDBCProvider attributes, while applying any templates. -->
        <xsl:apply-templates select="@*"/>
        <!-- The following call-template sections will call the templates below, this will act like a function call -->
        <xsl:call-template name="mapMigratedProvider">
          <xsl:with-param name="providerType"><xsl:value-of select="@providerType"/></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="mapMigratedImplementation">
          <xsl:with-param name="providerType"><xsl:value-of select="@providerType"/></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="mapMigratedClasspaths">
          <xsl:with-param name="providerType"><xsl:value-of select="@providerType"/></xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="*">
          <xsl:choose>
            <xsl:when test="name()='factories'">
              <!-- Start copying the factories (data sources) over -->
              <xsl:element name="factories">
                <!-- This statement will copy all of the attributes of the factories (data source) -->
                <xsl:apply-templates select="@*"/>
                <xsl:call-template name="mapMigratedProvider">
                  <xsl:with-param name="providerType"><xsl:value-of select="@providerType"/></xsl:with-param>
                </xsl:call-template>
                <xsl:attribute name="datasourceHelperClassname">
                  <!-- Find the resourceProperties element with the name 'MIGROLD_datasourceHelperClassname'
                    and use the value for the new datasourceHelperClassname of the factory. -->
                  <xsl:value-of select="propertySet/resourceProperties[@name='MIGROLD_datasourceHelperClassname']/@value"/>
                </xsl:attribute>
                <!-- The following loop will copy all elements of the factory (datasource) that are not propertySets -->
                <xsl:for-each select="*">
                  <xsl:variable name="type" select="name()"/>
                  <xsl:if test="not($type='propertySet')">
                    <xsl:apply-templates select="."/>
                  </xsl:if>
                </xsl:for-each>
                <!-- Now copy all the properties of each propertySet, only copying the resourceProperties that
                  start with MIGROLD_, and when copying, remove the MIGROLD_ tag from the name -->
                <xsl:for-each select="propertySet">
                  <xsl:element name="propertySet">
                    <xsl:attribute name="xmi:id"><xsl:value-of select="@xmi:id"/></xsl:attribute>
                    <!-- For resourceProperties, we do not need to worry about applying the other templates, since we already
                      will be stripping out any of the new properties from the higher release and restoring the properties
                      from the previous release, so none of the properties to remove will exist -->
                    <xsl:for-each select="resourceProperties">
                      <xsl:if test="starts-with(@name,'MIGROLD_') and not(@name='MIGROLD_datasourceHelperClassname')">
                        <xsl:element name="resourceProperties">
                          <xsl:for-each select="@*">
                            <xsl:apply-templates select="."/>
                            <!-- <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute> -->
                          </xsl:for-each>
                          <!-- Remove the MIGROLD_ from the name -->
                          <xsl:attribute name="name"><xsl:value-of select="substring-after(@name,'MIGROLD_')"/></xsl:attribute>
                        </xsl:element>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:when>
            <!-- The Embedded DataDirect JDBC Driver has its own classpath -->
            <xsl:when test="not(name()='classpath')">
              <xsl:call-template name="copy"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:element>
    </xsl:when>
    <!-- This when clause is for xforming non-migrated providers created in a mixed-cell evironment. -->
    <!-- 492056 Added iSeries Native -->
    <!-- 494973.1 Added ConnectJDBC -->
    <!-- 497699 Fixed Oracle providerType test -->
    <xsl:when test="@providerType='Oracle JDBC Driver'
                    or @providerType='Oracle JDBC Driver (XA)'
                    or @providerType='DB2 UDB for iSeries (Native)'
                    or @providerType='DB2 UDB for iSeries (Native XA)'
                    or @providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server'
                    or @providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server (XA)'
                    ">
      <xsl:copy>
        <xsl:for-each select="node() | @*">
          <xsl:choose>
            <xsl:when test="name()='classpath'">
              <xsl:call-template name="mapClasspaths">
                <xsl:with-param name="providerType">
                  <xsl:value-of select="../@providerType" />
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="copy"/>
    </xsl:otherwise>
  </xsl:choose>
 </xsl:if>

</xsl:template>

<!-- following functions are added so that if other drivers are migrated/mapped to something else in the future,
     then the tools will already be here to provide the mapping back -->
<xsl:template name="mapMigratedProvider">
  <xsl:param name="providerType"/>
  <xsl:choose>
    <xsl:when test="$providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server' or $providerType='Microsoft SQL Server JDBC Driver'">
      <xsl:attribute name="providerType"><xsl:text>WebSphere embedded ConnectJDBC driver for MS SQL Server</xsl:text></xsl:attribute>
    </xsl:when>
    <xsl:when test="$providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server (XA)' or $providerType='Microsoft SQL Server JDBC Driver (XA)'">
      <xsl:attribute name="providerType"><xsl:text>WebSphere embedded ConnectJDBC driver for MS SQL Server (XA)</xsl:text></xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="mapMigratedImplementation">
  <xsl:param name="providerType"/>
  <xsl:choose>
    <xsl:when test="$providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server' or $providerType='Microsoft SQL Server JDBC Driver'
       or $providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server (XA)' or $providerType='Microsoft SQL Server JDBC Driver (XA)'">
      <xsl:attribute name="implementationClassName"><xsl:text>com.ibm.websphere.jdbcx.sqlserver.SQLServerDataSource</xsl:text></xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="mapMigratedClasspaths">
  <xsl:param name="providerType"/>
  <xsl:choose>
    <xsl:when test="$providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server' or $providerType='Microsoft SQL Server JDBC Driver'
       or $providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server (XA)' or $providerType='Microsoft SQL Server JDBC Driver (XA)'">
      <xsl:element name="classpath"><xsl:text>${WAS_LIBS_DIR}/sqlserver.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${WAS_LIBS_DIR}/base.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${WAS_LIBS_DIR}/util.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${WAS_LIBS_DIR}/spy.jar</xsl:text></xsl:element>
    </xsl:when>
    <xsl:when test="$providerType='Oracle JDBC Driver' or $providerType='Oracle JDBC Driver (XA)'">
      <!-- Copy the classpath element and replace ojdbc6.jar with ojdbc14.jar, keeping any path prefix -->
      <xsl:copy>
        <xsl:choose>
          <!-- 497699 -->
          <xsl:when test="contains(., 'ojdbc6.jar' )">
            <xsl:value-of select="substring-before(., 'ojdbc6.jar')"/><xsl:text>ojdbc14.jar</xsl:text>
          </xsl:when>
          <xsl:when test="contains(., 'ojdbc6_g.jar' )">
            <xsl:value-of select="substring-before(., 'ojdbc6_g.jar')"/><xsl:text>ojdbc14_g.jar</xsl:text>
          </xsl:when>
          <!-- other path elements are copied as-is -->
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:when>
    <!-- 492056 Change ${OS400_NATIVE_JDBC40_DRIVER_PATH}/db2_classes16.jar to ${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar -->
    <xsl:when test="$providerType='DB2 UDB for iSeries (Native)' or $providerType='DB2 UDB for iSeries (Native XA)'">
      <xsl:element name="classpath"><xsl:text>${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar</xsl:text></xsl:element>
    </xsl:when>
  </xsl:choose>
</xsl:template>
<!-- End LIDB4602-30 -->

<!-- These are classpath transforms for NON-migrated providers. -->
<xsl:template name="mapClasspaths">
  <xsl:param name="providerType"/>
  <xsl:choose>
    <xsl:when test="$providerType='Oracle JDBC Driver' or $providerType='Oracle JDBC Driver (XA)'">
      <!-- Copy the classpath element and replace ojdbc6.jar with ojdbc14.jar, keeping any path prefix -->
      <xsl:copy>
        <xsl:choose>
          <!-- 497699 -->
          <xsl:when test="contains(., 'ojdbc6.jar' )">
            <xsl:value-of select="substring-before(., 'ojdbc6.jar')"/><xsl:text>ojdbc14.jar</xsl:text>
          </xsl:when>
          <xsl:when test="contains(., 'ojdbc6_g.jar' )">
            <xsl:value-of select="substring-before(., 'ojdbc6_g.jar')"/><xsl:text>ojdbc14_g.jar</xsl:text>
          </xsl:when>
          <!-- other path elements are copied as-is -->
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:when>
    <!-- 492056 Change ${OS400_NATIVE_JDBC40_DRIVER_PATH}/db2_classes16.jar to ${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar -->
    <xsl:when test="$providerType='DB2 UDB for iSeries (Native)' or $providerType='DB2 UDB for iSeries (Native XA)'">
      <xsl:element name="classpath"><xsl:text>${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar</xsl:text></xsl:element>
    </xsl:when>
    <!-- 494973.1 Added ConnectJDBC -->
    <xsl:when test="$providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server'
                    or $providerType='DataDirect ConnectJDBC type 4 driver for MS SQL Server (XA)'
                    ">
      <xsl:element name="classpath"><xsl:text>${CONNECTJDBC_JDBC_DRIVER_PATH}/sqlserver.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${CONNECTJDBC_JDBC_DRIVER_PATH}/base.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${CONNECTJDBC_JDBC_DRIVER_PATH}/util.jar</xsl:text></xsl:element>
      <xsl:element name="classpath"><xsl:text>${CONNECTJDBC_JDBC_DRIVER_PATH}/../spy/spy.jar</xsl:text></xsl:element>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- feature 477886.3 - Remove mailStorePort and mailTransportPort attributes from MailSession -->
<xsl:template match="resources.mail:MailProvider/factories/@mailStorePort">
  <xsl:if test="not(../@xmi:type='resources.mail:MailSession')">
    <xsl:call-template name="copy"/>
  </xsl:if>
</xsl:template>

<xsl:template match="resources.mail:MailProvider/factories/@mailTransportPort">
  <xsl:if test="not(../@xmi:type='resources.mail:MailSession')">
    <xsl:call-template name="copy"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

