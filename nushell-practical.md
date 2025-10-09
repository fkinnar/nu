# NuShell

## Quick tour pratique

En NuShell, *presque* toutes les commandes retournent un tableau structuré. Ce tableau peut alors être manipulé pour en extraire des informations.

> 🌐 <https://www.nushell.sh/>

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

> NuShell prend en charge beaucoup d'autres formats : <https://www.nushell.sh/commands/docs/to.html>.

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

> NuShell supporte tous les types de jointures : <https://www.nushell.sh/commands/docs/join.html>.
