# PowerShell -ExecutionPolicy RemoteSigned .\adb-start.ps1

$currentSript = $PSScriptRoot + "\adb-start.ps1"
$adbPath = "C:\Users\Yoshikazu Arimitsu\AppData\Local\Android\Sdk\platform-tools"
$adbPort = 5037
$adbListenAddress = '0.0.0.0'
$adbConnectAddress = '127.0.0.1'

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $FALSE)
{
    Start-Process "powershell.exe" -ArgumentList $currentSript -WindowStyle hidden -Verb runAs
}

# Set ADB path
Set-Location $adbPath

# Remove port mapping
netsh interface portproxy delete v4tov4 listenport=$adbPort listenaddr=$adbListenAddress

# Kill server
./adb.exe kill-server

# Start server
./adb.exe start-server

# Add port mapping
netsh interface portproxy add v4tov4 listenport=$adbPort listenaddr=$adbListenAddress connectport=$adbPort connectaddr=$adbConnectAddress

# Display portproxy
netsh interface portproxy show v4tov4

# Start WSL
# wsl --exec exit

# Remove firewall rule for WSL
Set-NetFirewallProfile -DisabledInterfaceAliases "vEthernet (WSL)"
