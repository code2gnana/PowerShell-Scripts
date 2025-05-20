# Step 1: Connect to network share with credentials

New-PSDrive -Name P -PSProvider FileSystem -Root "\\vm-dev-auea-dc0\DOWNLOADS\"

# Step 2: Elevate (if not already running as admin)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator"))
{
    Write-Host "Restarting script as Administrator..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -File `"$PSCommandPath`""
    exit
}

# Step 3: Install package from network share
Copy-Item P:\azure-cli.msi C:\Temp\azure-cli.msi

$installerPath = "C:\Temp\azure-cli.msi"
Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait -NoNewWindow

# Step 4: Clean up mapped drive (optional)
Remove-PSDrive -Name P -Force
