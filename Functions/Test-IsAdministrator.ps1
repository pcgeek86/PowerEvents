function Test-IsAdministrator {
    <#
        .Synopsis
        Determines whether or not the user is a member of the local Administrators security group.

        .Outputs
        System.Bool
    #>
    [CmdletBinding()]
    param (
    )

    ${Identity} = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    ${Principal} = new-object System.Security.Principal.WindowsPrincipal(${Identity})
    ${IsAdmin} = $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    
    Write-Output -InputObject ${IsAdmin};
}