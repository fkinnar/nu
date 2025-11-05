### 🎨 Alias et Configuration Personnalisée

#### 🔧 Créer des alias utiles

**Alias de base :**

```sh
# Alias pour les commandes fréquentes
alias ll = ls -la
alias la = ls -a
alias lt = ls --long --du --size
alias lh = ls -la | where type == "file" | sort-by size -r | first 10

# Alias pour la navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ~ = cd ~
alias / = cd /

# Alias pour Git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline
alias gd = git diff
alias gb = git branch
alias gco = git checkout

# Alias pour la gestion des processus
alias ps = ps | sort-by cpu -r
alias top = ps | where cpu > 0 | sort-by cpu -r | first 10
alias killall = ps | where name =~ $in | get pid | each { |pid| kill $pid }
```

**Alias avec paramètres :**

```sh
# Alias pour la recherche
alias find = ls **/* | where name =~ $in
alias grep = grep --color=auto
alias rg = rg --color=auto

# Alias pour les archives
alias untar = tar -xzf
alias targz = tar -czf
alias unzip = unzip -q

# Alias pour la gestion des fichiers
alias cp = cp -r
alias mv = mv -i
alias rm = rm -i
alias mkdir = mkdir -p
```

**Alias complexes :**

```sh
# Alias pour le monitoring système
alias meminfo = ps | where name != "ps" | reduce -f 0 { |it, acc| $acc + $it.mem } | into filesize
alias diskusage = du | where physical > 1gb | sort-by physical -r | first 10
alias netstat = netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}"

# Alias pour le développement
alias serve = python -m http.server 8000
alias jupyter = jupyter notebook --no-browser --port=8888
alias docker-clean = docker system prune -f
alias k8s-pods = kubectl get pods -o wide
```

#### 🔧 Configuration personnalisée (config.nu)

**Configuration de base :**

```sh
# config.nu
# Charger les modules
source ~/.config/nushell/aliases.nu
source ~/.config/nushell/functions.nu

# Configuration de l'éditeur
$env.EDITOR = "code"
$env.VISUAL = "code"

# Configuration Git
$env.GIT_AUTHOR_NAME = "Votre Nom"
$env.GIT_AUTHOR_EMAIL = "votre.email@example.com"

# Configuration des couleurs
$env.config = ($env.config | upsert color_config {
    separator: "blue"
    leading_trailing_space_bg: { attr: "n" }
    header: "green_bold"
    empty: "white"
    bool: "white"
    int: "white"
    filesize: "white"
    duration: "white"
    date: "white"
    range: "white"
    float: "white"
    string: "white"
    nothing: "white"
    binary: "white"
    cellpath: "white"
    row_index: "green_bold"
    record: "white"
    list: "white"
    block: "white"
    hints: "dark_gray"
    search_result: { bg: "red" fg: "white" }
    shape_flag: "blue_bold"
    shape_float: "cyan_bold"
    shape_int: "green_bold"
    shape_bool: "light_cyan"
    shape_internalcall: "cyan_bold"
    shape_external: "cyan"
    shape_externalarg: "green_bold"
    shape_literal: "blue"
    shape_operator: "yellow"
    shape_signature: "green_bold"
    shape_string: "green"
    shape_string_interpolation: "cyan_bold"
    shape_datetime: "blue_bold"
    shape_list: "cyan_bold"
    shape_table: "blue_bold"
    shape_record: "cyan_bold"
    shape_block: "blue_bold"
    shape_filepath: "cyan"
    shape_globpattern: "cyan_bold"
    shape_variable: "blue"
    shape_custom: "green"
    shape_nothing: "light_cyan"
})
```

**Configuration du prompt :**

```sh
# Prompt personnalisé
def create_left_prompt [] {
    let path_segment = if ($env.PWD | str length) > 20 {
        ($env.PWD | str substring 0 20) + "..."
    } else {
        $env.PWD
    }

    let git_branch = (try {
        git branch --show-current
    } catch {
        ""
    })

    let git_status = (try {
        git status --porcelain | lines | length
    } catch {
        0
    })

    let git_info = if ($git_branch | is-not-empty) {
        if $git_status > 0 {
            $"($git_branch) *"
        } else {
            $"($git_branch) ✓"
        }
    } else {
        ""
    }

    let user = $env.USER
    let host = (hostname)

    $"($user)@($host) ($path_segment) ($git_info) > "
}

# Appliquer le prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { "" }
```

**Configuration des hooks :**

