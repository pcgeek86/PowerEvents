$ServiceName = 'PS3 Media Server'
$Service = Get-WmiObject -Namespace root\cimv2 -Class Win32_Service -Filter "Name = '$Service'"
$Service.StopService()
$Service.StartService()