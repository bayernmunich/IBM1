#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for setting 64 bit mode in ZOS ODR templates in ND 7.0+ only.
#
# author: miksmith

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

def getConfigIdForTemplate(templateName):
   templates=convertToList(AdminConfig.listTemplates("Server"))
   for template in templates:
       cname = AdminConfig.showAttribute(template,"name")
       if (cname == templateName):
          return template
   return ""

enabled64bitset = 0
javahomeset = 0
templates=["odr_zos"]
for template in templates:
    print "processing template:"+template
    templateID=getConfigIdForTemplate(template)
    if (templateID != ""):
       
       print "processing templateID:"+templateID
       templateVARID = AdminConfig.list('VariableMap', templateID)
       print "processing templateVARID:"+templateVARID
       
       procDefs = convertToList(AdminConfig.showAttribute(templateID,"processDefinitions"))
       for procDef in procDefs:
          startCommandArgs = AdminConfig.showAttribute(procDef, "startCommandArgs")
          print "processing startCommandArgs:"+startCommandArgs
          #Modify to empty string to get around modify bug.  If the empty string is removed the  next modify
          #will append the new string to the old one.
          AdminConfig.modify(procDef,[['startCommandArgs',""]])
          AdminConfig.modify(procDef,[['startCommandArgs',"AMODE=64,"+startCommandArgs]])
          envattrs1 = ['name', 'was.com.ibm.websphere.zos.jvmmode']
          envattrs2 =['value','64bit']
          attrenv1 = [envattrs1,envattrs2]
          AdminConfig.modify(procDef,[['environment',[attrenv1]]])
          startCommandArgs = AdminConfig.showAttribute(procDef, "startCommandArgs")
          print "startCommandArgs updated:"+startCommandArgs

       print "PROCESS the variable Map" 
       vmaps = AdminConfig.list("VariableMap", templateVARID).split("\n")
       for tempVmap in vmaps:
          vmap = tempVmap
         
       print "process the VariableSubstitutionEntry"
       varSubstitutions = AdminConfig.list("VariableSubstitutionEntry",vmap).split("\n")  
       
       for varSubst in varSubstitutions:
          print "Variable Substitution loop"+varSubst
          unset = "unset"
          if (varSubst == ""):
             varSubst = None
          
          if (varSubst == None):
             print "Create the Variable SubstitutionEntry for JAVA_HOME"
             jaattrs = [['symbolicName', 'JAVA_HOME'], ['value', '${WAS_HOME}/java64']]
             AdminConfig.create('VariableSubstitutionEntry', vmap, jaattrs)	
             print "Create the Variable SubstitutionEntry for enable 64 bit"
             bitattrs = [['symbolicName', 'private_Enable_zWAS_for_64bit'], ['value', 'true']]
             AdminConfig.create('VariableSubstitutionEntry', vmap, bitattrs)
             unset = "set"

          if (unset == "unset"):
             getVarName = AdminConfig.showAttribute(varSubst, "symbolicName")
             if (getVarName == "JAVA_HOME"):
                AdminConfig.modify(varSubst,[["symbolicName", "JAVA_HOME"]])
                AdminConfig.modify(varSubst,[["value", "${WAS_HOME}/java64"]])
                print "JAVA_HOME for 64 bit"
             else:
                if (getVarName == "private_Enable_zWAS_for_64bit"):
                   AdminConfig.modify(varSubst,[["symbolicName", "private_Enable_zWAS_for_64bit"]])
                   AdminConfig.modify(varSubst,[["value", "true"]])
                   AdminConfig.modify(varSubst,[["description","64bit JVM variable"]])
                   print "enable the private_Enable_zWAS_for_64bit"
            

print "saving workspace"
AdminConfig.save()
print "finished."
