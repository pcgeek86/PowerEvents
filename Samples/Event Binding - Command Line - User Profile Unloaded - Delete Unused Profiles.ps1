# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 06/30/11
#   Brief: This example shows how to use PowerEvents to create a WMI event filter, consumer, and binding that
#          removes all unused user profiles upon user logoff.

${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
New-WmiFilterToConsumerBinding `
	-Consumer (& "${ScriptPath}\Event Consumers\Command Line - User Profile Unloaded - Delete Unloaded Profiles.ps1") `
	-Filter (& "${ScriptPath}\Event Filters\Windows\Event Filter - User Profile Unloaded.ps1")