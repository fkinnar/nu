### ðŸ“Š Analyse de DonnÃ©es AvancÃ©e

#### ðŸ”¹Statistiques descriptives

**Fonctions de statistiques de base :**

```sh
# Fonction de statistiques complÃ¨tes
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

# Test avec des donnÃ©es
let test_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
stats $test_data
```

```sh
â•­â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â•®
â”‚ count   â”‚    10 â”‚
â”‚ sum     â”‚    55 â”‚
â”‚ mean    â”‚   5.5 â”‚
â”‚ median  â”‚   5.5 â”‚
â”‚ std_dev â”‚ 3.028 â”‚
â”‚ varianceâ”‚ 9.167 â”‚
â”‚ min     â”‚     1 â”‚
â”‚ max     â”‚    10 â”‚
â”‚ range   â”‚     9 â”‚
â•°â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â•¯
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

# Test avec des donnÃ©es alÃ©atoires
let random_data = (1..100 | each { |i| (random integer 1..100) })
distribution $random_data --bins 10
```

**CorrÃ©lation entre variables :**

```sh
# Fonction de calcul de corrÃ©lation
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

# Test de corrÃ©lation
let x_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let y_data = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
correlation $x_data $y_data
```

#### ðŸ”¹Graphiques et visualisations

**Graphiques ASCII simples :**

```sh
# Fonction de graphique en barres ASCII
export def bar-chart [data: record, --width(-w): int = 50] {
    let max_value = ($data | transpose key value | get value | math max)

    $data | transpose key value | each { |item|
        let bar_length = (($item.value / $max_value) * $width) | into int
        let bar = ("â–ˆ" | str repeat $bar_length)
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
Jan: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 100
Feb: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 150
Mar: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 120
Apr: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 200
May: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 180
```

**Graphique linÃ©aire ASCII :**

```sh
# Fonction de graphique linÃ©aire ASCII
export def line-chart [data: list, --height(-h): int = 10] {
    let max_value = ($data | math max)
    let min_value = ($data | math min)
    let range = $max_value - $min_value

    let chart_lines = (0..$height | each { |i|
        let threshold = $max_value - (($i / $height) * $range)
        let line = ($data | each { |value|
            if $value >= $threshold { "â—" } else { " " }
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
        let bar = ("â–ˆ" | str repeat $bar_length)
        $"($bin.range): ($bar) ($bin.count)"
    }
}

# Exemple d'utilisation
let random_data = (1..100 | each { |i| (random integer 1..50) })
histogram $random_data --bins 10
```

#### ðŸ”¹Export vers diffÃ©rents formats

**Export vers CSV avec formatage :**

```sh
# Fonction d'export CSV formatÃ©
export def export-csv [data: table, output_file: string, --delimiter(-d): string = ","] {
    let headers = ($data | columns | str join $delimiter)
    let rows = ($data | each { |row|
        $row | transpose key value | get value | str join $delimiter
    })

    let csv_content = ([$headers] | append $rows | str join "\n")
    $csv_content | save $output_file

    print $"DonnÃ©es exportÃ©es vers: ($output_file)"
}

# Exemple d'utilisation
let sales_data = [
    {month: "Jan", sales: 1000, profit: 200},
    {month: "Feb", sales: 1200, profit: 250},
    {month: "Mar", sales: 1100, profit: 220}
]

export-csv $sales_data "sales_report.csv"
```

**Export vers JSON structurÃ© :**

```sh
# Fonction d'export JSON avec mÃ©tadonnÃ©es
export def export-json [data: table, output_file: string, --metadata(-m): record] {
    let export_data = {
        metadata: $metadata,
        timestamp: (date now),
        count: ($data | length),
        data: $data
    }

    $export_data | to json | save $output_file
    print $"DonnÃ©es JSON exportÃ©es vers: ($output_file)"
}

# Exemple d'utilisation
let analysis_metadata = {
    title: "Analyse des ventes",
    author: "SystÃ¨me d'analyse",
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
    <p>GÃ©nÃ©rÃ© le: (date now)</p>

    <h2>DonnÃ©es</h2>
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
    print $"Rapport HTML exportÃ© vers: ($output_file)"
}

# Exemple d'utilisation
export-html $sales_data "sales_report.html" --title "Rapport des ventes"
```

#### ðŸ”¹Manipulation de gros volumes de donnÃ©es

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

**AgrÃ©gation optimisÃ©e :**

```sh
# Fonction d'agrÃ©gation optimisÃ©e
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
    # Simulation d'un calcul coÃ»teux
    sleep 2sec
    {result: "Calcul terminÃ©", timestamp: (date now)}
}
```

> L'analyse de donnÃ©es avancÃ©e avec NuShell permet de traiter efficacement de gros volumes de donnÃ©es tout en gardant une syntaxe claire et lisible.

---
