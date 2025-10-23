### ðŸ› ï¸ Scripts et commandes personnalisÃ©es

NuShell permet de crÃ©er des scripts et des commandes personnalisÃ©es trÃ¨s facilement. Ces scripts peuvent Ãªtre exportÃ©s et rÃ©utilisÃ©s dans diffÃ©rents projets.

#### ðŸ”¹Concepts fondamentaux du langage

Avant de crÃ©er des scripts, il est important de comprendre les concepts de base du langage Nushell.

**Variables et types :**

```sh
# DÃ©claration de variables
let name = "Alice"
let age = 30
let active = true
let scores = [85, 92, 78]
let birthday = "1990-05-15"

# Types automatiquement infÃ©rÃ©s
$name | describe    # string
$age | describe     # int
$active | describe  # bool
$scores | describe  # list<int>
$birthday | describe # string
```

```sh
string
int
bool
list<int>
string
```

**Casting et conversion de types :**

```sh
# Conversion de types avec la commande 'into'
let age_str = "25"
let age_int = $age_str | into int
let age_float = $age_str | into float

# Conversion de dates
let date_str = "2023-12-25"
let date_obj = $date_str | into datetime
let date_formatted = $date_obj | into string

# Conversion de boolÃ©ens
let bool_str = "true"
let bool_val = $bool_str | into bool

# VÃ©rification des types aprÃ¨s conversion
$age_int | describe     # int
$date_obj | describe    # datetime
$bool_val | describe    # bool
```

```sh
int
datetime
bool
```

```sh
# Manipulation de dates
let today = date now
let yesterday = ($today - 1day)
let next_week = ($today + 7day)

print $"Aujourd'hui: ($today)"
print $"Hier: ($yesterday)"
print $"Dans une semaine: ($next_week)"
```

```sh
Aujourd'hui: 2025-01-14 15:30:45.123456789 +01:00
Hier: 2025-01-13 15:30:45.123456789 +01:00
Dans une semaine: 2025-01-21 15:30:45.123456789 +01:00
```

**Conditions :**

```sh
let score = 85

if $score >= 90 {
    print "Excellent!"
} else if $score >= 80 {
    print "TrÃ¨s bien!"
} else if $score >= 70 {
    print "Bien!"
} else {
    print "Ã€ amÃ©liorer"
}
```

```sh
TrÃ¨s bien!
```

**Boucles :**

```sh
# Boucle for
for $i in 1..5 {
    print $"NumÃ©ro: ($i)"
}

# Boucle while
mut counter = 0
while $counter < 3 {
    print $"Compteur: ($counter)"
    $counter = $counter + 1
}
```

```sh
NumÃ©ro: 1
NumÃ©ro: 2
NumÃ©ro: 3
NumÃ©ro: 4
NumÃ©ro: 5
Compteur: 0
Compteur: 1
Compteur: 2
```

**Valeur de retour des fonctions :**

En Nushell, la valeur de retour d'une fonction est automatiquement la derniÃ¨re expression Ã©valuÃ©e :

```sh
def calculate [a: int, b: int] {
    let sum = $a + $b
    let product = $a * $b
    $product  # Cette ligne est la valeur de retour
}

calculate 3 4
```

```sh
12
```

On peut aussi utiliser `return` explicitement :

```sh
def check_age [age: int] {
    if $age < 18 {
        return "Mineur"
    }
    return "Majeur"
}

check_age 16
```

```sh
Mineur
```

**OpÃ©rateurs et expressions :**

```sh
# OpÃ©rateurs mathÃ©matiques
let a = 10
let b = 5
let result = $a + $b * 2
print $"RÃ©sultat: ($result)"

# OpÃ©rateurs de comparaison
let score1 = 85
let score2 = 90
let is_better = $score2 > $score1
print $"Score2 est meilleur: ($is_better)"

# OpÃ©rateurs logiques
let age = 25
let has_license = true
let can_drive = $age >= 18 and $has_license
print $"Peut conduire: ($can_drive)"

# OpÃ©rateurs de chaÃ®nes
let first_name = "Alice"
let last_name = "Smith"
let full_name = $first_name + " " + $last_name
print $"Nom complet: ($full_name)"

# OpÃ©rateur de correspondance
let text = "Hello World"
let contains_hello = $text =~ "Hello"
print $"Contient 'Hello': ($contains_hello)"
```

