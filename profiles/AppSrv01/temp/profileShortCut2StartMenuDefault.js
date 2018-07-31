var wshShell = WScript.createobject("WScript.Shell");
var fileObject = WScript.createobject("Scripting.FileSystemObject");

var startMenuLocation = wshShell.SpecialFolders("Programs");

var forReading = 1;
var tristateUseDefault = -2;

var ff = fileObject.GetFile("C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\properties\\install\\shortcuts\\shortcuts.txt");
var tss = ff.OpenAsTextStream(forReading, tristateUseDefault);
var line = tss.ReadLine();
tss.Close();

var indexOfSlash = line.indexOf("/");
var node = line.substring(0,indexOfSlash+1);
var leaf = line.substring(indexOfSlash+1);


      
var cmd = "%windir%\\system32\\cmd.exe";

if (!(fileObject.FolderExists(startMenuLocation + "\\" + node)))
      fileObject.CreateFolder(startMenuLocation + "\\" + node);

if (!(fileObject.FolderExists(startMenuLocation + "\\" + node + "\\" + leaf )))
      fileObject.CreateFolder(startMenuLocation + "\\" + node + "\\" + leaf );

if (!(fileObject.FolderExists(startMenuLocation + "\\" + node + "\\" + leaf + "\\Profiles")))      
      fileObject.CreateFolder(startMenuLocation + "\\" + node + "\\" + leaf +  "\\Profiles");
            
if (!(fileObject.FolderExists(startMenuLocation + "\\" + node + "\\" + leaf + "\\Profiles\\AppSrv01")))
      fileObject.CreateFolder(startMenuLocation + "\\" + node + "\\" + leaf +  "\\Profiles\\AppSrv01");

var objShellLinkAdministrativeConsole = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf +  "\\Profiles\\AppSrv01\\AppSrv01 - Administrative console.lnk");      
//F908-38323 var objShellLinkSamplesGallery = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf +  "\\Profiles\\AppSrv01\\${SAMPLES}.lnk");      
var objShellLinkFirstSteps = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf + "\\Profiles\\AppSrv01\\AppSrv01 - First steps.lnk");      
var objShellLinkStartServer = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf +  "\\Profiles\\AppSrv01\\AppSrv01 - Start the server.lnk");
var objShellLinkStopServer = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf + "\\Profiles\\AppSrv01\\AppSrv01 - Stop the server.lnk");

//1: Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. 
//3: Activates the window and displays it as a maximized window.  
//7: Minimizes the window and activates the next top-level window. 
objShellLinkAdministrativeConsole.WindowStyle = 1;
//F908-38323 objShellLinkSamplesGallery.WindowStyle = 1;
objShellLinkFirstSteps.WindowStyle = 7;
objShellLinkStartServer.WindowStyle = 1;
objShellLinkStopServer.WindowStyle = 1;

if ( (fileObject.FolderExists("C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\config\\cells\\websphereQANode01Cell\\applications\\isclite.ear") ) )
{
	objShellLinkAdministrativeConsole.IconLocation = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\bin\\icons\\console.ico";
	objShellLinkAdministrativeConsole.TargetPath = cmd;
	objShellLinkAdministrativeConsole.Arguments = "/c start /b http://websphereQA.xoboqrqja4lepc2vjw3aqgubpg.tx.internal.cloudapp.net:9060/ibm/console";
	objShellLinkAdministrativeConsole.Description = "AppSrv01 - Administrative console";
	objShellLinkAdministrativeConsole.Save(); //commit change
}

//F908-38323 if ( (fileObject.FolderExists("C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\installedApps\\websphereQANode01Cell\\SamplesGallery.ear") ) )
//F908-38323 {
//F908-38323       objShellLinkSamplesGallery.IconLocation = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\bin\\icons\\samples.ico";
//F908-38323       objShellLinkSamplesGallery.TargetPath = cmd;
//F908-38323       objShellLinkSamplesGallery.Arguments = "/c start /b http://websphereQA.xoboqrqja4lepc2vjw3aqgubpg.tx.internal.cloudapp.net:9080/WSsamples";
//F908-38323       objShellLinkSamplesGallery.Description = "${SAMPLES}";
//F908-38323       objShellLinkSamplesGallery.Save(); //commit change
//F908-38323 }      

objShellLinkFirstSteps.IconLocation = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\bin\\icons\\firststeps.ico";
objShellLinkFirstSteps.TargetPath = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\firststeps\\firststeps.bat";
objShellLinkFirstSteps.WorkingDirectory = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\firststeps";
objShellLinkFirstSteps.Description = "AppSrv01 - First steps";
objShellLinkFirstSteps.Save(); //commit change

objShellLinkStartServer.IconLocation = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\bin\\icons\\start_server.ico";
objShellLinkStartServer.TargetPath = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\bin\\startserver.bat";
objShellLinkStartServer.Arguments = "server1";
objShellLinkStartServer.WorkingDirectory = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\bin";
objShellLinkStartServer.Description = "AppSrv01 - Start the server";
objShellLinkStartServer.Save(); //commit change

objShellLinkStopServer.IconLocation = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer" + "\\bin\\icons\\server_stopped.ico";
objShellLinkStopServer.TargetPath = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\bin\\stopserver.bat";
objShellLinkStopServer.Arguments = "server1";
objShellLinkStopServer.WorkingDirectory = "C:\\Program Files (x86)\\IBM\\WebSphere\\AppServer\\profiles\\AppSrv01" + "\\bin";
objShellLinkStopServer.Description = "AppSrv01 - Stop the server";
objShellLinkStopServer.Save(); //commit change