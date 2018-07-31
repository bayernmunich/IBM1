#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# installXDPortlet - installs the XD Portlet into the ISC
#
# author - viarsb

import os

while sys.argv:
    if sys.argv[0] == '-washome':
        # retrieve WAS home directory
        print sys.argv[1]
        pathToXDPortlet = sys.argv[1] + "/systemApps/isclite.ear/xdportlet.war"
        sys.argv = sys.argv[2:]

print "WAS_HOME="+pathToXDPortlet

print "Updating the ISCLite Module"

print "XDPortlet reported to be in: " + pathToXDPortlet

serv = AdminConfig.getid('/Server:dmgr/')
changed = 0
print "The DMGR config id is: " + serv
if serv != "":
    modulesList = AdminApp.listModules('isclite').split(java.lang.System.getProperty("line.separator"))
    changed = 1
    for modules in modulesList:
        print "modules contain in isclite: " + modules
        if (modules == "isclite#xdportlet.war+WEB-INF/web.xml"):
             changed = 0
             print "xdportlet.war is contained in isclite.ear"

    if (changed == 1):
        AdminApp.update('isclite', 'modulefile', '[-operation add -contents \'' + pathToXDPortlet + '\' -contenturi xdportlet.war -custom -usedefaultbindings -contextroot /xdportlet -server dmgr -MapWebModToVH [[.* .* admin_host]]]')


#save
if (changed == 1):
   print "saving workspace"
   AdminConfig.save()
