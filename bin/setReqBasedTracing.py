import sys
import java.lang.System as System
import java.util.ArrayList as ArrayList
import java.util.Iterator as Iterator
import java.lang.String as String
import javax.management as mgmt

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split("\"")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def getServerType(nodeName,serverName):
     server = convertToList(AdminConfig.getid("/Node:"+nodeName+"/Server:"+serverName+"/"))[0]
     serverType = AdminConfig.showAttribute(server,"serverType")
     return serverType

def getOdrName(dwlMbean):
    odrName = String(dwlmMbean)
    odrIdx = odrName.indexOf("process=")
    odrName = odrName.substring(odrIdx+8)
    odrName1 = String(odrName)
    odrIdx1 = odrName1.indexOf(',')
    odrname = odrName1.substring(0, odrIdx1)
    return odrname
    
def printEnableReqBasedTracingHelp(arg):
     if (arg != None):
        print "Unrecognized option: "+arg
     print "Available options:"
     print "\t-ruleID:<rule ID>                    rule ID for request based tracing. This parameters is optional. When this option is not specified ruleID will be calculated by the script."
     print "\t-ruleExpression:<rule expression>    rule expression for request based tracing"
     print "\t-odrTraceSpec:<trace string>         Trace string that needs to be set on the ODR servers. This is parameter is optional."
     print "\t-appServerTraceSpec:<trace string>   Trace string that needs to be set on the application servers. This is parameter is optional."

def printDisableReqBasedTracingHelp(arg):
     print "Unrecognized option: "+arg
     print "Available options:"
     print "\t-ruleIDs:<ruleID1,ruleID2,...,ruleIDn>    comma separated request based tracing rule IDs"

#
#  Start off main() program
#
ruleId = ""
ruleExpr = ""
option = ""
odrTraceSpec = ""
appServerTraceSpec = ""
if (len(sys.argv)==0):
   print "ERROR: A valid command must be specified. Valid commands are : enableReqBasedTracing, disableReqBasedTracing, listRuleIDs"
   sys.exit(1)

if (len(sys.argv)>0):
   option = sys.argv[0]
   ignore = 0
   if (option == "enableReqBasedTracing"):
       for arg in sys.argv:
           if (ignore == 0):
              ignore = 1
           elif (arg.startswith("-ruleID:")):
              parts = arg.split(":")
              ruleId=parts[1]
           elif (arg.startswith("-ruleExpression:")):
              parts = arg.split(":")
              ruleExpr=parts[1]
           elif (arg.startswith("-odrTraceSpec:")):
              parts = arg.split("-odrTraceSpec:")
              odrTraceSpec=parts[1]
           elif (arg.startswith("-appServerTraceSpec:")):
              parts = arg.split("-appServerTraceSpec:")
              appServerTraceSpec=parts[1]
           else:
              printEnableReqBasedTracingHelp(arg)
              sys.exit(1)
   elif (option == "disableReqBasedTracing"):
       for arg in sys.argv:
           if (ignore == 0):
              ignore = 1
           elif (arg.startswith("-ruleIDs:")):
              parts = arg.split(":")
              ruleId=parts[1]
           else:
              printDisableReqBasedTracingHelp(arg)
              sys.exit(1)
   elif (option == "listRuleIDs"):
       for arg in sys.argv:
           if (ignore == 0):
              ignore = 1
   else:
       print "ERROR: A valid command must be specified. Valid commands are : enableReqBasedTracing, disableReqBasedTracing, listRuleIDs"
       sys.exit(1)


if (option == "enableReqBasedTracing"):
    if (ruleExpr == None or ruleExpr == ""):
       print "ERROR: Rule expression cannot be null or empty when enabling request based tracing. Please specify rule expression using -ruleExpr parameter."
       printEnableReqBasedTracingHelp(None)
       sys.exit(1)
    elif (ruleId == None or ruleId == ""):
       ruleId = "ruleId-"+str(System.currentTimeMillis())
elif (option == "disableReqBasedTracing"):
    if (ruleId == None or ruleId == ""):
       print "ERROR: Rule ID cannot be null or empty when disabling request based tracing"
       sys.exit(1)

#
# find the ODR node
#
odrNodeName = ""
odrServerName = ""

nodes = convertToList(AdminConfig.list("Node"))
for node in nodes:
    nodeName = AdminConfig.showAttribute(node,"name")
    serverid = AdminConfig.getid("/Node:"+nodeName+"/Server:nodeagent/")
    servers = convertToList(AdminConfig.list("Server",node))
    if (serverid != None and serverid != ""):
        for server in servers:
          serverName = AdminConfig.showAttribute(server,"name")
          serverType = getServerType(nodeName, serverName)
          if (serverType == "ONDEMAND_ROUTER"):
             odrNodeName = nodeName
             odrServerName = serverName

dwlmMBeanStr="WebSphere:*,type=DWLMClient"
dwlmMBean = AdminControl.queryNames(dwlmMBeanStr)
dwlmMBeans = convertToList(dwlmMBean)
for dwlmMbean in dwlmMBeans:
    odrName = getOdrName(dwlmMbean)
    methodName = "disableEventTracing"
    if (option == "enableReqBasedTracing"):
        methodName = "enableEventTracing"
        params = [ruleId, ruleExpr, odrTraceSpec, appServerTraceSpec]
        signature = ['java.lang.String', 'java.lang.String', 'java.lang.String', 'java.lang.String']
        objName =  mgmt.ObjectName(dwlmMbean)
        rc = AdminControl.invoke_jmx(objName, methodName, params, signature)
        if (rc.startswith("SUCCESS:") == 1):
          print "Successfully enabled request based tracing for expression: \"" + ruleExpr + "\" on the ODR '" + odrName + "'. The rule ID is: " + ruleId
        elif (rc.startswith("FAILURE:") == 1):
          rcStr = String(rc)
          idx = rcStr.indexOf(':')
          print "Enable request based tracing failed on the ODR '" + odrName + "' with error message: \"" + rcStr.substring(idx+1) + "\""
    elif (option == "disableReqBasedTracing"):
        methodName = "disableEventTracing"
        rc = AdminControl.invoke(dwlmMbean, methodName, ruleId)
        if (rc.startswith("SUCCESS:") == 1):
          print "Successfully disabled request based tracing for rule IDs: " + ruleId + " on the ODR '" + odrName + "'"
        elif (rc.startswith("FAILURE:") == 1):
          rcStr = String(rc)
          idx = rcStr.indexOf(':')
          print "Disable request based tracing failed on the ODR '" + odrName + "' with error message: \"" + rcStr.substring(idx+1) + "\""
    elif (option == "listRuleIDs"):
        methodName = "queryEventTracing"
        objName =  mgmt.ObjectName(dwlmMbean)
        parms = []
        sig= []
        ruleIds = AdminControl.invoke_jmx(objName, methodName, parms, sig)
        if (ruleIds != None):
          iter = ruleIds.iterator()
          if (iter.hasNext()):
             print "Rule IDs on the ODR '" + odrName + "':"
             while (iter.hasNext()):
                 ruleIdStr = iter.next()
                 print "  " +  ruleIdStr
          else:
             print "No rule IDs found."
        else:
          print "No rule IDs found."
          
#End main
             