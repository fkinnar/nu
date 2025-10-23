﻿### ðŸŒ Variables d'environnement

NuShell gÃ¨re les variables d'environnement de maniÃ¨re structurÃ©e et puissante.

#### ðŸ”¹AccÃ©der aux variables d'environnement

```sh
# AccÃ¨s direct aux variables
$env.USER
$env.HOME
$env.PATH

# Lister toutes les variables d'environnement
$env | transpose key value | first 5
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚   key   â”‚                value                â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ USER    â”‚ kinnar                              â”‚
â”‚ 1 â”‚ HOME    â”‚ /home/kinnar                        â”‚
â”‚ 2 â”‚ PATH    â”‚ /usr/local/bin:/usr/bin:/bin        â”‚
â”‚ 3 â”‚ SHELL   â”‚ /usr/bin/nushell                    â”‚
â”‚ 4 â”‚ PWD     â”‚ /home/kinnar/projects               â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Variables d'environnement courantes

```sh
# Informations systÃ¨me
$env.OS                    # SystÃ¨me d'exploitation
$env.ARCH                  # Architecture (x86_64, arm64, etc.)
$env.PWD                   # RÃ©pertoire courant
$env.HOME                  # RÃ©pertoire utilisateur

# Configuration shell
$env.SHELL                 # Shell utilisÃ©
$env.PATH                  # Chemins d'exÃ©cution
$env.EDITOR                # Ã‰diteur par dÃ©faut

# Informations utilisateur
$env.USER                  # Nom d'utilisateur
$env.USERNAME              # Nom d'utilisateur (Windows)
$env.USERPROFILE           # Profil utilisateur (Windows)
```

#### ðŸ”¹Utilisation dans les pipelines

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

> Les variables d'environnement sont accessibles via `$env` et peuvent Ãªtre utilisÃ©es dans tous les pipelines NuShell.
