
$ErrorActionPreference = "Stop"

$url = "http://localhost:8080/health"
$response = $null

Write-Host "Checking application health..."

# Retry for up to 30 seconds
for ($i = 0; $i -lt 15; $i++) {
    try {
        $response = Invoke-RestMethod `
            -Uri $url `
            -Method Get `
            -TimeoutSec 3

        if ($response.status -eq "UP") {
            Write-Host "Application is healthy!"
            Write-Host "Status: $($response.status)"
            exit 0
        }
    }
    catch {
        Write-Host "Application not ready yet. Attempt: $($i + 1)"
    }

    Start-Sleep -Seconds 2
}

throw "Smoke test failed: Application did not become healthy."
