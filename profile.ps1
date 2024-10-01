
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module -Name Terminal-Icons
Import-Module z
Import-Module PSReadLine

# Alias
Set-Alias g git
Set-Alias grep findstr
Set-Alias l ls
Set-Alias cat Get-Content
Set-Alias rm Remove-Item

function gcp {
    param (
        [string]$commitMessage
    )

    git add .
    git commit -m $commitMessage
    git push
}


# Enhanced Listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

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
      Command = 'Yellow'
      Parameter = 'Green'
      String = 'DarkCyan'
    }
  }
  Set-PSReadLineOption @PSReadLineOptions
  # Shows navigable menu of all options when hitting Tab
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

  # Autocompleteion for Arrow keys
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
  Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord

  Set-PSReadLineKeyHandler -Key Ctrl+z -Function Undo
if ($host.Name -eq 'ConsoleHost')
{
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}

Invoke-Expression (&starship init powershell)
