param (
    [string]$fileArgument = $null,
    [string[]]$driveLetters = @(),
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
    $fileName = Read-Host "Enter the file name"
    $fileArgument = (Resolve-Path $fileName).Path
}

# Check if file exists
if (-not (Test-Path $fileArgument)) {
    Write-Host "File not found: $fileArgument"
    # Quit the script
    exit
}

# List volumes with ExFAT or FAT file systems
$driveInfo = Get-Volume | Where-Object { $_.FileSystemType -in 'FAT32', 'exFAT', 'Unknown' -and $_.DriveLetter } | Select-Object DriveLetter, FileSystemType, @{Name="Size(MB)";Expression={[math]::Round($_.Size / 1MB, 2)}}

# Display drive information
Write-Host "Available drives:"
$driveInfo | Format-Table -AutoSize

if ($driveLetters.Count -eq 0) {
    $driveLetters = (Read-Host "Enter drive letters separated by comma (e.g., C, D)").Split(',')
}

Write-Host $fileArgument

# Start background jobs to format each drive to ExFAT and copy the file
foreach ($driveLetter in $driveLetters) {
    Start-Job -ScriptBlock {
        param ($dl, $file)
        # $formatOutput = Format-Volume -DriveLetter $dl -FileSystem exFAT -Confirm:$false
        # Write-Host "Output of formatting drive $dl to ExFAT:"
        # $formatOutput
        Write-Host $file 
        # Copy-Item -Path $file -Destination "$dl\"
        # Write-Host "File copied to drive $dl"
    } -ArgumentList $driveLetter, $fileArgument | Out-Null
}

# Wait for all jobs to complete
Get-Job | Wait-Job | Out-Null

# Receive output from each job
Get-Job | Receive-Job