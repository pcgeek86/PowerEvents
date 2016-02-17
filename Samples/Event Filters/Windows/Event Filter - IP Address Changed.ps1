# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 02/08/14
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects when the IP address changes
#          on any installed network interface on a Windows operating system.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name IPAddressChanged -Query "select * from __InstanceModificationEvent within 30 where TargetInstance ISA 'Win32_NetworkAdapterConfiguration' and TargetInstance.IPAddress <> PreviousInstance.IPAddress";