# psScripts
My Powershell Scripts

Just a place where I store my Powershell scripts.

Might convert to a private repository at a later time.

## Installing PSFzf

### Install fzf

`winget install junegunn.fzf`

### Install PSReadLine

**Note**: This might already be installed in your Powershell, check with `Get-Module` if PSReadline is listed there. 

`Install-Module -Name PSReadLine -AllowClobber -Force -Scope CurrentUser`

### Install PSFzf

`Install-Module -Name PSFzf -AllowClobber -Force -Scope CurrentUser`

## Scripts

### Fuzzy milestones (fml.ps1)
Outputs all milestones in the current GitHub repository and lists them in the terminal. User can choose a milestone, with fuzzy search or using arrow keys, and press enter. The script then lists all issues in that milestone.

### Fuzzy branches (fbr.ps1)
Outputs all branches (local and remote) in the current GitHub repository and lists them in the terminal. User can choose a branch, with fuzzy search or using arrow keys, and press enter. The script then performs a `git switch` to the chosen branch.

### Fuzzy dbt run
Outputs all .sql files in the `models` folder and lists them in the terminal. User can choose a model, with fuzzy search or using arrow keys, and press enter. The scripts then performs a `dbt -s run [model name]` with the chosen model.
