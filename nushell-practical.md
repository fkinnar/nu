# NuShell

## Quick tour pratique

En NuShell, *presque* toutes les commandes retournent un tableau structuré. Ce tableau peut alors être manipulé pour en extraire des informations.

> 🌐 [https://www.nushell.sh/](https://www.nushell.sh/)

### 🔢 Les tableaux en mémoire

#### 🔹Exécuter une commande de base

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

#### 🔹Connaître les colonnes d'un objet en mémoire

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

#### 🔹Connaître la taille d'un tableau

```sh
ls | length
```

```sh
2
```

> Les commandes qui accèdent au système de fichiers sont héritées du bash: ``ls``, ``cp``, ``mv``, ``rm``...
> L'opérateur ``columns`` reçoit un tableau et retourne la liste des colonnes qu'il contient.

#### 🔹Lister les fichiers et filtrer par le nom

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

> L'opérateur ``=~`` signifie *contient*, contrairement à ``==`` qui représent l'égalité stricte.

#### 🔹Lister les fichiers modifiés récemment

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

#### 🔹Trouver les processus gourmands en CPU

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

> ``sort-by ... --reverse`` est équivalent à ``sort-by ... -r``

#### 🔹Afficher l’espace disque par dossier

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

> ``first x`` ne conserve que les *x* premières lignes d'un tableau.

#### 🔹Compter les fichiers par extension

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

> Mettre un commande entre ``()`` permet de définir un bloc, l'interpréteur sait alors qu'il doit attendre la fin du bloc pour évaluer celui-ci.
> ``ls | where type == "file"`` liste les fichiers (uniquement).
> ``| get name`` récupère la colonne ``name``.
> ``| parse "{name}.{ext}"`` décompose chaque valeur en ``name.ext``.
> ``| group-by ext`` groupe les lignes par extension (remarque, on a alors un arbre en mémoire, plus un tableau).
> ``| transpose ext files`` transforme le retour de group-by en tableau et nomme les deux colonnes ``ext`` et ``files`` (chaque ligne de la colonne ``files`` est alors elle -même un tableau de noms de fichiers).
> ``| each { |it| { extension: $it.ext, count: ($it.files | length) } }``, crée un tableau à deux colonnes, ``extension`` et ``count``, pour lequel la valeur ``count`` est le nombre de lignes dans ``files``.
> ``| sort-by count -r)`` trie le tableau final par ``count``, en *reverse*.

#### 🔹Trouver les ports actuellement ouverts

Parfois, malheureusement, certaines commandes ne retournent pas directement un tableau utilisable. Par exemple, *netstat* sous Windows :

- en-tête de 4 lignes;
- valeurs alignées avec des espaces, mais avec des colonnes manquantes.

On peut tout de même manipuler les données pour en créer un tableau :

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
> ``let tcp_data = (``
> ``netstat -an`` exécute la commande Windows
> ``| decode`` converti le résultat en utf-8
> ``| lines`` récupère le résultat ligne par ligne
> ``| skip 4``  passe les 4 premières lignes
> ``| where {|it| $it | str starts-with "  TCP"}`` ne garde que les lignes qui commencent par ``TCP``
> ``| str trim`` supprime les espaces en début et en fin de ligne
> ``| split column " " --collapse-empty`` crée des colonnes en considérant ``" "`` comme séparateur
> ``| rename proto local foreign state pid`` donne un nom lisible aux colonnes
> ``)``

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

#### 🔹Quelques commandes utiles

```first <n>```, pour extraire les *n* premières lignes d'un tableau

```sh
ls | first
```
```sh
╭──────────┬──────────────╮
│ name     │ .aitk        │
│ type     │ dir          │
│ size     │ 4,0 kB       │
│ modified │ 4 months ago │
╰──────────┴──────────────╯
```

```sh
ls | first 5
```
```sh
╭───┬───────────────┬──────┬────────┬──────────────╮
│ # │     name      │ type │  size  │   modified   │
├───┼───────────────┼──────┼────────┼──────────────┤
│ 0 │ .aitk         │ dir  │ 4,0 kB │ 4 months ago │
│ 1 │ .atom         │ dir  │ 4,0 kB │ 8 months ago │
│ 2 │ .aws          │ dir  │    0 B │ 8 months ago │
│ 3 │ .azure        │ dir  │    0 B │ 8 months ago │
│ 4 │ .bash_history │ file │  698 B │ 3 weeks ago  │
╰───┴───────────────┴──────┴────────┴──────────────╯
```

```last <n>```, pour extraire les *n* dernières lignes d'un tableau

```sh
ls | last
```
```sh
╭──────────┬────────────╮
│ name     │ source     │
│ type     │ dir        │
│ size     │ 4,0 kB     │
│ modified │ a week ago │
╰──────────┴────────────╯
```

```sh
ls | last 5
```
```sh
╭───┬───────────────┬──────┬────────┬───────────────╮
│ # │     name      │ type │  size  │   modified    │
├───┼───────────────┼──────┼────────┼───────────────┤
│ 0 │ lpm           │ dir  │    0 B │ a month ago   │
│ 1 │ mercurial.ini │ file │   74 B │ 3 months ago  │
│ 2 │ mulesoft      │ dir  │ 4,0 kB │ 10 months ago │
│ 3 │ scoop         │ dir  │    0 B │ a year ago    │
│ 4 │ source        │ dir  │ 4,0 kB │ a week ago    │
╰───┴───────────────┴──────┴────────┴───────────────╯
```

```transpose```

- pour transposer un tableau
```sh
ls | first 3 | transpose
```
```sh
╭───┬──────────┬──────────────┬──────────────┬──────────────╮
│ # │ column0  │   column1    │   column2    │   column3    │
├───┼──────────┼──────────────┼──────────────┼──────────────┤
│ 0 │ name     │ .aitk        │ .atom        │ .aws         │
│ 1 │ type     │ dir          │ dir          │ dir          │
│ 2 │ size     │       4,0 kB │       4,0 kB │          0 B │
│ 3 │ modified │ 4 months ago │ 8 months ago │ 8 months ago │
╰───┴──────────┴──────────────┴──────────────┴──────────────╯
```

- pour transformer une structure en tableau

Si on regarde ce que retourne ```ls | first```, on voit que ce n'est pas un tableau (les colonnes n'ont pas de nom). Pour remédier à cela, on peut utiliser ```transpose```.
```sh
ls | first | transpose
```
```sh
╭───┬──────────┬──────────────╮
│ # │ column0  │   column1    │
├───┼──────────┼──────────────┤
│ 0 │ name     │ .aitk        │
│ 1 │ type     │ dir          │
│ 2 │ size     │       4,0 kB │
│ 3 │ modified │ 4 months ago │
╰───┴──────────┴──────────────╯
```

On peut aussi donner un nom plus explicite au colonnes.
```sh $
ls | first | transpose nom extension
```
```sh
╭───┬──────────┬──────────────╮
│ # │   nom    │  extension   │
├───┼──────────┼──────────────┤
│ 0 │ name     │ .aitk        │
│ 1 │ type     │ dir          │
│ 2 │ size     │       4,0 kB │
│ 3 │ modified │ 4 months ago │
╰───┴──────────┴──────────────╯
```

Cas d'usage de ```transpose``` : afficher les variables d'environnement filtrées selon un critère.
```sh
$env | transpose clé valeur | where clé =~ '(?i)term'
```
```sh
╭───┬────────────────────────┬─────────────────────────────────────────────────────╮
│ # │          clé           │                       valeur                        │
├───┼────────────────────────┼─────────────────────────────────────────────────────┤
│ 0 │ COLORTERM              │ truecolor                                           │
│ 1 │ TERM                   │ xterm-256color                                      │
│ 2 │ TERM_PROGRAM           │ WezTerm                                             │
│ 3 │ TERM_PROGRAM_VERSION   │ 20251005-110037-db5d7437                            │
│ 4 │ WEZTERM_CONFIG_DIR     │ D:\Users\kinnar\.config\wezterm                     │
│ 5 │ WEZTERM_CONFIG_FILE    │ D:\Users\kinnar\.config\wezterm\wezterm.lua         │
│ 6 │ WEZTERM_EXECUTABLE     │ C:\Program Files\WezTerm\wezterm-gui.exe            │
│ 7 │ WEZTERM_EXECUTABLE_DIR │ C:\Program Files\WezTerm                            │
│ 8 │ WEZTERM_PANE           │ 1                                                   │
│ 9 │ WEZTERM_UNIX_SOCKET    │ D:\Users\kinnar\.local/share/wezterm\gui-sock-40160 │
╰───┴────────────────────────┴─────────────────────────────────────────────────────╯
```

### 📁 Ouvertures de fichiers

#### 🔹 Ouvrir un fichier texte

```sh
open examples\notes.txt
```

```sh
Ce fichier contient des notes diverses.
Chaque ligne représente une idée ou une remarque.
NuShell peut lire ce fichier avec 'open' et le transformer avec 'lines'.
```

#### 🔹 Lire un fichier texte ligne par ligne

```sh
open examples\notes.txt | lines | where $it =~ "NuShell
```

```sh
╭───┬──────────────────────────────────────────────────────────────────────────╮
│ 0 │ NuShell peut lire ce fichier avec 'open' et le transformer avec 'lines'. │
╰───┴──────────────────────────────────────────────────────────────────────────╯
```

#### 🔹Lire un fichier CSV

```sh
open examples\personnes.csv
```

```sh
╭───┬─────────┬─────┬───────────╮
│ # │   nom   │ age │   ville   │
├───┼─────────┼─────┼───────────┤
│ 0 │ Alice   │  30 │ Paris     │
│ 1 │ Bob     │  25 │ Lyon      │
│ 2 │ Charlie │  35 │ Marseille │
│ 3 │ Diane   │  28 │ Toulouse  │
╰───┴─────────┴─────┴───────────╯
```

#### 🔹Lire un fichier JSON

```sh
open examples\config.json
```

```sh
╭───────────────┬───────────────────╮
│ theme         │ sombre            │
│ langue        │ fr                │
│               │ ╭───────┬───────╮ │
│ notifications │ │ email │ true  │ │
│               │ │ sms   │ false │ │
│               │ ╰───────┴───────╯ │
│ version       │ 1.20              │
╰───────────────┴───────────────────╯
```

#### 🔹Extraire de l'information d'un fichier JSON

Un fichier JSON est représenté en mémoire sous forme d'un arbre.

```sh
open examples\employees.json | first
```

```sh
╭────────────┬───────────────────────────────────────────────────────────╮
│ id         │ d03113f3-e704-4d79-88bc-860584032064                      │
│            │ ╭────────────┬─────────────────────────────────╮          │
│ profile    │ │            │ ╭───────┬───────╮               │          │
│            │ │ name       │ │ first │ Hank  │               │          │
│            │ │            │ │ last  │ Brown │               │          │
│            │ │            │ ╰───────┴───────╯               │          │
│            │ │ email      │ eve.davis@example.com           │          │
│            │ │            │ ╭──────────┬──────────────────╮ │          │
│            │ │ department │ │ name     │ Engineering      │ │          │
│            │ │            │ │          │ ╭──────────┬───╮ │ │          │
│            │ │            │ │ location │ │ building │ A │ │ │          │
│            │ │            │ │          │ │ floor    │ 2 │ │ │          │
│            │ │            │ │          │ ╰──────────┴───╯ │ │          │
│            │ │            │ ╰──────────┴──────────────────╯ │          │
│            │ ╰────────────┴─────────────────────────────────╯          │
│            │ ╭───────────┬───────────────────────────────────────────╮ │
│ employment │ │ role      │ Developer                                 │ │
│            │ │ startDate │ 2025-09-20T15:03:53.877Z                  │ │
│            │ │           │ ╭────────────┬──────────────────────────╮ │ │
│            │ │ status    │ │ active     │ false                    │ │ │
│            │ │           │ │ lastReview │ 2025-10-07T14:12:06.508Z │ │ │
│            │ │           │ ╰────────────┴──────────────────────────╯ │ │
│            │ ╰───────────┴───────────────────────────────────────────╯ │
╰────────────┴───────────────────────────────────────────────────────────╯
```

