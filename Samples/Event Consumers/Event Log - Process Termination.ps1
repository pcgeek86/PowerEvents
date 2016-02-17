# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/21/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that writes to the event log.
#          The InsertionStringTemplates parameter is the message written to the event log.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

New-WmiEventConsumer -Name ProcessStopped -ConsumerType EventLog -EventType Information -EventId 9898 `
	-InsertionStringTemplates 'Process has stopped: %TargetInstance.ProcessName%'

