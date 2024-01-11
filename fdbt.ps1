# Fuzzy dbt run
# Lists models under \models\ and pipes them to fzf
# so that the user can fuzzy search for a model
# Then runs that model with `dbt run -s [model name]`
# If no model is selected (ctrl-c), it fails gracefully
function fdbt {
    $models = (Get-ChildItem models\ -Recurse -Include *.sql).BaseName
    $models = $models | Out-String | fzf -d $(( 2 + ($models.Count) )) -m

    if($null -eq $models) {
        return
    }
    else {
        dbt run -s $models
    }
}
fdbt