Pour récupérer les clés possibles dans un fichier JSON, par niveau :

```sh
open examples\employees.json | columns
```

```sh
╭───┬────────────╮
│ 0 │ id         │
│ 1 │ profile    │
│ 2 │ employment │
╰───┴────────────╯
```

```sh
open examples\employees.json | get profile | columns
```

```sh
╭───┬────────────╮
│ 0 │ name       │
│ 1 │ email      │
│ 2 │ department │
╰───┴────────────╯
```

On peut évidemment filtrer les données :

```sh
open examples\employees.json | where id =~ d03113f3 | get profile | get email
```

```sh
╭───┬───────────────────────╮
│ 0 │ eve.davis@example.com │
╰───┴───────────────────────╯
```

Ou de manière plus compacte :

```sh
(open examples\employees.json | where id =~ d03113f3).profile.department.name
```

```sh
╭───┬─────────────╮
│ 0 │ Engineering │
╰───┴─────────────╯
```

Les filtres peuvent être plus complexes bien entendu.

```sh
open examples\utilisateurs.json | where rôle == "admin" and préférences.notifications.email == true
```

```sh
╭───┬────┬──────────────┬──────────────────────────┬───────┬─────╮
│ # │ id │     nom      │          email           │ actif │ ... │
├───┼────┼──────────────┼──────────────────────────┼───────┼─────┤
│ 0 │  1 │ Utilisateur1 │ utilisateur1@exemple.com │ true  │ ... │
╰───┴────┴──────────────┴──────────────────────────┴───────┴─────╯
```

Comme on n'a qu'une seule ligne dans le tableau, pour rendre l'affichage plus lisible, on peut utiliser ``transpose``.

```sh
open examples\utilisateurs.json | where rôle == "admin" and préférences.notifications.email == true | transpose
```

```sh
╭───┬─────────────┬──────────────────────────╮
│ # │   column0   │         column1          │
├───┼─────────────┼──────────────────────────┤
│ 0 │ id          │                        1 │
│ 1 │ nom         │ Utilisateur1             │
│ 2 │ email       │ utilisateur1@exemple.com │
│ 3 │ actif       │ true                     │
│ 4 │ rôle        │ admin                    │
│ 5 │ préférences │ {record 2 fields}        │
│ 6 │ historique  │ [table 3 rows]           │
╰───┴─────────────┴──────────────────────────╯
```

On aurait aussi pu utiliser ``first``, ``last`` ou ``get 0``, qui affichent une ligne de tableau sous forme de fiche.

```sh
open examples\utilisateurs.json | where rôle == "admin" and préférences.notifications.email == true | first
╭─────────────┬──────────────────────────╮
│ id          │ 1                        │
│ nom         │ Utilisateur1             │
│ email       │ utilisateur1@exemple.com │
│ actif       │ true                     │
│ rôle        │ admin                    │
│ préférences │ {record 2 fields}        │
│ historique  │ [table 3 rows]           │
╰─────────────┴──────────────────────────╯
```

```sh
 open examples\utilisateurs.json | each { |it| $it.historique.0.ip }
```

```sh
╭───┬───────────────╮
│ 0 │ 192.168.1.36  │
│ 1 │ 192.168.1.216 │
│ 2 │ 192.168.1.5   │
│ 3 │ 192.168.1.128 │
│ 4 │ 192.168.1.195 │
╰───┴───────────────╯
```

```sh
open examples/utilisateurs.json
| each { |it|
    {
        id: $it.id,
        nom: $it.nom,
        derniere_connexion: ($it.historique.0.date)
    }
}
```

```sh
╭───┬────┬──────────────┬─────────────────────╮
│ # │ id │     nom      │ derniere_connexion  │
├───┼────┼──────────────┼─────────────────────┤
│ 0 │  1 │ Utilisateur1 │ 2025-10-09 12:43:33 │
│ 1 │  2 │ Utilisateur2 │ 2025-10-09 12:43:33 │
│ 2 │  3 │ Utilisateur3 │ 2025-10-09 12:43:33 │
│ 3 │  4 │ Utilisateur4 │ 2025-10-09 12:43:33 │
│ 4 │  5 │ Utilisateur5 │ 2025-10-09 12:43:33 │
╰───┴────┴──────────────┴─────────────────────╯
```

#### 🔹Fichier JSON Lines

Certains fichiers JSON formatés **par lignes**, chacunes de leurs lignes sont, elles-mêmes, un JSON valide. De tels fichiers ne peuvent pas être ouverts directement par ``open``.

```sh
open examples/titanic-parquet.json
```

```sh
Error: nu::shell::error

  × Error while parsing as json
   ╭─[entry #37:1:6]
 1 │ open examples/titanic-parquet.json
   ·      ──────────────┬──────────────
   ·                    ╰── Could not parse '/Volumes/Work/src/nu/examples/titanic-parquet.json' with `from json`
   ╰────
  help: Check out `help from json` or `help from` for more options or open raw data with `open --raw '/Volumes/Work/src/
        nu/examples/titanic-parquet.json'`

