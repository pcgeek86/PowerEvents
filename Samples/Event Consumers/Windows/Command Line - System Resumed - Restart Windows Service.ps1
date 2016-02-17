# EXAMPLE for PowerEvents PowerShell module available on http://powerevents.codeplex.com
#
#  Author: Trevor Sullivan
#    Date: 11/28/10
#   Brief: This example shows how to use PowerEvents to create a WMI event consumer that runs a command line in response to a user profile being loaded.
#          Note that there are double-quotes explicitly being added around the script path and script arguments (that might have a space in them)
#    Note: This is not a complete working sample of the PowerEvents module. This only shows how to create an event consumer.
#          A fully functioning sample requires an event filter, to define the events, as well as a binding between the filter and consumer.

$RestartScript = @'
$ServiceName = $args[0]
Add-Content -Path 'c:\Restart Service.log' -Value "Service name is: $ServiceName"
$Service = @(Get-WmiObject -Namespace root\cimv2 -Class Win32_Service -Filter "Name = '$ServiceName'")
Add-Content -Path 'C:\Restart Service.log' -Value "Found $($Service.Count) instances of '$ServiceName' service"
$Result = $Service[0].StopService()
Add-Content -Path 'c:\Restart Service.log' -Value "Stopped service with result: $($Result.ReturnValue)"
Start-Sleep 4
$Result = $Service[0].StartService()
Add-Content -Path 'c:\Restart Service.log' -Value "Started service with result: $($Result.ReturnValue)"
Add-Content -Path 'c:\Restart Service.log' -Value "Exiting restart service script"
'@
Remove-Item -Force -Path "$($env:WinDir)\temp\Restart Windows Service.ps1"
Add-Content -Path "$($env:WinDir)\temp\Restart Windows Service.ps1" -Value $RestartScript

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
New-WmiEventConsumer -Verbose -Name SystemResumedRestartService -ConsumerType CommandLine -CommandLineTemplate "powershell.exe -command `". '$($env:WinDir)\temp\Restart Windows Service.ps1' 'PS3 Media Server'`""


<#
MOF of a working command line consumer example:

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