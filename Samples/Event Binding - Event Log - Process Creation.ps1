# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that logs process creations to the Application event log.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Event Log - Process Creation.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - Process Created.ps1")