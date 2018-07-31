# ****************************************************************************
# Licensed Materials - Property of IBM
#
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 Copyright IBM Corp. 2010
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# ****************************************************************************
#
# Application Console to display information about Application Bundles, Service and Packages
#
import sys
import AdminUtilities 
from types import *
import jreload
import re
import org
import string
import jarray
       
# Create a resource bundle to access the translated messages that the python script uses.
resourceBundleName = "com.ibm.ws.eba.admin.messages.EBAADMINMessages"
resourceBundle = AdminUtilities.getResourceBundle(resourceBundleName)

# An ObjectName object that maps to the FrameworkMBean
frameworkMBean = None
# An ObjectName object that maps to the BundleStateMBean
bundleStateMBean = None
# An ObjectName object that maps to the PackageStateMBean
packageStateMBean = None
# An ObjectName object that maps to the ServiceStateMBean
serviceStateMBean = None

# The Array of Bundle objects for this Framework
bundleData = []
serviceData = []
packageData = []


# This method returns a short status of the bundle states in the current framework.
def ss():
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            print "ID      State       Bundle"
            # Iterate over the bundles in the bundleData and display information about each one.
            for bundle in bundleData:
                # Get the state of the bundle. If it is in starting change the display state to be <<LAZY>>
                state = bundle.get("State")
                if state == "STARTING":
                    state = "<<LAZY>>"
    
                # Print the main bundle information
                print string.ljust(str(bundle.get("Identifier")),4) + "    " + string.ljust(str(state), 8) + "    " + \
                    str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle))
    
                # Now find any other bundles that are fragments attached to this bundle.
                fragmentString = ""
                # Iterate over the fragments, and get the bundle IDs. Create a comma separated list of each ID.
                for fragment in bundle.get("Fragments"):
                    if fragmentString != "":
                        fragmentString += ","
                    fragmentString += str(fragment)
    
                # If we have one or more fragments, then display this info.
                if fragmentString != "":
                    print string.ljust(" ", 20) + "Fragments=" + fragmentString 
    
                # If this bundle is a fragment then we need to check which bundle is the master bundle
                if bundle.get("Fragment"):
                    fragmentHosts = ""
                    # Iterate over the master bundle IDs, and create a comma separated list.
                    for fragmentHostID in bundle.get("Hosts"):
                        if fragmentHosts != "":
                            fragmentHosts += ","
                        fragmentHosts += str(fragmentHostID)
    
                    # If there are master bundle IDs, then print this info out.
                    if fragmentHosts != "":
                        print string.ljust(" ", 20) + "Master=" + fragmentHosts
    else:
        displayNLSMessage("EBAADMIN0026E")


# This method returns a comprehensive display of each of the bundles in the framework. 
def bundles():
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            for bundle in bundleData:
                displayBundle(bundle)
    else:
        displayNLSMessage("EBAADMIN0026E")


