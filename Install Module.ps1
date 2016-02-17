<#
        .Author
        Trevor Sullivan
        
        .Date
        January 30th, 2012
        
        .Purpose
        The purpose of this script is to import a PowerShell module from wherever it 
        resides on the filesystem. To use this script, simply copy it to the root of 
        your module's folder, and execute it. Your working directory doesn't matter.
        
        Using this script avoids the need to copy your module to a valid path in the
        $env:PSModulePath Windows environment variable. That way, if your module is
        part of a source control repository, which may reside outside of the default
        paths defined in $env:PSModulePath, you can easily load the module without 
        the need to copy your module files to your default modules folder.
        
        Note: This script requires that the module folder name match the module name

#>


# Get the path the script is executing from     
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent;
Write-Debug -Message ("Install module script is running from: {0}" -f $ScriptPath);
# Get just the 'leaf' folder name of the script's execution path
$ModuleName = Split-Path -Path $ScriptPath -Leaf;

# Get the parent of the script path, which will be the newly added module search path
$ModulePath = Split-Path -Path $ScriptPath -Parent;

Write-Debug -Message ('$env:PSModulePath is set to: {0}' -f $env:PSModulePath);

# If $env:PSModulePath does not contain the new module path, then add it
if ($env:PSModulePath.Split(';') -notcontains $ModulePath) {
        $env:PSModulePath = $env:PSModulePath + (';{0}' -f $ModulePath);
}

# Silently remove the module, in case it is loaded
Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue;
# Load the module
$Module = Import-Module -Name $ModuleName -PassThru;


# Clean up
Remove-Variable -Name Module, ModulePath, ModuleName, ScriptPath;
$Module = $ModulePath = $ModuleName = $ScriptPath = $null;