# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 12/14/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that invokes a VBscript (intended to respond to user profile load events) when a process is started.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Command Line - User Profile Loaded.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Event Filter - Process Created.ps1")