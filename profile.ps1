
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module -Name Terminal-Icons

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr

if ($host.Name -eq 'ConsoleHost')
{
  Import-Module PSReadLine
  # PSReadLine
  Set-PSReadLineOption -EditMode Emacs
  Set-PSReadLineOption -BellStyle None
  
  # Shows navigable menu of all options when hitting Tab
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

  # Autocompleteion for Arrow keys
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -PredictionSource History

}

Invoke-Expression (&starship init powershell)