#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for setting sslConfig in template
#
# author: bkmartin

import java.lang.Throwable as JavaThrowable

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def getConfigIdForTemplate(templateName):
   templates=convertToList(AdminConfig.listTemplates("Server"))
   for template in templates:
       cname = AdminConfig.showAttribute(template,"name")
       if (cname == templateName):
          return template
   return ""

def getSSLAliasForNode():
   servers=convertToList(AdminConfig.list("Server"))
   nodename=""
   for server in servers:
       try:
          stype = AdminConfig.showAttribute(server,"serverType")
       except JavaThrowable:
          stype = "UNKNOWN"
       if (stype == "DEPLOYMENT_MANAGER"):
          parts=server.split("/")
          nodename = parts[3]
          dmgr=server
          print "dmgr found on node:"+nodename
          # break here as we found the DMGR
          break 

   if (nodename == ""):
      print "using first node returned"
      nodes=convertToList(AdminConfig.list("Node"))
      if (nodes != None):
          node=nodes[0]
          parts=node.split("/")
          nodename = parts[3].split("|")[0]
      else:
          nodename = "Default"
   print "nodename: "+nodename
   return nodename+"/DefaultSSLSettings"

# d347477 use same sslConfig as dmgr's SOAP connector (JSSE) if possible

   soapConnectors=convertToList(AdminConfig.list("SOAPConnector",dmgr))
   for soapConnector in soapConnectors:
          print "Searching for dmgr soapConnector for sslConfig:"+soapConnector
          properties=convertToList(AdminConfig.list("Property",soapConnector))
          for property in properties:
              print "Checking property:"+property
              pname=AdminConfig.showAttribute(property,"name")
              print "Checking property name:"+pname
              if (pname == "sslConfig"):
                 pvalue=AdminConfig.showAttribute(property,"value")
                 print "Found sslConfig value= "+pvalue
                 return pvalue

   print "Could not find dmgr SOAPConnector"
   return nodename+"/DefaultSSLSettings"

SSLALIAS=getSSLAliasForNode()
print "modifying templates to use ssl alias: "+SSLALIAS
templates=["odr","odr_zos","proxy_server","proxy_server_zos","http_sip_odr_server","http_sip_odr_server_zos","sip_odr_server","sip_odr_server_zos"]
for template in templates:
    #print "processing template:"+template
    templateID=getConfigIdForTemplate(template)
    if (templateID != ""):
       print "processing templateID:"+templateID
       transportServices=convertToList(AdminConfig.list("TransportChannelService",templateID))
       for transportService in transportServices:
          print "processing transportservice: "+transportService
          sslChannels=convertToList(AdminConfig.list("SSLInboundChannel",transportService))
          for sslChannel in sslChannels:
               print "modifying sslchannel:"+sslChannel
               AdminConfig.modify(sslChannel,[['sslConfigAlias',SSLALIAS]])
       soapConnectors=convertToList(AdminConfig.list("SOAPConnector",templateID))
       for soapConnector in soapConnectors:
          print "processing soapConnector:"+soapConnector
          properties=convertToList(AdminConfig.list("Property",soapConnector))
          for property in properties:
              print "processing property:"+property
              pname=AdminConfig.showAttribute(property,"name")
              print "processing property name:"+pname
              if (pname == "sslConfig"):
                  AdminConfig.modify(property,[['value',SSLALIAS]])

sslChannels=convertToList(AdminConfig.listTemplates("SSLInboundChannel"))
for sslChannel in sslChannels:
   print "testing sslchannel:"+sslChannel
   try:
      ssla = AdminConfig.showAttribute(sslChannel,"sslConfigAlias")
      if (ssla != None and ssla[0] == "$"):
          print "modifying sslchannel:"+sslChannel
          AdminConfig.modify(sslChannel,[['sslConfigAlias',SSLALIAS]])
   except JavaThrowable:
      print "no alias for channel:"+sslChannel

print "saving workspace"
AdminConfig.save()
print "finished."
