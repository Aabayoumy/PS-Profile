if ((winget list --id "Starship.Starship").count -lt 5) {     winget install starship --force }
If (Test-Path -Path "$env:TEMP\Fonts") { Remove-Item -Recurse -Force $env:TEMP\Fonts }

## Hack Fonts
#Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip  -OutFile "$env:TEMP\Hack.zip"
#Expand-Archive -LiteralPath "$env:TEMP\Hack.zip" -DestinationPath "$env:TEMP\Fonts\" -force

## JetBrainsMono Fonts
#Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip  -OutFile "$env:TEMP\JetBrainsMono.zip"
#Expand-Archive -LiteralPath "$env:TEMP\JetBrainsMono.zip" -DestinationPath "$env:TEMP\Fonts\" -force

Invoke-WebRequest https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip -OutFile "$env:TEMP\CascadiaCode.zip"
Expand-Archive -LiteralPath "$env:TEMP\CascadiaCode.zip" -DestinationPath "$env:TEMP\Fonts\" -force
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
Move-Item *.ttf c:\windows\fonts\
# Move-Item "$env:TEMP\Fonts\*.ttf" "C:\Windows\Fonts\" -force
if (-not (Get-Module -Name "Terminal-Icons")) {
    Write-Host "Installing Terminal-Icons" 
    Install-Module Terminal-Icons -force }
Move-Item $PROFILE "$($PROFILE)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"
Move-Item $PROFILE.AllUsersAllHosts "$($PROFILE.AllUsersAllHosts)-$((Get-Date).ToString('ddMMyyyy-HHmm')).bk"
Copy-Item profile.ps1 $PROFILE.AllUsersAllHosts
mkdir ~\.config\
Copy-Item starship.toml ~\.config\starship.toml