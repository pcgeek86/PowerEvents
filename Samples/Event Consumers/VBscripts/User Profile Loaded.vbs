set fso = CreateObject("Scripting.FileSystemObject")
set LogFile = fso.OpenTextFile("c:\temp\User Profile Loaded.log", 8, true)
call LogFile.WriteLine(Date() & " " & Time() & ": User profile loaded script has begun")
' call LogFile.WriteLine(TargetEvent.TargetInstance.LocalPath)


' Option Explicit
dim fso, LogFile

' If TargetEvent is not defined, then we are not running the script from the ActiveScriptEventConsumer
'if wscript then
'	ScriptConsumer = false
'end if
