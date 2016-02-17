<#

    Author: Trevor Sullivan
      Date: 2014-02-09
   Purpose: Retrieves a list of TODO items from the supporting scripts of this
            PowerShell module, and indicates the line number and file in which each
            item is located.
#>

Clear-Host;
$ScriptList = Get-ChildItem -Path $PSScriptRoot\* -Include *.ps1;

foreach ($Script in $ScriptList) {
    $Result = (Get-Content -Path $Script.FullName) -match '(?<=#.*)(?<!DONE.*)TODO(?!.*DONE)';
    $Result | Select-Object -Property PSChildName,ReadCount,@{ Name = 'String'; Expression = { $_.Trim(); } };
}
