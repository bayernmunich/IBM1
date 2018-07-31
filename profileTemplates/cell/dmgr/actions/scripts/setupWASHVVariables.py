#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
#  setupWASHVVariables.py - setup cell variables for WASHV product
#  - disable ARFM
#  - disable VE dashboard alerts and stability notifications
#
# @author - hee
#
#=====================================================================================================================

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
#endDef

def removeCellProperties():
     print ("Remove Cell properties")
     cell = AdminConfig.getid("/Cell:/")
     properties = convertToList(AdminConfig.showAttribute(cell,"properties"))
     for property in properties:
          name = AdminConfig.showAttribute(property,"name")
          value = AdminConfig.showAttribute(property,"value")
          if (name == "arfmManageCpu"):
              AdminConfig.remove(property)
          elif (name == "opalert.disableXDStability"):
              AdminConfig.remove(property)
          elif (name == "opalert.disableAlerts"):
              AdminConfig.remove(property)
          #endIf
     #endFor
#endDef

def createCellProperties():
     print ("Create Cell properties")
     cell = AdminConfig.getid("/Cell:/")
     AdminConfig.create("Property",cell,[["name","arfmManageCpu"],["value","false"]])
     AdminConfig.create("Property",cell,[["name","opalert.disableAlerts"],["value","true"]])
     AdminConfig.create("Property",cell,[["name","opalert.disableXDStability"],["value","true"]])
#endDef

#############################
# Begin main execution
#############################
option = ""
if (len(sys.argv) > 0):
    option = sys.argv[0]
#endIf

if (option == "-cleanup"):
    removeCellProperties()
else:
    removeCellProperties()
    createCellProperties()
#endIf

# Save off configuration
print ("Saving properties")
AdminConfig.save()
print "finished."
