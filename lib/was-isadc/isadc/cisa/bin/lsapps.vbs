' Licensed Materials - Property of IBM
'
' (C) Copyright IBM Corp. 2008, 2011 All Rights Reserved
'
' US Government Users Restricted Rights - Use, duplicate or
' disclosure restricted by GSA ADP Schedule Contract with
' IBM Corp.

'==============================
' Initialize
'==============================
Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE
strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"

Set objReg = GetObject("winmgmts://./root/default:StdRegProv")

'==============================
' Main(Args[])
'==============================
objReg.EnumKey HKLM, strKey, arrSubKeys

For Each strSubKey in arrSubKeys
  If IsSystemComponent(strSubKey) = false Then
    objReg.GetStringValue HKLM, strKey & strSubkey, "DisplayName", dispNameVal
    objReg.GetStringValue HKLM, strKey & strSubkey, "DisplayVersion", versionVal
    objReg.GetStringValue HKLM, strKey & strSubkey, "Publisher", vendorVal
    objReg.GetStringValue HKLM, strKey & strSubkey, "InstallDate", instDateVal
    objReg.GetStringValue HKLM, strKey & strSubkey, "InstallLocation", instLocVal
    WScript.StdOut.WriteLine strSubKey & "|" & dispNameVal & "|" & versionVal & "|" & vendorVal & "|" & instDateVal & "|" & instLocVal
  End If
Next

'==============================
' IsSystemComponent
'==============================
Function IsSystemComponent(subKey)

  IsSystemComponent = false
  objReg.GetDWORDValue HKLM, strKey & subKey, "SystemComponent", sysCompVal
  If IsNull(sysCompVal) = false Then
    If sysCompVal = 1 Then
      IsSystemComponent = true
    End If
  End If

End Function
