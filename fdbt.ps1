# Fuzzy dbt
# Syntax: fdbt [command]
# Lists models under \models\ and pipes them to fzf so that the user can fuzzy search for a model
# Then performs the specified dbt command on the selected model(s)
# If no dbt command or model is selected (ctrl-c), it fails gracefully
function fdbt {
    param(
        [ValidateSet('list', 'compile', 'run', 'build', 'test', 'lint', 'fix', 'format')]
        [string]$command = $args[0]
    )

    # No command chosen, exit
    if(-not $command) {
        Write-Output "Please specify a dbt command: list, compile, run, build or test"
        return
    }

    # Gets all filenames (without extension) under \models\
    $models = (Get-ChildItem models\ -Recurse -Include *.sql)
    # Pipes the list of models to fzf for fuzzy searching
    # The -m enables mulitple selections by tapping the tab key on the selected items
    $models = $models | Out-String | fzf -d $(( 2 + ($models.Count) )) -m

    Write-Output $models
    foreach ($model in $models) {
        $baseName = $model.BaseName
        $fullName = $model.FullName

        Write-Output "$model : BaseName: $baseName and FullName: $fullName"
    }
    break

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
            & dbt compile -s $models | Set-Clipboard
        }
        elseif($command -in @('lint', 'fix', 'format')) {
            $sqlfluff_command = "dbt sqlfluff $command $models"
            Write-Output "Performing $sqlfluff_command"
            # Adds the command to the history for easy retrieval
            [Microsoft.Powershell.PSConsoleReadLine]::AddToHistory($dbt_command)
            #& dbt sqlfluff $command $models
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
