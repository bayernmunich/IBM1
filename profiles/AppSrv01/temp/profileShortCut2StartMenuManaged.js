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

var objShellLinkFirstSteps = wshShell.CreateShortcut(startMenuLocation + "\\" + node + "\\" + leaf + "\\${PROFILESDIR}\\${PROFILENAME}\\${FIRSTSTEPS}.lnk");

//1: Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. 
//3: Activates the window and displays it as a maximized window.  
//7: Minimizes the window and activates the next top-level window. 
objShellLinkFirstSteps.WindowStyle = 7;

objShellLinkFirstSteps.IconLocation = ${WASROOT} + "\\bin\\icons\\firststeps.ico";
objShellLinkFirstSteps.TargetPath = ${PROFILEROOT} + "\\firststeps\\firststeps.bat";
objShellLinkFirstSteps.WorkingDirectory = ${PROFILEROOT} + "\\firststeps";
objShellLinkFirstSteps.Description = "${FIRSTSTEPS}";
objShellLinkFirstSteps.Save(); //commit change
