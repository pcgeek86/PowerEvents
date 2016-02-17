# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 02/22/12
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that writes to a log file.
#          The Text parameter is the message written to a log file, using WMI standard string templates.
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

New-WmiEventConsumer -ConsumerType LogFile -Name ProcessCreatedLogFile -FileName $env:windir\temp\Process.log `
	-Text "Process has been created. Process name is: %TargetInstance.Name%"