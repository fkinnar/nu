### 🔗 Jointures entre des tableaux en mémoire

#### 🔧 Remarque propos des classeurs Excel

Le résultat de la commande ``open`` sur une feuille Excel ne donne pas directement un tableau, il est donc nécessaire de manipuler un peu les données.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients]

┌─────────┬────────────────────────────────────────┤
│         │ ┌───┬───────────┬─────────┬──────────┤ │
│ clients │ │ # │  column0  │ column1 │ column2  │ │
│         │ ├───├───────────├─────────├──────────┼ │
│         │ │ 0 │ id_client │ nom     │ pays     │ │
│         │ │ 1 │      1.00 │ Alice   │ France   │ │
│         │ │ 2 │      2.00 │ Bob     │ Belgique │ │
│         │ │ 3 │      3.00 │ Charlie │ Suisse   │ │
│         │ └───┴───────────┴─────────┴──────────┘ │
└─────────┴────────────────────────────────────────┘
```

Pour obtenir un tableau il faut donc récupérer la valeur pour l'entrée ``clients``.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients

┌───┬───────────┬─────────┬──────────┤
│ # │  column0  │ column1 │ column2  │
├───├───────────├─────────├──────────┼
│ 0 │ id_client │ nom     │ pays     │
│ 1 │      1.00 │ Alice   │ France   │
│ 2 │      2.00 │ Bob     │ Belgique │
│ 3 │      3.00 │ Charlie │ Suisse   │
└───┴───────────┴─────────┴──────────┘
```

On a bien une table, mais les en-têtes de colonnes ne sont pas corrects. Il faut dire à  NuShell que la première ligne est un titre et pas une donnée.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients | headers
┌───┬───────────┬─────────┬──────────┤
│ # │ id_client │   nom   │   pays   │
├───├───────────├─────────├──────────┼
│ 0 │      1.00 │ Alice   │ France   │
│ 1 │      2.00 │ Bob     │ Belgique │
│ 2 │      3.00 │ Charlie │ Suisse   │
└───┴───────────┴─────────┴──────────┘
```

#### 🔧 Jointure entre des tableaux

```sh
let classeur = open ventes.xlsx
let clients = $classeur | get clients | headers
let commandes = $classeur | get commandes | headers
$commandes | join $clients id_client
```

```sh
┌───┬───────────┬─────────┬─────────┬─────────┬──────────┤
│ # │ id_client │ produit │ montant │   nom   │   pays   │
├───├───────────├─────────├─────────├─────────├──────────┼
│ 0 │      1.00 │ Livre   │   20.50 │ Alice   │ France   │
│ 1 │      1.00 │ Clavier │   45.00 │ Alice   │ France   │
│ 2 │      2.00 │ Stylo   │    5.00 │ Bob     │ Belgique │
│ 3 │      3.00 │ Souris  │   25.00 │ Charlie │ Suisse   │
└───┴───────────┴─────────┴─────────┴─────────┴──────────┘
```

#### 🔧 Noms de colonnes différents

Quand les noms des colonnes de gauche et de droite ne sont pas les mêmes, la commande devient:

```sh
let users = open users.json
let persons = open persons.json

let data = $users | join $persons Id UserId
```

> NuShell supporte tous les types de jointures : [https://www.nushell.sh/commands/docs/join.html](https://www.nushell.sh/commands/docs/join.html). (--inner, --left, --right, --outer)
