# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 05/31/11
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding
#          that shuts down a computer when Microsoft Outlook is started.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Command Line - Microsoft Outlook Started.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Event Filter - Microsoft Outlook Started.ps1")