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

function Install-NerdFonts {
    param (
        [string]$nerdfontsVersion,
        [datetime]$nerdfontsReleaseDate,
        [hashtable]$fonts
    )
    $FontDownloaded = $false
    foreach ($font in $fonts.GetEnumerator()) {
        $fontName = $font.Key
        $fontFamily = $font.Value
        $zipFileName = $fontName
        if ((New-Object System.Drawing.Text.InstalledFontCollection).Families.Name.Contains($fontFamily)) {
            Write-Host "Downloading and installing $fontName font"
            Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/$($nerdfontsVersion)/$zipFileName.zip" -OutFile "$env:TEMP\$zipFileName.zip"
            Expand-Archive -LiteralPath "$env:TEMP\$zipFileName.zip" -DestinationPath "$env:TEMP\Fonts\" -force
            $FontDownloaded = $true
        } else {
            write-Host "Font $fontFamily is already installed"
        }
    }
    return $FontDownloaded
}




# Add the following lines to get and display the version
$nerdfontsRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" -UseBasicParsing
$nerdfontsVersion = $nerdfontsRelease.tag_name
$nerdfontsReleaseDate = [datetime]::Parse($nerdfontsRelease.published_at).ToString("yyyy-MM-dd")
Write-Host "Nerd Fonts Version: $nerdfontsVersion"
Write-Host "Release Date: $nerdfontsReleaseDate"

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
