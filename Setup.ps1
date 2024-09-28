# By :    ABayoumy@outlook.com
# GitHub: https://github.com/Aabayoumy/PS-Profile

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
        [datetime]$nerdfontsReleaseDate,
        [hashtable]$fonts
    )
    $FontDownloaded = $false
    foreach ($font in $fonts.GetEnumerator()) {
        $fontName = $font.Key
        $zipFileName = $fontName
            Write-Host "Downloading and installing $fontName font"
            Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/$($nerdfontsVersion)/$zipFileName.zip" -OutFile "$env:TEMP\$zipFileName.zip"
            Expand-Archive -LiteralPath "$env:TEMP\$zipFileName.zip" -DestinationPath "$env:TEMP\Fonts\" -force
            $FontDownloaded = $true
    }
    return $FontDownloaded
}


Write-Host "Install Terminal-Icons if not installed"
if (-not (Get-Module -Name "Terminal-Icons")) {
    Write-Host "Installing Terminal-Icons" 
    Install-Module Terminal-Icons -force }

Write-Host "Install Profile"
If (Test-Path -Path "$PROFILE") { Move-Item $PROFILE "$($PROFILE)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"}
# If (Test-Path -Path "$PROFILE.AllUsersAllHosts") { Move-Item $PROFILE.AllUsersAllHosts "$($PROFILE.AllUsersAllHosts)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"}
Copy-Item profile.ps1 $PROFILE -force
If (! (Test-Path -Path "~\.config\")) {mkdir ~\.config}
Copy-Item starship.toml ~\.config\starship.toml

# Add the following lines to get and display the version
$nerdfontsRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" -UseBasicParsing
$nerdfontsVersion = $nerdfontsRelease.tag_name
$nerdfontsReleaseDate = [datetime]::Parse($nerdfontsRelease.published_at).ToString("yyyy-MM-dd")
Write-Host "Nerd Fonts Version: $nerdfontsVersion"
Write-Host "Release Date: $nerdfontsReleaseDate"

# Define a path for the JSON file to save version and release date
$jsonPath = "C:\ProgramData\nerd_fonts_ver_rel_date.json"

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
    if ($savedReleaseInfo.Version -eq $currentReleaseInfo.Version -and $savedReleaseInfo.ReleaseDate -eq $currentReleaseInfo.ReleaseDate) {
        Write-Host "Nerd Fonts are already up to date."
        return
    }
}

# If the JSON file does not exist or the version/release date has changed, update the JSON file
$currentReleaseInfo | ConvertTo-Json | Set-Content -Path $jsonPath

# Define font paths in a hashtable
$fonts = @{
    "FiraCode" = "FiraCode"
    "Hack" = "Hack Nerd"
    "JetBrainsMono" = "Jet Brains"
    "SourceCodePro" = "Source Code"
}

$FontDownloaded = Install-NerdFonts -nerdfontsVersion $nerdfontsVersion -nerdfontsReleaseDate $nerdfontsReleaseDate -fonts $fonts

if ($FontDownloaded) {
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
