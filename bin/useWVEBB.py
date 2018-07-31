#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
#  useWVEBB.py - enables WVE to use its own internal bulletin board implementation 
#
# options:
#    -disableHAM: disable ha manager on every process in the cell
#    -enableHAM: enable HAM on every process in the cell
#    -useHAMBB:  use the standard HA manager bulletin board (this also implicitly includes the -enableHAM option)
#=====================================================================================================================

disableHAM=0
enableHAM=0
enableNEWBB=1

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

def doDisableHAM(servers):
   for server in servers:
       hamserver=AdminConfig.list("HAManagerService",server)
       if (hamserver != "" and hamserver != None):
          AdminConfig.modify(hamserver,[["enable","false"]])

def doEnableHAM(servers):
   for server in servers:
       hamserver=AdminConfig.list("HAManagerService",server)
       if (hamserver != "" and hamserver != None):
           AdminConfig.modify(hamserver,[["enable","true"]])

def setBridgeCustomProperty():
   AdminConfig.create("Property",cell,[["name","xd.disable.cgb.config"],["value","true"]])

def unsetBridgeCustomProperty():
   cell=convertToList(AdminConfig.list("Cell"))[0]
   properties=convertToList(AdminConfig.showAttribute(cell,"properties"))
   for property in properties:
      propName = AdminConfig.showAttribute(property,"name")
      if (propName=="xd.disable.cgb.config"):
         AdminConfig.remove(property)

#========================================================================================
#
# Begin main
#
#========================================================================================

if (len(sys.argv)>0):
   if sys.argv[0] == "-disableHAM":
      disableHAM=1
   elif sys.argv[0] == "-enableHAM":
      enableHAM=1
   elif sys.argv[0] == "-useHAMBB":
      enableHAM=1
      enableNEWBB=0
   else:
      print "unrecognized option: ",sys.argv[0]
      sys.exit(1)

cell = AdminConfig.getid("/Cell:/")
properties = convertToList(AdminConfig.showAttribute(cell,"properties"))
for property in properties:
     name = AdminConfig.showAttribute(property,"name")
     value = AdminConfig.showAttribute(property,"value")
     if (name == "WXDBulletinBoardProviderOption"):
         AdminConfig.remove(property)

# allow auto-creation of coregroup bridges
unsetBridgeCustomProperty()

if (enableNEWBB):
   AdminConfig.create("Property",cell,[["name","WXDBulletinBoardProviderOption"],["value","WXD"]])
   # disable auto-creation of coregroup bridges (property was cleared above)
   setBridgeCustomProperty()
else:
    # disable BBSON
    AdminConfig.create("Property",cell,[["name","WXDBulletinBoardProviderOption"],["value","WAS"]])

if disableHAM>0:
   print "disabling hamanager on specified servers"
   servers=convertToList(AdminConfig.list("Server"))
   doDisableHAM(servers)
   servers=convertToList(AdminConfig.listTemplates("Server"))
   doDisableHAM(servers)

if enableHAM>0:
   print "enabling hamanager on all servers"
   servers=convertToList(AdminConfig.list("Server"))
   doEnableHAM(servers)
   servers=convertToList(AdminConfig.listTemplates("Server"))
   doEnableHAM(servers)

AdminConfig.save()
print "finished."
