#
# This script provides two options for propagating a plugin-cfg.xml file
# to the location of the Web server plugin.
#
# (1) copyToRepository
#     From anywhere in the cell, copy a local plugin-cfg.xml into one or
#     more locations in the config repository.  This option can be used
#     only if there is a nodeagent on the web server machine.  In this case,
#     nodesync can then push the file out to the Web server's machine.
#
# (2) uploadToIHSAdminServer
#     Upload a local plugin-cfg.xml file to the IHS Admin Server.
#
# See the usage() method below.
#

import sys, httplib, base64, jarray
import javax.xml.parsers.DocumentBuilderFactory as DocumentBuilderFactory
import javax.xml.parsers.DocumentBuilder as DocumentBuilder
import org.xml.sax.InputSource as InputSource
import java.io.StringReader as StringReader
import java.net.URL as URL
import java.lang.Boolean as Boolean
import java.io.ByteArrayOutputStream as ByteArrayOutputStream
import java.io.File as File
import java.io.FileInputStream as FileInputStream
import java.io.OutputStream as OutputStream
import java.net.HttpURLConnection as HttpURLConnection
import com.ibm.ws.security.util.Base64Coder as Base64Coder

def uploadToIHSAdminServer(urlString,uid,pwd,localPath,remotePath):
   # Load the content of the file at localPath
   fileBytes = getFileBytes(localPath)
   # POST the contents of localPath to the URL
   url = URL(urlString+"/wasadmin")
   conn = url.openConnection()
   conn.setRequestMethod("POST")
   conn.setDoOutput(1)
   conn.setRequestProperty("SAILCmd","WriteFile")
   conn.setRequestProperty("sailArgs",remotePath)
   encodedAuth = Base64Coder.base64Encode(uid+":"+pwd)
   conn.setRequestProperty("Authorization","Basic "+encodedAuth)
   out = conn.getOutputStream()
   out.write(fileBytes)
   out.close()
   # Check the response status
   rc = conn.getResponseCode()
   if (rc != 200):
      msg = "failed to upload "+localPath+" to IHS Admin Server at "+urlString
      if ((rc == 401) or (rc == 403)):
         msg += "; authorization failure"
      else:
         msg += "; "+response.reason+" ("+str(rc)+")"
      fatal(msg)
   # Check for any error message in the response body
   checkResponseBody(conn.getInputStream())
   print "Successfully uploaded "+localPath+" to "+remotePath

def getFileBytes(path):
    baos = ByteArrayOutputStream()
    fis = FileInputStream(File(path))
    bytes = jarray.zeros(1024,'b')
    while 1==1:
       readSize = fis.read(bytes)
       if (readSize == -1):
           break
       baos.write(bytes,0,readSize)
    return baos.toByteArray()

def checkResponseBody(inStream):
   docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder()
   source = InputSource()
   source.setByteStream(inStream)
   doc = docBuilder.parse(source)
   tag = "SAIL_Error"
   nodeList = doc.getElementsByTagName(tag);
   count = nodeList.getLength()
   if (count < 1):
      fatal("response did not contain a '"+tag+"' tag: "+responseBody)
   if (count > 1):
      fatal("response contained multiple '"+tag+"' tags: "+responseBody)
   node = nodeList.item(0)
   id = node.getAttribute("ID")
   if (id != "AC_OK"):
      msg = node.getAttribute("Msg")
      fatal("from IHS Admin Server: "+msg)

def file2string(path):
   file = open(path,'r')
   str = file.read()
   file.close()
   return str

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

def syncNodes():
   node_ids = convertToList(AdminConfig.list("Node"))
   for node in node_ids:
      nodeName = AdminConfig.showAttribute(node,"name")
      nodeSynch = AdminControl.completeObjectName("type=NodeSync,node=" + nodeName + ",*")
      if (nodeSynch != ""):
         AdminControl.invoke(nodeSynch,"sync")

def copyToRepository(localPath,repoPaths):
   for repoPath in repoPaths:
      if AdminConfig.existsDocument(repoPath):
         AdminConfig.deleteDocument(repoPath)
      AdminConfig.createDocument(repoPath,localPath)
   AdminConfig.save()
   syncNodes()
   print "Successfully uploaded "+localPath+" to the repository at "+str(repoPaths)+" and synchronized nodes"

#
# Print a usage message
#
def usage(msg):
  print "Usage: "+msg+"""
  Supported commands:
    copyToRepository <localPath> <remoteRepositoryPath> [<remoteRepositoryPath> ...]
       Copy a file to one or more locations in the repository
    uploadToIHSAdminServer <url> <uid> <pwd> <localPath> <remotePath>
       Upload a file to an IHS Admin Server
  where arguments are:
    <localPath> is the absolute path to the local file to be copied or uploaded
    <remoteRepositoryPath> is the relative path in the repository to which to copy the local file
    <remotePath> is the absolute path of the file on the IHS Admin Server 
    <url> is a IHS admin server's URL of the form '<proto>://<host>:<port>', where <proto> is 'http' or 'https'
    <uid> is the user name identifier to use in authenticating to the IHS Admin Server
    <pwd> is the password to use in authenticating to the IHS Admin Server

  Example 1 (copy /tmp/plugin-cfg.xml into myIHSServer's directory in the repository):
     wsadmin.sh -f propagatePluginCfg.py -lang jython copyToRepository /tmp/plugin-cfg.xml cells/myCell/nodes/myIHSNode/servers/myIHSServer/plugin-cfg.xml

  Example 2 (upload /tmp/plugin-cfg.xml to my IHS Admin server via https and place in the webserver1 directory):
     wsadmin.sh -f propagatePluginCfg.py -lang jython -conntype none uploadToIHSAdminServer https://myIHSHost:8192 ihsusr ihsusrPassword /tmp/plugin-cfg.xml /opt/HTTPServer/plugins/config/webserver1/plugin-cfg.xml
  """
  sys.exit(1)

#
# A fatal error occurred
#
def fatal(msg):
  print "ERROR: "+msg
  sys.exit(2)

#
# Get argument number 'count'; print a usage message if it doesn't exist.
#
def getarg(name,count):
  if(len(sys.argv) <= count):
    usage("too few arguments; argument "+name+" not found")
  return sys.argv[count].rstrip()

#========================================================================================
#
# Begin main
#
#========================================================================================

cmd = str(getarg('<command>',0))

if (cmd == 'copyToRepository'):
   if (len(sys.argv) < 3):
      usage("too few arguments for copyToRepository")
   copyToRepository(getarg('<localPath>',1),sys.argv[2:])
elif (cmd == 'uploadToIHSAdminServer'):
   if (len(sys.argv) != 6):
      usage("expecting 6 arguments")
   uploadToIHSAdminServer(getarg('<url>',1),getarg('<uid>',2),getarg('<pwd>',3),getarg('<localPath>',4),getarg('<remotePath>',5))
else:
   usage("invalid command: '"+cmd+"'")
