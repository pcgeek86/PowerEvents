Clear
Remove-Module -Name PowerEvents -ErrorAction SilentlyContinue
Import-Module -Name PowerEvents -ErrorAction SilentlyContinue

$VerbosePreference = 'continue'
$DebugPreference   = 'continue'

Get-WmiEventFilter -Name Matt