# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 02/22/12
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that logs process creations to a log file.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Log File - Process Created.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - Process Created.ps1")