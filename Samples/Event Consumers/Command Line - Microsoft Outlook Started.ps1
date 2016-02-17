# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 05/26/11
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that runs a command line in response to Microsoft Outlook being started.
#          Note that there are double-quotes explicitly being added around the script path and script arguments (that might have a space in them)
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
New-WmiEventConsumer -Verbose -Name MicrosoftOutlookStarted -ConsumerType CommandLine -CommandLineTemplate "shutdown -r -t 0"


<#
MOF of a working example:

instance of CommandLineEventConsumer
{
	CommandLineTemplate = "cscript.exe \"C:\\Users\\Phragcyte\\Documents\\WindowsPowerShell\\Modules\\PowerEvents\\Samples\\Event Consumers\\VBscripts\\User Profile Loaded.vbs\"";
	CreateNewConsole = TRUE;
	CreateNewProcessGroup = TRUE;
	CreatorSID = {1, 5, 0, 0, 0, 0, 0, 5, 21, 0, 0, 0, 7, 96, 247, 25, 179, 246, 87, 123, 169, 67, 178, 173, 232, 3, 0, 0};
	ExecutablePath = "cscript.exe";
	MachineName = NULL;
	Name = "UserProfileLoaded";
	WorkingDirectory = NULL;
};
#>