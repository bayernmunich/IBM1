#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for setting up email notifications of runtime tasks
#
# author: Anil Ambati (aambati@us.ibm.com)


import sys

###################################################
# Parameters controlling execution of the script
###################################################

SCRIPT_VERSION="01/26/10"
enableNotification = "true"
smtpHost = None
smtpPort = None
smtpUserID = None
smtpPassword = None
emailAddresses = None
senderAddress = None

def mkList( x ):
   pcs = x.replace( '\r', '\n' ).split( '\n' )
   pcs = filter( lambda x: len(x) <> 0, pcs )
   return map( lambda x: x.strip(), pcs )
       
def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split("\"")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def getDmgrNodeName():
    nodes = convertToList(AdminConfig.list("Node"))
    for node in nodes:
       nodeName = AdminConfig.showAttribute(node,"name")
       serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:dmgr/")
       if (serverid != None and serverid != ""):
         return nodeName

#
#
#  Start off main() program
#
#

print "#######################################################"
print "## Email notification of runtime tasks"
print "## Version:  "
print "#######################################################"
print ""


if (len(sys.argv)>0):
   for arg in sys.argv:
       if (arg.startswith("-smtpHost:")):
           parts = arg.split(":")
           smtpHost=parts[1]
       elif (arg.startswith("-smtpPort:")):
          parts = arg.split(":")
          smtpPort=parts[1]
       elif (arg.startswith("-smtpUserID:")):
           parts = arg.split(":")
           smtpUserID=parts[1]     
       elif (arg.startswith("-smtpPassword:")):
           parts = arg.split(":")
           smtpPassword=parts[1]
       elif (arg.startswith("-enableNotifications:")):
           parts = arg.split(":")
           enableNotification=parts[1]
       elif (arg.startswith("-senderAddress:")):
           parts = arg.split(":")
           senderAddress=parts[1]
       elif (arg.startswith("-emailAddresses:")):
           parts = arg.split(":")
           emailAddresses=parts[1]
       else:
           print "unrecognized option: "+arg
           print "available options:"
           print "\t-smtpHost:<SMTP hostname>                    SMTP hostname"
           print "\t-smtpPort:<SMTP port>                        SMTP port"
           print "\t-smptUserID:<SMTP User ID>                   SMTP user ID"
           print "\t-smtpPassword:<SMTP Password>                SMTP password"
           print "\t-enableNotifications                         enable notifications when a runtime task is created"
           print "\t-senderAddress:<sender email address>        sender email address"
           print "\t-emailAddresses:<email addresses>            comma separated email addresses"
           sys.exit(1)

emailNotifications = AdminConfig.list("EmailNotifications")
cell=AdminConfig.list("Cell")
if (emailNotifications == None or emailNotifications == ""):
    emailNotifications = AdminConfig.create('EmailNotifications', cell, [])  
attributes = convertToList(AdminConfig.showall(emailNotifications))           
if (enableNotification == ""):
   enableNotification = "false"
elif (enableNotification != "false" and enableNotification != "true"):
   enableNotification = "false"
AdminConfig.modify(emailNotifications,[["enabled",enableNotification]])
if (smtpHost != None):
   AdminConfig.modify(emailNotifications,[["transportHostName",smtpHost]])
if (smtpPort != None):
   AdminConfig.modify(emailNotifications,[["port",smtpPort]])
if (smtpUserID != None):
   AdminConfig.modify(emailNotifications,[["transportUserId",smtpUserID]])
if (smtpPassword != None):
   AdminConfig.modify(emailNotifications,[["transportPassword",smtpPassword]])
if (emailAddresses != None):
   AdminConfig.modify(emailNotifications,[["emailAddresses",""]])
   emailAddresses = emailAddresses.replace(",", ";")
   AdminConfig.modify(emailNotifications,[["emailAddresses",emailAddresses]])
if (senderAddress != None):
   nodeVersion=AdminTask.getNodeBaseProductVersion("-nodeName "+getDmgrNodeName()).split(".")
   if (int(nodeVersion[0])<7):
      print "Sender address is not supported in WAS 7.0 or lower versions" 
   else:      
      properties = convertToList(AdminConfig.showAttribute(cell,"properties"))
      for property in properties:
         name = AdminConfig.showAttribute(property,"name")
         value = AdminConfig.showAttribute(property,"value")
         if (name == "task.email.global.sender.id"):
            AdminConfig.remove(property)
      AdminConfig.create("Property",cell,[["name","task.email.global.sender.id"],["value",senderAddress],["required","false"],["validationExpression",""]])
print "Saving workspace"
AdminConfig.save()
print "Done."


