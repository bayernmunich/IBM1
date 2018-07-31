#
# IBM Confidential OCO Source Material
# 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp. 2009
# The source code for this program is not published or otherwise divested
# of its trade secrets, irrespective of what has been deposited with the
# U.S. Copyright Office.
#

#---------------------------------------------------------------------------
# This script modifies the JAAS system login module with
# alias named wss.caller to include the WebSphere SAML
# system login module. This script is for JAX-WS Web services
# applications using SAML token.
#
# Run this script in the <bin> directory of each created profile
# that is configured with the JAX-WS Web services applications.
#
# After execution, this script will generate two systemLoginConfig
#  similar to the following
#
#    <entries xmi:id="JAASConfigurationEntry_1244758654506" alias="wss.generate.saml">
#      <loginModules xmi:id="JAASLoginModule_1244840556749" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.SAMLGenerateLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244840556750" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.DKTGenerateLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#    <entries xmi:id="JAASConfigurationEntry_1244758654802" alias="wss.consume.saml">
#      <loginModules xmi:id="JAASLoginModule_1244840556843" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.SAMLConsumeLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244840556844" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.DKTConsumeLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#    <entries xmi:id="JAASConfigurationEntry_1185820116203" alias="wss.consume.issuedToken">
#      <loginModules xmi:id="JAASLoginModule_1185820116218" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.GenericIssuedTokenConsumeLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#    <entries xmi:id="JAASConfigurationEntry_1185820116204" alias="wss.generate.issuedToken">
#      <loginModules xmi:id="JAASLoginModule_1185820116219" moduleClassName="com.ibm.ws.wssecurity.wssapi.token.impl.GenericIssuedTokenGenerateLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#
#
# Executing this script will also update the wss.caller systemLoginConfig 
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
#    <entries xmi:id="JAASConfigurationEntry_1185820116312" alias="wss.caller">
#      <loginModules xmi:id="JAASLoginModule_1244836423625" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.PreCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423641" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.UNTCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423642" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.X509CallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423656" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPACallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423672" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.LTPAPropagationCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423673" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.KRBCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423688" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.SAMLCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423690" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.GenericIssuedTokenCallerLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423689" moduleClassName="com.ibm.ws.wssecurity.impl.auth.module.WSWSSLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423703" moduleClassName="com.ibm.ws.security.server.lm.ltpaLoginModule" authenticationStrategy="REQUIRED"/>
#      <loginModules xmi:id="JAASLoginModule_1244836423704" moduleClassName="com.ibm.ws.security.server.lm.wsMapDefaultInboundLoginModule" authenticationStrategy="REQUIRED"/>
#    </entries>
#
# For each profile, typical syntax would be:
#   wsadmin.sh -conntype NONE -lang jython -f $WAS_HOME/bin/addSamlLoginConfigs.py
#
#---------------------------------------------------------------------------


################################################
#
# Add SAML system login configurations
#
################################################

AdminTask.configureJAASLoginEntry('[-loginType system -loginEntryAlias "wss.generate.saml" -loginModules "com.ibm.ws.wssecurity.wssapi.token.impl.SAMLGenerateLoginModule,com.ibm.ws.wssecurity.wssapi.token.impl.DKTGenerateLoginModule" -authStrategies "REQUIRED,REQUIRED" ]')
print "systemLoginConfig alias=wss.generate.saml has been defined."

AdminTask.configureJAASLoginEntry('[-loginType system -loginEntryAlias "wss.consume.saml" -loginModules "com.ibm.ws.wssecurity.wssapi.token.impl.SAMLConsumeLoginModule,com.ibm.ws.wssecurity.wssapi.token.impl.DKTConsumeLoginModule" -authStrategies "REQUIRED,REQUIRED" ]')
print "systemLoginConfig alias=wss.consume.saml has been defined."

AdminTask.configureJAASLoginEntry('[-loginType system -loginEntryAlias "wss.generate.issuedToken" -loginModules "com.ibm.ws.wssecurity.wssapi.token.impl.GenericIssuedTokenGenerateLoginModule" -authStrategies "REQUIRED" ]')
print "systemLoginConfig alias=wss.generate.issuedToken has been defined."

AdminTask.configureJAASLoginEntry('[-loginType system -loginEntryAlias "wss.consume.issuedToken" -loginModules "com.ibm.ws.wssecurity.wssapi.token.impl.GenericIssuedTokenConsumeLoginModule" -authStrategies "REQUIRED" ]')
print "systemLoginConfig alias=wss.consume.issuedToken has been defined."

################################################
#
# Update caller system login configurations
#
################################################

def addLoginModule(newLoginModule):    
    global AdminTask

    loginModulesList = []
    loginModulesString = ""

    # Get the current list of login modules
    loginObjs = AdminTask.listLoginModules('-loginType system -loginEntryAlias wss.caller ]')
    if len(loginObjs) > 0:
        loginsModuleObjs = loginObjs.splitlines()
        for loginModuleObj in loginsModuleObjs :
            loginModuleLen = len(loginModuleObj) - 1
            loginModuleAttrs = loginModuleObj.split("] [")
            for loginModuleAttr in loginModuleAttrs :
                cleanModuleAttr = loginModuleAttr.replace("]", '').replace("[", '')
                cleanModuleAttrLen = len(cleanModuleAttr)
                attrs = cleanModuleAttr.split(" ")
                if attrs[0] == "moduleClassName" :
                    loginModulesList.append(attrs[1])

    for login in loginModulesList :
        if login == newLoginModule:
            print newLoginModule + " has already been defined in wss.caller"
            continue
        if len(loginModulesString) > 0:
            if login == "com.ibm.ws.wssecurity.impl.auth.module.WSWSSLoginModule":
                loginModulesString = loginModulesString + "," + newLoginModule
            loginModulesString = loginModulesString + "," + login
        else:
            loginModulesString = login

    AdminTask.configureJAASLoginEntry('[-loginType system -loginEntryAlias wss.caller -loginModules ' + loginModulesString + ' ]')

#call method to add the login module
addLoginModule("com.ibm.ws.wssecurity.impl.auth.module.SAMLCallerLoginModule")  
addLoginModule("com.ibm.ws.wssecurity.impl.auth.module.GenericIssuedTokenCallerLoginModule")  
print "systemLoginConfig alias=wss.caller has been updated."

print "systemLoginConfig alias=wss.caller has been updated."

################################################
#
# save the change
#
################################################

AdminConfig.save( )