# This method returns a comprehensive display of a particular bundle in the framework.
def bundle(bundleID): 
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            # Get the bundle with the specified bundle ID.
            bundle = getBundle(bundleID)
            if bundle == None:
                displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
            else:
                displayBundle(bundle)
                # We now need to add the extra info about the bundle that you don't get on the bundles command.
                # Display all exported packages
                exportedPackages = bundle.get("ExportedPackages")
                if len(exportedPackages) == 0:
                    print "  No exported packages"
                else: 
                    print "  Exported Packages"
                    # Iterate over the exported packages. Split the string <packageName>;<version>, and format the display
                    for package in exportedPackages:
                        pkgSplit = package.split(";")
                        print '    ' + str(pkgSplit[0]) + '; version="' + str(pkgSplit[1]) + '"[exported]'
        
                # Now display all imported packages
                importedPackages = bundle.get("ImportedPackages")
                if len(importedPackages) == 0:
                    print "  No imported packages"
                else: 
                    print "  Imported Packages"
                    # Iterate over the imported packages. Split the string <packageName>;<version>, and format the display
                    for package in importedPackages:
                        pkgSplit = package.split(";")
                        # Find the bundle that has exported the package
                        
                        exportingBundleIDs = AdminControl.invoke_jmx(packageStateMBean, "getExportingBundles", [str(pkgSplit[0]), str(pkgSplit[1])], 
                                                   ['java.lang.String','java.lang.String'])

                        exportingBundleID = -1

                        for bid in exportingBundleIDs:
                            importingBundleIds = AdminControl.invoke_jmx(packageStateMBean, "getImportingBundles", [str(pkgSplit[0]), str(pkgSplit[1]), int(bid)], 
                                                   ['java.lang.String','java.lang.String', 'long'])

                            for importingBundle in importingBundleIds:
                                if importingBundle == bundleID:
                                    exportingBundleID = bid

                        exportingBundle = getBundle(exportingBundleID)

                        bundleDisplay = "Unknown"
                        # If we have an exporting bundle then build up the exporting bundle information
                        if exportingBundle != None:
                            bundleDisplay = "<" + str(getSymbolicName(exportingBundle)) + "_" + str(getVersion(exportingBundle)) + " [" + \
                              str(exportingBundleID) + "]>"
    
                        # Finally display the exporting packge info.
                        print '    ' + str(pkgSplit[0]) + '; version="' + str(pkgSplit[1]) + '"' + bundleDisplay
        
                # Now display any fragment bundles
                fragments = bundle.get("Fragments")
                # Issue no fragments display if array is empty
                if len(fragments) == 0:
                    print "  No fragment bundles"
                else:
                    print "  Fragment bundles"
                    # Iterate over the fragment bundles. Format the display of the master bundle
                    for fragment in fragments:
                        fragmentBundle = getBundle(fragment)
                        if fragmentBundle != None:
                            print "    " + str(getSymbolicName(fragmentBundle)) + "_" + str(getVersion(fragmentBundle)) + " [" + str(fragmentBundle.get("Identifier")) + "]"
    
                # Now display any host bundles
                hosts = bundle.get("Hosts")
                # Issue no hosts display if array is empty
                if len(hosts) == 0:
                    print "  No host bundles"
                else:
                    print "  Host bundles"
                    # Iterate over the host bundles. Format the display of the master bundle
                    for host in hosts:
                        hostBundle = getBundle(host)
                        if hostBundle != None:
                            print "    " + str(getSymbolicName(hostBundle)) + "_" + str(getVersion(hostBundle)) + " [" + str(hostBundle.get("Identifier")) + "]"
    
                # Now get the Name Class Space info. Fragment bundles do not have a class space.
                if bundle.get("Fragment"):
                    print "  Named class space"
                    print "    " + str(getSymbolicName(hostBundle)) + '; bundle-version="' + str(getVersion(hostBundle)) + '"[provided]'
                else:
                    print "  No named class spaces"
    
                # Finally display the Required Bundles
                requiredBundles = bundle.get("RequiredBundles")
                # Issue no fragments display if array is empty
                if len(requiredBundles) == 0:
                    print "  No required bundles"
                else:
                    print "  Required bundles"
                    # Iterate over the required bundles. Format the display of each bundle
                    for requiredBundleID in requiredBundles:
                        requiredBundle = getBundle(requiredBundleID)
                        if requiredBundle != None:
                            print "    " + str(getSymbolicName(requiredBundle)) + "_" + str(getVersion(requiredBundle)) + " [" + str(requiredBundleID) + "]"
    else:
        displayNLSMessage("EBAADMIN0026E")       


# This method is the method that actually gathers and displays the bundle information for individual bundle and from a bundles command. 
def displayBundle(bundle):
    # Get the identifier for the bundle
    identifier = str(bundle.get("Identifier"))
    # Print the initial display for the bundle.
    print str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle)) + " [" + identifier + "]"
    print "  Id=" + identifier + ", Status=" + bundle.get("State") + "  Location=" + bundle.get("Location")
    # Get the services registered by this bundle. Display these if we have any.
    registeredServices = bundle.get("RegisteredServices")
    # Display the no registered services if the array is empty
    if len(registeredServices) == 0:
        print "  No registered services."
    else:
        # Iterate over the registeredservices and display the service data for each service ID
        print "  Registered Services"
        for serviceID in registeredServices:
            service = getService(serviceID)
            if service != None:
                print "    " + getServiceInfo(service)


    # Now display any services that this bundle is using.
    servicesInUse = bundle.get("ServicesInUse")
    # Display the no services in use if the array is empty
    if len(servicesInUse) == 0:
        print "  No services in use."
    else:
        # Iterate over the services in use and display the service data for each service ID
        print "  Services in use:"
        for serviceID in servicesInUse: 
            service = getService(serviceID)
            if service != None:
                print "    " + getServiceInfo(service)  


