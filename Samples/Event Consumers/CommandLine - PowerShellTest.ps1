# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/29/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that calls a script in response to a print job completing.

New-WmiEventConsumer -Name PowerShellTest -ConsumerType CommandLine -ExecutablePath 'c:\windows\system32\powershell.exe' -CommandLineTemplate '-Command { Add-Content -Path }'