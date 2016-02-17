function Get-WmiEventConsumer
{
	<#
	.Synopsis
	Retrieves WMI event consumer objects.
	
	.Description
	Retrieves WMI event consumers instances based on criteria passed to the function. The -Namespace All parameter value can be used to retrieve instances in all WMI namespaces on a given computer.
	
	.Link
	http://trevorsullivan.net
	
	.Link
	http://powershell.artofshell.com
	#>
	
	[CmdletBinding(
		  SupportsShouldProcess = $false
		, SupportsTransactions  = $false
		, ConfirmImpact         = 'Low'
	)]

    #region PARAM block
	param (
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the name of event consumer you would like to retrieve."
		)]
		[string]
		${Name}
		,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		${Namespace} = 'root\subscription'
		,
		# In the interest of think + type, I've adjusted these types from their actual WMI class names
		#   EventLog    = NTEventLogEventConsumer
		#   LogFile     = LogFileEventConsumer 
		#   Script      = ActiveScriptEventConsumer
		#   CommandLine = CommandLineEventConsumer
		#   SMTP        = SMTPEventConsumer
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the type of event consumer you would like to retrieve."
		)]
		[ValidateSet(
			  'EventLog'
			, 'LogFile'
			, 'CommandLine'
			, 'Script'
			, 'SMTP'
		)]
		[alias('Type')]
		${ConsumerType}
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('cn')]
        [ValidateScript({
            if (Test-Connection -ComputerName $_ -Count 1) { $true; }
            else { $false; }
            })]
        [string]
        ${ComputerName} = '.'
	)
    #endregion PARAM block
	
	Begin
	{
		# Get the cmdlet name for writing dynamic log messages
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name;
        Write-Verbose -Message ('{0}: Start running BEGIN block' -f ${CmdletName});

		$ConsumerClasses = @{
			Script      = "ActiveScriptEventConsumer";
			SMTP        = "SMTPEventConsumer";
			EventLog    = "NTEventLogEventConsumer";
			LogFile     = "LogFileEventConsumer";
			CommandLine = "CommandLineEventConsumer";
		}
	}

	Process
	{
        Write-Verbose -Message ('{0}: Start running BEGIN block' -f ${CmdletName});

		if (${Namespace} -ne 'All')
		{
			# Translate asterisks (wildcards) to percent signs (WMI wildcards)
			${Name} = ${Name}.Replace("*", "%")

			# $ConsumerList is an array that holds a list of WMI event consumers returned from WMI.
			# If multiple namespaces are queries for consumers, this will consolidate the results into a single variable.
			$ConsumerList = @();

			${ConsumerQuery} = "select * from __EventConsumer";
            if ($ConsumerType) {
                ${ConsumerQuery} += " where __CLASS = '{0}'" -f ${ConsumerClasses}.${ConsumerType};
            }

			Write-Verbose -Message ("${CmdletName}: Consumer query is: " + ${ConsumerQuery});
			${EventConsumerList} = Get-WmiObject -ComputerName ${ComputerName} -Query ${ConsumerQuery} -Namespace ${Namespace};
			
			if (${EventConsumerList})
			{
				Write-Verbose -Message ("${CmdletName}: Retrieved " + $Filters.Count + " event consumers from the ${Namespace} namespace.");
                foreach ($EventConsumer in $EventConsumerList) {
                    ${ConsumerList} += ${EventConsumer};
                }
			}
			else
			{
				Write-Verbose -Message ("${CmdletName}: Could not find any consumers with the specified name and type.");
			}
				
			
			Write-Output -InputObject ${ConsumerList};
		}
		else
		{
			
		}
	}

    end {
        Write-Verbose -Message ('{0}: Start running END block' -f ${CmdletName});
    }
}

# Export the Get-WmiEventConsumer function
Export-ModuleMember -Function Get-WmiEventConsumer

# Create an alias for the function
New-Alias -Name gwmic -Value Get-WmiEventConsumer;
Export-ModuleMember -Alias gwmic;