# This method displays the services registered in the framework or filtered by the supplied OSGi filter
def services(osgiFilter=None):
    if serviceStateMBean != None:
        if isMBeanAvailable(serviceStateMBean):
            # If no filter has been supplied, then display all services
            if osgiFilter == None:
                for service in serviceData:
                    displayService(service)
            # If there has been a argument passed, check to see if it is a service ID. If so then
            # display the service that has the identifier
            elif getService(osgiFilter) != None:
                service = getService(osgiFilter)
                displayService(service)
            # If we have an argument and it isn;t a service ID, we assume it is an OSGi filter. Create a filter using the
            # FrameworkUtil class.
            else:
                serviceFilter = org.osgi.framework.FrameworkUtil.createFilter(osgiFilter)
                matchingServices = []
                # Iterate over the services and put all the properties for each service into a HashTable.
                # Then pass these properties into the filter and see if we've got a match.
                # If so, then save the service in an array which we'll use to display the services once we've parsed the serviceData
                for service in serviceData:
                    # Create the hashtable and load the service properties.
                    props = java.util.Hashtable()
                    serviceProps = AdminControl.invoke_jmx(serviceStateMBean, "getProperties", [int(service.get("Identifier"))], ['long'])
                    for property in serviceProps.values():
                        # Get the key and value for the current property.
                        key = str(property.get("Key"))
                        value = str(property.get("Value"))
                        # If we have the objectClass property we need to add the interfaces to a 
                        # String array in order for the service filter to work.
                        if key == "objectClass" and value.find(",") != -1:
                            interfaces = []
                            for interface in value.split(","):
                                interfaces.append(interface)

                            # We need to use a jarray in order to force the interfaces into a String[]
                            value = jarray.array(interfaces, java.lang.String);

                        # Add the property to the hashtable.
                        props.put(key, value)
    
                    # Load the hashtable into the filter and see if we have a match.
                    if serviceFilter.matchCase(props):
                        matchingServices.append(service)
    
                # Finally check to see if we have any matches. If not, issue warning message. If we do then iterate over the
                # matches and call the service display.
                if len(matchingServices) == 0:
                    print "No matching services"
                else:
                    for matchingService in matchingServices:
                        displayService(matchingService)

    else:
        displayNLSMessage("EBAADMIN0027E")


# This method prints the information about the specified service object.
def displayService(service):

    # Print the service interface names and service properties
    print getServiceInfo(service)

    # Print the information about which bundle has registered the service
    bundleID = service.get("BundleIdentifier")
    bundle = getBundle(bundleID)
    if bundle != None:
        print "  Registered by bundle: " + str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle)) + " [" + str(bundleID) + "]"

    # Proces the bundles that are using this service.
    usingBundles = service.get("UsingBundles")
    if len(usingBundles) == 0:
        print "  No bundles using service."
    else:
        print "  Bundles using service:"
        for usingBundle in usingBundles:
            bundle = getBundle(usingBundle)
            if bundle != None:
                print "    " + str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle)) + " [" + str(bundle.get("Identifier")) + "]"


