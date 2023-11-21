function fml {
    $milestones = gh api repos/:owner/:repo/milestones | ConvertFrom-Json | Select-Object -ExpandProperty title
    $milestone = $milestones | Out-String | fzf -d $(( 2 + ($milestones.Count) )) -m
    gh issue list -m "$milestone"
}
fml
