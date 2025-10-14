export def --env load-dotenv [
    file?: string,
    --force(-f),
    --quiet(-q),
    --help(-h)
] {
    if $help {
        print "=== load-dotenv - Chargeur de variables d'environnement ==="
        print ""
        print "Usage:"
        print "  load-dotenv [OPTIONS] [FILE]"
        print "  open <file> | load-dotenv [OPTIONS]"
        print ""
        print "Arguments:"
        print "  FILE                    Fichier .env à charger (défaut: .env)"
        print ""
        print "Options:"
        print "  -f, --force            Écraser les variables existantes"
        print "  -q, --quiet            Mode silencieux (pas de messages)"
        print "  -h, --help             Afficher cette aide"
        print ""
        print "Exemples:"
        print "  load-dotenv                    # Charge .env par défaut"
        print "  load-dotenv config.env         # Charge config.env"
        print "  load-dotenv --force            # Écrase les variables existantes"
        print "  load-dotenv --quiet            # Mode silencieux"
        print "  open .env | load-dotenv        # Charge depuis un pipe"
        print ""
        print "Format du fichier .env:"
        print "  # Commentaires commencent par #"
        print "  DATABASE_URL=postgresql://..."
        print "  API_KEY=your-secret-key"
        print "  DEBUG=true"
        return
    }
    let content = if $file != null {
        open $file
    } else if ($in | is-empty) {
        open .env
    } else {
        $in
    }

    let env_vars = $content
    | lines
    | where ($it | str trim) != ""
    | where not ($it | str starts-with "#")
    | parse "{key}={value}"

    # Séparer les variables existantes et nouvelles
    let existing_vars = $env_vars | where { |it| ($env | get -o $it.key | is-not-empty) }
    let new_vars = $env_vars | where { |it| ($env | get -o $it.key | is-empty) }

    # Afficher les avertissements si pas en mode quiet
    if not $quiet {
        for $var in $existing_vars {
            if $force {
                print $"Variable ($var.key) écrasée avec la valeur: ($var.value)"
            } else {
                print $"Warning: Variable ($var.key) existe déjà et n'a pas été modifiée. Utilisez --force pour l'écraser."
            }
        }
    }

    # Charger les variables selon le mode
    let vars_to_load = if $force {
        $env_vars
    } else {
        $new_vars
    }

    $vars_to_load
    | reduce -f {} { |it, acc| $acc | upsert $it.key $it.value }
    | load-env
}