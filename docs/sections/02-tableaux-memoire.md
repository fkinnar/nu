### ðŸ”¢ Les tableaux en mÃ©moire

#### ðŸ”¹ExÃ©cuter une commande de base

```sh
ls
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚         name         â”‚ type â”‚  size   â”‚   modified   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ nushell-practical.md â”‚ file â”‚ 10,6 kB â”‚ a minute ago â”‚
â”‚ 1 â”‚ sql-server-iris.nu   â”‚ file â”‚  2,2 kB â”‚ a day ago    â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹ConnaÃ®tre les colonnes d'un objet en mÃ©moire

```sh
ls | columns
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ 0 â”‚ name     â”‚
â”‚ 1 â”‚ type     â”‚
â”‚ 2 â”‚ size     â”‚
â”‚ 3 â”‚ modified â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹ConnaÃ®tre la taille d'un tableau

```sh
ls | length
```

```sh
2
```

> Les commandes qui accÃ¨dent au systÃ¨me de fichiers sont hÃ©ritÃ©es du bash: ``ls``, ``cp``, ``mv``, ``rm``...
> L'opÃ©rateur ``columns`` reÃ§oit un tableau et retourne la liste des colonnes qu'il contient.

#### ðŸ”¹Lister les fichiers et filtrer par le nom

```sh
ls | where name =~ ini
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚     name      â”‚ type â”‚  size  â”‚   modified   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ .gemini       â”‚ dir  â”‚ 4,0 kB â”‚ 2 weeks ago  â”‚
â”‚ 1 â”‚ mercurial.ini â”‚ file â”‚   74 B â”‚ 3 months ago â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

> L'opÃ©rateur ``=~`` signifie *contient*, contrairement Ã  ``==`` qui reprÃ©sent l'Ã©galitÃ© stricte.

#### ðŸ”¹Lister les fichiers modifiÃ©s rÃ©cemment

```sh
ls | where modified > ((date now) - 7day) | sort-by modified --reverse
```

```sh
â•­â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚  # â”‚           name           â”‚ type â”‚  size   â”‚  modified   â”‚
â”œâ”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  0 â”‚ .python_history          â”‚ file â”‚    12 B â”‚ 3 hours ago â”‚
â”‚  1 â”‚ Downloads                â”‚ dir  â”‚ 40,9 kB â”‚ 3 hours ago â”‚
â”‚  2 â”‚ iCloudDrive              â”‚ dir  â”‚  4,0 kB â”‚ 4 hours ago â”‚
â”‚  3 â”‚ SynologyDrive            â”‚ dir  â”‚  4,0 kB â”‚ 4 hours ago â”‚
â”‚  4 â”‚ OneDrive - Iris Group    â”‚ dir  â”‚  8,1 kB â”‚ 5 hours ago â”‚
â”‚  5 â”‚ .config                  â”‚ dir  â”‚  4,0 kB â”‚ 5 hours ago â”‚
â”‚  6 â”‚ .luarc.json              â”‚ file â”‚    37 B â”‚ a day ago   â”‚
â”‚  7 â”‚ .gk                      â”‚ dir  â”‚     0 B â”‚ a day ago   â”‚
â”‚  8 â”‚ .cargo                   â”‚ dir  â”‚  4,0 kB â”‚ a day ago   â”‚
â”‚  9 â”‚ _lesshst                 â”‚ file â”‚    37 B â”‚ 2 days ago  â”‚
â”‚ 10 â”‚ .git-for-windows-updater â”‚ file â”‚    53 B â”‚ 4 days ago  â”‚
â”‚ 11 â”‚ source                   â”‚ dir  â”‚  4,0 kB â”‚ 6 days ago  â”‚
â”‚ 12 â”‚ nohup.out                â”‚ file â”‚     0 B â”‚ a week ago  â”‚
â•°â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Trouver les processus gourmands en CPU

