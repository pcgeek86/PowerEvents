function Get-WmiEventFilter
{
	[CmdletBinding(SupportsShouldProcess = $false)]
	<#
		.Synopsis
		Retrieves an existing WMI event filter.
		
		.Description
		Retrieves an existing WMI event filter.
		
		.Parameter Namespace
		The namespace in which to retrieve __EventFilter instances from.
		
		.Parameter Name
		The name of the __EventFilter instance to retrieve.
		
		.Parameter ComputerName
		The computer on which to retrieve __EventFilter instances.
		
		.Parameter QuerySearchString
		String to search for inside the event filter's query text.
		
		.Inputs
		
	#>
	Param(
		# The name of the WMI event filter to retrieve. The name property is the key on the __EventFilter system WMI class.
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the name of the __EventFilter instance you would like to retrieve. Wildcards are acceptable."
            , ValueFromPipelineByPropertyName = $true
            , ValueFromPipeline = $true
		)]
		[string]
		${Name}
		,
		# The WMI namespace to retrieve event filters from.
		# TODO: Provide an option to retrieve ALL event filters from ALL namespaces?
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
		# TODO: Implement parameter to allow searching of the query text
		[string]
		[ValidateNotNull()]
		${QuerySearchString}
	)
	
	begin
	{
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name;

		Write-Debug -Message "${CmdletName}: `${Name} parameter's value is: ${Name}";
		Write-Debug -Message "${CmdletName}: `${Namespace} parameter's value is: ${Name}";
		Write-Debug -Message "${CmdletName}: `${QuerySearchString} parameter's value is: ${Name}";
		
		if (${Name})
		{
			# Translate asterisks (wildcards) to percent signs (WMI wildcards)
			${Name} = ${Name}.Replace("*", "%");
			${EventFilters} = Get-WmiObject -Namespace ${Namespace} -Query "SELECT * FROM __EventFilter WHERE Name LIKE '${Name}'";
		}
		else
		{
			# Translate asterisks (wildcards) to percent signs (WMI wildcards)
			${QuerySearchString} = ${QuerySearchString}.Replace("*", "%");
			${EventFilters} = Get-WmiObject -Query "SELECT * FROM __EventFilter WHERE Query LIKE '${QuerySearchString}'";
		}

		if (${EventFilters})
		{
			Write-Verbose -Message "${CmdletName}: Found $(${EventFilters}.psbase.Length) event filters";
			Write-Output -InputObject ${EventFilters};
		}
		else
		{
			Write-Warning -Message "${CmdletName}: No event filters were found with the specified criteria.";
		}
	}
}

Export-ModuleMember -Function Get-WmiEventFilter;

# Create alias for the Get-WmiEventFilter function
New-Alias -Name gwmif -Value Get-WmiEventFilter;
Export-ModuleMember -Alias gwmif;