
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
# AdminUtilities.py - Jython procedures for performing utilities tasks.
#------------------------------------------------------------------------------
#
#   This script includes the following application procedures:
#      Ex1:  save
#      Ex2:  sleepDelay
#      Ex3:  getExceptionText
#      Ex4:  infoNotice
#      Ex5:  warningNotice
#      Ex6:  debugNotice
#      Ex7:  fail
#      Ex8:  setDebugNotices
#      Ex9:  setFailOnErrorDefault
#      Ex10: convertToList
#      Ex11: getResourceBundle
#      Ex12: getScriptLibraryList
#      Ex13: getScriptLibraryPath
#      Ex14: getScriptLibraryFiles
#      Ex15: fileSearch
#      Ex16: help
#      Ex17: configureAutoSave
#
#---------------------------------------------------------------------


import java.util.Locale
import java.util.ResourceBundle
import java.text.MessageFormat
import sys
import java
import java.lang.Thread
import java.io.File
from com.ibm.ws.bootstrap import ExtClassLoader

#--------------------------------------------------------------------
# Set global constants
#--------------------------------------------------------------------

_TRUE_          = "true"      
_FALSE_         = "false"     
_OK_            = "OK: "      
_BLANK_         = ""          
_MAX_RETRIES_   = 30
_isND_          = _TRUE_
_SLEEP_SECS_    = 10
_bundleError_   = "Missing ResourceBundle"     
_resourceBundle_= None
_FAIL_ON_ERROR_ = _FALSE_
_DEBUG_NOTICES_ = _FALSE_
_lineSeparator_ = java.lang.System.getProperty("line.separator")
_AUTOSAVE_      = _TRUE_

 
## Example 1 Save all config changes ##
def save(failonerror=_BLANK_):
    global _FAIL_ON_ERROR_
    if (failonerror==_BLANK_): 
        failonerror=_FAIL_ON_ERROR_
    #endIf
    msgPrefix = "save("+`failonerror`+"): "
    
    try:
        #--------------------------------------------------------------------
        # Set up globals
        #--------------------------------------------------------------------
        global AdminConfig

        #--------------------------------------------------------------------
        # Save all the changes
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print "  Save configuration modifications"
        print "---------------------------------------------------------------"
        print ""
        debugNotice("Save configuration modifications.")
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
           return fail(msgPrefix+getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef
 
       
## Example 2 Set sleep delay ##
def sleepDelay(secs, failonerror=_BLANK_):
    global _FAIL_ON_ERROR_
    if (failonerror==_BLANK_): 
        failonerror=_FAIL_ON_ERROR_
    #endIf
    msgPrefix = "sleepDelay("+`secs`+", "+`failonerror`+"): "
    
    try:
        #--------------------------------------------------------------------
        # Set sleep delay
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " AdminUtilities:         Set sleep delay"
        print " Seconds to delay:       "+secs
        print " Usage: AdminUtilities.sleepDelay(\""+secs+"\")"
        print "---------------------------------------------------------------"
        print " "
        print " "
        java.lang.Thread.sleep(int(secs) *1000)
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != "true"):
           print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
           val = "%s %s" % (sys.exc_type, sys.exc_value)
           raise "ScriptLibraryException: ", `val`
        else:   
           return fail(msgPrefix+getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


## Example 3 Get exception texts ##
def getExceptionText(typ, value, tb):
    msgPrefix = "getExceptionText(): "
    
    value = `value`
    WSEX = "com.ibm.ws.scripting.ScriptingException: "
    if (value.startswith(WSEX)):
        value = value[len(WSEX):]
    #endIf
    sd = `tb.dumpStack()`
    sd = sd.replace("\\\\","/")
    debugNotice(msgPrefix+"typ="+`typ`)
    warningNotice(msgPrefix+"value="+`value`)
    debugNotice(msgPrefix+"stackdump="+`sd`)

    i = sd.rfind("  File ")
    j = sd.rfind(", line ")
    k = sd.rfind(", in ")
    locn = ""
    if(i>0 and j>0 and k>0):
        file = sd[i+7:j]
        line = sd[j+7:k]
        func = sd[k+4:-3]
        locn = "Function="+func+"  Line="+line+"  File="+file
        warningNotice(msgPrefix+locn)
    #endIf
    return value+" "+locn
#endDef


## Example 4 Information notice ##
def infoNotice(msg):
    print msg
#endDef


## Example 5 Warning notice ##
def warningNotice(msg):
    print "WARNING: "+msg
    return -1  #failure
#endDef


## Example 6 Debug notice ##
def debugNotice(msg):
    global _DEBUG_NOTICES_
    if (_DEBUG_NOTICES_==_TRUE_):
        print "DEBUG: "+msg
    #endIf
#endDef


## Example 7 Failure message ##
def fail(msg, failonerror=_BLANK_):
    global _FAIL_ON_ERROR_
    if (failonerror==_BLANK_): 
        failonerror=_FAIL_ON_ERROR_
    #endIf
    print  "\nFAILURE: "+`msg`+"\n"
    if (failonerror==_TRUE_):
        print "Exiting."
        raise SystemExit, 'msg'  
    #endIf
    return -1  #failure
#endDef


## Example 8 Set debug notices ##
def setDebugNotices(debug):
    global _DEBUG_NOTICES_
    msgPrefix = "setDebugNotices(debug="+`debug`+"): "
    if(debug!=_TRUE_ and debug!=_FALSE_):
        warningNotice(msgPrefix+"Invalid (must be "+_FALSE_+" or "+_TRUE_+"), defaulting to "+_TRUE_+".")
        debug = _TRUE_
    #endIf
    _DEBUG_NOTICES_ = debug
    debugNotice(msgPrefix+_DEBUG_NOTICES_)
#endDef
 

## Example 9 Set failonerror default ##
def setFailOnErrorDefault(failonerror):
    global _FAIL_ON_ERROR_
    msgPrefix = "setFailOnError(failonerror="+`failonerror`+"): _FAIL_ON_ERROR_="+_FAIL_ON_ERROR_+" "
    if (failonerror!=_TRUE_ and failonerror!=_FALSE_):
        warningNotice(msgPrefix+"Invalid (must be "+_FALSE_+" or "+_TRUE_+"), defaulting to "+_TRUE_+".")
        failonerror = _TRUE_
    #endIf
    _FAIL_ON_ERROR_ = failonerror
    debugNotice(msgPrefix+_FAIL_ON_ERROR_)
#endDef


## Example 10 Convert string to list ##
def convertToList( inlist ):
    outlist = []
    if (len(inlist) > 0):
       if (inlist[0] == '[' and inlist[len(inlist) - 1] == ']'):
          # Special checking when the config name contain space 
          if (inlist[1] == "\"" and inlist[len(inlist)-2] == "\""):
             clist = inlist[1:len(inlist) -1].split(")\" ")
          else:
             clist = inlist[1:len(inlist) - 1].split(" ")
          #endIf
       else:
          clist = inlist.split(java.lang.System.getProperty("line.separator"))
       #endIf
        
       for elem in clist:
           elem = elem.rstrip();
           if (len(elem) > 0):
              if (elem[0] == "\"" and elem[len(elem) -1] != "\""):
                 elem = elem+")\""
              #endIf   
              outlist.append(elem)
           #endIf
        #endFor
    #endIf    
    return outlist
#endDef


# Example 11 Get the resource bundle ##
def getResourceBundle(bundleName, failonerror=_BLANK_):
    msgPrefix = "getResourceBundle(bundleName="+bundleName+"): "
    
    global _resourceBundle_
    try:
        locale = java.util.Locale.getDefault()
        ExtClassLoader = java.lang.Class.forName("com.ibm.ws.bootstrap.ExtClassLoader")
        _resourceBundle_ = java.util.ResourceBundle.getBundle(bundleName, locale, ExtClassLoader.getInstance())
        if (_resourceBundle_==None):
           fail("Cannot find resourceBundle=Messages")   
        #endIf
        return _resourceBundle_
    except:
        typ, value, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != "true"):
           print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
           val = "%s %s" % (sys.exc_type, sys.exc_value)
           raise "ScriptLibraryException: ", `val`
        else:   
           return fail(msgPrefix+getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
    #debugNotice(msgPrefix+"using Message ResourceBundle="+bundleName )
#endDef


# Example 12 Get the script library name list
def getScriptLibraryList():
        scriptLibList = []
        
        # Get the script library files
        scriptLibFiles = getScriptLibraryFiles()
        
        # Get each script library name
        if (scriptLibFiles != ""):
           for file in scriptLibFiles:
               libName = file[file.rfind(java.lang.System.getProperty("file.separator"))+1:len(file)-3]
               print "script library name: " + libName
               scriptLibList.append(libName)
           #endFor
        #endIf
        return scriptLibList
#endDef


# Example 13 Get the script library path
def getScriptLibraryPath():
        scriptLibPaths = []
        
        # Get the script library files
        scriptLibFiles = getScriptLibraryFiles()
        
        # get the script library paths
        if (scriptLibFiles != ""):
           for file in scriptLibFiles:
               path = file[0:file.rfind(java.lang.System.getProperty("file.separator"))]
               scriptLibPaths.append(path)
           #endFor
        #endIf
        return scriptLibPaths
#endDef


# Example 14 Get the script library files #
def getScriptLibraryFiles():
        libPaths = []
        fs = java.lang.System.getProperty("file.separator")

        # Find the wsadmin script library path
        wsHome = java.lang.System.getProperty("was.install.root")
        wsadminLibPath = wsHome + fs + "scriptLibraries" 
        
        dir = java.io.File(wsadminLibPath)
        libPaths = fileSearch(dir, libPaths)
        
        # Find the custom scipt library path
        customLibPath = java.lang.System.getProperty("wsadmin.script.libraries")
        
        if (customLibPath != None and customLibPath != ""):
           if (customLibPath.find(";") > 0):
              paths = customLibPath.split(";")
              for path in paths:
                  dir = java.io.File(path)
                  libPaths = fileSearch(dir, libPaths)
              #endFor
           else:
              dir = java.io.File(customLibPath)
              libPaths = fileSearch(dir, libPaths)
           #endIf
        #endIf
        return libPaths
#endDef


# Example 15 Recrusive search jython files through the directory
def fileSearch( directory, paths):
    if (directory != ""):
       files = directory.listFiles()
       
       # Recrusive search script library files in the directory
       for file in files:
           if (file.isDirectory()):
              fileSearch(file, paths)
           elif (file.getName().endswith(".py")): 
              path = file.getAbsolutePath()
              paths.append(path)
           #endif 
       #endFor 
    #endIf
    return paths
#endDef


## Example 16 Online help ##
def help(procedure="", failonerror=_BLANK_ ):
        if (failonerror==_BLANK_): 
                failonerror=_FAIL_ON_ERROR_
        #endIf
        msgPrefix = "help("+`procedure`+", "+`failonerror`+"): "

        try:
                #--------------------------------------------------------------------
                # Provide the online help
                #--------------------------------------------------------------------
                #print "---------------------------------------------------------------"
                #print " AdminUtilities:                Help "
                #print " Script procedure:               "+procedure
                #print " Usage: AdminUtilities.help(\""+procedure+"\")"
                #print "---------------------------------------------------------------"
                #print " "
                #print " "
                bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
                resourceBundle = getResourceBundle(bundleName)
                
                if (len(procedure) == 0):
                   message = resourceBundle.getString("ADMINUTILITIES_GENERAL_HELP")
                else:
                   procedure = "ADMINUTILITIES_HELP_"+procedure.upper()
                   message = resourceBundle.getString(procedure)
                #endIf
                return message
        except:
                typ, val, tb = sys.exc_info()
                #if (typ==SystemExit):  raise SystemExit,`val`
                if (failonerror != "true"):
                   print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
                   val = "%s %s" % (sys.exc_type, sys.exc_value)
                   raise "ScriptLibraryException: ", `val`
                else:   
                   return fail(msgPrefix+getExceptionText(typ, val, tb), failonerror)
                #endIf
                
        #endTry
        #infoNotice(_OK_+msgPrefix)
        #return 1  # succeed
#endDef


## Example 17 Configure the configuration automation save ##
def configureAutoSave(autosave, failonerror=_BLANK_):
    global _FAIL_ON_ERROR_
    global _AUTOSAVE_
    if (failonerror==_BLANK_): 
        failonerror=_FAIL_ON_ERROR_
    #endIf
    msgPrefix = "unsave("+`failonerror`+"): "
    bundleName = "com.ibm.ws.scripting.resources.scriptLibraryMessage"
    resourceBundle = getResourceBundle(bundleName)
    
    try:
        #--------------------------------------------------------------------
        # Set up globals
        #--------------------------------------------------------------------
        global AdminConfig
        
        #--------------------------------------------------------------------
        # Configure automation save option
        #--------------------------------------------------------------------
        print "---------------------------------------------------------------"
        print " Configure the configuration automation save"
        print " Set autosave option:             "+autosave
        print " Usage: AdminUtilities.configureAutoSave(\""+autosave+"\")"
        print "---------------------------------------------------------------"
        print ""
        if (autosave == "false"):
           _AUTOSAVE_ = _FALSE_
        elif (autosave == "true"):   
           _AUTOSAVE_ = _TRUE_
        else:
           raise AttributeError(_formatNLS(resourceBundle, "WASL6041E", ["autosave", autosave]))
    except:
        typ, val, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        if (failonerror != "true"):
           print "Exception: %s %s " % (sys.exc_type, sys.exc_value)
           val = "%s %s" % (sys.exc_type, sys.exc_value)
           raise "ScriptLibraryException: ", `val`
        else:   
           return fail(msgPrefix+getExceptionText(typ, val, tb), failonerror)
        #endIf
    #endTry
#endDef


#############################################################
##################  Internal procedures #####################
#############################################################

# Initialize WAS admin
def _initializeAdmin():
    global _isND_
    global AdminControl
    global AdminConfig
    msgPrefix = "AdminUtilities.py: initializeAdmin(): "
    debugNotice(msgPrefix+"AdminUtilities initialize() ...")
    
    try:
        wsadminPort = AdminControl.getPort()
    except:
        fail("AdminControl Service not available (server not started)")
    #endTry
    try:
        wsSvr   = AdminConfig.list("Server")
    except:
        fail("AdminConfig Service not available (server not started)")
    #endTry

    try:
        f = java.io.File(".")
        curdir =  f.getCanonicalPath()+java.lang.System.getProperty('file.separator')

        wsadminNode   = AdminControl.getNode()
        wsadminSvr    = AdminControl.queryNames("node="+wsadminNode+",type=Server,*")
        wsadminMgmt   = AdminControl.getAttribute(wsadminSvr, "processType")
        debugNotice(msgPrefix+"Connected to Node="+wsadminNode+" ServerManagement="+wsadminMgmt)

        if (wsadminMgmt == "UnManagedProcess"):
           _isND_ = _FALSE_
        #endIf
        debugNotice(msgPrefix+"_isND_="+`_isND_`)

        wsadminConn   = AdminControl.getType()
        if (wsadminConn != "SOAP"):
            # todo: NLS
            fail(msgPrefix+"Currently only tested for connectionType=SOAP")
        #endIf

        ############### comment out these in production version ####################
        wsadminHost   = AdminControl.getHost()
        wsadminPort   = AdminControl.getPort()
        debugNotice(msgPrefix+"Connected to Host="+wsadminHost+" Port="+wsadminPort+" Conn="+wsadminConn)
        wsadminCell   = AdminControl.getCell()
        wsadminServer = AdminControl.getAttribute(wsadminSvr,"name")
        debugNotice(msgPrefix+"Connected to Cell="+wsadminCell+" Server="+wsadminServer)
        wsadminVers   = AdminControl.getAttribute(wsadminSvr, "platformVersion")
        wsadminSvrId  = AdminControl.getConfigId( wsadminSvr)
        #wsadminType   = AdminConfig.showAttribute(wsadminSvrId, "serverType")
        wsadminState  = AdminControl.getAttribute(wsadminSvr, "state")
        debugNotice(msgPrefix+"Connected to ServerVers="+wsadminVers+" ServerState="+wsadminState)

    except:
        typ, value, tb = sys.exc_info()
        if (typ==SystemExit):  raise SystemExit,`val`
        fail(msgPrefix+ getExceptionText(typ, value, tb))
        #endTry
#endDef


# getNLText - Given a key looks up the translated text from the resource bundle
def _getNLS(key, resourceBundle):
    msgPrefix = "_getNLS(key="+key+"): "
    #global _resourceBundle_
    if (resourceBundle ==None):
       return _bundleError_
    #endIf
    try:
       txt = resourceBundle.getString(key)
       return txt
    except:
       typ, value, tb = sys.exc_info()
       #value = value.toString()
       value = `value`
       if (value.startswith("java.util.MissingResourceException")): 
          return "!" + key + "!";
       else:
          warningNotice(msgPrefix+getExceptionText(typ, value, tb) )
          print tb.dumpStack()
          return "!" + key + "!";  
       #endIf
    #endTry
#endDef


# get format NLS    
def _formatNLS(resourceBundle, key, params):
    msgPrefix = "_formatNLS(key="+key+", params="+`params`+"): "
    t = type(params).toString()
    if (t=="class org.python.core.PyString"):
       params = [params]
    #endIf
    txt = _getNLS(key, resourceBundle)
    if (txt.startswith("!") and txt.endswith("!")):
       infoNotice(msgPrefix+"could not find NLString "+key)    
       return txt
    #endIf
    try:
       txt = java.text.MessageFormat.format(txt, params)
    except:
       typ, value, tb = sys.exc_info()
       infoNotice(msgPrefix+getExceptionText(typ, value, tb) )
    #endTry
    return txt
#endDef


# convert param string "param1=param1Value, param2=param2Value, ..." to list 
def convertParamStringToList(paramString):
    if (len(paramString) > 0):
        paramString1 = str(paramString)
        #print paramString1
        newlist = []
        if (paramString1.startswith("[[") == 0 and paramString1.endswith("]]") == 0):
            if (paramString1.find(",") > 0):
                paramString1 = paramString1.split(",")
                for param in paramString1:
                    param = param.strip().split("=")
                    newlist1 = []
                    for p in param:
                        newlist1.append(p.strip())
                    newlist.append(newlist1)
            else:
                paramString1 = paramString1.split('=')
                newlist1 = []
                for param in paramString1:
                    newlist1.append(param.strip())
                newlist.append(newlist1)
            #endIf
            paramString = newlist
        #endIf
    #endIf 
    return paramString
#endDef

# get scope containment path from various scope formats
def getScopeContainmentPath(scope, failonerror=_BLANK_):
    # scope in containment path /Cell:cellName/Node:nodeName
    if (scope.find(":") > 0 and scope.find("=") < 0):
       # special handling for a server scope that has missed node
       if (scope.find("Server:") > 0):
          if (scope.find("Node:") < 0):
             print "Warning: the Node is missing in the scope and it may not work in some script procedures."
       if (scope[0] != "/"):
          scope = "/" + scope
          if (scope[len(scope)-1] != "/"):
             scope = scope + "/"
                       
    # scope in config id       
    if (scope.find(".xml") >0):
       #scopeId = scope
       if (scope.find("cell.xml") > 0):
          scope = "/Cell:"+scope[0:scope.find("(")]+"/"
       elif (scope.find("node.xml") > 0):
          scope = "/Cell:"+scope[scope.find("cells/")+6:scope.find("/nodes")]+"/Node:"+scope[0:scope.find("(")]+"/"
       elif (scope.find("server.xml") > 0):
          scope = "/Cell:"+scope[scope.find("cells/")+6:scope.find("/nodes")]+"/Node:"+scope[scope.find("nodes/")+6:scope.find("/servers")]+"/Server:"+scope[0:scope.find("(")]+"/"
       elif (scope.find("cluster.xml") > 0):
          scope = "/Cell:"+scope[scope.find("cells/")+6:scope.find("/clusters")]+"/ServerCluster:"+scope[0:scope.find("(")]+"/"
       #endIf
                   
    # scope in Cell=cellName:Node=nodeName:Server=serverName 
    if (scope.find("=") > 0):
       scope = " " + scope
       if (scope.find(",") > 0):
          scope = scope[0:scope.find(",")]+":"+scope[scope.find(",")+1:len(scope)]
          # for Cell=cellName,Node=nodeName,Server=serverName case
          if (scope.find(",") > 0):
              scope = scope[0:scope.find(",")]+":"+scope[scope.find(",")+1:len(scope)]
       # server scope 
       if (scope.find("Server=") > 0 or scope.find("server=") > 0):
          if (scope.find("Node=") > 0 or scope.find("node=") > 0):
             scope = "/Node:"+scope[scope.find("ode=")+4:scope.find(":")]+"/Server:"+scope[scope.find("erver=")+6:len(scope)]+"/"
          elif (scope.find("Node=") < 0 or scope.find("node=") < 0):
             print "Warning: the Node is missing in the scope and it may not work in some script procedures."
             scope = "/Server:"+scope[scope.find("erver=")+6:len(scope)]+"/"
       # node scope
       elif ((scope.find("Node=") > 0 or scope.find("node=") > 0) and scope.endswith(":") == 0):
          scope = "/Node:"+scope[scope.find("ode=")+4:len(scope)]+"/"
       # cluster scope
       elif (scope.find("Cluster=") > 0 or scope.find("cluster=") > 0):
          if (scope.find("Cell=") > 0 or scope.find("cell=") > 0):
             scope = "/Cell:"+scope[scope.find("ell=")+4:scope.find(":")]+"/ServerCluster:"+scope[scope.find("luster=")+7:len(scope)]+"/"
          else:
             scope = "/ServerCluster:"+scope[scope.find("luster=")+7:len(scope)]+"/"
       # cell scope
       elif ((scope.find("Cell=") > 0 or scope.find("cell=") > 0) and scope.endswith(":") == 0):
              scope = "/Cell:"+scope[scope.find("ell=")+4:len(scope)]+"/"
    #endif  
    return scope
#endDef    

# convert param list [-param1, value1, -param2, value2, ...] to String
def convertParamListToString(paramList):
    stringParam = "["
    for param in paramList:
	stringParam = stringParam + param + " "
    stringParam = stringParam + "]"
    return stringParam
#endDef
