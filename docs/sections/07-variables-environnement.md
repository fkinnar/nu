### 🌍 Variables d'environnement

NuShell gère les variables d'environnement de manière structurée et puissante.

#### 🔧 Accéder aux variables d'environnement

```sh
# Accès direct aux variables
$env.USER
$env.HOME
$env.PATH

# Lister toutes les variables d'environnement
$env | transpose key value | first 5
```

```sh
┌───┬─────────┬─────────────────────────────────────┤
│ # │   key   │                value                │
├───├─────────├─────────────────────────────────────┼
│ 0 │ USER    │ kinnar                              │
│ 1 │ HOME    │ /home/kinnar                        │
│ 2 │ PATH    │ /usr/local/bin:/usr/bin:/bin        │
│ 3 │ SHELL   │ /usr/bin/nushell                    │
│ 4 │ PWD     │ /home/kinnar/projects               │
└───┴─────────┴─────────────────────────────────────┘
```

#### 🔧 Variables d'environnement courantes

```sh
# Informations système
$env.OS                    # Système d'exploitation
$env.ARCH                  # Architecture (x86_64, arm64, etc.)
$env.PWD                   # Répertoire courant
$env.HOME                  # Répertoire utilisateur

# Configuration shell
$env.SHELL                 # Shell utilisé
$env.PATH                  # Chemins d'exécution
$env.EDITOR                # Éditeur par défaut

# Informations utilisateur
$env.USER                  # Nom d'utilisateur
$env.USERNAME              # Nom d'utilisateur (Windows)
$env.USERPROFILE           # Profil utilisateur (Windows)
```

#### 🔧 Utilisation dans les pipelines

```sh
# Utiliser les variables d'environnement dans des calculs
$env.HOME | path join "Documents" "projets"

# Filtrer les variables d'environnement
$env | transpose key value | where key =~ "PATH"

# Compter les variables d'environnement
$env | transpose key value | length
```

```sh
/home/kinnar/Documents/projets
```

> Les variables d'environnement sont accessibles via `$env` et peuvent être utilisées dans tous les pipelines NuShell.
