# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/22/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that calls a script in response to a new print job being created.

$VBcode = @"
set fso = CreateObject("Scripting.FileSystemObject")
set LogFile = fso.OpenTextFile("c:\Printer.log", 8, true)
call LogFile.WriteLine(Date() & " " & Time() & ": Print job created")
"@
New-WmiEventConsumer -Name PrintJobCreated -ConsumerType Script -ScriptText $VBcode