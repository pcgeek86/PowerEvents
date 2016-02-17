function Remove-WmiEventFilter {
    <#
        .Synopsis
        Removes a WMI event filter, with the specified name.

        .Parameter Name
        The name of the WMI event filter that will be removed.

        .Parameter Namespace
        The WMI namespace where the WMI event filter resides.

        .Parameter ComputerName
        The name of the computer where the WMI event filter will be removed from.

        .Link
        http://trevorsullivan.net
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]
        ${Name}
        ,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('ns', 'WMINamespace')]
        [string]
        ${Namespace} = 'root\subscription'
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

    begin {
		# Get the cmdlet name for writing dynamic log messages
		${CmdletName} = $Pscmdlet.MyInvocation.MyCommand.Name

		Write-Verbose -Message "${CmdletName}: Start running BEGIN block";
    }

    process {
		Write-Verbose -Message "${CmdletName}: Start running PROCESS block";

        $Filter = Get-WmiObject -ComputerName ${ComputerName} -Namespace ${Namespace} -Class __EventFilter -Filter ("Name = '{0}'" -f ${Name});

        if ($Filter) {
            try {
                $Filter.Delete();
            }
            catch {
                Write-Error -Exception $_ -Message ('{0}: Failed to delete WMI event filter named ({1})' -f ${CmdletName}, ${Name});
            }
        }
        else {
            Write-Error -Message ('{0}: No WMI event filter found with name {1}' -f ${CmdletName},  ${Name});
        }
    }

    end {
		Write-Verbose -Message "${CmdletName}: Start running END block";
    }
}

# Export the function
Export-ModuleMember -Function Remove-WmiEventFilter;

# Create and export an alias
New-Alias -Name rmwmif -Value Remove-WmiEventFilter;
Export-ModuleMember -Alias rmwmif;