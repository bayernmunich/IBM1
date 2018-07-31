import sys, java
           
truststore="CellDefaultTrustStore"
keystore="CellDefaultKeyStore"

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

try:
   foundXDAAlias = 0
   cell=AdminConfig.list("Cell")
   cellName=AdminConfig.showAttribute(cell,"name")
   aliases = convertToList(AdminTask.listSSLConfigs('[-all true ]'))
   for alias in aliases:
     parts = alias.split(" ")
     for part in parts:
       if (part == "XDADefaultSSLSettings"):
          foundXDAAlias=1
   if (foundXDAAlias == 0):
     cellScope = "(cell):" + cellName
     print "Adding  XDADefaultSSLSettings at cell scope:" + cellScope
     
     AdminTask.createSSLConfig(["-alias","XDADefaultSSLSettings","-clientAuthentication","true","-clientAuthenticationSupported","true","-trustStoreName",truststore,"-trustStoreScopeName",cellScope,"-keyStoreName",keystore,"-keyStoreScopeName",cellScope,"-scopeName",cellScope])
     AdminConfig.save();
except java.lang.Exception, e:
   print "Error adding XDADefaultSSLSettings: it may be duplicate"
   print e
