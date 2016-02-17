'On Error Resume Next
set fso = CreateObject("Scripting.FileSystemObject")
' Open a text file. 8 = ForAppending; True = Create file if non-existent
set LogFile = fso.OpenTextFile("UFD Installed.log", 8, true)
call LogFile.WriteLine("UFD Installed")
call LogFile.WriteLine("UFD installed with serial number: " & TargetEvent.TargetInstance.VolumeSerialNumber)