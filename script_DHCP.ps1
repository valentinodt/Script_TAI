# Mettre à jour le système et installer le rôle DHCP
Write-Output "Mise à jour le système et installation du rôle DHCP..."
$installResult = Install-WindowsFeature -Name DHCP-IncludeManagementTools 
