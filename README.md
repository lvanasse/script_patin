# Script Patin

Ce script PowerShell permet de formater des lecteurs avec le système de fichiers exFAT et de copier un fichier spécifié sur ces lecteurs. Il prend en charge l'utilisation de plusieurs lecteurs simultanément et offre une option pour afficher des informations détaillées lors de l'exécution.

## Utilisation

Assurez-vous également d'utiliser PowerShell version 7.2.5 ou ultérieur pour exécuter ce script. Voici le lien pour télécharger la version 7.2.5: https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi

Avant d'exécuter le script, assurez-vous d'avoir configuré votre environnement PowerShell pour autoriser l'exécution de scripts. Vous pouvez le faire en exécutant la commande suivante en tant qu'**administrateur** dans PowerShell :

```powershell
Set-ExecutionPolicy RemoteSigned
```

Pour exécuter le script, utilisez la commande suivante :

```powershell
.\script_patin.ps1 -f NomDuFichier -dl LetterDeLecteur1,LetterDeLecteur2,LetterDeLecteur3
```

- `-f` : Spécifie le nom du fichier à copier sur les lecteurs.
- `-dl` : Spécifie une liste de lettres de lecteur séparées par des virgules.

Si les lettres de lecteur ne sont pas spécifiées, le script les demande à l'utilisateur. Il formate ensuite chaque lecteur avec le système de fichiers exFAT et copie le fichier spécifié sur chaque lecteur. Et cela est la même chose pour le fichier qu'on désire copier sur les lecteurs, s'il n'est pas spécifié dans l'exécution dans la commande, il sera demander à l'utilisateur pendant l'exécution du script.

## Exemple

```powershell
.\script_patin.ps1 -f cpa_acadie_2023.mp4 -dl E,F,G
```

Ce script copiera le fichier "cpa_acadie_2023.mp4" sur les lecteurs E, F et G après les avoir formatés avec le système de fichiers exFAT.
