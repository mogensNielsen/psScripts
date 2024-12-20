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
        Write-Output 'Please specify a dbt command: list, compile, run, build or test'
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
        if($command -eq 'compile') {
            Write-Output "Doing dbt compile for $models. Sends output to the clipboard."
            # Pipes the output to the clipboard
            $compiled_sql = & dbt compile -s $models

            # Splits the output into an array of lines (splits on newline)
            $compiled_sql_lines = $compiled_sql.Split("`n")
            # Removes the first 11 lines (they are just dbt logs) and then joins the rest into a single string
            # Joins with newline
            $compiled_sql = $compiled_sql_lines[11..$compiled_sql_lines.Length] -join "`n"

            $compiled_sql = $compiled_sql -replace "^.*?Compiled node .* is:", "" -replace "Downloading artifacts", "" -replace "Invocation has finished", ""
            $compiled_sql | Set-Clipboard
        }
        else {
            $dbt_command = "dbt $command -s $models"
            Write-Output "Performing $dbt_command"
            # Adds the command to the history for easy retrieval
            [Microsoft.Powershell.PSConsoleReadLine]::AddToHistory($dbt_command)
            & dbt $command -s $models
        }
    }
}
fdbt