# This method builds up the service display, with the interface name and all service properties. It returns a string so that different 
# commands can format the data as they like
def getServiceInfo(service):
    # Get the service properties and format the output.
    serviceId = int(service.get("Identifier"))
    serviceProperties = ""

    properties = AdminControl.invoke_jmx(serviceStateMBean, "getProperties", [serviceId], ['long'])
    propList = properties.values()

    if propList != None:
        for property in propList:
            # Don't include the objectClass property as the interface is already in the display
            propertyKey = str(property.get("Key"))
            if propertyKey != "objectClass":
                if serviceProperties != "":
                    serviceProperties += ","

                serviceProperties += propertyKey + "=" + str(property.get("Value"))

    # Display the service interfaces.
    classNames = ""
    for className in service.get("objectClass"):
        if classNames != "":
            classNames += ","
        classNames += str(className)
    return "{" + classNames + "}={" + serviceProperties + "}"


# This method displays the packages imported and exported in the framework, or for the requested BundleID, or for the
# supplied package name
def packages(packageFilter = None):
    
    if packageStateMBean != None:
        if isMBeanAvailable(packageStateMBean):
            # If no packageFilter has been supplied then display all packages
            if packageFilter == None:
                for package in packageData:
                   displayPackage(package)
            # If the package matches a valid bundle ID then display the packages that the bundle exports.
            elif getBundle(packageFilter) != None:
                # If a packageFilter has been supplied, then check if it maps to a bundle ID, and if so, find all the 
                # packages that are exported by this bundle, and then display the details about these packages.
                exportedPackages = []
                # Iterate over each package looking to see which bundleID exported them. Store these away.
                for package in packageData:
                    packageIDs = package.get("ExportingBundles")
                    for packageID in packageIDs:
                        if packageID == packageFilter:
                            exportedPackages.append(package)
        
                if len(exportedPackages) == 0:
                    print "No exported Packages"
                else:
                    for exportPackage in exportedPackages:
                       displayPackage(exportPackage)
            # Otherwise display any packages that match the packageName passed in.
            else:
                matchingPackages = []
        
                # Look for any matching packages
                for package in packageData:
                    packageName = package.get("Name")
                    if packageName == packageFilter:
                        matchingPackages.append(package)
        
                # If the array is empty then we've not found a match.
                if len(matchingPackages) == 0:
                    print "No packages found" 
                else:
                    # Otherwise display the package(s)
                    for matchingPackage in matchingPackages:
                        displayPackage(matchingPackage)
    else:
        displayNLSMessage("EBAADMIN0048E")


# This displays the package information for the specified package object.
def displayPackage(package):
    exportingBundles = package.get("ExportingBundles")
    importingBundles = package.get("ImportingBundles")
    packageName = package.get("Name")
    packageVersion = package.get("Version")

    for exportingBundleID in exportingBundles:
        exportingBundle = getBundle(exportingBundleID)

        packageDisplay = ""
        if exportingBundle != None:
            packageDisplay = "<" + str(getSymbolicName(exportingBundle)) + "_" + str(getVersion(exportingBundle)) + " [" + \
                              str(exportingBundleID) + "]>"

        # Finally display the exporting packge info.
        print str(packageName) + '; version="' + str(packageVersion) + '"' + packageDisplay
        # Iterate over the importing bundles and display each one of these.
        for importBundleID in importingBundles:
            importingBundle = getBundle(importBundleID)
            if importingBundle != None:
                print "  " + str(getSymbolicName(importingBundle)) + "_" + str(getVersion(importingBundle)) + " [" + \
                              str(importBundleID) + "] imports" 


# This method returns the headers for the bundle with the specified bundleID.
def headers(bundleID = None):
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            bundle = getBundle(bundleID)
            if bundle == None:
                displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
            else:
                headers = []
                for headerProp in bundle.get("Headers").values():
                    headers.append([str(headerProp.get("Key")), str(headerProp.get("Value"))])
                
                # Sort the headers and then iterate over the sorted list, printing them out.
                headers.sort()
                for header in headers:
                    print header[0] + " = " + header[1]
    else:
        displayNLSMessage("EBAADMIN0030E")


