$RequestingServer = $env:COMPUTERNAME
#Local Server Admin Account
[STRING] $LocalUser = "tajpouria" 
[STRING] $LocalPassword = ""
$LocalSecurePassword = $LocalPassword | ConvertTo-SecureString -AsPlainText -Force

$LocalCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $LocalUser, $LocalSecurePassword

#Update Windows Firewall Remotely
$LocalSession = New-PSSession -Computername $Server -Credential $LocalCredentials
Invoke-Command -Session $LocalSession -ScriptBlock {

$AddServer = $Using:RequestingServer

#Update Windows Firewall from Public to Private
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
#Update Windows Firewall to allow remote WMI Access
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=yes
#Update Trusted Hosts is not domain-joined and therefore must be added to the TrustedHosts list 
Set-Item wsman:\localhost\Client\TrustedHosts -Value $AddServer -Force
#Update Windows Firewall to allow RDP
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#Enable RDP : 1 = Disable ; 0 = Enable
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
}
