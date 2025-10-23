### ðŸ“œ Scripting AvancÃ©

#### ðŸ”¹Gestion d'erreurs avancÃ©e

**Propagation d'erreurs avec `?` :**

```sh
# Fonction qui peut Ã©chouer
def safe_divide [a: int, b: int] {
    if $b == 0 {
        error make { msg: "Division par zÃ©ro" }
    } else {
        $a / $b
    }
}

# Propagation automatique des erreurs
def calculate_average [numbers: list<int>] {
    let sum = ($numbers | reduce -f 0 { |it, acc| $acc + $it })
    let count = ($numbers | length)
    safe_divide $sum $count  # L'erreur sera propagÃ©e automatiquement
}

# Test avec des donnÃ©es valides
calculate_average [10, 20, 30, 40]

# Test avec des donnÃ©es invalides (division par zÃ©ro)
try {
    calculate_average []
} catch { |err|
    print $"Erreur capturÃ©e: ($err)"
}
```

```sh
25
Erreur capturÃ©e: nu::shell::error
```

**Try-catch avancÃ© avec gestion de diffÃ©rents types d'erreurs :**

```sh
def process_file [file_path: string] {
    try {
        let content = (open $file_path)
        let lines = ($content | lines | length)
        print $"Fichier traitÃ©: ($lines) lignes"
        $content
    } catch { |err|
        match ($err | get msg) {
            "File not found" => {
                print "Le fichier n'existe pas"
                []
            }
            "Permission denied" => {
                print "AccÃ¨s refusÃ© au fichier"
                []
            }
            _ => {
                print $"Erreur inattendue: ($err)"
                []
            }
        }
    }
}

# Test avec diffÃ©rents scÃ©narios
process_file "fichier-inexistant.txt"
process_file "README.md"
```

#### ðŸ”¹Modules et organisation

**CrÃ©er un module simple :**

```sh
# scripts/utils.nu
export def --env cd-project [project_name: string] {
    let project_path = ($env.HOME | path join "projects" $project_name)
    if ($project_path | path exists) {
        cd $project_path
        print $"Projet '$project_name' chargÃ©"
    } else {
        print $"Le projet '$project_name' n'existe pas"
    }
}

export def format-date [date: datetime] {
    $date | format date "%Y-%m-%d %H:%M:%S"
}

export def get-file-size [file_path: string] {
    if ($file_path | path exists) {
        (ls $file_path | get size.0)
    } else {
        0
    }
}
```

**Utiliser le module :**

```sh
# Charger le module
use scripts/utils.nu *

# Utiliser les fonctions exportÃ©es
cd-project "mon-projet"
format-date (date now)
get-file-size "README.md"
```

**Module avec sous-modules :**

```sh
# scripts/database/mod.nu
export use sqlite.nu
export use postgres.nu
export use mysql.nu

# scripts/database/sqlite.nu
export def create-table [db_path: string, table_name: string, schema: record] {
    let create_sql = $"CREATE TABLE ($table_name) (($schema | transpose key value | each { |it| $"($it.key) ($it.value)" } | str join ", "))"
    print $"CrÃ©ation de la table: ($create_sql)"
    # Logique de crÃ©ation...
}

# scripts/database/postgres.nu
export def connect [host: string, port: int, database: string, user: string] {
    print $"Connexion Ã  PostgreSQL: ($host):($port)/($database) as ($user)"
    # Logique de connexion...
}
```

#### ðŸ”¹Completions personnalisÃ©es

**Completions pour les commandes personnalisÃ©es :**

```sh
# scripts/git-utils.nu
export def --env git-branch [
    action: string@"git-branch-actions"
] {
    match $action {
        "list" => { git branch }
        "create" => { git checkout -b $branch_name }
        "delete" => { git branch -d $branch_name }
        "switch" => { git checkout $branch_name }
        _ => { print "Action non reconnue" }
    }
}

# DÃ©finir les completions
def "git-branch-actions" [] {
    ["list", "create", "delete", "switch"]
}

# Completions pour les fichiers
export def edit-config [
    config_file: path@"config-files"
] {
    $env.EDITOR $config_file
}

def "config-files" [] {
    [
        "config.nu"
        "env.nu"
        "login.nu"
        "theme.nu"
    ]
}
```

#### ðŸ”¹Configuration avancÃ©e

**Configuration avec hooks :**