```sh
# Hooks de changement de répertoire
$env.config = ($env.config | upsert hooks {
    pre_prompt: [{
        # Mettre à  jour les informations Git
        let git_branch = (try { git branch --show-current } catch { "" })
        $env.GIT_BRANCH = $git_branch
    }]

    pre_execution: [{
        # Logger les commandes
        let cmd = $env.HISTORY_FILE
        if ($cmd | is-not-empty) {
            echo $"$(date now) | $cmd" | save --append ~/.nushell/command_history.log
        }
    }]

    env_change: {
        PWD: [{
            # Mettre à  jour le titre de la fenêtre
            if ($env.TERM_PROGRAM == "vscode") {
                print $"\e]0;NuShell - ($env.PWD)\a"
            }
        }]
    }
})
```

#### 🔧 Thèmes et personnalisation de l'interface

**Thème sombre personnalisé :**

```sh
# themes/dark.nu
$env.config = ($env.config | upsert color_config {
    separator: "light_blue"
    leading_trailing_space_bg: { attr: "n" }
    header: "green_bold"
    empty: "dark_gray"
    bool: "light_cyan"
    int: "light_blue"
    filesize: "light_blue"
    duration: "light_blue"
    date: "light_blue"
    range: "light_blue"
    float: "light_blue"
    string: "light_green"
    nothing: "dark_gray"
    binary: "light_blue"
    cellpath: "light_blue"
    row_index: "green_bold"
    record: "white"
    list: "white"
    block: "white"
    hints: "dark_gray"
    search_result: { bg: "red" fg: "white" }
    shape_flag: "light_blue_bold"
    shape_float: "light_blue_bold"
    shape_int: "light_blue_bold"
    shape_bool: "light_cyan"
    shape_internalcall: "light_blue_bold"
    shape_external: "light_blue"
    shape_externalarg: "light_green_bold"
    shape_literal: "light_blue"
    shape_operator: "yellow"
    shape_signature: "light_green_bold"
    shape_string: "light_green"
    shape_string_interpolation: "light_blue_bold"
    shape_datetime: "light_blue_bold"
    shape_list: "light_blue_bold"
    shape_table: "light_blue_bold"
    shape_record: "light_blue_bold"
    shape_block: "light_blue_bold"
    shape_filepath: "light_blue"
    shape_globpattern: "light_blue_bold"
    shape_variable: "light_blue"
    shape_custom: "light_green"
    shape_nothing: "dark_gray"
})
```

**Thème clair personnalisé :**

```sh
# themes/light.nu
$env.config = ($env.config | upsert color_config {
    separator: "dark_blue"
    leading_trailing_space_bg: { attr: "n" }
    header: "dark_green"
    empty: "dark_gray"
    bool: "dark_cyan"
    int: "dark_blue"
    filesize: "dark_blue"
    duration: "dark_blue"
    date: "dark_blue"
    range: "dark_blue"
    float: "dark_blue"
    string: "dark_green"
    nothing: "dark_gray"
    binary: "dark_blue"
    cellpath: "dark_blue"
    row_index: "dark_green"
    record: "black"
    list: "black"
    block: "black"
    hints: "dark_gray"
    search_result: { bg: "yellow" fg: "black" }
    shape_flag: "dark_blue"
    shape_float: "dark_blue"
    shape_int: "dark_blue"
    shape_bool: "dark_cyan"
    shape_internalcall: "dark_blue"
    shape_external: "dark_blue"
    shape_externalarg: "dark_green"
    shape_literal: "dark_blue"
    shape_operator: "dark_yellow"
    shape_signature: "dark_green"
    shape_string: "dark_green"
    shape_string_interpolation: "dark_blue"
    shape_datetime: "dark_blue"
    shape_list: "dark_blue"
    shape_table: "dark_blue"
    shape_record: "dark_blue"
    shape_block: "dark_blue"
    shape_filepath: "dark_blue"
    shape_globpattern: "dark_blue"
    shape_variable: "dark_blue"
    shape_custom: "dark_green"
    shape_nothing: "dark_gray"
})
```

**Changer de thème dynamiquement :**

```sh
# functions/theme.nu
export def switch-theme [theme_name: string] {
    match $theme_name {
        "dark" => { source ~/.config/nushell/themes/dark.nu }
        "light" => { source ~/.config/nushell/themes/light.nu }
        "default" => { source ~/.config/nushell/themes/default.nu }
        _ => { print "Thème non trouvé. Thèmes disponibles: dark, light, default" }
    }

    print $"Thème changé vers: ($theme_name)"
}

# Alias pour changer de thème
alias theme = switch-theme
alias dark = switch-theme dark
alias light = switch-theme light
```

