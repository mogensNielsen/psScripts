# Fetch latest remote branches
git fetch --prune

# Get list of local branches
$localBranches = git branch --format="%(refname:short)" | Where-Object { $_ -ne 'main' -and $_ -ne 'master' }

# Get list of remote branches
$remoteBranches = git branch -r --format="%(refname:short)" | ForEach-Object { $_ -replace '^origin/', '' }

# Compare and find local branches that are not on the remote
$obsoleteBranches = $localBranches | Where-Object { $_ -notin $remoteBranches }

if ($obsoleteBranches.Count -eq 0) {
    Write-Host "No obsolete branches found."
} else {
    Write-Host "The following branches are no longer on the remote:"
    $obsoleteBranches | ForEach-Object { Write-Host "- $_" }

    # Ask for confirmation to delete
    $obsoleteBranches | ForEach-Object {
        $confirm = Read-Host "Delete branch '$_'? (Y/n)"
        if ($confirm -eq 'y' -or $confirm -eq '') {
            git branch -D $_
        }
    }
}
