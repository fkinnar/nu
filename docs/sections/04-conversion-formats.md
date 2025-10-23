### ðŸ”„ Conversion entre formats

#### ðŸ”¹Sauver un fichier CSV

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

#### ðŸ”¹Sauver un fichier JSON

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

#### ðŸ”¹Sauver un fichier texte

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

#### ðŸ”¹Convertir un fichier

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
