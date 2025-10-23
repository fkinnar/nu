# 📚 Appendices NuShell

Ce fichier contient des techniques avancées et des détails supplémentaires pour NuShell.

## 🔍 Découverte de commandes

Une fois que vous maîtrisez les bases de NuShell, voici des techniques avancées pour découvrir et rechercher des commandes :

### 🔹Rechercher des commandes par nom

```sh
# Chercher toutes les commandes contenant "transpose"
help commands | where $it.name =~ "transpose"

# Chercher les commandes de filtrage
help commands | where $it.name =~ "filter|where|select"
```

### 🔹Rechercher par description/fonctionnalité

```sh
# Chercher les commandes qui mentionnent "table" dans leur description
help commands | where $it.usage =~ "table"

# Chercher les commandes pour les fichiers
help commands | where $it.usage =~ "file"
```

### 🔹Explorer par catégorie

```sh
# Voir toutes les catégories disponibles
help commands | get category | uniq

# Filtrer par catégorie
help commands | where category == "filters"
help commands | where category == "strings"
help commands | where category == "filesystem"
```

### 🔹Créer un alias de recherche pratique

```sh
alias search-cmd = help commands | where ($it.name =~ $in) or ($it.usage =~ $in)

# Utilisation
"transpose" | search-cmd
"file" | search-cmd
```

### 🔹Recherche combinée (nom + description)

```sh
# Chercher dans le nom ET la description
help commands | where ($it.name =~ "transpose") or ($it.usage =~ "transpose")
```

---

## 🔌 Plugins détaillés

### 🔹Plugins essentiels

#### nu_plugin_polars - Analyse de données avancée

**Installation :**

```sh
cargo install nu_plugin_polars
register ~/.cargo/bin/nu_plugin_polars
```

**Exemples pratiques :**

```sh
# Créer un dataset de test
let sales_data = [
    {product: "Laptop", quantity: 5, price: 1200, date: "2024-01-15"}
    {product: "Mouse", quantity: 20, price: 25, date: "2024-01-16"}
    {product: "Keyboard", quantity: 15, price: 80, date: "2024-01-17"}
    {product: "Monitor", quantity: 8, price: 300, date: "2024-01-18"}
    {product: "Laptop", quantity: 3, price: 1200, date: "2024-01-19"}
]

# Sauvegarder en CSV
$sales_data | to csv | save sales.csv

# Analyser avec Polars
open sales.csv | polars df
```

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

#### nu_plugin_query - Requêtes SQL

**Installation :**

```sh
cargo install nu_plugin_query
register ~/.cargo/bin/nu_plugin_query
```

**Exemples pratiques :**

```sh
# Créer une base de données SQLite
let employees = [
    {id: 1, name: "Alice", department: "IT", salary: 75000}
    {id: 2, name: "Bob", department: "HR", salary: 65000}
    {id: 3, name: "Charlie", department: "IT", salary: 80000}
    {id: 4, name: "Diana", department: "Finance", salary: 70000}
]

$employees | to sqlite employees.db

# Requêtes SQL
open employees.db | query db "SELECT department, AVG(salary) as avg_salary FROM main GROUP BY department"

open employees.db | query db "SELECT * FROM main WHERE salary > 70000 ORDER BY salary DESC"
```

#### nu_plugin_inc - Gestion de versions

**Installation :**

```sh
cargo install nu_plugin_inc
register ~/.cargo/bin/nu_plugin_inc
```

**Exemples pratiques :**

```sh
# Incrémenter une version
inc 1.2.3 --major    # 2.0.0
inc 1.2.3 --minor    # 1.3.0
inc 1.2.3 --patch    # 1.2.4

# Dans un script de déploiement
let current_version = (open Cargo.toml | lines | where $it =~ "version" | parse "version = \"{version}\"" | get version.0)
let new_version = (inc --patch $current_version)
print $"Nouvelle version: ($new_version)"
```

### 🔹Plugins moins connus mais utiles

#### nu_plugin_formats - Formats supplémentaires

**Installation :**

```sh
cargo install nu_plugin_formats
register ~/.cargo/bin/nu_plugin_formats
```

**Exemples :**

```sh
# Support pour TOML
open config.toml | get database.host

# Support pour YAML avancé
open docker-compose.yml | get services.web.ports
```

#### nu_plugin_gstat - Statistiques Git

**Installation :**

```sh
cargo install nu_plugin_gstat
register ~/.cargo/bin/nu_plugin_gstat
```

**Exemples :**

```sh
# Statistiques du dépôt Git
gstat

# Statistiques par auteur
gstat --author
```

### 🔹Dépannage des plugins

