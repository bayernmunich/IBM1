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

  <!-- Remove "WebSphere MQ Resource Adapter - builtin" RA -->
  <xsl:template match="resources.j2c:J2CResourceAdapter">
    <xsl:if test="not(starts-with(@description, 'WAS ') and contains(@description, ' Built In WebSphere MQ Resource Adapter'))">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove failingMessageDelay from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='failingMessageDelay']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='failingMessageDelay']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove autoStopSequentialMessageFailure from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='autoStopSequentialMessageFailure']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='autoStopSequentialMessageFailure']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- Remove AutoStopSequentialMessageFailure from activationSpecs (deliberate case-change from above entry) -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='AutoStopSequentialMessageFailure']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='AutoStopSequentialMessageFailure']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>   

  <!-- Remove providerEndpoints from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='providerEndpoints']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='providerEndpoints']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove alwaysActivateAllMDBs from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='alwaysActivateAllMDBs']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='alwaysActivateAllMDBs']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove retryInterval from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='retryInterval']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='retryInterval']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove ForwarderDoesNotModifyPayloadAfterSet from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='ForwarderDoesNotModifyPayloadAfterSet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='ForwarderDoesNotModifyPayloadAfterSet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove ConsumerDoesNotModifyPayloadAfterGet from activationSpecs -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/activationSpecTemplateProps/resourceProperties[@name='ConsumerDoesNotModifyPayloadAfterGet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cActivationSpec/resourceProperties[@name='ConsumerDoesNotModifyPayloadAfterGet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove ConsumerDoesNotModifyPayloadAfterGet from factories -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/factories/propertySet/resourceProperties[@name='ConsumerDoesNotModifyPayloadAfterGet']">
    <xsl:if test="not(../../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/resourceAdapter/outboundResourceAdapter/connectionDefinitions/configProperties[@name='ConsumerDoesNotModifyPayloadAfterGet']">
    <xsl:if test="not(../../../../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/connectionDefTemplateProps/resourceProperties[@name='ConsumerDoesNotModifyPayloadAfterGet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove ProducerDoesNotModifyPayloadAfterSet from factories -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/factories/propertySet/resourceProperties[@name='ProducerDoesNotModifyPayloadAfterSet']">
    <xsl:if test="not(../../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/deploymentDescriptor/resourceAdapter/outboundResourceAdapter/connectionDefinitions/configProperties[@name='ProducerDoesNotModifyPayloadAfterSet']">
    <xsl:if test="not(../../../../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/connectionDefTemplateProps/resourceProperties[@name='ProducerDoesNotModifyPayloadAfterSet']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>

  <!-- Remove new v7 MQ JMS messaging provider attributes -->
  <xsl:template match="resources.jms:JMSProvider/factories/@compressHeaders">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@compressPayload">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@providerVersion">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@wildcardFormat">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sslType">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sslConfiguration">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@tempTopicPrefix">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@replyWithRFH2">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@maxBatchSize">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@secExit">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@secExitInitData">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sendExit">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sendExitInitData">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@rcvExit">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@rcvExitInitData">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sslResetCount">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@brokerPubQueue">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider') or not(../@xmi:type = 'resources.jms.mqseries:MQTopic')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@brokerPubQmgr">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider') or not(../@xmi:type = 'resources.jms.mqseries:MQTopic')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@brokerVersion">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider') or not(../@xmi:type = 'resources.jms.mqseries:MQTopic')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@wmqServerName">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@wmqServerEndpoint">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@wmqServerSvrconnChannel">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@ccdtUrl">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@qmgrType">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@sendAsync">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@readAhead">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@readAheadClose">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.jms:JMSProvider/factories/@transportType[.='BINDINGS_THEN_CLIENT']">
    <xsl:attribute name="transportType">CLIENT</xsl:attribute>
  </xsl:template>


  <!-- Remove v7 JMS Queue properties -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cAdminObjects/properties[@name='scopeToLocalQP']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cAdminObjects/properties[@name='producerBind']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cAdminObjects/properties[@name='producerPreferLocal']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/j2cAdminObjects/properties[@name='gatherMessages']">
    <xsl:if test="not(../../@name='SIB JMS Resource Adapter')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove com.ibm.ejs.jms.disableWMQSupport from WMQ messaging provider property set for. Only set at WAS 8 and onwards. -->
  <xsl:template match="resources.jms:JMSProvider/propertySet/resourceProperties[@name='com.ibm.ejs.jms.disableWMQSupport']">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- 
  	Remove WMQ connection name list support which was added as a first class property in WAS 8. Note that this only removes the 
  	WAS property for connection list support. It is still possible to use custom properties to set this up. 
  -->
  <xsl:template match="resources.jms:JMSProvider/factories/@connameList">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  
  <!-- 
  	Remove clientReconnectOptions which was added in WAS 8. 
  -->
  <xsl:template match="resources.jms:JMSProvider/factories/@clientReconnectOptions">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
 
  <!-- 
  	Remove clientReconnectTimeout which was added in WAS 8. 
  --> 
  <xsl:template match="resources.jms:JMSProvider/factories/@clientReconnectTimeout">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- 
  	Remove inheritRRSContext which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@inheritRRSContext">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- 
  	Remove mqmdReadEnabled which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@mqmdReadEnabled">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- 
  	Remove mqmdWriteEnabled which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@mqmdWriteEnabled">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template> 
  
  <!-- 
  	Remove mqmdMessageContext which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@mqmdMessageContext">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- 
  	Remove messageBody which was added in WAS 8. 
  -->    
  <xsl:template match="resources.jms:JMSProvider/factories/@messageBody">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- 
  	Remove receiveCCSID which was added in WAS 8. 
  -->   
  <xsl:template match="resources.jms:JMSProvider/factories/@receiveCCSID">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template> 
  
  <!-- 
  	Remove wmqTopicName which was added in WAS 8. 
  -->   
  <xsl:template match="resources.jms:JMSProvider/factories/@wmqTopicName">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template> 
  
  <!-- 
  	Remove receiveConvert which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@receiveConvert">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template> 
  
  <!-- 
  	Remove replyToStyle which was added in WAS 8. 
  -->  
  <xsl:template match="resources.jms:JMSProvider/factories/@replyToStyle">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template> 
  
  <!-- Remove com.ibm.ejs.jms.enableWMQ71RAPropsBehaviour from WMQ messaging provider property set. Only set at WAS 8 and onwards. -->
  <xsl:template match="resources.jms:JMSProvider/propertySet/resourceProperties[@name='com.ibm.ejs.jms.enableWMQ71RAPropsBehaviour']">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Remove com.ibm.ejs.jms.wmqSupportDisabledSomewhereInCell from WMQ messaging provider property set. Only set at WAS 8 and onwards. -->
  <xsl:template match="resources.jms:JMSProvider/propertySet/resourceProperties[@name='com.ibm.ejs.jms.wmqSupportDisabledSomewhereInCell']">
    <xsl:if test="not(../../@name='WebSphere MQ JMS Provider')">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  
  <!-- Convert persistence of HIGH to PERSISTENT-->
  <xsl:template match="resources.jms:JMSProvider/factories/@persistence[.='HIGH']">
    <xsl:choose>
      <xsl:when test="not(../../@name='WebSphere MQ JMS Provider')">
        <xsl:call-template name="copy"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="persistence">PERSISTENT</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
</xsl:stylesheet>

