# NuShell

## Quick tour pratique

En NuShell, *presque* toutes les commandes retournent un tableau structuré. Ce tableau peut alors être manipulé pour en extraire des informations.

### Les tableaux en mémoire

#### Exécuter une commande de base

```sh
ls
```

```sh
╭───┬──────────────────────┬──────┬─────────┬──────────────╮
│ # │         name         │ type │  size   │   modified   │
├───┼──────────────────────┼──────┼─────────┼──────────────┤
│ 0 │ nushell-practical.md │ file │ 10,6 kB │ a minute ago │
│ 1 │ sql-server-iris.nu   │ file │  2,2 kB │ a day ago    │
╰───┴──────────────────────┴──────┴─────────┴──────────────╯
```

#### Connaître les colonnes d'un objet en mémoire

```sh
ls | columns
```

```sh
╭───┬──────────╮
│ 0 │ name     │
│ 1 │ type     │
│ 2 │ size     │
│ 3 │ modified │
╰───┴──────────╯
```

> Les commandes qui accèdent au système de fichiers sont héritées du bash: ```ls```, ```cp```, ```mv```, ```rm```...
L'opérateur ```columns``` reçoit un tableau et retourne la liste des colonnes qu'il contient

#### Lister les fichiers et filtrer par le nom

```sh
ls | where name =~ ini
```

```sh
╭───┬───────────────┬──────┬────────┬──────────────╮
│ # │     name      │ type │  size  │   modified   │
├───┼───────────────┼──────┼────────┼──────────────┤
│ 0 │ .gemini       │ dir  │ 4,0 kB │ 2 weeks ago  │
│ 1 │ mercurial.ini │ file │   74 B │ 3 months ago │
╰───┴───────────────┴──────┴────────┴──────────────╯
```

> L'opérateur ```=~``` signifie *contient*, contrairement à ```==``` qui représent l'égalité stricte.

#### Lister les fichiers modifiés récemment

```sh
ls | where modified > ((date now) - 7day) | sort-by modified --reverse
```

```sh
╭────┬──────────────────────────┬──────┬─────────┬─────────────╮
│  # │           name           │ type │  size   │  modified   │
├────┼──────────────────────────┼──────┼─────────┼─────────────┤
│  0 │ .python_history          │ file │    12 B │ 3 hours ago │
│  1 │ Downloads                │ dir  │ 40,9 kB │ 3 hours ago │
│  2 │ iCloudDrive              │ dir  │  4,0 kB │ 4 hours ago │
│  3 │ SynologyDrive            │ dir  │  4,0 kB │ 4 hours ago │
│  4 │ OneDrive - Iris Group    │ dir  │  8,1 kB │ 5 hours ago │
│  5 │ .config                  │ dir  │  4,0 kB │ 5 hours ago │
│  6 │ .luarc.json              │ file │    37 B │ a day ago   │
│  7 │ .gk                      │ dir  │     0 B │ a day ago   │
│  8 │ .cargo                   │ dir  │  4,0 kB │ a day ago   │
│  9 │ _lesshst                 │ file │    37 B │ 2 days ago  │
│ 10 │ .git-for-windows-updater │ file │    53 B │ 4 days ago  │
│ 11 │ source                   │ dir  │  4,0 kB │ 6 days ago  │
│ 12 │ nohup.out                │ file │     0 B │ a week ago  │
╰────┴──────────────────────────┴──────┴─────────┴─────────────╯
```

#### Trouver les processus gourmands en CPU

```sh
ps | where cpu > 10 | sort-by cpu -r | select name cpu mem
```

```sh
╭───┬─────────────────────────┬────────┬─────────╮
│ # │          name           │  cpu   │   mem   │
├───┼─────────────────────────┼────────┼─────────┤
│ 0 │ lua-language-server.exe │ 104.46 │ 10,6 GB │
│ 1 │ nu.exe                  │  29.38 │ 36,5 MB │
╰───┴─────────────────────────┴────────┴─────────╯
```

> ```sort-by ... --reverse``` est équivalent à ```sort-by ... -r```
>
#### Afficher l’espace disque par dossier

```sh
du | where physical > 1gb | sort-by physical -r | first 5
```

```sh
╭───┬───────────────────────────────┬──────────┬──────────╮
│ # │             path              │ apparent │ physical │
├───┼───────────────────────────────┼──────────┼──────────┤
│ 0 │ D:\Users\kinnar\AppData       │  67,2 GB │  66,1 GB │
│ 1 │ D:\Users\kinnar\.cursor       │   3,6 GB │   3,6 GB │
│ 2 │ D:\Users\kinnar\source        │   3,6 GB │   3,6 GB │
│ 3 │ D:\Users\kinnar\go            │   1,4 GB │   1,4 GB │
│ 4 │ D:\Users\kinnar\SynologyDrive │  56,8 GB │   1,1 GB │
╰───┴───────────────────────────────┴──────────┴──────────╯
```

> ```first x``` ne conserve que les *x* premières lignes d'un tableau.

#### Compter les fichiers par extension

NuShell dispose de nombreuses commandes puissantes pour gérer les données.

```sh
(ls | where type == "file"
    | get name
    | parse "{name}.{ext}"
    | group-by ext
    | transpose ext files
    | each { |it| { extension: $it.ext, count: ($it.files | length) } }
    | sort-by count -r)
```