Error:
  × Error while parsing JSON text
   ╭─[entry #37:1:1]
 1 │ open examples/titanic-parquet.json
   · ──┬─
   ·   ╰── error parsing JSON text
   ╰────

Error:
  × Error while parsing JSON text
   ╭─[2:1]
 1 │ {"PassengerId":"1","Survived":"0","Pclass":"3","Name":"Braund, Mr. Owen Harris","Sex":"male","Age":22,"SibSp":"1","Parch":"0","Ticket":"A\/5 21171","Fare":7.25,"Cabin":null,"Embarked":"S"}
 2 │ {"PassengerId":"2","Survived":"1","Pclass":"1","Name":"Cumings, Mrs. John Bradley (Florence Briggs Thayer)","Sex":"female","Age":38,"SibSp":"1","Parch":"0","Ticket":"PC 17599","Fare":71.2833,"Cabin":"C85","Embarked":"C"}
   · ▲
   · ╰── "trailing characters" at line 2 column 1
 3 │ {"PassengerId":"3","Survived":"1","Pclass":"3","Name":"Heikkinen, Miss. Laina","Sex":"female","Age":26,"SibSp":"0","Parch":"0","Ticket":"STON\/O2. 3101282","Fare":7.925,"Cabin":null,"Embarked":"S"}
   ╰────
```

Il faut alors explicitement expliquer à NuShell comment lire ce type de fichier.

```sh
open examples/titanic-parquet.json --raw | lines | each {|line| $line | from json }
```

```sh
╭─────┬─────────────┬──────────┬────────┬────────────────────────────────────────────────────────────────────────────┬─────╮
│   # │ PassengerId │ Survived │ Pclass │                                    Name                                    │ ... │
├─────┼─────────────┼──────────┼────────┼────────────────────────────────────────────────────────────────────────────┼─────┤
│   0 │ 1           │ 0        │ 3      │ Braund, Mr. Owen Harris                                                    │ ... │
│   1 │ 2           │ 1        │ 1      │ Cumings, Mrs. John Bradley (Florence Briggs Thayer)                        │ ... │
│   2 │ 3           │ 1        │ 3      │ Heikkinen, Miss. Laina                                                     │ ... │
│   3 │ 4           │ 1        │ 1      │ Futrelle, Mrs. Jacques Heath (Lily May Peel)                               │ ... │
│   4 │ 5           │ 0        │ 3      │ Allen, Mr. William Henry                                                   │ ... │
│   5 │ 6           │ 0        │ 3      │ Moran, Mr. James                                                           │ ... │
│   6 │ 7           │ 0        │ 1      │ McCarthy, Mr. Timothy J                                                    │ ... │
│   7 │ 8           │ 0        │ 3      │ Palsson, Master. Gosta Leonard                                             │ ... │

...

│ 886 │ 887         │ 0        │ 2      │ Montvila, Rev. Juozas                                                      │ ... │
│ 887 │ 888         │ 1        │ 1      │ Graham, Miss. Margaret Edith                                               │ ... │
│ 888 │ 889         │ 0        │ 3      │ Johnston, Miss. Catherine Helen "Carrie"                                   │ ... │
│ 889 │ 890         │ 1        │ 1      │ Behr, Mr. Karl Howell                                                      │ ... │
│ 890 │ 891         │ 0        │ 3      │ Dooley, Mr. Patrick                                                        │ ... │
├─────┼─────────────┼──────────┼────────┼────────────────────────────────────────────────────────────────────────────┼─────┤
│   # │ PassengerId │ Survived │ Pclass │                                    Name                                    │ ... │
╰─────┴─────────────┴──────────┴────────┴────────────────────────────────────────────────────────────────────────────┴─────╯
```

On peut utiliser la même commande pour convertir le fichier JSON lines en fichier JSON classique.

```sh
open examples/titanic-parquet.json --raw | lines | each {|line| $line | from json } | to json | save fix.json
```

Ce qui permet de l'ouvrir de la manière habituelle par la suite.

```sh
open fix.json
╭─────┬─────────────┬──────────┬────────┬────────────────────────────────────────────────────────────────────────────┬─────╮
│   # │ PassengerId │ Survived │ Pclass │                                    Name                                    │ ... │
├─────┼─────────────┼──────────┼────────┼────────────────────────────────────────────────────────────────────────────┼─────┤
│   0 │ 1           │ 0        │ 3      │ Braund, Mr. Owen Harris                                                    │ ... │
│   1 │ 2           │ 1        │ 1      │ Cumings, Mrs. John Bradley (Florence Briggs Thayer)                        │ ... │
│   2 │ 3           │ 1        │ 3      │ Heikkinen, Miss. Laina                                                     │ ... │
│   3 │ 4           │ 1        │ 1      │ Futrelle, Mrs. Jacques Heath (Lily May Peel)                               │ ... │
│   4 │ 5           │ 0        │ 3      │ Allen, Mr. William Henry                                                   │ ... │
│   5 │ 6           │ 0        │ 3      │ Moran, Mr. James                                                           │ ... │
│   6 │ 7           │ 0        │ 1      │ McCarthy, Mr. Timothy J                                                    │ ... │
│   7 │ 8           │ 0        │ 3      │ Palsson, Master. Gosta Leonard                                             │ ... │
│   8 │ 9           │ 1        │ 3      │ Johnson, Mrs. Oscar W (Elisabeth Vilhelmina Berg)                          │ ... │
│   9 │ 10          │ 1        │ 2      │ Nasser, Mrs. Nicholas (Adele Achem)                                        │ ... │
```

#### 🔹Lire un fichier Excel

```sh
open examples\ventes.xlsx
```

Ou en utilisant la commande ``from`` :

```sh
open --raw examples\ventes.xlsx | from xlsx
```

```sh
╭───────────┬────────────────────────────────────────╮
│           │ ╭───┬───────────┬─────────┬──────────╮ │
│ clients   │ │ # │  column0  │ column1 │ column2  │ │
│           │ ├───┼───────────┼─────────┼──────────┤ │
│           │ │ 0 │ id_client │ nom     │ pays     │ │
│           │ │ 1 │      1.00 │ Alice   │ France   │ │
│           │ │ 2 │      2.00 │ Bob     │ Belgique │ │
│           │ │ 3 │      3.00 │ Charlie │ Suisse   │ │
│           │ ╰───┴───────────┴─────────┴──────────╯ │
│           │ ╭───┬───────────┬─────────┬─────────╮  │
│ commandes │ │ # │  column0  │ column1 │ column2 │  │
│           │ ├───┼───────────┼─────────┼─────────┤  │
│           │ │ 0 │ id_client │ produit │ montant │  │
│           │ │ 1 │      1.00 │ Livre   │   20.50 │  │
│           │ │ 2 │      2.00 │ Stylo   │    5.00 │  │
│           │ │ 3 │      1.00 │ Clavier │   45.00 │  │
│           │ │ 4 │      3.00 │ Souris  │   25.00 │  │
│           │ ╰───┴───────────┴─────────┴─────────╯  │
╰───────────┴────────────────────────────────────────╯
```

Pour ouvrir une feuille de calcul en particulier :

```sh
open --raw examples\ventes.xlsx | from xlsx --sheets [commandes]
```

Ou :

```sh
open examples\ventes.xlsx | get commandes
```

```sh
╭───────────┬───────────────────────────────────────╮
│           │ ╭───┬───────────┬─────────┬─────────╮ │
│ commandes │ │ # │  column0  │ column1 │ column2 │ │
│           │ ├───┼───────────┼─────────┼─────────┤ │
│           │ │ 0 │ id_client │ produit │ montant │ │
│           │ │ 1 │      1.00 │ Livre   │   20.50 │ │
│           │ │ 2 │      2.00 │ Stylo   │    5.00 │ │
│           │ │ 3 │      1.00 │ Clavier │   45.00 │ │
│           │ │ 4 │      3.00 │ Souris  │   25.00 │ │
│           │ ╰───┴───────────┴─────────┴─────────╯ │
╰───────────┴───────────────────────────────────────╯
```

> Entre le ``[]``, on peut spécifier une liste de feuilles séparées par une ``,``.

Pour connaître la liste des feuilles disponibles dans un classeur.

```sh
open examples\ventes.xlsx | columns
```

```sh
╭───┬───────────╮
│ 0 │ clients   │
│ 1 │ commandes │
╰───┴───────────╯
```

### 🔄 Conversion entre formats

#### 🔹Sauver un fichier CSV

```sh
ls examples | to csv | save ls.csv
```

```sh
open --raw ls.csv

name,type,size,modified
examples\config.json,file,133 B,2025-10-09 11:31:02.033171500 +02:00
examples\notes.txt,file,168 B,2025-10-09 11:31:33.241767900 +02:00
examples\personnes.csv,file,87 B,2025-10-09 11:30:33.033195200 +02:00
examples\ventes.xlsx,file,"11,4 kB",2025-10-09 11:38:17.741472400 +02:00
```

#### 🔹Sauver un fichier JSON

```sh
ls examples | to json | save ls.json
```

```sh
open --raw ls.json

[
  {
    "name": "examples\\config.json",
    "type": "file",
    "size": 133,
    "modified": "2025-10-09 11:31:02.033171500 +02:00"
  },
  {
    "name": "examples\\notes.txt",
    "type": "file",
    "size": 168,
    "modified": "2025-10-09 11:31:33.241767900 +02:00"
  },
  {
    "name": "examples\\personnes.csv",
    "type": "file",
    "size": 87,
    "modified": "2025-10-09 11:30:33.033195200 +02:00"
  },
  {
    "name": "examples\\ventes.xlsx",
    "type": "file",
    "size": 11483,
    "modified": "2025-10-09 11:38:17.741472400 +02:00"
  }
]
```

#### 🔹Sauver un fichier texte

```sh
ls examples | to text | save ls.txt
```

```sh
open --raw ls.txt

name: examples\config.json
type: file
size: 133 B
modified: Thu, 9 Oct 2025 11:31:02 +0200 (an hour ago)
name: examples\notes.txt
type: file
size: 168 B
modified: Thu, 9 Oct 2025 11:31:33 +0200 (an hour ago)
name: examples\personnes.csv
type: file
size: 87 B
modified: Thu, 9 Oct 2025 11:30:33 +0200 (2 hours ago)
name: examples\ventes.xlsx
type: file
size: 11.483 kB
modified: Thu, 9 Oct 2025 11:38:17 +0200 (an hour ago)
```

#### 🔹Convertir un fichier

```sh
open examples\personnes.csv | to json | save personnes.json
```

```sh
open --raw personnes.json

[
  {
    "nom": "Alice",
    "age": 30,
    "ville": "Paris"
  },
  {
    "nom": "Bob",
    "age": 25,
    "ville": "Lyon"
  },
  {
    "nom": "Charlie",
    "age": 35,
    "ville": "Marseille"
  },
  {
    "nom": "Diane",
    "age": 28,
    "ville": "Toulouse"
  }
]
```

> NuShell prend en charge beaucoup d'autres formats : [https://www.nushell.sh/commands/docs/to.html](https://www.nushell.sh/commands/docs/to.html).

### 🔗 Jointures entre des tableaux en mémoire

#### 🔹Remarque propos des classeurs Excel

Le résultat de la commande ``open`` sur une feuille Excel ne donne pas directement un tableau, il est donc nécessaire de manipuler un peu les données.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients]

╭─────────┬────────────────────────────────────────╮
│         │ ╭───┬───────────┬─────────┬──────────╮ │
│ clients │ │ # │  column0  │ column1 │ column2  │ │
│         │ ├───┼───────────┼─────────┼──────────┤ │
│         │ │ 0 │ id_client │ nom     │ pays     │ │
│         │ │ 1 │      1.00 │ Alice   │ France   │ │
│         │ │ 2 │      2.00 │ Bob     │ Belgique │ │
│         │ │ 3 │      3.00 │ Charlie │ Suisse   │ │
│         │ ╰───┴───────────┴─────────┴──────────╯ │
╰─────────┴────────────────────────────────────────╯
```

Pour obtenir un tableau il faut donc récuper la valeur pour l'entrée ``clients``.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients

╭───┬───────────┬─────────┬──────────╮
│ # │  column0  │ column1 │ column2  │
├───┼───────────┼─────────┼──────────┤
│ 0 │ id_client │ nom     │ pays     │
│ 1 │      1.00 │ Alice   │ France   │
│ 2 │      2.00 │ Bob     │ Belgique │
│ 3 │      3.00 │ Charlie │ Suisse   │
╰───┴───────────┴─────────┴──────────╯
```

On a bien une table, mais les en-têtes de colonnes ne sont pas corrects. Il faut dire à NuShell que la première ligne est un titre et pas une donnée.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients | headers
╭───┬───────────┬─────────┬──────────╮
│ # │ id_client │   nom   │   pays   │
├───┼───────────┼─────────┼──────────┤
│ 0 │      1.00 │ Alice   │ France   │
│ 1 │      2.00 │ Bob     │ Belgique │
│ 2 │      3.00 │ Charlie │ Suisse   │
╰───┴───────────┴─────────┴──────────╯
```

#### 🔹Jointure entre des tableaux

```sh
let classeur = open ventes.xlsx
let clients = $classeur | get clients | headers
let commandes = $classeur | get commandes | headers
$commandes | join $clients id_client
```

```sh
╭───┬───────────┬─────────┬─────────┬─────────┬──────────╮
│ # │ id_client │ produit │ montant │   nom   │   pays   │
├───┼───────────┼─────────┼─────────┼─────────┼──────────┤
│ 0 │      1.00 │ Livre   │   20.50 │ Alice   │ France   │
│ 1 │      1.00 │ Clavier │   45.00 │ Alice   │ France   │
│ 2 │      2.00 │ Stylo   │    5.00 │ Bob     │ Belgique │
│ 3 │      3.00 │ Souris  │   25.00 │ Charlie │ Suisse   │
╰───┴───────────┴─────────┴─────────┴─────────┴──────────╯
```

#### 🔹Noms de colonnes différents

Quand les noms des colonnes de gauche et de droite ne sont pas les mêmes, la commande devient:

```sh
let users = open users.json
let persons = open persons.json

let data = $users | join $persons Id UserId
```

> NuShell supporte tous les types de jointures : [https://www.nushell.sh/commands/docs/join.html](https://www.nushell.sh/commands/docs/join.html). (--inner, --left, --right, --outer)

### ⚙️Intégration HTTP - API REST

NuShell intègre un module de connexion HTTP aux API REST. Ce dernier simplifie grandement l'intégration avec des telles API. Les données reçues étant stockées en mémoire de la même manière que le reste, on a accès à toute la puissance de NuShell pour les gérer. Ȧ ma connaissance, il n'existe pas de connecteur avec des API SOAP ou GraphQL.

#### 🔹GET

```sh
http get https://api.restful-api.dev/objects
```

```sh
╭────┬────┬───────────────────────────────────┬───────────────────╮
│  # │ id │               name                │       data        │
├────┼────┼───────────────────────────────────┼───────────────────┤
│  0 │ 1  │ Google Pixel 6 Pro                │ {record 2 fields} │
│  1 │ 2  │ Apple iPhone 12 Mini, 256GB, Blue │                   │
│  2 │ 3  │ Apple iPhone 12 Pro Max           │ {record 2 fields} │
│  3 │ 4  │ Apple iPhone 11, 64GB             │ {record 2 fields} │
│  4 │ 5  │ Samsung Galaxy Z Fold2            │ {record 2 fields} │
│  5 │ 6  │ Apple AirPods                     │ {record 2 fields} │
│  6 │ 7  │ Apple MacBook Pro 16              │ {record 4 fields} │
│  7 │ 8  │ Apple Watch Series 8              │ {record 2 fields} │
│  8 │ 9  │ Beats Studio3 Wireless            │ {record 2 fields} │
│  9 │ 10 │ Apple iPad Mini 5th Gen           │ {record 2 fields} │
│ 10 │ 11 │ Apple iPad Mini 5th Gen           │ {record 2 fields} │
│ 11 │ 12 │ Apple iPad Air                    │ {record 3 fields} │
│ 12 │ 13 │ Apple iPad Air                    │ {record 3 fields} │
╰────┴────┴───────────────────────────────────┴───────────────────╯
```

```sh
http get https://api.restful-api.dev/objects/7
```

```sh
╭──────┬──────────────────────╮
│ id   │ 7                    │
│ name │ Apple MacBook Pro 16 │
│ data │ {record 4 fields}    │
╰──────┴──────────────────────╯
```

> On peut aussi passer en paramètre ``user``, ``password``, ``headers``, ``max-time`` ou d'autres paramètres pour facilement obtenir les données qui nous intéressent.
> [https://www.nushell.sh/commands/docs/http_get.html](https://www.nushell.sh/commands/docs/http_get.html)

#### 🔹POST (et autres verbes)

```sh
let payload = {
    "name": "Apple MacBook Pro 16",
    "data": {
       "year": 2019,
       "price": 1849.99,
       "CPU model": "Intel Core i9",
       "Hard disk size": "1 TB"
    }
}
http post https://api.restful-api.dev/objects --content-type application/json $payload
```

```sh
╭───────────┬──────────────────────────────────╮
│ id        │ ff8081819782e69e0199ca14c2d807c2 │
│ name      │ Apple MacBook Pro 16             │
│ createdAt │ 2025-10-09T17:46:22.296+00:00    │
│ data      │ {record 4 fields}                │
╰───────────┴──────────────────────────────────╯
```

#### 🔹OAUTH2 (et autres autorisations)

> En combinant deux requêtes, une première pour obtenir le token, et une seconde pour effectuer la requête, et en utilisant le paramètre ``--headers`` pour passer le token, on peut simplement gérer l'autorisation.

1. Récupération du token

```sh
let response = (
    http post "https://www.n2f.com/services/api/v2/auth"
    --content-type "application/json" {
      "client_id": $env.N2F_CLIENT_ID,
      "client_secret": $env.N2F_CLIENT_SECRET
    }
)
let token = $response.response.token
```

> ``$env.N2F_CLIENT_ID`` et ``$env.N2F_CLIENT_SECRET`` sont supposés être défini dans l'environnement

1. Requête API

```sh
let companies = (
  http get "https://www.n2f.com/services/api/v2/companies" --headers {
    "Authorization": ("Bearer " + $token)
  }
)
```

```sh
╭───┬──────────────┬─────────────────────────┬─────────────────────────┬─────╮
│ # │     uuid     │          name           │         address         │ ... │
├───┼──────────────┼─────────────────────────┼─────────────────────────┼─────┤
│ 0 │ MzI5MjQ3Mw== │ IRIS FACILITY SOLUTIONS │ Avenue de Bâle 5, 1140  │ ... │
│   │              │                         │ Bruxelles, Belgique     │     │
│ 1 │ MzMxOTA2OA== │ IRIS GROUP              │ Avenue de Bâle 5, 1140  │ ... │
│   │              │                         │ Bruxelles, Belgique     │     │
│ 2 │ MzMxOTA3Mg== │ ALCYON                  │ Poortakkerstraat 41D,   │ ... │
│   │              │                         │ 9051                    │     │
│   │              │                         │ Sint-Denijs-Westrem,    │     │
│   │              │                         │ Belgique                │     │
│ 3 │ MzMxOTA3Ng== │ IRIS TECHNICAL SERVICES │ Rue Ilya Progogine 2,   │ ... │
│   │              │                         │ 7850 Enghien, Belgique  │     │
╰───┴──────────────┴─────────────────────────┴─────────────────────────┴─────╯
```

### 🌍 Variables d'environnement

NuShell gère les variables d'environnement de manière structurée et puissante.

#### 🔹Accéder aux variables d'environnement

```sh
# Accès direct aux variables
$env.USER
$env.HOME
$env.PATH

# Lister toutes les variables d'environnement
$env | transpose key value | first 5
```

```sh
╭───┬─────────┬─────────────────────────────────────╮
│ # │   key   │                value                │
├───┼─────────┼─────────────────────────────────────┤
│ 0 │ USER    │ kinnar                              │
│ 1 │ HOME    │ /home/kinnar                        │
│ 2 │ PATH    │ /usr/local/bin:/usr/bin:/bin        │
│ 3 │ SHELL   │ /usr/bin/nushell                    │
│ 4 │ PWD     │ /home/kinnar/projects               │
╰───┴─────────┴─────────────────────────────────────╯
```

#### 🔹Variables d'environnement courantes

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

#### 🔹Utilisation dans les pipelines

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

### 🔗 Connexions SQL

> NuShell intègre un connecteur à SQLite.

#### 🔹Utilisation de base avec SQLite

```sh
ls | into sqlite sample.db
```

```sh
open sample.db
```

```sh
╭──────┬────────────────╮
│ main │ [table 7 rows] │
╰──────┴────────────────╯
```

```sh
open sample.db | get main
```

```sh
╭───┬───────────────────┬──────┬───────┬─────────────────────────────────────╮
│ # │       name        │ type │ size  │              modified               │
├───┼───────────────────┼──────┼───────┼─────────────────────────────────────┤
│ 0 │ base.bd           │ file │  8192 │ 2025-10-13 14:24:41.221327700+02:00 │
│ 1 │ config.json       │ file │   133 │ 2025-10-09 11:31:02.033171500+02:00 │
│ 2 │ employees.json    │ file │  4932 │ 2025-10-09 14:43:03.634381700+02:00 │
│ 3 │ notes.txt         │ file │   168 │ 2025-10-09 11:31:33.241767900+02:00 │
│ 4 │ personnes.csv     │ file │    87 │ 2025-10-09 11:30:33.033195200+02:00 │
│ 5 │ utilisateurs.json │ file │  2559 │ 2025-10-09 15:05:51.614985900+02:00 │
│ 6 │ ventes.xlsx       │ file │ 11483 │ 2025-10-09 11:38:17.741472400+02:00 │
╰───┴───────────────────┴──────┴───────┴─────────────────────────────────────╯
```

```sh
open sample.db | query db "select name from main where size > 2500"
```

```sh
╭───┬───────────────────╮
│ # │       name        │
├───┼───────────────────┤
│ 0 │ base.bd           │
│ 1 │ employees.json    │
│ 2 │ utilisateurs.json │
│ 3 │ ventes.xlsx       │
╰───┴───────────────────╯
```

```sh
open sample.db | query db "select name from main where modified > '2025-10-10'"
```

```sh
╭───┬─────────╮
│ # │  name   │
├───┼─────────┤
│ 0 │ base.bd │
╰───┴─────────╯
```

#### 🔹Création d'une table manuellement dans SQLite

```sh
[ {id: 0, name: 'Fabrice', birthday: ('1974-05-12' | into datetime)} ]
  | into sqlite base.bd --table-name people
```

```sh
open base.bd
```

```sh
╭────────┬───────────────╮
│ people │ [table 1 row] │
╰────────┴───────────────╯
```

```sh
open base.bd | get people
```

```sh
╭───┬────┬─────────┬───────────────────────────╮
│ # │ id │  name   │         birthday          │
├───┼────┼─────────┼───────────────────────────┤
│ 0 │  0 │ Fabrice │ 1974-05-12 00:00:00+02:00 │
╰───┴────┴─────────┴───────────────────────────╯
```

> NuShell infère automatiquement les type de données. Mais si on veut forcer le type, ``into`` permet d'effectuer le casting.

#### 🔹Requête vers SQL Server

> Malheureusement, NuShell n'intègre pas de connexion directe avec SQL Server. Cependant, il est très facile d'exécuter une requête via ``sqlcmd`` (par exemple).

```sh
(
 sqlcmd -S <server> -d <database> -b -W -s "," -k 1 -Q <query>
  | lines
  | where {
    |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty)
  }
  | str join "\n"
  | from csv
)
```

Décomposons cette commande. Le résultat de ``sqlcmd`` n'est évidemment pas une table NuShell, il faut donc le reformater.

```sh
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company"

id,company_name,company_number,company_country,company_code,company_group
--,------------,--------------,---------------,------------,-------------
62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND
8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES  SA,453520233,Belgium,ICS,IFS
ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS GREENCARE,416912532,Belgium,IGC,IGC
a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON DIENSTENCHEQUES,877388259,Belgium,ADC,ADC
ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC
7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL SERVICES,843651263,Belgium,ITS,ITS

(6 rows affected)
```

Passer ce résultat à la commande ``lines`` permet de créer une table avec les lignes retournées par ``sqlcmd``.

```sh
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company" | lines

╭───┬──────────────────────────────────────────────────────────────────────────────────╮
│ 0 │ id,company_name,company_number,company_country,company_code,company_group        │
│ 1 │ --,------------,--------------,---------------,------------,-------------        │
│ 2 │ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND           │
│ 3 │ 8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES                      │
│   │ SA,453520233,Belgium,ICS,IFS                                                     │
│ 4 │ ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS                                   │
│   │ GREENCARE,416912532,Belgium,IGC,IGC                                              │
│ 5 │ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON                                │
│   │ DIENSTENCHEQUES,877388259,Belgium,ADC,ADC                                        │
│ 6 │ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC      │
│ 7 │ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL                              │
│   │ SERVICES,843651263,Belgium,ITS,ITS                                               │
│ 8 │                                                                                  │
│ 9 │ (6 rows affected)                                                                │
╰───┴──────────────────────────────────────────────────────────────────────────────────╯
```

La commande ``where`` permet de ne garder que les lignes de données.

```sh
(
  sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company"
  | lines
  | where {
    |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty)
  }
)

╭───┬──────────────────────────────────────────────────────────────────────────────────╮
│ 0 │ id,company_name,company_number,company_country,company_code,company_group        │
│ 1 │ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND           │
│ 2 │ 8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES                      │
│   │ SA,453520233,Belgium,ICS,IFS                                                     │
│ 3 │ ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS                                   │
│   │ GREENCARE,416912532,Belgium,IGC,IGC                                              │
│ 4 │ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON                                │
│   │ DIENSTENCHEQUES,877388259,Belgium,ADC,ADC                                        │
│ 5 │ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC      │
│ 6 │ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL                              │
│   │ SERVICES,843651263,Belgium,ITS,ITS                                               │
╰───┴──────────────────────────────────────────────────────────────────────────────────╯
```

L'appel a ``str join`` permet de recoller les lignes que ``sqlcmd`` a coupé en deux.

```sh
(
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company"
| lines
| where {
    |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty)
  }
| str join "\n"

id,company_name,company_number,company_country,company_code,company_group
62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND
8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES  SA,453520233,Belgium,ICS,IFS
ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS GREENCARE,416912532,Belgium,IGC,IGC
a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON DIENSTENCHEQUES,877388259,Belgium,ADC,ADC
ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC
7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL SERVICES,843651263,Belgium,ITS,ITS
```

Enfin, on a maintenant une structre CSV valide, il suffit donc de l'utiliser pour créer la table finale.

```sh
(
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company"
| lines
| where {
    |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty)
  }
| str join "\n"
| from csv
)

╭───┬───────────────────────────────────────┬─────────────────────────────┬─────╮
│ # │                  id                   │        company_name         │ ... │
├───┼───────────────────────────────────────┼─────────────────────────────┼─────┤
│ 0 │ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8  │ SA IRIS                     │ ... │
│ 1 │ 8a718cd0-fa68-477c-86f4-e7734ba5336c  │ IRIS CLEANING SERVICES  SA  │ ... │
│ 2 │ ef976bdb-caf8-40a7-87e9-f857b75d6073  │ SPRL IRIS GREENCARE         │ ... │
│ 3 │ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7  │ BVBA ALCYON DIENSTENCHEQUES │ ... │
│ 4 │ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3  │ BVBA ALCYON                 │ ... │
│ 5 │ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6  │ IRIS TECHNICAL SERVICES     │ ... │
╰───┴───────────────────────────────────────┴─────────────────────────────┴─────╯
```

### 🛠️ Scripts et commandes personnalisées

NuShell permet de créer des scripts et des commandes personnalisées très facilement. Ces scripts peuvent être exportés et réutilisés dans différents projets.

#### 🔹Concepts fondamentaux du langage

Avant de créer des scripts, il est important de comprendre les concepts de base du langage Nushell.

**Variables et types :**

```sh
# Déclaration de variables
let name = "Alice"
let age = 30
let active = true
let scores = [85, 92, 78]
let birthday = "1990-05-15"

# Types automatiquement inférés
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

# Conversion de booléens
let bool_str = "true"
let bool_val = $bool_str | into bool

# Vérification des types après conversion
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
    print "Très bien!"
} else if $score >= 70 {
    print "Bien!"
} else {
    print "À améliorer"
}
```

```sh
Très bien!
```

**Boucles :**

```sh
# Boucle for
for $i in 1..5 {
    print $"Numéro: ($i)"
}

# Boucle while
mut counter = 0
while $counter < 3 {
    print $"Compteur: ($counter)"
    $counter = $counter + 1
}
```

```sh
Numéro: 1
Numéro: 2
Numéro: 3
Numéro: 4
Numéro: 5
Compteur: 0
Compteur: 1
Compteur: 2
```

**Valeur de retour des fonctions :**

En Nushell, la valeur de retour d'une fonction est automatiquement la dernière expression évaluée :

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

**Opérateurs et expressions :**

```sh
# Opérateurs mathématiques
let a = 10
let b = 5
let result = $a + $b * 2
print $"Résultat: ($result)"

# Opérateurs de comparaison
let score1 = 85
let score2 = 90
let is_better = $score2 > $score1
print $"Score2 est meilleur: ($is_better)"

# Opérateurs logiques
let age = 25
let has_license = true
let can_drive = $age >= 18 and $has_license
print $"Peut conduire: ($can_drive)"

# Opérateurs de chaînes
let first_name = "Alice"
let last_name = "Smith"
let full_name = $first_name + " " + $last_name
print $"Nom complet: ($full_name)"

# Opérateur de correspondance
let text = "Hello World"
let contains_hello = $text =~ "Hello"
print $"Contient 'Hello': ($contains_hello)"
```

```sh
Résultat: 20
Score2 est meilleur: true
Peut conduire: true
Nom complet: Alice Smith
Contient 'Hello': true
```

**Ranges et séquences :**

```sh
# Ranges numériques
let numbers = 1..10
print $numbers

# Ranges de caractères
let letters = 'a'..'z'
print ($letters | first 5)

# Ranges avec conditions
let even_numbers = (1..20 | where $it % 2 == 0)
print ($even_numbers | first 5)

# Ranges inversés
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
# Définir une closure
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

**Manipulation de données :**

```sh
# Créer un tableau
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
╭───┬────────┬───────────╮
│ # │  nom   │   ville   │
├───┼────────┼───────────┤
│ 0 │ Alice  │ Paris     │
│ 1 │ Charlie│ Marseille │
╰───┴────────┴───────────╯
```

#### 🔹Gestion des erreurs dans les scripts

NuShell offre plusieurs mécanismes pour gérer les erreurs et déboguer les scripts.

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
# Récupérer l'erreur pour l'analyser
try {
    "abc" | into int
} catch { |err|
    print $"Erreur de conversion: ($err)"
}
```

```sh
Erreur de conversion: nu::shell::cant_convert
```

**Créer des erreurs personnalisées :**

```sh
def validate_age [age: int] {
    if $age < 0 {
        error make { msg: "L'âge ne peut pas être négatif" }
    } else if $age > 150 {
        error make { msg: "L'âge semble irréaliste" }
    } else {
        print $"Âge valide: ($age)"
    }
}

validate_age 25
validate_age -5
```

```sh
Âge valide: 25
Error: nu::shell::error

  × L'âge ne peut pas être négatif
```

**Gestion d'erreurs dans les pipelines :**

```sh
# Utiliser '?' pour propager les erreurs
def safe_divide [a: int, b: int] {
    if $b == 0 {
        error make { msg: "Division par zéro" }
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

print $"Résultat: ($result)"
```

```sh
Résultat: 5
```

**Debugging et traçage :**

```sh
def debug_function [input: string] {
    print $"Entrée: ($input)"
    let processed = ($input | str upcase)
    print $"Après traitement: ($processed)"
    $processed
}

debug_function "hello"
```

```sh
Entrée: hello
Après traitement: HELLO
HELLO
```

```sh
# Utiliser 'debug' pour inspecter les valeurs
let data = [1, 2, 3, 4, 5]
$data | debug | where $it > 3
```

#### 🔹Variables d'environnement dans les scripts

**Modifier les variables d'environnement :**

```sh
# Définir une variable temporaire
$env.MY_VAR = "valeur temporaire"
print $env.MY_VAR

# Modifier le PATH
$env.PATH = ($env.PATH | split row ":" | append "/usr/local/bin" | str join ":")

# Ajouter au PATH (méthode plus propre)
$env.PATH = ($env.PATH | split row ":" | append "/opt/myapp/bin" | str join ":")
```

```sh
valeur temporaire
```

**Charger des variables depuis un fichier :**

```sh
# Créer un fichier de variables
echo "API_KEY=abc123
DEBUG=true
LOG_LEVEL=info" | save config.env

# Charger les variables
open config.env | lines | parse "{key}={value}" | reduce -f {} { |it, acc| $acc | upsert $it.key $it.value } | load-env

# Vérifier que les variables sont chargées
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

    print $"Projet configuré: ($env.PROJECT_NAME)"
    print $"Racine: ($env.PROJECT_ROOT)"
    print $"Environnement: ($env.PROJECT_ENV)"
}

setup-project "mon-app"
```

```sh
Projet configuré: mon-app
Racine: /home/user/projects/mon-app
Environnement: development
```

**Gestion des variables sensibles :**

```sh
# Variables d'environnement pour les secrets
$env.DATABASE_PASSWORD = (input "Mot de passe DB: " --password)
$env.API_SECRET = (input "Clé API secrète: " --password)

# Utilisation dans les scripts
def connect-db [] {
    let connection_string = $"postgresql://user:($env.DATABASE_PASSWORD)@localhost/db"
    print "Connexion à la base de données..."
    # ... logique de connexion
}
```

> Les variables d'environnement sont essentielles pour la configuration des applications et le partage de paramètres entre scripts.

#### 🔹Créer une commande simple

```sh
def greet [name: string] {
    print $"Hello, ($name)!"
}

greet "Nushell"
```

```sh
Hello, Nushell!
```

> La commande `def` permet de définir une nouvelle commande. Les paramètres sont typés (ici `string`).

#### 🔹Créer une commande avec plusieurs paramètres

```sh
def add [a: int, b: int] {
    $a + $b
}

add 5 3
```

```sh
8
```

#### 🔹Créer une commande avec des options

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

#### 🔹Exporter une commande pour la réutiliser

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
        print "  -f, --force            Écraser les variables existantes"
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
```

> `export def` permet d'exporter la commande pour qu'elle soit disponible dans d'autres scripts ou dans la configuration.

#### 🔹Utiliser une commande exportée

```sh
# Charger le script
source scripts/load-dotenv.nu

# Utiliser la commande
load-dotenv                    # Charge .env par défaut
load-dotenv config.env         # Charge un fichier spécifique
open .env | load-dotenv        # Utilise le pipe (approche Nushellienne)
load-dotenv --force            # Écrase les variables existantes
load-dotenv --quiet            # Mode silencieux
load-dotenv --help             # Affiche l'aide
```

#### 🔹Créer une commande qui modifie l'environnement

```sh
export def --env my-cd [path: string] {
    cd $path
    print $"Répertoire changé vers: ($env.PWD)"
}

my-cd /tmp
```

```sh
Répertoire changé vers: /tmp
```

> `def --env` permet à la commande de modifier l'environnement du shell appelant. Sans cela, les changements d'environnement sont limités au scope de la commande.

#### 🔹Quand utiliser `def --env` ?

**Utilisez `def --env` quand votre fonction doit :**
- Changer le répertoire de travail (`cd`)
- Modifier des variables d'environnement qui doivent persister
- Créer des alias ou des fonctions temporaires
- Configurer l'environnement pour la session

**Exemple pratique : Navigation vers les repos**

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
# Définir la variable d'environnement
$env.repos = "D:\Users\kinnar\source\repos"

# Charger le script
source scripts/go-to-repos.nu

# Utiliser la fonction
repos                    # Va vers D:\Users\kinnar\source\repos
repos n2f               # Va vers D:\Users\kinnar\source\repos\n2f
repos "autre-projet"    # Va vers D:\Users\kinnar\source\repos\autre-projet
```

**⚠️ Important :** Sans `--env`, la fonction `cd` ne changerait pas le répertoire de la session parente !

#### 🔹Créer une commande complexe avec gestion d'erreurs

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
        print "  -e, --environment <env> Environnement à utiliser (dev, prod)"
        print "  -v, --verbose          Affiche les messages de débogage"
        print "  --trust                Utilise l'authentification Windows intégrée"
        print "  -u, --username <user>  Nom d'utilisateur pour l'authentification SQL"
        print "  -p, --password <pass>  Mot de passe pour l'authentification SQL"
        print "  -h, --help             Affiche cette aide"
        return
    }

    # Détermine l'environnement
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

    # Exécute sqlcmd avec gestion d'erreur
    let raw_output = (try {
        sqlcmd -S $server -d $database -b -W -s "," -k 1 -Q $query -f 65001 ...$auth_args
    } catch {
        error make { msg: "Erreur lors de l'exécution de sqlcmd. Vérifiez vos credentials, permissions ou la connectivité au serveur." }
    })

    # Nettoie et convertit la sortie
    let cleaned_lines = ($raw_output | lines | where { |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty) and not ($it | str starts-with "Changed database context") })

    let result = if ($cleaned_lines | length) > 0 {
        $cleaned_lines | str join "\n" | from csv
    } else {
        []
    }

    if ($result | is-empty) {
        error make { msg: "Aucun résultat retourné. Vérifiez que la requête est correcte et que vous avez les permissions nécessaires." }
    } else {
        $result
    }
}
```

#### 🔹Utiliser la commande SQL

```sh
# Charger le script
source scripts/sql-server-iris.nu

