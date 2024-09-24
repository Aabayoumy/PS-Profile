# By :    ABayoumy@outlook.com
# GitHub: https://github.com/Aabayoumy/PS-Profile

Write-Host "Install starship https://starship.rs/ if not installed"
if ((winget list --id "Starship.Starship").count -lt 5) { winget install starship --force }
If (Test-Path -Path "$env:TEMP\Fonts") { Remove-Item -Recurse -Force $env:TEMP\Fonts }

Write-Host "Download Fonts"
## Hack Fonts
#Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip  -OutFile "$env:TEMP\Hack.zip"
#Expand-Archive -LiteralPath "$env:TEMP\Hack.zip" -DestinationPath "$env:TEMP\Fonts\" -force

## JetBrainsMono Fonts
if (-not(Test-Path -Path "C:\Windows\Fonts\JetBrainsMono*.ttf" )) {
# Assuming that $fileName contains the name of the font file you are checking for
Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip  -OutFile "$env:TEMP\JetBrainsMono.zip"
Expand-Archive -LiteralPath "$env:TEMP\JetBrainsMono.zip" -DestinationPath "$env:TEMP\Fonts\" -force
}

## CascadiaCode Fonts
# Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip -OutFile "$env:TEMP\CascadiaCode.zip"
# Expand-Archive -LiteralPath "$env:TEMP\CascadiaCode.zip" -DestinationPath "$env:TEMP\Fonts\" -force
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
