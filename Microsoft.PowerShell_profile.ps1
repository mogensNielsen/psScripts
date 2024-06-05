oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\mogens.omp.json" | Invoke-Expression

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Make PSReadLine show a list of suggestions instead of just one suggestions
Set-PSReadLineOption -PredictionViewStyle ListView

# Add functions for aliases
## Creates a function that can be called in Set-Alias
## Function to switch to main branch
function git-switch-main { git switch main }

## Function to do `git fetch && git status`
function git-fetch-status { git fetch && git status }

# Add aliases
Set-Alias -Name main -Value git-switch-main
Set-Alias -Name gfs -Value git-fetch-status

# Change this path to where Powershell scripts are stored
$env:path += ";[path to where you have stored your scripts]"
