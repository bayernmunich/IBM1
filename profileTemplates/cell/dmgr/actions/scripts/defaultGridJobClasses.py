#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# defaultGridJobClasses - creates a default Grid JobClass
# 
#
# @author - Andrew Chen
# Date Created: 08/21/2005
#

import java.lang.Integer as Integer
import java.util.ArrayList as ArrayList
import java.lang.Exception as JavaException
import java.rmi.server.UID as UID



      
##
# Creates a Default JobClass.
#
##
def createDefaultGridJobClasses():  
   
   DefaultJobClass=AdminConfig.getid("/JobClass:Default")
   cell=AdminConfig.list("Cell")
   if (DefaultJobClass==""):
   	unlimited=0
   	
   	gjcattributes = [["name","Default"], ["description","This is a default grid job class."]]
	DefaultJobClass=AdminConfig.create("JobClass",cell, gjcattributes)
	   
   	# Create the default CPUAndThreadLimit for the default job class	
	cLimitAttributes = [["maxExecutionTime", unlimited], ["maxConcurrentJob", unlimited]]
	executionTimeAndThreadLimit = AdminConfig.create("ExecutionTimeAndThreadLimit",DefaultJobClass, cLimitAttributes)

	# Create the default JobLogLimit for the default job class
	jLimitAttributes = [["maxClassSpace", unlimited], ["maxFileAge", unlimited]]	
	jobLogLimit = AdminConfig.create("JobLogLimit",DefaultJobClass, jLimitAttributes)
	
	# Create the default OutputQueueLimit for the default job class
	oLimitAttributes = [["maxJob", unlimited], ["maxJobAge", unlimited]]	
	outputQueueLimit = AdminConfig.create("OutputQueueLimit",DefaultJobClass, oLimitAttributes)
   


print "creating... Default JobClass"
createDefaultGridJobClasses()
print "Default Grid Job Class created."

print "saving workspace"
AdminConfig.save()
print "finished."
