$ErrorActionPreference = "Stop"

$deployDir = "C:\jenkins-deploy"
$jarName = "jenkins-demo-0.0.1-SNAPSHOT.jar"
$sourceJar = Join-Path $PWD "target\$jarName"
$destinationJar = Join-Path $deployDir $jarName

# Create deployment directory
New-Item -ItemType Directory -Force -Path $deployDir |
    Out-Null

# Stop the previously deployed application, if running
$existingProcess = Get-NetTCPConnection `
    -LocalPort 8080 `
    -State Listen `
    -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($existingProcess) {
    Stop-Process -Id $existingProcess.OwningProcess -Force
    Start-Sleep -Seconds 2
}

# Copy the new JAR
Copy-Item $sourceJar $destinationJar -Force

# Start the application
Start-Process -FilePath "java" `
    -ArgumentList "-jar `"$destinationJar`"" `
    -WorkingDirectory $deployDir

Write-Host "Application deployed successfully!"