#### Problèmes courants

**Plugin non trouvé :**

```sh
# Vérifier l'installation
cargo list | grep nu_plugin

# Vérifier le PATH
which nu_plugin_polars

# Réinstaller si nécessaire
cargo install --force nu_plugin_polars
```

**Plugin non chargé :**

```sh
# Vérifier la configuration
cat ~/.config/nushell/config.nu | grep register

# Recharger la configuration
source ~/.config/nushell/config.nu

# Lister les commandes disponibles
help commands | where category =~ "plugin"
```

**Erreurs de compatibilité :**

```sh
# Vérifier la version de NuShell
version

# Mettre à jour le plugin
cargo install --force nu_plugin_polars

# Vérifier les dépendances
cargo tree -p nu_plugin_polars
```

### 🔹Créer un plugin simple

**Structure d'un plugin minimal :**

```rust
// src/main.rs
use nu_plugin::{serve_plugin, EvaluatedCall, LabeledError, MsgPackSerializer, Plugin};
use nu_protocol::{Signature, Value};

struct MyPlugin;

impl Plugin for MyPlugin {
    fn signature(&self) -> Vec<Signature> {
        vec![Signature::build("my-command")
            .required("input", SyntaxShape::String, "Input string")
            .named("uppercase", SyntaxShape::Boolean, "Convert to uppercase", Some('u'))
        ]
    }

    fn run(&mut self, name: &str, call: &EvaluatedCall, input: &Value) -> Result<Value, LabeledError> {
        match name {
            "my-command" => {
                let input_str: String = call.req(0)?;
                let uppercase = call.get_flag("uppercase")?.unwrap_or(false);
                
                let result = if uppercase {
                    input_str.to_uppercase()
                } else {
                    input_str
                };
                
                Ok(Value::String { val: result, span: call.head })
            }
            _ => Err(LabeledError::new("Unknown command"))
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

**Compilation et installation :**

```sh
# Compiler le plugin
cargo build --release

# Installer
cargo install --path .

# Enregistrer dans NuShell
register ~/.cargo/bin/nu_plugin_myplugin

# Utiliser
my-command "Hello World"
my-command "Hello World" --uppercase
```

### 🔹Bonnes pratiques pour les plugins

1. **Nommage** : Utiliser le préfixe `nu_plugin_`
2. **Documentation** : Inclure des exemples d'usage
3. **Gestion d'erreurs** : Messages d'erreur clairs
4. **Performance** : Optimiser pour les gros datasets
5. **Tests** : Inclure des tests unitaires
6. **Versioning** : Suivre le versioning sémantique
7. **Compatibilité** : Tester avec différentes versions de NuShell

---

## 🚀 Techniques avancées

### 🔹Optimisation des performances

#### Traitement de gros fichiers

```sh
# Utiliser des streams pour les gros fichiers
open large_file.csv | lines | skip 1 | each { |line| $line | split row "," } | take 1000

# Traitement parallèle avec par-each
open files/ | par-each { |file| open $file.name | lines | length }
```

#### Cache et optimisation

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

### 🔹Scripts complexes

#### Gestion d'erreurs avancée

```sh
export def robust-file-processor [file_path: string] {
    try {
        let content = (open $file_path)
        let processed = ($content | lines | each { |line|
            try {
                $line | parse "{name},{age},{city}" | get 0
            } catch {
                {name: "Unknown", age: 0, city: "Unknown"}
            }
        })
        $processed
    } catch {
        error make {msg: $"Impossible de traiter le fichier: ($file_path)"}
    }
}
```

#### Configuration dynamique

```sh
export def load-config [env: string] {
    let config_files = [
        $"config/($env).nu"
        "config/default.nu"
        "config/base.nu"
    ]
    
    $config_files | each { |file|
        if ($file | path exists) {
            source $file
        }
    }
}
```

---

## 📖 Ressources supplémentaires

### 🔹Documentation officielle

- [NuShell Book](https://www.nushell.sh/book/)
- [Command Reference](https://www.nushell.sh/commands/)
- [Plugin Development](https://www.nushell.sh/plugins/)

### 🔹Communauté

- [GitHub Discussions](https://github.com/nushell/nushell/discussions)
- [Discord](https://discord.gg/NtAbbGn)
- [Reddit](https://www.reddit.com/r/Nushell/)

### 🔹Plugins populaires

- [Awesome NuShell](https://github.com/nushell/awesome-nushell)
- [Crates.io - nu_plugin](https://crates.io/search?q=nu_plugin)

---

> Ces appendices couvrent les aspects avancés de NuShell. Pour les bases, consultez le [guide principal](nushell-practical.md).
