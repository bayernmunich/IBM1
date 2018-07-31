#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# installXDPortlet - installs the XD Portlet into the ISC
#
# author - viarsb


while sys.argv:
    if sys.argv[0] == '-washome':
        # retrieve WAS home directory
        print sys.argv[1]
        pathToXDPortlet = sys.argv[1] + "/systemApps/isclite.ear/xdportlet.war"
        sys.argv = sys.argv[2:]

print "Updating the ISCLite Module"

print "XDPortlet reported to be in: " + pathToXDPortlet
# add xd portlet....
AdminApp.update('isclite', 'modulefile', '[-operation delete -contents ' + pathToXDPortlet + ' -contenturi xdportlet.war]')
AdminApp.update('isclite', 'modulefile', '[-operation add -contents ' + pathToXDPortlet + ' -contenturi xdportlet.war -custom -usedefaultbindings -contextroot /xdportlet -server dmgr -MapWebModToVH [[.* .* admin_host]]]')

#AdminApp.update('isclite', 'modulefile', '[-operation add -contents ' + pathToXDPortlet + ' -contenturi xdportlet.war -custom -usedefaultbindings -contextroot /xdportlet -server dmgr -MapWebModToVH [[.* .* admin_host]]]')

print "saving workspace..."
AdminConfig.save()