# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 12/7/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that executes a VBscript file in response to a UFD being installed.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\ScriptFile - UFD Installed.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - UFD Installed.ps1")