# This method is used to start the specified bundle
def start(bundleID = None):
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            # Get the bundle that maps to the bundleID.
            bundle = getBundle(bundleID)
            if bundle == None:
                displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
            else:
                state = bundle.get("State")
                if state == "ACTIVE":
                    displayNLSMessage("EBAADMIN0031E", [str(getSymbolicName(bundle))])
                else:
                    displayNLSMessage("EBAADMIN0040I", [str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle))])
                    AdminControl.invoke_jmx(frameworkMBean, "startBundle", [bundleID], ['long'])
                    # Now we have started the bundle, refresh the information on the bundles and check that it has started successfully.
                    getBundleData()
                    chkBundle = getBundle(bundleID)
                    if chkBundle != None:
                        # Get the state and make sure it is now started.
                        state = chkBundle.get("State")
                        if state == "ACTIVE":
                            displayNLSMessage("EBAADMIN0032I", [str(getSymbolicName(bundle))])
                        else:
                            displayNLSMessage("EBAADMIN0040I", [str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle)), str(state)])
                    else:
                        displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
    else:
        displayNLSMessage("EBAADMIN0026E")


# This method is used to stop a specified bundle
def stop(bundleID = None):
    if bundleStateMBean != None:
        if isMBeanAvailable(bundleStateMBean):
            bundle = getBundle(bundleID)
            if bundle == "":
                displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
            else:
                state = bundle.get("State")
                if state == "RESOLVED":
                    displayNLSMessage("EBAADMIN0033E", [str(getSymbolicName(bundle))])
    
                else:
                    displayNLSMessage("EBAADMIN0042I", [str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle))])
                    AdminControl.invoke_jmx(frameworkMBean, "stopBundle", [bundleID], ['long'])
                    # Now we have stopped the bundle, refresh the information on the bundles and check that it has stopped successfully.
                    getBundleData()
                    chkBundle = getBundle(bundleID)
                    if chkBundle != None:
                        # Get the state and make sure it is now started.
                        state = chkBundle.get("State")
                        if state == "RESOLVED":
                            displayNLSMessage("EBAADMIN0034I", [str(getSymbolicName(bundle))])
                        else:
                            displayNLSMessage("EBAADMIN0043E", [str(getSymbolicName(bundle)) + "_" + str(getVersion(bundle)), str(state)])
                    else:
                        displayNLSMessage("EBAADMIN0028E", [str(bundleID)])
    else:
        displayNLSMessage("EBAADMIN0026E")


# This method is used to get the service with the specified identifier
def getService(serviceID):
    returnService = None
    # Iterate over each service object and return the service that matches the service Identifier
    for currService in serviceData:
        try:
            if currService.get("Identifier") == long(serviceID):
                returnService = currService
        # Catch eny exceptions. We'll return a None if we hit any problems.
        except:
            pass
    return returnService


# This method returns the bundle object for the specified bundle ID. If no bundle is found 
def getBundle(bundleID):
    returnBundle = None
    # Iterate over each bundle object and return the bundle that matches the bundle Identifier
    for currBundle in bundleData:
        try:
            if currBundle.get("Identifier") == long(bundleID):
                returnBundle = currBundle
        # Catch eny exceptions. We'll return a None if we hit any problems.
        except:
            pass
    return returnBundle


# This method refreshes the bundle, service and package data objects to give an up-to-date snapshot of the framework.
def refresh():
    if isMBeanAvailable(bundleStateMBean):
        getBundleData()
        getServiceData()
        getPackageData()


# This method is used to print a list of valid commands to the console.
def help():
    # Get the translated help message from the resource bundle
    help = AdminUtilities._getNLS("EBAADMIN0025I", resourceBundle)
    # Split the help info up by splitting on the \n's in the messageID. Iterate over each of these and display them.
    for printline in help.split("\\n"):
        print printline
  
  
