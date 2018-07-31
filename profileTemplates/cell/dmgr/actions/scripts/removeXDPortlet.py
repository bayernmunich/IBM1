#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# removeXDPortlet - removes the XD Portlet from the ISC
#
# author - viarsb


print "Attempting to remove the XD Portlet"

app = AdminConfig.getid('/Deployment:isclite/')
if app == "":
 print "Not removing - This is not the dmgr"
else:
 AdminApp.update('isclite', 'modulefile', '[-operation delete -contenturi xdportlet.war]')
 
print "saving workspace..."
AdminConfig.save()