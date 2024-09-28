
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module -Name Terminal-Icons
Import-Module z
Import-Module PSReadLine

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
Set-Alias -Name ls -Value 'Get-ChildItem'
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr


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

  Set-PSReadLineKeyHandler -Key Ctrl+z -Function Undo
if ($host.Name -eq 'ConsoleHost')
{
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}

Invoke-Expression (&starship init powershell)
