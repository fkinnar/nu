# Fichier: sql-server-iris.nu
# Contient des fonctions NuShell pour interagir avec SQL Server.

# Définit une fonction pour interroger SQL Server et retourner un tableau NuShell.
export def "query-sql-server" [
    query: string # La requête SQL à exécuter.
    --environment (-e): string # L'environnement à utiliser (dev, prod, etc.).
    --verbose (-v) # Affiche les messages de débogage.
    --trust # Utilise l'authentification Windows intégrée (équivalent à -E de sqlcmd).
    --username (-u): string # Nom d'utilisateur pour l'authentification SQL.
    --password (-p): string # Mot de passe pour l'authentification SQL.
    --separator (-s): string = "~" # Séparateur pour la sortie CSV (défaut: ~).
    --help (-h) # Affiche cette aide.
] {
    if $help {
        print "=== query-sql-server - Interrogation de SQL Server ==="
        print ""
        print "Usage:"
        print "  query-sql-server <QUERY> [OPTIONS]"
        print ""
        print "Arguments:"
        print "  QUERY                   Requête SQL à exécuter"
        print ""
        print "Options:"
        print "  -e, --environment <env> Environnement à utiliser (dev, prod)"
        print "  -v, --verbose          Affiche les messages de débogage"
        print "  --trust                Utilise l'authentification Windows intégrée"
        print "  -u, --username <user>  Nom d'utilisateur pour l'authentification SQL"
        print "  -p, --password <pass>  Mot de passe pour l'authentification SQL"
        print "  -s, --separator <sep>  Séparateur pour la sortie CSV (défaut: ~)"
        print "  -h, --help             Affiche cette aide"
        print ""
        print "Exemples:"
        print "  query-sql-server \"SELECT * FROM Users\""
        print "  query-sql-server \"SELECT COUNT(*) FROM Orders\" --environment prod"
        print "  query-sql-server \"SELECT * FROM Products\" --trust --verbose"
        print "  query-sql-server \"SELECT * FROM Sales\" --username sa --password mypass"
        print "  query-sql-server \"SELECT * FROM Data\" --separator \"|\""
        print ""
        print "Environnements disponibles:"
        print "  dev  - Serveur: 2019-SQLTEST, Base: AgrDev"
        print "  prod - Serveur: 2019-SQL01, Base: AgrProd"
        print ""
        print "Variables d'environnement:"
        print "  SQL_DEFAULT_ENV        Environnement par défaut (dev, prod)"
        return
    }
    # Détermine l'environnement à utiliser de manière explicite.
    mut current_env = "dev" # Valeur par défaut absolue

    if ("SQL_DEFAULT_ENV" in $env and $env.SQL_DEFAULT_ENV != null and $env.SQL_DEFAULT_ENV != "") {
        $current_env = $env.SQL_DEFAULT_ENV # Utilise la valeur par défaut de l'environnement si définie
    }
    if ($environment != null) {
        $current_env = $environment # Surcharge si le paramètre --environment est fourni
    }

    let server = (match $current_env {
        "dev" => "2019-SQLTEST",
        "prod" => "2019-SQL01",
        _ => { error make { msg: $"Environnement inconnu: '($current_env)'." } }
    })

    let database = (match $current_env {
        "dev" => "AgrDev",
        "prod" => "AgrProd",
        _ => { error make { msg: $"Environnement inconnu: '($current_env)'." } }
    })

    if ($server | is-empty) or ($database | is-empty) {
        error make { msg: $"Configuration manquante pour l'environnement '($current_env)'." }
    }

    # Construit les arguments d'authentification pour sqlcmd
    let auth_args = if $trust {
        ["-E"]  # Authentification Windows intégrée
    } else if ($username != null and $password != null) {
        ["-U", $username, "-P", $password]  # Authentification SQL avec username/password
    } else if ($username != null) {
        ["-U", $username]  # Authentification SQL avec username seulement (prompt pour password)
    } else {
        []  # Pas d'arguments d'authentification (utilise les credentials par défaut)
    }

    # Affiche un message d'information (si nécessaire)
    if $verbose {
        let auth_info = if $trust {
            "authentification Windows intégrée"
        } else if ($username != null) {
            $"authentification SQL (utilisateur: $username)"
        } else {
            "authentification par défaut"
        }
        print $"Exécution de la requête sur ($database)@($server) [environnement: ($current_env), $auth_info]..."
    }

    # Exécute sqlcmd avec les arguments d'authentification appropriés
    let sqlcmd_args = ([
        "-S", $server,
        "-d", $database,
        "-b", "-W", "-s", $separator, "-k", "1", "-Q", $query,
        "-f", "65001"  # Force l'encodage UTF-8
    ] ++ $auth_args)

    # Exécute sqlcmd et traite la sortie
    let raw_output = (try {
        sqlcmd ...$sqlcmd_args
    } catch {
        error make { msg: "Erreur lors de l'exécution de sqlcmd. Vérifiez vos credentials, permissions ou la connectivité au serveur." }
    })

    # Convertit la sortie en string
    let raw_output_str = try {
        $raw_output | decode utf-8
    } catch {
        $raw_output
    }

    # Nettoie la sortie et la convertit en CSV
    let cleaned_lines = ($raw_output_str | lines | where { |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty) and not ($it | str starts-with "Changed database context") and not ($it | str contains "Login failed") and not ($it | str contains "Access denied") })

    # Vérifie s'il y a des messages d'erreur dans la sortie
    let error_lines = ($raw_output_str | lines | where { |it| ($it | str contains "Login failed") or ($it | str contains "Access denied") or ($it | str contains "permission") or ($it | str contains "denied") })

    if ($error_lines | length) > 0 {
        error make { msg: $"Erreur d'authentification ou de permissions: ($error_lines | str join '; ')" }
    }

    # Parse le format avec pipe comme séparateur
    let result = if ($cleaned_lines | length) > 0 {
        let header_line = ($cleaned_lines | first)
        let headers = ($header_line | split row $separator | each { |it| $it | str trim })
        let data_lines = ($cleaned_lines | skip 1)

        $data_lines | each { |line|
            let parts = ($line | split row $separator | each { |it| $it | str trim })
            $headers | enumerate | reduce -f {} { |it, acc|
                let value = if ($it.index | into int) < ($parts | length) {
                    $parts | get $it.index
                } else {
                    ""
                }
                $acc | upsert $it.item $value
            }
        }
    } else {
        []
    }

    # Vérifie si le résultat est vide
    if ($result | is-empty) {
        error make { msg: "Aucun résultat retourné. Vérifiez que la requête est correcte et que vous avez les permissions nécessaires pour accéder aux données." }
    } else {
        # Retourne le tableau NuShell
        $result
    }
}
