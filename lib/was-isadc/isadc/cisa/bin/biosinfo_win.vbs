' Licensed Materials - Property of IBM
'
' (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved
'
' US Government Users Restricted Rights - Use, duplicate or
' disclosure restricted by GSA ADP Schedule Contract with
' IBM Corp.
'=========================================================
Set StdOut = WScript.StdOut
Set wbemSvc = GetObject("winmgmts://" & "." & "/root/cimv2")
Set csObjSet = wbemSvc.ExecQuery("Select * from Win32_ComputerSystemProduct")
ProductId = "Unknown"
For Each csObj In csObjSet
  ProductId = csObj.Name
  StdOut.WriteLine "SystemManufacturer=" & csObj.Vendor
  StdOut.WriteLine "SystemProduct=" & csObj.Name
  StdOut.WriteLine "SystemSerialNumber=" & csObj.IdentifyingNumber
  StdOut.WriteLine "SystemVersion=" & csObj.Version

  SystemUUID = Replace(csObj.UUID, "-", "")
' ## If the BIOS is 2.6 or greater, We do not want to change the format to Network Byte Order, since WMI reversed it backwards
  If (Len(SystemUUID) = 32 AND IsNewBiosVersion = 0) Then
    TempUUID1 = Mid(SystemUUID,7,2) & Mid(SystemUUID,5,2) & Mid(SystemUUID,3,2) & Mid(SystemUUID,1,2)
    TempUUID2 = Mid(SystemUUID,11,2) & Mid(SystemUUID,9,2) & Mid(SystemUUID,15,2) & Mid(SystemUUID,13,2)
    SystemUUID = TempUUID1 & TempUUID2 & Mid(SystemUUID, 17, 16)
  End If
  StdOut.WriteLine "SystemUUID=" & SystemUUID
Next
Set osObjSet = wbemSvc.ExecQuery("Select * from Win32_OperatingSystem")
For Each osObj In osObjSet
  StdOut.WriteLine "SystemCaption=" & osObj.Caption
  StdOut.WriteLine "SystemVersion=" & osObj.Version
  StdOut.WriteLine "SystemDateTime=" & osObj.LocalDateTime
  StdOut.WriteLine "SystemBootUpTime=" & osObj.LastBootUpTime
  StdOut.WriteLine "SystemServicePack=" & osObj.ServicePackMajorVersion
Next

const HKEY_LOCAL_MACHINE = &H80000002
Set osReg = GetObject("winmgmts:\\" & "." & "\root\default:StdRegProv")
strKeyPath = "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName"
strValueName = "TWGMachineID"
osReg.GetBinaryValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,strValue
If (IsNull(strValue) = false) Then
  StdOut.Write "SystemGUID="
  For i = lBound(strValue) to uBound(strValue)
    StdOut.Write ToHexStr(i)
  Next
  StdOut.WriteLine
End If

PrintProcVendor
IsMultinode

'==============================
' ToHexStr
'==============================
Function ToHexStr(intVal)
  hexStr = Hex(strValue(intVal))
  If Len(hexStr) > 1 Then
    ToHexStr = hexStr
  Else
    ToHexStr = "0" & hexStr
  End If
End Function

'==============================
' PrintProcVendor
'==============================
Function PrintProcVendor()
  On Error Resume Next
  firstProc = 1
  set wmi = GetObject("winmgmts:\\.\root\wmi")
  set smbios = wmi.InstancesOf("MSSmBios_RawSMBiosTables")
  for each smb in smbios

    ' Loop through each table
    buf = smb.SMBiosData
    pos = 0
    tableCount = 1
    do while pos < smb.Size

      ' At start of a table
      tableLen = buf(pos+1)
      tabletype = buf(pos)

      pos = pos + tableLen

      ' Process strings. The strings are a standard C multi-string, where each string
      '   is null terminated and the set of strings is double-null terminated.

      ' Loop through strings until two null characters are reached
      stringCount = 1
      do while buf(pos) + buf(pos+1) > 0

        ' Loop through string until a null character is reached.
        str = ""
        do while buf(pos) > 0
          str = str & chr(buf(pos))
          pos = pos + 1
        loop
        If firstProc = 1 AND tabletype = 4 AND stringCount = 2 Then
          StdOut.WriteLine "ProcVendor=" & str
          firstProc = 0 
        End If
        stringCount = stringCount + 1

        if buf(pos) + buf(pos+1) = 0 then
          exit do
        else
          pos = pos + 1   ' go to next string
        end if
      
      loop   ' loop through strings
      pos = pos + 2   ' go to next table
      tableCount = tableCount + 1

    loop   ' go through smbios table data

  next

