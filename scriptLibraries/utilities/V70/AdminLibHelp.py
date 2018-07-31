
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
# AdminLibHelp.py - Jython procedures for performing script library general help information.
#------------------------------------------------------------------------------

import java.util.Locale
import java.util.ResourceBundle
import java.text.MessageFormat
import sys
import java.io.File
import AdminUtilities


 
def help(library="", failonerror=AdminUtilities._BLANK_ ):
        if (failonerror==AdminUtilities._BLANK_): 
                failonerror=AdminUtilities._FAIL_ON_ERROR_
        #endIf
        msgPrefix = "help("+`library`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Provide the online help
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminLibHelp:                   General help "
                #print " Script library name:            "+library
                #print " Usage: AdminLibHelp.help(\""+library+"\")"
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = AdminUtilities.getResourceBundle(bundleName)
                
                if (len(library) == 0):
                   message = resourceBundle.getString("ADMINLIBHELP_GENERAL_HELP")
                else:
                   library = library.upper() + "_GENERAL_HELP"
                   message = resourceBundle.getString(library)
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

