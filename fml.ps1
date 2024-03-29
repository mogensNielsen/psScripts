# Fuzzy milestones
# Lists issues in a chosen milestone
# Fuzzy searches milestone in repo
function fml {
    # Get milestone, pipe to ConvertFrom-Json to PS object, pipe to Select-Object to select title,
    # expand title to get only the string value
    $milestones = gh api repos/:owner/:repo/milestones | ConvertFrom-Json | Select-Object -ExpandProperty title
    # Pipe milestones to fzf to enable fuzzy search
    $milestone = $milestones | Out-String | fzf -d $(( 2 + ($milestones.Count) ))

    # Checks if user has exited without choosing a milestone
    # Without this, the script outputs all issues if no milestone is chosen
    if($null -eq $milestone) {
        return
    }
    else {
        gh issue list -m "$milestone"
    }
}
fml