End Function

'==============================
' IsNewBiosVersion
'==============================
Function IsNewBiosVersion()

  On Error Resume Next
  Set biosSet = wbemSvc.ExecQuery("Select * from Win32_BIOS")

  newBios = 0
  For Each bios In biosSet
    minorFloat = "." & bios.SMBIOSMinorVersion
    If bios.SMBIOSMajorVersion > 2 OR (bios.SMBIOSMajorVersion = 2 AND minorFloat >= .6) Then
      newBios = 1
    End If
  Next
  IsNewBiosVersion = newBios

End Function

'==============================
' IsMultinode
'==============================
Function IsMultinode()

  On Error Resume Next
  nodeCount = 0
  Set nodeObjSet = wbemSvc.ExecQuery("Select * from Win32_SystemEnclosure")
  For Each nodeObj In nodeObjSet
    nodeCount = nodeCount + 1
  Next
  If nodeCount > 1 Then
    VerifyMultinode
  Else
    StdOut.WriteLine "MultiNode=false"
  End If

End Function

'==============================
' VerifyMultinode
' on Hammerhead single node there will be 2 SystemEnclosures so we need to see if this is really single or multinode
' Windows doesn't report the type in Win32_SystemEnclosure so we need to get the raw bios to find it
'==============================
Function VerifyMultinode()

  On Error Resume Next
set wmi = GetObject("winmgmts:\\.\root\wmi")
set smbios = wmi.InstancesOf("MSSmBios_RawSMBiosTables")
nodes=0
for each smb in smbios

  ' Loop through each table
  buf = smb.SMBiosData
  pos = 0
  tableCount = 1
  do while pos < smb.Size

    ' At start of a table
    tableLen = buf(pos+1)
    tabletype = buf(pos)

    ' We only care about the type 3 table
    ' the chassistype is the 5th byte
    If tabletype = 3 Then
      i = 5
      data = buf(pos+i)
      'Bit 7 Chassis lock is present if 1.Bits 6:0 Enumeration value
      'AND with 127 (0x7F) to get the first 7 bits
      tempdata = data and 127 
    
      ' 29 is for the blade enclosure, ignore counting this as a node
      ' 18 is expansion chassis, ignore as well
      If data = 29 OR data = 18 Then
         ' do nothing
      Else
         ' increase node count for all other types
         nodes = nodes + 1  
      End If
    End If

    pos = pos + tableLen

    ' Process strings. The strings are a standard C multi-string, where each string
    '   is null terminated and the set of strings is double-null terminated.

    ' Loop through strings until two null characters are reached
    stringCount = 1
    do while buf(pos) + buf(pos+1) > 0

      ' Loop through string until a null character is reached.
      str = ""
      do while buf(pos) > 0
        str = str & chr(buf(pos))
        pos = pos + 1
      loop
      stringCount = stringCount + 1

      if buf(pos) + buf(pos+1) = 0 then
        exit do
      else
        pos = pos + 1   ' go to next string
      end if
      
    loop   ' loop through strings
    pos = pos + 2   ' go to next table
    tableCount = tableCount + 1

  loop   ' go through smbios table data

next

  If nodes > 1 Then
    StdOut.WriteLine "VMID=0"
    StdOut.WriteLine "MultiNode=true"
  Else
    StdOut.WriteLine "MultiNode=false"
  End If

End Function