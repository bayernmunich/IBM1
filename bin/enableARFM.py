#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.
#
#  disableARFM.py - disable ARFM
#
# @author - brian.k.martin 
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

cell = AdminConfig.getid("/Cell:/")
properties = convertToList(AdminConfig.showAttribute(cell,"properties"))
for property in properties:
     name = AdminConfig.showAttribute(property,"name")
     value = AdminConfig.showAttribute(property,"value")
     if (name == "arfmManageCpu"):
         AdminConfig.remove(property)
AdminConfig.create("Property",cell,[["name","arfmManageCpu"],["value","true"]])
AdminConfig.save()
print "finished."
