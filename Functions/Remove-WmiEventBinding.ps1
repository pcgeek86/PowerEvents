# TODO: Test what happens if you delete an __EventFilter instance while the __FilterToConsumerBinding instance still exists

function Remove-WmiEventBinding
{
	<#
		.Synopsis
		Removes a WMI event binding.
		
		.Description
		Removes a binding between a WMI event filter and a WMI event consumer. This function requires the input of a partial filter name and consumer name. These two parameters will be used to identify the binding instance to be removed, because __FilterToConsumerBinding does not provider a friendly "Name" property to identify them by.
		
		.Parameter FilterName
		Partial name of the event filter that the binding is using.
		
		.Parameter ConsumerName
		Partial name of the event consumer that the binding is using.
		
		.Component
		Windows Management Instrumentation (WMI)
		
		.Link
		http://trevorsullivan.net
		
		.Link
		http://powershell.artofshell.com
	#>
	
	param(
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = 'Please enter the WMI namespace where the __FilterToConsumerBinding instance exists.'
		)]
		[string]
		$Namespace = 'root\subscription'
		,
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = 'Please enter the Name of the WMI filter that the binding will be removed for.'
#            , ParameterSetName = 'filter'
		)]
		[string]
		${Filter}
		,
		[Parameter(
			  Mandatory   = $false
			, HelpMessage = 'Please enter the WMI namespace where the __FilterToConsumerBinding instance exists.'
#            , ParameterSetName = 'consumer'
		)]
		[string]
		${Consumer}
        ,
        [string]
        ${ConsumerNamespace} = 'root\subscription'
        ,
        [string]
        ${FilterNamespace} = 'root\subscription'
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({
            if (Test-Connection -ComputerName $_ -Count 1) { $true; }
            else { $false; }
            })]
        [string] 
        ${ComputerName} = '.'
	)
	
	begin {
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name;
        ${ParameterSetName} = $Pscmdlet.ParameterSetName;
		Write-Verbose -Message ('{0}: Start running BEGIN block' -f $CmdletName);

        <#
		# Replace wildcards (*) with WMI wildcards (%)
		if (${Filter}) {
			${Filter} = ${Filter}.Replace('*','%');
		}
		
		# Replace wildcards (*) with WMI wildcards (%)
		if (${Consumer}) {
			${Consumer} = ${Consumer}.Replace('*','%');
		}
        #>
	}
	
	process {
		Write-Verbose -Message ('{0}: Start running PROCESS block' -f $CmdletName);

        $Consumer = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${ConsumerNamespace} -Filter ("Name = '{0}'" -f ${Consumer}) -ErrorAction SilentlyContinue;
        $Filter   = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${FilterNamespace} -Filter ("Name = '{0}'" -f ${Filter}) -ErrorAction SilentlyContinue;

        $ConsumerRefQuery = 'REFERENCES OF {{0}} WHERE __CLASS = ''__FilterToConsumerBinding''' -f $Consumer.__PATH;
        $ConsumerRefList = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Query $ConsumerRefQuery;

        $FilterRefQuery = 'REFERENCES OF {{0}} WHERE __CLASS = ''__FilterToConsumerBinding''' -f $Filter.__PATH;
        $FilterRefList = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Query $FilterRefQuery;
	}
	
	end
	{
		Write-Verbose -Message ('{0}: Start running END block' -f $CmdletName);
	}
}

# Export the Remove-WmiEventBinding function
Export-ModuleMember -Function Remove-WmiEventBinding;

# Create an alias for the advanced function and export it
Set-Alias -Name rmwmib -Value Remove-WmiEventBinding;
Export-ModuleMember -Alias rmwmib;