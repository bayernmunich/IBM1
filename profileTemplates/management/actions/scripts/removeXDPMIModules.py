#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# removeXDPMIModules
#
from java.lang import System
from jarray import array

def removePMIModules(serverPMIModule):
    count = 0
    pmiModules = AdminConfig.showAttribute(serverPMIModule, "pmimodules").replace("[","").replace("]","")
    if pmiModules <> "":
        pmiModules = pmiModules.split(" ")

        for pmiModule in pmiModules:
            name = AdminConfig.showAttribute(pmiModule, "moduleName")
            if (name == "xdProcessModule"):
                count = count + 1
                AdminConfig.remove(pmiModule)
    if (count < 1):
       print "One or more XD PMIModules were not found"
    return


def removeXDPMIModules():
    servers = AdminConfig.list("Server")
    if (servers <> ""):

        if System.getProperty("os.name").startswith("Windows"):
            servers = servers.split("\r\n")
        else:
            servers = servers.split("\n")

        for server in servers:
            serverType = AdminConfig.showAttribute(server, "serverType")
            if (serverType == "APPLICATION_SERVER"):
                pmiModules = AdminConfig.list("PMIModule", server)
                if (pmiModules <> ""):
                    if System.getProperty("os.name").startswith("Windows"):
                        pmiModules = pmiModules.split("\r\n")
                    else:
                        pmiModules = pmiModules.split("\n")
                    for pmiModule in pmiModules:
                        name = AdminConfig.showAttribute(pmiModule, "moduleName")
                        if (name == "pmi"):
                            print "updating " + pmiModule
                            removePMIModules(pmiModule)

    print "Updating server templates"
    templates = AdminConfig.listTemplates("PMIModule", "APPLICATION_SERVER")
    if (templates <> ""):
       if System.getProperty("os.name").startswith("Windows"):
           templates = templates.split("\r\n")
       else:
           templates = templates.split("\n")
       for template in templates:
           name = AdminConfig.showAttribute(template, "moduleName")
           if (name == "pmi"):
               print "updating " + template
               removePMIModules(template)

    print "AdminConfig.save()"
    AdminConfig.save()
    print "finished."
    return

#
#  main() -
#

print "*********************************"
print "Remove XD PMI Modules               "
print "*********************************"
removeXDPMIModules()
