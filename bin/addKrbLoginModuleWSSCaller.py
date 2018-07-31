#
# IBM Confidential OCO Source Material
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp. 1997, 2009
# The source code for this program is not published or otherwise divested
# of its trade secrets, irrespective of what has been deposited with the
# U.S. Copyright Office.
#

#---------------------------------------------------------------------------
# This script modifies the JAAS system login module with
# alias named wss.caller to include the WebSphere Kerberos
# system login module. This script is for JAX-WS Web services
# applications using Kerberos token.
#
# Run this script in the <bin> directory of each created profile
# that is configured with the JAX-WS Web services applications.
#
# For example, before the execution, the wss.caller JAAS login module is
#
#    <entries xmi:id="JAASConfigurationEntry_1185820116312" alias="wss.caller">
#      <loginModules xmi:id="JAASLoginModule_1185820116328" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.PreCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116343" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.UNTCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116359" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.X509CallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116375" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPACallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116390" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPAPropagationCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116391" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.KRBCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116421" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.WSWSSLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116437" moduleClassName="com.ibm.ws.security.server.lm.ltpaLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1185820116453" moduleClassName="com.ibm.ws.security.server.lm.wsMapDefaultInboundLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#
# After execution, the wss.caller JAAS login module becomes
#
#    <entries xmi:id="JAASConfigurationEntry_1224777684437" alias="wss.caller">
#      <loginModules xmi:id="JAASLoginModule_1224777684484" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.PreCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684562" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.UNTCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684625" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.X509CallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684671" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPACallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684750" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPAPropagationCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684796" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.KRBCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684843" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.WSWSSLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684875" moduleClassName="com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684906" moduleClassName="com.ibm.ws.security.server.lm.ltpaLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1224777684937" moduleClassName="com.ibm.ws.security.server.lm.wsMapDefaultInboundLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#
# For each profile, typical syntax would be:
#   wsadmin.sh -conntype NONE -lang jython -f $WAS_HOME/bin/addKrbLoginModuleWSSCaller.py
#
#---------------------------------------------------------------------------

import sys

#########################################
#
# Open security.xml 
#
#########################################

sec = AdminConfig.getid("/Cell:/Security:/" )

#########################################
#
# Locate systemLoginConfig 
#
#########################################

slc = AdminConfig.showAttribute(sec, "systemLoginConfig" )

#########################################
#
# Locate wss.caller login entry
#
#########################################

jaasLoginAliases = []
entryNames = []
moduleClassName = {}
authStrategy = {}
optionsList = {}
optionsProperties = {}
wasKRBlmfound = "false"

try :
  jaasLogins = AdminConfig.list('JAASConfigurationEntry', slc).splitlines()
  for jaasLogin in jaasLogins :
     theAlias = AdminConfig.showAttribute(jaasLogin, 'alias').split("\r\n")
     for aliasName in theAlias :
        if cmp(aliasName,"wss.caller") == 0 :
           jaasLoginAliases.append([theAlias, jaasLogin])
           login_ID = jaasLoginAliases[0][1]
           rawLMList = AdminConfig.showAttribute(login_ID, 'loginModules')
           LMList = rawLMList[1:len(rawLMList)-1].split()

#########################################
#
# Read content from old wss.caller login 
# entry
#
#########################################
           for entry in LMList :
             entryNames.append(entry)
             moduleName = AdminConfig.showAttribute(entry, 'moduleClassName')
             moduleClassName[entry] = moduleName
             authn = AdminConfig.showAttribute(entry,'authenticationStrategy')
             authStrategy[entry] = authn
             options = AdminConfig.showAttribute(entry, 'options')
             optionList = options[1:len(options)-1].split()
             optionsList[entry] = optionList
             count = len(optionsList[entry])
             if count > 0 :
               for prop in optionList :
                 keyName = prop + ':name'
                 optionsProperties[keyName] = AdminConfig.showAttribute(prop, 'name')
                 keyName = prop + ':value'
                 optionsProperties[keyName] = AdminConfig.showAttribute(prop, 'value')
                 keyName = prop + ':required'
                 optionsProperties[keyName] = AdminConfig.showAttribute(prop, 'required')

#########################################
#
# Update wss.caller login 
#
#########################################
           AdminConfig.remove(login_ID)
           newJAASConfigurationEntryId = AdminConfig.create("JAASConfigurationEntry", slc, [["alias", "wss.caller"]] )
           print "Updating JAAS Login Entry..."
           for en in entryNames :
             mClassName = moduleClassName[en]
             if cmp(mClassName, "com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule") == 0 :
               print "com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule already existed. Check security configuration."
               wasKRBlmfound = "true"

           for e1 in entryNames :
             mClassName = moduleClassName[e1]
             authStrag  = authStrategy[e1]
             if cmp(mClassName, "com.ibm.ws.security.server.lm.ltpaLoginModule") == 0 :
               if wasKRBlmfound == "false" :
                 newJAASLoginModuleId = AdminConfig.create("JAASLoginModule", newJAASConfigurationEntryId, [["moduleClassName", "com.ibm.ws.security.auth.kerberos.WSKrb5LoginModule"]] )
                 AdminConfig.modify(newJAASLoginModuleId, [["authenticationStrategy", "REQUIRED"]] )
             newJAASLoginModuleId = AdminConfig.create("JAASLoginModule", newJAASConfigurationEntryId, [["moduleClassName", mClassName]])
             AdminConfig.modify(newJAASLoginModuleId, [['authenticationStrategy', authStrag]])
             oplst = optionsList[e1]
             if len(oplst) > 0 :
                for prop in oplst :
                  kname = prop + ":name"
                  theName = optionsProperties[kname]
                  kname = prop + ":value"
                  theValue = optionsProperties[kname]
                  kname = prop + ":required"
                  requiredValue = optionsProperties[kname]
                  if len(requiredValue) > 0 :
                    AdminConfig.create("Property",  newJAASLoginModuleId, [['name', theName], ['value', theValue], ['required', requiredValue]])
                  if len(requiredValue) == 0 :
                    AdminConfig.create("Property",  newJAASLoginModuleId, [['name', theName],['value', theValue]])

#########################################
#
# save the change
#
#########################################
  if wasKRBlmfound == "false" :
    AdminConfig.save( )
    print "System JAAS login entry wss.caller has been updated."

#
#
#
#########################################
#
# Failure occurred.
#
#########################################
except :
  print "Unable to update the wss.caller system JAAS configuration entry in security.xml"

#
#
