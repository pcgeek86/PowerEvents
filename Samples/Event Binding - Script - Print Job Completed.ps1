# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that fires a VBscript in response to a completed print job.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Script - Print Job Completed.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - Print Job Completed.ps1")