#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# installPVSConsole - installs the private virtual server console application
#
# @author - lvuong
# Change History
# --------------
# 05-03-2006 initial version created
#=======================================================================================================================================================

while sys.argv:
    if sys.argv[0] == '-washome':
        # retrieve WAS home directory
        print sys.argv[1]
        pathToPVSConsole = sys.argv[1] + "/installableApps/php.pvsconsole.war"
        sys.argv = sys.argv[2:]

dmgr = AdminConfig.getid('/Server:dmgr')
beginIdx = dmgr.find('/nodes/')
beginIdx = beginIdx + 7
endIdx = dmgr.find('/servers/')
node = dmgr[beginIdx:endIdx]

AdminApp.install(pathToPVSConsole, "-node " + node + " -server dmgr -contextroot /pvs -MapWebModToVH [['pvs' php.pvsconsole.war,WEB-INF/web.xml admin_host]]")
AdminConfig.save()