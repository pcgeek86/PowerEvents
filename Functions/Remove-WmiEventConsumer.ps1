# TODO: Support for piping input [String[]] -- map pipeline input to ${Name} parameter?


function Remove-WmiEventConsumer
{
	<#
		.Synopsis
		Deletes a WMI event consumer from the specified computer name and WMI namespace.

        .Parameter ComputerName
        The name of the computer that the WMI event consumer will be removed from.

        .Parameter Name
        The name of the WMI event consumer that will be removed.

        .Parameter ConsumerType
        The type of WMI event consumer that will be removed.
	#>
	
	[CmdletBinding()]

	param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]
		${Name} = ''
		,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		${Namespace} = 'root\subscription'
		,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({
            if (Test-Connection -ComputerName $_ -Count 1) { $true; }
            else { $false; }
            })]
        [string]
		${ComputerName} = '.'
        ,
		# In the interest of think + type, I've adjusted these types from their actual WMI class names
		#   EventLog    = NTEventLogEventConsumer
		#   LogFile     = LogFileEventConsumer 
		#   Script      = ActiveScriptEventConsumer
		#   CommandLine = CommandLineEventConsumer
		#   SMTP        = SMTPEventConsumer
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('CommandLine', 'EventLog', 'LogFile', 'Script', 'SMTP')]
        [string]
        ${ConsumerType}
	)
	
	begin {
		# Get the cmdlet name for writing dynamic log messages
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name

		Write-Verbose -Message "${CmdletName}: Start running BEGIN block";

        $ConsumerTypeList = @{
            CommandLine = 'CommandLineEventConsumer';
            EventLog    = 'NTEventLogEventConsumer';
            LogFile     = 'LogFileEventConsumer';
            Script      = 'ActiveScriptEventConsumer';
            SMTP        = 'SMTPEventConsumer';
            }
	}
	
	process
	{
		Write-Verbose -Message "${CmdletName}: Start running PROCESS block";

        $ConsumerClass = $ConsumerTypeList.$ConsumerType;
        Write-Verbose -Message ('{0}: Consumer type is: {1}' -f $CmdletName, $ConsumerType);
        $Consumer = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Class $ConsumerClass -Filter ("Name = '{0}'" -f ${Name});

        if ($Consumer) {
            try {
                $Consumer.Delete();
            }
            catch {
                Write-Error -Exception $_ -Message ('{0}: Failed to delete consumer with name: {1}' -f ${CmdletName}, ${Name});
            }
        }
	}
	
	end
	{
		Write-Verbose -Message "${CmdletName}: Start running END block";
	}
}

# Export the Remove-WmiEventConsumer function
Export-ModuleMember Remove-WmiEventConsumer

# Create and export an alias for the function
New-Alias -Name rwmic -Value Remove-WmiEventConsumer;
Export-ModuleMember -Alias rwmic;