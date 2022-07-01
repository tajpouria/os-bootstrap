echo 'Install Windows updates'

Install-Module PSWindowsUpdate -Confirm
Get-WindowsUpdate -Confirm
Install-WindowsUpdate -AcceptAll


if (-not (Get-Command 'choco' -errorAction SilentlyContinue))
{
  echo 'Install Chocolatey'
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


echo 'Install Chocolatey packages'

choco feature enable -n allowGlobalConfirmation
choco install brave vscode bitwarden skype postman lens docker-desktop microsoft-windows-terminal bloomrpc winrar dbeaver mongodb-compass virtualbox vlc hackfont choco install authy-desktop


echo 'Install WSL'

wsl --install
wsl --set-default-version 2
wsl --set-default Ubuntu

echo "Install Long Paths"

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
>> -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force