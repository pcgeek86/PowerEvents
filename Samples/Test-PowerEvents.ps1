# Test WMI Query: select * from __InstanceOperationsEvent where TargetInstance ISA 'Win32_Process'

Clear-Host

# Enable verbose messages to be written to console output
$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'

#region Get script path
#$MyInvocation.MyCommand.Path
${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
# Write-Verbose -Message "Script path is: ${ScriptPath}"
#endregion

#region Import WMI Event Management module
if (-not (Get-Module 'WMI Event Management'))
{
	Remove-Module -Name 'WMI Event Management'
}
else
{
	Import-Module -Name 'WMI Event Management'
}
#endregion Import WMI Event Management module

#region Create VBscript responder for ActiveScriptEventConsumer
# All this VBscript does is log some text to "c:\temp\vboutput.log"

$VBResponderText = @"
Option Explicit
dim fso, logfile, logpath, sh
set sh = CreateObject("Wscript.Shell")
'*** Log an event to the application event log
call sh.LogEvent(0, "Script executed at: " & Time())
logpath = "c:\temp\vboutput.log"
set fso = CreateObject("Scripting.FileSystemObject")
'if fso.FileExists(logpath) then call fso.DeleteFile(logpath, true)
set logfile = fso.OpenTextFile(logpath, 8, true)
call logfile.WriteLine(Date() & Time())
'*** Release object handles
set fso = nothing
set logfile = nothing
"@
# Create VBscript responder file (aka. event handler script)
[void] (New-Item -ItemType Directory -Path c:\temp -Force)
[void] (New-Item -ItemType Directory -Path c:\temp\resources -Force)
[void] (New-Item -ItemType File -Path c:\temp\resources\Responder.vbs -Force)
Remove-Item -Path 'c:\temp\Resources\Responder.vbs'
Set-Content -Path 'c:\temp\Resources\Responder.vbs' -Value $VBResponderText -Force 
#endregion

#region Clean up WMI stuff
<#
Get-WmiObject ActiveScriptEventConsumer -Namespace root\default | Remove-WmiObject
Get-WmiObject CommandLineEventConsumer -Namespace root\default | Remove-WmiObject
Get-WmiObject ActiveScriptEventConsumer -Namespace root\subscription | Remove-WmiObject
Get-WmiObject CommandLineEventConsumer -Namespace root\subscription | Remove-WmiObject
Get-WmiObject __EventFilter -Namespace root\default | Remove-WmiObject
Get-WmiObject __EventFilter -Namespace root\cimv2 | Remove-WmiObject
Get-WmiObject __FilterToConsumerBinding -Namespace root\default | Remove-WmiObject
Get-WmiObject __FilterToConsumerBinding -Namespace root\cimv2 | Remove-WmiObject
#>
#endregion

#region Perform event monitoring for WMI event consumers
<#
Get-EventSubscriber | Unregister-Event
Register-WmiEvent -Namespace root\cimv2 -Class __EventDroppedEvent -Action { Write-Host "Event dropped in root\cimv2" }
Register-WmiEvent -Namespace root\cimv2 -Class __EventQueueOverflowEvent -Action { Write-Host "Event dropped in root\cimv2" }
Register-WmiEvent -Namespace root\default -Class __EventDroppedEvent -Action { Write-Host "Event dropped in root\cimv2" }
Register-WmiEvent -Namespace root\default -Class __EventQueueOverflowEvent -Action { Write-Host "Event dropped in root\cimv2" }
Register-WmiEvent -Namespace root\subscription -Class __ConsumerFailureEvent -Action { Write-Host "Consumer failed" }
#>
#endregion

#region Test creation of event consumer
# TEST: Create script consumer with both ${ScriptFile} and ${ScriptText} defined (should not work)
# RESULT (11.02.10): Added some parameter validation code that ensures validation will fail if both parameters ${ScriptFile} and ${ScriptText} are defined.
$ScriptConsumer = New-WmiEventConsumer -Consumer Script -ScriptFile 'c:\temp\Resources\Responder.vbs' -ScriptText 'set fso = CreateObject("Scripting.FileSystemObject")' -Name TestConsumer

# TEST: Create script consumer from script text
# RESULT (11.02.10): Works as expected, but did not validate that it responds correctly when bound to an event filter
$ScriptConsumer = New-WmiEventConsumer -Consumer Script -ScriptText $VBResponderText -Name TestConsumer

# TEST: Create script consumer with neither ${ScriptFile} or ${ScriptText} defined
# RESULT (11.02.10): Fails with "parameter set cannot be resolved"
$ScriptConsumer = New-WmiEventConsumer -Consumer Script -ScriptingEngine VBscript -Name TestConsumer

# TEST: Create script consumer from script file
$ScriptConsumer = New-WmiEventConsumer -Consumer Script -ScriptFile 'c:\temp\Resources\Responder.vbs' -Name TestConsumer

# Create SMTP consumer
$SmtpConsumer = New-WmiEventConsumer -ConsumerType SMTP -Name TestConsumer -SMTPServer 'localhost' -FromLine 'notifications@test.loc' -Subject 'WMI Notification' -Message '%TargetInstance.Name%' -ToLine 'trevor@test.loc'
# Create log file event consumer
$LogFileConsumer = New-WmiEventConsumer -ConsumerType LogFile -Name TestConsumer -Text 'Process started: %TargetInstance.Name% at %TIME_CREATED%' -FileName c:\temp\LogFileOutput.log
# Create command line consumer
$CliConsumer = New-WmiEventConsumer -ConsumerType 'CommandLine' -Name TestConsumer -ExecutablePath 'cmd.exe /c ipconfig >> c:\temp\clioutput.log'
# Create NT Event Log consumer
$EventLogConsumer = New-WmiEventConsumer -ConsumerType EventLog -Name TestConsumer -InsertionStringTemplates 'New instance created: %TargetInstance.__PATH%' -EventId 10 -EventType Information -Category 10 -UNCServerName localhost
#endregion Test creation of event consumer

#region Test creation of event filter
# Test filter creation with computer name
$Filter = New-WmiEventFilter -ComputerName 'gaming' -Name TestFilter -EventNamespace root\cimv2 -Query "select * from __InstanceCreationEvent WITHIN 5 where TargetInstance ISA 'Win32_Process'"

# Test filter creation without computer name
$Filter = New-WmiEventFilter -Name TestFilter -EventNamespace root\cimv2 -Query "select * from __InstanceCreationEvent WITHIN 5 where TargetInstance ISA 'Win32_Process'"
#endregion Test creation of event filter

#region Test creation of Filter-To-Consumer bindings
# New-WmiFilterToConsumerBinding -Consumer $CliConsumer -Filter $Filter
# New-WmiFilterToConsumerBinding -Consumer $ScriptConsumer -Filter $Filter
# New-WmiFilterToConsumerBinding -Consumer $SmtpConsumer -Filter $Filter
New-WmiFilterToConsumerBinding -Consumer $LogFileConsumer -Filter $Filter
#endregion Test creation of Filter-To-Consumer bindings

exit # Comment this line to enable clean up

# **************** RUN THIS SECTION OF THE SCRIPT TO CLEAN UP WMI EVENT INSTANCES ****************
# **************** RUN THIS SECTION OF THE SCRIPT TO CLEAN UP WMI EVENT INSTANCES ****************
# **************** RUN THIS SECTION OF THE SCRIPT TO CLEAN UP WMI EVENT INSTANCES ****************

# Clean up consumer instances
Remove-WmiObject -Path "root\subscription:ActiveScriptEventConsumer.Name='TestConsumer'"
Remove-WmiObject -Path "root\subscription:SMTPEventConsumer.Name='TestConsumer'"
Remove-WmiObject -Path "root\subscription:LogFileEventConsumer.Name='TestConsumer'"
Remove-WmiObject -Path "root\subscription:NTEventLogEventConsumer.Name='TestConsumer'"
Remove-WmiObject -Path "root\subscription:CommandLineEventConsumer.Name='TestConsumer'"

# Clean up __EventFilter instances
Get-WmiObject -Namespace root\subscription -Query "select * from __EventFilter where Name like '%Test%'" | Remove-WmiObject

# Clean up test bindings
Get-WmiObject -Namespace root\subscription -Class __FilterToConsumerBinding | ? { $_.Consumer -like '*TestConsumer*' } | Remove-WmiObject