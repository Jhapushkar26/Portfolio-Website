param(
    [string]$environment,
    [string]$server,
    [string]$deployDir
)

Write-Output "Starting deployment to $environment server: $server"

# Create directory if missing on remote server
Invoke-Command -ComputerName $server -Credential (Get-Credential) -ScriptBlock {
    param($deployDir)
    if (!(Test-Path $deployDir)) {
        New-Item -ItemType Directory -Path $deployDir
    }
} -ArgumentList $deployDir

# Copy files to remote server
$localPath = $PSScriptRoot
$remotePath = "\\$server\c$\Deployments"   # Or use your desired path
Write-Output "Copying files from $localPath to $remotePath"

Copy-Item "$localPath\*" -Destination $remotePath -Recurse -Force

Write-Output "Deployment to $environment server completed."
