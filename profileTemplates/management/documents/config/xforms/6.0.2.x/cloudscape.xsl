<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmi="http://www.omg.org/XMI" xmlns:resources="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.xmi" xmlns:resources.env="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.env.xmi" xmlns:resources.j2c="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.j2c.xmi" xmlns:resources.jdbc="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jdbc.xmi" xmlns:resources.jms="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.jms.xmi" xmlns:resources.mail="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.mail.xmi" xmlns:resources.url="http://www.ibm.com/websphere/appserver/schemas/5.0/resources.url.xmi" xmlns:scheduler="http://www.ibm.com/websphere/appserver/schemas/5.0/scheduler.xmi" xmlns:workmanager="http://www.ibm.com/websphere/appserver/schemas/5.0/workmanager.xmi">
<xsl:import href="copy.xsl"/>
<!-- Finds the jdbcprovider element and changes its attributes -->
<!-- These changes are based from LIDB3709 SDD -->

<xsl:template match="resources.jdbc:JDBCProvider[@implementationClassName='com.ibm.db2.jcc.DB2ConnectionPoolDataSource' or @implementationClassName='org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource' or @implementationClassName='org.apache.derby.jdbc.EmbeddedXADataSource']">
      <!-- Test for migration by checking for the new configProperties entry created by migration -->
    <!-- I -->
    <xsl:if test="contains(@description,'migrated -') and (@implementationClassName[.='org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource'] or @implementationClassName[.='org.apache.derby.jdbc.EmbeddedXADataSource'])"> 
      <!-- Found the olddbname attribute. performing transform... -->
        <xsl:variable name="cpath1">${CLOUDSCAPE_JDBC_DRIVER_PATH}/db2j.jar</xsl:variable>
          <!-- -->
          <!-- Modify attributes within the resources.jdbc element -->
      <xsl:copy>
        <xsl:for-each select="@*">
          <xsl:choose>
              <!-- copies all but the changing attributes -->
            <xsl:when test="not(local-name(.)='implementationClassName' or local-name(.)='description')">
              <xsl:call-template name="copy"/>
            </xsl:when>
              <!-- I b -->
              <!-- finds and changes the implementationClassName-->
            <xsl:when test="local-name()='implementationClassName'">
              <xsl:if test=".='org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource'">
                <xsl:attribute name="{name()}">com.ibm.db2j.jdbc.DB2jConnectionPoolDataSource</xsl:attribute>              
              </xsl:if>
              <xsl:if test="../@implementationClassName='org.apache.derby.jdbc.EmbeddedXADataSource'">
                <xsl:attribute name="implementationClassName">com.ibm.db2j.jdbc.DB2jXADataSource</xsl:attribute>
              </xsl:if>  
            </xsl:when>
              <!-- I f 2-->
              <!-- remove the migrated tag within the description-->
            <xsl:when test="local-name()='description'">
              <xsl:attribute name="description"><xsl:value-of select="concat(substring-before(../@description, 'migrated -'),substring-after(../@description, 'migrated -'))"/></xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
          <!-- -->
          <!-- retrieve the backed up classpaths from each datasource custom property-->
        <xsl:for-each select="*">
          <xsl:choose>
            <xsl:when test="local-name(.)='factories'">
              <xsl:for-each select="*">
                <xsl:choose>
                  <xsl:when test="name()='propertySet'"> 
                    <xsl:for-each select="*">
                      <xsl:choose>
                        <xsl:when test="@name='CloudscapeOldClasspath' and not(@value=$cpath1)">
                          <xsl:variable name="cpBackup" select="@value"/>
                          <xsl:element name="classpath"><xsl:value-of select="$cpBackup"/></xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                </xsl:choose>   
              </xsl:for-each>       
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
          <!-- add the default classpath -->
        <xsl:element name="classpath"><xsl:value-of select="$cpath1"/></xsl:element>
          <!-- -->
          <!-- work with the elements within the JDBCProivder -->
        <xsl:for-each select="*">
          <xsl:choose>
              <!-- copies all elements except factories and configProperties -->
            <xsl:when test="not(local-name(.)='factories' or local-name(.)='classpath')">
              <xsl:call-template name="copy"/>
            </xsl:when>
              <!-- -->
              <!-- modify the attributes within the factories element if the description contains migrated -->
            <xsl:when test="local-name()='factories' and contains(../@description,'migrated -')">
              <!--   found factories -->
            <xsl:copy>
              <xsl:for-each select="@*">
                <xsl:choose>
                    <!-- copies all attributes but datasourceHelperClassname -->
                  <xsl:when test="not(local-name(.)='datasourceHelperClassname' or local-name(.)='description')">
                    <xsl:call-template name="copy"/>
                  </xsl:when>
                    <!-- I c -->
                    <!-- finds and changes the datasourceHelperClassname -->
                  <xsl:when test="local-name()='datasourceHelperClassname'">
                    <xsl:if test=".='com.ibm.websphere.rsadapter.DerbyDataStoreHelper'">
                      <xsl:attribute name="{name()}">com.ibm.websphere.rsadapter.CloudscapeDataStoreHelper</xsl:attribute>
                    </xsl:if> 
                    <xsl:if test="not(.='com.ibm.websphere.rsadapter.DerbyDataStoreHelper')">
                      <xsl:call-template name="copy"/>
                    </xsl:if>
                  </xsl:when>
                    <!-- I f 2-->
                    <!-- remove the migrated tag within the description-->
                  <xsl:when test="local-name()='description'">
                    <xsl:attribute name="description"><xsl:value-of select="concat(substring-before(../@description, 'migrated -'),substring-after(../@description, 'migrated -'))"/></xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
              <xsl:for-each select="*">  
                <xsl:choose>
                    <!-- Copy all non-propertySet elements -->
                  <xsl:when test="not(name()='propertySet')">
                    <xsl:call-template name="copy"/>
                  </xsl:when>
                    <!-- I f 1 -->
                    <!-- Within propertySet, all elements will be copied except the elements with names databasename or CloudscapeOldDatabaseName -->
                    <!-- CloudscapeOldDatabaseName will be found and its value will be transferred to databasename's value -->
                  <xsl:when test="name()='propertySet'"> <xsl:copy>
                    <xsl:for-each select="@*">
                      <xsl:choose>
                        <xsl:when test="not(@name='')">
                          <xsl:call-template name="copy"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="*">
                      <xsl:choose>
                        <xsl:when test="not(@name='databaseName' or @name='CloudscapeOldDatabaseName' or @name='CloudscapeOldClasspath')">
                          <xsl:call-template name="copy"/>
                        </xsl:when>
                        <xsl:when test="@name='CloudscapeOldDatabaseName'">
                          <xsl:variable name="dbBackup" select="@value"/>
                          <xsl:for-each select="../*">
                            <xsl:choose>
                              <xsl:when test="@name='databaseName'">
                                <xsl:copy>
                                <xsl:for-each select="@*">
                                  <xsl:choose>
                                    <xsl:when test="not(local-name(.)='value')">
                                      <xsl:call-template name="copy"/>
                                    </xsl:when>
                                    <xsl:when test="local-name(.)='value'">
                                      <xsl:attribute name="value"><xsl:value-of select="$dbBackup"/></xsl:attribute>
                                    </xsl:when>
                                  </xsl:choose>
                                </xsl:for-each>
                                </xsl:copy>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:for-each>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:copy></xsl:when>                  
                </xsl:choose>
              </xsl:for-each>
            </xsl:copy>
            </xsl:when>
            <xsl:when test="local-name()='factories' and contains(../@description,'migrated')">
                <!-- removes non-migrated factories from 602 mixed cell environments -->
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:copy>
    </xsl:if>

       <!-- II -->
    <xsl:if test="contains(@description,'migrated -') and (@implementationClassName[.='com.ibm.db2.jcc.DB2ConnectionPoolDataSource'])">
      <!-- Found the olddbname attribute. performing transform... -->
      <!-- create default classpath variables -->
        <xsl:variable name="cpath1">${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc.jar</xsl:variable>
        <xsl:variable name="cpath2">${CLOUDSCAPE_JDBC_DRIVER_PATH}/otherJars/db2jcc.jar</xsl:variable>
        <xsl:variable name="cpath3">${CLOUDSCAPE_JDBC_DRIVER_PATH}/db2j.jar</xsl:variable>
        <xsl:variable name="cpath4">${UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc_license_cu.jar</xsl:variable>
          <!-- -->
          <!-- Modify attributes within the resources.jdbc element -->
      <xsl:copy>
        <xsl:for-each select="@*">
          <xsl:choose>
            <xsl:when test="not(local-name(.)='description')">
              <xsl:call-template name="copy"/>
            </xsl:when>
              <!-- II d 2-->
              <!-- remove the migrated tag within the description-->
            <xsl:when test="local-name()='description'">
              <xsl:attribute name="description"><xsl:value-of select="concat(substring-before(../@description, 'migrated -'),substring-after(../@description, 'migrated -'))"/></xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
          <!-- -->
          <!-- work with the elements within the JDBCProperties-->
        <xsl:for-each select="*">
          <xsl:choose>
            <xsl:when test="local-name(.)='factories'">
              <xsl:for-each select="*">
                <xsl:choose>
                  <xsl:when test="name()='propertySet'"> 
                    <xsl:for-each select="*">
                      <xsl:choose>
                        <xsl:when test="@name='CloudscapeOldClasspath' and not(@value=$cpath1) and not(@value=$cpath2) and not(@value=$cpath3) and not(@value=$cpath4)">
                          <xsl:variable name="cpBackup" select="@value"/>
                          <xsl:element name="classpath"><xsl:value-of select="$cpBackup"/></xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                </xsl:choose>   
              </xsl:for-each>       
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
          <!-- add the default classpath -->
        <xsl:element name="classpath"><xsl:value-of select="$cpath1"/></xsl:element>
        <xsl:element name="classpath"><xsl:value-of select="$cpath2"/></xsl:element>
        <xsl:element name="classpath"><xsl:value-of select="$cpath3"/></xsl:element>
        <xsl:element name="classpath"><xsl:value-of select="$cpath4"/></xsl:element>
          <!-- -->
          <!-- work with the elements within the JDBCProivder -->
        <xsl:for-each select="*">
          <xsl:choose>
              <!-- copies all elements except factories and configProperties -->
            <xsl:when test="not(local-name(.)='factories' or local-name(.)='classpath')">
              <xsl:call-template name="copy"/>
            </xsl:when>        
              <!-- II d 2 -->
              <!-- modify the attributes within the factories element if the description contains migrated -->
            <xsl:when test="local-name()='factories' and contains(../@description,'migrated -')">
              <!--   found factories -->
            <xsl:copy>
              <xsl:for-each select="@*">
                <xsl:choose>
                    <!-- copies all attributes but datasourceHelperClassname and description-->
                  <xsl:when test="not(local-name(.)='datasourceHelperClassname' or local-name(.)='description')">
                    <xsl:call-template name="copy"/>
                  </xsl:when>
                    <!-- II b -->
                    <!-- finds and changes the datasourceHelperClassname -->
                  <xsl:when test="local-name()='datasourceHelperClassname'">
                    <xsl:if test=".='com.ibm.websphere.rsadapter.DerbyNetworkServerDataStoreHelper'">
                      <xsl:attribute name="{name()}">com.ibm.websphere.rsadapter.CloudscapeNetworkServerDataStoreHelper</xsl:attribute>
                    </xsl:if>              
                    <xsl:if test="not(.='com.ibm.websphere.rsadapter.DerbyNetworkServerDataStoreHelper')">
                      <xsl:call-template name="copy"/>
                    </xsl:if>
                  </xsl:when>
                    <!-- II d 2 -->
                    <!-- modify the attributes within the factories element if the description contains migrated -->
                  <xsl:when test="local-name()='description'">
                    <xsl:attribute name="description"><xsl:value-of select="concat(substring-before(../@description, 'migrated -'),substring-after(../@description, 'migrated -'))"/></xsl:attribute>
                  </xsl:when> 
                </xsl:choose>
              </xsl:for-each>
              <xsl:for-each select="*">  
                <xsl:choose>
                    <!-- Copy all non-propertySet elements -->
                  <xsl:when test="not(name()='propertySet')">
                    <xsl:call-template name="copy"/>
                  </xsl:when>
                    <!-- II d 1 -->
                    <!-- Within propertySet, all elements will be copied except the elements with names databasename or CloudscapeOldDatabaseName -->
                    <!-- CloudscapeOldDatabaseName will be found and its value will be transferred to databasename's value -->
                  <xsl:when test="name()='propertySet'">
                    <xsl:copy><xsl:for-each select="@*">
                      <xsl:choose>
                        <xsl:when test="not(@name='')">
                          <xsl:call-template name="copy"/>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="*">
                      <xsl:choose>
                        <xsl:when test="not(@name='databaseName' or @name='CloudscapeOldDatabaseName' or @name='CloudscapeOldClasspath')">
                          <xsl:call-template name="copy"/>
                        </xsl:when>
                        <xsl:when test="@name='CloudscapeOldDatabaseName'">
                          <xsl:variable name="dbBackup" select="@value"/>
                          <xsl:for-each select="../*">
                            <xsl:choose>
                              <xsl:when test="@name='databaseName'">
                                <xsl:copy>
                                <xsl:for-each select="@*">
                                  <xsl:choose>
                                    <xsl:when test="not(local-name(.)='value')">
                                      <xsl:call-template name="copy"/>
                                    </xsl:when>
                                    <xsl:when test="local-name(.)='value'">
                                      <xsl:attribute name="value"><xsl:value-of select="$dbBackup"/></xsl:attribute>
                                    </xsl:when>
                                  </xsl:choose>
                                </xsl:for-each>
                                </xsl:copy>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:for-each>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each></xsl:copy>
                  </xsl:when>                  
                </xsl:choose>
              </xsl:for-each>
            </xsl:copy></xsl:when>
            <xsl:when test="local-name()='factories' and contains(../@description,'migrated')">
                <!-- removes non-migrated factories from 602 mixed cell environments -->
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:copy>
    </xsl:if>
      <!-- if provider is not migrated in a 6.0 mixed cell enviornment, remove it-->
    <xsl:if test="not(contains(@description,'migrated')) and (@implementationClassName[.='com.ibm.db2.jcc.DB2ConnectionPoolDataSource'] or @implementationClassName[.='org.apache.derby.jdbc.EmbeddedConnectionPoolDataSource'] or @implementationClassName[.='org.apache.derby.jdbc.EmbeddedXADataSource'])">
      <xsl:call-template name="copy"/>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>