<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:dynacache="http://www.ibm.com/websphere/appserver/schemas/5.0.2/dynacache.xmi"
  xmlns:AdminHelper="com.ibm.ws.management.AdminHelper"
  xmlns:PlatformHelper="com.ibm.ws.util.PlatformHelper">

<xsl:import href="copy.xsl"/>

<!-- Remove the elements and attributes related to disk cache size in the factories element -->
<xsl:template match="dynacache:CacheProvider/factories/@diskCachePerformanceLevel"/>
<xsl:template match="dynacache:CacheProvider/factories/@diskCacheSizeInGB"/>
<xsl:template match="dynacache:CacheProvider/factories/@diskCacheSizeInEntries"/>
<xsl:template match="dynacache:CacheProvider/factories/@diskCacheEntrySizeInMB"/>
<xsl:template match="dynacache:CacheProvider/factories/@diskCacheCleanupFrequency"/>
<xsl:template match="dynacache:CacheProvider/factories/diskCacheCustomPerformanceSettings"/>
<xsl:template match="dynacache:CacheProvider/factories/diskCacheEvictionPolicy"/>

<!-- Remove the elements and attributes related to memoryCacheSizeInMB in the factories element -->
<xsl:template match="dynacache:CacheProvider/factories/@memoryCacheSizeInMB"/>
<xsl:template match="dynacache:CacheProvider/factories/memoryCacheEvictionPolicy"/>

</xsl:stylesheet>
