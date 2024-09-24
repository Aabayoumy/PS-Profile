# By :    ABayoumy@outlook.com
# GitHub: https://github.com/Aabayoumy/PS-Profile

Write-Host "Install starship https://starship.rs/ if not installed"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not installed or not in your PATH. you have to install it manually"
        Start-Process "https://starship.rs/" 
    else {
        if ((winget list --id "Starship.Starship").count -lt 5) { winget install starship --force }
    }
}


If (Test-Path -Path "$env:TEMP\Fonts") { Remove-Item -Recurse -Force $env:TEMP\Fonts }

Write-Host "Download Fonts"


$downloadAndInstallFont = {
    param (
        $fontName,
        $fontPath,
        $zipFileName
    )
    Write-Host "Downloading and installing $fontName font"
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/$($nerdfontsVersion)/$zipFileName.zip" -OutFile "$env:TEMP\$zipFileName.zip"
    Expand-Archive -LiteralPath "$env:TEMP\$zipFileName.zip" -DestinationPath "$env:TEMP\Fonts\" -force
    $FontDownloaded = $true
}


# Add the following lines to get and display the version
$nerdfontsRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" -UseBasicParsing
$nerdfontsVersion = $nerdfontsRelease.tag_name
$nerdfontsReleaseDate = [datetime]::Parse($nerdfontsRelease.published_at).ToString("yyyy-MM-dd")
Write-Host "Nerd Fonts Version: $nerdfontsVersion"
Write-Host "Release Date: $nerdfontsReleaseDate"

$FontDownloaded = $false
## Hack Fonts
$hackFontPath = "C:\Windows\Fonts\HackNerdFontPropo-Regular.ttf"

if (-not (Test-Path -Path $hackFontPath)) {
    Write-Host "Downloading and installing Hack font"
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/$($nerdfontsVersion)/Hack.zip" -OutFile "$env:TEMP\Hack.zip"
    Expand-Archive -LiteralPath "$env:TEMP\Hack.zip" -DestinationPath "$env:TEMP\Fonts\" -force
    $FontDownloaded = $true
} 
else {
    Write-Host "Hack font already exists"
}

## JetBrainsMono Fonts

# Check if JetBrainsMono font needs to be downloaded
$jetBrainsMonoFontPath = "C:\Windows\Fonts\JetBrainsMonoNerdFont-Regular.ttf"

if (-not (Test-Path -Path $jetBrainsMonoFontPath)) {
    &$downloadAndInstallFont "JetBrainsMono" $jetBrainsMonoFontPath "JetBrainsMono"
} else {
    $fontCreatedDate = (Get-Item -Path $jetBrainsMonoFontPath).LastWriteTime.ToString("yyyy-MM-dd")
    if ([datetime]::Parse($fontCreatedDate) -lt [datetime]::Parse($nerdfontsReleaseDate)) {
        Write-Host "Existing JetBrainsMono font is older than the latest release date"
        &$downloadAndInstallFont "JetBrainsMono" $jetBrainsMonoFontPath "JetBrainsMono"
    } else {
        Write-Host "JetBrainsMono font is up to date"
    }
}

## CascadiaCode Fonts

# Check if CascadiaCode font needs to be downloaded
$cascadiaCodeFontPath = "C:\Windows\Fonts\CaskaydiaCoveNerdFont-Regular.ttf"

if (-not (Test-Path -Path $cascadiaCodeFontPath)) {
    &$downloadAndInstallFont "CascadiaCode" $cascadiaCodeFontPath "CascadiaCode"
} else {
    $fontCreatedDate = (Get-Item -Path $cascadiaCodeFontPath).LastWriteTime.ToString("yyyy-MM-dd")
    if ([datetime]::Parse($fontCreatedDate) -lt [datetime]::Parse($nerdfontsReleaseDate)) {
        Write-Host "Existing CascadiaCode font is older than the latest release date"
        &$downloadAndInstallFont "CascadiaCode" $cascadiaCodeFontPath "CascadiaCode"
    } else {
        Write-Host "CascadiaCode font is up to date"
    }
}

## FiraCode Fonts
# Check if FiraCode font needs to be downloaded
$firaCodeFontPath = "C:\Windows\Fonts\FiraCodeNerdFont-Regular.ttf"
if (-not (Test-Path -Path $firaCodeFontPath)) {
    &$downloadAndInstallFont "FiraCode" $firaCodeFontPath "FiraCode"
} else {
    $fontCreatedDate = (Get-Item -Path $firaCodeFontPath).LastWriteTime.ToString("yyyy-MM-dd")
    if ([datetime]::Parse($fontCreatedDate) -lt [datetime]::Parse($nerdfontsReleaseDate)) {
        Write-Host "Existing FiraCode font is older than the latest release date"
        &$downloadAndInstallFont "FiraCode" $firaCodeFontPath "FiraCode"
    } else {
        Write-Host "FiraCode font is up to date"
    }
}

## SourceCodePro Fonts
# Check if SourceCodePro font needs to be downloaded
$sourceCodeProFontPath = "C:\Windows\Fonts\SauseCodeProNerdFont-Regular.ttf"

if (-not (Test-Path -Path $sourceCodeProFontPath)) {
    &$downloadAndInstallFont "SourceCodePro" $sourceCodeProFontPath "SourceCodePro"
} else {
    $fontCreatedDate = (Get-Item -Path $sourceCodeProFontPath).LastWriteTime.ToString("yyyy-MM-dd")
    if ([datetime]::Parse($fontCreatedDate) -lt [datetime]::Parse($nerdfontsReleaseDate)) {
        Write-Host "Existing SourceCodePro font is older than the latest release date"
        &$downloadAndInstallFont "SourceCodePro" $sourceCodeProFontPath "SourceCodePro"
    } else {
        Write-Host "SourceCodePro font is up to date"
    }
}


if ($FontDownloaded) {
    Write-Host "Install fonts"
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in Get-ChildItem "$env:TEMP\Fonts\*windows*.ttf")
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            Write-Output $fileName
            Get-ChildItem $file | ForEach-Object{ $fonts.CopyHere($_.fullname,16) }
        }
    }
    Move-Item "$env:TEMP\Fonts\*.ttf" "C:\Windows\Fonts\" -force
}
Write-Host "Install Terminal-Icons if not installed"
if (-not (Get-Module -Name "Terminal-Icons")) {
    Write-Host "Installing Terminal-Icons" 
    Install-Module Terminal-Icons -force }

Write-Host "Install Profile"
If (Test-Path -Path "$PROFILE") { Move-Item $PROFILE "$($PROFILE)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"}
If (Test-Path -Path "$PROFILE.AllUsersAllHosts") { Move-Item $PROFILE.AllUsersAllHosts "$($PROFILE.AllUsersAllHosts)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"}
Copy-Item profile.ps1 $PROFILE.AllUsersAllHosts -force
If (! (Test-Path -Path "~\.config\")) {mkdir ~\.config}
Copy-Item starship.toml ~\.config\starship.toml
