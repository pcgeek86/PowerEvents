# TODO: Test creation of a new __FilterToConsumerBinding instance against a remote computer
# TODO: Rename this cmdlet to New-WmiEventBinding for consistency?

<#
	.Synopsis
	Creates a new binding between a WMI event filter and a WMI event consumer.
	
	.Description
	Creates a new binding between a WMI event filter and a WMI event consumer.
	
	.Parameter ComputerName
	The computer name to perform the operation against.
	
	.Parameter Namespace
	The WMI namespace to create the instance of __FilterToConsumerBinding in.
	
	.Parameter Filter
	The WMI event filter instance to use for the permanent event filter/consumer binding.
	
	.Parameter Consumer
	The WMI event consumer instance to use for the permanent event filter/consumer binding.
	
	.Parameter SlowDownProviders
	A boolean value that determines whether or not WMI will slow down providers in order to keep up with event processing. NOT RECOMMENDED TO ENABLE!
	
	.Inputs
	No inputs available. Piping objects to New-WmiFilterToConsumerBinding is not possible.
	
	.Outputs
	A System.Management.ManagementObject representing the new __FilterToConsumerBinding WMI instance.
	
	.Link
	http://trevorsullivan.net
	
	.Link
	http://powershell.artofshell.com
#>
function New-WmiFilterToConsumerBinding 
{
	[CmdletBinding(
		  SupportsShouldProcess = $false
		, SupportsTransactions  = $false
		, ConfirmImpact         = 'Low'
	)]
	
	#region New-WmiFilterToConsumerBinding Parameters
	param(
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the computer name to create the binding on."
		)]
		[string]
		${ComputerName} = 'localhost'
		,
		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify the namespace where you would like to create the filter/consumer binding."
		)]
		[ValidateSet("root\subscription")]
		[string]
		${Namespace} = 'root\subscription'
		,
		[parameter(
			  Mandatory   = $true
			, HelpMessage = "Please specify the WMI __EventFilter instance to use for this binding."
            , ValueFromPipelineByPropertyName = $true
		)]
		[alias("WmiFilter")]
		[ValidateNotNull()]
		[System.Management.ManagementObject]
		${Filter}
		,
		[parameter(
			  Mandatory   = $true
			, HelpMessage = "Please specify the WMI event consumer for this binding."
            , ValueFromPipelineByPropertyName = $true
		)]
		[alias("EventConsumer", "WmiEventConsumer")]
		[ValidateNotNull()]
		[System.Management.ManagementObject]
		${Consumer}
		,
		[parameter(
			  Mandatory   = $false
			, HelpMessage = 'Please specify whether or not to maintain security context.'
		)]
		[bool]
		${MaintainSecurityContext} = $false
		,

		[parameter(
			  Mandatory   = $false
			, HelpMessage = "Please specify whether or not to slow down WMI providers in order to keep up with event handling. NOT RECOMMENDED!"
		)]
		[bool]
		${SlowDownProviders} = $false
	)
	#endregion New-WmiFilterToConsumerBinding Parameters
	
	#region New-WmiFilterToConsumerBinding BEGIN block
	begin
	{
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name
		Write-Verbose -Message ('{0}: Start running BEGIN block' -f ${CmdletName});
		# TODO: Validate WMI instance paths passed to ${Filter} and ${Consumer} parameters
		
		# TODO: Validate that the ${Namespace} is valid on the ${ComputerName} specified (test bind)
	}
	#endregion New-WmiFilterToConsumerBinding BEGIN block
	
	#region New-WmiFilterToConsumerBinding PROCESS block
	process
	{
		Write-Verbose -Message "${CmdletName}: Start running PROCESS block";
		
		# Create new in-memory instance of __FilterToConsumerBinding
		${NewBinding} = ([wmiclass]"\\${ComputerName}\${Namespace}:__FilterToConsumerBinding").CreateInstance()

		# Cannot use braces around the Filter property name, otherwise PowerShell complains. Filter is a keyword in PowerShell
		if (${Filter})
		{
			${NewBinding}.Filter = ${Filter}.__PATH
			Write-Verbose -Message ("${CmdletName}: Defined the Filter property: " + ${Filter}.__PATH)
		}
		else
		{
			Write-Error -Message 'New-WmiFilterToConsumerBinding: ${Filter} parameter is $null. You must specify a valid instance of __EventFilter to the ${Filter} parameter of this function.'
		}

		# Write-Host ${Consumer}.GetType()
		Write-Debug -Message ("${CmdletName}: Consumer is of type: " + ${Consumer}.GetType())
		# A reference to the __EventConsumer (parent class) of the WMI event consumer
		if (${Consumer})
		{
			${NewBinding}.{Consumer} = ${Consumer}.__PATH
			Write-Verbose -Message ("${CmdletName}: Defined the Consumer property: " + ${Consumer}.__PATH)
		}
		# If the event consumer is $null, we can't continue with creating the __FilterToConsumerBinding instance
		else
		{
			Write-Error -Message ('{0}: ${Consumer} is $null. Unable to continue. Please get a reference to a WMI event consumer, or create a new one. Once you have an instance of __EventConsumer, please pass it to this function as the -Consumer parameter.' -f ${CmdletName});
		}
		
		${NewBinding}.{MaintainSecurityContext} = ${MaintainSecurityContext};
		${NewBinding}.{SlowDownProviders} = ${SlowDownProviders};
		
		${PutResult} = ${NewBinding}.Put()
		Write-Verbose -Message ('{0}: Wrote __FilterToConsumerBinding instance to WMI provider.' -f ${CmdletName});
	}
	#endregion New-WmiFilterToConsumerBinding PROCESS block
	
	#region New-WmiFilterToConsumerBinding END block
	end
	{
		Write-Verbose -Message ('{0}: Start running END block' -f ${CmdletName});
	}
	#endregion New-WmiFilterToConsumerBinding END block
}

# Export the Get-WmiFilterToConsumerBinding function
Export-ModuleMember -Function New-WmiFilterToConsumerBinding;

# Create and export alias for the function
New-Alias -Name nwmib -Value New-WmiFilterToConsumerBinding;
Export-ModuleMember -Alias nwmib;