# Fuzzy dbt
# Syntax: fdbt [command]
# Lists models under \models\ and pipes them to fzf so that the user can fuzzy search for a model
# Then performs the specified dbt command on the selected model(s)
# If no dbt command or model is selected (ctrl-c), it fails gracefully
function fdbt {
    param(
        [ValidateSet('list', 'compile', 'run', 'build', 'test')]
        [string]$command = $args[0]
    )

    # No command chosen, exit
    if(-not $command) {
        Write-Output "Please specify a dbt command: list, compile, run, build or test"
        return
    }

    # Gets all filenames (without extension) under \models\
    $models = (Get-ChildItem models\ -Recurse -Include *.sql).BaseName
    # Pipes the list of models to fzf for fuzzy searching
    # The -m enables mulitple selections by tapping the tab key on the selected items
    $models = $models | Out-String | fzf -d $(( 2 + ($models.Count) )) -m

    # No model(s) chosen, exit
    if(-not $models) {
        Write-Output "No model selected"
        return
    }
    # Show what will be done and do it
    else {
        Write-Output "Doing dbt $command for $models"
        & dbt $command -s $models
    }
}
fdbt
