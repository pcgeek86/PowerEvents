# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects when a user profile is loaded.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name UserProfileLoaded -Query "select * from __InstanceModificationEvent within 2 where TargetInstance ISA 'Win32_UserProfile' and TargetInstance.Loaded <> PreviousInstance.Loaded and TargetInstance.Loaded = TRUE"