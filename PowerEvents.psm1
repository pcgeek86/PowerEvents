function Write-Introduction
{
	Write-Host "Thank you for installing the $($PowerEvents.ModuleName) module!"
	Write-Host "".PadLeft(40, "=")
	
}

# TODO: Build a Windows Installer (MSI) package for PowerEvents

# Define the name of the module
# Build a hashtable with basic properties for use elsewhere in the module
$Global:PowerEvents = @{
	ModuleName = "PowerEvents"
}

#region Get script path
$MyInvocation.MyCommand.Path
${ScriptPath} = Split-Path $MyInvocation.MyCommand.Path
#Write-Host "Script path is: ${ScriptPath}"
#endregion

Write-Host -Object ('Loading PowerShell module: {0}' -f $PowerEvents.ModuleName);

#region Check admin rights
# Check if user token is an administrator

. ${ScriptPath}\Functions\Test-IsAdministrator.ps1;

if (-not (Test-IsAdministrator))
{
	Write-Error -Message 'User is not an administrator. Module installation cannot continue.' -RecommendedAction 'Please import this module as an administrator.';
#	Remove-Module $PowerEvents.ModuleName
	return;
}
#endregion Check admin rights

#region Dot-source cmdlet scripts
# Dot-source supporting scripts
try
{
    ${ScriptList} = @(
          'New-WmiEventFilter.ps1'
        , 'New-WmiEventConsumer.ps1'
        , 'New-WmiFilterToConsumerBinding.ps1'
        , 'Get-WmiEventConsumer.ps1'
        , 'Get-WmiEventFilter.ps1'
        , 'Get-WmiEventBinding.ps1'
        , 'Remove-WmiEventConsumer.ps1'
        , 'Remove-WmiEventFilter.ps1'
        , 'Remove-WmiEventBinding.ps1'
        );

    foreach (${Script} in ${ScriptList}) {
	    . ${ScriptPath}\Functions\${Script};
    }
}
catch
{
    Write-Error -Exception $_ -Message "$($PowerEvents.ModuleName): Error occurred while loading module functions.";
}

#endregion

# Call the function to write some help to the screen
# TODO: Implement this function. Commenting out for initial release
# Write-Introduction

Write-Host "Finished loading PowerShell module: $($PowerEvents.ModuleName)"

# TODO: Create a module manifest
<#
New-ModuleManifest `
	-Author 'Trevor Sullivan' `
	-CmdletsToExport * `
	-FileList $(Get-ChildItem *) `
	-Copyright 'Trevor Sullivan' `
	-CompanyName 'Trevor Sullivan'
	
#>