# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/22/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects the termination of a Windows process.
#          Processes are started and stopped constantly, in particular depending on user activity.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name ProcessTerminated -Query "select * from __InstanceDeletionEvent within 2 where TargetInstance ISA 'Win32_Process'"