```sh
ps | where cpu > 10 | sort-by cpu -r | select name cpu mem
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚          name           â”‚  cpu   â”‚   mem   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ lua-language-server.exe â”‚ 104.46 â”‚ 10,6 GB â”‚
â”‚ 1 â”‚ nu.exe                  â”‚  29.38 â”‚ 36,5 MB â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

> ``sort-by ... --reverse`` est Ã©quivalent Ã  ``sort-by ... -r``

#### ðŸ”¹Afficher lâ€™espace disque par dossier

```sh
du | where physical > 1gb | sort-by physical -r | first 5
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚             path              â”‚ apparent â”‚ physical â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ D:\Users\kinnar\AppData       â”‚  67,2 GB â”‚  66,1 GB â”‚
â”‚ 1 â”‚ D:\Users\kinnar\.cursor       â”‚   3,6 GB â”‚   3,6 GB â”‚
â”‚ 2 â”‚ D:\Users\kinnar\source        â”‚   3,6 GB â”‚   3,6 GB â”‚
â”‚ 3 â”‚ D:\Users\kinnar\go            â”‚   1,4 GB â”‚   1,4 GB â”‚
â”‚ 4 â”‚ D:\Users\kinnar\SynologyDrive â”‚  56,8 GB â”‚   1,1 GB â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

> ``first x`` ne conserve que les *x* premiÃ¨res lignes d'un tableau.

#### ðŸ”¹Compter les fichiers par extension

NuShell dispose de nombreuses commandes puissantes pour gÃ©rer les donnÃ©es.

```sh
(ls | where type == "file"
    | get name
    | parse "{name}.{ext}"
    | group-by ext
    | transpose ext files
    | each { |it| { extension: $it.ext, count: ($it.files | length) } }
    | sort-by count -r)
```

> Mettre un commande entre ``()`` permet de dÃ©finir un bloc, l'interprÃ©teur sait alors qu'il doit attendre la fin du bloc pour Ã©valuer celui-ci.
> ``ls | where type == "file"`` liste les fichiers (uniquement).
> ``| get name`` rÃ©cupÃ¨re la colonne ``name``.
> ``| parse "{name}.{ext}"`` dÃ©compose chaque valeur en ``name.ext``.
> ``| group-by ext`` groupe les lignes par extension (remarque, on a alors un arbre en mÃ©moire, plus un tableau).
> ``| transpose ext files`` transforme le retour de group-by en tableau et nomme les deux colonnes ``ext`` et ``files`` (chaque ligne de la colonne ``files`` est alors elle -mÃªme un tableau de noms de fichiers).
> ``| each { |it| { extension: $it.ext, count: ($it.files | length) } }``, crÃ©e un tableau Ã  deux colonnes, ``extension`` et ``count``, pour lequel la valeur ``count`` est le nombre de lignes dans ``files``.
> ``| sort-by count -r)`` trie le tableau final par ``count``, en *reverse*.

#### ðŸ”¹Trouver les ports actuellement ouverts

Parfois, malheureusement, certaines commandes ne retournent pas directement un tableau utilisable. Par exemple, *netstat* sous Windows :

- en-tÃªte de 4 lignes;
- valeurs alignÃ©es avec des espaces, mais avec des colonnes manquantes.

On peut tout de mÃªme manipuler les donnÃ©es pour en crÃ©er un tableau :

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

