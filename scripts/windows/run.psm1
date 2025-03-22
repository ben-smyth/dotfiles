$chocolateyPackages = @(
    'googlechrome'
    'vscode'
    'obsidian'
)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "This PowerShell session is not running with elevated permissions. Please run PowerShell as an Administrator."
    exit
} else {
    Write-Output "This PowerShell session is running with elevated permissions."
}


if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey not found. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey is already installed."
}

foreach ($package in $chocolateyPackages ) {
    choco install $package -y --ignore-checksums
}
