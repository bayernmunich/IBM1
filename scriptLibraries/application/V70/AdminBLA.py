
###############################################################################
# Licensed Material - Property of IBM 
# 5724-I63, 5724-H88, (C) Copyright IBM Corp. 2005 - All Rights Reserved. 
# US Government Users Restricted Rights - Use, duplication or disclosure 
# restricted by GSA ADP Schedule Contract with IBM Corp. 
#
# DISCLAIMER:
# The following source code is sample code created by IBM Corporation.
# This sample code is provided to you solely for the purpose of assisting you 
# in the  use of  the product. The code is provided 'AS IS', without warranty or 
# condition of any kind. IBM shall not be liable for any damages arising out of your
# use of the sample code, even if IBM has been advised of the possibility of
# such damages.
###############################################################################

#
#------------------------------------------------------------------------------
# AdminBLA.py - Jython procedures for performing business leval application tasks.
#------------------------------------------------------------------------------
#
#   This script includes the following business level application script procedures:
#
#      Ex1:  createEmptyBLA
#      Ex2:  listBLAs
#      Ex3:  deleteBLA
#      Ex4:  importAsset
#      Ex5:  exportAsset
#      Ex6:  editAsset
#      Ex7:  listAssets
#      Ex8:  deleteAsset
#      Ex9:  viewAsset
#      Ex10: addCompUnit
#      Ex11: listCompUnits
#      Ex12: editCompUnit
#      Ex13: deleteCompUnit
#      Ex14: viewCompUnit
#      Ex15: startBLA
#      Ex16: stopBLA
#      Ex17: help
#
#---------------------------------------------------------------------

import sys
import java
import AdminUtilities 

# Setting up Global Variable within this script
bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
resourceBundle = AdminUtilities.getResourceBundle(bundleName)