# Utiliser la commande
query-sql-server "SELECT * FROM iris_geo_company" --environment prod --username=$env.AGRESSO_DB_USER --password=$env.AGRESSO_DB_PASSWORD
```

```sh
╭───┬───────────────────────────────────────┬─────────────────────────────┬────────────────┬─────────────────┬──────────────┬───────────────╮
│ # │                  id                   │        company_name         │ company_number │ company_country │ company_code │ company_group │
├───┼───────────────────────────────────────┼─────────────────────────────┼────────────────┼─────────────────┼──────────────┼───────────────┤
│ 0 │ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8  │ SA IRIS                     │      453520431 │ Belgium         │ IRS          │ IND           │
│ 1 │ 8a718cd0-fa68-477c-86f4-e7734ba5336c  │ IRIS CLEANING SERVICES  SA  │      453520233 │ Belgium         │ ICS          │ IFS           │
│ 2 │ ef976bdb-caf8-40a7-87e9-f857b75d6073  │ SPRL IRIS GREENCARE         │      416912532 │ Belgium         │ IGC          │ IGC           │
╰───┴───────────────────────────────────────┴─────────────────────────────┴────────────────┴─────────────────┴──────────────┴───────────────╯
```

#### 🔹Organiser les scripts dans des modules

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

#### 🔹Ajouter des scripts à la configuration

```sh
# Dans config.nu
source ~/path/to/scripts/load-dotenv.nu
source ~/path/to/scripts/sql-server-iris.nu
```

> Une fois ajoutés à la configuration, les scripts sont disponibles automatiquement à chaque démarrage de NuShell.

#### 🔹Créer une commande qui wrap une commande externe

```sh
export def --wrapped my-git [...args] {
    if $args.0 == "status" {
        git ...$args | lines | where { |it| ($it | str contains "modified") or ($it | str contains "new file") }
    } else {
        git ...$args
    }}

