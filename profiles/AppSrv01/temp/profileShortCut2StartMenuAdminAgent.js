var wshShell = WScript.createobject("WScript.Shell");
var fileObject = WScript.createobject("Scripting.FileSystemObject");

var startMenuLocation = wshShell.SpecialFolders("Programs");

var forReading = 1;
var tristateUseDefault = -2;

var ff = fileObject.GetFile(${WASROOT} + "\\properties\\install\\shortcuts\\shortcuts.txt");
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

if (!(fileObject.FolderExists(startMenuLocation + "\\" + node + "\\" + leaf + "\\${PROFILESDIR}")))      
      fileObject.CreateFolder(startMenuLocation + "\\" + node + "\\" + leaf +  "\\${PROFILESDIR}");
            
if (!(fileObject.FolderExists(startMenuLocation + "\\" + node + "\\" + leaf + "\\${PROFILESDIR}\\${PROFILENAME}")))
      fileObject.CreateFolder(startMenuLocation + "\\" + node + "\\" + leaf +  "\\${PROFILESDIR}\\${PROFILENAME}");

var objShellLinkAdministrativeConsole = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf +  "\\${PROFILESDIR}\\${PROFILENAME}\\${ADMINCONSOLE}.lnk");      
var objShellLinkFirstSteps = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf  + "\\${PROFILESDIR}\\${PROFILENAME}\\${FIRSTSTEPS}.lnk");            
var objShellLinkStartServer = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf  + "\\${PROFILESDIR}\\${PROFILENAME}\\${STARTSERVER}.lnk");
var objShellLinkStopServer = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf  + "\\${PROFILESDIR}\\${PROFILENAME}\\${STOPSERVER}.lnk");

//1: Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. 
//3: Activates the window and displays it as a maximized window.  
//7: Minimizes the window and activates the next top-level window. 
objShellLinkAdministrativeConsole.WindowStyle = 1;
objShellLinkFirstSteps.WindowStyle = 7;
objShellLinkStartServer.WindowStyle = 1;
objShellLinkStopServer.WindowStyle = 1;

if ( (fileObject.FolderExists(${PROFILEROOT} + "\\config\\cells\\${CELLNAME}\\applications\\isclite.ear") ) )
{
	objShellLinkAdministrativeConsole.IconLocation = ${WASROOT} + "\\bin\\icons\\console.ico";
	objShellLinkAdministrativeConsole.TargetPath = cmd;
	objShellLinkAdministrativeConsole.Arguments = "/c start /b http://${HOSTNAME}:9060/ibm/console";
	objShellLinkAdministrativeConsole.Description = "${ADMINCONSOLE}";
	objShellLinkAdministrativeConsole.Save(); //commit change
}

objShellLinkFirstSteps.IconLocation = ${WASROOT} + "\\bin\\icons\\firststeps.ico";
objShellLinkFirstSteps.TargetPath = ${PROFILEROOT} + "\\firststeps\\firststeps.bat";
objShellLinkFirstSteps.WorkingDirectory = ${PROFILEROOT} + "\\firststeps";
objShellLinkFirstSteps.Description = "${FIRSTSTEPS}";
objShellLinkFirstSteps.Save(); //commit change

objShellLinkStartServer.IconLocation = ${WASROOT} + "\\bin\\icons\\start_server.ico";
objShellLinkStartServer.TargetPath = ${PROFILEROOT} + "\\bin\\startserver.bat";
objShellLinkStartServer.Arguments = "adminagent";
objShellLinkStartServer.WorkingDirectory = ${PROFILEROOT} + "\\bin";
objShellLinkStartServer.Description = "${STARTSERVER}";
objShellLinkStartServer.Save(); //commit change

objShellLinkStopServer.IconLocation = ${WASROOT} + "\\bin\\icons\\server_stopped.ico";
objShellLinkStopServer.TargetPath = ${PROFILEROOT} + "\\bin\\stopserver.bat";
objShellLinkStopServer.Arguments = "adminagent";
objShellLinkStopServer.WorkingDirectory = ${PROFILEROOT} + "\\bin";
objShellLinkStopServer.Description = "${STOPSERVER}";
objShellLinkStopServer.Save(); //commit change