## Example 1: Create an empty business level application ##
def createEmptyBLA( blaName, description="", failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "createEmptyBLA("+`blaName`+", "+`description`+", "+`failonerror`+"): "
        
        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Create an empty business level application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               Create an empty business level application"
                print " BLA name:               "+blaName
                print " Optional parameter: "
                print "    description:         "+description
                print " Usage: AdminBLA.createEmptyBLA(\""+blaName+"\", \""+description+"\")"
                print " Return: Create an empty business-level application. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                else:
                   blas = AdminTask.listBLAs(['-blaID', blaName])
                   if (len(blas) > 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [blaName]))
                #endIf
                
                # Construct required parameters
                requiredParams = ['-name', blaName]
                
                # Construct optional parameters
                optionalParams = []
                if (len(description) == 0):
                   description = ""
                optionalParams = ['-description', description]
                params = requiredParams + optionalParams

                bla = AdminTask.createEmptyBLA(params)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return bla
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 2: List available business level applications in a cell ##
def listBLAs(blaName="", includeDescription="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listBLAs("+`blaName`+", "+`includeDescription`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List available business level applications
                #--------------------------------------------------------------------
                print "-------------------------------------------------------------------"
                print " AdminBLA:                               List business level applications"
                print " Optional parameters:"
                print "      BLA ID (or BLA name):              "+blaName
                print "      include description in result:     "+includeDescription
                print " Usage: AdminBLA.listBLAs(\""+blaName+"\", \""+includeDescription+"\")"
                print " Return: List of the business-level applications in the cell or list the business-level application for the specified name."
                print "--------------------------------------------------------------------"
                print " "
                print " "
                # Construct optional parameters
                optionalParams = []
                if (len(blaName) == 0):
                   blaName = ""
                #endIf
                
                if (len(includeDescription) == 0):
                   includeDescription = ""
                   
                optionalParams = ['-blaID', blaName, '-includeDescription', includeDescription]
                
                blas = AdminTask.listBLAs(optionalParams)
                blas = AdminUtilities.convertToList(blas)
                return blas
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 3: Delete a business level application if there are no composition units in it ##
def deleteBLA( blaName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteBLA("+`blaName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a business level application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               Delete a business level application"
                print " BLA ID (or bla name):   "+blaName
                print " Usage: AdminBLA.deleteBLA(\""+blaName+"\")"
                print " Return: Business-level application that is deleted. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                else:
                   blas = AdminTask.listBLAs(['-blaID', blaName])
                   if (len(blas) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf
                
                result = AdminTask.deleteBLA(["-blaID", blaName])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 4: Import and register an asset (deployed object) to WebSphere management domain ##
def importAsset( sourcePath, storageType="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "importAsset("+`sourcePath`+", "+`storageType`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Register an asset (deployed object) with WebSphere
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       Import an asset with WebSphere"
                print " Source path:                    "+sourcePath
                print " Optional parameter:"
                print "      Storage type (FULL, METADATA, NONE):"
                print "                                 "+storageType
                print " Usage: AdminBLA.importAsset(\""+sourcePath+"\", \""+storageType+"\")"
                print " Return: Asset name that is imported to WebSphere management domain."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (sourcePath == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["sourcePath", sourcePath]))

                # Construct required parameters
                requiredParams = ['-source', sourcePath]
                
                # Construct optional parameters
                optionalParams = []
                if (len(storageType) == 0):
                   storageType = ""
                optionalParams = ['-storageType', storageType]
                params = requiredParams + optionalParams
                asset = AdminTask.importAsset(params)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return asset
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 5: Export a registered asset to the file ##
def exportAsset( assetID, fileName, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "exportAsset("+`assetID`+", "+`fileName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Export a registered asset
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       Export a registered asset to a file"
                print " Registered asset ID:            "+assetID
                print " File name for asset to export:  "+fileName
                print " Usage: AdminBLA.exportAsset(\""+assetID+"\", \""+fileName+"\")"
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (assetID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["assetID", assetID]))
                
                if (fileName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["fileName", fileName]))

                # check if asset exists
                assets = AdminTask.listAssets(["-assetID", assetID])
                if (len(assets) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["assetID", assetID]))
                #endIf

                               
                # Construct required parameters
                requiredParams= ['-assetID', assetID, '-filename', fileName]

                AdminTask.exportAsset(requiredParams)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef


## Example 6: Edit an asset metadata ##
def editAsset( assetID, description, destinationURL, typeAspect, relationship, filePermission, validate, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "editAsset("+`assetID`+", "+`description`+", "+`destinationURL`+", "+`typeAspect`+", "+`relationship`+", , "+`filePermission`+", "+`validate`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Edit an asset metadata
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       Edit an asset metadata"
                print " Registered asset ID:            "+assetID
                print " Optional asset options parameters:"
                print "      Asset description:         "+description
                print "      Asset destination Url:     "+destinationURL
                print "      Asset type aspects:        "+typeAspect   
                print "      Asset relationships:       "+relationship
                print "      File permission:           "+filePermission
                print "      Validate asset:            "+validate   
                print " Usage: AdminBLA.editAsset(\""+assetID+"\", \""+description+"\", \""+destinationURL+"\", \""+typeAspect+"\", \""+relationship+"\", \""+filePermission+"\", \""+validate+"\")"   
                print " Return: If the command is successful, a value of 1 is returned."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (assetID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["assetID", assetID]))
                else:
                   # Check if asset exists
                   assets = AdminTask.listAssets(["-assetID", assetID])
                   if (len(assets) == 0):
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["assetID", assetID]))
                #endIf

                # Construct required parameters
                requiredParams = ['-assetID', assetID]
                
                # Construct optional parameters
                optionalParams = []
                if (len(description) == 0):
                   description = ""
                if (len(destinationURL) == 0):
                   destinationURL = ""
                if (len(typeAspect) == 0):
                   typeAspect = ""
                if (len(relationship) == 0):
                   relationship = ""
                if (len(filePermission) == 0):
                   filePermission = ""
                if (len(validate) == 0):
                   validate = ""
                optionalParams = ['-AssetOptions', [['', '.*', '', description, destinationURL, typeAspect, relationship, filePermission, validate]]]
                
                params = requiredParams + optionalParams
                asset = AdminTask.editAsset(params)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef



## Example 7: List registered assets in a cell ##
def listAssets( assetID="", includeDescription="", includeDeployUnit="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listAssets("+`assetID`+", "+`includeDescription`+", "+`includeDeployUnit`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List registered assets
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       List registered assets"
                print " Optional parameters:"
                print "      Asset ID:                  "+assetID
                print "      Display description:       "+includeDescription
                print "      Display deployable unit    "+includeDeployUnit
                print " Usage: AdminBLA.listAssets(\""+assetID+"\", \""+includeDescription+"\", \""+includeDeployUnit+"\")"
                print " Return: List of registered assets in the respective cell."
                print "---------------------------------------------------------------"
                print " "
                print " "
                # Construct optional parameters
                optionalParams = []
                if (len(assetID) == 0):
                   assetID = ""
                
                if (len(includeDescription) == 0):
                   includeDescription = ""
                
                if (len(includeDeployUnit) == 0):
                   includeDeployUnit = ""
                optionalParams = ['-assetID', assetID, '-includeDescription', includeDescription, '-includeDeplUnit', includeDeployUnit]
                                
                assets = AdminTask.listAssets(optionalParams)
                return assets
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
    
## Example 8: Delete a registered asset from WebSphere configuration repository ##
def deleteAsset( assetID, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteAsset("+`assetID`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a registered asset
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               Delete a registerd asset"
                print " Asset ID:               "+assetID
                print " Usage: AdminBLA.deleteAsset(\""+assetID+"\")"
                print " Return: Asset name that is deleted from the configuration."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (assetID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["assetID", assetID]))
                else:
                   # Check if asset exists
                   assets = AdminTask.listAssets(["-assetID", assetID])
                   if (len(assets) == 0):
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["assetID", assetID]))
                #endIf

                result = AdminTask.deleteAsset(['-assetID', assetID])
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 9 View a registered asset ##
def viewAsset( assetID, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "viewAsset("+`assetID`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # View a registered asset
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               View a registered asset "
                print " Asset ID:               "+assetID
                print " Usage: AdminBLA.viewAsset(\""+assetID+"\")"
                print " Return: List the configuration attributes for a specified registered asset. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (assetID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["assetID", assetID]))
                else:
                   # Check if assest exists
                   assets = AdminTask.listAssets(["-assetID", assetID])
                   if (len(assets) == 0):
                       raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["assetID", assetID]))
                #endIf

                asset = AdminTask.viewAsset(['-assetID', assetID])
                return asset
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef

  
## Example 10: Add a composition unit to a business level application ##
def addCompUnit( blaName, cuSourceID, deployUnits, cuName, cuDescription, startingWeight, server, activationPlan, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "addCompUnit("+`blaName`+", "+`cuSourceID`+", "+`deployUnits`+", "+`cuName`+", "+`cuDescription`+", "+`startingWeight`+", "+`server`+", "+`activationPlan`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Add composition unit to BLA
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       Add composition unit to business level application"
                print " BLA ID (or BLA name):           "+blaName
                print " Composition unit source ID:     "+cuSourceID 
                print " Optional parameter:"
                print "      Deployable unit:           "+deployUnits
                print " Optional CU options parameters:"
                print "      CU name:                   "+cuName
                print "      CompUnit description:      "+cuDescription
                print "      Starting weight:           "+startingWeight
                print " Optional map target parameters:"
                print "      Server to deploy CompUnit: "+server
                print " Optional activation plan parameters:"
                print "      Activation plan:           "+activationPlan     
                print " Usage: AdminBLA.addCompUnit(\""+blaName+"\", \""+cuSourceID+"\", \""+deployUnits+"\", \""+cuDescription+"\", \""+startingWeight+"\", \""+server+"\", \""+activationPlan+"\")"
                print " Return: Composition unit name that is added to the given business-level application."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                
                if (cuSourceID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["cuSourceID", cuSourceID]))

                # check if bla exists
                blas = AdminTask.listBLAs(['-blaID', blaName])
                # Check if BLA exists
                if (len(blas) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                # check if comp unit exists
                cus = AdminTask.listCompUnits(['-blaID', blaName])
                # Check if compUnit exists
                if (cus.find(cuSourceID) > 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6046E", [cuSourceID]))
                #endIf  

                # Construct required parameters
                requiredParams = ['-blaID', blaName, '-cuSourceID', cuSourceID]
                
                # Construct optional parameters
                optionalParams = []
                if (len(cuDescription) == 0):
                   cuDescription = ""
                
                if (len(startingWeight) == 0):
                   startingWeight = ""
                
                if (len(server) == 0):
                   server = ""
                
                if (len(activationPlan) == 0):
                   activationPlan = ""
                
                optionalParams = ['-deplUnits', deployUnits, '-CUOptions', [['.*', '.*', cuName, cuDescription, startingWeight]], '-MapTargets', [['.*', server]], '-ActivationPlanOptions', [['.*', activationPlan]]]
                
                params = requiredParams + optionalParams
                cu = AdminTask.addCompUnit(params)
                
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()

                return cu
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  
  
## Example 11: List composition units in a BLA ##
def listCompUnits( blaName, includeDescription="", failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "listCompUnits("+`blaName`+", "+`includeDescription`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # List composition units in a business level application (BLA)
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       List composition units in a BLA"
                print " BLA ID (or BLA name):           "+blaName
                print " Optional parameter:"
                print "      Display description:       "+includeDescription
                print " Usage: AdminBLA.listCompUnits(\""+blaName+"\", \""+includeDescription+"\") "
                print " Return: List the composition units within the specified business-level application. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                else:
                   blas = AdminTask.listBLAs(['-blaID', blaName])
                   if (len(blas) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                # Construct required parameters
                requiredParams = ['-blaID', blaName]
                
                # Construct optional parameters
                optionalParams = []
                if (len(includeDescription) == 0):
                   includeDescription = ""
                optionalParams = ['-includeDescription', includeDescription]
                params = requiredParams + optionalParams

                CUs = AdminTask.listCompUnits(params)
                return CUs
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 12: Edit a composition unit in a BLA ##
def editCompUnit( blaName, compUnitID, cuDescription, startingWeight, server, activationPlan, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "editCompUnit("+`blaName`+", "+`compUnitID`+", "+`cuDescription`+", "+`startingWeight`+", "+`server`+", "+`activationPlan`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Edit a composition unit in a BLA
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:                       Edit a composition unit in a BLA"
                print " BLA ID (or BLA name):           "+blaName
                print " Composition unit ID:            "+compUnitID
                print " Optional CU options parameters:"
                print "      CompUnit description:      "+cuDescription
                print "      Starting weight:           "+startingWeight
                print " Optional map target parameters:"
                print "      Server to deploy CompUnit: "+server
                print " Optional activation plan parameters:"
                print "      Activation plan:           "+activationPlan     
                print " Usage: AdminApplication.installAppWithDeployEjbOptions(\""+blaName+"\", \""+compUnitID+"\",\""+cuDescription+"\", \""+startingWeight+"\", \""+server+"\", \""+activationPlan+"\")"
                print " Return: Composition unit name that is edited in the given business-level application."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                
                if (compUnitID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["compUnitID", compUnitID]))

                
                # check if bla exists
                blas = AdminTask.listBLAs(['-blaID', blaName])
                if (len(blas) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf
                
                # check if comp unit
                cus = AdminTask.listCompUnits(['-blaID', blaName])
                # Check if compUnit exists
                if (cus.find(compUnitID) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["compUnitID", compUnitID]))
                #endIf  

                # Construct required parameters
                requiredParams = ['-blaID', blaName, '-cuID', compUnitID]
                
                # Construct optional parameters
                optionalParams = []
                if (len(cuDescription) == 0):
                   cuDescription = ""
                if (len(startingWeight) == 0):
                   startingWeight = ""
                if (len(server) == 0):
                   server = ""
                if (len(activationPlan) == 0):
                   activationPlan = ""
                optionalParams = ['-CUOptions', [['.*', '.*', '.*', cuDescription, startingWeight]], '-MapTargets', [['.*', server]], '-ActivationPlanOptions', [['.*', activationPlan]]]
                
                params = requiredParams + optionalParams
                cu = AdminTask.editCompUnit(params)
        
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
        
                return cu
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 13 Delete a composition unit in a BLA ##
def deleteCompUnit( blaName, compUnitID, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "deleteCompUnit("+`blaName`+", "+`compUnitID`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Delete a composition unit in a BLA
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               Delete a composition unit in a BLA"
                print " BLA ID (or BLA name):   "+blaName
                print " Composition unit ID:    "+compUnitID
                print " Usage: AdminBLA.deleteCompUnit(\""+blaName+"\", \""+compUnitID+"\")"
                print " Return: Composition unit name that is deleted from the given business-level application."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                
                if (compUnitID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["compUnitID", compUnitID]))

                # check if bla exists
                blas = AdminTask.listBLAs(['-blaID', blaName])
                if (len(blas) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                # check if comp unit exists
                cus = AdminTask.listCompUnits(['-blaID', blaName])
                # Check if compUnit exists
                if (cus.find(compUnitID) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["compUnitID", compUnitID]))
                #endIf  

                # Construct required parameters
                requiredParams = ['-blaID', blaName, '-cuID', compUnitID]

                result = AdminTask.deleteCompUnit(requiredParams)
        
                if (AdminUtilities._AUTOSAVE_ == "true"):
                   AdminConfig.save()
        
                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        return 1  # succeed
#endDef
  

## Example 14 View a composition unit in a BLA ##
def viewCompUnit( blaName, compUnitID, failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "viewCompUnit("+`blaName`+", "+`compUnitID`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Veiw a composition unit in a BLA
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               View a composition unit in a BLA "
                print " BLA ID (or BLA name):   "+blaName
                print " Composition unit        "+compUnitID
                print " Usage: AdminBLA.viewCompUnit(\""+blaName+"\", \""+compUnitID+"\")"
                print " Return: Configuration attributes for a given composition unit within the business-level application."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required arguments
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                
                if (compUnitID == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["compUnitID", compUnitID]))

                # check if bla exists
                blas = AdminTask.listBLAs(['-blaID', blaName])
                if (len(blas) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                # check if comp unit exists
                cus = AdminTask.listCompUnits(['-blaID', blaName])
                # Check if compUnit exists
                if (cus.find(compUnitID) == 0):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["compUnitID", compUnitID]))
                #endIf  

                # Construct required parameters
                requiredParams = ['-blaID', blaName, '-cuID', compUnitID]
                
                cu = AdminTask.viewCompUnit(requiredParams)
                
                return cu
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 15 Start a business level application ##
def startBLA(blaName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "startBLA("+`blaName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # start a business level application 
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print "---------------------------------------------------------------"
                print " AdminBLA:               Start a business level application "
                print " BLA ID (or BLA name):   "+blaName
                print " Usage: AdminBLA.startBLA(\""+blaName+"\") "
                print " Return: State that the business-level application is started."
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                else:
                   blas = AdminTask.listBLAs(['-blaID', blaName])
                   if (len(blas) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                result = AdminTask.startBLA(['-blaID', blaName])
                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef
  

## Example 16 Stop a business level application ##
def stopBLA( blaName, failonerror=AdminUtilities._BLANK_):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "stopBLA("+`blaName`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Stop a business level application
                #--------------------------------------------------------------------
                print "---------------------------------------------------------------"
                print " AdminBLA:               Stop a business level application "
                print " BLA ID (or BLA name):   "+blaName
                print " Usage: AdminBLA.stopBLA(\""+blaName+"\")"
                print " Return: State that the business-level application name is stopped. "
                print "---------------------------------------------------------------"
                print " "
                print " "
                
                # check the required argument
                if (blaName == ""):
                   raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6041E", ["blaName", blaName]))
                else:
                   blas = AdminTask.listBLAs(['-blaID', blaName])
                   if (len(blas) == 0):
                      raise AttributeError(AdminUtilities._formatNLS(resourceBundle, "WASL6040E", ["blaName", blaName]))
                #endIf

                result = AdminTask.stopBLA(['-blaID', blaName])
                return result
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
#endDef


## Example 17 Online help ##
def help(procedure="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "help("+`procedure`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Set up globals
                #--------------------------------------------------------------------
                global AdminTask
                
                #--------------------------------------------------------------------
                # Provide the online help
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminBLA:                       Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminBLA.help(\""+procedure+"\")"
                #print " Return: List the help information for the specified AdminBLA library function or list the help information for all of the AdminBLA script library function if parameters are not passed."
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
                
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINBLA_GENERAL_HELP")
                else:
                   procedure = "ADMINBLA_HELP_"+procedure.upper()
                   message = resourceBundle.getString(procedure)
                #endIf
                return message
        except:
                typ, val, tb = sys.exc_info()
                if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                   return -1
                else:   
                   return AdminUtilities.fail(msgPrefix+AdminUtilities.getExceptionText(typ, val, tb), failonerror)
                #endIf
        #endTry
        #AdminUtilities.infoNotice(AdminUtilities._OK_+msgPrefix)
        #return 1  # succeed
#endDef


