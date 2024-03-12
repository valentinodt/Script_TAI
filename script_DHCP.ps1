# Mettre à jour le système et installer le rôle DHCP
Write-Output "Mise à jour le système et installation du rôle DHCP..."
$installResult = Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Vérifier si le redémarrage est nécessaire
if ($installResult.RestartNeeded -eq "Oui") {
    Write-Output "Un redémarrage est nécessaire pour terminer l'insatallation. Le serveur va redémarrer..."
    # Renommer le serveur en "SRV-DHCP" avant de redémarrer
    Rename-Computer -NewName "SRV-DHCP" -Force
    # Le script s'arrête ici, et vous devez redémarrer manuellement le serveur
    Restart-Computer
    exit
}

# ************************************************** #

# Importation du module DHCP
Import-Module DhcpServer

# Vérification de l'installation du rôle DHCP
if(!(Get-WindowsFeature DHCP -ErrorAction Stop))