def list():
    frameworks = getFrameworks()

    frameworkProperties = []
    # set the default lengths to be the number of chars in the label.
    maxBundleName = 9
    maxBundleVersion = 7
    maxNodeName = 4
    
    for frameworkID in range(len(frameworks)):
        framework = frameworks[frameworkID]
        bundleName = framework.getKeyProperty("bundle")
        bundleVersion = framework.getKeyProperty("version")
        serverName = framework.getKeyProperty("process")
        nodeName = framework.getKeyProperty("node")

        # find the largest bundleName. 
        if len(bundleName) > maxBundleName:
            maxBundleName = len(bundleName)

        # find the largest bundle version. 
        if len(bundleVersion) > maxBundleVersion:
            maxBundleVersion = len(bundleVersion)

        # find the largest Node Name. 
        if len(nodeName) > maxNodeName:
            maxNodeName = len(nodeName)

        connect = "";
        if bundleStateMBean == framework:
            connect = "<== Connected"

        # Store the entries away in an array which we'll iterate over to display once we know the formatting lengths
        frameworkProperties.append([frameworkID, bundleName, bundleVersion, nodeName, serverName, connect])

    # Print the headers, using the formatting lengths
    print " " + string.ljust("ID",3) + "  " + string.ljust("Framework", maxBundleName) + "  " + \
        string.ljust("Version", maxBundleVersion) + "  " + string.ljust("Node", maxNodeName) + "  " + "Server"

    for framework in frameworkProperties:
        print " " + string.ljust(str(framework[0]), 3) + "  " + string.ljust(str(framework[1]), maxBundleName) + "  " + \
            string.ljust(str(framework[2]), maxBundleVersion) + "  " + string.ljust(str(framework[3]), maxNodeName) + "  " + \
            str(framework[4]) + "  " + str(framework[5])
    
    
def connect(bundleName, bundleVersion=None, nodeName=None, serverName=None):

    global frameworkMBean, bundleStateMBean, packageStateMBean, serviceStateMBean, bundleData, serviceData
    
    connectFramework = ""
    if bundleVersion == None and nodeName == None and serverName == None:
        frameworks = getFrameworks()
        try:
            connectFramework = (frameworks[bundleName])
        except:
            pass
    else:
        for framework in getFrameworks():
            frameworkBundleName = framework.getKeyProperty("bundle")
            frameworkBundleVersion = framework.getKeyProperty("version")
            frameworkServerName = framework.getKeyProperty("process")
            frameworkNodeName = framework.getKeyProperty("node")

            if (bundleName == frameworkBundleName) and \
                (bundleVersion == frameworkBundleVersion) and  \
                (nodeName == frameworkNodeName) and \
                (serverName == frameworkServerName):
                    connectFramework = framework

    if connectFramework != "":
        bundleName = connectFramework.getKeyProperty("bundle")
        bundleVersion = connectFramework.getKeyProperty("version")
        serverName = connectFramework.getKeyProperty("process")
        nodeName = connectFramework.getKeyProperty("node")

        bundleStateMBean = connectFramework
        queryString = "node=" + nodeName + ",process=" + serverName + ",bundle=" + bundleName + ",version=" + bundleVersion + ","

        # List all Framework MBeans. Check that there is a FrameworkMbean registered, and
        # take the 1st one as there should only be one available.
        allFrameworkMBeans = getMBeans(queryString + "type=FrameworkMBean,*")
        if len(allFrameworkMBeans) > 0:
            frameworkMBean = allFrameworkMBeans[0]

        # List all PackageState MBeans. Check that there is a PackageStateMbean registered, and
        # take the 1st one as there should only be one available.
        allPackageStateMBeans = getMBeans(queryString + "type=PackageStateMBean,*")
        if len(allPackageStateMBeans) > 0:
            packageStateMBean = allPackageStateMBeans[0]

        # List all ServiceState MBeans. Check that there is a ServiceStateMbean registered, and
        # take the 1st one as there should only be one available.
        allServiceStateMBeans = getMBeans(queryString + "type=ServiceStateMBean,*")
        if len(allServiceStateMBeans) > 0:
            serviceStateMBean = allServiceStateMBeans[0]

        displayNLSMessage("EBAADMIN0035I", [str(bundleName + "_" + bundleVersion), str(nodeName), str(serverName)])
        
        # populate the bundleData object and ServiceData object with the current state of the framework
        refresh()
        displayNLSMessage("EBAADMIN0036I", [str(bundleName + "_" + bundleVersion)])

    else:
        if bundleVersion == None and nodeName == None and serverName == None:
            displayNLSMessage("EBAADMIN0037E", [str(bundleName)])
        else:
            displayNLSMessage("EBAADMIN0038E", [str(bundleName + "_" + bundleVersion), str(nodeName), str(serverName)])

        displayNLSMessage("EBAADMIN0039I")
        list()