# Et maintenant, on peut tout simplement les ajouter l'un Ã  la suite de l'autre
let net_data = $tcp_data | append $udp_data
```

> Explication de la commande :
> ``let tcp_data = (``
> ``netstat -an`` exÃ©cute la commande Windows
> ``| decode`` converti le rÃ©sultat en utf-8
> ``| lines`` rÃ©cupÃ¨re le rÃ©sultat ligne par ligne
> ``| skip 4``  passe les 4 premiÃ¨res lignes
> ``| where {|it| $it | str starts-with "  TCP"}`` ne garde que les lignes qui commencent par ``TCP``
> ``| str trim`` supprime les espaces en dÃ©but et en fin de ligne
> ``| split column " " --collapse-empty`` crÃ©e des colonnes en considÃ©rant ``" "`` comme sÃ©parateur
> ``| rename proto local foreign state pid`` donne un nom lisible aux colonnes
> ``)``

```sh
$net_data | where local =~ 127.0.0.1 and foreign =~ 127.0.0.1
```

```sh
â•­â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚  # â”‚ proto â”‚      local      â”‚     foreign     â”‚    state    â”‚
â”œâ”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  0 â”‚ TCP   â”‚ 127.0.0.1:49679 â”‚ 127.0.0.1:49680 â”‚ ESTABLISHED â”‚
â”‚  1 â”‚ TCP   â”‚ 127.0.0.1:49808 â”‚ 127.0.0.1:49807 â”‚ ESTABLISHED â”‚
â”‚  2 â”‚ TCP   â”‚ 127.0.0.1:49811 â”‚ 127.0.0.1:49812 â”‚ ESTABLISHED â”‚
â”‚  3 â”‚ TCP   â”‚ 127.0.0.1:49816 â”‚ 127.0.0.1:49817 â”‚ ESTABLISHED â”‚
â”‚  4 â”‚ TCP   â”‚ 127.0.0.1:49817 â”‚ 127.0.0.1:49816 â”‚ ESTABLISHED â”‚
â”‚  5 â”‚ TCP   â”‚ 127.0.0.1:53542 â”‚ 127.0.0.1:53541 â”‚ SYN_SENT    â”‚
â”‚  6 â”‚ TCP   â”‚ 127.0.0.1:53544 â”‚ 127.0.0.1:53543 â”‚ SYN_SENT    â”‚
â”‚  7 â”‚ TCP   â”‚ 127.0.0.1:53545 â”‚ 127.0.0.1:8124  â”‚ SYN_SENT    â”‚
â”‚  8 â”‚ UDP   â”‚ 127.0.0.1:49664 â”‚ 127.0.0.1:49664 â”‚             â”‚
â”‚  9 â”‚ UDP   â”‚ 127.0.0.1:51049 â”‚ 127.0.0.1:51050 â”‚             â”‚
â”‚ 10 â”‚ UDP   â”‚ 127.0.0.1:51050 â”‚ 127.0.0.1:51049 â”‚             â”‚
â”‚ 11 â”‚ UDP   â”‚ 127.0.0.1:52641 â”‚ 127.0.0.1:52641 â”‚             â”‚
â”‚ 12 â”‚ UDP   â”‚ 127.0.0.1:54699 â”‚ 127.0.0.1:54700 â”‚             â”‚
â”‚ 13 â”‚ UDP   â”‚ 127.0.0.1:54700 â”‚ 127.0.0.1:54699 â”‚             â”‚
â”‚ 14 â”‚ UDP   â”‚ 127.0.0.1:59043 â”‚ 127.0.0.1:59044 â”‚             â”‚
â”‚ 15 â”‚ UDP   â”‚ 127.0.0.1:59044 â”‚ 127.0.0.1:59043 â”‚             â”‚
â”‚ 16 â”‚ UDP   â”‚ 127.0.0.1:63438 â”‚ 127.0.0.1:63438 â”‚             â”‚
â”‚ 17 â”‚ UDP   â”‚ 127.0.0.1:64174 â”‚ 127.0.0.1:64175 â”‚             â”‚
â”‚ 18 â”‚ UDP   â”‚ 127.0.0.1:64175 â”‚ 127.0.0.1:64174 â”‚             â”‚
â•°â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Quelques commandes utiles

``first <n>``, pour extraire les *n* premiÃ¨res lignes d'un tableau

