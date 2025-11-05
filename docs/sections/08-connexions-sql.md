### 🔗 Connexions SQL

> NuShell intègre un connecteur à  SQLite.

#### 🔧Utilisation de base avec SQLite

```sh
ls | into sqlite sample.db
```

```sh
open sample.db
```

```sh
┌──────┬────────────────┤
│ main │ [table 7 rows] │
└──────┴────────────────┘
```

```sh
open sample.db | get main
```

```sh
┌───┬───────────────────┬──────┬───────┬─────────────────────────────────────┤
│ # │       name        │ type │ size  │              modified               │
├───├───────────────────├──────├───────├─────────────────────────────────────┼
│ 0 │ base.bd           │ file │  8192 │ 2025-10-13 14:24:41.221327700+02:00 │
│ 1 │ config.json       │ file │   133 │ 2025-10-09 11:31:02.033171500+02:00 │
│ 2 │ employees.json    │ file │  4932 │ 2025-10-09 14:43:03.634381700+02:00 │
│ 3 │ notes.txt         │ file │   168 │ 2025-10-09 11:31:33.241767900+02:00 │
│ 4 │ personnes.csv     │ file │    87 │ 2025-10-09 11:30:33.033195200+02:00 │
│ 5 │ utilisateurs.json │ file │  2559 │ 2025-10-09 15:05:51.614985900+02:00 │
│ 6 │ ventes.xlsx       │ file │ 11483 │ 2025-10-09 11:38:17.741472400+02:00 │
└───┴───────────────────┴──────┴───────┴─────────────────────────────────────┘
```

```sh
open sample.db | query db "select name from main where size > 2500"
```

```sh
┌───┬───────────────────┤
│ # │       name        │
├───├───────────────────┼
│ 0 │ base.bd           │
│ 1 │ employees.json    │
│ 2 │ utilisateurs.json │
│ 3 │ ventes.xlsx       │
└───┴───────────────────┘
```

```sh
open sample.db | query db "select name from main where modified > '2025-10-10'"
```

```sh
┌───┬─────────┤
│ # │  name   │
├───├─────────┼
│ 0 │ base.bd │
└───┴─────────┘
```

#### 🔧Création d'une table manuellement dans SQLite

```sh
[ {id: 0, name: 'Fabrice', birthday: ('1974-05-12' | into datetime)} ]
  | into sqlite base.bd --table-name people
```

```sh
open base.bd
```

```sh
┌────────┬───────────────┤
│ people │ [table 1 row] │
└────────┴───────────────┘
```

```sh
open base.bd | get people
```

```sh
┌───┬────┬─────────┬───────────────────────────┤
│ # │ id │  name   │         birthday          │
├───├────├─────────├───────────────────────────┼
│ 0 │  0 │ Fabrice │ 1974-05-12 00:00:00+02:00 │
└───┴────┴─────────┴───────────────────────────┘
```

> NuShell infère automatiquement les type de données. Mais si on veut forcer le type, ``into`` permet d'effectuer le casting.

#### 🔧Requête vers SQL Server

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

Passer ce résultat à  la commande ``lines`` permet de créer une table avec les lignes retournées par ``sqlcmd``.

```sh
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company" | lines

┌───┬──────────────────────────────────────────────────────────────────────────────────┤
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
└───┴──────────────────────────────────────────────────────────────────────────────────┘
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

┌───┬──────────────────────────────────────────────────────────────────────────────────┤
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
└───┴──────────────────────────────────────────────────────────────────────────────────┘
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

┌───┬───────────────────────────────────────┬─────────────────────────────┬─────┤
│ # │                  id                   │        company_name         │ ... │
├───├───────────────────────────────────────├─────────────────────────────├─────┼
│ 0 │ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8  │ SA IRIS                     │ ... │
│ 1 │ 8a718cd0-fa68-477c-86f4-e7734ba5336c  │ IRIS CLEANING SERVICES  SA  │ ... │
│ 2 │ ef976bdb-caf8-40a7-87e9-f857b75d6073  │ SPRL IRIS GREENCARE         │ ... │
│ 3 │ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7  │ BVBA ALCYON DIENSTENCHEQUES │ ... │
│ 4 │ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3  │ BVBA ALCYON                 │ ... │
│ 5 │ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6  │ IRIS TECHNICAL SERVICES     │ ... │
└───┴───────────────────────────────────────┴─────────────────────────────┴─────┘
```
