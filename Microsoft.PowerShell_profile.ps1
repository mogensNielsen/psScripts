oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\mogens.omp.json" | Invoke-Expression

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Add functions for aliases
# Creates a function that can be called in Set-Alias
function git-switch-main { git switch main }

# Add aliases
Set-Alias -Name main -Value git-switch-main

# Change this path to where Powershell scripts are stored
$env:path += ";H:\My Documents\work\powershell"