```sh
ls | first
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ name     â”‚ .aitk        â”‚
â”‚ type     â”‚ dir          â”‚
â”‚ size     â”‚ 4,0 kB       â”‚
â”‚ modified â”‚ 4 months ago â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
ls | first 5
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚     name      â”‚ type â”‚  size  â”‚   modified   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ .aitk         â”‚ dir  â”‚ 4,0 kB â”‚ 4 months ago â”‚
â”‚ 1 â”‚ .atom         â”‚ dir  â”‚ 4,0 kB â”‚ 8 months ago â”‚
â”‚ 2 â”‚ .aws          â”‚ dir  â”‚    0 B â”‚ 8 months ago â”‚
â”‚ 3 â”‚ .azure        â”‚ dir  â”‚    0 B â”‚ 8 months ago â”‚
â”‚ 4 â”‚ .bash_history â”‚ file â”‚  698 B â”‚ 3 weeks ago  â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

``last <n>``, pour extraire les *n* derniÃ¨res lignes d'un tableau

```sh
ls | last
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ name     â”‚ source     â”‚
â”‚ type     â”‚ dir        â”‚
â”‚ size     â”‚ 4,0 kB     â”‚
â”‚ modified â”‚ a week ago â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
ls | last 5
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚     name      â”‚ type â”‚  size  â”‚   modified    â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ lpm           â”‚ dir  â”‚    0 B â”‚ a month ago   â”‚
â”‚ 1 â”‚ mercurial.ini â”‚ file â”‚   74 B â”‚ 3 months ago  â”‚
â”‚ 2 â”‚ mulesoft      â”‚ dir  â”‚ 4,0 kB â”‚ 10 months ago â”‚
â”‚ 3 â”‚ scoop         â”‚ dir  â”‚    0 B â”‚ a year ago    â”‚
â”‚ 4 â”‚ source        â”‚ dir  â”‚ 4,0 kB â”‚ a week ago    â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

``transpose``

- pour transposer un tableau

```sh
ls | first 3 | transpose
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚ column0  â”‚   column1    â”‚   column2    â”‚   column3    â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ name     â”‚ .aitk        â”‚ .atom        â”‚ .aws         â”‚
â”‚ 1 â”‚ type     â”‚ dir          â”‚ dir          â”‚ dir          â”‚
â”‚ 2 â”‚ size     â”‚       4,0 kB â”‚       4,0 kB â”‚          0 B â”‚
â”‚ 3 â”‚ modified â”‚ 4 months ago â”‚ 8 months ago â”‚ 8 months ago â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

- pour transformer une structure en tableau

Si on regarde ce que retourne ``ls | first``, on voit que ce n'est pas un tableau (les colonnes n'ont pas de nom). Pour remÃ©dier Ã  cela, on peut utiliser ``transpose``.

```sh
ls | first | transpose
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚ column0  â”‚   column1    â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ name     â”‚ .aitk        â”‚
â”‚ 1 â”‚ type     â”‚ dir          â”‚
â”‚ 2 â”‚ size     â”‚       4,0 kB â”‚
â”‚ 3 â”‚ modified â”‚ 4 months ago â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

On peut aussi donner un nom plus explicite au colonnes.

```sh
ls | first | transpose nom extension
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚   nom    â”‚  extension   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ name     â”‚ .aitk        â”‚
â”‚ 1 â”‚ type     â”‚ dir          â”‚
â”‚ 2 â”‚ size     â”‚       4,0 kB â”‚
â”‚ 3 â”‚ modified â”‚ 4 months ago â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

Cas d'usage de ``transpose`` : afficher les variables d'environnement filtrÃ©es selon un critÃ¨re.

```sh
$env | transpose clÃ© valeur | where clÃ© =~ '(?i)term'
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚          clÃ©           â”‚                       valeur                        â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ COLORTERM              â”‚ truecolor                                           â”‚
â”‚ 1 â”‚ TERM                   â”‚ xterm-256color                                      â”‚
â”‚ 2 â”‚ TERM_PROGRAM           â”‚ WezTerm                                             â”‚
â”‚ 3 â”‚ TERM_PROGRAM_VERSION   â”‚ 20251005-110037-db5d7437                            â”‚
â”‚ 4 â”‚ WEZTERM_CONFIG_DIR     â”‚ D:\Users\kinnar\.config\wezterm                     â”‚
â”‚ 5 â”‚ WEZTERM_CONFIG_FILE    â”‚ D:\Users\kinnar\.config\wezterm\wezterm.lua         â”‚
â”‚ 6 â”‚ WEZTERM_EXECUTABLE     â”‚ C:\Program Files\WezTerm\wezterm-gui.exe            â”‚
â”‚ 7 â”‚ WEZTERM_EXECUTABLE_DIR â”‚ C:\Program Files\WezTerm                            â”‚
â”‚ 8 â”‚ WEZTERM_PANE           â”‚ 1                                                   â”‚
â”‚ 9 â”‚ WEZTERM_UNIX_SOCKET    â”‚ D:\Users\kinnar\.local/share/wezterm\gui-sock-40160 â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```
