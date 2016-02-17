# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 7/9/2011
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding
#          that shuts down a computer when Microsoft Outlook is started.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Windows\Command Line - System Resumed - Restart Windows Service.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - System Resumed.ps1")