```sh
RÃ©sultat: 20
Score2 est meilleur: true
Peut conduire: true
Nom complet: Alice Smith
Contient 'Hello': true
```

**Ranges et sÃ©quences :**

```sh
# Ranges numÃ©riques
let numbers = 1..10
print $numbers

# Ranges de caractÃ¨res
let letters = 'a'..'z'
print ($letters | first 5)

# Ranges avec conditions
let even_numbers = (1..20 | where $it % 2 == 0)
print ($even_numbers | first 5)

# Ranges inversÃ©s
let countdown = (10..1)
print ($countdown | first 3)
```

```sh
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[a, b, c, d, e]
[2, 4, 6, 8, 10]
[10, 9, 8]
```

**Closures et fonctions anonymes :**

```sh
# DÃ©finir une closure
let add = { |x, y| $x + $y }
let multiply = { |x, y| $x * $y }

print (add 5 3)
print (multiply 4 6)

# Closures avec each
let numbers = [1, 2, 3, 4, 5]
let doubled = ($numbers | each { |it| $it * 2 })
print $doubled

# Closures avec where
let scores = [85, 92, 78, 96, 88]
let high_scores = ($scores | where { |it| $it >= 90 })
print $high_scores

# Closures avec reduce
let numbers = [1, 2, 3, 4, 5]
let sum = ($numbers | reduce -f 0 { |it, acc| $acc + $it })
print $"Somme: ($sum)"
```

```sh
8
24
[2, 4, 6, 8, 10]
[92, 96]
Somme: 15
```

**Manipulation de donnÃ©es :**

```sh
# CrÃ©er un tableau
let users = [
    {name: "Alice", age: 30, city: "Paris"},
    {name: "Bob", age: 25, city: "Lyon"},
    {name: "Charlie", age: 35, city: "Marseille"}
]

# Filtrer et transformer
$users
| where age > 25
| each { |it| {nom: $it.name, ville: $it.city} }
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚  nom   â”‚   ville   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ Alice  â”‚ Paris     â”‚
â”‚ 1 â”‚ Charlieâ”‚ Marseille â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Gestion des erreurs dans les scripts

NuShell offre plusieurs mÃ©canismes pour gÃ©rer les erreurs et dÃ©boguer les scripts.

**Gestion d'erreurs avec try-catch :**

```sh
# Gestion d'erreur basique
try {
    open "fichier-inexistant.txt"
} catch {
    print "Le fichier n'existe pas"
}
```

```sh
Le fichier n'existe pas
```

```sh
# RÃ©cupÃ©rer l'erreur pour l'analyser
try {
    "abc" | into int
} catch { |err|
    print $"Erreur de conversion: ($err)"
}
```

```sh
Erreur de conversion: nu::shell::cant_convert
```

**CrÃ©er des erreurs personnalisÃ©es :**

```sh
def validate_age [age: int] {
    if $age < 0 {
        error make { msg: "L'Ã¢ge ne peut pas Ãªtre nÃ©gatif" }
    } else if $age > 150 {
        error make { msg: "L'Ã¢ge semble irrÃ©aliste" }
    } else {
        print $"Ã‚ge valide: ($age)"
    }
}

validate_age 25
validate_age -5
```

```sh
Ã‚ge valide: 25
Error: nu::shell::error

  Ã— L'Ã¢ge ne peut pas Ãªtre nÃ©gatif
```

**Gestion d'erreurs dans les pipelines :**

```sh
# Utiliser '?' pour propager les erreurs
def safe_divide [a: int, b: int] {
    if $b == 0 {
        error make { msg: "Division par zÃ©ro" }
    } else {
        $a / $b
    }
}

# Propagation automatique avec '?'
let result = (try {
    safe_divide 10 2
} catch { |err|
    print $"Erreur: ($err)"
    0
})

print $"RÃ©sultat: ($result)"
```

```sh
RÃ©sultat: 5
```

**Debugging et traÃ§age :**

```sh
def debug_function [input: string] {
    print $"EntrÃ©e: ($input)"
    let processed = ($input | str upcase)
    print $"AprÃ¨s traitement: ($processed)"
    $processed
}

debug_function "hello"
```

```sh
EntrÃ©e: hello
AprÃ¨s traitement: HELLO
HELLO
```

```sh
# Utiliser 'debug' pour inspecter les valeurs
let data = [1, 2, 3, 4, 5]
$data | debug | where $it > 3
```

#### ðŸ”¹Variables d'environnement dans les scripts

**Modifier les variables d'environnement :**

```sh
# DÃ©finir une variable temporaire
$env.MY_VAR = "valeur temporaire"
print $env.MY_VAR

