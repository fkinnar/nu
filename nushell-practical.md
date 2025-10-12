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

Certains fichiers JSON formatés **par lignes**, chacunes de leurs lignes sont, elles-mêmes, un JSON valide. De tels fichiers ne peuvent pas être ouverts directement par ```open```.

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
> <https://www.nushell.sh/commands/docs/http_get.html>

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
