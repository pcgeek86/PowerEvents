# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 05/24/11
#   Brief: This example shows how to use PowerEvents to create a WMI event filter that detects the creation of a new System Center Configuration Mananger (ConfigMgr) system resource.
#          This example assumes that the ConfigMgr site code is 'LAB' and the script is being executed on the primary site server.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event filter.
#          A fully functioning sample requires an event consumer, to respond to the events, as well as a binding between the filter and consumer.

New-WmiEventFilter -Name ConfigMgrSystemResourceCreated -EventNamespace root\sms\site_lab -Query "select * from __InstanceCreationEvent within 5 where TargetInstance ISA 'SMS_R_System'"