my-git status
```

> `def --wrapped` permet de créer une commande qui étend une commande externe en interceptant ses arguments.

#### 🔹Bonnes pratiques pour les scripts

1. **Utiliser `export def`** pour les commandes réutilisables
2. **Ajouter de l'aide** avec `--help` et des commentaires
3. **Gérer les erreurs** avec `try-catch` et `error make`
4. **Utiliser des types** pour les paramètres (`string`, `int`, etc.)
5. **Organiser** les scripts dans des dossiers dédiés
6. **Tester** les scripts avec différents paramètres
7. **Documenter** l'usage avec des exemples concrets

> Les scripts NuShell sont très puissants et permettent d'automatiser des tâches complexes tout en gardant la lisibilité et la maintenabilité du code.

### 📜 Scripting Avancé

#### 🔹Gestion d'erreurs avancée

**Propagation d'erreurs avec `?` :**

```sh
# Fonction qui peut échouer
def safe_divide [a: int, b: int] {
    if $b == 0 {
        error make { msg: "Division par zéro" }
    } else {
        $a / $b
    }
}

# Propagation automatique des erreurs
def calculate_average [numbers: list<int>] {
    let sum = ($numbers | reduce -f 0 { |it, acc| $acc + $it })
    let count = ($numbers | length)
    safe_divide $sum $count  # L'erreur sera propagée automatiquement
}

# Test avec des données valides
calculate_average [10, 20, 30, 40]

# Test avec des données invalides (division par zéro)
try {
    calculate_average []
} catch { |err|
    print $"Erreur capturée: ($err)"
}
```

```sh
25
Erreur capturée: nu::shell::error
```

**Try-catch avancé avec gestion de différents types d'erreurs :**

```sh
def process_file [file_path: string] {
    try {
        let content = (open $file_path)
        let lines = ($content | lines | length)
        print $"Fichier traité: ($lines) lignes"
        $content
    } catch { |err|
        match ($err | get msg) {
            "File not found" => {
                print "Le fichier n'existe pas"
                []
            }
            "Permission denied" => {
                print "Accès refusé au fichier"
                []
            }
            _ => {
                print $"Erreur inattendue: ($err)"
                []
            }
        }
    }
}

# Test avec différents scénarios
process_file "fichier-inexistant.txt"
process_file "README.md"
```

#### 🔹Modules et organisation

**Créer un module simple :**

```sh
# scripts/utils.nu
export def --env cd-project [project_name: string] {
    let project_path = ($env.HOME | path join "projects" $project_name)
    if ($project_path | path exists) {
        cd $project_path
        print $"Projet '$project_name' chargé"
    } else {
        print $"Le projet '$project_name' n'existe pas"
    }
}

export def format-date [date: datetime] {
    $date | format date "%Y-%m-%d %H:%M:%S"
}

export def get-file-size [file_path: string] {
    if ($file_path | path exists) {
        (ls $file_path | get size.0)
    } else {
        0
    }
}
```

**Utiliser le module :**

```sh
# Charger le module
use scripts/utils.nu *

