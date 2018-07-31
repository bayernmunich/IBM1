#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultElasticityPolicies  - creates default Elasticity Polices
# @author - mcgillq
# Date Created: 4/12/2011
#

import sys
lineSeparator = java.lang.System.getProperty('line.separator')

def doesElasticityPolicyExist(elasticityPolicyName):
   hpids = AdminConfig.list("ElasticityClass")
   hpList = hpids.split(lineSeparator)
   for hp in hpList:
     hp = hp.rstrip()
     hp = hp.replace("\"","")
     if (hp.split("(")[0] == elasticityPolicyName):
        print "INFO: Elasticity policy of name "+elasticityPolicyName+" already exists."
        return 1
   return 0

def createAddElasticityPolicy():
   elasticityPolicyName="Add"
   if not doesElasticityPolicyExist(elasticityPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     ec=AdminConfig.create("ElasticityClass",cell,[["name",elasticityPolicyName],["description",""],["reactionMode","2"]])

def createRemoveElasticityPolicy():
   elasticityPolicyName="Remove"
   if not doesElasticityPolicyExist(elasticityPolicyName):
     cell=AdminConfig.list("Cell")
     cellname=AdminConfig.showAttribute(cell,"name")
     ec=AdminConfig.create("ElasticityClass",cell,[["name",elasticityPolicyName],["description",""],["reactionMode","2"]])

print "Creating... AddElasticityPolicy"
createAddElasticityPolicy()
print "Creating... RemoveElasticityPolicy"
createRemoveElasticityPolicy()
print "Saving workspace"
AdminConfig.save()
print "Finished."
