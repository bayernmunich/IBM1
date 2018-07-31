On Error Resume Next
Set objShell = WScript.CreateObject( "WScript.Shell" )
strRegKeyValue = objShell.RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\IBM\GSK7\CurrentVersion\InstallPath" ) & "\lib"
Set objEnv = objShell.Environment( "PROCESS" )
objEnv("GIP") = strRegKeyValue
objShell.run( "cmd.exe /C ikeyman_old.bat" )