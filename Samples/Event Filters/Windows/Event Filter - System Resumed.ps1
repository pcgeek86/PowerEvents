# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 7/9/2011
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects when the system has been resumed.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name SystemResumed -Query "select * from Win32_PowerManagementEvent where EventType = 7"