# Prompt for path (file or folder)
$path = Read-Host "Enter the full path of a file or folder to upload"

# Check if path exists
if (-not (Test-Path $path)) {
    Write-Host "ERROR: Path not found: $path"
    exit
}

# Prompt for webhook URL
$webhookUrl = Read-Host "Enter the webhook URL"

# Function to upload a single file
function Upload-File {
    param($filePath, $webhookUrl)

    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"

    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
    $fileName  = [System.IO.Path]::GetFileName($filePath)

    # Auto-detect MIME type
    Add-Type -AssemblyName System.Web
    $fileType = [System.Web.MimeMapping]::GetMimeMapping($filePath)

    $header = "--$boundary$LF" +
              "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"$LF" +
              "Content-Type: $fileType$LF$LF"

    $footer = "$LF--$boundary--$LF"

    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $footerBytes = [System.Text.Encoding]::ASCII.GetBytes($footer)

    $bodyBytes = $headerBytes + $fileBytes + $footerBytes

    $req = [System.Net.WebRequest]::Create($webhookUrl)
    $req.Method = "POST"
    $req.ContentType = "multipart/form-data; boundary=$boundary"
    $req.ContentLength = $bodyBytes.Length

    $reqStream = $req.GetRequestStream()
    $reqStream.Write($bodyBytes, 0, $bodyBytes.Length)
    $reqStream.Close()

    $response = $req.GetResponse()
    Write-Host "Uploaded $fileName ->" $response.StatusDescription
    $response.Close()
}

# If folder -> upload all files inside
if ((Get-Item $path).PSIsContainer) {
    Write-Host "Uploading all files from folder: $path"
    Get-ChildItem -Path $path -File | ForEach-Object {
        Upload-File -filePath $_.FullName -webhookUrl $webhookUrl
    }
}
else {
    # Single file
    Write-Host "Uploading file: $path"
    Upload-File -filePath $path -webhookUrl $webhookUrl
}
