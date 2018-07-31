#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for deleting XD default template
#
# author: bkmartin

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

print "searching for templates"
templates=convertToList(AdminConfig.listTemplates("Server"))
for template in templates:
    cname = AdminConfig.showAttribute(template,"name")
    if (cname != None):
       print "found: "+cname
    if (cname == "defaultXD" or cname == "defaultXDZOS"):
       print "deleting template: "+template
       AdminTask.makeNonSystemTemplate("-templateName "+cname+" -serverType APPLICATION_SERVER")
       AdminTask.deleteServerTemplate(template)

print "saving workspace"
AdminConfig.save()
print "finished."
