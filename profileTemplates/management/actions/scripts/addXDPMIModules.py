#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# addXDPMIModules
#
from java.lang import System

def findPMIModuleByName(pmiModuleName, pmiModules):
    for pmiModule in pmiModules:
        name=AdminConfig.showAttribute(pmiModule,"moduleName")
        if (name == pmiModuleName):
            return pmiModule
    return ""

def updatePMIModules(serverPMIModule):
    pmiModules = AdminConfig.showAttribute(serverPMIModule, "pmimodules").replace("[","").replace("]","")
    if pmiModules <> "":
        pmiModules = pmiModules.split(" ")

        if (findPMIModuleByName("xdProcessModule", pmiModules) == ""):
            attributes2 = [ ["moduleName", "xdProcessModule"],
                            ["type", "com.ibm.ws.xd.pmi.xml.processModule"],
                            ["enable", ""],
                            ["pmimodules", [] ] ]
            AdminConfig.create("PMIModule", serverPMIModule, attributes2)
        else:
            print "xdProcessModule PMIModule already exists"

    return


def addXDPMIModules():
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
                            updatePMIModules(pmiModule)
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
               updatePMIModules(template)

    print "AdminConfig.save()"
    AdminConfig.save()
    print "finished."
    return

#
#  main() -
#

print "*********************************"
print "Add XD PMI Modules               "
print "*********************************"
addXDPMIModules()
