
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module -Name Terminal-Icons
Import-Module z


# Alias
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
Set-Alias ll ls
Set-Alias -Name la -Value 'Get-ChildItem -Force' -Option AllScope
Set-Alias g git
Set-Alias grep findstr
function ix ($file) {
  curl.exe -F "f:1=@$file" ix.io
}

if ($host.Name -eq 'ConsoleHost')
{
  Import-Module PSReadLine
  # PSReadLine

  $PSReadLineOptions = @{
    EditMode = "Emacs"
    HistoryNoDuplicates = $true
    BellStyle = "None"
    ShowToolTips = $true
    PredictionSource = "History"
    PredictionViewStyle = "ListView"
    # PredictionViewStyle = "InlineView"
    MaximumHistoryCount = 4096
    HistorySavePath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        "Command" = "#8181f7"
    }
  }
  Set-PSReadLineOption @PSReadLineOptions
  # Shows navigable menu of all options when hitting Tab
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

  # Autocompleteion for Arrow keys
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

function cd {
    param (
        [string]$dir
    )
    Set-Location -Path $dir
    Get-ChildItem | Format-Table -AutoSize
}

Invoke-Expression (&starship init powershell)
