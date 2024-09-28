# By :    ABayoumy@outlook.com
# GitHub: https://github.com/Aabayoumy/PS-Profile

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or higher. Please upgrade your PowerShell version."
    Read-Host "Press any key to exit"
    exit
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script needs to be run as an administrator."
    Read-Host "Press any key to exit"
    exit
}

# Define fonts  hashtable
$fonts = @(
    "FiraCode",
    "Hack",
    "JetBrainsMono",
    "SourceCodePro"
)

function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

Write-Host "Install starship https://starship.rs/ if not installed"
if (-not (Test-CommandExists winget)) {
        Write-Host "winget is not installed or not in your PATH. you have to install starship manually"
        Start-Process "https://starship.rs/" 
    else {
        if ((Test-CommandExists starship).count -lt 5) { winget install Starship.Starship --force }
    }
}

function Install-NerdFonts {
    param (
        [string]$nerdfontsVersion,
        [array]$fonts
    )

    foreach ($fontName in $fonts) {
            Write-Host "Downloading and installing $fontName font"
            Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/$($nerdfontsVersion)/$fontName.zip" -OutFile "$env:TEMP\$zipFileName.zip"
            Expand-Archive -LiteralPath "$env:TEMP\$fontName.zip" -DestinationPath "$env:TEMP\Fonts\" -force
    }

    Write-Host "Install fonts"
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in Get-ChildItem "$env:TEMP\Fonts\*.ttf")
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            Write-Output $fileName
            Get-ChildItem $file | ForEach-Object{ $fonts.CopyHere($_.fullname,16) }
        }
    }
    Move-Item "$env:TEMP\Fonts\*.ttf" "C:\Windows\Fonts\" -force
}


$latestTerminalIconsVersion = (Find-Module -Name "Terminal-Icons").Version
$installedModule = Get-Module -ListAvailable -Name "Terminal-Icons"

if (-not $installedModule) {
    Write-Host "Installing Terminal-Icons" 
    Install-Module -Name Terminal-Icons -Force
} else {
    $installedVersion = $installedModule.Version
    if ($installedVersion -lt $latestTerminalIconsVersion) {
        Write-Host "Updating Terminal-Icons from version $installedVersion to $latestTerminalIconsVersion"
        Update-Module -Name Terminal-Icons -Force
    } else {
        Write-Host "Terminal-Icons module is already up to date."
    }
}

Write-Host "Install Profile"
If (Test-Path -Path "$PROFILE") {
    $BackupFile = "$($PROFILE)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"
try {
    Move-Item $PROFILE $BackupFile -force -ErrorAction Stop
    Write-Host "Profile backed up to $BackupFile"
} catch {
    Write-Host "Failed to back up profile: $_"
} }


Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Aabayoumy/PS-Profile/refs/heads/main/profile.ps1" -OutFile $PROFILE
If (! (Test-Path -Path "~\.config\")) {mkdir ~\.config}
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Aabayoumy/PS-Profile/refs/heads/main/starship.toml" -OutFile "$env:USERPROFILE\.config\starship.toml"

# Add the following lines to get and display the version
$nerdfontsRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" -UseBasicParsing
$nerdfontsVersion = $nerdfontsRelease.tag_name
$nerdfontsReleaseDate = [datetime]::Parse($nerdfontsRelease.published_at).ToString("yyyy-MM-dd")
Write-Host "Nerd Fonts Version: $nerdfontsVersion"
Write-Host "Release Date: $nerdfontsReleaseDate"

# Define a path for the JSON file to save version and release date
$jsonPath = "C:\ProgramData\nerd_fonts.json"

# Create an object to hold version and release date
$currentReleaseInfo = @{
    Version = $nerdfontsVersion
    ReleaseDate = $nerdfontsReleaseDate
}

# Check if the JSON file exists
if (Test-Path $jsonPath) {
    # If it exists, read the JSON file
    $savedReleaseInfo = Get-Content $jsonPath | ConvertFrom-Json

    # Compare the current release info with the saved info
    if ($savedReleaseInfo.Version -eq $currentReleaseInfo.Version) {
        Write-Host "Nerd Fonts are already up to date."
        exit
    }
}

# If the JSON file does not exist or the version/release date has changed, update the JSON file
$currentReleaseInfo | ConvertTo-Json | Set-Content -Path $jsonPath
Install-NerdFonts -nerdfontsVersion $nerdfontsVersion -fonts $fonts

Write-Host "Profile has been installed. Please restart your shell to reflect changes!" -ForegroundColor Magenta