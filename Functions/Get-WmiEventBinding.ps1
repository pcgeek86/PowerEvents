function Get-WmiEventBinding
{
	[CmdletBinding(SupportsShouldProcess = $false)]
	<#
		.Synopsis
		Retrieves WMI event bindings
		
		.Description
		The Get-WmiEventBinding function retrieves WMI event binding instances from the specified computer
        and WMI namespace. You can specify either the -Filter or -Consumer parameter, to identify which
        WMI event bindings you would like to retrieve, based on the bound filter or consumer. WMI event
        bindings are instances of the __FilterToConsumerBinding WMI class.
		
		.Parameter Namespace
		The namespace in which to retrieve WMI event bindings from.
		
		.Parameter Filter
		The name of the WMI event filter that you would like to retrieve 
		
		.Parameter ComputerName
		The computer on which to retrieve __FilterToConsumerBinding instances.
	#>
	Param(
		# The name of the WMI event filter to retrieve. The name property is the key on the __FilterToConsumerBinding system WMI class.
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the name of the WMI event filter instance that you would like to retrieve bindings for."
            , ParameterSetName = 'filter'
		)]
		[string]
		${Filter}
		,
        [Parameter(ParameterSetName = 'consumer')]
        [string]
        ${Consumer}
        ,
		# The WMI namespace to retrieve event filters from.
		# TODO: Provide an option to retrieve ALL event filters from ALL namespaces?
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('ns')]
        [string]
		${Namespace}
		,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('cn')]
        [ValidateScript({
            if (Test-Connection -ComputerName $_ -Count 1) { $true; }
            else { $false; }
            })]
		[string]
		${ComputerName} = '.'
		,
		# TODO: Implement parameter to allow searching of the query text
		[string]
		${QuerySearchString}
        ,
        [Parameter(ParameterSetName = 'all')]
        [switch]
        ${All}
	)
	
	begin
	{
		# Get the cmdlet name for writing dynamic log messages
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name
        ${ParameterSetName} = $Pscmdlet.ParameterSetName;

		Write-Verbose -Message "${CmdletName}: Start running BEGIN block";
	}

    process {
		Write-Verbose -Message "${CmdletName}: Start running PROCESS block";

        if (${ParameterSetName} = 'all') {
            $BindingList = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Class __FilterToConsumerBinding;
        }
        elseif (${ParameterSetName} = 'filter') {
            ${WmiQuery} = "REFERENCES OF {__EventFilter='{0}'} WHERE ResultClass = __FilterToConsumerBinding" -f ${Filter};
            $BindingList = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Query ${WmiQuery} -ErrorAction Stop;
        }
        elseif (${ParameterSetName} = 'consumer') {
            ${WmiQuery} = "REFERENCES OF {__EventConsumer='{0}'} WHERE ResultClass = __FilterToConsumerBinding" -f ${Consumer};
            $BindingList = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Query ${WmiQuery} -ErrorAction Stop;
        }
        # Get a list of WMI filter-to-consumer bindings

        if ($BindingList) {
            Write-Output -InputObject $BindingList;
        }
        else {
            Write-Error -Message ('{0}: Could not find any matching WMI event bindings' -f ${CmdletName});
        }
		# Translate asterisks (wildcards) to percent signs (WMI wildcards)
		#${Name} = ${Name}.Replace("*", "%");
    }

    end {
    }
}

# Export the Get-WmiEventBinding function
Export-ModuleMember -Function Get-WmiEventBinding;

# Export an alias for the function
New-Alias -Name gwmib -Value Get-WmiEventBinding;
Export-ModuleMember -Alias gwmib