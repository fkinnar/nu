### ðŸ”— Jointures entre des tableaux en mÃ©moire

#### ðŸ”¹Remarque propos des classeurs Excel

Le rÃ©sultat de la commande ``open`` sur une feuille Excel ne donne pas directement un tableau, il est donc nÃ©cessaire de manipuler un peu les donnÃ©es.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients]

â•­â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚         â”‚ â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•® â”‚
â”‚ clients â”‚ â”‚ # â”‚  column0  â”‚ column1 â”‚ column2  â”‚ â”‚
â”‚         â”‚ â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â”‚
â”‚         â”‚ â”‚ 0 â”‚ id_client â”‚ nom     â”‚ pays     â”‚ â”‚
â”‚         â”‚ â”‚ 1 â”‚      1.00 â”‚ Alice   â”‚ France   â”‚ â”‚
â”‚         â”‚ â”‚ 2 â”‚      2.00 â”‚ Bob     â”‚ Belgique â”‚ â”‚
â”‚         â”‚ â”‚ 3 â”‚      3.00 â”‚ Charlie â”‚ Suisse   â”‚ â”‚
â”‚         â”‚ â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯ â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

Pour obtenir un tableau il faut donc rÃ©cuper la valeur pour l'entrÃ©e ``clients``.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients

â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚  column0  â”‚ column1 â”‚ column2  â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ id_client â”‚ nom     â”‚ pays     â”‚
â”‚ 1 â”‚      1.00 â”‚ Alice   â”‚ France   â”‚
â”‚ 2 â”‚      2.00 â”‚ Bob     â”‚ Belgique â”‚
â”‚ 3 â”‚      3.00 â”‚ Charlie â”‚ Suisse   â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

On a bien une table, mais les en-tÃªtes de colonnes ne sont pas corrects. Il faut dire Ã  NuShell que la premiÃ¨re ligne est un titre et pas une donnÃ©e.

```sh
open --raw ventes.xlsx | from xlsx --sheets [clients] | get clients | headers
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚ id_client â”‚   nom   â”‚   pays   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚      1.00 â”‚ Alice   â”‚ France   â”‚
â”‚ 1 â”‚      2.00 â”‚ Bob     â”‚ Belgique â”‚
â”‚ 2 â”‚      3.00 â”‚ Charlie â”‚ Suisse   â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Jointure entre des tableaux

```sh
let classeur = open ventes.xlsx
let clients = $classeur | get clients | headers
let commandes = $classeur | get commandes | headers
$commandes | join $clients id_client
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚ id_client â”‚ produit â”‚ montant â”‚   nom   â”‚   pays   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚      1.00 â”‚ Livre   â”‚   20.50 â”‚ Alice   â”‚ France   â”‚
â”‚ 1 â”‚      1.00 â”‚ Clavier â”‚   45.00 â”‚ Alice   â”‚ France   â”‚
â”‚ 2 â”‚      2.00 â”‚ Stylo   â”‚    5.00 â”‚ Bob     â”‚ Belgique â”‚
â”‚ 3 â”‚      3.00 â”‚ Souris  â”‚   25.00 â”‚ Charlie â”‚ Suisse   â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹Noms de colonnes diffÃ©rents

Quand les noms des colonnes de gauche et de droite ne sont pas les mÃªmes, la commande devient:

```sh
let users = open users.json
let persons = open persons.json

let data = $users | join $persons Id UserId
```

> NuShell supporte tous les types de jointures : [https://www.nushell.sh/commands/docs/join.html](https://www.nushell.sh/commands/docs/join.html). (--inner, --left, --right, --outer)
