var wshShell = WScript.createobject("WScript.Shell");
var fileObject = WScript.createobject("Scripting.FileSystemObject");

var forReading = 1;
var tristateUseDefault = -2;

var ff = fileObject.GetFile(${WASROOT} + "\\properties\\install\\shortcuts\\shortcuts.txt");
var tss = ff.OpenAsTextStream(forReading, tristateUseDefault);
var line = tss.ReadLine();
tss.Close();

var indexOfSlash = line.indexOf("/");
var node = line.substring(0,indexOfSlash+1);
var leaf = line.substring(indexOfSlash+1);


      
var startMenuLocation = wshShell.SpecialFolders("Programs");
if ((fileObject.FolderExists(startMenuLocation + "\\" + node + "\\"  + leaf + "\\${PROFILESDIR}\\${PROFILENAME}")))
      fileObject.DeleteFolder(startMenuLocation + "\\" + node + "\\"  + leaf +  "\\${PROFILESDIR}\\${PROFILENAME}");

if (fileObject.FolderExists(startMenuLocation + "\\" + node + "\\"  + leaf + "\\${PROFILESDIR}"))
{
     if ((fileObject.GetFolder(startMenuLocation + "\\" + node + "\\"  + leaf + "\\${PROFILESDIR}")).Size == 0)
	 {
	  fileObject.DeleteFolder(startMenuLocation + "\\" + node + "\\"  + leaf + "\\${PROFILESDIR}");
	 }
}