# Utiliser les fonctions exportées
cd-project "mon-projet"
format-date (date now)
get-file-size "README.md"
```

**Module avec sous-modules :**

```sh
# scripts/database/mod.nu
export use sqlite.nu
export use postgres.nu
export use mysql.nu

# scripts/database/sqlite.nu
export def create-table [db_path: string, table_name: string, schema: record] {
    let create_sql = $"CREATE TABLE ($table_name) (($schema | transpose key value | each { |it| $"($it.key) ($it.value)" } | str join ", "))"
    print $"Création de la table: ($create_sql)"
    # Logique de création...
}

# scripts/database/postgres.nu
export def connect [host: string, port: int, database: string, user: string] {
    print $"Connexion à PostgreSQL: ($host):($port)/($database) as ($user)"
    # Logique de connexion...
}
```

#### 🔹Completions personnalisées

**Completions pour les commandes personnalisées :**

```sh
# scripts/git-utils.nu
export def --env git-branch [
    action: string@"git-branch-actions"
] {
    match $action {
        "list" => { git branch }
        "create" => { git checkout -b $branch_name }
        "delete" => { git branch -d $branch_name }
        "switch" => { git checkout $branch_name }
        _ => { print "Action non reconnue" }
    }
}

# Définir les completions
def "git-branch-actions" [] {
    ["list", "create", "delete", "switch"]
}

# Completions pour les fichiers
export def edit-config [
    config_file: path@"config-files"
] {
    $env.EDITOR $config_file
}

def "config-files" [] {
    [
        "config.nu"
        "env.nu"
        "login.nu"
        "theme.nu"
    ]
}
```

#### 🔹Configuration avancée

**Configuration avec hooks :**

```sh
# config.nu
# Hook de changement de répertoire
$env.config = ($env.config | upsert hooks {
    pre_prompt: [{
        # Mettre à jour le prompt avec des infos Git
        let git_branch = (try { git branch --show-current } catch { "" })
        let git_status = (try { git status --porcelain | lines | length } catch { 0 })

        if ($git_branch | is-not-empty) {
            $env.PROMPT_COMMAND = $"($git_branch) ($git_status) > "
        }
    }]

    pre_execution: [{
        # Logger les commandes exécutées
        let cmd = $env.HISTORY_FILE
        if ($cmd | is-not-empty) {
            echo $"$(date now) | $cmd" | save --append ~/.nushell/history.log
        }
    }]
})

# Variables d'environnement conditionnelles
if $env.OS == "Windows_NT" {
    $env.EDITOR = "code"
    $env.PATH = ($env.PATH | split row ";" | append "C:\\tools" | str join ";")
} else {
    $env.EDITOR = "vim"
    $env.PATH = ($env.PATH | split row ":" | append "/usr/local/bin" | str join ":")
}

# Alias utiles
alias ll = ls -la
alias la = ls -a
alias grep = grep --color=auto
alias df = df -h
alias du = du -h
```

**Configuration par environnement :**

```sh
# env.nu
def load-env-config [env_name: string] {
    let config_file = $"~/.config/nushell/env/($env_name).nu"

    if ($config_file | path exists) {
        source $config_file
        print $"Configuration '$env_name' chargée"
    } else {
        print $"Configuration '$env_name' non trouvée"
    }
}

# Charger la configuration selon l'environnement
if ("NUSHELL_ENV" in $env) {
    load-env-config $env.NUSHELL_ENV
} else {
    load-env-config "default"
}
```

#### 🔹Performance et optimisation

**Traitement parallèle avec `par-each` :**

```sh
# Traitement séquentiel (lent)
def process-files-slow [files: list<string>] {
    $files | each { |file|
        let content = (open $file)
        let word_count = ($content | str words | length)
        {file: $file, words: $word_count}
    }
}

# Traitement parallèle (rapide)
def process-files-fast [files: list<string>] {
    $files | par-each { |file|
        let content = (open $file)
        let word_count = ($content | str words | length)
        {file: $file, words: $word_count}
    }
}

# Test avec plusieurs fichiers
let files = (ls *.md | get name)
process-files-fast $files
```

**Optimisation des gros datasets :**

```sh
# Traitement efficace de gros fichiers CSV
def analyze-large-csv [file_path: string] {
    open $file_path
    | skip 1  # Ignorer l'en-tête
    | par-each { |row|
        # Traitement de chaque ligne
        let processed = ($row | str split "," | each { |it| $it | str trim })
        $processed
    }
    | group-by 0  # Grouper par première colonne
    | each { |group|
        {
            category: $group.0,
            count: ($group.1 | length),
            avg_value: ($group.1 | get 1 | into float | math avg)
        }
    }
}

# Utilisation
analyze-large-csv "big-data.csv"
```

#### 🔹Intégration système

**Gestion des processus :**

```sh
# Surveiller les processus
def monitor-process [process_name: string] {
    while true {
        let processes = (ps | where name =~ $process_name)
        if ($processes | is-empty) {
            print $"Processus '$process_name' non trouvé"
        } else {
            $processes | select name pid cpu mem
        }
        sleep 5sec
    }
}

# Démarrer un processus en arrière-plan
def start-background-process [command: string] {
    let pid = (run-external --redirect-stdout --redirect-stderr $command | get pid)
    print $"Processus démarré avec PID: ($pid)"
    $pid
}

# Arrêter un processus
def stop-process [pid: int] {
    try {
        kill $pid
        print $"Processus ($pid) arrêté"
    } catch {
        print $"Impossible d'arrêter le processus ($pid)"
    }
}
```

**Redirections et pipes :**

```sh
# Redirection de sortie
def save-command-output [command: string, output_file: string] {
    run-external $command --redirect-stdout $output_file
    print $"Sortie sauvegardée dans: ($output_file)"
}

# Pipe vers une commande externe
def filter-with-grep [input: string, pattern: string] {
    echo $input | run-external grep $pattern --redirect-stdout
}

# Combiner plusieurs commandes
def complex-pipeline [input_file: string] {
    open $input_file
    | lines
    | where { |it| $it | str contains "error" }
    | str join "\n"
    | run-external wc -l --redirect-stdout
}
```

#### 🔹Scripts autonomes

**Script avec shebang :**

```sh
#!/usr/bin/env nu

# Script autonome pour nettoyer les fichiers temporaires
def main [
    --dry-run(-d): bool  # Mode simulation
    --age: int = 7       # Âge en jours
] {
    let temp_dir = "/tmp"
    let cutoff_date = (date now) - ($age * 1day)

    let old_files = (ls $temp_dir
        | where type == "file"
        | where modified < $cutoff_date)

    if $dry_run {
        print "Mode simulation - fichiers qui seraient supprimés:"
        $old_files | select name modified
    } else {
        print "Suppression des fichiers anciens..."
        for $file in $old_files {
            try {
                rm $file.name
                print $"Supprimé: ($file.name)"
            } catch {
                print $"Erreur lors de la suppression de: ($file.name)"
            }
        }
    }
}

# Exécution du script
main $args
```

**Script avec gestion d'arguments :**

```sh
#!/usr/bin/env nu

def main [
    input_file: string,
    --output(-o): string,
    --format: string@"formats" = "json",
    --verbose(-v): bool
] {
    if $verbose {
        print $"Traitement du fichier: ($input_file)"
        print $"Format de sortie: ($format)"
    }

    let output_file = if $output != null {
        $output
    } else {
        ($input_file | path parse | get stem) + $".($format)"
    }

    let data = (open $input_file)

    match $format {
        "json" => { $data | to json | save $output_file }
        "csv" => { $data | to csv | save $output_file }
        "yaml" => { $data | to yaml | save $output_file }
        _ => { error make { msg: "Format non supporté" } }
    }

    print $"Fichier sauvegardé: ($output_file)"
}

def "formats" [] {
    ["json", "csv", "yaml", "toml"]
}

main $args
```

#### 🔹Tests et validation de scripts

**Tests unitaires simples :**

```sh
# scripts/tests.nu
def test-math-functions [] {
    print "Test des fonctions mathématiques..."

    # Test de la fonction add
    let result1 = (add 2 3)
    assert equal $result1 5 "Addition de 2 + 3"

    # Test de la fonction multiply
    let result2 = (multiply 4 5)
    assert equal $result2 20 "Multiplication de 4 * 5"

    print "Tous les tests mathématiques ont réussi!"
}

def test-file-operations [] {
    print "Test des opérations de fichiers..."

    # Créer un fichier de test
    echo "test content" | save test-file.txt

    # Tester la lecture
    let content = (open test-file.txt)
    assert equal $content "test content" "Lecture du fichier"

    # Nettoyer
    rm test-file.txt

    print "Tous les tests de fichiers ont réussi!"
}

# Fonction d'assertion simple
def assert equal [actual: any, expected: any, message: string] {
    if $actual != $expected {
        error make {
            msg: $"Test échoué: ($message). Attendu: ($expected), Obtenu: ($actual)"
        }
    }
}

# Exécuter tous les tests
def run-all-tests [] {
    test-math-functions
    test-file-operations
    print "Tous les tests ont réussi! ✅"
}
```

**Validation de scripts :**

```sh
# scripts/validator.nu
def validate-script [script_path: string] {
    print $"Validation du script: ($script_path)"

    # Vérifier la syntaxe
    try {
        source $script_path
        print "✅ Syntaxe correcte"
    } catch { |err|
        print $"❌ Erreur de syntaxe: ($err)"
        return false
    }

    # Vérifier les fonctions exportées
    let exported_functions = (scope commands | where is_exported == true)
    if ($exported_functions | is-empty) {
        print "⚠️  Aucune fonction exportée trouvée"
    } else {
        print $"✅ ($exported_functions | length) fonction(s) exportée(s)"
    }

    # Vérifier la documentation
    let script_content = (open $script_path)
    if ($script_content | str contains "--help") {
        print "✅ Documentation d'aide présente"
    } else {
        print "⚠️  Documentation d'aide manquante"
    }

    print "Validation terminée"
    true
}

# Utilisation
validate-script "scripts/my-script.nu"
```

### 🔌 Plugins

Les plugins étendent les capacités de NuShell avec de nouvelles commandes et fonctionnalités. Ils sont généralement écrits en Rust et peuvent être installés via `cargo` ou `plugin add`.

#### 🔹Où trouver les plugins

**Sources principales :**

- **crates.io** : [https://crates.io/search?q=nu_plugin](https://crates.io/search?q=nu_plugin)
- **GitHub** : Rechercher `nu_plugin` dans les dépôts
- **Documentation officielle** : [https://www.nushell.sh/plugins/](https://www.nushell.sh/plugins/)

**Plugins populaires :**

- `nu_plugin_polars` - Analyse de données avancée
- `nu_plugin_query` - Requêtes SQL sur les données
- `nu_plugin_formats` - Support de formats supplémentaires
- `nu_plugin_inc` - Gestion de versions
- `nu_plugin_gstat` - Statistiques Git

#### 🔹Installation via cargo install

```sh
# Installer un plugin depuis crates.io
cargo install nu_plugin_polars
cargo install nu_plugin_query
cargo install nu_plugin_inc

# Vérifier l'installation
cargo list | grep nu_plugin
```

#### 🔹Installation via plugin add

```sh
# Ajouter un plugin (si disponible via plugin add)
plugin add nu_plugin_polars
plugin add nu_plugin_query

# Lister les plugins installés
plugin list
```

#### 🔹Initialisation et configuration

**Activer les plugins dans config.nu :**

```sh
# config.nu
# Charger les plugins
register ~/.cargo/bin/nu_plugin_polars
register ~/.cargo/bin/nu_plugin_query
register ~/.cargo/bin/nu_plugin_inc

# Configuration des plugins
$env.config = ($env.config | upsert plugins {
    polars: {
        lazy: true
        streaming: true
    }
    query: {
        default_database: "sqlite"
    }
})
```

**Vérifier que les plugins sont chargés :**

```sh
# Lister les commandes disponibles
help commands | where category =~ "plugin"

