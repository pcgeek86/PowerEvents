# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/29/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that calls a script in response to a print job completing.

New-WmiEventConsumer -Name ScriptWithArgs -ConsumerType CommandLine -ExecutablePath 'c:\windows\system32\cscript.exe' -CommandLineTemplate 'c:\windows\system32\cscript.exe','c:\temp\resources\responder.vbs'