# Modifier le PATH
$env.PATH = ($env.PATH | split row ":" | append "/usr/local/bin" | str join ":")

# Ajouter au PATH (mÃ©thode plus propre)
$env.PATH = ($env.PATH | split row ":" | append "/opt/myapp/bin" | str join ":")
```

```sh
valeur temporaire
```

**Charger des variables depuis un fichier :**

```sh
# CrÃ©er un fichier de variables
echo "API_KEY=abc123
DEBUG=true
LOG_LEVEL=info" | save config.env

# Charger les variables
open config.env | lines | parse "{key}={value}" | reduce -f {} { |it, acc| $acc | upsert $it.key $it.value } | load-env

# VÃ©rifier que les variables sont chargÃ©es
print $env.API_KEY
print $env.DEBUG
```

```sh
abc123
true
```

**Persistance des variables d'environnement :**

```sh
# Dans config.nu - variables persistantes
$env.MY_PROJECT_ROOT = "/home/user/projects"
$env.EDITOR = "code"
$env.GIT_AUTHOR_NAME = "Mon Nom"

# Variables conditionnelles
if $env.OS == "Windows_NT" {
    $env.PATH = ($env.PATH | split row ";" | append "C:\\tools" | str join ";")
} else {
    $env.PATH = ($env.PATH | split row ":" | append "/usr/local/bin" | str join ":")
}
```

**Variables d'environnement dans les scripts :**

```sh
export def --env setup-project [project_name: string] {
    $env.PROJECT_NAME = $project_name
    $env.PROJECT_ROOT = ($env.HOME | path join "projects" $project_name)
    $env.PROJECT_ENV = "development"

    print $"Projet configurÃ©: ($env.PROJECT_NAME)"
    print $"Racine: ($env.PROJECT_ROOT)"
    print $"Environnement: ($env.PROJECT_ENV)"
}

setup-project "mon-app"
```

```sh
Projet configurÃ©: mon-app
Racine: /home/user/projects/mon-app
Environnement: development
```

**Gestion des variables sensibles :**

```sh
# Variables d'environnement pour les secrets
$env.DATABASE_PASSWORD = (input "Mot de passe DB: " --password)
$env.API_SECRET = (input "ClÃ© API secrÃ¨te: " --password)

# Utilisation dans les scripts
def connect-db [] {
    let connection_string = $"postgresql://user:($env.DATABASE_PASSWORD)@localhost/db"
    print "Connexion Ã  la base de donnÃ©es..."
    # ... logique de connexion
}
```

> Les variables d'environnement sont essentielles pour la configuration des applications et le partage de paramÃ¨tres entre scripts.

#### ðŸ”¹CrÃ©er une commande simple

```sh
def greet [name: string] {
    print $"Hello, ($name)!"
}

greet "Nushell"
```

```sh
Hello, Nushell!
```

> La commande `def` permet de dÃ©finir une nouvelle commande. Les paramÃ¨tres sont typÃ©s (ici `string`).

#### ðŸ”¹CrÃ©er une commande avec plusieurs paramÃ¨tres

```sh
def add [a: int, b: int] {
    $a + $b
}

add 5 3
```

```sh
8
```

#### ðŸ”¹CrÃ©er une commande avec des options

```sh
def greet [
    name: string,
    --formal,
    --shout
] {
    let greeting = if $formal { "Good day" } else { "Hello" }
    let message = $"($greeting), ($name)!"

    if $shout {
        $message | str upcase
    } else {
        $message
    }
}