> Mettre un commande entre ```()``` permet de définir un bloc, l'interpréteur sait alors qu'il doit attendre la fin du bloc pour évaluer celui-ci.
> ```ls | where type == "file"``` liste les fichiers (uniquement)
> ```| get name``` récupère la colonne ```name```
> ```| parse "{name}.{ext}"``` décompose chaque valeur en ```name.ext```
> ```| group-by ext``` groupe les lignes par extension (remarque, on a alors un arbre en mémoire, plus un tableau)
> ```| transpose ext files``` transforme le retour de group-by et nomme les deux colonnes ```ext``` et ```files``` (chaque ligne de la colonne ```files``` est alors elle -même un tableau de noms de fichiers)
> ```| each { |it| { extension: $it.ext, count: ($it.files | length) } }```, crée un tableau à deux colonnes, ```extension``` et ```count```, pour lequel la valeur ```count``` est le nombre de lignes dans ```files```.
> ```| sort-by count -r)``` trie le tableau final par ```count```, en *reverse*.

#### Trouver les ports actuellement ouverts

Parfois, malheureusement, certaines commandes ne retournent pas directement un tableau utilisable. Par exemple, *netstat* sous Windows :

- En-tête de 4 lignes
- Valeurs alignées avec espace, mais avec des colonnes manquantes

On peut tout de même manipuler les données pour en créer un tableau

```sh
# On ne garde que les lignes TCP, qui ont 5 colonnes
let tcp_data = (
    netstat -an 
    | decode
    | lines 
    | skip 4 
    | where {|it| $it | str starts-with "  TCP"} 
    | str trim 
    | split column " " --collapse-empty 
    | rename proto local foreign state pid
)

# On ne garde que les lignes UDP...
let udp_data_incomplete = (
    netstat -an 
    | decode
    | lines 
    | skip 4 
    | where {|it| $it | str starts-with "  UDP"} 
    | str trim 
    | split column " " --collapse-empty 
    | rename proto local foreign pid
)

# On ajoute la colonne 'state' manquante au tableau UDP
let udp_data = ($udp_data_incomplete | insert state "")

# Et maintenant, on peut tout simplement les ajouter l'un à la suite de l'autre
let net_data = $tcp_data | append $udp_data
```

> Explication de la commande :
> ```let tcp_data = (```
> ```netstat -an``` exécute la commande Windows
> ```| decode``` converti le résultat en utf-8
> ```| lines``` récupère le résultat ligne par ligne
> ```| skip 4```  passe les 4 premières lignes
> ```| where {|it| $it | str starts-with "  TCP"}``` ne garde que les lignes qui commencent par ```TCP```
> ```| str trim``` supprime les espaces en début et en fin de ligne
> ```| split column " " --collapse-empty``` crée des colonnes en considérant ```" "``` comme séparateur
> ```| rename proto local foreign state pid``` donne un nom lisible aux colonnes
> ```)```

```sh
$net_data | where local =~ 127.0.0.1 and foreign =~ 127.0.0.1
```

```sh
╭────┬───────┬─────────────────┬─────────────────┬─────────────╮
│  # │ proto │      local      │     foreign     │    state    │
├────┼───────┼─────────────────┼─────────────────┼─────────────┤
│  0 │ TCP   │ 127.0.0.1:49679 │ 127.0.0.1:49680 │ ESTABLISHED │
│  1 │ TCP   │ 127.0.0.1:49808 │ 127.0.0.1:49807 │ ESTABLISHED │
│  2 │ TCP   │ 127.0.0.1:49811 │ 127.0.0.1:49812 │ ESTABLISHED │
│  3 │ TCP   │ 127.0.0.1:49816 │ 127.0.0.1:49817 │ ESTABLISHED │
│  4 │ TCP   │ 127.0.0.1:49817 │ 127.0.0.1:49816 │ ESTABLISHED │
│  5 │ TCP   │ 127.0.0.1:53542 │ 127.0.0.1:53541 │ SYN_SENT    │
│  6 │ TCP   │ 127.0.0.1:53544 │ 127.0.0.1:53543 │ SYN_SENT    │
│  7 │ TCP   │ 127.0.0.1:53545 │ 127.0.0.1:8124  │ SYN_SENT    │
│  8 │ UDP   │ 127.0.0.1:49664 │ 127.0.0.1:49664 │             │
│  9 │ UDP   │ 127.0.0.1:51049 │ 127.0.0.1:51050 │             │
│ 10 │ UDP   │ 127.0.0.1:51050 │ 127.0.0.1:51049 │             │
│ 11 │ UDP   │ 127.0.0.1:52641 │ 127.0.0.1:52641 │             │
│ 12 │ UDP   │ 127.0.0.1:54699 │ 127.0.0.1:54700 │             │
│ 13 │ UDP   │ 127.0.0.1:54700 │ 127.0.0.1:54699 │             │
│ 14 │ UDP   │ 127.0.0.1:59043 │ 127.0.0.1:59044 │             │
│ 15 │ UDP   │ 127.0.0.1:59044 │ 127.0.0.1:59043 │             │
│ 16 │ UDP   │ 127.0.0.1:63438 │ 127.0.0.1:63438 │             │
│ 17 │ UDP   │ 127.0.0.1:64174 │ 127.0.0.1:64175 │             │
│ 18 │ UDP   │ 127.0.0.1:64175 │ 127.0.0.1:64174 │             │
╰────┴───────┴─────────────────┴─────────────────┴─────────────╯
```
