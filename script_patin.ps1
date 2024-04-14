# Pour trouver les lettres des clés
#Get-Volume | select-object -expandproperty Driveletter

# Entrée du path
$path = Read-Host "SVP, mettre le chemin du fichier contenant les videos."

# Entrée des lettres des clés
$usb = Read-Host "SVP, mettre les lettres des usb. Ex: A,B,C"

for ($i = 0; $i -lt $usb.length; $i++)
{
	Start-Job -Scriptblock 
	{
		# Pour changer le file system
		Format-Volume -DriveLetter $usb[$i] -FileSystem EXFAT -confirm:$false
		
		# Étape intermédiaire
		$usbpath = $usb[$i] + ":"

		# Copier fichier vers clé
		Copy-Item -Path $path -Destination $usbpath -verbose
	}
}