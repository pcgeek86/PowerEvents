# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/22/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that writes to a log file.
#          The Text parameter is the message written to the event log, using WMI standard string templates.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

New-WmiEventConsumer -ConsumerType LogFile -Name PrintJobComplete -FileName $env:windir\temp\PrintJobs.log `
	-Text "Print job has completed. Document is: %TargetInstance.Document%"