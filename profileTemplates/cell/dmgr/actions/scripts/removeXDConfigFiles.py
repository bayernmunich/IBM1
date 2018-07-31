#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for deleting XD configuration objects
#
# author: bkmartin

import java.lang.Throwable as JavaThrowable

def convertToList(inlist):
     outlist=[]
     if (len(inlist)>0 and inlist[0]=='[' and inlist[len(inlist)-1]==']'):
        inlist = inlist[1:len(inlist)-1]
        clist = inlist.split(" ")
     else:
        clist = inlist.split("\n")
     for elem in clist:
        elem=elem.rstrip();
        if (len(elem)>0):
           outlist.append(elem)
     return outlist

def deleteDynamicClusters():
   print "searching for dynamic clusters"
   dcs=convertToList(AdminConfig.list("DynamicCluster"))
   for dc in dcs:
      dname = AdminConfig.showAttribute(dc,"name")
      print "deleting dynamic cluster: "+dname
      AdminConfig.remove(dc)

def deleteWorkClasses():
   print "searching for workclasses"
   workclasses=convertToList(AdminConfig.list("WorkClass"))
   for workclass in workclasses:
      wname = AdminConfig.showAttribute(workclass,"name")
      print "deleting workclass: "+wname
      AdminConfig.remove(workclass)

def deleteGridClassRules():
   print "searching for gridclassrules"
   gridclassrulesets=convertToList(AdminConfig.list("GridClassRules"))
   for gridclassrules in gridclassrulesets:
      gcrname = AdminConfig.showAttribute(gridclassrules,"name")
      print "deleting gridclassrules: "+gcrname
      AdminConfig.remove(gridclassrules)

def deleteJobClasses():
   print "searching for jobclasses"
   gridjobclasses=convertToList(AdminConfig.list("JobClass"))
   for jobclass in gridjobclasses:
      gjcname = AdminConfig.showAttribute(jobclass,"name")
      print "deleting jobclass: "+gjcname
      AdminConfig.remove(jobclass)
def deleteServiceClasses():
   print "searching for serviceclasses"
   serviceclasses=convertToList(AdminConfig.list("ServiceClass"))
   for serviceclass in serviceclasses:
      sname = AdminConfig.showAttribute(serviceclass,"name")
      print "deleting serviceclass: "+sname
      AdminConfig.remove(serviceclass)

def deleteHealthClasses():
   print "searching for healthclasses"
   healthclasses=convertToList(AdminConfig.list("HealthClass"))
   for healthclass in healthclasses:
      print "deleting healthclass: "+healthclass
      AdminConfig.remove(healthclass)
	  
def deleteHealthControllers():
   print "searching for healthcontrollers"
   healthcontrollers=convertToList(AdminConfig.list("HealthController"))
   for healthcontroller in healthcontrollers:
      print "deleting healthcontroller: "+healthcontroller
      AdminConfig.remove(healthcontroller)

def deleteEmailNotifications():
   print "searching for emailnotifications"
   emailnotifications=convertToList(AdminConfig.list("EmailNotifications"))
   for emailnotification in emailnotifications:
      print "deleting emailnotification: "+emailnotification
      AdminConfig.remove(emailnotification)

def deleteAPCService():
   print "searching for apcservice"
   apcservices=convertToList(AdminConfig.list("AppPlacementController"))
   for apcservice in apcservices:
      print "deleting apcservice: "+apcservice
      AdminConfig.remove(apcservice)

def deleteARFM():
   print "searching for ARFM"
   arfms=convertToList(AdminConfig.list("AutonomicRequestFlowManager"))
   for arfm in arfms:
      print "deleting arfm: "+arfm
      AdminConfig.remove(arfm)

def deleteForeignServers():
   print "searching for Foreign Servers"
   servers=convertToList(AdminConfig.list("Server"))
   for server in servers:
       try:
          stype = AdminConfig.showAttribute(server,"serverType")
       except JavaThrowable:
          stype = "UNKNOWN"

       if (stype == "PHP_SERVER" or
           stype == "APACHE_SERVER" or
           stype == "CUSTOMHTTP_SERVER" or
           stype == "TOMCAT_SERVER" or
           stype == "LIBERTY_SERVER" or
           stype == "WEBLOGIC_SERVER" or
           stype == "WASCE_SERVER" or
           stype == "JBOSS_SERVER"):
          sname = AdminConfig.showAttribute(server,"name")
          parts = server.split('/')
          nodename = parts[3]
          print "deleting server: "+sname+" on node "+nodename
          AdminTask.deleteServer("-serverName "+sname+" -nodeName "+nodename)

def deleteODRClusters():
    print "searching for ODR clusters"
    clusters = convertToList(AdminConfig.list("ServerCluster"))
    for cluster in clusters:
        try:
            ctype = AdminConfig.showAttribute(cluster,"serverType")
        except JavaThrowable:
            ctype = "UNKNOWN"
        if (ctype == "ONDEMAND_ROUTER"):
            cname = AdminConfig.showAttribute(cluster, "name")
            print "deleting cluster: " + cname 
            AdminConfig.remove(cluster)

def deleteODRs():
   print "searching for ODRs"
   servers=convertToList(AdminConfig.list("Server"))
   for server in servers:
       try:
          stype = AdminConfig.showAttribute(server,"serverType")
       except JavaThrowable:
          stype = "UNKNOWN"
       if (stype == "ONDEMAND_ROUTER"):
          sname = AdminConfig.showAttribute(server,"name")
          parts = server.split('/')
          nodename = parts[3]
          print "deleting server: "+sname+" on node "+nodename
          AdminTask.deleteServer("-serverName "+sname+" -nodeName "+nodename)

def deleteElasticityClasses():
   print "searching for elasticityclasses"
   elasticityclasses=convertToList(AdminConfig.list("ElasticityClass"))
   for elasticityclass in elasticityclasses:
       print "deleting elasticityclass: "+elasticityclass
       AdminConfig.remove(elasticityclass)
		  
		  
deleteODRClusters()
deleteODRs()
deleteForeignServers()
deleteDynamicClusters()
deleteWorkClasses()
deleteServiceClasses()
deleteHealthClasses()
deleteHealthControllers()
deleteEmailNotifications()
deleteAPCService()
deleteARFM()
deleteElasticityClasses()
print "saving workspace"
AdminConfig.save()
print "finished."
