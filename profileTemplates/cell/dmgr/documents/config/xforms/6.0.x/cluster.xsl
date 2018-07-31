<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmi="http://www.omg.org/XMI"
  xmlns:topology.cluster="http://www.ibm.com/websphere/appserver/schemas/5.0/topology.cluster.xmi" >

<xsl:import href="copy.xsl"/>

<xsl:template match="topology.cluster:ServerCluster/@jsfProvider"/>
<xsl:template match="topology.cluster:ServerCluster/@clusterAddress"/>
<xsl:template match="topology.cluster:ServerCluster/@prefetchDWLMTable"/>
</xsl:stylesheet>
