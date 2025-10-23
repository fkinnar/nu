### ðŸ”— Connexions SQL

> NuShell intÃ¨gre un connecteur Ã  SQLite.

#### ðŸ”¹Utilisation de base avec SQLite

```sh
ls | into sqlite sample.db
```

```sh
open sample.db
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ main â”‚ [table 7 rows] â”‚
â•°â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
open sample.db | get main
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚       name        â”‚ type â”‚ size  â”‚              modified               â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ base.bd           â”‚ file â”‚  8192 â”‚ 2025-10-13 14:24:41.221327700+02:00 â”‚
â”‚ 1 â”‚ config.json       â”‚ file â”‚   133 â”‚ 2025-10-09 11:31:02.033171500+02:00 â”‚
â”‚ 2 â”‚ employees.json    â”‚ file â”‚  4932 â”‚ 2025-10-09 14:43:03.634381700+02:00 â”‚
â”‚ 3 â”‚ notes.txt         â”‚ file â”‚   168 â”‚ 2025-10-09 11:31:33.241767900+02:00 â”‚
â”‚ 4 â”‚ personnes.csv     â”‚ file â”‚    87 â”‚ 2025-10-09 11:30:33.033195200+02:00 â”‚
â”‚ 5 â”‚ utilisateurs.json â”‚ file â”‚  2559 â”‚ 2025-10-09 15:05:51.614985900+02:00 â”‚
â”‚ 6 â”‚ ventes.xlsx       â”‚ file â”‚ 11483 â”‚ 2025-10-09 11:38:17.741472400+02:00 â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
open sample.db | query db "select name from main where size > 2500"
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚       name        â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ base.bd           â”‚
â”‚ 1 â”‚ employees.json    â”‚
â”‚ 2 â”‚ utilisateurs.json â”‚
â”‚ 3 â”‚ ventes.xlsx       â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
open sample.db | query db "select name from main where modified > '2025-10-10'"
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚  name   â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ base.bd â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

#### ðŸ”¹CrÃ©ation d'une table manuellement dans SQLite

```sh
[ {id: 0, name: 'Fabrice', birthday: ('1974-05-12' | into datetime)} ]
  | into sqlite base.bd --table-name people
```

```sh
open base.bd
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ people â”‚ [table 1 row] â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

```sh
open base.bd | get people
```

```sh
â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ # â”‚ id â”‚  name   â”‚         birthday          â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚  0 â”‚ Fabrice â”‚ 1974-05-12 00:00:00+02:00 â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

> NuShell infÃ¨re automatiquement les type de donnÃ©es. Mais si on veut forcer le type, ``into`` permet d'effectuer le casting.

#### ðŸ”¹RequÃªte vers SQL Server

> Malheureusement, NuShell n'intÃ¨gre pas de connexion directe avec SQL Server. Cependant, il est trÃ¨s facile d'exÃ©cuter une requÃªte via ``sqlcmd`` (par exemple).

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

DÃ©composons cette commande. Le rÃ©sultat de ``sqlcmd`` n'est Ã©videmment pas une table NuShell, il faut donc le reformater.

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

Passer ce rÃ©sultat Ã  la commande ``lines`` permet de crÃ©er une table avec les lignes retournÃ©es par ``sqlcmd``.

```sh
sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company" | lines

â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ 0 â”‚ id,company_name,company_number,company_country,company_code,company_group        â”‚
â”‚ 1 â”‚ --,------------,--------------,---------------,------------,-------------        â”‚
â”‚ 2 â”‚ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND           â”‚
â”‚ 3 â”‚ 8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES                      â”‚
â”‚   â”‚ SA,453520233,Belgium,ICS,IFS                                                     â”‚
â”‚ 4 â”‚ ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS                                   â”‚
â”‚   â”‚ GREENCARE,416912532,Belgium,IGC,IGC                                              â”‚
â”‚ 5 â”‚ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON                                â”‚
â”‚   â”‚ DIENSTENCHEQUES,877388259,Belgium,ADC,ADC                                        â”‚
â”‚ 6 â”‚ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC      â”‚
â”‚ 7 â”‚ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL                              â”‚
â”‚   â”‚ SERVICES,843651263,Belgium,ITS,ITS                                               â”‚
â”‚ 8 â”‚                                                                                  â”‚
â”‚ 9 â”‚ (6 rows affected)                                                                â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

La commande ``where`` permet de ne garder que les lignes de donnÃ©es.

```sh
(
  sqlcmd -S 2019-SQLTEST -d AgrDev -b -W -s "," -k 1 -Q "select * from iris_geo_company"
  | lines
  | where {
    |it| not ($it | str starts-with "-") and not ($it | str starts-with "(") and not ($it | is-empty)
  }
)

â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ 0 â”‚ id,company_name,company_number,company_country,company_code,company_group        â”‚
â”‚ 1 â”‚ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8,SA IRIS,453520431,Belgium,IRS,IND           â”‚
â”‚ 2 â”‚ 8a718cd0-fa68-477c-86f4-e7734ba5336c,IRIS CLEANING SERVICES                      â”‚
â”‚   â”‚ SA,453520233,Belgium,ICS,IFS                                                     â”‚
â”‚ 3 â”‚ ef976bdb-caf8-40a7-87e9-f857b75d6073,SPRL IRIS                                   â”‚
â”‚   â”‚ GREENCARE,416912532,Belgium,IGC,IGC                                              â”‚
â”‚ 4 â”‚ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7 ,BVBA ALCYON                                â”‚
â”‚   â”‚ DIENSTENCHEQUES,877388259,Belgium,ADC,ADC                                        â”‚
â”‚ 5 â”‚ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3 ,BVBA ALCYON,446955214,Belgium,ALC,ALC      â”‚
â”‚ 6 â”‚ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6,IRIS TECHNICAL                              â”‚
â”‚   â”‚ SERVICES,843651263,Belgium,ITS,ITS                                               â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â•¯
```

L'appel a ``str join`` permet de recoller les lignes que ``sqlcmd`` a coupÃ© en deux.

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

Enfin, on a maintenant une structre CSV valide, il suffit donc de l'utiliser pour crÃ©er la table finale.

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

â•­â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â•®
â”‚ # â”‚                  id                   â”‚        company_name         â”‚ ... â”‚
â”œâ”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ 0 â”‚ 62c927fd-c60c-4dbe-948a-cd621ea2f6a8  â”‚ SA IRIS                     â”‚ ... â”‚
â”‚ 1 â”‚ 8a718cd0-fa68-477c-86f4-e7734ba5336c  â”‚ IRIS CLEANING SERVICES  SA  â”‚ ... â”‚
â”‚ 2 â”‚ ef976bdb-caf8-40a7-87e9-f857b75d6073  â”‚ SPRL IRIS GREENCARE         â”‚ ... â”‚
â”‚ 3 â”‚ a2cad8f2-ba5f-4144-9a94-90a0ee0f39c7  â”‚ BVBA ALCYON DIENSTENCHEQUES â”‚ ... â”‚
â”‚ 4 â”‚ ad424ebe-e0d8-4ada-b03d-6ab5c93166d3  â”‚ BVBA ALCYON                 â”‚ ... â”‚
â”‚ 5 â”‚ 7738d5fa-91fe-4fbc-81a1-cec62d3798d6  â”‚ IRIS TECHNICAL SERVICES     â”‚ ... â”‚
â•°â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â•¯
```
