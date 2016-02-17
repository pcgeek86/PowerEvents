# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 05/24/11
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that calls a script in response to
#          a new System Center Configuration Manager system resource being created.

$VBcode = @"
set fso = CreateObject("Scripting.FileSystemObject")
set LogFile = fso.OpenTextFile("c:\SCCM.log", 8, true)
call LogFile.WriteLine(Date() & " " & Time() & ": New ConfigMgr system resource created!")
"@
New-WmiEventConsumer -Name ConfigMgrSystemResourceCreated -ConsumerType Script -ScriptText $VBcode