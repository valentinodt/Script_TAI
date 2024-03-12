Write-Host "Installation du rôle Active Directory Domain Services..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Restart


Write-Host "Attente du redémarrage du serveur..."
Start-Sleep -Seconds 60


Start-Sleep -Seconds 10


Write-Host "Renommage du serveur en SRV-AD..."
Rename-Computer -NewName "SRV-AD" -Force -Restart


Write-Host "Attente du redémarrage du serveur après le renommage..."
Start-Sleep -Seconds 60


$domainName = "mondomaine.local"
$adminUsername = "Admin"
$adminPassword = "MotDePasse123"



Write-Host "Configuration du domaine Active Directory..."
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath"C:\Windows\NTDS" -DomainNetBIOSName "MONDOMAINE" -DomainMode Win2012R2 -DomainName $domainName -DomainType ThreeDomainWholeForest -Force -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $adminPassword -Force) -Verbose


Write-Host "Attente de la configuration du domaine..."
Start-Sleep -Seconds 60


Write-Host "Création de l'unité d'organisation PC-Clients..."
New-ADOrganizationalUnit -Name "PC-Clients" -Path ("DC=" + ($domainName -split '\.' | Select-Object -First 2) -join ', DC=')


Write-Host "Création des utilisateurs et ajout aux PC-Clients..."
for ($i = 1; $i -le 10; $i++) {
 ...
}


Write-Host "La configuration du serveur Active Directory est terminée !"


# Installer le rôle Active Directory Domain Services
Write-Host "Installation du rôle Active Directory Domain Services..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Restart


# Attendre le redémarrage du serveur
Write-Host "Attente du redémarrage du serveur..."
Start-Sleep -Seconds 60


# Renommer le serveur en "SRV-AD"
Write-Host "Renommage du serveur en SRV-AD..."
Rename-Computer -NewName "SRV-AD" -Force -Restart

# Attendre le redémarrage du serveur après le renommage
Write-Host "Attente du redémarrage du serveur après le renommage..."
Start-Sleep -Seconds 60

# Définir les paramètres du domaine
$domainName = "mondomaine.local"
$adminUsername = "Admin"
$adminPassword = "MotDePasse123"

# Configurer le domaine Active Directory
Write-Host "Configuration du domaine Active Directory..."
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomaineNetBIOSName "MONDOMAINE" -DomainMode Win2012R2 -
DomainName $domainName -DomainType ThreeDomainWholeForest -Force -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion -SysvolPath "C:\Windows\SYSVOL" -
SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $adminPassword -Force) -Verbose


# Attendre que la configuration du domaine soit terminée
Write-Host "Attente de la configuration du domaine..."
Start-Sleep -Seconds 60


# Créer l'unité d'organisation (OU) "PC-Clients"
Write-Host "Création de l'unité d'organisation PC-Clients..."
New-ADOrganizationalUnit -Name "PC-Clients" -Path ("DC=" + ($domainName -split '\.' | Select-Object -First 2) -join ', DC=')

# Créer 10 utilisateurs avec le rôle administrateur pour les PC membres de l'OU "PC-Clients"
Write-Host "Création des utilisateurs et ajout aux PC-Clients..."
for ($i = 1; $i -le 10; $i++) {
    $userName = "User$i"
    $userPassword = ConvertTo-SecureString -String "Password$i" -AsPlainText -Force
    $userPrincipal = "$userName@$domainName"
    $newUser = New-ADUser -Name $userName -AccountPassword $userPassword -UserPrincipalName $userPrincipal -Enabled $true -PassThru
    
    # Ajouter l'utilisateur au groupe "Domain Admins"
    Add-ADPrincipalGroupMembership -Identity $newUser -Members "Domain Admins"
    
    # Déplacer l'utilisateur vers l'OU "PC-Clients"
    Move-ADObject -Identity $newUser -TargetPath "OU=PC-Clients," + ($domainName -split '\.',2)[1].Replace('.','=')
}

Write-Host "La configuration du serveur Active Directory est terminée !"