# Tester un plugin
polars --help
query --help
```

#### 🔹Exemples concrets de plugins

**nu_plugin_polars - Analyse de données :**

```sh
# Créer un dataset de test
let sales_data = [
    {date: "2024-01-01", product: "Laptop", price: 999, quantity: 5},
    {date: "2024-01-02", product: "Mouse", price: 25, quantity: 20},
    {date: "2024-01-03", product: "Keyboard", price: 75, quantity: 15},
    {date: "2024-01-04", product: "Laptop", price: 999, quantity: 3},
    {date: "2024-01-05", product: "Monitor", price: 299, quantity: 8}
] | to csv | save sales.csv

# Analyser avec Polars
open sales.csv | polars df
```

```sh
╭───┬────────────┬─────────┬───────┬──────────╮
│ # │    date    │ product │ price │ quantity │
├───┼────────────┼─────────┼───────┼──────────┤
│ 0 │ 2024-01-01 │ Laptop  │   999 │        5 │
│ 1 │ 2024-01-02 │ Mouse   │    25 │       20 │
│ 2 │ 2024-01-03 │ Keyboard│    75 │       15 │
│ 3 │ 2024-01-04 │ Laptop  │   999 │        3 │
│ 4 │ 2024-01-05 │ Monitor │   299 │        8 │
╰───┴────────────┴─────────┴───────┴──────────╯
```

**Opérations avancées avec Polars :**

```sh
# Calculer le chiffre d'affaires par produit
open sales.csv | polars df | polars group-by product | polars agg [
    (polars col quantity * polars col price | polars sum | polars alias "total_revenue")
    (polars col quantity | polars sum | polars alias "total_quantity")
]

# Filtrer les produits avec un CA > 1000
open sales.csv | polars df | polars filter (polars col price * polars col quantity > 1000)

# Statistiques descriptives
open sales.csv | polars df | polars describe
```

**nu_plugin_query - Requêtes SQL :**

```sh
# Créer une base de données SQLite
let employees = [
    {id: 1, name: "Alice", department: "IT", salary: 75000},
    {id: 2, name: "Bob", department: "HR", salary: 65000},
    {id: 3, name: "Charlie", department: "IT", salary: 80000},
    {id: 4, name: "Diana", department: "Finance", salary: 70000}
] | to csv | save employees.csv

# Convertir en base SQLite
open employees.csv | into sqlite employees.db

# Requêtes SQL
open employees.db | query db "SELECT department, AVG(salary) as avg_salary FROM main GROUP BY department"

open employees.db | query db "SELECT * FROM main WHERE salary > 70000 ORDER BY salary DESC"
```

**nu_plugin_inc - Gestion de versions :**

```sh
# Incrémenter une version
inc --major 1.2.3    # 2.0.0
inc --minor 1.2.3    # 1.3.0
inc --patch 1.2.3    # 1.2.4

# Utilisation dans un script de déploiement
def bump-version [version_type: string] {
    let current_version = (open Cargo.toml | lines | where $it =~ "version" | parse "version = \"{version}\"" | get version.0)
    let new_version = (inc --$version_type $current_version)

    print $"Version mise à jour: ($current_version) -> ($new_version)"

    # Mettre à jour le fichier Cargo.toml
    open Cargo.toml | str replace $"version = \"($current_version)\"" $"version = \"($new_version)\"" | save Cargo.toml

    # Créer un tag Git
    git add Cargo.toml
    git commit -m $"Bump version to ($new_version)"
    git tag $"v($new_version)"
}
```

#### 🔹Autres plugins utiles

**nu_plugin_formats - Formats supplémentaires :**

```sh
# Support pour TOML
echo "title = 'Mon projet'
version = '1.0.0'
[author]
name = 'Alice'
email = 'alice@example.com'" | save config.toml

open config.toml | from toml

# Support pour YAML
echo "database:
  host: localhost
  port: 5432
  name: myapp
  user: admin" | save config.yaml

open config.yaml | from yaml
```

**nu_plugin_gstat - Statistiques Git :**

```sh
# Statistiques du dépôt Git
gstat

# Statistiques pour un auteur spécifique
gstat --author "Alice"

# Statistiques pour une période
gstat --since "2024-01-01" --until "2024-12-31"
```

#### 🔹Créer un plugin simple

**Structure d'un plugin minimal :**

```rust
// src/main.rs
use nu_plugin::{serve_plugin, EvaluatedCall, LabeledError, MsgPackSerializer, Plugin};
use nu_protocol::{Category, PluginSignature, SyntaxShape, Value};

struct MyPlugin;

impl Plugin for MyPlugin {
    fn signature(&self) -> Vec<PluginSignature> {
        vec![PluginSignature::build("my-command")
            .desc("Ma commande personnalisée")
            .required("input", SyntaxShape::String, "Entrée à traiter")
            .category(Category::Custom("MyPlugin".into()))]
    }

    fn run(
        &mut self,
        name: &str,
        call: &EvaluatedCall,
        input: &Value,
    ) -> Result<Value, LabeledError> {
        match name {
            "my-command" => {
                let input_str: String = call.req(0)?;
                let result = format!("Traitement de: {}", input_str);
                Ok(Value::String { val: result, span: call.head })
            }
            _ => Err(LabeledError {
                label: "Commande inconnue".into(),
                msg: format!("Commande '{}' non reconnue", name),
                span: Some(call.head),
            }),
        }
    }
}

fn main() {
    serve_plugin(&mut MyPlugin, MsgPackSerializer {})
}
```

**Cargo.toml :**

```toml
[package]
name = "nu_plugin_myplugin"
version = "0.1.0"
edition = "2021"

[dependencies]
nu-plugin = "0.87"
nu-protocol = "0.87"
```

**Installation et utilisation :**

```sh
# Compiler le plugin
cargo build --release

# Installer
cargo install --path .

# Enregistrer dans NuShell
register ~/.cargo/bin/nu_plugin_myplugin

# Utiliser
my-command "Hello World"
```

#### 🔹Bonnes pratiques pour les plugins

1. **Nommage** : Utiliser le préfixe `nu_plugin_`
2. **Documentation** : Inclure des exemples d'usage
3. **Gestion d'erreurs** : Messages d'erreur clairs
4. **Performance** : Optimiser pour les gros datasets
5. **Tests** : Inclure des tests unitaires
6. **Configuration** : Permettre la personnalisation
7. **Compatibilité** : Tester avec différentes versions de NuShell

> Les plugins permettent d'étendre considérablement les capacités de NuShell tout en gardant le shell léger et modulaire.

### 🎨 Alias et Configuration Personnalisée

#### 🔹Créer des alias utiles

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

#### 🔹Configuration personnalisée (config.nu)

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
        # Mettre à jour les informations Git
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
            # Mettre à jour le titre de la fenêtre
            if ($env.TERM_PROGRAM == "vscode") {
                print $"\e]0;NuShell - ($env.PWD)\a"
            }
        }]
    }
})
```

#### 🔹Thèmes et personnalisation de l'interface

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

#### 🔹Intégration avec Git

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

#### 🔹Configuration par environnement

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

# Alias spécifiques à la production
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

> La configuration personnalisée permet d'adapter NuShell à vos besoins spécifiques et d'automatiser vos workflows quotidiens.

### 🔧 Outils et Utilitaires

#### 🔹Chemins et navigation avancée

**Navigation intelligente :**

```sh
# Fonction de navigation avec historique
export def --env smart-cd [path: string] {
    # Sauvegarder l'ancien répertoire
    let old_path = $env.PWD

    # Changer de répertoire
    cd $path

    # Ajouter à l'historique
    $env.DIR_HISTORY = ($env.DIR_HISTORY | default [] | append $old_path | last 50)

    print $"Répertoire changé: ($old_path) -> ($env.PWD)"
}

# Alias pour la navigation intelligente
alias cd = smart-cd
alias back = cd $env.DIR_HISTORY.0

# Navigation rapide vers les dossiers fréquents
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
        print $"Navigué vers: ($name) -> ($env.PWD)"
    } else {
        print "Dossier rapide non trouvé. Dossiers disponibles:"
        $quick_paths | transpose name path | select name
    }
}

# Alias pour la navigation rapide
alias qcd = quick-cd
```

**Recherche de fichiers avancée :**

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

# Fonction pour créer une structure de dossiers
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

#### 🔹Compression/décompression de fichiers

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
        _ => { error make { msg: "Format non supporté" } }
    }

    print $"Archive créée: ($output_file)"
}

# Fonction de décompression universelle
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
        _ => { error make { msg: "Format d'archive non supporté" } }
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

    print $"Sauvegarde créée: ($backup_path)"
    print $"Taille: (($backup_path | ls | get size.0) | into filesize)"
}

# Fonction de nettoyage des sauvegardes anciennes
export def cleanup-backups [backup_dir: string = "~/backups", --keep-days(-k): int = 30] {
    let cutoff_date = (date now) - ($keep_days * 1day)

    ls $backup_dir | where type == "file" and modified < $cutoff_date | each { |file|
        rm $file.name
        print $"Sauvegarde supprimée: ($file.name)"
    }
}

# Alias pour les sauvegardes
alias backup = backup
alias cleanup = cleanup-backups
```

#### 🔹Monitoring système

**Surveillance des processus :**

```sh
# Fonction de monitoring des processus en temps réel
export def monitor-processes [--interval(-i): duration = 5sec, --top(-t): int = 10] {
    while true {
        clear
        print $"=== Monitoring des processus - $(date now) ==="

        ps | where cpu > 0 | sort-by cpu -r | first $top | select name pid cpu mem | table

        sleep $interval
    }
}

