### ðŸ”§ Outils et Utilitaires

#### ðŸ”¹Chemins et navigation avancÃ©e

**Navigation intelligente :**

```sh
# Fonction de navigation avec historique
export def --env smart-cd [path: string] {
    # Sauvegarder l'ancien rÃ©pertoire
    let old_path = $env.PWD

    # Changer de rÃ©pertoire
    cd $path

    # Ajouter Ã  l'historique
    $env.DIR_HISTORY = ($env.DIR_HISTORY | default [] | append $old_path | last 50)

    print $"RÃ©pertoire changÃ©: ($old_path) -> ($env.PWD)"
}

# Alias pour la navigation intelligente
alias cd = smart-cd
alias back = cd $env.DIR_HISTORY.0

# Navigation rapide vers les dossiers frÃ©quents
export def --env quick-cd [name: string] {
    let quick_paths = {
        "docs" => "~/Documents",
        "proj" => "~/Projects",
        "temp" => "/tmp",
        "home" => "~",
        "root" => "/"
    }

    if ($name in $quick_paths) {
        cd ($quick_paths | get $name)
        print $"NaviguÃ© vers: ($name) -> ($env.PWD)"
    } else {
        print "Dossier rapide non trouvÃ©. Dossiers disponibles:"
        $quick_paths | transpose name path | select name
    }
}

# Alias pour la navigation rapide
alias qcd = quick-cd
```

**Recherche de fichiers avancÃ©e :**

```sh
# Recherche de fichiers par nom
export def find-file [pattern: string, --directory(-d): string = "."] {
    ls $directory **/* | where name =~ $pattern | select name type size modified
}

# Recherche de fichiers par contenu
export def find-content [pattern: string, --directory(-d): string = ".", --type(-t): string = "file"] {
    ls $directory **/* | where type == $type | each { |file|
        try {
            let content = (open $file.name --raw)
            if ($content | str contains $pattern) {
                {file: $file.name, matches: ($content | str index-of $pattern | length)}
            }
        } catch {
            # Ignorer les fichiers non lisibles
        }
    } | where $it != null
}

# Recherche de fichiers par taille
export def find-large-files [--min-size(-s): string = "100MB", --directory(-d): string = "."] {
    let min_bytes = ($min_size | into filesize)
    ls $directory **/* | where type == "file" and size > $min_bytes | sort-by size -r
}

# Alias pour la recherche
alias ff = find-file
alias fc = find-content
alias fl = find-large-files
```

**Gestion des chemins :**

```sh
# Fonction pour nettoyer les chemins
export def clean-path [path: string] {
    $path | path expand | path normalize
}

# Fonction pour obtenir le chemin relatif
export def relative-path [target: string, base: string = $env.PWD] {
    let target_path = ($target | path expand)
    let base_path = ($base | path expand)

    if ($target_path | str starts-with $base_path) {
        $target_path | str substring ($base_path | str length).. | str substring 1..
    } else {
        $target_path
    }
}

# Fonction pour crÃ©er une structure de dossiers
export def mkdir-tree [structure: record] {
    $structure | transpose name children | each { |item|
        let dir_path = $item.name
        mkdir $dir_path

        if ($item.children | is-not-empty) {
            cd $dir_path
            mkdir-tree $item.children
            cd ..
        }
    }
}

# Exemple d'utilisation
mkdir-tree {
    "project": {
        "src": {
            "components": {},
            "utils": {}
        },
        "tests": {},
        "docs": {}
    }
}
```

#### ðŸ”¹Compression/dÃ©compression de fichiers

**Gestion des archives :**

