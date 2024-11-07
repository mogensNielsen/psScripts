# Fuzzy dbt
# Syntax: fdbt [command]
# Lists models under \models\ and pipes them to fzf so that the user can fuzzy search for a model
# Then performs the specified dbt command on the selected model(s)
# If no dbt command or model is selected (ctrl-c), it fails gracefully
function fdbt {
    param(
        [string]$command = $args[0]
    )

    $allowed_commands = @('list', 'compile', 'run', 'build', 'test', 'lint')

    # No command chosen, exit
    if(-not $command -or $command -notin $allowed_commands) {
        Write-Output 'Please specify a dbt command: list, compile, run, build, test, or lint'
        return
    }

    # Gets either the basenames or full paths, depending on the command
    if ($command -eq 'lint') {
        # Get full paths with forward slashes
        $models = (Get-ChildItem models\ -Recurse -Include *.sql | ForEach-Object { $_.FullName -replace '\\', '/' })
    } else {
        # Get basenames for other commands
        $models = (Get-ChildItem models\ -Recurse -Include *.sql).BaseName
    }

    # Pipes the list of models to fzf for fuzzy searching
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
            $compiled_sql = & dbt compile -s $models
            $compiled_sql_lines = $compiled_sql.Split("`n")
            $compiled_sql = $compiled_sql_lines[11..$compiled_sql_lines.Length] -join "`n"
            $compiled_sql = $compiled_sql -replace "^.*?Compiled node .* is:", "" -replace "Downloading artifacts", "" -replace "Invocation has finished", ""
            $compiled_sql | Set-Clipboard
        }
        elseif ($command -eq 'lint') {
            Write-Output "Performing dbt sqlfluff lint for $models"
            & dbt sqlfluff lint -s "$models"
        }
        else {
            $dbt_command = "dbt $command -s $models"
            Write-Output "Performing $dbt_command"
            [Microsoft.Powershell.PSConsoleReadLine]::AddToHistory($dbt_command)
            & dbt $command -s $models
        }
    }
}
fdbt
