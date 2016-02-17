# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/29/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects when a USB flash drive is removed.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name UFDRemoved -Query "select * from __InstanceDeletionEvent within 2 where TargetInstance ISA 'Win32_LogicalDisk' and TargetInstance.DriveType = 2"