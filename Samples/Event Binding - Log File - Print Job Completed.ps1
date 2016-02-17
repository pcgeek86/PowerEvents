# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that logs a completed print job to a text file.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Log File - Print Job Completed.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - Print Job Completed.ps1")