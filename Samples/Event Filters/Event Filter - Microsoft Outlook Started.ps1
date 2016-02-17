# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 05/25/11
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects when Microsoft Outlook is started.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name MicrosoftOutlookStarted -Query "select * from __InstanceCreationEvent within 5 where TargetInstance ISA 'Win32_Process' and TargetInstance.Name = 'outlook.exe'"