# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/30/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that calls a script in response to a USB flash drive (UFD) being removed.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
New-WmiEventConsumer -Name ScriptFileUFDInstalled -ConsumerType Script -ScriptFile "$ScriptPath\VBscripts\UFD Installed.vbs"