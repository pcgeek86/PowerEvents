# TODO: Check if a filter with the same name already exists, and prompt user if they want to overwrite (use the -Force parameter)
# TODO (DONE): Check if user is an administrator. If not, write an error message informing them of this, and hope they haven't set $ErrorActionPreference to 'SilentlyContinue' :)

#region New-WmiEventFilter
function New-WmiEventFilter
{
	<#
		.Synopsis
		Creates a new WMI event filter.
		
		.Description
		Creates a new instance of __EventFilter in the specified namespace. This is typically used in concert with an instance of an event consumer, and a __FilterToConsumerBinding.
		
		.Parameter Name
		A unique name for the event filter. If this parameter is not specified, then a random GUID will be used to identify the event filter. It is highly recommended to use a friendly name for event filters, to avoid confusion when managing them in the future.
		
		.Parameter Namespace
		The WMI namespace in which the the event filter will be executed. This is NOT the same as the namespace where the __EventFilter instance will be created.
		
		.Parameter Query
		The WQL event query that the filter will use to poll for events.
		
		.Parameter QueryLanguage
		The language used to write the event query. This will almost always be 'WQL'.
		
		.Parameter ComputerName
		The computer on which to create the WMI event filter.
		
		.Inputs
		None
		
		.Outputs
		A System.Management.ManagementObject, representing an instance of the __EventFilter WMI class. The output can be stored in a variable, and then used with New-WmiFilterToConsumerBinding.
		
		.Component
		Windows Management Instrumentation (WMI)
		
		.Link
		http://trevorsullivan.net
		
		.Link
		http://powershell.artofshell.com
		
		.Link
		http://msdn.microsoft.com/en-us/library/aa392902(VS.85).aspx

		.Link
		http://msdn.microsoft.com/en-us/library/aa394639(VS.85).aspx
		
		.Link
		http://www.codeproject.com/KB/system/PermEvtSubscriptionMOF.aspx?display=Print
	#>

	[CmdletBinding(
		  SupportsShouldProcess = $false
		, SupportsTransactions  = $false  # Script cmdlets cannot support transactions. Only compiled cmdlets can support them.
		, ConfirmImpact         = 'Low'   # This function has a minimal impact on data loss
	)]

	#region New-WmiEventFilter Parameters
	param(
		[Parameter(
			  Mandatory   = $false
			, Position    = 1
			, HelpMessage = "Please enter a name for the event filter."
		)]
		[string]
		[alias("FilterName", "fltr")]
		${Name}
		,
		# TODO: Use script validation to ensure that this namespace is valid
		[Parameter(
			  Mandatory   = $false
			,  Position    = 0
			, HelpMessage = "Please specify the namespace where the event query should be executed against."
		)]
		${EventNamespace} = 'root\cimv2'
		,
		[Parameter(
			  Mandatory   = $true
			, ParameterSetName = 'WqlQuery'
			, HelpMessage = "Please specify the WQL event query to be used for this event filter."
		)]
		[string]
		[alias("WQLQuery", "qry")]
		${Query}
		,
		# This parameter MUST be set to 'WQL'
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the query language for this event filter; Must be 'WQL'."
		)]
		[ValidateSet("WQL")]
		[string]
		${QueryLanguage} = 'WQL'
		,
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the computer to create the WMI event filter on."
		)]
		[string]
		${ComputerName} = '.'
		,
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the namespace where the __EventFilter instance should be created."
		)]
		<#
		This [ValidateScript()] block ensures that the user has passed a valid namespace to the function.
		UPDATE: After testing, this won't work, because we can't use ${ComputerName} to test a namespace on a remote system.
		        This validation code will have to go in the BEGIN { ... } block
		[ValidateScript({
			Write-Verbose -Message ${ComputerName}
			if (([wmiclass]"\\${ComputerName}\root\cimv2:__ThisNamespace").__namespace -eq $_)
			{
				return $true
			}
			else
			{
				return $false
			}
		})]
		#>
		[ValidateSet("root\subscription")]
		${Namespace} = 'root\subscription'
		
		# TODO: Build a new parameter set ( call it "QueryBuilder"?) to allow for query building. Include parameters such as:
		#    "ClassName"       = ex. Win32_Process, Win32_ProcessStartTrace
		#	    If "ClassName" is implemented, use the [ValidateScript()] attribute to ensure the class exists
		#    "EventType"       = Intrinsic or Extrinsic -- alternative: write some code to automatically detect this based on the ClassName?
		#    "PollingInterval" = the polling interval for the WITHIN clause of the event query
	)
	#endregion New-WmiEventFilter Parameters
	
	#region New-WmiEventFilter Begin block
	begin
	{
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name
		Write-Verbose -Message "${CmdletName}: Running the BEGIN block"

		#region Check if user token is an administrator
		${Identity} = [System.Security.Principal.WindowsIdentity]::GetCurrent()
		${Principal} = new-object System.Security.Principal.WindowsPrincipal(${Identity})
		${IsAdmin} = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
		if (-not ${IsAdmin})
		{
			Write-Error -Message "${CmdletName}: User is not an administrator. Cannot continue." -RecommendedAction "${CmdletName}: Please run this function as an administrator."
		}
		#endregion Check if user token is an administrator
  
  		#region Check for existence of ${EventNamespace} and ${Namespace}
		if (([wmiclass]"\\${ComputerName}\${EventNamespace}:__ThisNamespace").__namespace -eq ${EventNamespace})
		{
			Write-Verbose -Message "${CmdletName}: Validated the existence of WMI namespace passed to `${EventNamespace} (\\${ComputerName}\${EventNamespace})"
		}
		else
		{
			Write-Error -Message "${CmdletName}: Could not validate the existence of WMI namespace passed to `${EventNamespace} (\\${ComputerName}\${EventNamespace})" -TargetObject ${EventNamespace} -ErrorAction Stop
		}

		if (([wmiclass]"\\${ComputerName}\${Namespace}:__ThisNamespace").__namespace -eq ${Namespace})
		{
			Write-Verbose -Message "${CmdletName}: Validated the existence of WMI namespace passed to `${Namespace} (\\${ComputerName}\${Namespace})"
		}
		else
		{
			Write-Error -Message "${CmdletName}: Could not validate the existence of WMI namespace passed to `${Namespace} (\\${ComputerName}\${Namespace})" -TargetObject ${Namespace} -ErrorAction Stop
		}
  		#endregion Check for existence of ${EventNamespace} and ${Namespace}
  
  		#region Check for existing __EventFilter with same name
		# Check to see if an instance of __EventFilter with the requested name already exists
		if (${Name})
		{
			Write-Verbose -Message "Looking for existing instances of __EventFilter in namespace ${Namespace} with the name ${Name}"
			${ExistingFilter} = Get-WmiObject -Namespace ${Namespace} -ComputerName ${ComputerName} -Class __EventFilter -Filter "Name = '${Name}'"
			if (${ExistingFilter})
			{
				Write-Warning -Message "${CmdletName}: __EventFilter instance already exists with name ${Name}"
				#Write-Output -InputObject ${ExistingFilter}
			}
		}
  		#endregion Check for existing __EventFilter with same name
	}
	#endregion New-WmiEventFilter Begin block
	
	#region New-WmiEventFilter Process block
	process
	{
		${NewFilter} = ([wmiclass]"\\${ComputerName}\${Namespace}:__EventFilter").CreateInstance()
		Write-Verbose -Message "${CmdletName}: Created new instance of __EventFilter"
		
		# The QueryLanguage will always be 'WQL' for WMI event queries
		${NewFilter}.{QueryLanguage} = ${QueryLanguage}
		Write-Verbose -Message "${CmdletName}: Defined the QueryLanguage property"
		
		# The WQL event query that will be used to capture events
		if (${NewFilter})
		{
			${NewFilter}.{Query} = ${Query}
			Write-Verbose -Message "${CmdletName}: Defined the Query (${Query}) property"
		}
		
		# The namespace that events will be captured in.
		# Example: root\cimv2, if your event query targets Win32_Process
		if (${EventNamespace})
		{
			${NewFilter}.{EventNamespace} = ${EventNamespace}
			Write-Verbose -Message "${CmdletName}: Defined the EventNamespace (${EventNamespace}) property"
		}
		else
		{
			Write-Warning -Message "${CmdletName}: `${EventNamespace} parameter was not specified." -WarningAction "Please specify a valid WMI namespace"
		}
		
		# The unique name for the event filter instance
		if (${Name})
		{
			${NewFilter}.{Name} = ${Name}
			Write-Verbose -Message "${CmdletName}: Defined the Name (${Name}) property"
		}
		else
		{
			Write-Verbose "${CmdletName}: `${Name} parameter was not specified. Defaulting to random GUID for Name property."
		}
		
		# Write the __EventFilter instance to the WMI provider
		Write-Verbose -Message "${CmdletName}: Preparing to commit __EventFilter instance to WMI: ${PutResult}"
		${PutResult} = ${NewFilter}.Put()

		if (${PutResult}.Path)
		{
			Write-Verbose -Message ('${CmdletName}: Committed new __EventFilter instance: ' + ${PutResult}.{Path})
			# Write new __EventFilter instance to the pipeline
			Write-Output $([wmi]"$(${PutResult}.{Path})")
		}
		else
		{
			Write-Error -Message "${CmdletName}: Failed to commit __EventFilter instance to WMI." -ErrorAction Stop
		}

	}
	#endregion New-WmiEventFilter Process block
	
	#region New-WmiEventFilter End block
	end
	{
		Write-Verbose -Message "${CmdletName}: Running the END block"
	}
	#endregion New-WmiEventFilter End block
}
#endregion New-WmiEventFilter

# Export the advanced function for use in the module
Export-ModuleMember -Function New-WmiEventFilter

# Create and export an alias for the advanced function
Set-Alias -Name nwmif -Value New-WmiEventFilter
Export-ModuleMember -Alias nwmif