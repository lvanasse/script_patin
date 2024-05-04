param (
    [string]$fileArgument = $null,
    [string]$dl = $null,
    [switch]$help
)

if ($help) {
    Write-Host "This script format multiple drive and copy a file onto all of them."
    Write-Host "Arguments:"
    Write-Host "-f : Specify the file you want to copy."
    Write-Host "-dl : Specify a list of drive letters."
    Write-Host "-help : Print this help message"
    exit
}

if (-not $fileArgument) {
    # Prompt user to enter file name
    $fileArgument = Read-Host "Enter the file name"
}

# Resolve the absolute path of the file
$fileAbsolutePath = (Resolve-Path $fileArgument).Path

# Check if file exists
if (-not (Test-Path $fileAbsolutePath)) {
    Write-Host "File not found: $fileAbsolutePath"
    # Quit the script
    exit
}

if (-not [string]::IsNullOrEmpty($dl)) {
    $dl = $dl -replace ' ', ','
    # Convert comma-separated list to array of drive letters
    $driveLetters = $dl -split ","

    # Check if each drive letter exists
    foreach ($driveLetter in $driveLetters) {
        $test_driverLetter = $driveLetter + ":\"
        if (-not (Test-Path $test_driverLetter)) {
            Write-Host "Drive $driveLetter does not exist. Exiting script. Please provid a driver letter that exist"
            exit
        }
    }
}
else {
    # List volumes with ExFAT or FAT file systems
    $driveInfo = Get-Volume | Where-Object { $_.FileSystemType -in 'FAT32', 'exFAT', 'Unknown' -and $_.DriveLetter } | Select-Object DriveLetter, FileSystemType, @{Name = "Size(MB)"; Expression = { [math]::Round($_.Size / 1MB, 2) } }
    # Display drive information
    Write-Host "Available drives:"
    $driveInfo | Format-Table -AutoSize
    # Prompt user to enter drive letters
    $driveLetters = (Read-Host "Enter drive letters separated by comma (e.g., C, D)").Split(',')
}

Write-Host "Drive letters provided: $($driveLetters -join ', ')"

# Start parallel jobs to format each drive to ExFAT and copy the file
$driveLetters | ForEach-Object -Parallel {
    $driveLetter = $_

    # Format drive to ExFAT
    Format-Volume -DriveLetter $driveLetter -FileSystem exFAT -Confirm:$false *> $null
    Write-Host "Drive $driveLetter formatted to ExFAT"

    # Copy file to drive
    $destinationPath = $driveLetter + ":\"

    Copy-Item -Path $using:fileAbsolutePath -Destination $destinationPath -Force
    Write-Host "File copied to drive $driveLetter"
}

# Wait for all jobs to complete
Get-Job | Wait-Job | Out-Null