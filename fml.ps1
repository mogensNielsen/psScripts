# Fuzzy milestones
# Lists issues in a chosen milestone
# Fuzzy searches milestone in repo
function fml {
    # Get milestone, pipe to ConvertFrom-Json to PS object, pipe to Select-Object to select title,
    # expand title to get only the string value
    $milestones = gh api repos/:owner/:repo/milestones | ConvertFrom-Json | Select-Object -ExpandProperty title
    # Pipe milestones to fzf to enable fuzzy search
    $milestone = $milestones | Out-String | fzf -d $(( 2 + ($milestones.Count) )) -m
    # gh command to list issues in the milestone
    gh issue list -m "$milestone"
}
fml