```sh
# config.nu
# Hook de changement de rÃ©pertoire
$env.config = ($env.config | upsert hooks {
    pre_prompt: [{
        # Mettre Ã  jour le prompt avec des infos Git
        let git_branch = (try { git branch --show-current } catch { "" })
        let git_status = (try { git status --porcelain | lines | length } catch { 0 })

        if ($git_branch | is-not-empty) {
            $env.PROMPT_COMMAND = $"($git_branch) ($git_status) > "
        }
    }]

    pre_execution: [{
        # Logger les commandes exÃ©cutÃ©es
        let cmd = $env.HISTORY_FILE
        if ($cmd | is-not-empty) {
            echo $"$(date now) | $cmd" | save --append ~/.nushell/history.log
        }
    }]
})

# Variables d'environnement conditionnelles
if $env.OS == "Windows_NT" {
    $env.EDITOR = "code"
    $env.PATH = ($env.PATH | split row ";" | append "C:\\tools" | str join ";")
} else {
    $env.EDITOR = "vim"
    $env.PATH = ($env.PATH | split row ":" | append "/usr/local/bin" | str join ":")
}

# Alias utiles
alias ll = ls -la
alias la = ls -a
alias grep = grep --color=auto
alias df = df -h
alias du = du -h
```

**Configuration par environnement :**

```sh
# env.nu
def load-env-config [env_name: string] {
    let config_file = $"~/.config/nushell/env/($env_name).nu"

    if ($config_file | path exists) {
        source $config_file
        print $"Configuration '$env_name' chargÃ©e"
    } else {
        print $"Configuration '$env_name' non trouvÃ©e"
    }
}

# Charger la configuration selon l'environnement
if ("NUSHELL_ENV" in $env) {
    load-env-config $env.NUSHELL_ENV
} else {
    load-env-config "default"
}
```

#### ðŸ”¹Performance et optimisation

**Traitement parallÃ¨le avec `par-each` :**

```sh
# Traitement sÃ©quentiel (lent)
def process-files-slow [files: list<string>] {
    $files | each { |file|
        let content = (open $file)
        let word_count = ($content | str words | length)
        {file: $file, words: $word_count}
    }
}

# Traitement parallÃ¨le (rapide)
def process-files-fast [files: list<string>] {
    $files | par-each { |file|
        let content = (open $file)
        let word_count = ($content | str words | length)
        {file: $file, words: $word_count}
    }
}

# Test avec plusieurs fichiers
let files = (ls *.md | get name)
process-files-fast $files
```

**Optimisation des gros datasets :**

```sh
# Traitement efficace de gros fichiers CSV
def analyze-large-csv [file_path: string] {
    open $file_path
    | skip 1  # Ignorer l'en-tÃªte
    | par-each { |row|
        # Traitement de chaque ligne
        let processed = ($row | str split "," | each { |it| $it | str trim })
        $processed
    }
    | group-by 0  # Grouper par premiÃ¨re colonne
    | each { |group|
        {
            category: $group.0,
            count: ($group.1 | length),
            avg_value: ($group.1 | get 1 | into float | math avg)
        }
    }
}

# Utilisation
analyze-large-csv "big-data.csv"
```

#### ðŸ”¹IntÃ©gration systÃ¨me

**Gestion des processus :**

```sh
# Surveiller les processus
def monitor-process [process_name: string] {
    while true {
        let processes = (ps | where name =~ $process_name)
        if ($processes | is-empty) {
            print $"Processus '$process_name' non trouvÃ©"
        } else {
            $processes | select name pid cpu mem
        }
        sleep 5sec
    }
}

# DÃ©marrer un processus en arriÃ¨re-plan
def start-background-process [command: string] {
    let pid = (run-external --redirect-stdout --redirect-stderr $command | get pid)
    print $"Processus dÃ©marrÃ© avec PID: ($pid)"
    $pid
}

# ArrÃªter un processus
def stop-process [pid: int] {
    try {
        kill $pid
        print $"Processus ($pid) arrÃªtÃ©"
    } catch {
        print $"Impossible d'arrÃªter le processus ($pid)"
    }
}
```

**Redirections et pipes :**

```sh
# Redirection de sortie
def save-command-output [command: string, output_file: string] {
    run-external $command --redirect-stdout $output_file
    print $"Sortie sauvegardÃ©e dans: ($output_file)"
}

# Pipe vers une commande externe
def filter-with-grep [input: string, pattern: string] {
    echo $input | run-external grep $pattern --redirect-stdout
}

# Combiner plusieurs commandes
def complex-pipeline [input_file: string] {
    open $input_file
    | lines
    | where { |it| $it | str contains "error" }
    | str join "\n"
    | run-external wc -l --redirect-stdout
}
```