#### 🔧 Intégration avec Git

**Commandes Git natives :**

```sh
# functions/git.nu
export def git-status [] {
    git status --porcelain | lines | each { |line|
        let parts = ($line | split row " " | where $it != "")
        let status = $parts.0
        let file = $parts.1

        {
            status: $status,
            file: $file,
            type: (match $status {
                "M" => "Modified"
                "A" => "Added"
                "D" => "Deleted"
                "R" => "Renamed"
                "C" => "Copied"
                "U" => "Unmerged"
                "?" => "Untracked"
                "!" => "Ignored"
                _ => "Unknown"
            })
        }
    }
}

export def git-log [--oneline(-o): bool] {
    if $oneline {
        git log --oneline --graph --decorate
    } else {
        git log --graph --pretty=format:"%h - %an, %ar : %s"
    }
}

export def git-branch-info [] {
    let current_branch = (git branch --show-current)
    let branches = (git branch -a | lines | each { |it| $it | str trim | str replace "remotes/origin/" "" })
    let remotes = (git remote -v | lines | each { |it| $it | split row " " | get 0 })

    {
        current: $current_branch,
        local: ($branches | where not ($it | str contains "origin/")),
        remote: ($branches | where $it | str contains "origin/"),
        remotes: $remotes
    }
}

# Alias pour les commandes Git
alias gs = git-status
alias gl = git-log
alias gb = git-branch-info
alias gd = git diff
alias ga = git add
alias gc = git commit
alias gp = git push
alias gpl = git pull
```

**Workflow Git automatisé :**

```sh
# functions/git-workflow.nu
export def git-quick-commit [message: string] {
    git add .
    git commit -m $message
    print "Commit créé avec succès"
}

export def git-push-branch [branch_name: string] {
    git push -u origin $branch_name
    print $"Branche ($branch_name) poussée vers origin"
}

export def git-sync [] {
    git fetch --all
    git pull origin (git branch --show-current)
    print "Synchronisation terminée"
}

export def git-cleanup [] {
    git branch --merged | lines | where $it != "*" and $it != "main" and $it != "master" | each { |branch|
        git branch -d ($branch | str trim)
        print $"Branche supprimée: ($branch)"
    }
}

# Alias pour le workflow
alias gqc = git-quick-commit
alias gpb = git-push-branch
alias gsync = git-sync
alias gclean = git-cleanup
```

#### 🔧 Configuration par environnement

**Configuration de développement :**

```sh
# env/development.nu
$env.NODE_ENV = "development"
$env.DEBUG = "true"
$env.LOG_LEVEL = "debug"

# Configuration de la base de données
$env.DATABASE_URL = "postgresql://localhost:5432/myapp_dev"
$env.REDIS_URL = "redis://localhost:6379"

# Configuration des services
$env.API_URL = "http://localhost:3000"
$env.WEB_URL = "http://localhost:8080"

# Alias spécifiques au développement
alias dev-server = npm run dev
alias test = npm test
alias build = npm run build
alias lint = npm run lint
```

**Configuration de production :**

```sh
# env/production.nu
$env.NODE_ENV = "production"
$env.DEBUG = "false"
$env.LOG_LEVEL = "error"

# Configuration de la base de données
$env.DATABASE_URL = $env.PROD_DATABASE_URL
$env.REDIS_URL = $env.PROD_REDIS_URL

# Configuration des services
$env.API_URL = $env.PROD_API_URL
$env.WEB_URL = $env.PROD_WEB_URL

# Alias spécifiques à  la production
alias deploy = ./scripts/deploy.sh
alias backup = ./scripts/backup.sh
alias monitor = ./scripts/monitor.sh
```

**Charger la configuration selon l'environnement :**

```sh
# config.nu
def load-env-config [env_name: string] {
    let config_file = $"~/.config/nushell/env/($env_name).nu"

    if ($config_file | path exists) {
        source $config_file
        print $"Configuration '$env_name' chargée"
    } else {
        print $"Configuration '$env_name' non trouvée"
    }
}

# Charger la configuration selon la variable d'environnement
if ("NUSHELL_ENV" in $env) {
    load-env-config $env.NUSHELL_ENV
} else {
    load-env-config "development"
}

# Fonction pour changer d'environnement
export def switch-env [env_name: string] {
    $env.NUSHELL_ENV = $env_name
    load-env-config $env_name
    print $"Environnement changé vers: ($env_name)"
}
```

> La configuration personnalisée permet d'adapter NuShell à  vos besoins spécifiques et d'automatiser vos workflows quotidiens.
