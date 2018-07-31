#--------------------------------------------------------------
# Script to update bindings.xml in the WSSecurity policy type:
# 1. remove the basicAuth elements, 
#     <basicAuth userid="user1" password="{xor}LDo8Ki02KyY="/>,
# from the gen_signunametoken, gen_signltpatoken, and con_unametoken in the bindings.xml file
# 
# 2. Add the following properties under the right elements
#    2.1 Add the following properties under con_unametoken
#      <properties name="com.ibm.wsspi.wssecurity.token.username.verifyTimestamp" value="true"/>
#      <properties name="com.ibm.wsspi.wssecurity.token.username.verifyNonce" value="true"/>
#    2.2 Add the following properties under gen_signunametoken
#      <properties name="com.ibm.wsspi.wssecurity.token.username.addTimestamp" value="true"/>
#      <properties name="com.ibm.wsspi.wssecurity.token.username.addNonce" value="true"/>
#  
# Typical syntax would be:
#   wsadmin.sh -conntype NONE -lang jython -f updateBindings.py
#
#--------------------------------------------------------------

bindings = AdminTask.getBinding(["-policyType", "WSSecurity", "-bindingLocation", "", "-attributes", [""]])
bindings = bindings[2:len(bindings)-2]
bindingProperties = bindings.split("] [")
found = "false"
result = "false"
for bindingProperty in bindingProperties:
        nameValue = bindingProperty.split(" ")
	value = nameValue[1]
	# find the right token generator or the token consumer. If none is found, then do nothing and exit
	if value == "gen_signunametoken" or value == "gen_signltpatoken" or value == "con_unametoken":
		print "\nUpdating "+value+"..."
		found = "true"
		namePrefix = nameValue[0][0:nameValue[0].find('.name')]
		if namePrefix.startswith('application.securityoutboundbindingconfig.tokengenerator') or namePrefix.startswith('application.securityinboundbindingconfig.tokenconsumer'):
			callbackhandler=namePrefix+".callbackhandler"
			basicAuthProperty = callbackhandler+".basicauth"
			timeStampPropertyName = callbackhandler+".properties_998.name"
			timeStampPropertyValue = callbackhandler+".properties_998.value"
			noncePropertyName = callbackhandler+".properties_999.name"
			noncePropertyValue = callbackhandler+".properties_999.value"
			
			existingBasicAuthProperty = AdminTask.getBinding(["-policyType", "WSSecurity", "-bindingLocation", "", "-attributes", [basicAuthProperty]])
			# Check to see if basic auth element exists
			if existingBasicAuthProperty != '':
				print "Remove basicauth property from "+value+"."
				AdminTask.setBinding(["-policyType", "WSSecurity", "-bindingLocation", "", "-attributes", [[basicAuthProperty,[[]]]]])
				#update the bindings based on the token type and name
				if value == "gen_signunametoken":
					print "gen_signunametoken found.  Add addTimestamp and addNonce properties"
					AdminTask.setBinding(["-policyType", "WSSecurity", "-bindingLocation", "", "-attributes", [[timeStampPropertyName, "com.ibm.wsspi.wssecurity.token.username.addTimestamp"],[timeStampPropertyValue, "true"],[noncePropertyName, "com.ibm.wsspi.wssecurity.token.username.addNonce"],[noncePropertyValue, "true"]]]) 
				result = "true" 
				print value+" updated successfully\n"
			else:
				print "No basicAuth information found in the "+value
				if value == "con_unametoken":
					print "con_unametoken found.  Add verifyTimestamp and verifyNonce properties"
					AdminTask.setBinding(["-policyType", "WSSecurity", "-bindingLocation", "", "-attributes", [[timeStampPropertyName, "com.ibm.wsspi.wssecurity.token.username.verifyTimestamp"],[timeStampPropertyValue, "true"],[noncePropertyName, "com.ibm.wsspi.wssecurity.token.username.verifyNonce"],[noncePropertyValue, "true"]]])
					result = "true"
					print value+" updated successfully\n"
if found == "false":
	print "No gen_signunametoken, gen_signltpatoken, or con_unametoken entry found."      
elif result == "false":
	print "No WSSecurity bindings.xml was updated"
elif result == "true":
	print "WSSecurity bindings.xml has been updated successfully."
	AdminConfig.save() 	


