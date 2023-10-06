# fbr - checkout git branch (including remote branches)
function fbr {
    $branches = git branch --all | Select-String -NotMatch HEAD
    $branch = $branches | Out-String | fzf -d $(( 2 + ($branches.Count) )) -m
    git switch ($branch -replace ".* " -replace "remotes/[^/]*/")
}
fbr
