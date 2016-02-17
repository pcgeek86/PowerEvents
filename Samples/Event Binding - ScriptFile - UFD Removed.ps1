# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/29/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that fires a VBscript in response to a UFD being removed.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\ScriptFile - UFD Removed.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - UFD Removed.ps1")