print (greet "Alice")
print (greet "Bob" --formal)
print (greet "Charlie" --shout)
print (greet "David" --formal --shout)
```

```sh
Hello, Alice!
Good day, Bob!
HELLO, CHARLIE!
GOOD DAY, DAVID!
```

#### ðŸ”¹Exporter une commande pour la rÃ©utiliser

```sh
export def load-dotenv [
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
        print "Options:"
        print "  -f, --force            Ã‰craser les variables existantes"
        print "  -q, --quiet            Mode silencieux (pas de messages)"
        print "  -h, --help             Afficher cette aide"
        return
    }

    let content = if $file != null {
        try { open $file } catch {
            print $"Erreur: Le fichier ($file) n'existe pas."
            return
        }
    } else {
        let input = $in
        if ($input | describe) == "nothing" {
            try { open .env } catch {
                print "Erreur: Le fichier .env n'existe pas."
                return
            }
        } else {
            $input
        }
    }

    let env_vars = $content
    | lines
    | where ($it | str trim) != ""
    | where not ($it | str starts-with "#")
    | parse "{key}={value}"

    # SÃ©parer les variables existantes et nouvelles
    let existing_vars = $env_vars | where { |it| ($env | get -o $it.key | is-not-empty) }
    let new_vars = $env_vars | where { |it| ($env | get -o $it.key | is-empty) }

    # Afficher les avertissements si pas en mode quiet
    if not $quiet {
        for $var in $existing_vars {
            if $force {
                print $"Variable ($var.key) Ã©crasÃ©e avec la valeur: ($var.value)"
            } else {
                print $"Warning: Variable ($var.key) existe dÃ©jÃ  et n'a pas Ã©tÃ© modifiÃ©e. Utilisez --force pour l'Ã©craser."
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
```

> `export def` permet d'exporter la commande pour qu'elle soit disponible dans d'autres scripts ou dans la configuration.

#### ðŸ”¹Utiliser une commande exportÃ©e

```sh
# Charger le script
source scripts/load-dotenv.nu

# Utiliser la commande
load-dotenv                    # Charge .env par dÃ©faut
load-dotenv config.env         # Charge un fichier spÃ©cifique
open .env | load-dotenv        # Utilise le pipe (approche Nushellienne)
load-dotenv --force            # Ã‰crase les variables existantes
load-dotenv --quiet            # Mode silencieux
load-dotenv --help             # Affiche l'aide
```

#### ðŸ”¹CrÃ©er une commande qui modifie l'environnement

```sh
export def --env my-cd [path: string] {
    cd $path
    print $"RÃ©pertoire changÃ© vers: ($env.PWD)"
}

my-cd /tmp
```

```sh
RÃ©pertoire changÃ© vers: /tmp
```

> `def --env` permet Ã  la commande de modifier l'environnement du shell appelant. Sans cela, les changements d'environnement sont limitÃ©s au scope de la commande.

#### ðŸ”¹Quand utiliser `def --env` ?

**Utilisez `def --env` quand votre fonction doit :**

- Changer le rÃ©pertoire de travail (`cd`)
- Modifier des variables d'environnement qui doivent persister
- CrÃ©er des alias ou des fonctions temporaires
- Configurer l'environnement pour la session

#### ðŸ”¹Exemple pratique : Navigation vers les repos

```sh
# scripts/go-to-repos.nu
def --env repos [subpath? : string] {
  mut real_path = $env.repos

  if ($subpath != null and $subpath != '') {
    $real_path = ($real_path | path join $subpath)
  }

  cd $real_path
}
```

**Utilisation :**

```sh
# DÃ©finir la variable d'environnement
$env.repos = "D:\Users\kinnar\source\repos"

# Charger le script
source scripts/go-to-repos.nu

# Utiliser la fonction
repos                    # Va vers D:\Users\kinnar\source\repos
repos n2f               # Va vers D:\Users\kinnar\source\repos\n2f
repos "autre-projet"    # Va vers D:\Users\kinnar\source\repos\autre-projet
```

**âš ï¸ Important :** Sans `--env`, la fonction `cd` ne changerait pas le rÃ©pertoire de la session parente !

#### ðŸ”¹CrÃ©er une commande complexe avec gestion d'erreurs

```sh
export def query-sql-server [
    query: string,
    --environment (-e): string,
    --verbose (-v),
    --trust,
    --username (-u): string,
    --password (-p): string,
    --help (-h)
] {
    if $help {
        print "=== query-sql-server - Interrogation de SQL Server ==="
        print ""
        print "Usage:"
        print "  query-sql-server <QUERY> [OPTIONS]"
        print ""
        print "Options:"
        print "  -e, --environment <env> Environnement Ã  utiliser (dev, prod)"
        print "  -v, --verbose          Affiche les messages de dÃ©bogage"
        print "  --trust                Utilise l'authentification Windows intÃ©grÃ©e"
        print "  -u, --username <user>  Nom d'utilisateur pour l'authentification SQL"
        print "  -p, --password <pass>  Mot de passe pour l'authentification SQL"
        print "  -h, --help             Affiche cette aide"
        return
    }

    # DÃ©termine l'environnement
    mut current_env = "dev"
    if ("SQL_DEFAULT_ENV" in $env and $env.SQL_DEFAULT_ENV != null) {
        $current_env = $env.SQL_DEFAULT_ENV
    }
    if ($environment != null) {
        $current_env = $environment
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

    # Construit les arguments d'authentification
    let auth_args = if $trust {
        ["-E"]
    } else if ($username != null and $password != null) {
        ["-U", $username, "-P", $password]
    } else if ($username != null) {
        ["-U", $username]
    } else {
        []
    }

    # ExÃ©cute sqlcmd avec gestion d'erreur
    let raw_output = (try {
        sqlcmd -S $server -d $database -b -W -s "," -k 1 -Q $query -f 65001 ...$auth_args
    } catch {
        error make { msg: "Erreur lors de l'exÃ©cution de sqlcmd. VÃ©rifiez vos credentials, permissions ou la connectivitÃ© au serveur." }
    })

    # Nettoie et convertit la sortie
    let cleaned_lines = ($raw_output | lines | where { |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty) and not ($it | str starts-with "Changed database context") })

    let result = if ($cleaned_lines | length) > 0 {
        $cleaned_lines | str join "\n" | from csv
    } else {
        []
    }

    if ($result | is-empty) {
        error make { msg: "Aucun rÃ©sultat retournÃ©. VÃ©rifiez que la requÃªte est correcte et que vous avez les permissions nÃ©cessaires." }
    } else {
        $result
    }
}
```

#### ðŸ”¹Utiliser la commande SQL

```sh
# Charger le script
source scripts/sql-server-iris.nu

# Utiliser la commande
query-sql-server "SELECT * FROM iris_geo_company" --environment prod --username=$env.AGRESSO_DB_USER --password=$env.AGRESSO_DB_PASSWORD
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚                  id                   â”‚        company_name         â”‚ company_number â”‚ company_country â”‚ company_code â”‚ company_group â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8  â”‚ SA IRIS                     â”‚      453520431 â”‚ Belgium         â”‚ IRS          â”‚ IND           â”‚
â”‚ 1 â”‚ 8a718cd0-fa68-477c-86f4-e7734ba5336c  â”‚ IRIS CLEANING SERVICES  SA  â”‚      453520233 â”‚ Belgium         â”‚ ICS          â”‚ IFS           â”‚
â”‚ 2 â”‚ ef976bdb-caf8-40a7-87e9-f857b75d6073  â”‚ SPRL IRIS GREENCARE         â”‚      416912532 â”‚ Belgium         â”‚ IGC          â”‚ IGC           â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Organiser les scripts dans des modules

```sh
# scripts/mod.nu
export use load-dotenv.nu
export use sql-server-iris.nu
```

```sh
# Utiliser le module
use scripts/mod.nu *
load-dotenv
query-sql-server "SELECT COUNT(*) FROM iris_geo_company"
```

#### ðŸ”¹Ajouter des scripts Ã  la configuration

```sh
# Dans config.nu
source ~/path/to/scripts/load-dotenv.nu
source ~/path/to/scripts/sql-server-iris.nu
```

> Une fois ajoutÃ©s Ã  la configuration, les scripts sont disponibles automatiquement Ã  chaque dÃ©marrage de NuShell.

#### ðŸ”¹CrÃ©er une commande qui wrap une commande externe

```sh
export def --wrapped my-git [...args] {
    if $args.0 == "status" {
        git ...$args | lines | where { |it| ($it | str contains "modified") or ($it | str contains "new file") }
    } else {
        git ...$args
    }}

my-git status
```

> `def --wrapped` permet de crÃ©er une commande qui Ã©tend une commande externe en interceptant ses arguments.

#### ðŸ”¹Bonnes pratiques pour les scripts

1. **Utiliser `export def`** pour les commandes rÃ©utilisables
2. **Ajouter de l'aide** avec `--help` et des commentaires
3. **GÃ©rer les erreurs** avec `try-catch` et `error make`
4. **Utiliser des types** pour les paramÃ¨tres (`string`, `int`, etc.)
5. **Organiser** les scripts dans des dossiers dÃ©diÃ©s
6. **Tester** les scripts avec diffÃ©rents paramÃ¨tres
7. **Documenter** l'usage avec des exemples concrets

> Les scripts NuShell sont trÃ¨s puissants et permettent d'automatiser des tÃ¢ches complexes tout en gardant la lisibilitÃ© et la maintenabilitÃ© du code.