# Fonction de surveillance de la mémoire
export def monitor-memory [--interval(-i): duration = 10sec] {
    while true {
        clear
        print $"=== Surveillance de la mémoire - $(date now) ==="

        let mem_info = (ps | where name != "ps" | reduce -f 0 { |it, acc| $acc + $it.mem })
        let mem_usage = ($mem_info | into filesize)

        print $"Utilisation mémoire totale: ($mem_usage)"

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

**Surveillance du réseau :**

```sh
# Fonction de surveillance des connexions réseau
export def monitor-network [--interval(-i): duration = 10sec] {
    while true {
        clear
        print $"=== Surveillance réseau - $(date now) ==="

        # Connexions TCP
        print "=== Connexions TCP ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | where proto == "tcp" | table

        # Connexions UDP
        print "=== Connexions UDP ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | where proto == "udp" | table

        sleep $interval
    }
}

# Fonction de test de connectivité
export def test-connectivity [host: string, --port(-p): int = 80, --timeout(-t): int = 5] {
    try {
        let result = (run-external nc -z -w $timeout $host $port)
        print $"✅ Connexion réussie vers ($host):($port)"
        true
    } catch {
        print $"❌ Connexion échouée vers ($host):($port)"
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
    print $"  Taux de succès: ($success_rate)%"
    print $"  Temps moyen: ($avg_time)ms"
}

# Alias pour le réseau
alias mon-net = monitor-network
alias ping = ping-stats
alias test-conn = test-connectivity
```

**Surveillance des logs :**

```sh
# Fonction de surveillance des logs en temps réel
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

**Tableau de bord système :**

```sh
# Fonction de tableau de bord complet
export def system-dashboard [--refresh(-r): duration = 5sec] {
    while true {
        clear
        print $"=== Tableau de bord système - $(date now) ==="

        # Informations système
        print "=== Informations système ==="
        print $"Utilisateur: ($env.USER)"
        print $"Hôte: (hostname)"
        print $"OS: ($env.OS)"
        print $"Architecture: ($env.ARCH)"

        # Utilisation CPU et mémoire
        print "=== Utilisation des ressources ==="
        let top_processes = (ps | where cpu > 0 | sort-by cpu -r | first 5)
        $top_processes | select name pid cpu mem | table

        # Utilisation du disque
        print "=== Utilisation du disque ==="
        du | where physical > 1GB | sort-by physical -r | first 5 | select path physical | table

        # Connexions réseau
        print "=== Connexions réseau ==="
        netstat -tuln | lines | skip 2 | parse "{proto} {local} {foreign} {state}" | group-by proto | transpose protocol count | table

        sleep $refresh
    }
}

# Alias pour le tableau de bord
alias dashboard = system-dashboard
alias sysinfo = system-dashboard
```

> Ces outils de monitoring permettent de surveiller efficacement votre système et de détecter rapidement les problèmes de performance ou de sécurité.

### 📊 Analyse de Données Avancée

#### 🔹Statistiques descriptives

**Fonctions de statistiques de base :**

```sh
# Fonction de statistiques complètes
export def stats [data: list] {
    let count = ($data | length)
    let sum = ($data | reduce -f 0 { |it, acc| $acc + $it })
    let mean = $sum / $count
    let sorted = ($data | sort)
    let median = if $count % 2 == 0 {
        ($sorted | get ($count / 2 - 1) + ($sorted | get ($count / 2))) / 2
    } else {
        $sorted | get ($count / 2)
    }

    let variance = ($data | each { |it| ($it - $mean) * ($it - $mean) } | math avg)
    let std_dev = ($variance | math sqrt)

    let min = ($data | math min)
    let max = ($data | math max)
    let range = $max - $min

    {
        count: $count,
        sum: $sum,
        mean: $mean,
        median: $median,
        std_dev: $std_dev,
        variance: $variance,
        min: $min,
        max: $max,
        range: $range
    }
}

# Test avec des données
let test_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
stats $test_data
```

```sh
╭─────────┬───────╮
│ count   │    10 │
│ sum     │    55 │
│ mean    │   5.5 │
│ median  │   5.5 │
│ std_dev │ 3.028 │
│ variance│ 9.167 │
│ min     │     1 │
│ max     │    10 │
│ range   │     9 │
╰─────────┴───────╯
```

**Analyse de distribution :**

```sh
# Fonction d'analyse de distribution
export def distribution [data: list, --bins(-b): int = 10] {
    let min_val = ($data | math min)
    let max_val = ($data | math max)
    let bin_width = ($max_val - $min_val) / $bins

    let bins = (0..($bins - 1) | each { |i|
        let start = $min_val + ($i * $bin_width)
        let end = $min_val + (($i + 1) * $bin_width)
        let count = ($data | where $it >= $start and $it < $end | length)

        {
            bin: $i + 1,
            range: $"($start) - ($end)",
            count: $count,
            percentage: (($count / ($data | length)) * 100)
        }
    })

    $bins
}

# Test avec des données aléatoires
let random_data = (1..100 | each { |i| (random integer 1..100) })
distribution $random_data --bins 10
```

**Corrélation entre variables :**

```sh
# Fonction de calcul de corrélation
export def correlation [x: list, y: list] {
    let n = ($x | length)
    let sum_x = ($x | reduce -f 0 { |it, acc| $acc + $it })
    let sum_y = ($y | reduce -f 0 { |it, acc| $acc + $it })
    let mean_x = $sum_x / $n
    let mean_y = $sum_y / $n

    let sum_xy = ($x | zip $y | each { |pair| $pair.0 * $pair.1 } | reduce -f 0 { |it, acc| $acc + $it })
    let sum_x2 = ($x | each { |it| $it * $it } | reduce -f 0 { |it, acc| $acc + $it })
    let sum_y2 = ($y | each { |it| $it * $it } | reduce -f 0 { |it, acc| $acc + $it })

    let numerator = $sum_xy - ($n * $mean_x * $mean_y)
    let denominator = (($sum_x2 - ($n * $mean_x * $mean_x)) * ($sum_y2 - ($n * $mean_y * $mean_y))) | math sqrt

    $numerator / $denominator
}

# Test de corrélation
let x_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let y_data = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
correlation $x_data $y_data
```

#### 🔹Graphiques et visualisations

**Graphiques ASCII simples :**

```sh
# Fonction de graphique en barres ASCII
export def bar-chart [data: record, --width(-w): int = 50] {
    let max_value = ($data | transpose key value | get value | math max)

    $data | transpose key value | each { |item|
        let bar_length = (($item.value / $max_value) * $width) | into int
        let bar = ("█" | str repeat $bar_length)
        $"($item.key): ($bar) ($item.value)"
    }
}

# Exemple d'utilisation
let sales_data = {
    "Jan": 100,
    "Feb": 150,
    "Mar": 120,
    "Apr": 200,
    "May": 180
}

bar-chart $sales_data --width 30
```

```sh
Jan: ████████████████████████████████ 100
Feb: ████████████████████████████████████████████████████ 150
Mar: ████████████████████████████████████████████ 120
Apr: █████████████████████████████████████████████████████████████████████████████ 200
May: ████████████████████████████████████████████████████████████████████████ 180
```

**Graphique linéaire ASCII :**

```sh
# Fonction de graphique linéaire ASCII
export def line-chart [data: list, --height(-h): int = 10] {
    let max_value = ($data | math max)
    let min_value = ($data | math min)
    let range = $max_value - $min_value

    let chart_lines = (0..$height | each { |i|
        let threshold = $max_value - (($i / $height) * $range)
        let line = ($data | each { |value|
            if $value >= $threshold { "●" } else { " " }
        } | str join "")
        $"($line) ($threshold | into string | str substring 0..6)"
    })

    $chart_lines | reverse
}

# Exemple d'utilisation
let trend_data = [10, 15, 12, 18, 25, 30, 28, 35, 40, 38, 45, 50]
line-chart $trend_data --height 8
```

**Histogramme ASCII :**

```sh
# Fonction d'histogramme ASCII
export def histogram [data: list, --bins(-b): int = 10] {
    let min_val = ($data | math min)
    let max_val = ($data | math max)
    let bin_width = ($max_val - $min_val) / $bins

    let bins = (0..($bins - 1) | each { |i|
        let start = $min_val + ($i * $bin_width)
        let end = $min_val + (($i + 1) * $bin_width)
        let count = ($data | where $it >= $start and $it < $end | length)

        {
            range: $"($start | into string | str substring 0..4) - ($end | into string | str substring 0..4)",
            count: $count
        }
    })

    let max_count = ($bins | get count | math max)

    $bins | each { |bin|
        let bar_length = (($bin.count / $max_count) * 30) | into int
        let bar = ("█" | str repeat $bar_length)
        $"($bin.range): ($bar) ($bin.count)"
    }
}

# Exemple d'utilisation
let random_data = (1..100 | each { |i| (random integer 1..50) })
histogram $random_data --bins 10
```

#### 🔹Export vers différents formats

**Export vers CSV avec formatage :**

```sh
# Fonction d'export CSV formaté
export def export-csv [data: table, output_file: string, --delimiter(-d): string = ","] {
    let headers = ($data | columns | str join $delimiter)
    let rows = ($data | each { |row|
        $row | transpose key value | get value | str join $delimiter
    })

    let csv_content = ([$headers] | append $rows | str join "\n")
    $csv_content | save $output_file

    print $"Données exportées vers: ($output_file)"
}

# Exemple d'utilisation
let sales_data = [
    {month: "Jan", sales: 1000, profit: 200},
    {month: "Feb", sales: 1200, profit: 250},
    {month: "Mar", sales: 1100, profit: 220}
]

export-csv $sales_data "sales_report.csv"
```

**Export vers JSON structuré :**

```sh
# Fonction d'export JSON avec métadonnées
export def export-json [data: table, output_file: string, --metadata(-m): record] {
    let export_data = {
        metadata: $metadata,
        timestamp: (date now),
        count: ($data | length),
        data: $data
    }

    $export_data | to json | save $output_file
    print $"Données JSON exportées vers: ($output_file)"
}

# Exemple d'utilisation
let analysis_metadata = {
    title: "Analyse des ventes",
    author: "Système d'analyse",
    version: "1.0"
}

export-json $sales_data "sales_analysis.json" --metadata $analysis_metadata
```

**Export vers HTML avec graphiques :**

```sh
# Fonction d'export HTML avec graphiques
export def export-html [data: table, output_file: string, --title(-t): string = "Rapport"] {
    let html_content = $"
<!DOCTYPE html>
<html>
<head>
    <title>($title)</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .chart { margin: 20px 0; }
    </style>
</head>
<body>
    <h1>($title)</h1>
    <p>Généré le: (date now)</p>

    <h2>Données</h2>
    <table>
        <tr>
            ($data | columns | each { |col| $"<th>($col)</th>" } | str join "")
        </tr>
        ($data | each { |row|
            $"<tr>($row | transpose key value | get value | each { |val| $"<td>($val)</td>" } | str join "")</tr>"
        } | str join "")
    </table>
</body>
</html>"

    $html_content | save $output_file
    print $"Rapport HTML exporté vers: ($output_file)"
}

# Exemple d'utilisation
export-html $sales_data "sales_report.html" --title "Rapport des ventes"
```

#### 🔹Manipulation de gros volumes de données

**Traitement par chunks :**

```sh
# Fonction de traitement par chunks
export def process-chunks [data: list, chunk_size: int, processor: closure] {
    let chunks = ($data | window $chunk_size)

    $chunks | each { |chunk|
        $processor $chunk
    }
}

# Exemple de traitement de gros dataset
def process-sales-chunk [chunk: list] {
    $chunk | each { |sale|
        {
            month: $sale.month,
            sales: $sale.sales,
            profit: $sale.profit,
            profit_margin: (($sale.profit / $sale.sales) * 100)
        }
    }
}

# Utilisation avec un gros dataset
let large_sales_data = (1..10000 | each { |i| {
    month: $"Month($i % 12 + 1)",
    sales: (random integer 1000..5000),
    profit: (random integer 100..500)
}})

process-chunks $large_sales_data 1000 { |chunk| process-sales-chunk $chunk }
```

**Filtrage efficace :**

```sh
# Fonction de filtrage avec index
export def filter-indexed [data: table, condition: closure] {
    let indexed_data = ($data | enumerate)

    $indexed_data | where { |item| $condition $item.item } | get item
}

# Exemple d'utilisation
let large_dataset = (1..100000 | each { |i| {
    id: $i,
    value: (random integer 1..1000),
    category: (["A", "B", "C"] | random choice)
}})

# Filtrage efficace
filter-indexed $large_dataset { |item| $item.value > 500 and $item.category == "A" }
```

**Agrégation optimisée :**

```sh
# Fonction d'agrégation optimisée
export def aggregate-optimized [data: table, group_by: string, aggregations: record] {
    let grouped = ($data | group-by $group_by)

    $grouped | transpose key value | each { |group|
        let group_data = $group.value
        let result = { $group.key }

        $aggregations | transpose key value | each { |agg|
            let field = $agg.key
            let operation = $agg.value

            let agg_value = (match $operation {
                "sum" => { $group_data | get $field | reduce -f 0 { |it, acc| $acc + $it } }
                "avg" => { $group_data | get $field | math avg }
                "count" => { $group_data | length }
                "min" => { $group_data | get $field | math min }
                "max" => { $group_data | get $field | math max }
                _ => { 0 }
            })

            $result | upsert $field $agg_value
        }
    }
}

# Exemple d'utilisation
let sales_data = [
    {category: "Electronics", sales: 1000, profit: 200},
    {category: "Electronics", sales: 1500, profit: 300},
    {category: "Clothing", sales: 800, profit: 150},
    {category: "Clothing", sales: 1200, profit: 250}
]

aggregate-optimized $sales_data "category" {
    sales: "sum",
    profit: "sum",
    count: "count"
}
```

**Cache et optimisation :**

```sh
# Fonction de cache simple
export def cached-computation [key: string, computation: closure] {
    let cache_file = $"~/.cache/nushell/($key).json"

    if ($cache_file | path exists) {
        try {
            open $cache_file
        } catch {
            let result = ($computation)
            $result | to json | save $cache_file
            $result
        }
    } else {
        let result = ($computation)
        $result | to json | save $cache_file
        $result
    }
}

# Exemple d'utilisation
cached-computation "expensive_calculation" { |it|
    # Simulation d'un calcul coûteux
    sleep 2sec
    {result: "Calcul terminé", timestamp: (date now)}
}
```

> L'analyse de données avancée avec NuShell permet de traiter efficacement de gros volumes de données tout en gardant une syntaxe claire et lisible.
