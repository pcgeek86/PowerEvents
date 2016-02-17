Remove-Module -Name PowerEvents -ErrorAction SilentlyContinue
Import-Module -Name PowerEvents -ErrorAction SilentlyContinue

$VerbosePreference = 'continue'
$DebugPreference   = 'continue'

Get-WmiEventConsumer -ConsumerType Script -Name *b* -Verbose