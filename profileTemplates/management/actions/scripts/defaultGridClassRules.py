#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultGridClassRules - creates default GridClassRules named "Default_Rules"
# 
#
# @author - Andrew Chen
# Date Created: 08/03/2006
# Last Updated: 04/21/2007
#

import java.lang.Integer as Integer
import java.util.ArrayList as ArrayList
import java.lang.Exception as JavaException
import java.rmi.server.UID as UID
import java.lang.String as String
import sys
import re


lineSeparator = java.lang.System.getProperty('line.separator')


##
# Entry point to excute multiple actions if GridClassRules type exists.
#
##
def main():
	i=isTypeDefined('GridClassRules')
	if (i==1):
		print "creating... predefined transaction classes"
		addPredefinedTCsInDefaultSP()
		
		#print "creating... DefaultGridClassRules"
		createDefaultRulesForGrid()
	else:
		print "No action performed in this script."
	

##
# Query WAS config repositorty to get a list of transaction classes defined in gridclassrules.xml, if any.
# Then add these predefined transaction classses into Default_SP.
#
##
def addPredefinedTCsInDefaultSP():	
	defaultTCStr="Default_TC"

	# first find the Default_Rules object

	drs=AdminConfig.getid('/GridClassRules:Default_Rules/')
	if(drs==""):
		return 0
		
	
	# get the transaction class defined as the matchAction attribute in Default_Rules	
	dma=AdminConfig.showAttribute(drs, 'matchAction')
	
	
	# set it to DefaultTC if undefined
	if(dma == ""):
		AdminConfig.modify(drs, [['matchAction', defaultTCStr]])
		print "Modifying matchAction attribute for GridMatchRule..." + dma
		AdminConfig.save()
	else:
		print "creating transaction class " + dma
		createTransactionClass(dma)		
		AdminConfig.modify(drs, [['matchAction', dma]])
		
	# find the list of matchRules defined in Default_Rules	
	rl=AdminConfig.list('GridMatchRule')
	if(rl != ""):		
		gmrList=rl.split(lineSeparator)
		for gmr in gmrList:			
			gmr= "GridMatchRule" + gmr
			print "find GridMatchRule: " + gmr
			maName=AdminConfig.showAttribute(gmr, 'matchAction')
			if(maName==""):
				AdminConfig.modify(gmr, [['matchAction', defaultTCStr]])
				print "Modifying matchAction attribute for Default_Rules ..."
				AdminConfig.save()
			elif (maName[0]!='$'):		
				createTransactionClass(maName)				
				AdminConfig.modify(gmr, [['matchAction', maName]])     
	else:
		print "no instances of GridMatchRule found"
	
	return 1

##
# Create transaction class using the given name in the default service policy Default_SP
#
##

def createTransactionClass(tcname):  
	spid = AdminConfig.getid("/ServiceClass:Default_SP")
	tcd = ""
	r=isTransactionClassNameUnique(tcname)
	if(r==1):
  		# finished processing paraemeters, now create the transaction class
  		print "Creating Transaction Class ..." + tcname
  		tcid = AdminConfig.create("TransactionClass", spid, [["name",tcname],["description", tcd]],"TransactionClasses")
  		print "Saving Transaction Class ..."
  		AdminConfig.save()
  		print "Transaction Class successfully created. New Transaction Class id ="+tcid
  	else:	
  		print "Transaction class of name "+tcname+" can not be created."  		
  	
  	
  			
##
# Determin whether the given transaction class name is unique within the cell
#
##

def isTransactionClassNameUnique(tcname):  
	tcids = AdminConfig.list("TransactionClass")
	tcList = tcids.split(lineSeparator)
	for tc in tcList:
       		if (tc.split("(")[0] == tcname):
        		print "Transaction class of name "+tcname+" already exists."
        		return 0
      	
        return 1
  
##
# Creates two Default match rules for Grid, create Default GridClassRules if not defined.
# 
##
def createDefaultRulesForGrid():	
	defaultGridClassRules=AdminConfig.getid("/GridClassRules:Default_Rules")
	
	cell=AdminConfig.list("Cell")
	if (defaultGridClassRules==""):
   		gcrattributes = [["name","Default_Rules"], ["matchAction", "Default_TC"], ["type", "Grid"], ["description","This is a default classification rule set."]]
		defaultGridClassRules=AdminConfig.create("GridClassRules",cell, gcrattributes)
		print "Default Grid Class Rules created."
	# comment out for 6.1, revisit in 6.1.0.1	
	#else:
		i=findLastPriority(defaultGridClassRules)
   		# Create the default rule 1: if application-type='j2ee' then classify to ${default_iiop_transaction_class}
		expr="apptype='j2ee'"
		txclassName="${default_iiop_transaction_class}"
		priority=i+1
		ruleAttributes = [["matchAction",txclassName],["matchExpression",expr],["priority",priority]]
		defaultRuleOne=AdminConfig.create("GridMatchRule",defaultGridClassRules,ruleAttributes)
        	
		# Create the default rule 2: if jobname=*, then classify to transaction class Default_TC
		expr="jobname LIKE '%'"
		txclassName="Default_TC"
		priority=i+2
		ruleAttributes = [["matchAction",txclassName],["matchExpression",expr],["priority",priority]]
		defaultRuleTwo=AdminConfig.create("GridMatchRule",defaultGridClassRules,ruleAttributes)
	
	print "saving workspace"
	AdminConfig.save()

##
# Query WAS config repositorty to see if the type is defined.
#
##

def isTypeDefined(aType):
	allTypes=AdminConfig.types()
	tpList = allTypes.split(lineSeparator)
	for tp in tpList:
		if (tp.split("(")[0] == aType):
	        	return 1
	        	
	print aType + " undefined"        	
	return 0	   
	
##
# Query WAS config repositorty to see if the type is defined.
#
##

def findLastPriority(gcrId):
	i=0
	
	rl=AdminConfig.list('GridMatchRule')
	if(rl != ""):
		gmrList=rl.split(lineSeparator)
		for gmr in gmrList:		
			gmr= "GridMatchRule" + gmr
			print "find GridMatchRule: " + gmr
			order=AdminConfig.showAttribute(gmr, 'priority')
			print "--the priority is: " + order
			o=int(order)
			if(i<o):
				i=o
        else:                                                                  
		print "no instances of GridMatchRule found"                    
	return i

print "starting the execution of defaultGridClassRules.py"
main()


print "finished."
