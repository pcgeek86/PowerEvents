# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects the deletion of a computer object in Active Directory (AD).
#          Take note that, if a computer account is moved, the WMI instance that represents the computer will be deleted and a new one created. A modification event (__InstanceModificationEvent) will NOT be fired in this scenario.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -EventNamespace root\directory\ldap -Name ADComputerCreated `
	-Query "select * from __InstanceDeletionEvent within 5 where TargetInstance ISA 'ds_computer'"