#### ðŸ”¹Scripts autonomes

**Script avec shebang :**

```sh
#!/usr/bin/env nu

# Script autonome pour nettoyer les fichiers temporaires
def main [
    --dry-run(-d): bool  # Mode simulation
    --age: int = 7       # Ã‚ge en jours
] {
    let temp_dir = "/tmp"
    let cutoff_date = (date now) - ($age * 1day)

    let old_files = (ls $temp_dir
        | where type == "file"
        | where modified < $cutoff_date)

    if $dry_run {
        print "Mode simulation - fichiers qui seraient supprimÃ©s:"
        $old_files | select name modified
    } else {
        print "Suppression des fichiers anciens..."
        for $file in $old_files {
            try {
                rm $file.name
                print $"SupprimÃ©: ($file.name)"
            } catch {
                print $"Erreur lors de la suppression de: ($file.name)"
            }
        }
    }
}

# ExÃ©cution du script
main $args
```

**Script avec gestion d'arguments :**

```sh
#!/usr/bin/env nu

def main [
    input_file: string,
    --output(-o): string,
    --format: string@"formats" = "json",
    --verbose(-v): bool
] {
    if $verbose {
        print $"Traitement du fichier: ($input_file)"
        print $"Format de sortie: ($format)"
    }

    let output_file = if $output != null {
        $output
    } else {
        ($input_file | path parse | get stem) + $".($format)"
    }

    let data = (open $input_file)

    match $format {
        "json" => { $data | to json | save $output_file }
        "csv" => { $data | to csv | save $output_file }
        "yaml" => { $data | to yaml | save $output_file }
        _ => { error make { msg: "Format non supportÃ©" } }
    }

    print $"Fichier sauvegardÃ©: ($output_file)"
}

def "formats" [] {
    ["json", "csv", "yaml", "toml"]
}

main $args
```

#### ðŸ”¹Tests et validation de scripts

**Tests unitaires simples :**

```sh
# scripts/tests.nu
def test-math-functions [] {
    print "Test des fonctions mathÃ©matiques..."

    # Test de la fonction add
    let result1 = (add 2 3)
    assert equal $result1 5 "Addition de 2 + 3"

    # Test de la fonction multiply
    let result2 = (multiply 4 5)
    assert equal $result2 20 "Multiplication de 4 * 5"

    print "Tous les tests mathÃ©matiques ont rÃ©ussi!"
}

def test-file-operations [] {
    print "Test des opÃ©rations de fichiers..."

    # CrÃ©er un fichier de test
    echo "test content" | save test-file.txt

    # Tester la lecture
    let content = (open test-file.txt)
    assert equal $content "test content" "Lecture du fichier"

    # Nettoyer
    rm test-file.txt

    print "Tous les tests de fichiers ont rÃ©ussi!"
}

# Fonction d'assertion simple
def assert equal [actual: any, expected: any, message: string] {
    if $actual != $expected {
        error make {
            msg: $"Test Ã©chouÃ©: ($message). Attendu: ($expected), Obtenu: ($actual)"
        }
    }
}

# ExÃ©cuter tous les tests
def run-all-tests [] {
    test-math-functions
    test-file-operations
    print "Tous les tests ont rÃ©ussi! âœ…"
}
```

**Validation de scripts :**

```sh
# scripts/validator.nu
def validate-script [script_path: string] {
    print $"Validation du script: ($script_path)"

    # VÃ©rifier la syntaxe
    try {
        source $script_path
        print "âœ… Syntaxe correcte"
    } catch { |err|
        print $"âŒ Erreur de syntaxe: ($err)"
        return false
    }

    # VÃ©rifier les fonctions exportÃ©es
    let exported_functions = (scope commands | where is_exported == true)
    if ($exported_functions | is-empty) {
        print "âš ï¸  Aucune fonction exportÃ©e trouvÃ©e"
    } else {
        print $"âœ… ($exported_functions | length) fonction(s) exportÃ©e(s)"
    }

    # VÃ©rifier la documentation
    let script_content = (open $script_path)
    if ($script_content | str contains "--help") {
        print "âœ… Documentation d'aide prÃ©sente"
    } else {
        print "âš ï¸  Documentation d'aide manquante"
    }

    print "Validation terminÃ©e"
    true
}

# Utilisation
validate-script "scripts/my-script.nu"
```
