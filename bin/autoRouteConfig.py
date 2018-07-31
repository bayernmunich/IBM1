###############################################################################
# "This program may be used, executed, copied, modified and distributed without
# royalty for the purpose of developing, using, marketing, or distributing."
#
# Product 5630-A36 (C) COPYRIGHT International Business Machines Corp., 2006, 2007
# All Rights Reserved * Licensed Materials - Property of IBM
###############################################################################
#******************************************************************************
# File Name: autoRouteConfig.py
# Description: Automatically configure routing for a topology in which
#              a web server is routing to ODRs.  This configures the trusted
#              proxies for the ODR, and attempts to configure plugin-cfg.xml
#              auto-generation.
#
#
# Author:
#
# History:
#
#******************************************************************************	
#
# List of Procedures:
#******************************************************************************
# convertToList
# getWebServers
#
#--------------------------------------------------------------------

from java.net import InetAddress
import sys
import os

global webServerList, odrList
webServerList = []
odrList = []

#
# Stolen from some other random augmentation script, this makes a list from
# the sort of thing that AdminConfig.list() and so on return.
#

class Server:
   def __init__(self, node, server, host):
      self.node = node
      self.server = server
      self.host = host
      ia = InetAddress.getByName(host)
      if (ia != None):
         self.host = ia.getCanonicalHostName()
         self.ipAddr = ia.getHostAddress()
         self.trustedProxy = self.ipAddr
      else:
         self.ipAddr = None
         self.trustedProxy = host

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split(lineSeparator)
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist
#endDef

def setCellCustomProperty(propName,propValue):
   cell = AdminConfig.getid("/Cell:/")
   properties = convertToList(AdminConfig.showAttribute(cell,"properties"))
   oldValue = None
   for property in properties:
     name = AdminConfig.showAttribute(property,"name")
     value = AdminConfig.showAttribute(property,"value")
     if (name == propName):
        if (value == propValue):
            print "   Cell custom property '"+propName+"' already set to '"+propValue+"'"
            return
        AdminConfig.remove(property)
        oldValue = value
   AdminConfig.create("Property",cell,[["name",propName],["value",propValue]])
   if (oldValue != None):
      print "   Cell custom property '"+propName+"' changed from '"+oldValue+"' to '"+propValue+"'"
   else:
      print "   Cell custom property '"+propName+"' set to '"+propValue+"'"

#
# Process server info, populating  the web server information
#
def processServerInfo():
   nodes = convertToList(AdminConfig.list("Node"))
   for node in nodes:
      serverIndexes = convertToList(AdminConfig.list("ServerIndex",node))
      for serverIndex in serverIndexes:
           hostName = AdminConfig.showAttribute(serverIndex,"hostName")
           break
      #endFor
      serverEntries = convertToList(AdminConfig.list("ServerEntry",node))
      for serverEntry in serverEntries:
         nodeName = AdminConfig.showAttribute(node,"name")
         serverName = AdminConfig.showAttribute(serverEntry,"serverName")
         stype = AdminConfig.showAttribute(serverEntry,"serverType")
         if (stype=="WEB_SERVER"):
            webServerList.append(Server(nodeName,serverName,hostName))
         elif (stype=="ONDEMAND_ROUTER"):
            odrList.append(Server(nodeName,serverName,hostName))
         #endIf
      #endFor
   #endFor
#endDef

def getTrustedProxies(webServerList):
   trustedProxies = ""
   for ws in webServerList:
      if (len(trustedProxies) > 0):
         trustedProxies += " "
      trustedProxies += ws.trustedProxy
   return trustedProxies
#endDef

def configureTrustedProxiesForOdrs():
   print "Configuring trusted security proxies for ODRs ..."
   trustedProxies = getTrustedProxies(webServerList)
   for odr in odrList:
      proxy_settings_id = AdminConfig.getid( '/Node:%s/Server:%s/ProxySettings:/' % ( odr.node, odr.server ) )
      AdminConfig.modify(proxy_settings_id, [['trustedIntermediaryAddresses',trustedProxies]])
      print "   The trusted security proxies for ODR '"+odr.node+"/"+odr.server+"' was set to '"+trustedProxies+"'"
#endDef

def configurePluginConfigGeneration():
   print "Configuring auto plugin-cfg.xml generation ..."
   setCellCustomProperty("ODCPluginCfgDisable_default","false");
   setCellCustomProperty("ODCPluginCfgOdrList_default","*:*:*");
   setCellCustomProperty("ODCPluginCfgOutputPath_default","/tmp/plugin-cfg.xml");
   setCellCustomProperty("ODCPluginCfgUpdateScript_default","autoPropagate *:*:*");
#endDef

processServerInfo()
configureTrustedProxiesForOdrs()
configurePluginConfigGeneration()
AdminConfig.save()
print "Done"
