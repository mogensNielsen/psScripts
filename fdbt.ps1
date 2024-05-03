# Fuzzy dbt run
# Lists models under \models\ and pipes them to fzf so that the user can fuzzy search for a model
# Then performs the specified dbt command on the selected model(s)
# If no dbt command or model is selected (ctrl-c), it fails gracefully
function fdbt {
    param(
        [ValidateSet('list', 'compile', 'run', 'build', 'test')]
        [string]$command = $args[0]
    )

    if(-not $command) {
        Write-Output "Please specify a dbt command: list, compile, run, build or test"
        return
    }

    $models = (Get-ChildItem models\ -Recurse -Include *.sql).BaseName
    $models = $models | Out-String | fzf -d $(( 2 + ($models.Count) )) -m

    if(-not $models) {
        Write-Output "No model selected"
        return
    }
    else {
        Write-Output "Doing dbt $command for $models"
        & dbt $command -s $models
    }
}
fdbt
