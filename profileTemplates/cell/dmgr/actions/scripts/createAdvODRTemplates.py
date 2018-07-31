#  This program may be used, executed, copied, modified and distributed
#  without royalty for the purpose of developing, using, marketing, or distributing.

#
# script for creating SIP and SIP+HTTP ODR templates
#
# author: viarsb

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
   return None


print "creating sip odr template"
if (getConfigIdForTemplate("sip_odr_server") == None):
   AdminTask.createTemplateFromTemplate('[-sourceTemplate sip_proxy_server -sourceType PROXY_SERVER -destinationTemplate sip_odr_server -destinationType ONDEMAND_ROUTER -description "WebSphere SIP On Demand Router Template"]')

print "creating sip odr zOS template"
if (getConfigIdForTemplate("sip_odr_server_zos") == None):
   AdminTask.createTemplateFromTemplate('[-sourceTemplate sip_proxy_server_zos -sourceType PROXY_SERVER -destinationTemplate sip_odr_server_zos -destinationType ONDEMAND_ROUTER -description "WebSphere SIP zOS On Demand Router Template"]')

print "creating http+sip odr template"
if (getConfigIdForTemplate("http_sip_odr_server") == None):
   AdminTask.createTemplateFromTemplate('[-sourceTemplate http_sip_proxy_server -sourceType PROXY_SERVER -destinationTemplate http_sip_odr_server -destinationType ONDEMAND_ROUTER -description "WebSphere HTTP and SIP On Demand Router Template"]')

print "creating http+sip odr zOS template"
if (getConfigIdForTemplate("http_sip_odr_server_zos") == None):
   AdminTask.createTemplateFromTemplate('[-sourceTemplate http_sip_proxy_server_zos -sourceType PROXY_SERVER -destinationTemplate http_sip_odr_server_zos -destinationType ONDEMAND_ROUTER -description "WebSphere HTTP and SIP zOS On Demand Router Template"]')

print "saving workspace"
AdminConfig.save()
print "finished."