```sh
# Fonction de compression universelle
export def compress [input: string, --output(-o): string, --format(-f): string = "zip"] {
    let output_file = if $output != null {
        $output
    } else {
        ($input | path parse | get stem) + $".($format)"
    }

    match $format {
        "zip" => { zip -r $output_file $input }
        "tar" => { tar -cf $output_file $input }
        "targz" => { tar -czf $output_file $input }
        "tarbz2" => { tar -cjf $output_file $input }
        "7z" => { 7z a $output_file $input }
        _ => { error make { msg: "Format non supportÃ©" } }
    }

    print $"Archive crÃ©Ã©e: ($output_file)"
}

# Fonction de dÃ©compression universelle
export def extract [archive: string, --output(-o): string] {
    let output_dir = if $output != null {
        $output
    } else {
        $archive | path parse | get stem
    }

    mkdir $output_dir
    cd $output_dir

    let ext = ($archive | path parse | get extension)
    match $ext {
        "zip" => { unzip $archive }
        "tar" => { tar -xf $archive }
        "gz" => { tar -xzf $archive }
        "bz2" => { tar -xjf $archive }
        "7z" => { 7z x $archive }
        _ => { error make { msg: "Format d'archive non supportÃ©" } }
    }

    print $"Archive extraite dans: ($output_dir)"
}

# Alias pour la compression
alias zip = compress --format zip
alias tar = compress --format tar
alias targz = compress --format targz
alias extract = extract
```

**Gestion des sauvegardes :**

```sh
# Fonction de sauvegarde avec horodatage
export def backup [source: string, --destination(-d): string = "~/backups"] {
    let timestamp = (date now | format date "%Y%m%d_%H%M%S")
    let source_name = ($source | path parse | get stem)
    let backup_name = $"($source_name)_($timestamp).tar.gz"
    let backup_path = ($destination | path join $backup_name)

    mkdir $destination
    tar -czf $backup_path $source

    print $"Sauvegarde crÃ©Ã©e: ($backup_path)"
    print $"Taille: (($backup_path | ls | get size.0) | into filesize)"
}

# Fonction de nettoyage des sauvegardes anciennes
export def cleanup-backups [backup_dir: string = "~/backups", --keep-days(-k): int = 30] {
    let cutoff_date = (date now) - ($keep_days * 1day)

    ls $backup_dir | where type == "file" and modified < $cutoff_date | each { |file|
        rm $file.name
        print $"Sauvegarde supprimÃ©e: ($file.name)"
    }
}

# Alias pour les sauvegardes
alias backup = backup
alias cleanup = cleanup-backups
```

#### ðŸ”¹Monitoring systÃ¨me

**Surveillance des processus :**

```sh
# Fonction de monitoring des processus en temps rÃ©el
export def monitor-processes [--interval(-i): duration = 5sec, --top(-t): int = 10] {
    while true {
        clear
        print $"=== Monitoring des processus - $(date now) ==="

        ps | where cpu > 0 | sort-by cpu -r | first $top | select name pid cpu mem | table

        sleep $interval
    }
}

# Fonction de surveillance de la mÃ©moire
export def monitor-memory [--interval(-i): duration = 10sec] {
    while true {
        clear
        print $"=== Surveillance de la mÃ©moire - $(date now) ==="

        let mem_info = (ps | where name != "ps" | reduce -f 0 { |it, acc| $acc + $it.mem })
        let mem_usage = ($mem_info | into filesize)

        print $"Utilisation mÃ©moire totale: ($mem_usage)"

        ps | where mem > 100MB | sort-by mem -r | first 10 | select name pid mem | table

        sleep $interval
    }
}

# Fonction de surveillance du disque
export def monitor-disk [--interval(-i): duration = 30sec] {
    while true {
        clear
        print $"=== Surveillance du disque - $(date now) ==="

        du | where physical > 1GB | sort-by physical -r | first 10 | select path physical apparent | table

        sleep $interval
    }
}

# Alias pour le monitoring
alias mon-proc = monitor-processes
alias mon-mem = monitor-memory
alias mon-disk = monitor-disk
```

**Surveillance du rÃ©seau :**

