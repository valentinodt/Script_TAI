# Définition des paramètres IP statiques
$ipv4Address = "192.168.1.100"
$subnetMask = "255.255.255.0"
$defaultGateway = "192.168.1.1"
$dnsServer = "127.0.0.1" # Adresse IP du serveur DNS local

# Configuration de l'adresse IP statique sur la carte réseau
Write-Host "Configuration de l'adresse IP statique sue la carte réseau..."
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ipv4Address -Prefix 24 -DefaultGateway $defaultGateway


# Configuration des serveurs DNS
Write-Host "Configuration des serveurs DNS..."
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsServer


# Attendre quelques secondes pour que les changements prennent effet
Start-Sleep -Seconds 10


# Renommer le PC en SRV-DNS avant de redémarrer
Write-Host "Renommage du PC en SRV-DNS..."
Rename-Computer -NewName "SRV-DNS" -Force


# Installer le rôle DNS
Write-Host "Installation du rôle DNS..."
Install-WindowsFeature -Name DNS -IncludeManagementTools -Restart


# Attendre le redémarrage du serveur 
Write-Host "En attente du redémarrage du serveur..."
Start-Sleep -Seconds 60


# Importer le module DNS
Write-Host "Importation du module DNS..."
Import-Modules DnsServer


# Configurer les zonrs Forward Lookup et Reverses Lookup principales
$forwardZoneName = "exemple.local"
$reverseZoneName = "192.168.1.0/24"

Write-Host "Création de la zone Forward Lookup '$forwardZoneName'..."
Add-DnsServerPrimaryZone -Name $forwardZoneName -ReplicationScope Forest

Write-Host "Création de la zone Reverse Lookup '$reverseZoneName'..."
Add-DnsServerPrimaryZone -NetworkId ($reverseZoneName.Split('/'))[0] -Name $reverseZoneName -ReplicationScope Forest


Write-Host "La configuration du serveur DNS s'est correctement terminée !"
