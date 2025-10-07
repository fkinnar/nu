# Fichier: sql_functions.nu
# Contient des fonctions NuShell pour interagir avec SQL Server.

# Définit une fonction pour interroger SQL Server et retourner un tableau NuShell.
export def "query-sql-server" [
    query: string # La requête SQL à exécuter.
    --environment (-e): string # L'environnement à utiliser (dev, prod, etc.).
    --verbose (-v) # Affiche les messages de débogage.
] {
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

    # Affiche un message d'information (si nécessaire)
    if ($verbose) {
        print $"Exécution de la requête sur ($database)@($server) [environnement: ($current_env)]..."
    }

    # Exécute sqlcmd, nettoie la sortie et la convertit en tableau CSV.
    let result = (sqlcmd -S $server -d $database -E -b -W -s "," -k 1 -Q $query | lines | where { |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty) } | str join "\n" | from csv)

    # Vérifie si le résultat est vide ou contient une erreur
    if ($result | is-empty) {
        error make { msg: "Aucun résultat ou erreur lors de l'exécution de la requête. Vérifiez la requête, le serveur ou la base de données." }
    } else {
        # Retourne le tableau NuShell
        $result
    }
}