```sh
# Fonction de surveillance des connexions rÃ©seau
export def monitor-network [--interval(-i): duration = 10sec] {
    while true {
        clear
        print $"=== Surveillance rÃ©seau - $(date now) ==="

        # Connexions TCP
        print "=== Connexions TCP ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | where proto == "tcp" | table

        # Connexions UDP
        print "=== Connexions UDP ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | where proto == "udp" | table

        sleep $interval
    }
}

# Fonction de test de connectivitÃ©
export def test-connectivity [host: string, --port(-p): int = 80, --timeout(-t): int = 5] {
    try {
        let result = (run-external nc -z -w $timeout $host $port)
        print $"âœ… Connexion rÃ©ussie vers ($host):($port)"
        true
    } catch {
        print $"âŒ Connexion Ã©chouÃ©e vers ($host):($port)"
        false
    }
}

# Fonction de ping avec statistiques
export def ping-stats [host: string, --count(-c): int = 10] {
    let ping_results = (1..$count | each { |i|
        try {
            let result = (run-external ping -c 1 $host --redirect-stdout)
            let time = ($result | lines | where $it =~ "time=" | parse "time={time}ms" | get time.0 | into float)
            {success: true, time: $time}
        } catch {
            {success: false, time: 0}
        }
    })

    let successful_pings = ($ping_results | where success == true)
    let success_rate = (($successful_pings | length) / $count) * 100
    let avg_time = if ($successful_pings | is-not-empty) {
        ($successful_pings | get time | math avg)
    } else {
        0
    }

    print $"Ping vers ($host):"
    print $"  Taux de succÃ¨s: ($success_rate)%"
    print $"  Temps moyen: ($avg_time)ms"
}

# Alias pour le rÃ©seau
alias mon-net = monitor-network
alias ping = ping-stats
alias test-conn = test-connectivity
```

**Surveillance des logs :**

```sh
# Fonction de surveillance des logs en temps rÃ©el
export def tail-logs [log_file: string, --lines(-n): int = 50, --follow(-f): bool] {
    if $follow {
        tail -f -n $lines $log_file
    } else {
        tail -n $lines $log_file
    }
}

# Fonction de recherche dans les logs
export def search-logs [pattern: string, --file(-f): string, --since(-s): string] {
    let grep_cmd = if $file != null {
        $"grep -n '$pattern' $file"
    } else {
        $"grep -r -n '$pattern' /var/log/"
    }

    if $since != null {
        let since_date = ($since | into datetime)
        # Logique pour filtrer par date
    }

    run-external bash -c $grep_cmd
}

# Fonction d'analyse des logs d'erreur
export def analyze-errors [log_file: string, --hours(-h): int = 24] {
    let cutoff_time = (date now) - ($hours * 1hour)

    open $log_file | lines | where $it =~ "ERROR" | each { |line|
        let timestamp = ($line | parse "{timestamp} {level} {message}" | get timestamp.0)
        let error_time = ($timestamp | into datetime)

        if $error_time > $cutoff_time {
            $line
        }
    } | group-by { |it| $it | parse "{timestamp} {level} {message}" | get message.0 } | transpose error count | sort-by count -r
}

# Alias pour les logs
alias logs = tail-logs
alias search-logs = search-logs
alias errors = analyze-errors
```

**Tableau de bord systÃ¨me :**

```sh
# Fonction de tableau de bord complet
export def system-dashboard [--refresh(-r): duration = 5sec] {
    while true {
        clear
        print $"=== Tableau de bord systÃ¨me - $(date now) ==="

        # Informations systÃ¨me
        print "=== Informations systÃ¨me ==="
        print $"Utilisateur: ($env.USER)"
        print $"HÃ´te: (hostname)"
        print $"OS: ($env.OS)"
        print $"Architecture: ($env.ARCH)"

        # Utilisation CPU et mÃ©moire
        print "=== Utilisation des ressources ==="
        let top_processes = (ps | where cpu > 0 | sort-by cpu -r | first 5)
        $top_processes | select name pid cpu mem | table

        # Utilisation du disque
        print "=== Utilisation du disque ==="
        du | where physical > 1GB | sort-by physical -r | first 5 | select path physical | table

        # Connexions rÃ©seau
        print "=== Connexions rÃ©seau ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | group-by proto | transpose protocol count | table

        sleep $refresh
    }
}

# Alias pour le tableau de bord
alias dashboard = system-dashboard
alias sysinfo = system-dashboard
```

> Ces outils de monitoring permettent de surveiller efficacement votre systÃ¨me et de dÃ©tecter rapidement les problÃ¨mes de performance ou de sÃ©curitÃ©.
