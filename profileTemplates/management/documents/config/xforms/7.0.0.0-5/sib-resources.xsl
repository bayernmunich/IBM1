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

  <!-- Remove com.ibm.ejs.jms.disableWMQSupport from WMQ messaging provider property set. -->
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
  
  <!-- If we find a WMQ resource adapter which is built in and is not the one we would expect at this level then convert it to the one we expect. -->
  <!-- Note that we choose the 7.0 resource adapter over the 7.0.0.1 as it will work at all versions whereas the 7.0.0.1 only works from WAS 7.0.0.1 onwards. -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/@description">
	<xsl:choose>
	  <xsl:when test="starts-with(., 'WAS ') and contains(., ' Built In WebSphere MQ Resource Adapter') and not(.='WAS 7.0.0.1 Built In WebSphere MQ Resource Adapter' or .='WAS 7.0 Built In WebSphere MQ Resource Adapter')">
        <xsl:attribute name="description">WAS 7.0 Built In WebSphere MQ Resource Adapter</xsl:attribute>
 	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="copy"/>
	  </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Remove startupReconnectionRetryCount and startupReconnectionRetryInterval from the WMQ resource adapter. -->
  <xsl:template match="resources.j2c:J2CResourceAdapter/propertySet/resourceProperties[@name='startupReconnectionRetryCount']">
    <xsl:if test="not(starts-with(../../@description, 'WAS ') and contains(../../@description, ' Built In WebSphere MQ Resource Adapter'))">
      <xsl:call-template name="copy"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="resources.j2c:J2CResourceAdapter/propertySet/resourceProperties[@name='startupReconnectionRetryInterval']">
    <xsl:if test="not(starts-with(../../@description, 'WAS ') and contains(../../@description, ' Built In WebSphere MQ Resource Adapter'))">
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
</xsl:stylesheet>

