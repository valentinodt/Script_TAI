# Définition des paramètres IP statiques
$ipv4Address = "192.168.1.100"
$subnetMask = "255.255.255.0"
$defaultGateway = "192.168.1.1"
$dnsServer = "127.0.0.1" # Adresse IP du serveur DNS local

# Configuration de l'adresse IP statique sur la carte réseau
Write-Output "Configuration de l'adresse IP statique sue la carte réseau..."
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ipv4Address -Prefix 24 -DefaultGateway $defaultGateway


# Configuration des serveurs DNS
Write-Output "Configuration des serveurs DNS..."
Set-DnsClientServerAdress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServer


# Attendre quelques secondes pour que les changements prennent effet
Start-Sleep -Second 10


# Renommer le PC en SRV-DNS avant de redémarrer
Write-Output "Renommage du PC en SRV-DNS..."
Rename-Computer -NewName "SRV-DNS" -Force


# Installer le rôle DNS
Write-Output "Installation du rôle DNS..."
Install-WindowsFeature -Name DNS -IncludeManagementTools -Restart