# This method calls the Mbean to gather the latest data about the bundles in the framework.
def getBundleData():
    global bundleData
    # populate the bundleData object with the individual bundle elements
    if bundleStateMBean != None:
        bundleData = []
        # Invoke the Mbean and store the individual bundle objects in the bundleData array
        mbeanBundleData = AdminControl.invoke_jmx(bundleStateMBean, "listBundles", [], [])
        for bundle in mbeanBundleData.values():
            bundleData.append(bundle)
    else:
        displayNLSMessage("EBAADMIN0026E") 


# This method calls the Mbean to gather the latest data about the services in the framework.
def getServiceData():
    global serviceData
    # populate the bundleData object with the individual bundle elements
    if serviceStateMBean != None:
        serviceData = []

        # Invoke the Mbean and store the individual service objects in the serviceData array
        mbeanServiceData = AdminControl.invoke_jmx(serviceStateMBean, "listServices", [], [])
        for service in mbeanServiceData.values():
            serviceData.append(service)
            serviceId = int(service.get("Identifier"))
    else:
        displayNLSMessage("EBAADMIN0027E")


# This method calls the Mbean to gather the latest data about the packages in the framework.
def getPackageData():
    global packageData
    # populate the bundleData object with the individual bundle elements
    if packageStateMBean != None:
        packageData = []
        # Invoke the Mbean and store the individual service objects in the serviceData array
        mbeanPackageData = AdminControl.invoke_jmx(packageStateMBean, "listPackages", [], [])
        for package in mbeanPackageData.values():
            packageData.append(package)
    else:
        displayNLSMessage("EBAADMIN0048E")


# This method get the available frameworks that the user can connect to.
def getFrameworks():
    # Look for all BundleStateMBeans. We use this to get one entry for each isolated framework
    return getMBeans("type=BundleStateMBean,*")


# This method returns the arary of mbeans that match the queryString.
def getMBeans(queryString):
    # Get a list of all Mbeans matching the queryString string
    listOfMbeans = AdminControl.queryNames(queryString)
    result = []
    # Iterate over each name and get the object name for each. Add to the result array.
    for mbean in listOfMbeans.split():
        objectInstance = AdminControl.getObjectInstance(mbean)
        result.append(objectInstance.getObjectName())
    return result


# This method takes a message ID and optional array of parameters, and prints the NLS message out.
def displayNLSMessage(messageID, attrs=[]):
    print AdminUtilities._formatNLS(resourceBundle, messageID, attrs)
    
    
# This method checks to see if the requested MBean is still available. This is to check that the MBeans haven't be unregistered 
# i.e. when an Application has been stopped. 
def isMBeanAvailable(queryString):
    result = 1
    if len(getMBeans(str(queryString))) == 0:
        connectionDropped()
        result = 0
    return result
    
    
# This method displays the message to say that the connection has dropped and resets all of the MBeans.
def connectionDropped():
    global frameworkMBean, bundleStateMBean, packageStateMBean, serviceStateMBean 
    # Reset the MBeans so that the connection status doesn't show we're connected to a framework
    frameworkMBean = None
    bundleStateMBean = None
    packageStateMBean = None
    serviceStateMBean = None
    displayNLSMessage("EBAADMIN0050E")

# This method returns the symbolic name from the bundle data object. If it is None then we 
# return the string version of this.
def getSymbolicName(bundle):
    bundleSymbolicName = "None"

    if bundle != None:
        bundleSymbolicName = bundle.get("SymbolicName");
               
        if (bundleSymbolicName == None):
            bundleSymbolicName = "None"

    return bundleSymbolicName

# This method returns the bundle version from the bundle data object. If it is None then we 
# return the string version of this.
def getVersion(bundle):
    bundleVersion = "None"
    if bundle != None:
        bundleVersion = bundle.get("Version")
        if (bundleVersion == None):
            bundleVersion = "None"

    return bundleVersion



