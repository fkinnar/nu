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

> NuShell supporte tous les types de jointures : [https://www.nushell.sh/commands/docs/join.html](https://www.nushell.sh/commands/docs/join.html).

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
